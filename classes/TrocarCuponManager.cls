/******************************************************************************************************
Author  	: Leonardo Façanha
Date    	: 22/12/2017
Purpose 	: Api Rest para buscar informações do Trocar Cupon para a aplicação de promoção
*******************************************************************************************************/
@RestResource(urlMapping='/TrocarCupom/*')
global with sharing class TrocarCuponManager {
	
    @HttpGet
    global static requestWrapper getTrocarCuponPorId(){
        try{
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
      
        String accountId = req.params.get('accountId');
        Integer Quantidade = Integer.valueOf(req.params.get('QuantidadeCupons'));
        String Shopping = req.params.get('IdShopping');
        String IdOperador = req.params.get('IdOperador');
        String NomeLojista = req.params.get('NomeLojista') == null? '':req.params.get('NomeLojista');
        String NomeLoja = req.params.get('NomeLoja') == null ? '':req.params.get('NomeLoja');
		
        Boolean EspacoNomeLojista = NomeLojista.contains('-');
            
        If(EspacoNomeLojista)
        NomeLojista = NomeLojista.replace('-', ' ');
            
        Boolean EspacoNomeLoja = NomeLoja.contains('-');
            
        If(EspacoNomeLoja)
        NomeLoja = NomeLoja.replace('-', ' ');
            
            
        requestWrapper acc = new requestWrapper();
        acc.cupom = new List<Cupom>();
         List<TW1_Cupom__c> Listcup = new List<TW1_Cupom__c>();
		 date vaData = DateTime.now().date();
            
        TW1_Parametros_Promocao__c Promocao = [Select Id,Name,TW1_Cert_de_Aut__c,TW1_Pergunta__c From TW1_Parametros_Promocao__c Where TW1_Shopping__c=:Shopping And TW1_Data_Fim__c >=:vaData Limit 1];
        TW1_Shopping__c shoppingCorrente = [Select Id,Name From TW1_Shopping__c Where Id=:Shopping Limit 1];
            
        Account account = [Select  Id,
                        FirstName,
                        LastName,
                        Name,
                        TW1_Av_Rua__c,
                        TW1_Numero__c,
                        TW1_Bairro__c,
                        CEP__c,
                        TW1_Complemento__c,
                        TW1_Estado_civil__c,
                        TW1_Sexo__c,
                        TW1_Cidade__c,
                        TW1_UF_de_emissao__c,
                        TW1_CPF__c,
                        TW1_Identidade__c,
                        PersonEmail,
                        TW1_Permite_SMS__c,
                        TW1_Data_Nascimento__c,
                        DDD__c,
                        TW1_DDI__c,
                        Phone,
                        TW1_EmailCB__c,
                        TW1_TelefoneCB__c,
                        TW1_Correspondencia__c
                        FROM Account Where Id=:accountId Limit 1];

        for(Integer i = 1; i <= Quantidade; i++)
        {
            TW1_Cupom__c cup = new TW1_Cupom__c();
            
              cup.TW1_Nome_Lojista__c = NomeLojista;
              cup.TW1_Nome_da_Loja__c = NomeLoja;
              cup.TW1_Data__c = DateTime.now();
              cup.TW1_Nome_do_Cliente__c = accountId;
              cup.TW1_Bairro__c =  account.TW1_Bairro__c;
              cup.TW1_Celular__c =  String.valueOf(account.DDD__c) + String.valueOf(account.Phone);
              cup.TW1_CEP__c =  String.valueOf(account.CEP__c);
              cup.TW1_Cidade__c =  account.TW1_Cidade__c;
              cup.TW1_Complemento__c =  account.TW1_Complemento__c;
              cup.TW1_CPF__c =  account.TW1_CPF__c;
              cup.TW1_Data_de_Nascimento__c =  account.TW1_Data_Nascimento__c;
              cup.TW1_Email__c =  account.PersonEmail;
              cup.Numero__c =  account.TW1_Numero__c;
              cup.TW1_RG__c =  account.TW1_Identidade__c;
              cup.TW1_Rua__c =  account.TW1_Av_Rua__c;
              cup.Sexo__c =  account.TW1_Sexo__c;
              cup.TW1_UF__c =  account.TW1_UF_de_emissao__c;
           	  cup.TW1_Certificado_Autenticao_Promocao__c = 	Promocao.TW1_Cert_de_Aut__c;
              cup.TW1_Pergunta__c = Promocao.TW1_Pergunta__c;
              cup.TW1_Operador__c = IdOperador;
              cup.TW1_Shopping_Lookup__c = shoppingCorrente.Id;
              //cup.TW1_Formas_de_Pagamento__c = ;
              cup.TW1_Parametro_Promocao__c = Promocao.Id;
              
              Listcup.add(cup);             
        }  
        
        insert Listcup;
            
        Map<Id,TW1_Cupom__c> MapCup = new Map<Id,TW1_Cupom__c>(Listcup);
        
        List<Tw1_Cupom__c> listaCupom = [Select Id,Name,TW1_Operador__r.Name From TW1_Cupom__c Where Id In:MapCup.keySet()];
        
        Map<Id,TW1_Cupom__c> litsMapCup = new Map<Id,TW1_Cupom__c>(listaCupom);

        acc.cupom = MapCupom(litsMapCup,Listcup,Promocao,account,shoppingCorrente,NomeLojista,NomeLoja);
        
         return acc;

        }
        catch (Exception ex) {
               return new requestWrapper();
           }  
    }

    Private static List<Cupom> MapCupom(Map<Id,TW1_Cupom__c> litsMapCup,List<TW1_Cupom__c> Listcup,TW1_Parametros_Promocao__c Promocao,Account account,TW1_Shopping__c shoppingCorrente, string NomeLojista,string NomeLoja)
    {
        List<Cupom> listcupomSalesforce = new List<Cupom>();

        for(TW1_Cupom__c Cup : Listcup){
        
        Cupom cupom = new Cupom();
			
            DateTime dataCup = Cup.TW1_Data__c;
            
            cupom.Nome_Lojista = NomeLojista;
            cupom.Nome_da_Loja = NomeLoja;
            cupom.TW1_DataCupom = dataCup.format('dd/MM/yyyy HH:mm:ss');
            cupom.Numero_Cupom = litsMapCup.get(Cup.Id).Name;
            cupom.TW1_Nome_do_Cliente = account.Name;
            cupom.TW1_Bairro =  account.TW1_Bairro__c;
            cupom.TW1_Celular =  String.valueOf(account.DDD__c) + String.valueOf(account.Phone);
            cupom.TW1_CEP =  String.valueOf(account.CEP__c);
            cupom.TW1_Cidade =  account.TW1_Cidade__c;
            cupom.TW1_Complemento =  account.TW1_Complemento__c;
            cupom.TW1_CPF =  account.TW1_CPF__c;
            cupom.TW1_Data_de_Nascimento = account.TW1_Data_Nascimento__c.day() + '/' + account.TW1_Data_Nascimento__c.month() + '/' + account.TW1_Data_Nascimento__c.year();
            System.debug(cupom.TW1_Data_de_Nascimento);
            cupom.TW1_Email =  account.PersonEmail;
            cupom.Numero =  String.valueOf(account.TW1_Numero__c);
            cupom.TW1_RG =  account.TW1_Identidade__c;
            cupom.TW1_Rua =  account.TW1_Av_Rua__c;
            cupom.Sexo =  account.TW1_Sexo__c;
            cupom.TW1_UF =  account.TW1_UF_de_emissao__c;
            cupom.TW1_Certificado_Autenticao_Promocao = Promocao.TW1_Cert_de_Aut__c;
            cupom.TW1_Pergunta = Promocao.TW1_Pergunta__c;
            cupom.TW1_Operador = litsMapCup.get(Cup.Id).TW1_Operador__r.Name;
            cupom.Nome_Parametro_Promocao = Promocao.Name;
            cupom.Nome_Shopping = shoppingCorrente.Name; 

            listcupomSalesforce.add(cupom);
        }

        return listcupomSalesforce;       
    }
    
    global class requestWrapper 
    {
        public List<Cupom> cupom;
    }

    global class Cupom 
    {
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
        Public String Nome_da_Loja;
        Public String Nome_Lojista;
    }
}