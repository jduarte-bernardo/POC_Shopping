@isTest
public class TW1_JSONIntegracaoSOQL_Test {
    
    public static TW1_Ancar_wrapRecodtypes rec = new TW1_Ancar_wrapRecodtypes();
    
    @isTest(SeeAllData=true)
    public static void testarClasseIntegracaoSOQL()
    {
        Test.startTest();

        Opportunity opp = mockOpp();
        
        String json = '';
        try
        {
			json = TW1_Ancar_IntegracaoSOQL.serializarObjetos(opp);
            System.debug('json: ' + json);
        }
        catch (Exception e) 
        {}
        
        System.assert(json != '');
        
        Test.stopTest();
    }
    
    private static Opportunity mockOpp()
    {       
        //Oportunidade
		Opportunity opp = TW1_Ancar_OpportunityMockGenerator_cls.getLojaMock();
        
        //Cotação
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getLojaMock(opp.Id);
        quote.TW1_Sincronizada__c = true;
        update quote;
        System.debug('Quote: ' + quote);
        
        //Propriedade
        TW1_Propriedade__c prop = TW1_Ancar_PropriedadeMockGenerator_cls.getLojaMock(quote.Id);
        System.debug('Propriedade: ' + prop);
         
        return opp;
    }
}