@istest
private class Tw1_Ancar_ShoppingManager_tst {
	
     static testMethod void testdoShopping() {
       
        TW1_Shopping__c shopping = new TW1_Shopping__c();
    		shopping.TW1_SGL_Empreendimento__c = 'BPS';
        	shopping.Name = 'Barra Shopping';
        
         Insert shopping;

        // COMEÇA O TESTE
        string nome= '';
        string Cpf = '';
        
        //+'&nome='+Nome+'&cpf='+Cpf

        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Shopping';
        
        //request.addParameter('Id', acc.Id);
        //request.addParameter('IdCliente', acc.Id);
        //request.addParameter('Valor', '200');
        
        //request.addParameter('IdShopping', shopping.Id);
        //request.addParameter('IdOperador', operador.Id);
        //request.addParameter('SenhaOperaodor', operador.TW1_Senha__c);

        request.httpMethod = 'GET';
		
        RestContext.request = request;
         System.debug(RestContext.request);
        
        ShoppingManager.getShoppings();

    }
}