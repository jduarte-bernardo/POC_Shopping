public class getLucsByLuc {
	@AuraEnabled
    public static List<TW1_Propriedade__c> getLucsByLuc(String strLuc, String idShopping){
        TW1_Propriedade__c luc = getLuc(strLuc, idShopping);
        
        List<TW1_Informacoes_historicas__c> listaInformacoesHistoricas = [SELECT TW1_Propriedade__c FROM TW1_Informacoes_historicas__c WHERE TW1_Propriedade__c = :luc.Id AND TW1_Shopping__c = :idShopping];
        
        List<Id> listaLucsIds = new List<Id>();
        for(TW1_Informacoes_historicas__c informacaoHistorica : listaInformacoesHistoricas){
            listaLucsIds.add(informacaoHistorica.TW1_Propriedade__c);
        }
        
        List<TW1_Propriedade__c> listaLucs = [SELECT Id, Name FROM TW1_Propriedade__c WHERE Id IN :listaLucsIds];
        
        return listaLucs;
    }
    
    @AuraEnabled
    public static TW1_Propriedade__c getLuc(String strLuc, String idShopping){
        List<TW1_Propriedade__c> listaLucsEqual = [SELECT Name FROM TW1_Propriedade__c WHERE Name = :strLuc AND TW1_Shopping__c = :idShopping];
        
        if(listaLucsEqual.size() >= 1){
            return listaLucsEqual.get(0);
        }else{
            String strLucLike = '%' + strLuc + '%';
            List<TW1_Propriedade__c> listaLucsLike = [SELECT Name FROM TW1_Propriedade__c WHERE Name LIKE :strLucLike AND TW1_Shopping__c = :idShopping];
            
            if(listaLucsLike.size() >= 1){
                List<String> listaLucsLikeStr = new List<String>();
                for(TW1_Propriedade__c lucLike : listaLucsLike){
                    listaLucsLikeStr.add(lucLike.Name);
                }
                Integer moreSimilarLucIndex = Util.getClosestString(strLuc, listaLucsLikeStr);
                
                return listaLucsLike.get(moreSimilarLucIndex);
            }else{
                List<TW1_Propriedade__c> listaLucsAll = [SELECT Name FROM TW1_Propriedade__c WHERE TW1_Shopping__c = :idShopping];
                
                List<String> listaLucsAllStr = new List<String>();
                for(TW1_Propriedade__c lucAll : listaLucsAll){
                    listaLucsAllStr.add(lucAll.Name);
                }
                
                Integer moreSimilarLucIndex = Util.getClosestString(strLuc, listaLucsAllStr);
                
                return listaLucsAll.get(moreSimilarLucIndex);
                
            }
        }
    }
}