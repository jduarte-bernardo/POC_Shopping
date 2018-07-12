public class TW1_Ancar_Venda_CotacaoLoja_LP_ctrl {
    
    private static TW1_Ancar_Venda_CotacaoLojaApplication cotacaoApplication = new TW1_Ancar_Venda_CotacaoLojaApplication();
    
    @AuraEnabled
    public static Date getDataAtual()
    {
        return Date.today();
    }
    
    @AuraEnabled
    public static string GetCotacaoClone(string vaCotacaoId)
    {	
        TW1_Ancar_Venda_CotacaoLoja_LP_ctrl.CotacaoDto cotacaoDto = cotacaoApplication.GetCotacaoCloneLoja(vaCotacaoId);

        String listJson = JSON.serialize((Object)cotacaoDto);
		System.debug(listJson);
        return listJson;
    }
    
    @AuraEnabled
    public static List<SObject> getListaPropriedadesDisponiveis(string opportunityId)
    {
        system.debug('Chamada de busca de lista de propriedades disponíveis para o shopping da negociação: ' + opportunityId);
        return cotacaoApplication.getListaPropriedadesDisponiveis(opportunityId);
    }
    
    @AuraEnabled
    public static List<string> getListaMeses()
    {
        system.debug('Montando lista de meses aluguel dobrado');
        List<string> meses = new List<string>();
        meses.add('Janeiro');
        meses.add('Fevereiro');
        meses.add('Março');
        meses.add('Abril');
        meses.add('Maio');
        meses.add('Junho');
        meses.add('Julho');
        meses.add('Agosto');
        meses.add('Setembro');
        meses.add('Outubro');
        meses.add('Novembro');
        meses.add('Dezembro');
        system.debug('Retornando lista: ' +meses) ;
        return meses;
    }
    
    @AuraEnabled
    public static string SalvarCotacao(string opportunityId, string idPropriedade, string strCotacaoDto)
    {
        system.debug('Chamada para salvar cotação de loja: Oportunidade: ' + opportunityId + 'Propriedade: ' + idPropriedade + ' Cotação: '  + strCotacaoDto);
        CotacaoDto request = (CotacaoDto)JSON.deserialize(strCotacaoDto, CotacaoDto.class);
        System.debug('teste '+ request);
        Quote cotacao = new Quote();
        cotacao.OpportunityId = opportunityId;
        cotacao.TW1_FPP__c = request.ValorFPP;
        cotacao.TW1_AMM_1__c = request.Amm1;
        cotacao.TW1_AMM_2__c = request.Amm2;
        cotacao.TW1_AMM_3__c = request.Amm3;
        cotacao.TW1_AMM_4__c = request.Amm4;
        cotacao.TW1_AMM_5__c = request.Amm5;
        cotacao.TW1_AMM_6__c = request.Amm6;
        cotacao.TW1_AMM_7__c = request.Amm7;
        cotacao.TW1_AMM_8__c = request.Amm8;
        cotacao.TW1_AMM_9__c = request.Amm9;
        cotacao.TW1_AMM_10__c = request.Amm10;
        cotacao.TW1_Valor_pacote_de_midia__c  = request.ValorMidia;
        cotacao.TW1_Forma_pagamento_pacote_de_midia__c = request.FormaPagamentoMidia;
        cotacao.TW1_Condominio__c = request.ValorCondominio;
        cotacao.TW1_Aluguel_Percentual__c  = request.AluguelPercentual;
        cotacao.TW1_CDU__c = request.ValorCDU;
        cotacao.TW1_Forma_de_pagamento_da_CDU__c = request.FormaPagamentoCDU;
        cotacao.TW1_Carencia__c = request.Carencia;
        cotacao.TW1_Mes_aluguel_dobrado__c = request.MesAluguelDobrado;
        cotacao.Description = request.Observavao;
        cotacao.TW1_Data_inicio_de_vigencia__c = request.DataInicio;
        cotacao.TW1_Data_fim_de_vigencia__c = request.DataFim;
        cotacao.TW1_Prazo__c = request.Periodo;
        System.debug('taxa '+ request.TaxaTransferencia);
        cotacao.TW1_Taxa_de_transferencia__c = request.TaxaTransferencia;
        System.debug('taxa 2 '+ request.TaxaTransferencia);
        system.debug('Enviando para salvar: ' + cotacao);
        cotacaoApplication.SalvarCotacao(cotacao, request.Propriedade);
        system.debug('Cotação salva.');
        return 'SUCESSO';
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
}