@isTest
public with sharing class TW1_Cartao_Estacio_Tst_GerarPDFT {
    
    @isTest 
    public static void testGerarCartaoPDFSaldoMaiorQue1000(){
        //Inserindo a massa de teste
        recordtype varecodtype2=[select id,name from recordtype where name='Cartão Estacionamento' limit 1];
        recordtype varecodtype=[select id,name from recordtype where name='Conta pessoal padrão' limit 1];
        
        Account vaAccounts = new Account(); 
        vaAccounts.FirstName ='Teste';
        vaAccounts.LastName ='silva';
        vaAccounts.TW1_CPF__c='74745710569';
        vaAccounts.TW1_CNPJ__c='27364928000101';
        vaAccounts.Phone = '2133337444';
        vaAccounts.PersonMobilePhone = '21999984578';
        vaAccounts.RecordTypeId = varecodtype.id;
        insert vaAccounts;
        
        TW1_Fidelidade__c vafidelidade = new TW1_Fidelidade__c();
        system.debug(vaAccounts.Id);
        vafidelidade.TW1_Nome_Cliente__c = vaAccounts.Id;
        insert vafidelidade;
        
        TW1_Cartoes_Estacionamento__c cartao = new TW1_Cartoes_Estacionamento__c();
        cartao.TW1_Cartao_Gerado__c = true;
        cartao.TW1_Data_Fim__c = Date.newinstance(2017,01,01);
        cartao.TW1_Data_inicio__c = Date.newinstance(2017,01,10);
        cartao.TW1_Numero_Fidelidade__c = vafidelidade.Id;
        cartao.TW1_Status__c = 'Ativo';
        insert cartao;
        
        TW1_Historico__c historico = new TW1_Historico__c();
        historico.TW1_Fidelidade__c = vafidelidade.id;
        historico.RecordTypeId = varecodtype2.id;
        historico.TW1_Tipo__c = 'Cartão Estacionamento';
        historico.TW1_Data__c = DateTime.now().date();
        historico.TW1_Pontos__c = 1000;
        insert historico;
        
        //Começando os Testes
        Test.startTest();
        ApexPages.CurrentPage().getparameters().put('id', cartao.Id);      
        Apexpages.StandardController sc = new Apexpages.StandardController(cartao);
        TW1_Cartao_Estacio_Ctr_GerarPDFT ctrCartEst = new TW1_Cartao_Estacio_Ctr_GerarPDFT(sc);
        
        ctrCartEst.GerarPdf();
        
        Test.stopTest();
        //Fim do teste
    }
    
    @isTest public static void testGerarCartaoPDFSaldoMenorQue1000(){
        //Inserindo a massa de teste
        
         recordtype varecodtype2=[select id,name from recordtype where name='Cartão Estacionamento' limit 1];
        recordtype varecodtype=[select id,name from recordtype where name='Conta pessoal padrão' limit 1];
        
        Account vaAccounts = new Account(); 
        vaAccounts.FirstName ='Teste';
        vaAccounts.LastName ='silva';
        vaAccounts.TW1_CPF__c='74745710569';
        vaAccounts.TW1_CNPJ__c='27364928000101';
        vaAccounts.Phone = '2133337444';
        vaAccounts.PersonMobilePhone = '21999984578';
        vaAccounts.RecordTypeId = varecodtype.id;
        insert vaAccounts;
        
        TW1_Fidelidade__c vafidelidade = new TW1_Fidelidade__c();
        system.debug(vaAccounts.Id);
        vafidelidade.TW1_Nome_Cliente__c = vaAccounts.Id;
        insert vafidelidade;
        
        TW1_Cartoes_Estacionamento__c cartao = new TW1_Cartoes_Estacionamento__c();
        cartao.TW1_Cartao_Gerado__c = true;
        cartao.TW1_Data_Fim__c = Date.newinstance(2017,01,01);
        cartao.TW1_Data_inicio__c = Date.newinstance(2017,01,10);
        cartao.TW1_Numero_Fidelidade__c = vafidelidade.Id;
        cartao.TW1_Status__c = 'Ativo';
        insert cartao;
        
        TW1_Historico__c historico = new TW1_Historico__c();
        historico.TW1_Fidelidade__c = vafidelidade.id;
        historico.RecordTypeId = varecodtype2.id;
        historico.TW1_Tipo__c = 'Cartão Estacionamento';
        historico.TW1_Data__c = DateTime.now().date();
        historico.TW1_Pontos__c = 0;
        insert historico;
        
        //Começando os Testes
        Test.startTest();
        ApexPages.CurrentPage().getparameters().put('id', cartao.Id);      
        Apexpages.StandardController sc = new Apexpages.StandardController(cartao);
        TW1_Cartao_Estacio_Ctr_GerarPDFT ctrCartEst = new TW1_Cartao_Estacio_Ctr_GerarPDFT(sc);
        
        ctrCartEst.GerarPdf();
        
        Test.stopTest();
        //Fim do teste
    }
    
    @isTest public static void testGerarCartaoPDFStatusInativoMenorQue1000(){
        //Inserindo a massa de teste
       
       	 recordtype varecodtype2=[select id,name from recordtype where name='Cartão Estacionamento' limit 1];
        recordtype varecodtype=[select id,name from recordtype where name='Conta pessoal padrão' limit 1];
        
        Account vaAccounts = new Account(); 
        vaAccounts.FirstName ='Teste';
        vaAccounts.LastName ='silva';
        vaAccounts.TW1_CPF__c='74745710569';
        vaAccounts.TW1_CNPJ__c='27364928000101';
        vaAccounts.Phone = '2133337444';
        vaAccounts.PersonMobilePhone = '21999984578';
        vaAccounts.RecordTypeId = varecodtype.id;
        insert vaAccounts;
        
        TW1_Fidelidade__c vafidelidade = new TW1_Fidelidade__c();
        system.debug(vaAccounts.Id);
        vafidelidade.TW1_Nome_Cliente__c = vaAccounts.Id;
        insert vafidelidade;
        
        TW1_Cartoes_Estacionamento__c cartao = new TW1_Cartoes_Estacionamento__c();
        cartao.TW1_Cartao_Gerado__c = false;
        cartao.TW1_Data_Fim__c = Date.newinstance(2017,01,01);
        cartao.TW1_Data_inicio__c = Date.newinstance(2017,01,10);
        cartao.TW1_Numero_Fidelidade__c = vafidelidade.Id;
        cartao.TW1_Status__c = 'inativo';
        insert cartao;
        
        TW1_Historico__c historico = new TW1_Historico__c();
        historico.TW1_Fidelidade__c = vafidelidade.id;
        historico.RecordTypeId = varecodtype2.id;
        historico.TW1_Tipo__c = 'Cartão Estacionamento';
        historico.TW1_Data__c = DateTime.now().date();
        historico.TW1_Pontos__c = 0;
        insert historico;
        
        //Começando os Testes
        Test.startTest();
        ApexPages.CurrentPage().getparameters().put('id', cartao.Id);      
        Apexpages.StandardController sc = new Apexpages.StandardController(cartao);
        TW1_Cartao_Estacio_Ctr_GerarPDFT ctrCartEst = new TW1_Cartao_Estacio_Ctr_GerarPDFT(sc);
        
        ctrCartEst.GerarPdf();
        
        Test.stopTest();
        //Fim do teste
    }
    
    @isTest public static void testGerarCartaoPDFStatusIDNulo(){
        //Inserindo a massa de teste
        recordtype varecodtype2=[select id,name from recordtype where name='Cartão Estacionamento' limit 1];
        recordtype varecodtype=[select id,name from recordtype where name='Conta pessoal padrão' limit 1];
        
        Account vaAccounts = new Account(); 
        vaAccounts.FirstName ='Teste';
        vaAccounts.LastName ='silva';
        vaAccounts.TW1_CPF__c='74745710569';
        vaAccounts.TW1_CNPJ__c='27364928000101';
        vaAccounts.Phone = '2133337444';
        vaAccounts.PersonMobilePhone = '21999984578';
        vaAccounts.RecordTypeId = varecodtype.id;
        insert vaAccounts;
        
        TW1_Fidelidade__c vafidelidade = new TW1_Fidelidade__c();
        system.debug(vaAccounts.Id);
        vafidelidade.TW1_Nome_Cliente__c = vaAccounts.Id;
        insert vafidelidade;
        
        TW1_Cartoes_Estacionamento__c cartao = new TW1_Cartoes_Estacionamento__c();
        cartao.TW1_Cartao_Gerado__c = false;
        cartao.TW1_Data_Fim__c = Date.newinstance(2017,01,01);
        cartao.TW1_Data_inicio__c = Date.newinstance(2017,01,10);
        cartao.TW1_Numero_Fidelidade__c = vafidelidade.Id;
        cartao.TW1_Status__c = 'inativo';
        insert cartao;
        
        TW1_Historico__c historico = new TW1_Historico__c();
        historico.TW1_Fidelidade__c = vafidelidade.id;
        historico.RecordTypeId = varecodtype2.id;
        historico.TW1_Tipo__c = 'Cartão Estacionamento';
        historico.TW1_Data__c = DateTime.now().date();
        historico.TW1_Pontos__c = 0;
        insert historico;
        
        //Começando os Testes
        Test.startTest();
        ApexPages.CurrentPage().getparameters().put('id', null);      
        Apexpages.StandardController sc = new Apexpages.StandardController(cartao);
        TW1_Cartao_Estacio_Ctr_GerarPDFT ctrCartEst = new TW1_Cartao_Estacio_Ctr_GerarPDFT(sc);
        
        ctrCartEst.GerarPdf();
        
        Test.stopTest();
        //Fim do teste
    }
}