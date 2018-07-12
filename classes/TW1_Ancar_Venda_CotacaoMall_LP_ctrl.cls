public with sharing class TW1_Ancar_Venda_CotacaoMall_LP_ctrl {
    
    private static TW1_Ancar_Venda_CotacaoMallApplication cotacaoApplication = new TW1_Ancar_Venda_CotacaoMallApplication();
    
    @AuraEnabled
    public static list<string> getListSubTipoDePropriedade(){
        system.debug('getListSubTipoDePropriedade');
        list<string> response = cotacaoApplication.getListSubTipoDePropriedadeMall();
        system.debug('Response getListSubTipoDePropriedade: ' + response);
        return response;
    }
    
    @AuraEnabled
    public static string GetCotacaoClone(string vaCotacaoId)
    {
        TW1_Ancar_Venda_CotacaoMall_LP_ctrl.CotacaoMallRequest cotacaoDto = cotacaoApplication.GetCotacaoCloneMall(vaCotacaoId);
        System.debug('GetCotacaoClone: '+cotacaoDto);
        String listJson = JSON.serialize((Object)cotacaoDto);
        System.debug('listJson: '+cotacaoDto);
        return listJson;
    }
        
    @AuraEnabled
    public static list<string> getListPeriodoLocacao(){
        system.debug('getListPeriodoLocacao');
        list<string> response = cotacaoApplication.getListPeriodoLocacao();
        system.debug('Response getListPeriodoLocacao: ' + response);
        return response;
    }
    
    @AuraEnabled
    public static Date GetCurrentDate()
    {
        return Date.today();
    }
    
    @AuraEnabled
    public static List<SObject> PesquisarPropriedadeCotacaoMall(String opportunityId,String subTipo)
    {
        system.debug('PesquisarPropriedadeCotacaoMall');
        list<SObject> response = cotacaoApplication.PesquisarPropriedadeCotacaoMall(opportunityId,subTipo);
        system.debug('Response PesquisarPropriedadeCotacaoMall: ' + response);
        return response;
    }
        
    @AuraEnabled
    public static string  SalvarCotacao(string opportunityId, string IdPropriedade, string strCotacao)
    {
        System.debug('pegou o Id de oportunidade:' + opportunityId);
        System.debug('minha propriedade:' + IdPropriedade);
        System.debug('clone:' + strCotacao);
        
        system.debug('Inicio para salvar cotação de mall');
        
        system.debug('Validando parâmetro opportunityId: ' + opportunityId);
        if(opportunityId == null || opportunityId == '')
            throw new Util_ApplicationException('Não foi informado o  opportunityId');
        
        system.debug('Validando parâmetro IdPropriedade: ' + IdPropriedade);
        if(IdPropriedade == null || IdPropriedade == '')
            throw new Util_ApplicationException('Não foi informado o  IdPropriedade');
        
        system.debug('Validando parâmetro strCotacao: ' + strCotacao);
        if(strCotacao == null || strCotacao == '')
            throw new Util_ApplicationException('Não foi informado o  strCotacao');
        
        system.debug('Realizando parse em DTO');
        CotacaoMallRequest request = (CotacaoMallRequest)JSON.deserialize(strCotacao, CotacaoMallRequest.class);
        system.debug('Parse realizado com sucesso: ' + request);
        
        if(request.PeriodoLocacao == 'Determinado')
        {
            if( request.DataInicio == null || request.DataFim == null || request.DataInicio < Date.today()  || request.DataFim < Date.today() )
            {
                throw new Util_ApplicationException('A data de inicio ou a data fim está menor que a data atual ou nula');
            }
            
            if(request.DataInicio > request.DataFim){
                throw new Util_ApplicationException('A data de inicio deve ser maior que data fim');
            }
        }
        else
        {
            if(request.DataInicio == null  || request.DataInicio < Date.today())
            {
                throw new Util_ApplicationException('A data de inicio ou a data fim está menor que a data atual ou nula');
            }
            
            request.DataFim = null;
        }
        
        if(request.AMM == null || request.AMM < 1)
        {
            throw new Util_ApplicationException('É obrigatório o preenchimento do AMM');
        }
        
        Quote cotacao = MapCotacaoMallRequestToQuote(request);
        cotacao.OpportunityId = opportunityId;
        
        system.debug('Chamando application para salvar mall');
        cotacaoApplication.SalvarCotacao(cotacao, IdPropriedade, request.NomePropriedade);
        system.debug('Cotação processada com sucesso');
        
        return 'SUCESSO';
    }
    
    private static Quote MapCotacaoMallRequestToQuote(CotacaoMallRequest source)
    {
        Quote cotacao = new Quote();
        cotacao.TW1_Periodo_de_locacao__c = source.PeriodoLocacao;
        cotacao.TW1_Data_inicio_de_vigencia__c = source.DataInicio;
        cotacao.TW1_Data_fim_de_vigencia__c = source.DataFim;
        cotacao.TW1_AMM__c = source.AMM;
        cotacao.TW1_Valor__c = source.AMM;
        cotacao.TW1_Condominio__c = source.Condominio;
        cotacao.TW1_FPP__c = source.FPP;
        cotacao.TW1_Aluguel_Percentual__c = source.AluguelPercentual;
        cotacao.TW1_Acrescimo_sazonal_dezembro__c = source.AcrescimoSazonalDezembro;
        cotacao.TW1_Acrescimo_sazonal_maio__c = source.AcrescimoSazonalMaio;
        cotacao.TW1_Acrescimo_sazonal_novembro__c = source.AcrescimoSazonalNovembro;
        cotacao.TW1_Valor_pacote_de_midia__c = source.ValorPacoteMidia;
        cotacao.TW1_Forma_pagamento_pacote_de_midia__c = source.FormaPagamentoPacoteMidia;
        cotacao.Description = source.Observacao;
        cotacao.TW1_Area_utilizada__c = source.AreaUtilizada;
        //cotacao.TW1_Taxa_de_transferencia__c = source.TaxaTransferencia;
        return cotacao;
    }
    
    public class CotacaoMallRequest
    {
        public string OpportunityId {get;set;}
        public string PeriodoLocacao {get;set;}   
        public Date DataInicio {get;set;}   
        public Date DataFim {get;set;}   
        public Decimal AMM {get;set;}   
        public Decimal Condominio {get;set;}   
        public Decimal FPP {get;set;}   
        public Decimal AluguelPercentual {get;set;}   
        public Decimal AcrescimoSazonalMaio {get;set;}   
        public Decimal AcrescimoSazonalNovembro {get;set;}   
        public Decimal AcrescimoSazonalDezembro {get;set;}   
        public Decimal ValorPacoteMidia {get;set;} 
        //public Decimal TaxaTransferencia {get;set;}
        public string FormaPagamentoPacoteMidia {get;set;}   
        public string Observacao {get;set;}
        public string IdPropriedade {get;set;}
        public string NomePropriedade {get;set;}
        public Decimal AreaUtilizada {get;set;}
    }
    
}