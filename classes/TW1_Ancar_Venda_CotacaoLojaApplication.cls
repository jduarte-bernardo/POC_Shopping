public class TW1_Ancar_Venda_CotacaoLojaApplication {
    public TW1_Ancar_wrapRecodtypes rec = new TW1_Ancar_wrapRecodtypes();
    
    /// Repositório de oportunidade
    public TW1_Ancar_Venda_Oportunidade_Rep oportunidadeRepository = new TW1_Ancar_Venda_Oportunidade_Rep();
    
    /// Repositório de propriedade
    public TW1_Ancar_Venda_Propriedade_Rep propriedadeRepository = new TW1_Ancar_Venda_Propriedade_Rep();
    
    /// Repositório de cotação
    public TW1_Ancar_Venda_Cotacao_Rep cotacaoRepository = new TW1_Ancar_Venda_Cotacao_Rep();
    
    /// Application de cálculo de cotação
    public TW1_Ancar_Venda_CalculosCotaApplication calculoApplication = new TW1_Ancar_Venda_CalculosCotaApplication();
    
    public RecordType getRecordtype(String vaNomeDoRecodtype){
        return [SELECT Id,Name FROM RecordType WHERE Name=:vaNomeDoRecodtype limit 1];
    }
    
    public TW1_Ancar_Venda_CotacaoLoja_LP_ctrl.CotacaoDto GetCotacaoCloneLoja(string vaCotacaoId){
        
        quote cotacao = cotacaoRepository.GetCotacaoById(vaCotacaoId);
        System.debug('Quote:' + cotacao);
        TW1_Propriedade__c Propriedade = propriedadeRepository.GetPropriedadeCotacaoLoja(vaCotacaoId);
        System.debug('Propriedade:' + Propriedade);
        TW1_Ancar_Venda_CotacaoLoja_LP_ctrl.CotacaoDto cotacaoDto = MapCotacaoPropriedadeClone(cotacao,Propriedade);
        System.debug('cotacaoDto:' + cotacaoDto);
        
        return cotacaoDto; 
    }
    
    public TW1_Ancar_Venda_CotacaoLoja_LP_ctrl.CotacaoDto MapCotacaoPropriedadeClone(quote cotacao,TW1_Propriedade__c Propriedade)
    {
        TW1_Ancar_Venda_CotacaoLoja_LP_ctrl.CotacaoDto cotacaoDto = new TW1_Ancar_Venda_CotacaoLoja_LP_ctrl.CotacaoDto();
        
        cotacaoDto.OpportunityId = cotacao.OpportunityId;
        cotacaoDto.ValorFPP = cotacao.TW1_FPP__c;
        cotacaoDto.Amm1 = cotacao.TW1_AMM_1__c;
        cotacaoDto.Amm2 = cotacao.TW1_AMM_2__c;
        cotacaoDto.Amm3 = cotacao.TW1_AMM_3__c;
        cotacaoDto.Amm4 = cotacao.TW1_AMM_4__c;
        cotacaoDto.Amm5 = cotacao.TW1_AMM_5__c;
        cotacaoDto.Amm6 = cotacao.TW1_AMM_6__c;
        cotacaoDto.Amm7 = cotacao.TW1_AMM_7__c;
        cotacaoDto.Amm8 = cotacao.TW1_AMM_8__c;
        cotacaoDto.Amm9 = cotacao.TW1_AMM_9__c;
        cotacaoDto.Amm10 = cotacao.TW1_AMM_10__c;
        cotacaoDto.Periodo = cotacao.TW1_Prazo__c;
        cotacaoDto.ValorMidia  = cotacao.TW1_Valor_pacote_de_midia__c;
        cotacaoDto.FormaPagamentoMidia = cotacao.TW1_Forma_pagamento_pacote_de_midia__c;
        cotacaoDto.ValorCondominio = cotacao.TW1_Condominio__c;
        cotacaoDto.AluguelPercentual  = cotacao.TW1_Aluguel_Percentual__c;
        cotacaoDto.ValorCDU = cotacao.TW1_CDU__c;
        cotacaoDto.FormaPagamentoCDU = cotacao.TW1_Forma_de_pagamento_da_CDU__c;
        cotacaoDto.Carencia = cotacao.TW1_Carencia__c;
        cotacaoDto.MesAluguelDobrado = cotacao.TW1_Mes_aluguel_dobrado__c;
        cotacaoDto.Observavao = cotacao.Description;
        cotacaoDto.DataInicio = cotacao.TW1_Data_inicio_de_vigencia__c;
        cotacaoDto.DataFim = cotacao.TW1_Data_fim_de_vigencia__c;
        cotacaoDto.TaxaTransferencia = cotacao.TW1_Taxa_de_transferencia__c;
        cotacaoDto.Propriedade = Propriedade;
        return cotacaoDto;
    }
    
    public List<SObject> getListaPropriedadesDisponiveis(string opportunityId)
    {
        Opportunity opportunity = oportunidadeRepository.GetOpportunityById(opportunityId);
        return propriedadeRepository.ListarPropriedadeLoja(opportunity.TW1_Shopping__c);
    }
    
    public void SalvarCotacao(Quote cotacao, TW1_Propriedade__c Propriedade)
    {
        System.debug('cotacao: ' + cotacao);
        Savepoint sp = Database.setSavepoint();
        
        try{
            String vaRecordType ='';
            
            cotacao.RecordTypeId = this.getRecordtype(rec.rec_Cotcao_loja).id;
            cotacao.Name = Propriedade.Name + ' - ' + Date.today().day() + '/' + Date.today().month() + '/' + Date.today().year();
            
            system.debug('Inserindo cotação');
            Insert cotacao;
            system.debug('Cotação inserida ');
            
            ///Montando lista de propriedades de cotação
            list<TW1_Propriedade_da_Cotacao__c> propCotacao = new List<TW1_Propriedade_da_Cotacao__c>();
            
            TW1_Propriedade_da_Cotacao__c vaPropriedadeCotacao = new TW1_Propriedade_da_Cotacao__c();
            vaPropriedadeCotacao.TW1_Cotacao__c = cotacao.id;
            vaPropriedadeCotacao.TW1_Propriedade__c = Propriedade.Id;
            vaPropriedadeCotacao.TW1_Data_de_inicio__c = cotacao.TW1_Data_inicio_de_vigencia__c;
            
            integer periodo = integer.valueOf(cotacao.TW1_Prazo__c);
            vaPropriedadeCotacao.TW1_Data_de_fim__c = cotacao.TW1_Data_inicio_de_vigencia__c.addMonths(periodo);
            System.debug('5: ' + cotacao.TW1_Data_inicio_de_vigencia__c.addMonths(periodo));
            
            vaPropriedadeCotacao.TW1_Area__c = Propriedade.TW1_area_m2__c;
            propCotacao.add(vaPropriedadeCotacao);
            
            system.debug('Inserindo propriedade');
            Insert propCotacao;
            system.debug('Propriedade inserida');
            
            //Executa calculo da cotação
            system.debug('Executando cálculo da cotação: ' + cotacao);
            cotacao = calculoApplication.CalcularCotacaco(cotacao, propCotacao);
            system.debug('Cálculos executados: ' + cotacao);
            
            update cotacao;
        }
        catch(Exception ex){
            System.debug('erro de cotação:'+ex.getMessage());
            Database.rollback(sp);
            throw ex;
        }
    }
}