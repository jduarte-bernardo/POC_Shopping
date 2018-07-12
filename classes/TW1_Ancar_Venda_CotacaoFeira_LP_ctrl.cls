public with sharing class TW1_Ancar_Venda_CotacaoFeira_LP_ctrl {
    
    //public static TW1_Ancar_Venda_Cotacao_Maestro cotacaoMaestro = new TW1_Ancar_Venda_Cotacao_Maestro();
    
    public static TW1_Ancar_Venda_CotacaoFeiraApplication cotacaoApplication = new TW1_Ancar_Venda_CotacaoFeiraApplication();
    
    @AuraEnabled
    public static String getUIThemeDescription() {
        String theme = UserInfo.getUiThemeDisplayed();
        return theme;
    }
        
    @AuraEnabled
    public static string GetCotacaoClone(string vaCotacaoId)
    {
        TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.CotacaoRequestDto cotacaoDto = cotacaoApplication.GetCotacaoCloneFeira(vaCotacaoId);
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
    public static list<string> getListTipoDePropriedade(){
        system.debug('getListSubTipoDePropriedade');
        list<string> response = cotacaoApplication.getListSubTipoDePropriedade();
        system.debug('Response getListSubTipoDePropriedade: ' + response);
        return response;
    }
    
    @AuraEnabled
    public static list<string> getListarSubTipoPorTipo(string tipo){
        system.debug('getListarSubTipoPorTipo');
        list<string> response = cotacaoApplication.ListarSubTipoPorTipo(tipo);
        system.debug('Response getListarSubTipoPorTipo: ' + response);
        return response;
    }
    
    @AuraEnabled
    public static string PesquisaPropriedade(string opportunityId, string strrequest)
    {
        system.debug('Entrara request: ' + strrequest);
        PesquisaRequestDto request = (PesquisaRequestDto)JSON.deserialize(strrequest, PesquisaRequestDto.class);
        system.debug('Parse request: ' + request);
        system.debug('Chamando persquisa de propriedade');
        
        string resultado = cotacaoApplication.PesquisarPropriedadesParaFeira(opportunityId, request);
        
        return resultado;
    }
    
    @AuraEnabled
    public static string PostSalvarCotacao(string opportunityId, string strrequest)
    {
        system.debug('Entrara request: ' + strrequest);
        CotacaoRequestDto request = (CotacaoRequestDto)JSON.deserialize(strrequest, CotacaoRequestDto.class);
        system.debug('Parse request: ' + request);
        system.debug('Chamando ao salvar');
        cotacaoApplication.SalvarCotacaoFeira(opportunityId, request);
        return 'Sucesso';
    }
    
    public class PesquisaRequestDto
    {   
        public string Tipo {get;set;}
        public string SubTipo {get;set;}
        public Date DataInicio {get;set;}
        public Date DataFim {get;set;}
    }
    
    public class CotacaoRequestDto
    {
        public string OpportunityId {get;set;}
        public string  Atividade {get;set;}        
        public Date DataPagamento {get;set;}        
        public Date SegundaDataPagamento {get;set;}
        public Decimal ValorDesconto {get;set;}        
        public string  Observacao {get;set;}        
        public string RecordTypeId {get;set;}        
        public decimal AreaUtualizada {get;set;}
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
        public Decimal AreaUtilizada {get;set;}
    }
    
    public with sharing class RetornoPesquisaPropriedadeFeiraDto
    {
        public string Id {get;set;}
        public string Name {get;set;}
        public string Status {get;set;}
        public decimal Valor_de_tabela {get;set;}
        public Decimal AreaUtilizada {get;set;}
    }
    
}