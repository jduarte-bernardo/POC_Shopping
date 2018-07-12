/******************************************************************************************************
Author  	: Wellington Rodrigues
Date    	: 16/01/2018
Purpose 	: Api Rest para buscar informações do Cordenador para a aplicação de promoção
*******************************************************************************************************/
@RestResource(urlMapping='/Estorno/*')
global with sharing class EstornoManager {

    @HttpGet
    global static ResponseWrapper getEstorno(){

        RestRequest req = RestContext.request;

          String IdCliente = req.params.get('IdCliente');
          String IdPromocao = req.params.get('IdPromocao');

          List<TW1_Brindes_da_Promocao__c> brindesPromocao = [Select Id,TW1_Brinde__c From TW1_Brindes_da_Promocao__c Where TW1_Promocao__c=:IdPromocao ];

            Set<string> brindesIds = new Set<string>();
        	Map<Id,String> FotoBrinde = new Map<Id,String>();
        	
            for(TW1_Brindes_da_Promocao__c item :brindesPromocao){
                brindesIds.add(item.TW1_Brinde__c);
             }
          
          List<TW1_Brinde__c> listabrindes = [Select Id,Name,TW1_Foto__c,Tipo__c,Valor__c From TW1_Brinde__c Where Id In:brindesIds];
		  Map<Id,TW1_Brinde__c> brindes = new Map<Id,TW1_Brinde__c>(listabrindes);
        
        for(TW1_Brinde__c Item:listabrindes)
        {
              FotoBrinde.put(Item.Id, GetBase64(Item.TW1_Foto__c));
        }
        
          ResponseWrapper responseWrapper = new ResponseWrapper();
          responseWrapper.listbrinde = new List<Brinde>();
          responseWrapper.listbrindeEstornados = new List<BrindeEstornados>();

          for(TW1_Brindes_da_Promocao__c item :brindesPromocao)
          {
                TW1_Brinde__c brindeSalesfoce = brindes.get(item.TW1_Brinde__c);

                Brinde brinde = new Brinde();
                brinde.IdBrinde = brindeSalesfoce.Id;
                brinde.TW1_BrindeName = brindeSalesfoce.Name;
                brinde.TW1_BrindeFoto = FotoBrinde.get(brindeSalesfoce.Id);
                brinde.Tipo = brindeSalesfoce.Tipo__c;
                brinde.Valor = brindeSalesfoce.Valor__c;

                responseWrapper.listbrinde.add(brinde);
          }
        
        Brinde brindeDinheiro = new Brinde();
                brindeDinheiro.IdBrinde = 'Dinheiro';
                brindeDinheiro.TW1_BrindeName = 'Dinheiro';
		responseWrapper.listbrinde.add(brindeDinheiro);

        // Buscando Brindes estornados
        List<TW1_Estorno_Brindes__c> BrindesEstornados = [Select Id,Name,TW1_Stand__r.Name,TW1_Brinde_Retirado__c,TW1_Brinde_devolvido__c,TW1_Data_de_Extorno__c,TW1_Operador__r.Name From TW1_Estorno_Brindes__c Where TW1_Cliente__c=:IdCliente And TW1_Parametros_da_Promocao__c=:IdPromocao];
       
		System.debug('-----------------------'+ BrindesEstornados );
       For(TW1_Estorno_Brindes__c Item :BrindesEstornados){

           BrindeEstornados estornados = new BrindeEstornados(); 
           
           if(Item.TW1_Brinde_Retirado__c != null){
               System.debug('-----------Entro IF------------'+ BrindesEstornados );
             estornados.TW1_BrindeRetirado = FotoBrinde.get(Item.TW1_Brinde_Retirado__c);
           }else{
               System.debug('--------Entro else---------------');
               estornados.TW1_BrindeRetirado = 'Devolução';
           }
           	 estornados.TW1_BrindeDevolvido = FotoBrinde.get(Item.TW1_Brinde_devolvido__c);
             estornados.Data_Estorno = Item.TW1_Data_de_Extorno__c;
             estornados.Stand = Item.TW1_Stand__r.Name;
             estornados.Operador = Item.TW1_Operador__r.Name;

            responseWrapper.listbrindeEstornados.add(estornados);
       }

          return responseWrapper;

    }

    @HttpPost
    global static String EstornoCliente(String BrindeDevolvido, String BrindeRetirado, String IdCliente,String IdOperador,String IdPromocao){
        
        try{
        TW1_Terminal__c Terminal = [Select Id,TW1_Stand__r.Id From TW1_Terminal__c where TW1_Operador__c=:IdOperador Limit 1];
		TW1_Caixa__c caixa = [Select Id From TW1_Caixa__c Where TW1_Operador__c=:IdOperador Order By TW1_Data_de_Abertura__c Desc Limit 1];
		TW1_Brinde__c brinde = [Select Id,Name,TW1_Foto__c,Tipo__c,Valor__c From TW1_Brinde__c Where Id=:BrindeDevolvido limit 1];
        TW1_Estoque__c listOrigemestoque = [Select Id,Name,TW1_Quantidade__c,TW1_Brinde__c From TW1_Estoque__c Where TW1_Brinde__c=:brinde.Id And TW1_Tipo__c='Estoque Stand' And TW1_Stand__c=:Terminal.TW1_Stand__r.Id limit 1];
        TW1_Parametros_Promocao__c paramentrosPromocao = [Select Id,Tw1_CobrarBrinde__c From TW1_Parametros_Promocao__c where Id=:IdPromocao Limit 1];
          
            
        TW1_Estorno_Brindes__c estorno = new TW1_Estorno_Brindes__c();
            
        if(BrindeRetirado == 'Dinheiro'){
            
            If(paramentrosPromocao.Tw1_CobrarBrinde__c == True && brinde.Tipo__c != 'Voucher'){

                      TW1_Extrato__c extrato = new TW1_Extrato__c();
                                            extrato.TW1_Caixa__c = caixa.Id;
                                            extrato.TW1_Data__c = DateTime.now();
                                            extrato.TW1_Tipo__c = 'ValorEstorno';
                                            extrato.TW1_Valor__c =  - brinde.Valor__c;
                
                	 TW1_Estoque__c estoque = new TW1_Estoque__c();
                                            estoque.Id = listOrigemestoque.Id;
                                            estoque.TW1_Quantidade__c = listOrigemestoque.TW1_Quantidade__c + 1;
                
                    estorno.TW1_Brinde_devolvido__c = BrindeDevolvido;
                    estorno.TW1_Stand__c = Terminal.TW1_Stand__r.Id;
                    estorno.TW1_Data_de_Extorno__c = DateTime.now().date();
                    estorno.TW1_Operador__c = IdOperador;
                    estorno.TW1_Cliente__c = IdCliente;
                    estorno.TW1_Parametros_da_Promocao__c = IdPromocao;
                   
                 	  insert estorno;
                      insert extrato;
                	  update estoque;   
                Return 'Estorno feito com sucesso';
            }
            else{
                				TW1_Estoque__c estoque = new TW1_Estoque__c();
                                            estoque.Id = listOrigemestoque.Id;
                                            estoque.TW1_Quantidade__c = listOrigemestoque.TW1_Quantidade__c + 1;
                				update estoque;   
                
                estorno.TW1_Brinde_devolvido__c = BrindeDevolvido;
                estorno.TW1_Stand__c = Terminal.TW1_Stand__r.Id;
                estorno.TW1_Data_de_Extorno__c = DateTime.now().date();
                estorno.TW1_Operador__c = IdOperador;
                estorno.TW1_Cliente__c = IdCliente;
                estorno.TW1_Parametros_da_Promocao__c = IdPromocao;
                insert estorno;
                
                Return 'Estorno feito com sucesso';
            }            
            
                
            }else{
                estorno.TW1_Brinde_Retirado__c = BrindeRetirado;
                estorno.TW1_Brinde_devolvido__c = BrindeDevolvido;
                estorno.TW1_Stand__c = Terminal.TW1_Stand__r.Id;
                estorno.TW1_Data_de_Extorno__c = DateTime.now().date();
                estorno.TW1_Operador__c = IdOperador;
                estorno.TW1_Cliente__c = IdCliente;
                estorno.TW1_Parametros_da_Promocao__c = IdPromocao;
                
                
                TW1_Estoque__c estoque = new TW1_Estoque__c();
                estoque.Id = listOrigemestoque.Id;
                estoque.TW1_Quantidade__c = listOrigemestoque.TW1_Quantidade__c + 1;
                
                TW1_Brinde__c brinde2 = [Select Id,Name,TW1_Foto__c,Tipo__c,Valor__c From TW1_Brinde__c Where Id=:BrindeRetirado limit 1];
                TW1_Estoque__c listOrigemestoque2 = [Select Id,Name,TW1_Quantidade__c,TW1_Brinde__c From TW1_Estoque__c Where TW1_Brinde__c=:brinde2.Id And TW1_Tipo__c='Estoque Stand' And TW1_Stand__c=:Terminal.TW1_Stand__r.Id limit 1];
                
                TW1_Estoque__c estoque2 = new TW1_Estoque__c();
                estoque2.Id = listOrigemestoque2.Id;
                estoque2.TW1_Quantidade__c = listOrigemestoque2.TW1_Quantidade__c - 1;
                
                
                insert estorno;
                insert estoque2;                
                
                Return 'Estorno feito com sucesso';
          } 
       }
                catch(Exception e){
                    return 'Erro ao efetuar o estorno, tente novamente';
       			}
    }




      global class ResponseWrapper
    {
        public List<Brinde> listbrinde;
        public List<BrindeEstornados> listbrindeEstornados;
    }  

     global class Brinde 
    {
        public String IdBrinde;
        public String IdCliente;
        public String IdPromocao;
        public String TW1_BrindeName;
        public String TW1_BrindeFoto;
        public String Tipo;
        public String Quantidade;
        public Decimal Valor;
    }

     global class BrindeEstornados 
    {
        public String TW1_BrindeDevolvido;
        public String TW1_BrindeRetirado;
        public Date Data_Estorno;
        public String Stand;
        public String Operador;
    }
    
     Private static string GetBase64(string foto){

        String strBase64 = '';
		
         if(foto != null){
        String bookimg = foto.substringBetween('<img', 'img>');
         
        String imgsrc = bookimg.substringBetween('src="', '"');
        imgsrc = imgsrc.replace('amp;', '');
        PageReference page = new PageReference(imgsrc);
        Blob imgblob;
         if(page.getContent() != null){
             imgblob = page.getContent();}
         else{
             PageReference pagee = new PageReference(imgsrc); 
             imgblob = pagee.getContent();
         }
            
        strBase64  = 'data:image/jpeg;base64,' + EncodingUtil.base64Encode(imgblob);
         }
        return strBase64;

    }


}