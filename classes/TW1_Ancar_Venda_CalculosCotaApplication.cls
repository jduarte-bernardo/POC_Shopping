public class TW1_Ancar_Venda_CalculosCotaApplication {
    
    public TW1_Ancar_wrapRecodtypes rec = new TW1_Ancar_wrapRecodtypes();
    
    /// Repositório de oportunidade
    public TW1_Ancar_Venda_Oportunidade_Rep oportunidadeRepository = new TW1_Ancar_Venda_Oportunidade_Rep();
    
    /// Repositório de propriedade
    public TW1_Ancar_Venda_Propriedade_Rep propriedadeRepository = new TW1_Ancar_Venda_Propriedade_Rep();
    
    /// Repositório de cotação
    public TW1_Ancar_Venda_Cotacao_Rep cotacaoRepository = new TW1_Ancar_Venda_Cotacao_Rep();
    
    /// Application responsável por realizar os cálculos de loja
    public TW1_Ancar_CalcCotacao_LojaApp calculadoraLojaApp;
    
    /// Application responsável por realizar os cálculos de Mall
    public TW1_Ancar_CalcCotacao_MallApp calculadoraMallApp;
    
    /// Application responsável por realizar os cálculos de mídia
    public TW1_Ancar_CalcCotacao_MidiaApp calculadoraMidiaApp;
    
    /// Application responsável por realizar os cálculos de Feiras e Eventos
    public TW1_Ancar_CalcCotacao_FeiraApp calculadoraFeiraApp;
    
    /// Executa cálculo de uma cotação
    public Quote CalcularCotacaco(Quote cotacao, list<TW1_Propriedade_da_Cotacao__c> listaPropriedadesCotacao)
    {
        system.debug('Iniciando cálculo da cotação: ' + cotacao + ' Lista de propriedade: ' + listaPropriedadesCotacao);
        Opportunity oportunidade = oportunidadeRepository.GetOpportunityById(cotacao.OpportunityId);
        
        if(oportunidade.RecordType.Name == rec.rec_loja){
            system.debug('Iniciando cálculos de loja');
            calculadoraLojaApp = new TW1_Ancar_CalcCotacao_LojaApp(cotacao, listaPropriedadesCotacao);
            system.debug('Realizando cálculos');
            cotacao = calculadoraLojaApp.RealizarCalculo();
            system.debug('Cálculo realizado com sucesso: ' + cotacao);
        }
        
        if(oportunidade.RecordType.Name == rec.rec_mall){
            system.debug('Iniciando cálculos de Mall');
            calculadoraMallApp = new TW1_Ancar_CalcCotacao_MallApp(cotacao, listaPropriedadesCotacao);
            system.debug('Realizando cálculos');
            cotacao = calculadoraMallApp.RealizarCalculo();
            system.debug('Cálculo mall realizado com sucesso: ' + cotacao);
        }
        
        if(oportunidade.RecordType.Name == rec.rec_midia){
            system.debug('Iniciando cálculos de Mídia');
            calculadoraMidiaApp = new TW1_Ancar_CalcCotacao_MidiaApp(cotacao, listaPropriedadesCotacao);
            system.debug('Realizando cálculos');
            cotacao = calculadoraMidiaApp.RealizarCalculo();
            system.debug('Cálculo mídia realizado com sucesso: ' + cotacao);
        }
        
        if(oportunidade.RecordType.Name == rec.rec_feiras){
            system.debug('Iniciando cálculos de Mídia');
            calculadoraFeiraApp = new TW1_Ancar_CalcCotacao_FeiraApp(cotacao, listaPropriedadesCotacao);
            system.debug('Realizando cálculos');
            cotacao = calculadoraFeiraApp.RealizarCalculo();
            system.debug('Cálculo mídia realizado com sucesso: ' + cotacao);
        }
        
        return cotacao;
    }
}