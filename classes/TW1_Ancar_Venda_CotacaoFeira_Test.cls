@isTest
public class TW1_Ancar_Venda_CotacaoFeira_Test {
        
    @isTest static void getUIThemeDescription() {
        
        String theme = TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.getUIThemeDescription();
        System.assertEquals('Theme3', theme);
    }
    
    @isTest static void getCotacaoClone() {

        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getFeiraoMock();
        
 		Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getFeiraoMock(opportunity.Id);
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getFeiraoMock(quote.Id);
        TW1_Propriedade__c propriedade2 = TW1_Ancar_PropriedadeMockGenerator_cls.getFeiraoMock(quote.Id);
        
        List<TW1_Propriedade__c> lstPropriedade = new List<TW1_Propriedade__c>();
        lstPropriedade.add(propriedade);
        lstPropriedade.add(propriedade2);
        
        List<TW1_Propriedade_da_Cotacao__c> lstPropCot = 
            [SELECT TW1_Propriedade__c, TW1_Cotacao__c, TW1_Data_de_inicio__c, TW1_Data_de_fim__c, 
             TW1_Area__c, TW1_Localizacao__c, TW1_Valor__c
             FROM TW1_Propriedade_da_Cotacao__c
             WHERE TW1_Propriedade__c IN :lstPropriedade];
        
        CotacaoRequestDto cotacaoDto = MapCotacaoPropriedade(quote, lstPropCot);      
        
        //Expected
        string jsonData = JSON.serialize((Object)cotacaoDto);
        
        String listJson = TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.getCotacaoClone(quote.Id);
        
        System.assert(listJson!=null);
    }
    
    @isTest static void getCurrentDate() {
        
        Date data = TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.GetCurrentDate();
        System.assertEquals(Date.today(), data);
    }
    
    @isTest static void getListTipoDePropriedade() {
        
        List<String> response = TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.getListTipoDePropriedade();
        List<String> responseMock = getListSubTipoDePropriedade();
        
        System.assertEquals(responseMock, response);
    }
    
    @isTest static void getListarSubTipoPorTipo() {
        
        String tipo = 'Propriedade Feiras e Eventos';
        
        List<String> response = TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.getListarSubTipoPorTipo(tipo);
        
        List<String> responseMock = new List<String>();
        responseMock.add('Praça de Eventos');
        responseMock.add('Evento Interno');
        responseMock.add('Evento Externo');
        
        System.assertEquals(responseMock, response);
    }
    
    @isTest static void pesquisaPropriedade() {
        
		Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getFeiraoMock();
        
 		Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getFeiraoMock(opportunity.Id);
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getFeiraoMock(quote.Id);
              
        //Criando um calendário da propriedade
        TW1_Calendario_de_propriedades__c calendar = new TW1_Calendario_de_propriedades__c(
            TW1_Data_de_inicio__c = Date.newInstance(2018, 10, 18),
            TW1_Data_de_fim__c = Date.newInstance(2018, 10, 19),
            TW1_Status__c ='Reservada',
            TW1_Propriedade__c = propriedade.Id
        );
        insert calendar;
        
        PesquisaRequestDto request = new PesquisaRequestDto();
        request.Tipo = 'Propriedade feiras e eventos';
        request.SubTipo = propriedade.TW1_Subtipo__c;
        request.DataInicio = calendar.TW1_Data_de_inicio__c;
        request.DataFim = calendar.TW1_Data_de_fim__c;
            
        string requestMock = JSON.serialize(request);
        
        System.debug('requestMock: ' + requestMock);
               
        //Actual
        String jsonPropriedade = TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.PesquisaPropriedade(opportunity.Id, requestMock);
        System.debug('jsonPropriedade: ' + jsonPropriedade);
        
        List<List<SObject>> ListRetornoPropriedade = ListarPorpriedadeMidiaFeira(opportunity.TW1_Shopping__c, request.SubTipo, request.DataInicio, request.DataFim);
        System.debug(ListRetornoPropriedade);
        
		List<RetornoPesquisaPropriedadeMidiaDto> RetornoMap = MapRetornoPropriedadeMidia(ListRetornoPropriedade);
        System.debug('RetornoMap: ' + RetornoMap);
        
        //Expected
        String listJson = JSON.serialize((List<Object>)RetornoMap);
        System.debug('listJson: ' + listJson);
        
        System.assert(listJson != null);        
    }
    
    @isTest static void postSalvarCotacao() {
        
        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getFeiraoMock();
        
 		Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getFeiraoMock(opportunity.Id);
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getFeiraoMock(quote.Id);
        TW1_Propriedade__c propriedade2 = TW1_Ancar_PropriedadeMockGenerator_cls.getFeiraoMock(quote.Id);
        
        List<TW1_Propriedade__c> lstPropriedade = new List<TW1_Propriedade__c>();
        lstPropriedade.add(propriedade);
        lstPropriedade.add(propriedade2);
        
        List<TW1_Propriedade_da_Cotacao__c> lstPropCot = 
            [SELECT TW1_Propriedade__c, TW1_Cotacao__c, TW1_Data_de_inicio__c, TW1_Data_de_fim__c, 
             TW1_Area__c, TW1_Localizacao__c, TW1_Valor__c
             FROM TW1_Propriedade_da_Cotacao__c
             WHERE TW1_Propriedade__c IN :lstPropriedade];
        
        System.debug('Propriedades da cotação: ' + lstPropCot);
        CotacaoRequestDto cotacaoDto = MapCotacaoPropriedade(quote, lstPropCot);       
        string jsonData = JSON.serialize((Object)cotacaoDto);
        
        System.debug(opportunity.Id);
        System.debug(jsonData);
        String response = TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.PostSalvarCotacao(opportunity.Id, jsonData);
        System.debug(response);
        
        System.assertEquals('Sucesso', response);
    }
    
    public static CotacaoRequestDto MapCotacaoPropriedade(Quote cotacao, List<TW1_Propriedade_da_Cotacao__c> listPropriedades)
    {
        CotacaoRequestDto cotacaoDto = new CotacaoRequestDto();
        
        cotacaoDto.OpportunityId = cotacao.OpportunityId == null ? '' : cotacao.OpportunityId;
        cotacaoDto.Atividade= cotacao.TW1_Atividade__c == null ? '' : cotacao.TW1_Atividade__c;
        cotacaoDto.DataPagamento = cotacao.TW1_Data_de_pagamento__c;
        cotacaoDto.SegundaDataPagamento = cotacao.TW1_Segunda_data_de_pagamento__c;
        cotacaoDto.ValorDesconto = cotacao.TW1_Valor_Desconto__c;
        cotacaoDto.Observacao = cotacao.Description == null ? '' : cotacao.Description;
        cotacaoDto.RecordTypeId = cotacao.RecordTypeId == null ? ''  :cotacao.RecordTypeId;
        cotacaoDto.ListaDePropriedade = new List<PropriedadeDto>();
        
        for(TW1_Propriedade_da_Cotacao__c propriedade : listPropriedades)
        {
            PropriedadeDto propriedadeCotacaoDto = new PropriedadeDto();
            
            propriedadeCotacaoDto.IdPropriedade = propriedade.TW1_Propriedade__c == null ? '':propriedade.TW1_Propriedade__c;
            propriedadeCotacaoDto.DataInicio = propriedade.TW1_Data_de_inicio__c;
            propriedadeCotacaoDto.DataFim = propriedade.TW1_Data_de_fim__c;
            propriedadeCotacaoDto.Localizacao = propriedade.TW1_Localizacao__c == null ? '':propriedade.TW1_Localizacao__c;
            propriedadeCotacaoDto.ValorAluguel = propriedade.TW1_Valor__c == null ? 0.0:propriedade.TW1_Valor__c;
            propriedadeCotacaoDto.AreaUtilizada = propriedade.TW1_Area__c == null ? 0.0:propriedade.TW1_Valor__c;
            cotacaoDto.ListaDePropriedade.add(propriedadeCotacaoDto);
        }
        
        return cotacaoDto;
    }
    
    public static List<string> getListSubTipoDePropriedade()
    {
        system.debug('Inciando busca tipo de propriedades');
        list<String> tipos = new list<String>();
        
        tipos.add('Propriedade Feiras e Eventos');
        tipos.add('Propriedade de Mall');
        tipos.add('Propriedade de Mídia');
        
        system.debug('Retornando tipos: ' + tipos);
        return tipos;
    }
    
    public static List<List<SObject>> ListarPorpriedadeMidiaFeira(Id idShopping, String paPropriedadeSubtipo, Date paDtini, Date paDtfim)
    {
			string IdShoppingsub = idShopping;
        	IdShoppingsub = IdShoppingsub.substring(0,15);
        
        try{
            
            List<TW1_Propriedade__c> vaPropriedade = [
                select 
                Id,
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
                TW1_Valor_de_tabela__c,
                TW1_Localizacao__c
                from 
                TW1_Propriedade__c
                where
                TW1_Ativa__c = true and
                TW1_Subtipo__c=:paPropriedadeSubtipo and
                TW1_Shopping__c=:idShopping and
                Id NOT IN
                (Select TW1_Propriedade__c from TW1_Calendario_de_propriedades__c 
                 where TW1_ShoppingId__c=:IdShoppingsub and 
                 TW1_Data_de_inicio__c <=:paDtfim and
                 TW1_Data_de_fim__c >=:paDtini and 
                 TW1_Status__c ='Ocupada'
                )
            ];	
            
            List<List<SObject>> listObjetosPropriedade = new List<List<SObject>>();
                  
            listObjetosPropriedade.add(vaPropriedade);            
            
            if(listObjetosPropriedade.size() >= 1){
                return listObjetosPropriedade;
            }else{
                return null;
            }
            
        }catch(Exception ex){
            return null;
        }
    }
    
    public static List<RetornoPesquisaPropriedadeMidiaDto> MapRetornoPropriedadeMidia (List<List<SObject>> ListRetornoPropriedade)
    {
        List<RetornoPesquisaPropriedadeMidiaDto> ListMapRetornoPropriedade = new List<RetornoPesquisaPropriedadeMidiaDto>();
        
        List<TW1_Propriedade__c> ListPropriedade =  (List<TW1_Propriedade__c>)ListRetornoPropriedade.get(0);
               
        for(TW1_Propriedade__c item : ListPropriedade)
        {
            RetornoPesquisaPropriedadeMidiaDto dtoMap = new RetornoPesquisaPropriedadeMidiaDto(); 
            
            dtoMap.Id = item.Id;
            dtoMap.Name = item.Name;
            dtoMap.Status = item.TW1_Status__c == null? 'Vaga':item.TW1_Status__c;
            dtoMap.Valor_de_tabela  = item.TW1_Valor_de_tabela__c;   
            dtoMap.Localizacao = item.TW1_Localizacao__c;
            
            ListMapRetornoPropriedade.add(dtoMap);
        }
                
        System.debug('MAP ---Fim---'+ListRetornoPropriedade);
        return ListMapRetornoPropriedade;
    }
     
    public class CotacaoRequestDto
    {
        public Date DataPagamento {get;set;}
        public Date SegundaDataPagamento {get;set;}
        public string  Atividade {get;set;}
        public string  Observacao {get;set;}
        public string OpportunityId {get;set;}
        public string RecordTypeId {get;set;}
        public decimal AreaUtualizada {get;set;}
        public Decimal ValorDesconto {get;set;}
        public list<PropriedadeDto> ListaDePropriedade{get;set;}
    }
    
    public class PropriedadeDto
    {
        public string IdPropriedade {get;set;}
        public Date DataInicio {get;set;}
        public Date DataFim {get;set;}
        public string Localizacao {get;set;}
        public Decimal ValorAluguel {get;set;}
        public Decimal AreaUtilizada {get;set;}
    }
    
    public class PesquisaRequestDto
    {   
        public string Tipo {get;set;}
        public string SubTipo {get;set;}
        public Date DataInicio {get;set;}
        public Date DataFim {get;set;}
    }
    
    public class RetornoPesquisaPropriedadeMidiaDto
    {
        public string Id {get;set;}
        public string Name {get;set;}
        public string Status {get;set;}
        public string Localizacao {get;set;}
        public decimal Valor_de_tabela {get;set;}
    }
}