@isTest
public class TW1_Ancar_Venda_CotacaoMidia_Test {

    public static TW1_Ancar_wrapRecodtypes rec = new TW1_Ancar_wrapRecodtypes();
    
    @isTest
    public static void getUIThemeDescription() {
        String theme = TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.getUIThemeDescription();
        System.debug('tema '+theme);
        System.assertEquals('Theme3', theme);
    } 
    
    @isTest static void getCotacaoClone() {
        
        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getMidiaMock();
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getMidiaMock(opportunity.Id);   
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getMidiaMock(quote.Id);
        TW1_Propriedade__c propriedade2 = TW1_Ancar_PropriedadeMockGenerator_cls.getMidiaMock(quote.Id);
        
        List<TW1_Propriedade_da_Cotacao__c> listPropriedades = 
            [SELECT TW1_Propriedade__c, TW1_Cotacao__c, TW1_Data_de_inicio__c, TW1_Data_de_fim__c, TW1_Localizacao__c, TW1_Valor__c, TW1_Area__c
            FROM TW1_Propriedade_da_Cotacao__c
            WHERE TW1_Propriedade__c =:propriedade.Id OR TW1_Propriedade__c =:propriedade2.Id ];
        
        System.debug(listPropriedades);
        
        CotacaoRequestDto requestMock = MapCotacaoPropriedadeClone(quote, listPropriedades);
        
        //Expected
        string jsonData = JSON.serialize((Object)requestMock);
        
        //Actual
        String listJson = TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.GetCotacaoClone(quote.Id);
        
        System.assertEquals(jsonData, listJson);
    }
    
    @isTest
    public static void getCurrentDate() {
        Date dt = TW1_Ancar_Venda_CotacaoMall_LP_ctrl.GetCurrentDate();
        System.assertEquals(Date.today(), dt);
    }
    
    @isTest
    public static void getListSubTipoDePropriedade() {
        
        List<String> subtiposMok = new list<String>();
        subtiposMok.add('Adesivo Piso');
        subtiposMok.add('Adesivos de Mesa');
        subtiposMok.add('Adoção de Espaço');
        subtiposMok.add('Adoção Fraldário');
        subtiposMok.add('Banner');
        subtiposMok.add('Cancela Estacionamento');
        subtiposMok.add('Colunas Mall');
        subtiposMok.add('Colunas Praça de Alimentação');
        subtiposMok.add('Display Mall');
        subtiposMok.add('Display Mesa');
        subtiposMok.add('Escada Rolante');
        subtiposMok.add('Espelho de Banheiro');
        subtiposMok.add('Feiras e Eventos');
        subtiposMok.add('Mega Banner');
        subtiposMok.add('Mock up');
        subtiposMok.add('Painel');
        subtiposMok.add('Painel Backlight');
        subtiposMok.add('Painel Fachada');
        subtiposMok.add('Painel Frontlight');
        subtiposMok.add('Panfletagem');
        subtiposMok.add('Placas aéreas');
        subtiposMok.add('Porta de Banheiro');
        subtiposMok.add('Portas de Acesso');
        subtiposMok.add('Portas de Elevador');
        subtiposMok.add('Stand Temporário');
        subtiposMok.add('Testeira');
        subtiposMok.add('Totem Digital');
        subtiposMok.add('Totem Interno');
        subtiposMok.add('Voicer de cancela');

        List<String> response = TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.getListSubTipoDePropriedade();
        
        System.assertEquals(subtiposMok, response);
    }
    
    @isTest
    public static void PesquisaPropriedade(){

        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getMidiaMock();
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getMidiaMock(opportunity.Id);   
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getMidiaMock(quote.Id);
        
        TW1_Calendario_de_propriedades__c calendar = new TW1_Calendario_de_propriedades__c(
            TW1_Data_de_inicio__c = Date.newInstance(2018, 10, 18),
            TW1_Data_de_fim__c = Date.newInstance(2018, 10, 19),
            TW1_Status__c ='Reservada',
            TW1_Propriedade__c = propriedade.Id
        );
        insert calendar;
        
        PesquisaRequestDto request = new PesquisaRequestDto();
        request.SubTipo = propriedade.TW1_Subtipo__c;
        request.DataInicio = calendar.TW1_Data_de_inicio__c;
        request.DataFim = calendar.TW1_Data_de_fim__c;
      	
        string requestMock = JSON.serialize(request);
        
        String jsonPropriedade = TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.PesquisaPropriedade(opportunity.Id,requestMock);
		
         List<List<SObject>> ListRetornoPropriedade = ListarPorpriedadeMidiaFeira(opportunity.TW1_Shopping__c, request.SubTipo, request.DataInicio, request.DataFim);
        System.debug(ListRetornoPropriedade);
        
		List<RetornoPesquisaPropriedadeMidiaDto> RetornoMap = MapRetornoPropriedadeMidia(ListRetornoPropriedade);
        System.debug('RetornoMap: ' + RetornoMap);
        
        //Expected
        String listJson = JSON.serialize((List<Object>)RetornoMap);
        System.debug('listJson: ' + listJson);
        
        System.assertEquals(listJson, jsonPropriedade);        

    }
    
    @isTest
    public static void postSalvarCotacao() {
        
        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getMidiaMock();
        
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getMidiaMock(opportunity.Id);   
        
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getMidiaMock(quote.Id);
        TW1_Propriedade__c propriedade2 = TW1_Ancar_PropriedadeMockGenerator_cls.getMidiaMock(quote.Id);
        
        List<TW1_Propriedade_da_Cotacao__c> listPropriedades = 
            [SELECT TW1_Propriedade__c, TW1_Cotacao__c, TW1_Data_de_inicio__c, TW1_Data_de_fim__c, TW1_Localizacao__c, TW1_Valor__c, TW1_Area__c
            FROM TW1_Propriedade_da_Cotacao__c
            WHERE TW1_Propriedade__c =:propriedade.Id OR TW1_Propriedade__c =:propriedade2.Id ];
        
        System.debug(listPropriedades);
        
        CotacaoRequestDto requestMock = MapCotacaoPropriedadeClone(quote, listPropriedades);
        
        string jsonRequest = JSON.serialize((Object)requestMock);
        
        //Actual
        String response = TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.PostSalvarCotacao(opportunity.Id, jsonRequest);
        
        //Expected
        String responseMock = SalvarCotacaoMidia(opportunity.Id, requestMock);
        
        System.assertEquals('Sucesso', response);
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
    
    private static CotacaoRequestDto MapCotacaoPropriedadeClone(quote cotacao,List<TW1_Propriedade_da_Cotacao__c> listPropriedades)
    {
        CotacaoRequestDto cotacaoDto = new CotacaoRequestDto();
        
        cotacaoDto.OpportunityId = cotacao.OpportunityId == null ? '':cotacao.OpportunityId;
        cotacaoDto.Atividade= cotacao.TW1_Atividade__c == null ? '':cotacao.TW1_Atividade__c;
        cotacaoDto.DataPagamento = cotacao.TW1_Data_de_pagamento__c;
        cotacaoDto.SegundaDataPagamento = cotacao.TW1_Segunda_data_de_pagamento__c;
        cotacaoDto.Observacao = cotacao.Description == null ? '':cotacao.Description;
        cotacaoDto.ValorDesconto = cotacao.TW1_Valor_Desconto__c ;
        
        cotacaoDto.RecordTypeId = cotacao.RecordTypeId == null ? '':cotacao.RecordTypeId;
        cotacaoDto.ListaDePropriedade = new List<PropriedadeDto>();
        
        for(TW1_Propriedade_da_Cotacao__c propriedade : listPropriedades)
        {
            PropriedadeDto propriedadeCotacaoDto = new PropriedadeDto();
            
            propriedadeCotacaoDto.IdPropriedade = propriedade.TW1_Propriedade__c == null ? '':propriedade.TW1_Propriedade__c;
            propriedadeCotacaoDto.DataInicio = propriedade.TW1_Data_de_inicio__c;
            propriedadeCotacaoDto.DataFim = propriedade.TW1_Data_de_fim__c;
            propriedadeCotacaoDto.Localizacao = propriedade.TW1_Localizacao__c == null ? '':propriedade.TW1_Localizacao__c;
            propriedadeCotacaoDto.ValorAluguel = propriedade.TW1_Valor__c == null ? 0.0:propriedade.TW1_Valor__c;
            propriedadeCotacaoDto.AreaUtilizada = propriedade.TW1_Area__c;
            cotacaoDto.ListaDePropriedade.add(propriedadeCotacaoDto);
        }
        
        return cotacaoDto;
    }
    
    private static String SalvarCotacaoMidia(String opportunityId, CotacaoRequestDto request)
    {        
        try{
            List<RecordType> record = [SELECT Id FROM RecordType WHERE Name = :rec.rec_Cotcao_midia];
            
            Quote cotacao = new Quote();
            cotacao.OpportunityId = opportunityId;
            cotacao.TW1_Atividade__c= request.Atividade;
            cotacao.TW1_Data_de_pagamento__c= request.DataPagamento;
            cotacao.TW1_Segunda_data_de_pagamento__c= request.SegundaDataPagamento;cotacao.Description = request.Observacao;
            cotacao.RecordTypeId = record[0].Id;
            cotacao.Name = rec.rec_Cotcao_midia + ' - ' + Date.today().day() + '/' + Date.today().month() + '/' + Date.today().year();
            cotacao.TW1_Valor_Desconto__c = request.ValorDesconto;
            
            Insert cotacao;
            
            /// Montando lista de propriedades de cotação
            list<TW1_Propriedade_da_Cotacao__c> listaPropriedadesCotacao = new List<TW1_Propriedade_da_Cotacao__c>();
            
            
            for(PropriedadeDto propriedade : request.ListaDePropriedade)
            {
                TW1_Propriedade_da_Cotacao__c propriedadeCotacao = new TW1_Propriedade_da_Cotacao__c();
                propriedadeCotacao.TW1_Cotacao__c = cotacao.id;
                propriedadeCotacao.TW1_Propriedade__c = propriedade.IdPropriedade;
                propriedadeCotacao.TW1_Data_de_inicio__c = propriedade.DataInicio;
                propriedadeCotacao.TW1_Data_de_fim__c = propriedade.DataFim;
                propriedadeCotacao.TW1_Localizacao__c = propriedade.Localizacao;
                propriedadeCotacao.TW1_Valor__c = propriedade.ValorAluguel;
                propriedadeCotacao.TW1_Area__c = propriedade.AreaUtilizada;
                listaPropriedadesCotacao.add(propriedadeCotacao);
            }
            
            system.debug('Final ');
            
            Insert listaPropriedadesCotacao;
            
            /// Executa calculo da cotação
            system.debug('Executando cálculo da cotação: ' + cotacao);
            TW1_Ancar_CalcCotacao_MidiaApp calculadoraMidiaApp = new TW1_Ancar_CalcCotacao_MidiaApp(cotacao, listaPropriedadesCotacao);
            cotacao = calculadoraMidiaApp.RealizarCalculo();
            system.debug('Cálculo mídia realizado com sucesso: ' + cotacao);
            
            update cotacao;
            
            return 'Success';
        }
        catch(Exception ex){
            System.debug('erro em salvar cotação de mídia:'+ex.getMessage());
            return 'Fail';
        }
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
        public List<PropriedadeDto> ListaDePropriedade{get;set;}
    }
    
    public class PropriedadeDto
    {	
        public string IdPropriedade {get;set;}
        public Date DataInicio {get;set;}
        public Date DataFim {get;set;}
        public string Localizacao {get;set;}
        public Decimal ValorAluguel {get;set;}
        public decimal AreaUtilizada {get;set;}
    }
    
    public class PesquisaRequestDto
    {   
        public string SubTipo {get;set;}
        public Date DataInicio {get;set;}
        public Date DataFim {get;set;}
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