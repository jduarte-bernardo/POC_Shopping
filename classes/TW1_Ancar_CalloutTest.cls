@isTest
public with sharing class TW1_Ancar_CalloutTest {
       
    @isTest
    public static void testCallout()
    {   
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new TW1_Ancar_CalloutMock_cls());
        
        // Call method to test.
        // This causes a fake response to be sent from TW1_CalloutMock_cls
        HttpResponse res = Tw1_Ancar_CalloutUtils_cls.getInfoFromExternalService(false, false, false, false);        
        
    	// Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        
        String actualValue = res.getBody();
        String expectedValue = '{"bairro": "Piratininga", "cidade": "Niter\u00f3i", "logradouro": "Rua Delfina de Jesus (Lot Sto Ant\u00f4nio)", "estado_info": {"area_km2": "43.781,566", "codigo_ibge": "33", "nome": "Rio de Janeiro"}, "cep": "24350326", "cidade_info": {"area_km2": "133,919", "codigo_ibge": "3303302"}, "estado": "RJ"}';
        System.debug('actualValue: ' + actualValue);
        System.debug('expectedValue: ' + expectedValue);
        
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        
        //Null Method Parameter
        res = Tw1_Ancar_CalloutUtils_cls.getInfoFromExternalService(true, false, false, false); 
        System.assertEquals(null, res);
        
        //Empty Method Parameter
        res = Tw1_Ancar_CalloutUtils_cls.getInfoFromExternalService(false, true, false, false);  
        System.assertEquals(null, res);
        
        //Null Method Endpoint
        res = Tw1_Ancar_CalloutUtils_cls.getInfoFromExternalService(false, false, true, false); 
        System.assertEquals(null, res);
        
        //Empty Method Endpoint
        res = Tw1_Ancar_CalloutUtils_cls.getInfoFromExternalService(false, false, false, true); 
        System.assertEquals(null, res);
    }
}