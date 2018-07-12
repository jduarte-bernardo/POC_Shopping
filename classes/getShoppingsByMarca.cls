public with sharing class getShoppingsByMarca {
    
	@AuraEnabled
    public static Map<Id,Account> GetMapAccuntsIds(String strMarca)
    {
        List<Account> marca = getListMarca(strMarca);
		Map<Id,Account> accountsIds = new Map<Id,Account>(marca);
        System.debug('001 '+ accountsIds);
		return accountsIds;
    }
    
    @AuraEnabled
    public static List<TW1_Shopping__c> getShoppingsByMarca(String strMarca){
   
        List<Account> marca = getListMarca(strMarca);
       	
        If(marca.size() >= 1 ){
        
        Map<Id,Account> accountsIds = new Map<Id,Account>(marca);
       
        List<TW1_Informacoes_historicas__c> listaInformacoesHistoricas = [SELECT TW1_Shopping__c FROM TW1_Informacoes_historicas__c WHERE TW1_Marca__c IN : accountsIds.keySet() ];
        
        Set<Id> listaShoppingsIds = new Set<Id>();
 		
        for(TW1_Informacoes_historicas__c informacaoHistorica : listaInformacoesHistoricas){
            listaShoppingsIds.add(informacaoHistorica.TW1_Shopping__c);
        }
        
        List<TW1_Shopping__c> listaShoppings = [SELECT Id, Name FROM TW1_Shopping__c WHERE Id IN :listaShoppingsIds];
        
        return listaShoppings;
        
         }else{
            return new List<TW1_Shopping__c>();
        }
    }
    
    @AuraEnabled
    public static List<Account> getListMarca(String strMarca){
        List<Account> listaMarcasEqual = [SELECT Name FROM Account WHERE RecordType.Name='Marca' And Name = :strMarca];
        System.debug('003 '+ listaMarcasEqual);
        if(listaMarcasEqual.size() >= 1){
            return listaMarcasEqual;
        }else{
            String strMarcaLike = '%' + strMarca + '%';
            List<Account> listaMarcasLike = [SELECT Name FROM Account WHERE RecordType.Name='Marca' And Name LIKE :strMarcaLike ];
            
            if(listaMarcasLike.size() >= 1){
                return listaMarcasLike;
            }else{
                return new List<Account>();
                
            }
        }
    }
    @AuraEnabled
    public static Account getMarca(String strMarca){
        List<Account> listaMarcasEqual = [SELECT Name FROM Account WHERE RecordType.Name='Marca' And Name = :strMarca];
        
        if(listaMarcasEqual.size() >= 1){
            return listaMarcasEqual.get(0);
        }else{
            String strMarcaLike = '%' + strMarca + '%';
            List<Account> listaMarcasLike = [SELECT Name FROM Account WHERE RecordType.Name='Marca' And Name LIKE :strMarcaLike ];
            
            if(listaMarcasLike.size() >= 1){
                return listaMarcasLike.get(0);
            }else{
                return new Account();
                
            }
        }
    }
}