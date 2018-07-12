/******************************************************************************************************
Author  	: Leonardo Façanha
Date    	: 05/01/2017
Purpose 	: Api Rest para buscar informações do fluxo de Caixa para a aplicação de promoção
*******************************************************************************************************/
@RestResource(urlMapping='/TrocarBrinde/*')
global with sharing class TrocarBrindeManager {

    @HttpGet
    global static ResponseWrapper getInfBrindes(){

          RestRequest req = RestContext.request;

          String IdCliente = req.params.get('IdCliente');
          String IdPromocao = req.params.get('IdPromocao');

          List<TW1_Brindes_da_Promocao__c> brindesPromocao = [Select Id,TW1_Brinde__c From TW1_Brindes_da_Promocao__c Where TW1_Promocao__c=:IdPromocao ];
          List<TW1_Brindes_Entregues__c> brindesEntregues = [Select Id,Quantidade__c,TW1_Brinde__c,Data_Entrega__c,Tipo__c,Valor__c from TW1_Brindes_Entregues__c Where Parametros_da_Promocao__c=:IdPromocao And TW1_Cliente__c=:IdCliente];        
        
           Set<string> brindesIds = new Set<string>();
        
            for(TW1_Brindes_da_Promocao__c item :brindesPromocao){
                brindesIds.add(item.TW1_Brinde__c);
             }
          
          List<TW1_Brinde__c> listabrindes = [Select Id,Name,TW1_Foto__c,Tipo__c,Valor__c From TW1_Brinde__c Where Id In:brindesIds];
		  Map<Id,TW1_Brinde__c> brindes = new Map<Id,TW1_Brinde__c>(listabrindes);
        
          ResponseWrapper responseWrapper = new ResponseWrapper();
          responseWrapper.listbrinde = new List<Brinde>();
          responseWrapper.listBrindesTrocados = new List<BrindeTrocados>();

          for(TW1_Brindes_da_Promocao__c item :brindesPromocao)
          {
                TW1_Brinde__c brindeSalesfoce = brindes.get(item.TW1_Brinde__c);

                Brinde brinde = new Brinde();
              	brinde.IdBrinde = brindeSalesfoce.Id;
                brinde.TW1_BrindeName = brindeSalesfoce.Name;
                brinde.TW1_BrindeFoto = GetBase64(brindeSalesfoce.TW1_Foto__c);
                brinde.Tipo = brindeSalesfoce.Tipo__c;
                brinde.Valor = brindeSalesfoce.Valor__c;
              	brinde.Quantidade = 0;

                responseWrapper.listbrinde.add(brinde);
          }

          for(TW1_Brindes_Entregues__c item :brindesEntregues)
          {
                TW1_Brinde__c brindeSalesfoce = brindes.get(item.TW1_Brinde__c);

                BrindeTrocados brindeTrocados = new BrindeTrocados();

                brindeTrocados.TW1_BrindeName = brindeSalesfoce.Name;
                brindeTrocados.TW1_BrindeFoto = GetBase64(brindeSalesfoce.TW1_Foto__c);
                brindeTrocados.Valor = item.Valor__c;
                brindeTrocados.Quantidade = item.Quantidade__c.intValue();
                brindeTrocados.Data_Entrega = item.Data_Entrega__c;

                responseWrapper.listBrindesTrocados.add(brindeTrocados);
          }

          return responseWrapper;

    }

    @HttpPost
    global static string TrocaBrinde(RequestWrapper requestWrapper){
         Savepoint sp = Database.setSavepoint();
        
        try{
            
            TW1_Terminal__c Terminal = [Select Id,TW1_Stand__r.Id From TW1_Terminal__c where TW1_Operador__c=:requestWrapper.IdOperador Limit 1];
            List<TW1_Estoque__c> listOrigemestoque = [Select Id,Name,TW1_Quantidade__c,TW1_Brinde__c From TW1_Estoque__c Where TW1_Tipo__c='Estoque Stand' And TW1_Stand__c=:Terminal.TW1_Stand__r.Id And TW1_Shopping__c=:requestWrapper.IdShopping];
            TW1_Parametros_Promocao__c paramentrosPromocao = [Select Id,Tw1_CobrarBrinde__c From TW1_Parametros_Promocao__c where Id=:requestWrapper.IdPromocao Limit 1];
            List<TW1_Brindes_Entregues__c> brindes = MapBrinde(requestWrapper.listbrinde,requestWrapper.IdPromocao,requestWrapper.IdShopping);
            TW1_Caixa__c caixa = [Select Id From TW1_Caixa__c Where TW1_Operador__c=:requestWrapper.IdOperador Order By TW1_Data_de_Abertura__c Desc Limit 1];
            
            List<TW1_Estoque__c> listEstoque = new List<TW1_Estoque__c>();
            List<TW1_Extrato__c> listExtrato = new List<TW1_Extrato__c>();

            For(TW1_Brindes_Entregues__c brinde :brindes)
                {
                    Boolean BrindeEstoque = False;

                    For(TW1_Estoque__c itemEstoque :listOrigemestoque)
                        {
                            If(itemEstoque.TW1_Brinde__c == brinde.TW1_Brinde__c){
                                If(itemEstoque.TW1_Quantidade__c >= brinde.Quantidade__c){

                                     TW1_Estoque__c estoque = new TW1_Estoque__c();
                                            estoque.Id = itemEstoque.Id;
                                            estoque.TW1_Quantidade__c = itemEstoque.TW1_Quantidade__c - brinde.Quantidade__c;
                                            listEstoque.add(estoque);

                                       If(paramentrosPromocao.Tw1_CobrarBrinde__c == True && brinde.Tipo__c != 'Voucher'){

                                           TW1_Extrato__c extrato = new TW1_Extrato__c();
                                            extrato.TW1_Caixa__c = caixa.Id;
                                            extrato.TW1_Data__c = DateTime.now();
                                            extrato.TW1_Tipo__c = 'ValorBrinde';
                                            extrato.TW1_Valor__c = brinde.Quantidade__c * brinde.Valor__c;
                                            listExtrato.add(extrato);
                                       }
                                }
                                else{
                                    return 'O estoque de brindes neste stand não é suficiente para efetuar essa troca';
                                }
                                 BrindeEstoque = True;
                            }
                        }

                        If(BrindeEstoque == False)
                        return 'Não existe estoque para este brinde';
                }

            	update listEstoque;
                insert brindes;
                If(listExtrato.size() >=1)
                insert listExtrato;

            }catch (Exception ce) {
                    Database.rollback(sp);
                    return 'Erro na operacao';
            }  

             return 'Troca feita com sucesso';
    }

    global class ResponseWrapper
    {
        public List<Brinde> listbrinde;
        Public List<BrindeTrocados> listBrindesTrocados;
    }  

    global class RequestWrapper
    {
        public List<Brinde> listbrinde;
        Public String IdPromocao;
        Public String IdShopping;
        Public String IdOperador;
    } 


    global class BrindeTrocados 
    {
        public Integer Quantidade;
        public string TW1_BrindeName;
        public string TW1_BrindeFoto;
        public Date Data_Entrega;
        public Decimal Valor;
    }

    global class Brinde 
    {
        Public String IdBrinde;
        Public String IdCliente;
        Public String IdPromocao;
        public string TW1_BrindeName;
        public string TW1_BrindeFoto;
        public string Tipo;
        public Integer Quantidade;
        public Decimal Valor;
    }

    Private static string GetBase64(string foto){

        String strBase64 = '';
        if(foto != null){
        String bookimg = foto.substringBetween('<img', 'img>');
        String imgsrc = bookimg.substringBetween('src="', '"');
        imgsrc = imgsrc.replace('amp;', '');
        PageReference page = new PageReference(imgsrc);
        Blob imgblob = page.getContent();
        strBase64  = 'data:image/jpeg;base64,' + EncodingUtil.base64Encode(imgblob);
        }

        return strBase64;

    }

    Private static List<TW1_Brindes_Entregues__c> MapBrinde(List<Brinde> listBrindes,String IdPromocao, string IdShopping){
 
        List<TW1_Brindes_Entregues__c> listBrindeSalesforce = new List<TW1_Brindes_Entregues__c>();

        For(Brinde item :listBrindes){

            TW1_Brindes_Entregues__c brinde = new TW1_Brindes_Entregues__c();

            brinde.TW1_Brinde__c = item.IdBrinde;
            brinde.Quantidade__c = Decimal.valueOf(item.Quantidade);
            brinde.Data_Entrega__c = DateTime.now().date();
            brinde.Tipo__c = item.Tipo;
            brinde.Valor__c = item.Valor;
            brinde.Parametros_da_Promocao__c = IdPromocao;
            brinde.TW1_Cliente__c = item.IdCliente;
            brinde.TW1_Shopping_Lookup__c = IdShopping;

            listBrindeSalesforce.add(brinde);
        }
    
        return listBrindeSalesforce;



    }

}