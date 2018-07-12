@isTest
public class TW1_Ancar_Venda_CotacaoLoja_Test {
    
    @isTest static void getDataAtual() {
        
        Date data = TW1_Ancar_Venda_CotacaoLoja_LP_ctrl.getDataAtual();
        System.assertEquals(Date.today(), data);
    }
    
    @isTest static void getCotacaoClone() {
        
		Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getLojaMock();
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getLojaMock(opportunity.Id);   
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getLojaMock(quote.Id);
        
        CotacaoDto cotacaoDto = MapCotacaoPropriedade(quote, propriedade);      
        System.debug('CotacaoDto Mock:' + cotacaoDto);
        
        //Expected
        string jsonData = JSON.serialize((Object)cotacaoDto);
        
        //Actual
        String listJson = TW1_Ancar_Venda_CotacaoLoja_LP_ctrl.getCotacaoClone(quote.Id);
        
        System.assertEquals(jsonData, listJson);
    }
        
    @isTest static void getListaPropriedadesDisponiveis() {
        
 		Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getLojaMock();
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getLojaMock(opportunity.Id);   
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getLojaMock(quote.Id);
        
        //Expected
        List<sObject> propriedadesMock = ListarPropriedadeLoja(opportunity.TW1_Shopping__c);
        System.debug(propriedadesMock);
        
        //Actual
        List<SObject> propriedades = TW1_Ancar_Venda_CotacaoLoja_LP_ctrl.getListaPropriedadesDisponiveis(opportunity.Id);
        System.debug(propriedades);
        
        System.assertEquals(propriedadesMock, propriedades);
    }
        
    @isTest static void getListaMeses() {
        
        List<string> mesesMock = new List<string>();
        mesesMock.add('Janeiro');
        mesesMock.add('Fevereiro');
        mesesMock.add('Março');
        mesesMock.add('Abril');
        mesesMock.add('Maio');
        mesesMock.add('Junho');
        mesesMock.add('Julho');
        mesesMock.add('Agosto');
        mesesMock.add('Setembro');
        mesesMock.add('Outubro');
        mesesMock.add('Novembro');
        mesesMock.add('Dezembro');
        
        List<string> meses = TW1_Ancar_Venda_CotacaoLoja_LP_ctrl.getListaMeses();
        System.assertEquals(mesesMock, meses);
    }
    
    @isTest static void salvarCotacao() {
        
		Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getLojaMock();
        System.debug('opportunity: ' + opportunity);
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getLojaMock(opportunity.Id); 
        System.debug('quote: ' + quote);  
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getLojaMock(quote.Id);
        System.debug('propriedade: ' + propriedade);  
                
        CotacaoDto cotacaoDTO = MapCotacaoPropriedade(quote, propriedade);
        System.debug(cotacaoDTO);
        
        String dtoSerialized = JSON.serialize(cotacaoDTO);
        System.debug(dtoSerialized);
        
        String sucesso = TW1_Ancar_Venda_CotacaoLoja_LP_ctrl.SalvarCotacao(opportunity.Id, propriedade.Id, dtoSerialized);
        
        System.assertEquals('SUCESSO', sucesso);
    }
    
    public static CotacaoDto MapCotacaoPropriedade(quote cotacao,TW1_Propriedade__c Propriedade)
    {
        CotacaoDto cotacaoDto = new CotacaoDto();
         
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
    
    public class CotacaoDto
    {
        public Date DataInicio {get;set;}
        public String OpportunityId{get;set;}
        public Date DataFim {get;set;}
        public Decimal Amm1 {get;set;}
        public Decimal Amm2 {get;set;}
        public Decimal Amm3 {get;set;}
        public Decimal Amm4 {get;set;}
        public Decimal Amm5 {get;set;}
        public Decimal Amm6 {get;set;}
        public Decimal Amm7 {get;set;}
        public Decimal Amm8 {get;set;}
        public Decimal Amm9 {get;set;}
        public Decimal Amm10 {get;set;}
        public Decimal ValorCondominio {get;set;}
        public Decimal ValorFPP {get;set;}
        public Decimal ValorCDU {get;set;}
        public String FormaPagamentoCDU{get;set;}
        public Decimal AluguelPercentual{get;set;}
        public string Carencia{get;set;}
        public String MesAluguelDobrado{get;set;}
        public Decimal ValorMidia{get;set;}
        public String FormaPagamentoMidia{get;set;}
        public Decimal TaxaTransferencia{get;set;}
        public String Observavao{get;set;}
        public Decimal Periodo{get;set;}
        public TW1_Propriedade__c Propriedade{get;set;}
    }
    
    private static List<SObject> ListarPropriedadeLoja(Id idShopping)
    {
        try{
            
            List<TW1_Propriedade__c> vaPropriedade = [
                Select
                id,
                Name,
                TW1_Shopping__c,
                TW1_Subtipo__c,
                TW1_Piso__c,
                TW1_area_m2__c, 
                TW1_Observacao__c,
                TW1_Status__c,
                TW1_Ativa__c,
                TW1_Status_da_prospecao__c,
                TW1_AMM__c,
                TW1_Fundo__c,
                TW1_OTN__c,
                TW1_Condominio__c,
                TW1_Nota_de_d_bito_ou_CTO__c,
                TW1_Res_Perata__c,
                TW1_IPTU__c,
                TW1_Valor_TR__c,
                TW1_Valor_de_tabela__c
                from 
                TW1_Propriedade__c 
                where
                TW1_Ativa__c = true and
                TW1_Shopping__c =:idShopping and 
                (
                    TW1_Status__c='Vaga' or 
                    TW1_Status__c='Repasse'
                ) and
                (
                    TW1_Subtipo__c ='Âncora' or
                    TW1_Subtipo__c ='Megaloja' or
                    TW1_Subtipo__c ='Satélite'
                )
            ];
            
            System.debug('Propriedade loja' + vaPropriedade);
            if(vaPropriedade.size() >= 1){
                return vaPropriedade;
            }else{
                return null;
            }
            
        }catch(Exception ex){
            system.debug('Erro em consultar ListarPropriedadeLoja EX:' +ex);
            return null;
        }
    }
}