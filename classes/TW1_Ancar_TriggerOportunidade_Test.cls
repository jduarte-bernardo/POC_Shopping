@isTest
public class TW1_Ancar_TriggerOportunidade_Test {

    @isTest(SeeAllData=true) 
    static void TestOportunidadeAprovada() 
    {
        
        Opportunity opp = TW1_Ancar_OpportunityMockGenerator_cls.getMidiaUniqueOwnerMock('testAncar@testAncar.com.br', '47281354541');
        Opportunity opp2 = TW1_Ancar_OpportunityMockGenerator_cls.getMidiaUniqueOwnerMock('2testAncar@testAncar.com.br', '56430245519');
        
        Quote quoteMock = TW1_Ancar_CotacaoMockGenerator_cls.getMidiaMock(opp.Id);
        Quote quoteMock2 = TW1_Ancar_CotacaoMockGenerator_cls.getMidiaMock(opp2.Id);
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getMidiaMock(quoteMock.Id);
        TW1_Propriedade__c propriedade2 = TW1_Ancar_PropriedadeMockGenerator_cls.getMidiaMock(quoteMock2.Id);
        
        //Criando uma Junction Prop-Opp
        TW1_Prpriedade_Oportunidade__c oppProp = new TW1_Prpriedade_Oportunidade__c(
            TW1_Oportunidade__c = opp.Id,
            TW1_Propriedade__c = propriedade.Id
        );        
        insert oppProp;
        
        //Criando outra Junction Prop-Opp
        TW1_Prpriedade_Oportunidade__c oppProp2 = new TW1_Prpriedade_Oportunidade__c(
            TW1_Oportunidade__c = opp.Id,
            TW1_Propriedade__c = propriedade2.Id
        );        
        insert oppProp2;
        
        //Criando outra Junction Prop-Opp
        TW1_Prpriedade_Oportunidade__c oppProp3 = new TW1_Prpriedade_Oportunidade__c(
            TW1_Oportunidade__c = opp2.Id,
            TW1_Propriedade__c = propriedade.Id
        );        
        insert oppProp3;      
                
        //Propriedade da cotação adicional 
        //Propriedade 2 também na Cotação 1
        TW1_Propriedade_da_Cotacao__c cotProp3 = new TW1_Propriedade_da_Cotacao__c(
            TW1_Propriedade__c = propriedade2.Id,
            TW1_Cotacao__c = quoteMock.Id
        );        
        insert cotProp3; 
        
        //Cria os calendários das propriedades da oportunidade 1     
        TW1_Calendario_de_propriedades__c calendario1 = new TW1_Calendario_de_propriedades__c(
        	TW1_Opportunidade__c = opp.Id,
            TW1_Propriedade__c = propriedade.Id,
            TW1_Status__c = 'Reservada'
        );
        insert calendario1;
        
        TW1_Calendario_de_propriedades__c calendario2 = new TW1_Calendario_de_propriedades__c(
        	TW1_Opportunidade__c = opp.Id,
            TW1_Propriedade__c = propriedade2.Id,
            TW1_Status__c = 'Reservada'
        );
        insert calendario2;
                
        // Perform test
        Test.startTest();
        
        ApexPages.currentPage().getparameters().put('id', quoteMock.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(quoteMock); 
        
        TW1_Ancar_SyncCotacaoController Sync = new TW1_Ancar_SyncCotacaoController(sc);
        Sync.sincronizarCotacao();  
        
        Opportunity oportunidade = [SELECT Id, TW1_Cotacao_sincronizada__c FROM Opportunity WHERE Id = :opp.Id];
        System.debug('cotação da oportunidade sincronizada: ' + oportunidade);
        
        ApexPages.currentPage().getparameters().put('id', quoteMock2.Id);
        sc = new ApexPages.StandardController(quoteMock2); 
        
        Sync = new TW1_Ancar_SyncCotacaoController(sc);
        Sync.sincronizarCotacao();  
        
        List<TW1_Prpriedade_Oportunidade__c> lstOpportunityProperty2 = 
            [SELECT TW1_Oportunidade__c FROM TW1_Prpriedade_Oportunidade__c 
             WHERE TW1_Propriedade__c = :propriedade.Id];
        System.debug('lstOpportunityProperty2: ' + lstOpportunityProperty2);
        
        Opportunity oportunidade2 = [SELECT Id, StageName, TW1_Cotacao_sincronizada__c FROM Opportunity WHERE Id = :opp2.Id];
        System.debug('cotação da oportunidade sincronizada: ' + oportunidade2);
        
        //Submeter para aprovação
        submitForApproval(opp);
        submitForApproval(opp2);
        
        approveRecord(opp);
        
        oportunidade = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp.Id];
        oportunidade2 = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp2.Id];
        
        System.debug('oportunidade: ' + oportunidade);
        System.debug('oportunidade 2: ' + oportunidade2);
        
        propriedade = [SELECT Id, TW1_Status__c FROM TW1_Propriedade__c WHERE Id = :propriedade.Id];
        propriedade2 = [SELECT Id, TW1_Status__c FROM TW1_Propriedade__c WHERE Id = :propriedade2.Id];
        
        List<TW1_Calendario_de_propriedades__c> lstCalProp1 = [SELECT TW1_Propriedade__c, TW1_Status__c, TW1_Data_de_inicio__c, TW1_Data_de_fim__c
                                                 FROM TW1_Calendario_de_propriedades__c
                                                 WHERE TW1_Propriedade__c = :propriedade.Id AND TW1_Opportunidade__c = :oportunidade.Id];
        
        List<TW1_Calendario_de_propriedades__c> lstCalProp2 = [SELECT TW1_Propriedade__c, TW1_Status__c, TW1_Data_de_inicio__c, TW1_Data_de_fim__c
                                                 FROM TW1_Calendario_de_propriedades__c
                                                 WHERE TW1_Propriedade__c = :propriedade2.Id AND TW1_Opportunidade__c = :oportunidade.Id];
        
        List<TW1_Calendario_de_propriedades__c> lstCalProp3 = [SELECT TW1_Propriedade__c, TW1_Status__c, TW1_Data_de_inicio__c, TW1_Data_de_fim__c
                                                 FROM TW1_Calendario_de_propriedades__c
                                                 WHERE TW1_Propriedade__c = :propriedade.Id AND TW1_Opportunidade__c = :oportunidade2.Id];
                
        System.debug('Estágio da Oportunidade 2: ' + oportunidade2.StageName);
        System.assertEquals('Arquivada', oportunidade2.StageName);
        
        //Criou TW1_Calendario_de_propriedades__c da propriedade da oportunidade que foi aprovada
        System.debug('Lista calendário 1: ' + lstCalProp1);
        System.assert(!lstCalProp1.isEmpty());        
        if (!lstCalProp1.isEmpty())
        {
            for(TW1_Calendario_de_propriedades__c cal : lstCalProp1)
            {
                System.assertEquals('Ocupada', cal.TW1_Status__c);
            }
        }
        
        //Criou TW1_Calendario_de_propriedades__c da outra propriedade da oportunidade que foi aprovada
        System.debug('Lista calendário 2: ' + lstCalProp2);
        System.assert(!lstCalProp2.isEmpty());
        if (!lstCalProp2.isEmpty())
        {
			for(TW1_Calendario_de_propriedades__c cal : lstCalProp2)
            {
                System.assertEquals('Ocupada', cal.TW1_Status__c);
            }
        }
        
        //Deletou o TW1_Calendario_de_propriedades__c da propriedade da oportunidade que foi arquivada
        System.debug('Lista calendário 3 (deve estar vazia): ' + lstCalProp2);
        System.assert(lstCalProp3.isEmpty());
        
        // exit the testing context
        Test.stopTest();
    }
    
    @isTest static void TestOportunidadeParaIntegracao()
    {
        // Perform test
        Test.startTest();
        
        //Oportunidade
		Opportunity opp = TW1_Ancar_OpportunityMockGenerator_cls.getLojaMock();
        update opp;
        
        //Cotação
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getLojaMock(opp.Id);
        
        //Propriedade
        TW1_Propriedade__c prop = TW1_Ancar_PropriedadeMockGenerator_cls.getLojaMock(quote.Id);
              
        //Cria Propriedade da Oportunidade       
        ApexPages.currentPage().getparameters().put('id', quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(quote); 
        
        TW1_Ancar_SyncCotacaoController Sync = new TW1_Ancar_SyncCotacaoController(sc);
        Sync.sincronizarCotacao();     
        
        Opportunity oportunidade = [SELECT Id, StageName FROM Opportunity WHERE Id = :opp.Id];
        oportunidade.StageName = 'Enviada para integração';
        
        // change the status of the record and update it
        update oportunidade;
        
        System.debug('Verifica se alterou o estágio para Integrada');
        
        // Asynchronous calls are executed after Test.stopTest
        Test.stopTest();
        
        Opportunity oppStage = [SELECT StageName, TW1_Descricao_erro_integracao__c FROM Opportunity WHERE Id = :oportunidade.Id];
        System.debug(oppStage);
        System.assertEquals('Integrada', oppStage.StageName);
    }
    
    @isTest static void TestOportunidadeModify()
    {
        //Criando uma oportunidade        
        Opportunity opp = TW1_Ancar_OpportunityMockGenerator_cls.getMidiaMock();
        
        opp.Name = 'Modified';
		update opp;
        
        delete opp;
        
        undelete opp;
    }
    
    private static void submitForApproval(Opportunity opp)
    {
        System.debug('Vai submeter para aprovação a oportunidade ' + opp.Id);
        
        Opportunity idOwnerField = [select OwnerId from Opportunity where Id = :opp.Id];
        System.debug('idOwnerField: ' + idOwnerField);
        Id idOwner = idOwnerField.OwnerId;
        System.debug('idOwner: ' + idOwner);
        List<User> users = [SELECT Id FROM User WHERE Id = :idOwner];
        System.debug('users: ' + users);
        List<Id> lstIdUser = new List<Id>();
        for(User u : users)
        	 lstIdUser.add(u.Id);
        System.debug('lstIdUser: ' + lstIdUser);
        
        // Create an approval request for the Opportunity
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval automatically using Trigger');
        req1.setObjectId(opp.id);
        req1.setNextApproverIds(lstIdUser);

        // Submit the approval request for the Opportunity
        Approval.ProcessResult result = Approval.process(req1);
        Opportunity o = [SELECT stagename from Opportunity where id =:opp.Id];
        System.debug('Status da oportunidade: ' + o);
    }
    
    private static void approveRecord(Opportunity opp)
    {
        System.debug('Vai aprovar a oportunidade ' + opp.Id);
        
        Opportunity idOwnerField = [select OwnerId from Opportunity where Id = :opp.Id];
        Id idOwner = idOwnerField.OwnerId;
        List<User> users = [SELECT Id FROM User WHERE Id = :idOwner];
        List<Id> lstIdUser = new List<Id>();
        for(User u : users)
        	 lstIdUser.add(u.Id);
        
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Approving request using Trigger');
        req.setAction('Approve');
        req.setNextApproverIds(lstIdUser);
        Id workItemId = getWorkItemId(opp.id); 

        if(workItemId == null)
        {
            System.debug('Erro ao tentar aprovar');
        }
        else
        {
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
            
            Opportunity o = [SELECT stagename from Opportunity where id =:opp.Id];
        	System.debug('Status da oportunidade: ' + o);            
        }
    }
    
    private static Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;

        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
            where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
        }

        return retVal;
    }
    
}