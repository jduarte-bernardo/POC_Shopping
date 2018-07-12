({
    doInit : function(component, event, helper) {
        console.log("Iniciando componente de Cotação de Feiras");
        component.set('v.RequestPesquisarPropriedadeDto', {});
        component.set('v.PropriedadesSeleciondas', []);
        component.set('v.CotacaoRequestDto', {});
        //this.CarregaListaSubTipo(component, event, helper);
        console.log('Inicianco chamada de busca de subtipo de propriedade');
        
        if(component.get('v.TipoChamada') == 'Clone')
        {
            component.set('v.PrimeiraEtapaAtiva', false);
            component.set('v.SegundaEtapaAtiva', true);
            component.set('v.BtnHideVoltar', false);
            
            helper.getCotacaoClone(component);
        }
        else
        {	
            component.set('v.BtnHideVoltar', true);
            helper.getDataAtual(component);
            helper.getTipoDePropriedade(component);
        }
    },
    selecionarSubTipo : function(component, event, helper) {
        component.set('v.ExisteResultadoParaFiltro', false);
        component.set('v.ResultadoFiltroPropriedades', []);
        helper.getSubTipoDePropriedade(component);
    },
    MontarCotacao:function(component, event, helper)    {
        
        var CotacaoRequestDto = component.get('v.CotacaoRequestDto');
        
        component.set("v.txtAtividade", CotacaoRequestDto.Atividade);
        component.set("v.txtObservacao", CotacaoRequestDto.Observacao);
        
        console.log('Resgatando lista anterior');
        var listaCorrente = component.get('v.PropriedadesSeleciondas');
        console.log('listaCorrente');
        
        CotacaoRequestDto.ListaDePropriedade = [];
        
        for(var ponteiroListaCorrente = 0; ponteiroListaCorrente < listaCorrente.length; ponteiroListaCorrente++)
        {
            var propriedade = {};
            propriedade.IdPropriedade = listaCorrente[ponteiroListaCorrente].IdPropriedade;
            propriedade.Nome = listaCorrente[ponteiroListaCorrente].Name;
            propriedade.ValorAluguel = listaCorrente[ponteiroListaCorrente].ValorAluguel;
            propriedade.DataInicio = listaCorrente[ponteiroListaCorrente].DataInicio;
            propriedade.DataFim = listaCorrente[ponteiroListaCorrente].DataFim;
            propriedade.Localizacao = listaCorrente[ponteiroListaCorrente].Localizacao;
            propriedade.AreaUtilizada = listaCorrente[ponteiroListaCorrente].AreaUtilizada;
            CotacaoRequestDto.ListaDePropriedade.push(propriedade);
        }
        
        component.set('v.CotacaoRequestDto', CotacaoRequestDto );
        
        component.set('v.PrimeiraEtapaAtiva', false);
        component.set('v.SegundaEtapaAtiva', true);
    },
    VoltarPrimeiraEtapa:function(component, event, helper){
        
        var CotacaoRequestDto = component.get('v.CotacaoRequestDto');
        
        CotacaoRequestDto.Atividade = component.find("txtAtividade").get("v.value");
        CotacaoRequestDto.Observacao = component.find("txtObservacao").get("v.value");
        
        component.set('v.CotacaoRequestDto', CotacaoRequestDto);
        
        component.set('v.PrimeiraEtapaAtiva', true);
        component.set('v.SegundaEtapaAtiva', false);
        
    },
    PesquisarPropriedade:function(component, event, helper){
        
        /// Montando lista de parâmetros
        var opportunityId = component.get("v.recordId");
        var request = component.get('v.RequestPesquisarPropriedadeDto');
        var dataAtual = component.get('v.DataAtual');
        
        if(request.DataInicio == undefined || request.DataFim == undefined)
        {
            alert('A data de inicio e a data fim da vigência são obrigatórias');
            return;
        }
        
        if(request.DataInicio <  dataAtual || request.DataFim <  dataAtual)
        {
            alert('A data de inicio ou a data fim está menor que a data atual');
            return;
        }
        
        if(request.DataInicio > request.DataFim )
        {
            alert('A data de inicio deve ser maior que data fim');
            return;
        }
        
        if(request.Tipo == 'Propriedade de Mall')
            component.set('v.ExibeStatusTabela', false);
        else
            component.set('v.ExibeStatusTabela', true);
        
        component.set('v.ExisteResultadoParaFiltro', false);
        
        console.log('Realizando consutla de propriedade');
        
        component.set('v.NaoPermitirPesquisar', true);
        component.set('v.LabelBtnPesquisar', 'Pesquisando....');
        
        helper.PesquisaPropriedade(component);
    },
    AdcionarPropriedadeLista :function(component, event, helper)
    {
        console.log('Adcionando propriedade a lista')
        var ctarget = event.currentTarget;
        console.log(ctarget);
        
        var listaPesquisaResultado = component.get('v.ResultadoFiltroPropriedades');
        var listaCorrente = component.get('v.PropriedadesSeleciondas');
        var requestPesquisa = component.get('v.RequestPesquisarPropriedadeDto');
        
        console.log(listaPesquisaResultado);
        
        for(var i = 0;i < listaPesquisaResultado.length; i++)
        {
            console.log('Id corrente: ' + listaPesquisaResultado[i].Id);
            if(listaPesquisaResultado[i].Id == ctarget.id)
            {
                console.log('Encontrou propriedade na lista');
                var propriedade = {};
                propriedade.IdPropriedade = listaPesquisaResultado[i].Id;
                propriedade.Name = listaPesquisaResultado[i].Name;
                propriedade.DataInicio = requestPesquisa.DataInicio;
                propriedade.DataFim = requestPesquisa.DataFim;
                propriedade.Localizacao = listaPesquisaResultado[i].Localizacao;
                propriedade.ValorAluguel = listaPesquisaResultado[i].Valor_de_tabela;
                propriedade.AreaUtilizada = listaPesquisaResultado[i].AreaUtilizada;
                console.log('Propriedade montada');
                console.log(propriedade);
                listaCorrente.push(propriedade);
            }
        }
        
        console.log('Definindo nova lista atual: ' + listaCorrente);
        component.set('v.PropriedadesSeleciondas', listaCorrente);
        console.log('Lista definida');
        
        /// Caso o valor seja maior que zero, então tem item na lista e deve ser mostrada
        if(listaCorrente.length > 0)
            component.set('v.ExistePropriedadeSelecionada', true);
        else
            component.set('v.ExistePropriedadeSelecionada', false);        
    },
    RemoverPropriedadeLista:function(component, event, helper)
    {
        console.log('Removendo propriedade a lista')
        var ctarget = event.currentTarget;
        console.log(ctarget);
        
        var listaCorrente = component.get('v.PropriedadesSeleciondas');
        
        console.log(listaCorrente);
        
        for(var i = 0;i < listaCorrente.length; i++)
        {
            console.log('Id corrente: ' + listaCorrente[i].IdPropriedade + listaCorrente[i].DataInicio +  listaCorrente[i].DataFim );
            var idComposto = listaCorrente[i].IdPropriedade + listaCorrente[i].DataInicio +  listaCorrente[i].DataFim;
            console.log('Criando ID Composto: ' + idComposto);
            console.log('ctarget.id: ' + ctarget.id);
            if(idComposto == ctarget.id)
            {
                console.log('Encontrou propriedade na lista');
                listaCorrente.splice(i,1);
            }
        }
        
        console.log('Definindo nova lista atual: ' + listaCorrente);
        component.set('v.PropriedadesSeleciondas', listaCorrente);
        console.log('Lista definida');
        
        /// Caso o valor seja maior que zero, então tem item na lista e deve ser mostrada
        if(listaCorrente.length > 0)
            component.set('v.ExistePropriedadeSelecionada', true);
        else
            component.set('v.ExistePropriedadeSelecionada', false);      
    },
    MudancaNoFiltro:function(component, event, helper)
    {
        component.set('v.ExisteResultadoParaFiltro', false);
        component.set('v.ResultadoFiltroPropriedades', []);
    },
    SalvarCotacao:function(component, event, helper)
    {
        /// TODO: Realizar validações de valores
        /// Liberando botão para consulta
        var request = component.get('v.CotacaoRequestDto');
        var dataAtual =  component.get('v.DataAtual');
        
        console.log('Valor de data de pagamento: ' + request.DataPagamento);
        console.log('Valor de data de atual: ' + dataAtual);
        
        if(request.ValorDesconto == '')
            request.ValorDesconto = undefined;
        /*
        if(request.DataPagamento == undefined || request.DataPagamento <= dataAtual)
        {
            //helper.toastThis('Data de pagamento não pode ser menor que a data atual.', 'Erro...');
            //component.set('v.OcorreuErroEmSalvar',true);
            //component.set('v.MsgErroSalvarCotacao', 'Data de pagamento não pode ser menor que a data atual.');
            alert('Data de pagamento não pode ser menor que a data atual.');
            return;
        }*/
        
        console.log('Lista de propriedades');
        console.log(request.ListaDePropriedade);
        for(var iPropriedade = 0; iPropriedade < request.ListaDePropriedade.length; iPropriedade++)
        {
            var propriedade = request.ListaDePropriedade[iPropriedade];
            if(propriedade.ValorAluguel < 1)
            {
                alert('O valor de aluguel da propriedade '+ propriedade.Nome +' deve ser preenchido.');
                return;
            }
        }
        
        component.set('v.MsgErroSalvarCotacao','');
        component.set('v.OcorreuErroEmSalvar',false);
        component.set('v.NaoPermitirAcoes', true);
        component.set('v.LabelBtnSalvar', 'Salvando....');
        
        helper.SalvarCotacao(component);
    },
    acionaBotaoDevoltar : function(component, event, helper){
        
        var device = $A.get("$Browser.formFactor");
        var vaRecordId = component.get('v.recordId');
        var urlAtual   = component.get('v.urlAtual');
        
        if(device=='PHONE' || device=='TABLET'){
            if(urlAtual != '' || urlAtual != null){ 
                //sforce.one.back(true);
                //sforce.one.navigateToSObject(vaRecordId);
                
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": vaRecordId,
                    "slideDevName": "detail"
                });
                navEvt.fire();
            }
        }else{
            if(urlAtual.match(/portaldevendas/)){
                window.location.href="/portaldevendas/"+vaRecordId;
            }else{
                window.location.href="/"+vaRecordId;
            }
        }
        
    },
    AbrirRelatorioOcupacoes: function(component, event, helper){
        var ctarget = event.currentTarget;
        console.log('Ctarget');
        console.log(ctarget);
        var listaPesquisaResultado = component.get('v.ResultadoFiltroPropriedades');
        var requestPesquisa = component.get('v.RequestPesquisarPropriedadeDto');
        for(var i = 0;i < listaPesquisaResultado.length; i++)
        {
            console.log('Id corrente: ' + listaPesquisaResultado[i].Id);
            if(listaPesquisaResultado[i].Id == ctarget.name)
            {
                console.log('Encontrou propriedade na lista');
                var propriedade = {};
                propriedade.IdPropriedade = listaPesquisaResultado[i].Id;
                propriedade.Name = listaPesquisaResultado[i].Name;
                propriedade.DataInicio = requestPesquisa.DataInicio;
                propriedade.DataFim = requestPesquisa.DataFim;
                propriedade.Localizacao = listaPesquisaResultado[i].Localizacao;
                propriedade.ValorAluguel = listaPesquisaResultado[i].Valor_de_tabela;
                propriedade.AreaUtilizada = listaPesquisaResultado[i].AreaUtilizada;
                console.log('Propriedade montada');
                console.log(propriedade);
                component.set('v.PropriedadeRelatorio', propriedade);
            }
        }
        
        component.set('v.RelatorioDisponibilidade', true);
        component.set('v.PrimeiraEtapaAtiva', false);
        component.set('v.SegundaEtapaAtiva', false);
        
        console.log('Iniciando relatório');
        var childCmp = component.find('child');
        console.log(childCmp);
        // call the aura:method in the child component
        console.log('Chamando método no relatório');
        childCmp.RefinarRelatorioOcupacao(propriedade);
        console.log('Método executado');
        console.log('Liberando tela');
        
    },
    VoltarPrimeiraEtapaPosRelatorio:function(component, event, helper){
        component.set('v.RelatorioDisponibilidade', false);
        component.set('v.PrimeiraEtapaAtiva', true);
        component.set('v.SegundaEtapaAtiva', false);
    }
    
})