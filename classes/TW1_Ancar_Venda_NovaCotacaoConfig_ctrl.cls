public with sharing class TW1_Ancar_Venda_NovaCotacaoConfig_ctrl {
    
    @AuraEnabled
    public static string getObjectById(string opportunityId){
        
        /// Repositório de oportunidade
        TW1_Ancar_Venda_Oportunidade_Rep oportunidadeRepository = new TW1_Ancar_Venda_Oportunidade_Rep();
        /// Repositório de cotação
        TW1_Ancar_Venda_Cotacao_Rep cotacaoRepository = new TW1_Ancar_Venda_Cotacao_Rep();   
        
        String listJson = '';
        
        if(opportunityId != null || opportunityId !=''){
            quote cotacao = cotacaoRepository.GetCotacaoById(opportunityId);
            Opportunity opp = oportunidadeRepository.GetOpportunityById(opportunityId);   
            System.debug(cotacao);
            NovaCotacaoAppConfigDto dto = new NovaCotacaoAppConfigDto();
            
            if(opp == null){
                System.debug(cotacao.TW1_QuoteRecordTypeName__c);
                dto.TipoRegistro = cotacao.TW1_QuoteRecordTypeName__c.replace('Cotação de ','Oportunidade de ');
                dto.TipoChamada = 'Clone';
            }else{
                dto.TipoRegistro = opp.TW1_OpportunityRecordTypeName__c;
                dto.TipoChamada = 'Novacotacao';
            }
            
            listJson = JSON.serialize((Object)dto);
        }
        System.debug('leo '+listJson);
        return listJson;
    }
    
    public class NovaCotacaoAppConfigDto
    {	@AuraEnabled
        public string TipoChamada {get;set;}
        @AuraEnabled
        public string TipoRegistro {get;set;}
    }
    
    
}