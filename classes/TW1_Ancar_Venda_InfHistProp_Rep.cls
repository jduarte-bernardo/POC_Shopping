public class TW1_Ancar_Venda_InfHistProp_Rep {
    public list<TW1_Propriedade__c> ListarInformacoesHistoricas(String paRecordId, list<String> paInformacaoDaPropriedade)
    {
        try{
            /*
            list<TW1_Informacoes_historicas__c> vaInformacaoDaPropriedade =[
                SELECT
                id,
                TW1_Propriedade__r.Name,
                TW1_Propriedade__r.TW1_area_m2__c,
                TW1_Propriedade__r.TW1_Piso__c,
                TW1_AMM_faturado__c,
                TW1_Propriedade__r.TW1_Condominio__c,
                TW1_FPP_Total_faturado__c,
                TW1_Propriedade__r.TW1_Res_Perata__c,
                TW1_Propriedade__r.TW1_Localizacao__c,
                TW1_Propriedade__r.TW1_IPTU__c,
                TW1_Propriedade__r.TW1_Valor_TR__c,
                TW1_Propriedade__r.TW1_Observacao__c,
                TW1_Propriedade__r.TW1_AMM__c,
                TW1_Propriedade__r.TW1_Fundo__c
                FROM
                TW1_Informacoes_historicas__c
                WHERE 
                TW1_Propriedade__C IN:paInformacaoDaPropriedade
            ];
            */
            
            list<TW1_Propriedade__c> vaInformacaoDaPropriedade =[
                SELECT
                id,
                Name,
                TW1_area_m2__c,
                TW1_Piso__c,
                //TW1_AMM_faturado__c,
                TW1_Condominio__c,
                //TW1_FPP_Total_faturado__c,
                TW1_Res_Perata__c,
                TW1_Localizacao__c,
                TW1_IPTU__c,
                TW1_Valor_TR__c,
                TW1_Observacao__c,
                TW1_AMM__c,
                TW1_Fundo__c
                FROM
                TW1_Propriedade__c
                WHERE 
                Id IN:paInformacaoDaPropriedade
            ];
            
            if(vaInformacaoDaPropriedade.size() >= 1){
                return vaInformacaoDaPropriedade;
            }else{
                return null;
            }
            
        }catch(Exception ex){
            return null;
        }
    }
}