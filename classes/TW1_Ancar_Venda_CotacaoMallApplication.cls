public class TW1_Ancar_Venda_CotacaoMallApplication {
    
    public TW1_Ancar_wrapRecodtypes rec = new TW1_Ancar_wrapRecodtypes();
    
    /// Repositório de oportunidade
    public TW1_Ancar_Venda_Oportunidade_Rep oportunidadeRepository = new TW1_Ancar_Venda_Oportunidade_Rep();
    
    /// Repositório de propriedade
    public TW1_Ancar_Venda_Propriedade_Rep propriedadeRepository = new TW1_Ancar_Venda_Propriedade_Rep();
     
    /// Repositório de cotação 
    public TW1_Ancar_Venda_Cotacao_Rep cotacaoRepository = new TW1_Ancar_Venda_Cotacao_Rep();
    
    /// Application de cálculo de cotação
    public TW1_Ancar_Venda_CalculosCotaApplication calculoApplication = new TW1_Ancar_Venda_CalculosCotaApplication();
    
    public list<string> getListSubTipoDePropriedadeMall(){
        list<String> subtipos = new list<String>();
        
        subtipos.add('Antena');
        subtipos.add('Caixa Eletronico');
        subtipos.add('Deposito');
        subtipos.add('Quiosque');
        
        return subtipos;
    }
    
    public list<string> getListPeriodoLocacao(){
        list<String> tipoLocacao = new list<String>();
        
        tipoLocacao.add('Determinado');
        tipoLocacao.add('Indeterminado');
        
        return tipoLocacao;
    }
        
    public List<SObject> PesquisarPropriedadeCotacaoMall(String opportunityId,String subTipo)
    {
        Opportunity opportunity = oportunidadeRepository.GetOpportunityById(opportunityId);
        return propriedadeRepository.ListarPropriedadeMall(opportunity.TW1_Shopping__c, subTipo);
    }
    
    private RecordType getRecordtype(String vaNomeDoRecodtype){
        return [SELECT Id,Name FROM RecordType WHERE Name=:vaNomeDoRecodtype limit 1];
    }
    
    public void SalvarCotacao(Quote cotacao, string idPropriedade, string nomePropriedade)
    {   
        Savepoint sp = Database.setSavepoint();
        
        try{
            String vaRecordType ='';
            
            cotacao.RecordTypeId = this.getRecordtype(rec.rec_Cotcao_mall).id;
            cotacao.Name = nomePropriedade + ' - ' + Date.today().day() + '/' + Date.today().month() + '/' + Date.today().year();
            
            system.debug('Inserindo cotação de mall');
            Insert cotacao;
            system.debug('Cotação inserida ');
            
            ///Montando lista de propriedades de cotação
            list<TW1_Propriedade_da_Cotacao__c> propCotacao = new List<TW1_Propriedade_da_Cotacao__c>();
            
            TW1_Propriedade_da_Cotacao__c vaPropriedadeCotacao = new TW1_Propriedade_da_Cotacao__c();
            vaPropriedadeCotacao.TW1_Cotacao__c = cotacao.id;
            vaPropriedadeCotacao.TW1_Propriedade__c = idPropriedade;
            vaPropriedadeCotacao.TW1_Data_de_inicio__c = cotacao.TW1_Data_inicio_de_vigencia__c;
            vaPropriedadeCotacao.TW1_Data_de_fim__c = cotacao.TW1_Data_fim_de_vigencia__c;
            vaPropriedadeCotacao.TW1_Valor__c = cotacao.TW1_AMM__c;
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
    
    public TW1_Ancar_Venda_CotacaoMall_LP_ctrl.CotacaoMallRequest GetCotacaoCloneMall(string vaCotacaoId){
        
        quote cotacao = cotacaoRepository.GetCotacaoById(vaCotacaoId);
        TW1_Propriedade__c listPropriedades = propriedadeRepository.GetPropriedadeByIdCotacaoMALL(vaCotacaoId);
        System.debug('listPropriedades: '+listPropriedades);
        listPropriedades =  listPropriedades == null? new TW1_Propriedade__c() : listPropriedades;
        System.debug('listPropriedades Old: '+listPropriedades);
        TW1_Ancar_Venda_CotacaoMall_LP_ctrl.CotacaoMallRequest cotacaoDto = MapCotacaoPropriedadeClone(cotacao,listPropriedades);
        System.debug('MapCotacaoPropriedadeClone: '+cotacaoDto);
        return cotacaoDto;
    }
    
    public TW1_Ancar_Venda_CotacaoMall_LP_ctrl.CotacaoMallRequest MapCotacaoPropriedadeClone(quote cotacao,TW1_Propriedade__c listPropriedades)
    {
        TW1_Ancar_Venda_CotacaoMall_LP_ctrl.CotacaoMallRequest cotacaoDto = new TW1_Ancar_Venda_CotacaoMall_LP_ctrl.CotacaoMallRequest();
		cotacaoDto.OpportunityId = cotacao.OpportunityId;       
        cotacaoDto.PeriodoLocacao = cotacao.TW1_Periodo_de_locacao__c;	
        cotacaoDto.DataInicio = cotacao.TW1_Data_inicio_de_vigencia__c;	
      	cotacaoDto.DataFim = cotacao.TW1_Data_fim_de_vigencia__c;
        cotacaoDto.AMM = cotacao.TW1_AMM__c;
        cotacaoDto.Condominio = cotacao.TW1_Condominio__c;
        cotacaoDto.FPP = cotacao.TW1_FPP__c;
        cotacaoDto.AluguelPercentual = cotacao.TW1_Aluguel_Percentual__c;
        cotacaoDto.AcrescimoSazonalMaio = cotacao.TW1_Acrescimo_sazonal_maio__c;
        cotacaoDto.AcrescimoSazonalNovembro = cotacao.TW1_Acrescimo_sazonal_novembro__c;
        cotacaoDto.AcrescimoSazonalDezembro = cotacao.TW1_Acrescimo_sazonal_dezembro__c;
        cotacaoDto.ValorPacoteMidia = cotacao.TW1_Valor_pacote_de_midia__c;
        //cotacaoDto.TaxaTransferencia = cotacao.TW1_Taxa_de_transferencia__c;
        cotacaoDto.FormaPagamentoPacoteMidia = cotacao.TW1_Forma_pagamento_pacote_de_midia__c;
        cotacaoDto.Observacao = cotacao.Description;
        cotacaoDto.IdPropriedade = listPropriedades.Id;
        cotacaoDto.NomePropriedade = listPropriedades.Name;
        cotacaoDto.AreaUtilizada = cotacao.TW1_Area_utilizada__c;
        return cotacaoDto;
    }
	
}