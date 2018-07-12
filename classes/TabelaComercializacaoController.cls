public class TabelaComercializacaoController {

	@AuraEnabled
    public static List<TW1_Propriedade__c> getLucsByShopping(String idShopping){
        List<TW1_Propriedade__c> lucs = new List<TW1_Propriedade__c>();
        
        for(TW1_Propriedade__c luc : [
            	SELECT
            		Name,
                	TW1_Piso__c,
                	TW1_Status_da_prospecao__c,
                	TW1_Status__c,
                	TW1_area_m2__c,
            		TW1_AMM__c,
            		TW1_AMM_M2__c,
                	TW1_Fundo__c,
                	TW1_OTN__c,
                	TW1_AMM_OTN__c,
                	TW1_Valor_TR__c,
                	TW1_Condominio__c,
                	TW1_Nota_de_d_bito_ou_CTO__c,
                	TW1_RES_m2__c,
                	TW1_Res_Perata__c,
                	TW1_IPTU__c,
                	TW1_Observacao__c
                FROM TW1_Propriedade__c
                WHERE TW1_Shopping__c = :idShopping
            	And RecordType.Name = 'Propriedade Loja'
            	AND (TW1_Status__c = 'Vaga' OR TW1_Status__c = 'Repasse')
        ])
        {
            luc.TW1_IPTU__c = (luc.TW1_IPTU__c == null ? 0:luc.TW1_IPTU__c);
            luc.TW1_AMM__c = (luc.TW1_AMM__c == null ? 0:luc.TW1_AMM__c);
            luc.TW1_Condominio__c = (luc.TW1_Condominio__c == null ? 0:luc.TW1_Condominio__c);
            luc.TW1_Fundo__c = (luc.TW1_Fundo__c == null ? 0:luc.TW1_Fundo__c);
            luc.TW1_Nota_de_d_bito_ou_CTO__c = (luc.TW1_Nota_de_d_bito_ou_CTO__c == null ? 0:luc.TW1_Nota_de_d_bito_ou_CTO__c);
            luc.TW1_OTN__c = (luc.TW1_OTN__c == null ? 0:luc.TW1_OTN__c);
            luc.TW1_Valor_TR__c = (luc.TW1_Valor_TR__c == null ? 0:luc.TW1_Valor_TR__c);
            
            lucs.add(luc);
        }
        
        return lucs;
    }
    
    @AuraEnabled
    public static List<TW1_Shopping__c> getListaShoppings(String strShopping){
        List<TW1_Shopping__c> listaShoppings = new List<TW1_Shopping__c>();
        
        if(strShopping.length() <= 1){
            String strShoppingLike = '%' + strShopping + '%';
            listaShoppings = [SELECT Id, Name FROM TW1_Shopping__c WHERE Name LIKE :strShoppingLike];
        }else{
            List<List<SObject>> searchResult = [FIND :strShopping IN Name Fields RETURNING TW1_Shopping__c(Id, Name)];
        	listaShoppings = searchResult[0];
        }
        
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