public class TW1_Ancar_Venda_Oportunidade_Rep {
    
    /// Buscar oportunidade pelo ID
    public Opportunity GetOpportunityById(string idOpportunity){
        system.debug('Consultando oportunidade com o ID: ' + idOpportunity);
        List<Opportunity> vaOpportunitys = [select id,name,TW1_Shopping__c,TW1_OpportunityRecordTypeName__c, recordtype.name from Opportunity WHERE id=:idOpportunity limit 1];
        system.debug('Retorno da consulta Consultando oportunidade com o ID: ' + idOpportunity + ' retorno: ' + vaOpportunitys);
        
        if(vaOpportunitys.size() <1)
            return null;
        else
            return vaOpportunitys[0];        
    }
}