@isTest
public class TW1_Ancar_Venda_NovaCotacaoConfig_Test {
	
    @isTest
    static Opportunity TW1_Ancar_Venda_NovaCotacaoConfig_Test_Moc(){
    
        RecordType vaRecodtypeMarca = [SELECT Id, Name FROM RecordType WHERE Name ='Marca'];
        
        Account vaMarca = new Account();
        vaMarca.Name = 'Apex test Marca';
        vaMarca.TW1_Status__c = 'Ativa';
		vaMarca.RecordTypeId = vaRecodtypeMarca.Id; 
        Insert vaMarca;

        RecordType vaRecodtypeConta = [SELECT Id, Name FROM RecordType WHERE Name ='Contato comercial PF'];
        
        Account vaConta = new Account();
        vaConta.FirstName = 'Apex Test Contato'; 
        vaConta.LastName = 'de Teste';
        vaConta.CEP__c = 235847658;
		vaConta.TW1_Av_Rua__c = 'Rua teste';
        vaConta.TW1_Numero__c = 123;
        vaConta.TW1_Bairro__c = 'Bairro de Teste';
        vaConta.TW1_Cidade__c = 'Cidade de teste';
        vaConta.TW1_Estado__c = 'Estado de Teste';
        vaConta.TW1_Telefone_comercial__c = '21999998888';
        vaConta.RecordTypeId = vaRecodtypeConta.Id; 
		Insert vaConta;
        
        TW1_Shopping__c vaShopping = new TW1_Shopping__c();
        vaShopping.Name = 'Apex Test Shopping de Teste';
        vaShopping.TW1_SGL_Empreendimento__c = 'MST';
		Insert vaShopping;
        
        RecordType vaRecodtypeOppotunity = [SELECT Id, Name FROM RecordType WHERE Name ='Oportunidade de Loja'];
        
        Opportunity vaOportunidade = new Opportunity();
		vaOportunidade.Name = 'Apex Test '+vaRecodtypeOppotunity.Name;
        vaOportunidade.TW1_Shopping__c = vaShopping.Id;
        vaOportunidade.TW1_Marca__c = vaMarca.Id;
        vaOportunidade.AccountId = vaConta.Id;
        vaOportunidade.StageName = 'Em negociação';
        vaOportunidade.CloseDate = Date.valueOf('2018-02-12');
        vaOportunidade.RecordTypeId = vaRecodtypeOppotunity.Id; 
        Insert vaOportunidade;
        
		return vaOportunidade;
    }
    
    @isTest
    static void getObjectById_Test(){
        String vaOpportunityId = TW1_Ancar_Venda_NovaCotacaoConfig_Test_Moc().id;
        System.debug('id de teste:'+vaOpportunityId);
        
        Test.startTest();
            String retornaDto = TW1_Ancar_Venda_NovaCotacaoConfig_ctrl.getObjectById(vaOpportunityId);
        	System.assert(retornaDto!=null);
        test.stopTest();
    }
    
}