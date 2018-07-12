public class TW1_Ancar_Venda_CotacaoFeiraApplication {
    
    public TW1_Ancar_wrapRecodtypes rec = new TW1_Ancar_wrapRecodtypes();
    
    /// Repositório de oportunidade
    public TW1_Ancar_Venda_Oportunidade_Rep oportunidadeRepository = new TW1_Ancar_Venda_Oportunidade_Rep();
    
    /// Repositório de propriedade
    public TW1_Ancar_Venda_Propriedade_Rep propriedadeRepository = new TW1_Ancar_Venda_Propriedade_Rep();
    
    /// Repositório de cotação
    public TW1_Ancar_Venda_Cotacao_Rep cotacaoRepository = new TW1_Ancar_Venda_Cotacao_Rep();
    
    /// Application de cálculo de cotação
    public TW1_Ancar_Venda_CalculosCotaApplication calculoApplication = new TW1_Ancar_Venda_CalculosCotaApplication();
        
    TW1_Ancar_Venda_CotacaoMallApplication mallApplication = new TW1_Ancar_Venda_CotacaoMallApplication();
    
    TW1_Ancar_Venda_CotacaoMidiaApplication cotacaoMidia = new TW1_Ancar_Venda_CotacaoMidiaApplication();
    
    private RecordType getRecordtype(String vaNomeDoRecodtype){
        return [SELECT Id,Name FROM RecordType WHERE Name=:vaNomeDoRecodtype limit 1];
    }
    
    public list<string> getListSubTipoDePropriedade()
    {
        system.debug('Inciando busca tipo de propriedades');
        list<String> tipos = new list<String>();
        
        tipos.add('Propriedade Feiras e Eventos');
        tipos.add('Propriedade de Mall');
        tipos.add('Propriedade de Mídia');
        
        system.debug('Retornando tipos: ' + tipos);
        return tipos;
    }
    
    public list<string> ListarSubTipoPorTipo(string tipo)
    {
        system.debug('Selecionando subtipo pelo tipo: ' + tipo);
        
        list<string> retorno = null;
        
        if(tipo == 'Propriedade Feiras e Eventos')
            retorno = ListarSubTipoFeira();
        if(tipo == 'Propriedade de Mall')
            retorno = mallApplication.getListSubTipoDePropriedadeMall();
        if(tipo == 'Propriedade de Mídia')
            retorno =  cotacaoMidia.ListarSubTipoMallMidia();
        
        system.debug('Retornando lista de subtipo: ' + retorno);
        
        return retorno;
    }
    
    private list<string> ListarSubTipoFeira()
    {
        list<String> subTipos = new list<String>();
        subTipos.add('Praça de Eventos');
        subTipos.add('Evento Interno');
        subTipos.add('Evento Externo');
        return subTipos; 
    }
    
    public string PesquisarPropriedadesParaFeira(string opportunityId, TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.PesquisaRequestDto request)
    {
        system.debug('Iniciando pesquisa para propriedade feira: ' + request);
        
        string retorno = '';
        
        if(request.Tipo == 'Propriedade de Mall')
        {
            system.debug('Iniciando pesquisa de propriedade de Mall');
            List<SObject> retornoListaPesquisaMall = mallApplication.PesquisarPropriedadeCotacaoMall(opportunityId, request.SubTipo);
            system.debug('retornoListaPesquisaMall: ' + retornoListaPesquisaMall);
            
            List<TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.RetornoPesquisaPropriedadeMidiaDto> listaDtoRetorno = new List<TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.RetornoPesquisaPropriedadeMidiaDto>();
            
            system.debug('Realizando map para DTO de retorno');
            for(TW1_Propriedade__c propriedade : (list<TW1_Propriedade__c>)retornoListaPesquisaMall)
            {
                TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.RetornoPesquisaPropriedadeMidiaDto dtoRetorno = new TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.RetornoPesquisaPropriedadeMidiaDto();
                dtoRetorno.Id = propriedade.Id;
                dtoRetorno.Name = propriedade.Name;
                dtoRetorno.Status = propriedade.TW1_Status__c;
                dtoRetorno.Valor_de_tabela = propriedade.TW1_Valor_de_tabela__c;    
                dtoRetorno.Localizacao = propriedade.TW1_Localizacao__c;
                dtoRetorno.AreaUtilizada = propriedade.TW1_area_m2__c;
                listaDtoRetorno.add(dtoRetorno);
            }
            system.debug('Lista DTO montada: ' + listaDtoRetorno);
            retorno = JSON.serialize((List<Object>)listaDtoRetorno);
        }
        if(request.Tipo == 'Propriedade de Mídia' || request.Tipo == 'Propriedade Feiras e Eventos')
        {
            system.debug('Pesquisando propriedades de mída ou feira');
            TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.PesquisaRequestDto pesquisaMidia = new TW1_Ancar_Venda_CotacaoMidia_LP_ctrl.PesquisaRequestDto();
            pesquisaMidia.SubTipo = request.SubTipo;
            pesquisaMidia.DataInicio = request.DataInicio;
            pesquisaMidia.DataFim = request.DataFim;
            system.debug('Request de pesquisa montado para enviar ao application de mídia: ' + pesquisaMidia);
            
            retorno =  cotacaoMidia.PesquisaPropriedadeMidia(opportunityId, pesquisaMidia);
        }   
        
        system.debug('Retorno pesquisa serializado de feira: ' + retorno);
        return retorno;
    }
    
    public void SalvarCotacaoFeira(string opportunityId, TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.CotacaoRequestDto request)
    {
        Savepoint sp = Database.setSavepoint();
        
        try{
            
            Quote cotacao = new Quote();
            cotacao.RecordTypeId = this.getRecordtype(rec.rec_Cotcao_feiras).id;
            cotacao.OpportunityId = opportunityId;
            cotacao.Name = rec.rec_Cotcao_feiras;
            cotacao.TW1_Atividade__c= request.Atividade;
            cotacao.TW1_Data_de_pagamento__c= request.DataPagamento;
            cotacao.TW1_Segunda_data_de_pagamento__c= request.SegundaDataPagamento;
            cotacao.Description = request.Observacao;
            cotacao.TW1_Valor_Desconto__c = request.ValorDesconto;
            
            Insert cotacao;
            
            /// Montando lista de propriedades de cotação
            list<TW1_Propriedade_da_Cotacao__c> listaPropriedadesCotacao = new List<TW1_Propriedade_da_Cotacao__c>();
            
            for(TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.PropriedadeDto propriedade : request.ListaDePropriedade)
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
    
    public TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.CotacaoRequestDto GetCotacaoCloneFeira(string vaCotacaoId){
        
        quote cotacao = cotacaoRepository.GetCotacaoById(vaCotacaoId);
        List<TW1_Propriedade_da_Cotacao__c> listPropriedades = propriedadeRepository.GetPropriedadeCotacao(vaCotacaoId);
        System.debug('listPropriedades: '+listPropriedades);
        listPropriedades =  listPropriedades == null? new List<TW1_Propriedade_da_Cotacao__c>() : listPropriedades;
        System.debug('listPropriedades Old: '+listPropriedades);
        TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.CotacaoRequestDto cotacaoDto = MapCotacaoPropriedadeClone(cotacao,listPropriedades);
        System.debug('MapCotacaoPropriedadeClone: '+cotacaoDto);
        return cotacaoDto;
    }
    
    public TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.CotacaoRequestDto MapCotacaoPropriedadeClone(quote cotacao,List<TW1_Propriedade_da_Cotacao__c> listPropriedades)
    {
        TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.CotacaoRequestDto cotacaoDto = new TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.CotacaoRequestDto();
        
        cotacaoDto.OpportunityId = cotacao.OpportunityId == null ? '':cotacao.OpportunityId;
        cotacaoDto.Atividade= cotacao.TW1_Atividade__c == null ? '':cotacao.TW1_Atividade__c;
        cotacaoDto.DataPagamento = cotacao.TW1_Data_de_pagamento__c;
        cotacaoDto.RecordTypeId = cotacao.RecordTypeId == null ? '':cotacao.RecordTypeId;
        cotacaoDto.ListaDePropriedade = new List<TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.PropriedadeDto>();
        cotacaoDto.AreaUtualizada = cotacao.TW1_Area_utilizada__c;
        cotacaoDto.SegundaDataPagamento = cotacao.TW1_Segunda_data_de_pagamento__c;
        cotacaoDto.Observacao = cotacao.Description == null ? '':cotacao.Description;
        cotacaoDto.ValorDesconto = cotacao.TW1_Valor_Desconto__c ;
        
        for(TW1_Propriedade_da_Cotacao__c propriedade : listPropriedades)
        {
            TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.PropriedadeDto propriedadeCotacaoDto = new TW1_Ancar_Venda_CotacaoFeira_LP_ctrl.PropriedadeDto();
            
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
}