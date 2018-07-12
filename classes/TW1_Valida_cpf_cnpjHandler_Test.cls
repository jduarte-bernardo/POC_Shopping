@isTest
public class TW1_Valida_cpf_cnpjHandler_Test {
	
    @isTest static void test_validar_cpf_cnpj_insertContaPessoalPadrao(){
        
        recordtype ContaPessoaPadrao = [SELECT id FROM recordtype WHERE Name = 'Conta pessoal padrão' limit 1];
        
        Account acct = new Account();
        acct.FirstName = 'Apex teste';
        acct.LastName = 'Conta pessoal padrão';
        acct.TW1_CPF__c='74745710569';
        acct.TW1_Sexo__c='Masculino';
        acct.TW1_Celular__c ='2188547584';
        acct.RecordTypeId = ContaPessoaPadrao.Id;
        
        Test.startTest();
        Database.SaveResult result1 = Database.insert(acct,false);
        Test.stopTest();
        
        System.assert(result1.isSuccess()); 
       
    }
    
    @isTest static void test_validar_cpf_cnpj_insertContatocomercialPF(){
        
        recordtype ContatoComercialPF = [SELECT id FROM recordtype WHERE Name = 'Contato comercial PF' limit 1];
        
        Account acct = new Account();
        acct.FirstName = 'Apex teste';
        acct.LastName = 'Contato comercial PF';
        acct.TW1_CPF__c='74745710569';
        acct.TW1_Sexo__c='Masculino';
        acct.TW1_Celular__c ='2188547584';
        acct.RecordTypeId = ContatoComercialPF.Id;
        
        Test.startTest();
        Database.SaveResult result1 = Database.insert(acct,false);
        Test.stopTest();
        
        System.assert(result1.isSuccess()); 
       
    }
    
    
    @isTest static void test_validar_cpf_cnpj_insert1(){
        
        Account acct = new Account();
        acct.Name='Test de validação cpf e cnpj';
        acct.TW1_CPF__c='74745710569';
        acct.TW1_CNPJ__c='27364928000101';
        
        Test.startTest();
        Database.SaveResult result1 = Database.insert(acct,false);
        Test.stopTest();
        
        System.assert(result1.isSuccess()); 
    }
   
    @isTest static void test_validar_cpf_cnpj_insert1Nulo(){
        
        Account acct = new Account(); 
        acct.Name='Test de validação cpf e cnpj';
        acct.TW1_CPF__c='';
        acct.TW1_CNPJ__c='';
        
        Test.startTest(); 
        Database.SaveResult result1 = Database.insert(acct,false);
        Test.stopTest();
        
        for(Database.Error err : result1.getErrors())
        {
            System.debug('err.getMessage(): ' + err.getMessage());
        	System.assertEquals(err.getMessage(),'O CPF está inválido.');            
        }
        
    }
    
    @isTest static void test_validar_cpf_cnpj_insert1ComErro(){
        
        
        try{
            recordtype ContatoComercialPF = [SELECT id FROM recordtype WHERE Name = 'Contato comercial PF' limit 1];
            
            Account acct = new Account();
            acct.FirstName = 'Apex teste';
            acct.LastName = '';
            acct.TW1_CPF__c='74745710569';
            acct.TW1_Sexo__c='Masculino';
            acct.TW1_Celular__c ='2188547584';
            acct.RecordTypeId = ContatoComercialPF.Id;
           
            Insert acct;

        }catch(TriggerException e){
            System.assert(false);
        }
        Catch(Exception e){
            system.debug('fail ' + e);
            System.assert(true);
        }
        
    }
    
    @isTest static void test_validar_cpf_cnpj_Update(){

        Account acct = new Account();
        acct.Name='Test de validação cpf e cnpj';
        acct.TW1_CPF__c='32816442950';
        acct.TW1_CNPJ__c='58927175000129';

        Insert acct;
        
        Account n = [select id,TW1_CPF__c,TW1_CNPJ__c from Account where id =:acct.Id  limit 1];
        n.TW1_CPF__c = '13369144751';
        n.TW1_CNPJ__c = '46185012000139';
        
        Test.startTest();
        	Database.SaveResult result1 = Database.update(n,false);
        Test.stopTest();
        
        System.assert(result1.isSuccess());

    }
    

}