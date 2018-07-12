/******************************************************************************************************
Author  	: Wellington N. Rodrigues
Date    	: 22/01/2018
Purpose 	: Api Rest para buscar informações do Reimpressão Cupon para a aplicação de promoção
*******************************************************************************************************/
@RestResource(urlMapping='/ReimpressaoCupon/*')
global with sharing class ReimpressaoManager {
    
    @HttpGet
    global static ResponseWrapper getReimpressaoCupon(){

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        ResponseWrapper rw = new ResponseWrapper();
        
        String accountId = req.params.get('IdCliente');
        String ShoppingId = req.params.get('IdShopping');
        date vaData = DateTime.now().date();
        
        try{
            list<TW1_Cupom__c> listcupom = [SELECT 
                                            Id, 
                                            Name,
                                            TW1_Nome_do_Cliente__r.Name,
                                            TW1_Operador__r.Name,
                                            TW1_Data__c,
                                            TW1_Bairro__c,
                                            TW1_Celular__c,
                                            TW1_CEP__c,
                                            TW1_Certificado_Autenticao_Promocao__c,
                                            TW1_Cidade__c,
                                            TW1_Complemento__c,
                                            TW1_CPF__c,
                                            TW1_Data_de_Nascimento__c,
                                            TW1_Email__c,
                                            TW1_Parametro_Promocao__c,
                                            Numero__c,
                                            TW1_Pergunta__c,
                                            TW1_RG__c,
                                            TW1_Rua__c,
                                            Sexo__c,
                                            TW1_Telefone__c,
                                            TW1_Nome_da_Loja__c,
                                            TW1_Nome_Lojista__c,
                                            TW1_UF__c,
                                            TW1_Data_Reimpressao__c,
                                            TW1_Gerou_Reimpressao__c
                                        FROM 
                                        	TW1_Cupom__c 
                                        WHERE 
                                        	TW1_Nome_do_Cliente__c =:accountId
                                       ];


        TW1_Parametros_Promocao__c Promocao = [Select Id,Name,TW1_Cert_de_Aut__c,TW1_Pergunta__c From TW1_Parametros_Promocao__c Where TW1_Shopping__c=:ShoppingId And TW1_Data_Fim__c >=:vaData Limit 1];
        TW1_Shopping__c shoppingCorrente = [Select Id,Name From TW1_Shopping__c Where Id=:ShoppingId Limit 1];
	     

         List<Cupom> listcupomSalesforce = new List<Cupom>();

       For(TW1_Cupom__c cup : listcupom)
       {

        Cupom cupom = new Cupom();
			DateTime dataCup = Cup.TW1_Data__c;  
                
           cupom.Id = Cup.Id;
           cupom.TW1_DataCupom = dataCup.format('dd/MM/yyyy HH:mm:ss');
           cupom.TW1_Data_de_Nascimento = string.valueOf(Cup.TW1_Data_de_Nascimento__c.day()) + '/' + string.valueOf(Cup.TW1_Data_de_Nascimento__c.month()) + '/' + string.valueOf(Cup.TW1_Data_de_Nascimento__c.year());cupom.Nome_Lojista = cup.TW1_Nome_Lojista__c;cupom.Nome_da_Loja = cup.TW1_Nome_da_Loja__c;cupom.TW1_Nome_do_Cliente = Cup.TW1_Nome_do_Cliente__r.Name;cupom.TW1_Bairro =  Cup.TW1_Bairro__c;cupom.TW1_Celular = String.valueOf(Cup.TW1_Celular__c);cupom.TW1_CEP =  String.valueOf(Cup.TW1_CEP__c);cupom.TW1_Cidade =  Cup.TW1_Cidade__c;cupom.TW1_Complemento =  Cup.TW1_Complemento__c;cupom.TW1_CPF =  Cup.TW1_CPF__c;cupom.TW1_Email = Cup.TW1_Email__c;cupom.Numero =  String.valueOf(Cup.Numero__c);cupom.TW1_RG =  Cup.TW1_RG__c;cupom.TW1_Rua =  Cup.TW1_Rua__c;cupom.Sexo =  Cup.Sexo__c;cupom.TW1_UF =  Cup.TW1_UF__c;cupom.TW1_Certificado_Autenticao_Promocao = Promocao.TW1_Cert_de_Aut__c;cupom.TW1_Pergunta = Promocao.TW1_Pergunta__c;cupom.TW1_Operador = Cup.TW1_Operador__r.Name;cupom.Nome_Parametro_Promocao = Promocao.Name;cupom.Nome_Shopping = shoppingCorrente.Name;cupom.Data_Reimpressao = String.valueOf(cup.TW1_Data_Reimpressao__c);cupom.Gerou_Reimpressao = String.valueOf(cup.TW1_Gerou_Reimpressao__c);cupom.Numero_Cupom = Cup.Name;
            listcupomSalesforce.add(cupom);
       }
           		rw.cupons = listcupomSalesforce;
            return rw; 
        }catch(Exception e){return null;}
        
    }


    @HttpPost
    global static String ReimpressaoCupons(RequestWrapper requestWrapper){

        Try{

        Set<string> IdsCupons = new Set<string>(requestWrapper.IdsCupons);

        List<TW1_Cupom__c> listCupons = [Select Id,TW1_Data_Reimpressao__c,TW1_Gerou_Reimpressao__c From TW1_Cupom__c Where Id In:IdsCupons];

        For(TW1_Cupom__c item : listCupons)
        {
            item.TW1_Data_Reimpressao__c = DateTime.now().date();
            item.TW1_Gerou_Reimpressao__c = true;
        }

        Update listCupons;
            return 'Sucesso!';
        }catch(Exception e){return 'Erro ao recuperar cupons para reimpressão!';}
    }


    global class RequestWrapper 
    {
        Public List<string> IdsCupons;
    }

    global class ResponseWrapper 
    {
        public List<Cupom> cupons;
    }

    global class Cupom 
    {
        Public String Id;
        public String Numero_Cupom;
        public String TW1_DataCupom;
        public String TW1_Nome_do_Cliente;
        public String TW1_Bairro; 
        public String TW1_Celular;
        public String TW1_CEP; 
        public String TW1_Cidade; 
        public String TW1_Complemento;
        public String TW1_CPF;
        public String TW1_Data_de_Nascimento; 
        public String TW1_Email;
        public String Numero; 
        public String TW1_RG; 
        public String TW1_Rua; 
        public String Sexo;
        public String TW1_UF; 
        public String TW1_Certificado_Autenticao_Promocao; 
        public String TW1_Pergunta;
        public String TW1_Operador; 
        public String Nome_Parametro_Promocao;
        Public String Nome_Shopping; 
        Public String Data_Reimpressao;
        Public String Gerou_Reimpressao;
        Public String Nome_da_Loja;
        Public String Nome_Lojista;
    }
}