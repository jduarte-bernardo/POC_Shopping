public class TW1_Ancar_Venda_Cotacao_Rep {
	
     /// Buscar Cotaçao por ID
    public quote GetCotacaoById(Id vaCotacaoId)
    {
        try{
            
            quote vaCotacao = [
                Select
                id,
                TW1_FPP__c,
                TW1_AMM__c,
                TW1_AMM_1__c,
                TW1_AMM_2__c,
                TW1_AMM_3__c,
                TW1_AMM_4__c,
                TW1_AMM_5__c,
                TW1_AMM_6__c,
                TW1_AMM_7__c,
                TW1_AMM_8__c,
                TW1_AMM_9__c,
                TW1_AMM_10__c,
              	TW1_Valor_pacote_de_midia__c,
                TW1_Forma_pagamento_pacote_de_midia__c,
                TW1_Condominio__c,
                TW1_Acrescimo_sazonal_maio__c,
                TW1_Acrescimo_sazonal_novembro__c,
                TW1_Acrescimo_sazonal_dezembro__c,
                TW1_Aluguel_Percentual__c,
                TW1_CDU__c,
                TW1_Forma_de_pagamento_da_CDU__c,
                TW1_Carencia__c,
                TW1_Mes_aluguel_dobrado__c,
                TW1_Data_inicio_de_vigencia__c,
                TW1_Data_fim_de_vigencia__c,
                TW1_Data_de_pagamento__c,
                TW1_Atividade__c,
                TW1_Periodo_de_locacao__c,
                Description,
                TW1_Taxa_de_transferencia__c,
                TW1_QuoteRecordTypeName__c,
                TW1_Area_utilizada__c,
                RecordTypeId,
                Name,
                OpportunityId,
                TW1_Valor_Desconto__c,
                TW1_Segunda_data_de_pagamento__c,
                TW1_Prazo__c
                from
                quote
                where
                Id = :vaCotacaoId
            ];
            
            System.debug(vaCotacao);
            if(vaCotacao != null){
                return vaCotacao;
            }else{
                return null;
            }
            
        }catch(Exception ex){
            system.debug('Erro em consultar Cotação pelo Id EX:' +ex);
            return null;
        }
    }
    
}