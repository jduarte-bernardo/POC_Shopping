@isTest
public class TW1_Ancar_Venda_CotacaoMall_Test {
    
    @isTest
    public static void getListSubTipoDePropriedade() {
        
        //Expected
        List<String> subtiposMock = new list<String>();        
        subtiposMock.add('Antena');
        subtiposMock.add('Caixa Eletronico');
        subtiposMock.add('Deposito');
        subtiposMock.add('Quiosque');
        
        //Actual
        List<String> response = TW1_Ancar_Venda_CotacaoMall_LP_ctrl.getListSubTipoDePropriedade();
        
        System.assertEquals(subtiposMock, response);
    }
    
    @isTest
    public static void GetCotacaoClone() {
        
        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getMallMock();
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getMallMock(opportunity.Id);   
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getMallMock(quote.Id);
        
        //Actual        
        String cotacaoDtoString = TW1_Ancar_Venda_CotacaoMall_LP_ctrl.GetCotacaoClone(quote.Id);
        
        //Expected
        CotacaoMallRequest cotacaoDto = MapCotacaoPropriedadeClone(quote, propriedade);
        String cotacaoDTOMock = JSON.serialize((Object)cotacaoDto);
        
        System.assertEquals(cotacaoDTOMock, cotacaoDtoString);
    }
    
    @isTest
    public static void getListPeriodoLocacao() {
        
        //Expected
        List<String> lstTipoLocacaoMock = new list<String>();
        
        lstTipoLocacaoMock.add('Determinado');
        lstTipoLocacaoMock.add('Indeterminado');
        
        //Actual
        List<String> response = TW1_Ancar_Venda_CotacaoMall_LP_ctrl.getListPeriodoLocacao();
        
        System.assertEquals(lstTipoLocacaoMock, response);
    }
    
    @isTest
    public static void getCurrentDate() {
        
        Date dt = TW1_Ancar_Venda_CotacaoMall_LP_ctrl.GetCurrentDate();
        System.assertEquals(Date.today(), dt);
    }
    
    @isTest
    public static void pesquisarPropriedadeCotacaoMall() {
        
        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getMallMock();
        List<SObject> lstPropriedadeCotacao = TW1_Ancar_Venda_CotacaoMall_LP_ctrl.PesquisarPropriedadeCotacaoMall(opportunity.Id, 'subTipo');
    }
    
    @isTest
    public static void SalvarCotacao() {
        
        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getMallMock();
        System.debug('opportunity: ' + opportunity);
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getMallMock(opportunity.Id); 
        System.debug('quote: ' + quote);  
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getMallMock(quote.Id);
        System.debug('propriedade: ' + propriedade);  
        
        CotacaoMallRequest cotacaoDTO = MapCotacaoPropriedadeClone(quote, propriedade);
        System.debug(cotacaoDTO);
        
        String dtoSerialized = JSON.serialize(cotacaoDTO);
        System.debug(dtoSerialized);
        
        String sucesso = TW1_Ancar_Venda_CotacaoMall_LP_ctrl.SalvarCotacao(opportunity.Id, propriedade.Id, dtoSerialized);
        
        System.assertEquals('SUCESSO', sucesso);
    }
    
    private static CotacaoMallRequest MapCotacaoPropriedadeClone(Quote cotacao, TW1_Propriedade__c propriedade)
    {
        CotacaoMallRequest cotacaoDto = new CotacaoMallRequest();
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
        cotacaoDto.FormaPagamentoPacoteMidia = cotacao.TW1_Forma_pagamento_pacote_de_midia__c;
        cotacaoDto.Observacao = cotacao.Description;
        cotacaoDto.IdPropriedade = propriedade.Id;
        cotacaoDto.NomePropriedade = propriedade.Name;
        cotacaoDto.AreaUtilizada = cotacao.TW1_Area_utilizada__c;
        return cotacaoDto;
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
        public string FormaPagamentoPacoteMidia {get;set;}   
        public string Observacao {get;set;}
        public string IdPropriedade {get;set;}
        public string NomePropriedade {get;set;}
        public Decimal AreaUtilizada {get;set;}
    }
    
    @isTest
    public static void SalvarCotacaoComErro() {
        
        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getMallMock();
        System.debug('opportunity: ' + opportunity);
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getMallMock(opportunity.Id); 
        System.debug('quote: ' + quote);  
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getMallMock(quote.Id);
        System.debug('propriedade: ' + propriedade);  
        
        CotacaoMallRequest cotacaoDTO = MapCotacaoPropriedadeClone(quote, propriedade);
        System.debug(cotacaoDTO);
        
        String dtoSerialized = JSON.serialize(cotacaoDTO);
        System.debug(dtoSerialized);
        
        try{
            
            String sucesso = TW1_Ancar_Venda_CotacaoMall_LP_ctrl.SalvarCotacao(null, propriedade.Id, dtoSerialized);
            
        }catch(Util_ApplicationException ea){
            System.assert(true);
        }
        Catch(Exception e){
            system.debug('fail ' + e);
            System.assert(false);
        }
        
        
    }
}