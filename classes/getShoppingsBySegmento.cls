public with sharing class getShoppingsBySegmento {
	@AuraEnabled
    public static List<TW1_Shopping__c> getShoppingsBySegmento(String strSegmento){
       
        TW1_Plano_de_mix__c segmento = getSegmento(strSegmento);
        
        List<TW1_Informacoes_historicas__c> listaInformacoesHistoricas = 
            [
                SELECT TW1_Shopping__c
                FROM TW1_Informacoes_historicas__c
                WHERE TW1_Marca__c IN (
                	SELECT TW1_Marca__c
                    FROM TW1_JuctionMarcaPlanoMix__c
                    WHERE TW1_Plano_de_mix__c = :segmento.Id
                )
            ];
        
        List<Id> listaShoppingsIds = new List<Id>();
        for(TW1_Informacoes_historicas__c informacaoHistorica : listaInformacoesHistoricas){
            listaShoppingsIds.add(informacaoHistorica.TW1_Shopping__c);
        }
        
        List<TW1_Shopping__c> listaShoppings = [SELECT Id, Name FROM TW1_Shopping__c WHERE Id IN :listaShoppingsIds];
        
        return listaShoppings;
    }
    
    @AuraEnabled
    public static TW1_Plano_de_mix__c getSegmento(String strSegmento){

        List<TW1_Plano_de_mix__c> listaSegmentosEqual = [SELECT Name FROM TW1_Plano_de_mix__c WHERE Ramo_de_atividade__c = :strSegmento];

        if(listaSegmentosEqual.size() >= 1){
            return listaSegmentosEqual.get(0);
        }else{
            String strSegmentoLike = '%' + strSegmento + '%';
            List<TW1_Plano_de_mix__c> listaSegmentosLike = [SELECT Name,Ramo_de_atividade__c FROM TW1_Plano_de_mix__c WHERE Ramo_de_atividade__c LIKE :strSegmentoLike ];
            
            if(listaSegmentosLike.size() >= 1){
                List<String> listaSegmentosLikeStr = new List<String>();
                for(TW1_Plano_de_mix__c segmentoLike : listaSegmentosLike){
                    listaSegmentosLikeStr.add(segmentoLike.Ramo_de_atividade__c);
                }
                Integer moreSimilarSegmentoIndex = Util.getClosestString(strSegmento, listaSegmentosLikeStr);
                
                return listaSegmentosLike.get(moreSimilarSegmentoIndex);
            }else{
                List<TW1_Plano_de_mix__c> listaSegmentosAll = [SELECT Ramo_de_atividade__c FROM TW1_Plano_de_mix__c];
                
                List<String> listaSegmentosAllStr = new List<String>();
                for(TW1_Plano_de_mix__c segmentoAll : listaSegmentosAll){
                    listaSegmentosAllStr.add(segmentoAll.Ramo_de_atividade__c);
                }
                
                Integer moreSimilarSegmentoIndex = Util.getClosestString(strSegmento, listaSegmentosAllStr);
                
                return listaSegmentosAll.get(moreSimilarSegmentoIndex);
                
            }
        }
    }
}