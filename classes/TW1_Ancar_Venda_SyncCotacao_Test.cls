@isTest
public class TW1_Ancar_Venda_SyncCotacao_Test {
    
    //Teste: Atualiza a oportunidade com a data início e fim cotação (caso a oportunidade seja de Loja ou Mall) 
    //Teste: Se a oportunidade NÃO for de mídia, NÃO altera o status da(s) propriedade(s)
    @isTest public static void QuoteSyncCotacaoLoja()
    {        
        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getLojaMock();
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getLojaMock(opportunity.Id);   
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getLojaMock(quote.Id);
              
        // Perform test
        Test.startTest();
        
        //TW1_SyncCotacaoController       
        ApexPages.currentPage().getparameters().put('id', quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(quote); 
        
        TW1_Ancar_SyncCotacaoController Sync = new TW1_Ancar_SyncCotacaoController(sc);
        Sync.sincronizarCotacao();     
        
        opportunity = [SELECT Id, TW1_Prazo__c, TW1_Data_inicio_de_vigencia__c, TW1_Data_fim_de_vigencia__c, TW1_Possui_midia_inaugural__c 
                       FROM Opportunity WHERE Id = :opportunity.Id];
        
        //Verifica se marcou a checkbox TW1_Possui_midia_inaugural__c, 
        //pois o campo TW1_Valor_pacote_de_midia__c da cotação está com valor
        System.assertEquals(true, opportunity.TW1_Possui_midia_inaugural__c);
        
        //Verifica se a oportunidade pegou as datas início e fim da cotação
        System.assertEquals(quote.TW1_Data_inicio_de_vigencia__c, opportunity.TW1_Data_inicio_de_vigencia__c);        
        System.assertEquals(quote.TW1_Data_fim_de_vigencia__c, opportunity.TW1_Data_fim_de_vigencia__c);
        
        propriedade = [SELECT Id, TW1_Status__c FROM TW1_Propriedade__c WHERE Id = :propriedade.Id];
        
        //Verifica se a propriedade atreladas à oportunidade manteve o status 'Vaga'
        System.assertEquals('Vaga', propriedade.TW1_Status__c);
        
        // exit the testing context
        Test.stopTest();
    }
    
    @isTest public static void QuoteSyncVlrPctMidiaMarcado()
    {                        
        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getLojaMock();
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getLojaMock(opportunity.Id);  
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getLojaMock(quote.Id);
        
        // Perform test
        Test.startTest();
        
        quote = [SELECT Id, TW1_Prazo__c FROM Quote WHERE Id = :quote.Id];
             
        ApexPages.currentPage().getparameters().put('id', quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(quote); 
        
        TW1_Ancar_SyncCotacaoController Sync = new TW1_Ancar_SyncCotacaoController(sc);
        Sync.sincronizarCotacao();     
        
        opportunity = [SELECT TW1_Possui_midia_inaugural__c FROM Opportunity WHERE Id = :opportunity.Id];
        
        //Verifica se MARCOU a checkbox TW1_Possui_midia_inaugural__c, 
        //pois o campo TW1_Valor_pacote_de_midia__c da cotação está COM valor
        System.assertEquals(true, opportunity.TW1_Possui_midia_inaugural__c);        
                        
        // exit the testing context
        Test.stopTest();        
    }
    
    @isTest public static void QuoteSyncVlrPctMidiaDesmarcado()
    {        
        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getLojaMock();
        opportunity.TW1_Possui_midia_inaugural__c = true;
        update opportunity;
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getLojaMock(opportunity.Id);
        quote.TW1_Valor_pacote_de_midia__c = 0;
        update quote;
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getLojaMock(quote.Id);

        // Perform test
        Test.startTest();
               
        //TW1_SyncCotacaoController
        ApexPages.currentPage().getparameters().put('id', quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(quote); 
        
        TW1_Ancar_SyncCotacaoController Sync = new TW1_Ancar_SyncCotacaoController(sc);
        Sync.sincronizarCotacao();     
        
        opportunity = [SELECT TW1_Possui_midia_inaugural__c FROM Opportunity WHERE Id = :opportunity.Id];
        
        //Verifica se DESMARCOU a checkbox TW1_Possui_midia_inaugural__c, 
        //pois o campo TW1_Valor_pacote_de_midia__c da cotação está SEM valor
        System.assertEquals(false, opportunity.TW1_Possui_midia_inaugural__c);
        
        // exit the testing context
        Test.stopTest();        
    }
    
    //Teste: Atualiza a oportunidade com o Prazo da cotação (se não for de loja)
    //Teste: Atualiza a oportunidade com a data início e fim cotação caso a oportunidade seja de Mall
    @isTest public static void QuoteSyncCotacaoMall()
    { 
        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getMallMock();
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getMallMock(opportunity.Id);   
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getMallMock(quote.Id);
        
        // Perform test
        Test.startTest();
        
        //TW1_SyncCotacaoController
        ApexPages.currentPage().getparameters().put('id', quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(quote); 
        
        TW1_Ancar_SyncCotacaoController Sync = new TW1_Ancar_SyncCotacaoController(sc);
        Sync.sincronizarCotacao();
        
        opportunity = [SELECT Id, TW1_Data_inicio_de_vigencia__c, TW1_Data_fim_de_vigencia__c, TW1_Prazo__c, 
                       RecordTypeId, TW1_VGL_AMM__c, TW1_VGL_total__c, TW1_Valor__c
                       FROM Opportunity WHERE Id = :opportunity.Id];
        
        //Verifica se atualizou a oportunidade com o prazo da cotação, VGL Total e VGL AMM
        System.assertEquals(quote.TW1_Prazo__c, opportunity.TW1_Prazo__c);
        System.assertEquals(quote.TW1_Valor__c, opportunity.TW1_Valor__c);
        
        //Verifica se a oportunidade pegou as datas início e fim da cotação
        System.assertEquals(quote.TW1_Data_inicio_de_vigencia__c, opportunity.TW1_Data_inicio_de_vigencia__c);
        System.assertEquals(quote.TW1_Data_fim_de_vigencia__c, opportunity.TW1_Data_fim_de_vigencia__c);
        
        // exit the testing context
        Test.stopTest();
    }
    
    //Teste: Se a oportunidade for de mídia, altera a(s) propriedade(s) para "reservada"
    @isTest public static void QuoteSyncCotacaoMidia()
    { 
        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getMidiaMock();
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getMidiaMock(opportunity.Id);
        Quote quote2 = TW1_Ancar_CotacaoMockGenerator_cls.getMidiaMock(opportunity.Id);
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getMidiaMock(quote.Id);
        TW1_Propriedade__c propriedade2 = TW1_Ancar_PropriedadeMockGenerator_cls.getMidiaMock(quote2.Id);
   
        // Perform test
        Test.startTest();
        
        System.debug('Passo 4: Enviando Cotação para a Visualforce: ' + quote);
        
        //TW1_SyncCotacaoController       
        ApexPages.currentPage().getparameters().put('id', quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(quote); 
        
        TW1_Ancar_SyncCotacaoController Sync = new TW1_Ancar_SyncCotacaoController(sc);
        Sync.sincronizarCotacao();
        
        opportunity = [SELECT Id, RecordTypeId, TW1_Prazo__c, TW1_Cotacao_sincronizada__c, TW1_VGL_AMM__c, TW1_VGL_total__c, TW1_Valor__c 
                       FROM Opportunity WHERE Id = :opportunity.Id];
        
        //Verifica se atualizou a oportunidade com o prazo da cotação, VGL Total e VGL AMM
        System.assertEquals(quote.TW1_Prazo__c, opportunity.TW1_Prazo__c);
        System.assertEquals(quote.TW1_Valor__c, opportunity.TW1_Valor__c);
        
        //Verifica se atualizou o campo TW1_Cotacao_sincronizada__c da oportunidade com o Id da cotação
        System.assertEquals(quote.Id, opportunity.TW1_Cotacao_sincronizada__c);
        
        propriedade = [SELECT Id, TW1_Status__c FROM TW1_Propriedade__c WHERE Id = :propriedade.Id];
        
        //Verifica se criou o calendário da propriedade
        List<TW1_Calendario_de_propriedades__c> calendario = 
            [SELECT TW1_Status__c FROM TW1_Calendario_de_propriedades__c WHERE TW1_Propriedade__c = :propriedade.Id];
        
        System.debug('calendario: ' + calendario);
        System.assert(calendario != null);
        System.assertEquals('Reservada', calendario[0].TW1_Status__c);
        
        //Sincroniza a outra cotação
        ApexPages.currentPage().getparameters().put('id', quote2.Id);
        sc = new ApexPages.StandardController(quote2); 
        
        Sync = new TW1_Ancar_SyncCotacaoController(sc);
        Sync.sincronizarCotacao();
        
        propriedade2 = [SELECT Id, TW1_Status__c FROM TW1_Propriedade__c WHERE Id = :propriedade2.Id];
        
        //Verifica se criou o calendário da propriedade da cotação atual
        List<TW1_Calendario_de_propriedades__c> calendario2 = 
            [SELECT TW1_Status__c FROM TW1_Calendario_de_propriedades__c WHERE TW1_Propriedade__c = :propriedade2.Id];
        
        System.assert(calendario != null);
        System.assertEquals('Reservada', calendario[0].TW1_Status__c);
        
        //Verifica se deletou o outro calendário
        calendario = [SELECT TW1_Status__c FROM TW1_Calendario_de_propriedades__c WHERE TW1_Propriedade__c = :propriedade.Id];
        System.assert(calendario.isEmpty());
        
        // exit the testing context
        Test.stopTest();
    }
    
    //Teste: Se a oportunidade for de feirão e a propriedade for de mídia, altera a(s) propriedade(s) para "Reservada"
    @isTest public static void QuoteSyncCotacaoFeirao()
    {
        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getFeiraoMock();
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getFeiraoMock(opportunity.Id);
        Quote quote2 = TW1_Ancar_CotacaoMockGenerator_cls.getFeiraoMock(opportunity.Id);
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getMidiaMock(quote.Id);
        TW1_Propriedade__c propriedade2 = TW1_Ancar_PropriedadeMockGenerator_cls.getMallMock(quote.Id);
        TW1_Propriedade__c propriedade3 = TW1_Ancar_PropriedadeMockGenerator_cls.getFeiraoMock(quote.Id);
        TW1_Propriedade__c propriedade4 = TW1_Ancar_PropriedadeMockGenerator_cls.getMidiaMock(quote2.Id);
         
        Test.startTest();
        
        //TW1_SyncCotacaoController       
        ApexPages.currentPage().getparameters().put('id', quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(quote); 
        
        TW1_Ancar_SyncCotacaoController Sync = new TW1_Ancar_SyncCotacaoController(sc);
        Sync.sincronizarCotacao();
        
        System.debug('Sincronizando a primeira cotação');
        quote = [SELECT Id, TW1_Prazo__c FROM Quote WHERE Id = :quote.Id];
        opportunity = [SELECT Id, RecordTypeId, TW1_Prazo__c FROM Opportunity WHERE Id = :opportunity.Id];
        
        //Verifica se atualizou o Prazo da oportunidade com o prazo da cotação
        System.assertEquals(quote.TW1_Prazo__c, opportunity.TW1_Prazo__c);
        
        TW1_Propriedade__c propriedadeSync = [SELECT Id FROM TW1_Propriedade__c WHERE Id = :propriedade.Id];
        TW1_Propriedade__c propriedade2Sync = [SELECT Id FROM TW1_Propriedade__c WHERE Id = :propriedade2.Id];
        TW1_Propriedade__c propriedade3Sync = [SELECT Id FROM TW1_Propriedade__c WHERE Id = :propriedade3.Id];
               
        //Verifica se criou o calendário da propriedade de mídia e feirão (1 e 3)
        List<TW1_Calendario_de_propriedades__c> calendario = 
            [SELECT TW1_Status__c, TW1_Propriedade__c FROM TW1_Calendario_de_propriedades__c WHERE TW1_Propriedade__c = :propriedadeSync.Id];
        
        System.debug('calendario: ' + calendario);
        System.assert(calendario.size() > 0);
        if (calendario.size() > 0)
        	System.assertEquals('Reservada', calendario[0].TW1_Status__c);
        
        List<TW1_Calendario_de_propriedades__c> calendario2 = 
            [SELECT TW1_Status__c, TW1_Propriedade__c FROM TW1_Calendario_de_propriedades__c WHERE TW1_Propriedade__c = :propriedade2Sync.Id];
        
        System.debug('calendario2: ' + calendario2);
        System.assert(calendario2.IsEmpty());
        
        List<TW1_Calendario_de_propriedades__c> calendario3 = 
            [SELECT TW1_Status__c FROM TW1_Calendario_de_propriedades__c WHERE TW1_Propriedade__c = :propriedade3Sync.Id];
        
        System.debug('calendario3: ' + calendario3);
        System.assert(calendario3 != null);
        System.assert(calendario3.size() > 0);
        if (calendario3 != null && calendario3.size() > 0)
        	System.assertEquals('Reservada', calendario3[0].TW1_Status__c);
        
        //Sincroniza a outra cotação
        ApexPages.currentPage().getparameters().put('id', quote2.Id);
        sc = new ApexPages.StandardController(quote2); 
        
        Sync = new TW1_Ancar_SyncCotacaoController(sc);
        Sync.sincronizarCotacao();
        
        System.debug('Sincronizando a segunda cotação');
        
        TW1_Propriedade__c propriedade4Sync = [SELECT Id, TW1_Status__c FROM TW1_Propriedade__c WHERE Id = :propriedade4.Id];
        
        //Verifica se criou o calendário da propriedade da cotação atual
        List<TW1_Calendario_de_propriedades__c> calendario4 = 
            [SELECT TW1_Status__c FROM TW1_Calendario_de_propriedades__c WHERE TW1_Propriedade__c = :propriedade4Sync.Id];
        
        System.debug('calendario4: ' + calendario3);
        System.assert(calendario4 != null);
        System.assert(calendario4.size() > 0);
        if (calendario4 != null && calendario4.size() > 0)
        	System.assertEquals('Reservada', calendario4[0].TW1_Status__c);
        
        //Verifica se deletou os outros calendários
        calendario = [SELECT TW1_Status__c FROM TW1_Calendario_de_propriedades__c WHERE TW1_Propriedade__c = :propriedadeSync.Id];
        System.assert(calendario.isEmpty());
        
        calendario3 = [SELECT TW1_Status__c FROM TW1_Calendario_de_propriedades__c WHERE TW1_Propriedade__c = :propriedade3Sync.Id];
        System.assert(calendario.isEmpty());
        
        // exit the testing context
        Test.stopTest();
    }
    
    @isTest public static void QuoteSyncFlagSyncro()
    {
        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getMidiaMock();
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getMidiaMock(opportunity.Id);
        Quote quoteAction = TW1_Ancar_CotacaoMockGenerator_cls.getMidiaMock(opportunity.Id);
        quoteAction.TW1_Prazo__c = 5;
        update quoteAction;
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getMidiaMock(quote.Id);
        TW1_Propriedade__c propriedade2 = TW1_Ancar_PropriedadeMockGenerator_cls.getMidiaMock(quoteAction.Id);
        
        // Perform test
        Test.startTest();
        
        //Sincroniza a primeira cotação
        System.debug('Sincroniza a primeira cotação');
        ApexPages.currentPage().getparameters().put('id', quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(quote); 
        
        TW1_Ancar_SyncCotacaoController Sync = new TW1_Ancar_SyncCotacaoController(sc);
        Sync.sincronizarCotacao();    
              
        //Sincroniza a segunda cotação
        System.debug('Sincroniza a segunda cotação');
        ApexPages.currentPage().getparameters().put('id', quoteAction.Id);
        sc = new ApexPages.StandardController(quoteAction); 
        
        Sync = new TW1_Ancar_SyncCotacaoController(sc);
        Sync.sincronizarCotacao();
        
        quote = [SELECT Id, TW1_Sincronizada__c FROM Quote WHERE Id = :quote.Id];
        quoteAction = [SELECT Id, TW1_Sincronizada__c, TW1_Prazo__c FROM Quote WHERE Id = :quoteAction.Id];
        
        opportunity = [SELECT Id, RecordTypeId, TW1_Prazo__c FROM Opportunity WHERE Id = :opportunity.Id];
        
        //Verifica se atualizou a checkbox da primeira cotação para desmarcada
        System.assertEquals(false, quote.TW1_Sincronizada__c);
        
        //Verifica se atualizou a checkbox da segunda cotação que chamou a controller para marcada
        System.assertEquals(true, quoteAction.TW1_Sincronizada__c);
        
        System.assertEquals(5, opportunity.TW1_Prazo__c);
        
        quoteAction.TW1_Prazo__c = 1;
        update quoteAction;
        
        //Tenta sincronizar novamente a segunda cotação
        ApexPages.currentPage().getparameters().put('id', quoteAction.Id);
        sc = new ApexPages.StandardController(quoteAction); 
        
        Sync = new TW1_Ancar_SyncCotacaoController(sc);
        Sync.sincronizarCotacao();
        
        opportunity = [SELECT Id, RecordTypeId, TW1_Prazo__c FROM Opportunity WHERE Id = :opportunity.Id];
        
        //Verifica se não atualizou o Prazo da Oportunidade, pois não é possível sincronizar a mesma cotação duas vezes.
        System.assertEquals(5, opportunity.TW1_Prazo__c);
        
        // exit the testing context
        Test.stopTest();        
    }
    
    @isTest public static void QuoteCantSyncStageOpportunity()
    {        
		Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getMallMock();
        opportunity.StageName = 'Arquivada';        
        update opportunity;
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getMallMock(opportunity.Id);   
                
        // Perform test
        Test.startTest();
        
        //TW1_SyncCotacaoController       
        ApexPages.currentPage().getparameters().put('id', quote.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(quote); 
        
        TW1_Ancar_SyncCotacaoController Sync = new TW1_Ancar_SyncCotacaoController(sc);
        Sync.sincronizarCotacao();     
        
        opportunity = [SELECT Id, TW1_Prazo__c, TW1_Data_inicio_de_vigencia__c, TW1_Data_fim_de_vigencia__c, 
                       TW1_Possui_midia_inaugural__c, TW1_Cotacao_sincronizada__c 
                       FROM Opportunity WHERE Id = :opportunity.Id];
        
        quote = [SELECT Id, TW1_Sincronizada__c FROM Quote WHERE Id = :quote.Id];
        
        //Verifica se NÃO sincronizou a cotação
        System.assertEquals(false, quote.TW1_Sincronizada__c);
        System.assertEquals(null, opportunity.TW1_Cotacao_sincronizada__c);
        
        // exit the testing context
        Test.stopTest();
    }
}