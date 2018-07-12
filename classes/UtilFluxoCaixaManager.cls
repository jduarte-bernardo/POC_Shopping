/******************************************************************************************************
Author  	: Leonardo Façanha
Date    	: 05/01/2017
Purpose 	: Api Rest para buscar informações do fluxo de Caixa para a aplicação de promoção
*******************************************************************************************************/
@RestResource(urlMapping='/UtilFluxoCaixa/*')
global with sharing class UtilFluxoCaixaManager {
    
    @HttpGet
    global static responseWrapper getStandTerminalPorId(){
        RestRequest req = RestContext.request;
        responseWrapper rew = new responseWrapper();
        
        String vaShoppingId = req.params.get('IdShopping');
        String vaStandId = req.params.get('IdStand');
        
        if(vaShoppingId != null && vaShoppingId != '' && vaShoppingId != 'null'){
            rew.Stands = [Select Id,Name From TW1_Stand__c where TW1_Shopping__c =:vaShoppingId];
            Return rew;   
        }
        else{
            rew.Terminais = [Select Id,Name,TW1_Stand__c From TW1_Terminal__c where TW1_Stand__c =:vaStandId];
            Return rew;               
        }        
    }
    
    
    global class responseWrapper
    {
        public List<TW1_Stand__c> Stands;
        public List<TW1_Terminal__c> Terminais;
    }   
}