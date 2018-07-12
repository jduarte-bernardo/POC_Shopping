@isTest
public with sharing class TW1_Cartao_Estacio_Tst_Reempressao {
    
    @isTest public static void testGerarCartaoEstacionamento(){
        
        recordtype varecodtype=[select id,name from recordtype where name='Conta pessoal padrão' limit 1];
        
        //Inserindo a massa de teste
        Account vaAccount = new Account(); 
        vaAccount.FirstName ='Teste';
        vaAccount.LastName ='silva';
        vaAccount.TW1_CPF__c='74745710569';
        vaAccount.TW1_CNPJ__c='27364928000101';
        vaAccount.Phone = '2133337444';
        vaAccount.PersonMobilePhone = '21999984578';
        vaAccount.RecordTypeId = varecodtype.id;
        insert vaAccount;
        
        TW1_Fidelidade__c vafidelidade = new TW1_Fidelidade__c();
        system.debug(vaAccount.Id);
        vafidelidade.TW1_Nome_Cliente__c = vaAccount.Id;
        insert vafidelidade;
        
        TW1_Cartoes_Estacionamento__c cartao = new TW1_Cartoes_Estacionamento__c();
        cartao.TW1_Cartao_Gerado__c = true;
        cartao.TW1_Data_Fim__c = Date.newinstance(2017,01,01);
        cartao.TW1_Data_inicio__c = Date.newinstance(2017,01,10);
        cartao.TW1_Numero_Fidelidade__c = vafidelidade.Id;
        cartao.TW1_Status__c = 'Ativo';
        insert cartao;
        
        //Começando os Testes
        Test.startTest();
        
        ApexPages.CurrentPage().getparameters().put('id', cartao.Id);      
        
        Apexpages.StandardController sc = new Apexpages.StandardController(cartao);
        Tw1_Cartao_Estacio_Ctr_Reempressao ctrCartEst = new Tw1_Cartao_Estacio_Ctr_Reempressao(sc);
        
        ctrCartEst.GerarPdf();
        
        Test.stopTest();
        //Fim do teste
    }
}