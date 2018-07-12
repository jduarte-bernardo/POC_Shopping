public class TW1_Ancar_Venda_CotacaoMidiaApplication {
    public TW1_Ancar_wrapRecodtypes rec = new TW1_Ancar_wrapRecodtypes();
    
    /// Repositório de oportunidade
    public TW1_Ancar_Venda_Oportunidade_Rep oportunidadeRepository = new TW1_Ancar_Venda_Oportunidade_Rep();
    
    /// Repositório de propriedade
    public TW1_Ancar_Venda_Propriedade_Rep propriedadeRepository = new TW1_Ancar_Venda_Propriedade_Rep();
    
    /// Repositório de cotação
    public TW1_Ancar_Venda_Cotacao_Rep cotacaoRepository = new TW1_Ancar_Venda_Cotacao_Rep();
    
    /// Application de cálculo de cotação
    public TW1_Ancar_Venda_CalculosCotaApplication calculoApplication = new TW1_Ancar_Venda_CalculosCotaApplication();
    
    /// Listar SubTipo Mall e Midia
    public list<String> ListarSubTipoMallMidia()
    {
        String[] subtipos = new list<String>();
        
        subtipos.add('Adesivo Piso');
        subtipos.add('Adesivos de Mesa');
        subtipos.add('Adoção de Espaço');
        subtipos.add('Adoção Fraldário');
        subtipos.add('Banner');
        subtipos.add('Cancela Estacionamento');
        subtipos.add('Colunas Mall');
        subtipos.add('Colunas Praça de Alimentação');
        subtipos.add('Display Mall');
        subtipos.add('Display Mesa');
        subtipos.add('Escada Rolante');
        subtipos.add('Espelho de Banheiro');
        subtipos.add('Feiras e Eventos');
        subtipos.add('Mega Banner');
        subtipos.add('Mock up');
        subtipos.add('Painel');
        subtipos.add('Painel Backlight');
        subtipos.add('Painel Fachada');
        subtipos.add('Painel Frontlight');
        subtipos.add('Panfletagem');
        subtipos.add('Placas aéreas');
        subtipos.add('Porta de Banheiro');
        subtipos.add('Portas de Acesso');
        subtipos.add('Portas de Elevador');
        subtipos.add('Stand Temporário');
        subtipos.add('Testeira');
        subtipos.add('Totem Digital');
        subtipos.add('Totem Interno');
        subtipos.add('Voicer de cancela');
        
        return subtipos;
    }
    
    public RecordType getRecordtype(String vaNomeDoRecodtype){
        return [SELECT Id,Name FROM RecordType WHERE Name=:vaNomeDoRecodtype limit 1];
    }
    
    public TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.CotacaoRequestDto GetCotacaoCloneMidia(string vaCotacaoId){
        
        quote cotacao = cotacaoRepository.GetCotacaoById(vaCotacaoId);
        List<TW1_Propriedade_da_Cotacao__c> listPropriedades = propriedadeRepository.GetPropriedadeCotacao(vaCotacaoId);
        System.debug('listPropriedades: '+listPropriedades);
        listPropriedades =  listPropriedades == null? new List<TW1_Propriedade_da_Cotacao__c>() : listPropriedades;
        System.debug('listPropriedades Old: '+listPropriedades);
        TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.CotacaoRequestDto cotacaoDto = MapCotacaoPropriedadeClone(cotacao,listPropriedades);
        System.debug('MapCotacaoPropriedadeClone: '+cotacaoDto);
        return cotacaoDto;
    }
    
    public TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.CotacaoRequestDto MapCotacaoPropriedadeClone(quote cotacao,List<TW1_Propriedade_da_Cotacao__c> listPropriedades)
    {
        TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.CotacaoRequestDto cotacaoDto = new TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.CotacaoRequestDto();
        
        cotacaoDto.OpportunityId = cotacao.OpportunityId == null ? '':cotacao.OpportunityId;
        cotacaoDto.Atividade= cotacao.TW1_Atividade__c == null ? '':cotacao.TW1_Atividade__c;
        cotacaoDto.DataPagamento = cotacao.TW1_Data_de_pagamento__c;
        cotacaoDto.SegundaDataPagamento = cotacao.TW1_Segunda_data_de_pagamento__c;
        cotacaoDto.Observacao = cotacao.Description == null ? '':cotacao.Description;
        cotacaoDto.ValorDesconto = cotacao.TW1_Valor_Desconto__c ;
        
        cotacaoDto.RecordTypeId = cotacao.RecordTypeId == null ? '':cotacao.RecordTypeId;
        cotacaoDto.ListaDePropriedade = new List<TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.PropriedadeDto>();
        
        for(TW1_Propriedade_da_Cotacao__c propriedade : listPropriedades)
        {
            TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.PropriedadeDto propriedadeCotacaoDto = new TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.PropriedadeDto();
            
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
    
    
    /// Método para listar propriedades List<TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.RetornoPesquisaPropriedadeMidiaDto>
    public string PesquisaPropriedadeMidia(string opportunityId, TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.PesquisaRequestDto request){
        system.debug('Pesquisa de propriedade de mídia');
        system.debug('OportunityId: ' + opportunityId);
        system.debug('Request: ' + request);
        
        Opportunity vaOpportunity = oportunidadeRepository.GetOpportunityById(opportunityId);
        
        List<SObject> ListRetornoPropriedade = propriedadeRepository.ListarPorpriedadeMidiaFeira(vaOpportunity.TW1_Shopping__c, request.SubTipo, request.DataInicio, request.DataFim);
        
        System.debug('--------');
        
        List<TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.RetornoPesquisaPropriedadeMidiaDto> RetornoMap = MapRetornoPropriedadeMidia(ListRetornoPropriedade, 'Vaga');
        
        List<SObject> ocupadas = propriedadeRepository.ListarPorpriedadeMidiaFeiraOcupadas(vaOpportunity.TW1_Shopping__c, request.SubTipo, request.DataInicio, request.DataFim);
        RetornoMap.addall(MapRetornoPropriedadeMidia(ocupadas, 'Ocupada'));
        
        String listJson = JSON.serialize((List<Object>)RetornoMap);
        
        System.debug('--------'+RetornoMap);
        
        return listJson;
    }
    
    
    public List<TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.RetornoPesquisaPropriedadeMidiaDto> MapRetornoPropriedadeMidia (List<SObject> ListRetornoPropriedade, string status)
    {
        List<TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.RetornoPesquisaPropriedadeMidiaDto> ListMapRetornoPropriedade = new List<TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.RetornoPesquisaPropriedadeMidiaDto>();
        
        System.debug('Lista de propriedades a serem mapeadas: ' + ListRetornoPropriedade);
        
        if(ListRetornoPropriedade == null)
            return ListMapRetornoPropriedade;
        
        for(TW1_Propriedade__c item : ((List<TW1_Propriedade__c>) ListRetornoPropriedade))
        {
            TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.RetornoPesquisaPropriedadeMidiaDto dtoMap = new TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.RetornoPesquisaPropriedadeMidiaDto(); 
            
            dtoMap.Id = item.Id;
            dtoMap.Name = item.Name;
            dtoMap.Status = status;
            dtoMap.Valor_de_tabela  = item.TW1_Valor_de_tabela__c;   
            dtoMap.Localizacao = item.TW1_Localizacao__c;
            dtoMap.AreaUtilizada = item.TW1_area_m2__c;
            System.debug('localizacao:'+item.TW1_Localizacao__c);
            ListMapRetornoPropriedade.add(dtoMap);
        }
        
        System.debug('Map de propriedades realizado com sucesso: '+ListRetornoPropriedade);
        return ListMapRetornoPropriedade;
    }
    
    /// Salvar uma cotação de mídia
    public void SalvarCotacaoMidia(string opportunityId, TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.CotacaoRequestDto request)
    {
        Savepoint sp = Database.setSavepoint();
        
        try{
            
            Quote cotacao = new Quote();
            cotacao.OpportunityId = opportunityId;
            cotacao.TW1_Atividade__c= request.Atividade;
            cotacao.TW1_Data_de_pagamento__c= request.DataPagamento;
            cotacao.TW1_Segunda_data_de_pagamento__c= request.SegundaDataPagamento;cotacao.Description = request.Observacao;
            cotacao.RecordTypeId = this.getRecordtype(rec.rec_Cotcao_midia).id;
            cotacao.Name = rec.rec_Cotcao_midia + ' - ' + Date.today().day() + '/' + Date.today().month() + '/' + Date.today().year();
            cotacao.TW1_Valor_Desconto__c = request.ValorDesconto;
            
            Insert cotacao;
            
            /// Montando lista de propriedades de cotação
            list<TW1_Propriedade_da_Cotacao__c> listaPropriedadesCotacao = new List<TW1_Propriedade_da_Cotacao__c>();
            
            
            for(TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.PropriedadeDto propriedade : request.ListaDePropriedade)
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
            cotacao = calculoApplication.CalcularCotacaco(cotacao, listaPropriedadesCotacao);
            system.debug('Cálculos executados: ' + cotacao);
            
            update cotacao;
        }
        catch(Exception ex){
            System.debug('erro em salvar cotação de mídia:'+ex.getMessage());
            Database.rollback(sp);
            throw ex;
        }
    }
}