@RestResource(urlMapping='/Shopping/*')
global with sharing class ShoppingManager {
	@HttpGet
    global static List<TW1_Shopping__c> getShoppings(){
        List<TW1_Shopping__c> listaShoppings = 
            [
                SELECT Id, Name
                FROM TW1_Shopping__c
            ];
        
        return listaShoppings;
    }
}