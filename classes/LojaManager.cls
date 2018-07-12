/******************************************************************************************************
Author  	: Leonardo Façanha
Date    	: 22/12/2017
Purpose 	: Api Rest para buscar informações do Loja para a aplicação de promoção
*******************************************************************************************************/
@RestResource(urlMapping='/Loja/*')
global with sharing class LojaManager {
    
    @HttpPost
    global static List<Account> BuscarLojas(string IdPromocao)
    {
       Set<string> listLojasId = new Set<string>(); List<Loja_Participante__c> LojasParticipante = [SELECT Id,TW1_Loja__c From Loja_Participante__c where TW1_Promocao__c=:IdPromocao];
          
        For(Loja_Participante__c Loja : LojasParticipante){listLojasId.Add(Loja.TW1_Loja__c);}
     	
        List<Account> listaLoja =[ SELECT Id,Name, TW1_LUC__c,TW1_CNPJ__c,TW1_Nome_fantasia__c,TW1_Razao_Social__c FROM Account WHERE Id IN :listLojasId];        
        return listaLoja;
    }
    
    @HttpGet
    global static List<Account> getLojaPorId(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        recordtype rtAcc = [Select Id,Name From recordtype where Name='Loja' Limit 1];

        String LojaId = req.params.get('Id');
        
        If(LojaId != null && LojaId != '' && LojaId != 'null'){
            
            try{
                
                List<Account> listaLojaPorId = 
                    [ 
                        SELECT 
                        Id,
                        Name,
                        TW1_LUC__c,
                        TW1_CNPJ__c,
                        TW1_Nome_fantasia__c,
                        TW1_Razao_Social__c
                        FROM Account 
                        WHERE 
                        Id=:LojaId LIMIT 1
                    ];
                return listaLojaPorId;
                
            }catch(exception e){return null;}
        }
        else{ 
            
            String Luc = req.params.get('Luc') == null? '':req.params.get('Luc');
            String Cnpj = req.params.get('Cnpj')== null? '':req.params.get('Cnpj');
            String Nome = req.params.get('Nome')== null? '':req.params.get('Nome');
            String Razao = req.params.get('Razao')== null? '':req.params.get('Razao');
            String IdPromocao = req.params.get('IdPromocao')== null? '':req.params.get('IdPromocao');
            String IdShopping = req.params.get('IdShopping')== null? '':req.params.get('IdShopping');
            Boolean EspacoNome = false;
            Boolean EspacoRazao = false;
            Boolean EspacoCnpj = false;
            
            If(Nome != null)
            EspacoNome = Nome.contains('-');
            EspacoNome = Nome.contains('26');
            If(Razao != null)
            EspacoRazao = Razao.contains('-');
            EspacoRazao = Razao.contains('26');
            If(Cnpj != null)
            EspacoCnpj = Cnpj.contains('.');
            
            If(EspacoNome)
                Nome = Nome.replace('-', ' ');
            	Nome = Nome.replace('26', '&');
             If(EspacoRazao)
                Razao = Razao.replace('-', ' ');
            	Razao = Razao.replace('26', '&');
            If(EspacoCnpj){
                Cnpj = Cnpj.replace('.', '');Cnpj = Cnpj.replace('.', '');Cnpj = Cnpj.replace('/', '');Cnpj = Cnpj.replace('-', '');          }
            
            List<Account> listaAccount;
            
            if((Luc == '' && Cnpj == '' && Nome == '' && Razao == '') || (Luc == null && Cnpj == null && Nome == null && Razao == null)){
                return listaAccount;
            }
            else{
                String strQuery = 'SELECT Id,Name,TW1_LUC__c,TW1_CNPJ__c,TW1_Nome_fantasia__c,TW1_Razao_Social__c FROM Account ';
                strQuery += 'WHERE recordtypeId=' + '\'' + rtAcc.Id + '\'' + ' And TW1_Shopping__c='+ '\'' + IdShopping + '\'' + ' And ';
                
                if(Luc != '' && Luc != null)
                 strQuery += '(TW1_LUC__c !=' + '\'' + '\'' + ' And TW1_LUC__c=' + '\'' + Luc + '\'' + ')';

                if(Cnpj != '' && Cnpj != null)
                 strQuery += '(TW1_CNPJ__c !=' + '\'' + '\'' + ' And TW1_CNPJ__c=' + '\'' + Cnpj + '\'' + ')';

                if(Nome != '' && Nome != null)
                 strQuery += '(TW1_Nome_fantasia__c !=' + '\'' + '\'' + ' And TW1_Nome_fantasia__c LIKE ' + '\'%' + Nome + '%\'' + ') Order by TW1_Nome_fantasia__c Asc';
                 
                if(Razao != '' && Razao != null)
                 strQuery += '(TW1_Razao_Social__c !=' + '\'' + '\'' + ' And TW1_Razao_Social__c LIKE' + '\'%' + Razao + '%\'' + ') Order by TW1_Razao_Social__c Asc';
               	
                System.debug(strQuery);
                
                listaAccount = Database.query(strQuery);
                
                return GetLojasParticipantes(listaAccount,IdPromocao);
            }
        }        
    }
    
    Public static List<Account> GetLojasParticipantes(List<Account> listaAccount,string IdPromocao)
    {
        List<Loja_Participante__c> LojasParticipante = [SELECT Id,TW1_Loja__c From Loja_Participante__c where TW1_Promocao__c=:IdPromocao];
        
        List<Account> ListAccountPromocao = new List<Account>();
        
        For(Loja_Participante__c item : LojasParticipante){
            
            For(Account Loja : listaAccount){
                If(item.TW1_Loja__c == Loja.Id)
                    ListAccountPromocao.add(Loja);
            }
        }
        If(ListAccountPromocao.size() >= 1) 
            return ListAccountPromocao; 
        else 
            return New List<Account>();
    }
}