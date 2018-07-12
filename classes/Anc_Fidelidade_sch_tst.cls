@istest
public with sharing class Anc_Fidelidade_sch_tst {
    
    @isTest static void testexecuteJob1() { 
                
        TW1_Fidelidade__c vafidelidade = new TW1_Fidelidade__c();
        vafidelidade.TW1_Modalidade__c='Prospect';
        insert vafidelidade;    

        TW1_Cartoes_Estacionamento__c cartao = new TW1_Cartoes_Estacionamento__c();
        cartao.TW1_Numero_Fidelidade__c = vafidelidade.Id;
        Cartao.TW1_Status__c = 'Ativo';
        cartao.TW1_Data_Fim__c = DateTime.now().addMonths(3).date();
        cartao.TW1_Data_inicio__c = DateTime.now().date();
		insert cartao;
            
       Test.startTest();  
        Anc_Fidelidade_Handler_cls.executeJob();//.sendWithFuture(); 
        Test.stopTest();
    } 
    @isTest static void testexecuteJob2() { 
       	Test.startTest();  
        Anc_ScheaduleUtils_cls.scheadule('Anc_Fidelidade_sch', DateTime.now().addMinutes(1)); 
        Test.stopTest(); 
    } 
}