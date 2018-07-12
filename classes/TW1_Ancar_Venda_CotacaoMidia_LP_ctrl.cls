public with sharing class TW1_Ancar_Venda_CotacaoMidia_LP_ctrl {
    
    //public static TW1_Ancar_Venda_Cotacao_Maestro cotacaoMaestro = new TW1_Ancar_Venda_Cotacao_Maestro();
    
    public static TW1_Ancar_Venda_CotacaoMidiaApplication cotacaoApplication = new TW1_Ancar_Venda_CotacaoMidiaApplication();
    
    @AuraEnabled
    public static String getUIThemeDescription() {
        String theme = UserInfo.getUiThemeDisplayed();
        return theme;
    }
    
    @AuraEnabled
    public static string GetCotacaoClone(string vaCotacaoId)
    {
        TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.CotacaoRequestDto cotacaoDto = cotacaoApplication.GetCotacaoCloneMidia(vaCotacaoId);
        System.debug('GetCotacaoClone: '+cotacaoDto);
        String listJson = JSON.serialize((Object)cotacaoDto);
        System.debug('listJson: '+cotacaoDto);
        return listJson;
    }
    
    @AuraEnabled
    public static Date GetCurrentDate()
    {
        return Date.today();
    }
    
    @AuraEnabled
    public static list<string> getListSubTipoDePropriedade(){
        system.debug('getListSubTipoDePropriedade');
        list<string> response = cotacaoApplication.ListarSubTipoMallMidia();
        system.debug('Response getListSubTipoDePropriedade: ' + response);
        return response;
    }
    
    @AuraEnabled
    public static string PesquisaPropriedade(string opportunityId, string strrequest)
    {
        system.debug('Entrara request: ' + strrequest);
        PesquisaRequestDto request = (PesquisaRequestDto)JSON.deserialize(strrequest, PesquisaRequestDto.class);
        system.debug('Parse request: ' + request);
        system.debug('Chamando persquisa de propriedade');
        
        return cotacaoApplication.PesquisaPropriedadeMidia(opportunityId, request);
    }
    
    @AuraEnabled
    public static string PostSalvarCotacao(string opportunityId, string strrequest)
    {
        system.debug('Entrara request: ' + strrequest);
        CotacaoRequestDto request = (CotacaoRequestDto)JSON.deserialize(strrequest, CotacaoRequestDto.class);
        system.debug('Parse request: ' + request);
        system.debug('Chamando ao salvar');
        cotacaoApplication.SalvarCotacaoMidia(opportunityId, request);
        return 'Sucesso';
    }
    
    public class PesquisaRequestDto
    {   
        public string SubTipo {get;set;}
        public Date DataInicio {get;set;}
        public Date DataFim {get;set;}
    }
    
    public class CotacaoRequestDto
    {
        public Date DataPagamento {get;set;}
        public Date SegundaDataPagamento {get;set;}
        public string  Atividade {get;set;}
        public string  Observacao {get;set;}
        public string OpportunityId {get;set;}
        public string RecordTypeId {get;set;}
        public Decimal ValorDesconto {get;set;}
        public list<PropriedadeDto> ListaDePropriedade{get;set;}
    }
    
    public class PropriedadeDto
    {	@AuraEnabled
        public string IdPropriedade {get;set;}
        @AuraEnabled
        public Date DataInicio {get;set;}
        @AuraEnabled
        public Date DataFim {get;set;}
        @AuraEnabled
        public string Localizacao {get;set;}
        @AuraEnabled
        public Decimal ValorAluguel {get;set;}
        @AuraEnabled
        public decimal AreaUtilizada {get;set;}
    }
    
    public with sharing class RetornoPesquisaPropriedadeMidiaDto
    {
        public string Id {get;set;}
        public string Name {get;set;}
        public string Status {get;set;}
        public string Localizacao {get;set;}
        public decimal Valor_de_tabela {get;set;}
        public decimal AreaUtilizada {get;set;}
    }
    
}