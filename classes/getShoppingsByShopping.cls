public with sharing class getShoppingsByShopping {
	@AuraEnabled
    public static List<TW1_Shopping__c> getShoppingsByShopping(String strShopping){
        List<TW1_Informacoes_historicas__c> listaInformacoesHistoricas = new List<TW1_Informacoes_historicas__c>();
        
        if(strShopping.length() <= 1){
            String strShoppingLike = '%' + strShopping + '%';
            listaInformacoesHistoricas = [SELECT TW1_Shopping__c FROM TW1_Informacoes_historicas__c WHERE TW1_Shopping__r.Name LIKE :strShoppingLike ];
        }else{
            List<List<SObject>> searchResult = [FIND :strShopping IN Name Fields RETURNING TW1_Shopping__c(Id, Name)];
        	List<TW1_Shopping__c> listaShoppings = searchResult[0];
            listaInformacoesHistoricas = [SELECT TW1_Shopping__c FROM TW1_Informacoes_historicas__c WHERE TW1_Shopping__c IN :listaShoppings ];
        }
        
        
        List<Id> listaShoppingsIds = new List<Id>();
        for(TW1_Informacoes_historicas__c informacaoHistorica : listaInformacoesHistoricas){
            listaShoppingsIds.add(informacaoHistorica.TW1_Shopping__c);
        }
        
        List<TW1_Shopping__c> listaShoppings = [SELECT Id, Name FROM TW1_Shopping__c WHERE Id IN :listaShoppingsIds];
        
        return listaShoppings;
    }
    
    @AuraEnabled
    public static TW1_Shopping__c getShopping(String strShopping){
        List<TW1_Shopping__c> listaShoppingsEqual = [SELECT Name FROM TW1_Shopping__c WHERE Name = :strShopping];
        
        if(listaShoppingsEqual.size() >= 1){
            return listaShoppingsEqual.get(0);
        }else{
            String strShoppingLike = '%' + strShopping + '%';
            List<TW1_Shopping__c> listaShoppingsLike = [SELECT Name FROM TW1_Shopping__c WHERE Name LIKE :strShoppingLike ];
            
            if(listaShoppingsLike.size() >= 1){
                List<String> listaShoppingsLikeStr = new List<String>();
                for(TW1_Shopping__c shoppingLike : listaShoppingsLike){
                    listaShoppingsLikeStr.add(shoppingLike.Name);
                }
                Integer moreSimilarShoppingIndex = Util.getClosestString(strShopping, listaShoppingsLikeStr);
                
                return listaShoppingsLike.get(moreSimilarShoppingIndex);
            }else{
                List<TW1_Shopping__c> listaShoppingsAll = [SELECT Name FROM TW1_Shopping__c];
                
                List<String> listaShoppingsAllStr = new List<String>();
                for(TW1_Shopping__c shoppingAll : listaShoppingsAll){
                    listaShoppingsAllStr.add(shoppingAll.Name);
                }
                
                Integer moreSimilarShoppingIndex = Util.getClosestString(strShopping, listaShoppingsAllStr);
                
                return listaShoppingsAll.get(moreSimilarShoppingIndex);
                
            }
        }
    }
}