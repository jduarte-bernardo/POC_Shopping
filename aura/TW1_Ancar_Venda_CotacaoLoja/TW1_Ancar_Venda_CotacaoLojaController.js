({
    init: function(component, event, helper) {
        console.log("Iniciando componente de Cotação de loja");
        console.log('Montando lista de propriedades disponíveis');
        component.set('v.CotacaoRequestDto', {});
        
        if(component.get('v.TipoChamada') == 'Clone')
        {
            component.set('v.PrimeiraEtapaAtiva', false);
            component.set('v.SegundaEtapaAtiva', true);
            component.set('v.BtnHideVoltar', false);
            helper.MontarListaMesesAluguelDobrado(component);
            helper.getCotacaoClone(component);
        }
        else
        {	
            component.set('v.BtnHideVoltar', true);
            helper.MontarListaProprieadesDisponiveis(component);
            helper.MontarListaMesesAluguelDobrado(component);
            helper.BuscarDataAtual(component);
        }
        
    },
    SelecionarData : function(component, event, helper) {
        var ctarget = component.find('vidDataDeFimVigencia');
        console.log('Objeto target ' + ctarget.get('v.value'));
        console.log(ctarget.get('v.value'));
        
        var dataInicio = new Date(component.find('vidDataDeInicioVigencia').get('v.value'));
        var datafim = new Date(component.find('vidDataDeFimVigencia').get('v.value'));
        
        var d1Y = dataInicio.getFullYear();
        var d2Y = datafim.getFullYear();
        var d1M = dataInicio.getMonth();
        var d2M = datafim.getMonth();
        
        var difference = ((d2M+12*d2Y)-(d1M+12*d1Y)) / 12;
        /*
        if(difference >= 2)
            component.find('vidAmm2').set('v.readonly', false);
        else
        {
            component.find('vidAmm2').set('v.readonly', true);
            component.find('vidAmm2').set('v.value', 0);
        }
        if(difference >= 3)
            component.find('vidAmm3').set('v.readonly', false);
        else
        {
            component.find('vidAmm3').set('v.readonly', true);
            component.find('vidAmm3').set('v.value', 0);
        }
        if(difference >= 4)
            component.find('vidAmm4').set('v.readonly', false);
        else
        {
            component.find('vidAmm4').set('v.readonly', true);
            component.find('vidAmm4').set('v.value', 0);
        }
        if(difference >= 5)
            component.find('vidAmm5').set('v.readonly', false);
        else
        {
            component.find('vidAmm5').set('v.readonly', true);
            component.find('vidAmm5').set('v.value', 0);
        }
        if(difference >= 6)
            component.find('vidAmm6').set('v.readonly', 0);
        else
        {
            component.find('vidAmm6').set('v.readonly', true);
            component.find('vidAmm6').set('v.value', 0);
        }
        if(difference >= 7)
            component.find('vidAmm7').set('v.readonly', false);
        else
        {
            component.find('vidAmm7').set('v.readonly', true);
            component.find('vidAmm7').set('v.value', 0);
        }
        if(difference >= 8)
            component.find('vidAmm8').set('v.readonly', false);
        else
        {
            component.find('vidAmm8').set('v.readonly', true);
            component.find('vidAmm8').set('v.value', 0);
        }
        if(difference >= 9)
            component.find('vidAmm9').set('v.readonly', false);
        else
        {
            component.find('vidAmm9').set('v.readonly', true);
            component.find('vidAmm9').set('v.value', 0);
        }
        if(difference >= 10)
            component.find('vidAmm10').set('v.readonly', false);
        else
        {
            component.find('vidAmm10').set('v.readonly', true);
            component.find('vidAmm10').set('v.value', 0);
        }
        */
        console.log(difference);
        //alert(ctarget.value);
    },
    SelecionarItem: function(component, event, helper) {
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
    AbreSegundoPasso:function (component, event, helper)
    {
        var propriedadeSelecionada = component.get('v.PropriedadeSelecionda');  
        console.log('O que veio :' +propriedadeSelecionada);
        if(propriedadeSelecionada == undefined || propriedadeSelecionada == {})
        {
            alert('Favor selecionar uma propriedade');
            return;
        }
        
        var requestDto = component.get('v.CotacaoRequestDto');
        requestDto.Amm1 = propriedadeSelecionada.TW1_AMM__c;
        requestDto.ValorCondominio = propriedadeSelecionada.TW1_Condominio__c;
        requestDto.ValorFPP = propriedadeSelecionada.TW1_Fundo__c;
        /*requestDto.Amm2 = requestDto.Amm1;
        requestDto.Amm3 = requestDto.Amm1;
        requestDto.Amm4 = requestDto.Amm1;
        requestDto.Amm5 = requestDto.Amm1;
        requestDto.Amm6 = requestDto.Amm1;
        requestDto.Amm7 = requestDto.Amm1;
        requestDto.Amm8 = requestDto.Amm1;
        requestDto.Amm9 = requestDto.Amm1;
        requestDto.Amm10 = requestDto.Amm1;*/
        
        component.set('v.PrimeiraEtapaAtiva', false);
        component.set('v.SegundaEtapaAtiva', true);
    },
    VoltarPrimeiraEtapa: function(component, event, helper)
    {
        helper.MontarListaProprieadesDisponiveis(component);
        helper.MontarListaMesesAluguelDobrado(component);
        component.set('v.PropriedadeSelecionda', undefined);   
        component.set('v.PrimeiraEtapaAtiva', true);
        component.set('v.SegundaEtapaAtiva', false);
    },
    Salvar: function(component, event, helper)
    {
        var requestDto = component.get('v.CotacaoRequestDto');
        var dataAtual = component.get('v.DataAtual');
        
        var jsonCotacao = JSON.stringify(requestDto);
        console.log('Json de cotação: ' + jsonCotacao);
        
        if(requestDto.DataInicio == undefined || requestDto.Periodo == undefined)
        {
            alert('A data de inicio e o período são obrigatórios');
            return;
        }
        
        if(requestDto.DataInicio <  dataAtual)
        {
            alert('A data de inicio está menor que a data atual');
            return;
        }
        
        if(requestDto.Periodo <  1)
        {
            alert('O período não pode ser menor que 1');
            return;
        }
        
        if(requestDto.Amm1 == undefined || requestDto.Amm1 <=  0)
        {
            alert('É obrigatório o preenchimento de pelo menos 1 AMM (AMM1)');
            return;
        }
        
        var listaCampo = ['Amm2','Amm3','Amm4','Amm5','Amm6','Amm7','Amm8','Amm9','Amm10',
                          'TaxaTransferencia','ValorCondominio','ValorFPP','ValorCDU','AluguelPercentual',
                          'Carencia', 'ValorMidia'];
        
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
        
        helper.Salvar(component);
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
    }
})