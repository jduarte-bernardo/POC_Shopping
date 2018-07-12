({
    doInit : function(component, event, helper) {
        console.log("Iniciando componente de Cotação de Mall");
        component.set('v.CotacaoRequestDto', {});
        console.log(component.get('v.urlAtual'));
        if(component.get('v.TipoChamada') == 'Clone')
        {
            //console.log("Clone");
            component.set('v.PrimeiraEtapaAtiva', false);
            component.set('v.SegundaEtapaAtiva', true);
            component.set('v.BtnHideVoltar', false);
            helper.ListarPeriodoLocacao(component);
            helper.getCotacaoClone(component);
        }
        else
        {	
            console.log("processo normal");
            component.set('v.BtnHideVoltar', true);
            helper.getSubTipoDePropriedade(component);
            console.log("processo getSubTipoDePropriedade");
            helper.getDataAtual(component);
            console.log("processo getDataAtual");
            helper.getListaPropriedadePorOpportunityESubTipo(component);
            console.log("processo getListaPropriedadePorOpportunityESubTipo");
            helper.ListarPeriodoLocacao(component);
            console.log("processo ListarPeriodoLocacao");
        }
        
    },
    SelecionaSubTipo : function(component, event, helper) {
        component.set('v.PropriedadeSelecionda', undefined);   
        helper.getListaPropriedadePorOpportunityESubTipo(component);
    },
    SelecionarItem : function(component, event, helper){
        var ctarget = event.currentTarget;
        
        console.log(ctarget);
        
        console.log('Resgatando lista anterior');
        console.log('Lista de pesquisa');
        var listaPesquisaResultado = component.get('v.ListaPropriedadesParaShopping');
        console.log(listaPesquisaResultado);
        
        var propriedadeSelecionada = {};
        
        for(var i = 0;i < listaPesquisaResultado.length; i++)
        {
            console.log('Id corrente: ' + listaPesquisaResultado[i].Id);
            if(listaPesquisaResultado[i].Id == ctarget.value)
            {
                if(ctarget.checked)
                    propriedadeSelecionada = listaPesquisaResultado[i];
            }
        }
        
        component.set('v.PropriedadeSelecionda', propriedadeSelecionada);        
        console.log('Definindo nova propriedade: ' + propriedadeSelecionada);
    },
    AbreSegundoPasso : function(component, event, helper) {
        
        var propriedadeSelecionada = component.get('v.PropriedadeSelecionda');  
        var cotacao = component.get('v.CotacaoRequestDto');
        
        console.log('O que veio :' +propriedadeSelecionada);
        console.log(propriedadeSelecionada);
        if(propriedadeSelecionada == undefined)
        {
            alert('Favor selecionar uma propriedade');
            return;
        }
        
        if(propriedadeSelecionada.TW1_Valor_de_tabela__c != undefined || propriedadeSelecionada.TW1_Valor_de_tabela__c > 0)
        {
            cotacao.AMM = propriedadeSelecionada.TW1_Valor_de_tabela__c;
        }
        
        cotacao.AreaUtilizada = propriedadeSelecionada.TW1_area_m2__c;
        
        component.set('v.CotacaoRequestDto', cotacao);
        
        component.set('v.PrimeiraEtapaAtiva', false);
        component.set('v.SegundaEtapaAtiva', true);
    },
    VoltarPrimeiraEtapa: function(component, event, helper) {
        
        component.set('v.PropriedadeSelecionda', undefined);  
        component.set('v.CotacaoRequestDto', {});
        component.set('v.PrimeiraEtapaAtiva', true);
        component.set('v.SegundaEtapaAtiva', false);
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
    Salvar: function(component, event, helper) {
        var requestDto = component.get('v.CotacaoRequestDto');
        var dataAtual = component.get('v.DataAtual');
        
        var listaCampo = ['Condominio','FPP', 'AluguelPercentual' , 'AcrescimoSazonalMaio'
                          ,'AcrescimoSazonalNovembro','AcrescimoSazonalDezembro','ValorPacoteMidia'];
        
        Object.getOwnPropertyNames(requestDto).forEach(function(val, idx, array) {
            
            for(var iCampo = 0; iCampo < listaCampo.length; iCampo++)
            {
                if(val == listaCampo[iCampo] && requestDto[val] == '')
                {
                    console.log('Nome do campo ' + val);
                    console.log('Limpando campo');
                    requestDto[val] = undefined;
                }
            }
        });
        
        console.log(requestDto);
        
        var jsonCotacao = JSON.stringify(requestDto);
        console.log('Json de cotação: ' + jsonCotacao);
        
        if(requestDto.PeriodoLocacao == 'Determinado')
        {
            if(requestDto.DataInicio == undefined || requestDto.DataFim == undefined)
            {
                alert('A data de inicio e a data fim da vigência são obrigatórias');
                return;
            }
            
            if(requestDto.DataInicio <  dataAtual || requestDto.DataFim <  dataAtual)
            {
                alert('A data de inicio ou a data fim está menor que a data atual');
                return;
            }
            
            if(requestDto.DataInicio > requestDto.DataFim )
            {
                alert('A data de inicio deve ser maior que data fim');
                return;
            }
        }
        else
        {
            if(requestDto.DataInicio == undefined)
            {
                alert('A data de inicio é obrigatórias');
                return;
            }
            
            if(requestDto.DataInicio <  dataAtual)
            {
                alert('A data de inicio está menor que a data atual');
                return;
            }
        }
        
        if(requestDto.AMM == undefined || requestDto.AMM <=  0)
        {
            alert('É obrigatório o preenchimento do AMM');
            return;
        }
        
        component.set('v.LabelBtnSalvar', 'Salvando...');        
        component.set('v.NaoPermitirAcoes', true);        
        
        
        helper.Salvar(component);
    }
})