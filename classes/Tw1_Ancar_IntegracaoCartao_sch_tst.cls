@istest
public with sharing class Tw1_Ancar_IntegracaoCartao_sch_tst {
    
    @isTest static void testexecuteJob1() { 
        
        recordtype varecodtype=[select id,name from recordtype where name='Conta pessoal padrão' limit 1];
        
        Account act = new Account(); 
        act.FirstName ='Teste';
        act.LastName ='silva';
        act.TW1_CPF__c='74745710569';
        act.TW1_CNPJ__c='27364928000101';
        act.Phone = '2133337444';
        act.PersonMobilePhone = '21999984578';
        act.RecordTypeId = varecodtype.id;
        insert act;
        
        TW1_Fidelidade__c vafidelidade = new TW1_Fidelidade__c();
        vafidelidade.TW1_Modalidade__c='Prospect';
        vafidelidade.TW1_Nome_Cliente__c=act.id;
        insert vafidelidade; 
        
        TW1_Fidelidade__c vaUpdatefidelidade = [select id from TW1_Fidelidade__c where id=:vafidelidade.id];
        vaUpdatefidelidade.TW1_Modalidade__c='Gold';
        Update vaUpdatefidelidade;

        TW1_Cartoes_Estacionamento__c cartao = new TW1_Cartoes_Estacionamento__c();
        cartao.TW1_Numero_Fidelidade__c = vafidelidade.Id;
        Cartao.TW1_Status__c = 'Ativo';
        cartao.TW1_Data_Fim__c = DateTime.now().addMonths(3).date();
        cartao.TW1_Data_inicio__c = DateTime.now().date();
		insert cartao;
        
        Test.startTest();  
        	Tw1_Ancar_IntegracaoCartao_Handler_cls.executeJob();//.sendWithFuture(); 
        Test.stopTest();
    } 
    @isTest static void testexecuteJob2() { 
        
        recordtype varecodtype=[select id,name from recordtype where name='Conta pessoal padrão' limit 1];
        
        Account act = new Account(); 
        act.FirstName ='Teste';
        act.LastName ='silva';
        act.TW1_CPF__c='74745710569';
        act.TW1_CNPJ__c='27364928000101';
        act.Phone = '2133337444';
        act.PersonMobilePhone = '21999984578';
        act.RecordTypeId = varecodtype.id;
        insert act;
        
        TW1_Fidelidade__c vafidelidade = new TW1_Fidelidade__c();
        vafidelidade.TW1_Modalidade__c='Prospect';
        vafidelidade.TW1_Nome_Cliente__c=act.id;
        insert vafidelidade; 
        
        TW1_Fidelidade__c vaUpdatefidelidade = [select id from TW1_Fidelidade__c where id=:vafidelidade.id];
        vaUpdatefidelidade.TW1_Modalidade__c='Gold';
        Update vaUpdatefidelidade;

        TW1_Cartoes_Estacionamento__c cartao = new TW1_Cartoes_Estacionamento__c();
        cartao.TW1_Numero_Fidelidade__c = vafidelidade.Id;
        Cartao.TW1_Status__c = 'Ativo';
        cartao.TW1_Data_Fim__c = DateTime.now().addMonths(3).date();
        cartao.TW1_Data_inicio__c = DateTime.now().date();
		insert cartao;
        
       	Test.startTest();  
        Anc_ScheaduleUtils_cls.scheadule('Tw1_Ancar_IntegracaoCartao_sch', DateTime.now().addMinutes(1)); 
        Test.stopTest(); 
    } 
}