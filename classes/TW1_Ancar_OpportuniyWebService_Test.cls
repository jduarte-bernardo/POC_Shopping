@isTest
private class TW1_Ancar_OpportuniyWebService_Test {
    @isTest static void testAtualizaStatusProposta() 
    {        
        Opportunity oportunidade = TW1_Ancar_OpportunityMockGenerator_cls.getLojaMock();
        
        TW1_OpportunityWebService.WebserviceResponse res = new TW1_OpportunityWebService.WebserviceResponse();
        res = TW1_OpportunityWebService.atualizaStatusProposta(oportunidade.Id, 'etapa', 'descricao etapa');
        
        oportunidade = [SELECT TW1_Etapa__c, TW1_Descricao_da_etapa__c FROM Opportunity WHERE Id = :oportunidade.Id];
        System.assertEquals('etapa', oportunidade.TW1_Etapa__c);
        System.assertEquals('descricao etapa', oportunidade.TW1_Descricao_da_etapa__c);
    }
    
    @isTest static void atualizaStatusProposta_IdInexistente()
    {
        TW1_OpportunityWebService.WebserviceResponse res = new TW1_OpportunityWebService.WebserviceResponse();
        res = TW1_OpportunityWebService.atualizaStatusProposta('123', 'etapa', 'descricao etapa');
        
        System.assertEquals('Fail', res.result);
    }
    
    @isTest static void testAtualizaValoresAprovadosComite ()
    {
        Opportunity oportunidade = TW1_Ancar_OpportunityMockGenerator_cls.getLojaMock();
        
        TW1_OpportunityWebService.WebserviceResponse res = new TW1_OpportunityWebService.WebserviceResponse();
        res = TW1_OpportunityWebService.atualizaValoresAprovadosComite(oportunidade.Id, 1.12, 2.12, 3.12, 5);
        
        oportunidade = [SELECT TW1_VGL_total__c, TW1_ABL_faturada__c, TW1_Comissao__c, TW1_Quantidade_de_propriedades__c
                           FROM Opportunity WHERE Id = :oportunidade.Id];
        
        System.assertEquals(1.12, oportunidade.TW1_VGL_total__c);
        System.assertEquals(2.12, oportunidade.TW1_ABL_faturada__c);
        System.assertEquals(3.12, oportunidade.TW1_Comissao__c);
        System.assertEquals(5, oportunidade.TW1_Quantidade_de_propriedades__c);
    }
    
    @isTest static void atualizaValoresAprovadosComite_IdInexistente()
    {
        TW1_OpportunityWebService.WebserviceResponse res = new TW1_OpportunityWebService.WebserviceResponse();
        res = TW1_OpportunityWebService.atualizaValoresAprovadosComite('123', 1, 1, 1, 1);
        
        System.assertEquals('Fail', res.result);
    }
    
    @isTest static void atualizaPropostaGeral()
    {
        Opportunity oportunidade = TW1_Ancar_OpportunityMockGenerator_cls.getLojaMock();
        
        TW1_OpportunityWebService.WebserviceResponse res = new TW1_OpportunityWebService.WebserviceResponse();
        res = TW1_OpportunityWebService.atualizaPropostaGeral(oportunidade.Id, 'etapa 1', 'descricao etapa 1', 1.12, 2.12, 3.12, 5);
        
        oportunidade = [SELECT TW1_Etapa__c, TW1_Descricao_da_etapa__c, TW1_VGL_total__c, TW1_ABL_faturada__c, 
                           TW1_Comissao__c, TW1_Quantidade_de_propriedades__c
                           FROM Opportunity WHERE Id = :oportunidade.Id];
        
        System.assertEquals('etapa 1', oportunidade.TW1_Etapa__c);
        System.assertEquals('descricao etapa 1', oportunidade.TW1_Descricao_da_etapa__c);
        System.assertEquals(1.12, oportunidade.TW1_VGL_total__c);
        System.assertEquals(2.12, oportunidade.TW1_ABL_faturada__c);
        System.assertEquals(3.12, oportunidade.TW1_Comissao__c);
        System.assertEquals(5, oportunidade.TW1_Quantidade_de_propriedades__c); 
    }
    
    @isTest static void atualizaPropostaGeral_IdInexistente()
    {
        TW1_OpportunityWebService.WebserviceResponse res = new TW1_OpportunityWebService.WebserviceResponse();
        res = TW1_OpportunityWebService.atualizaPropostaGeral('123', '', '', 1, 1, 1, 1);
        
        System.assertEquals('Fail', res.result);
    }
    
    @isTest static void testInsereIdProposta ()
    {
        Opportunity oportunidade = TW1_Ancar_OpportunityMockGenerator_cls.getLojaMock();
        
        TW1_OpportunityWebService.WebserviceResponse res = new TW1_OpportunityWebService.WebserviceResponse();
        res = TW1_OpportunityWebService.insereIdProposta(oportunidade.Id, '12345');
        
        oportunidade = [SELECT TW1_Id_VS__c FROM Opportunity WHERE Id = :oportunidade.Id];
        System.assertEquals('12345', oportunidade.TW1_Id_VS__c);
    }
    
    @isTest static void insereIdProposta_IdInexistente()
    {
        TW1_OpportunityWebService.WebserviceResponse res = new TW1_OpportunityWebService.WebserviceResponse();
        res = TW1_OpportunityWebService.InsereIdProposta('123', '');
        
        System.assertEquals('Fail', res.result);
    }
    
    @isTest static void atualizaEstagioPropostaIntegrada ()
    {
        Opportunity oportunidade = TW1_Ancar_OpportunityMockGenerator_cls.getLojaMock();
        
        TW1_OpportunityWebService.WebserviceResponse res = new TW1_OpportunityWebService.WebserviceResponse();
        res = TW1_OpportunityWebService.atualizaEstagioProposta(oportunidade.Id, true, '');
        
        oportunidade = [SELECT StageName FROM Opportunity WHERE Id = :oportunidade.Id];
        System.assertEquals('Integrada', oportunidade.StageName);
    }
    
    @isTest static void atualizaEstagioPropostaErro ()
    {
        Opportunity oportunidade = TW1_Ancar_OpportunityMockGenerator_cls.getLojaMock();
        
        TW1_OpportunityWebService.WebserviceResponse res = new TW1_OpportunityWebService.WebserviceResponse();
        res = TW1_OpportunityWebService.atualizaEstagioProposta(oportunidade.Id, false, 'Erro teste');
        
        oportunidade = [SELECT StageName, TW1_Descricao_erro_integracao__c FROM Opportunity WHERE Id = :oportunidade.Id];
        System.assertEquals('Erro de integração', oportunidade.StageName);
        System.assertEquals('Erro teste', oportunidade.TW1_Descricao_erro_integracao__c);
    }
    
    @isTest static void atualizaEstagioProposta_IdInexistente()
    {
        TW1_OpportunityWebService.WebserviceResponse res = new TW1_OpportunityWebService.WebserviceResponse();
        res = TW1_OpportunityWebService.atualizaEstagioProposta('123', true, '');
        
        System.assertEquals('Fail', res.result);
    }
}