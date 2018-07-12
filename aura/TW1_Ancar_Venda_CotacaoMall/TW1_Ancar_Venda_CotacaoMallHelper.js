({
    getCotacaoClone : function(component, callback) {
        //resgata a cotação a ser clonada
        //console.log('Chamando serviço');
        var cotacaoId = component.get("v.recordId");
        var action = component.get('c.GetCotacaoClone');
        action.setParams({
            "vaCotacaoId": cotacaoId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log('Retorno: ' + state);
            if (component.isValid() && state === "SUCCESS") {
                var records = response.getReturnValue();
                var result = JSON.parse(records);
                
                component.set("v.PropriedadeSelecionda.Id", result.IdPropriedade);
                component.set("v.PropriedadeSelecionda.Name", result.NomePropriedade);
                component.set('v.CotacaoRequestDto', result);
                component.set("v.recordId", result.OpportunityId);
            }else{
                alert("Erro: "+records);
            }    
        });
        $A.enqueueAction(action);
    },
    getDataAtual : function(component, callback) {
        //resgata o tipo de propriedade
        //console.log('Chamando serviço');
        var action = component.get('c.GetCurrentDate');
        /*action.setParams({
            "vaRecordId": paRecordId
        });*/
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log('Retorno: ' + state);
            if (component.isValid() && state === "SUCCESS") {
                var records = response.getReturnValue();
                component.set('v.DataAtual', records);
            }else{
                alert("Erro: "+records);
            }    
        });
        $A.enqueueAction(action);
    },
    getSubTipoDePropriedade : function(component, callback) {
        //resgata o tipo de propriedade
        //console.log('Chamando serviço');
        var action = component.get('c.getListSubTipoDePropriedade');
        
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log('Retorno: ' + state);
            if (component.isValid() && state === "SUCCESS") {
                var records = response.getReturnValue();
                component.set('v.SubTipoDePropriedade', records);
                component.set('v.SubTipoSelecionado', records[0]);
                
                
                //resgata o tipo de propriedade
                //console.log('Chamando serviço');
                var opportunityId = component.get("v.recordId");
                var subTipo = component.get("v.SubTipoSelecionado");
                
                var action = component.get('c.PesquisarPropriedadeCotacaoMall');
                action.setParams({
                    "opportunityId": opportunityId,
                    "subTipo": subTipo
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    //console.log('Retorno: ' + state);
                    if (component.isValid() && state === "SUCCESS") {
                        var records = response.getReturnValue();
                        //console.log('Itens retornados');
                        //console.log(records);
                        if(records == null || records.Length < 1)
                            component.set("v.ExiteResultadoPesquisa", false);
                        else
                            component.set("v.ExiteResultadoPesquisa", true);
                        
                        component.set('v.ListaPropriedadesParaShopping', records);
                    }else{
                        alert("Erro: "+records);
                    }    
                });
                $A.enqueueAction(action);
                
                
            }else{
                alert("Erro: "+records);
            }    
        });
        $A.enqueueAction(action);
    },
    ListarPeriodoLocacao : function(component, callback) {
        //resgata o tipo de propriedade
        //console.log('Chamando serviço');
        var action = component.get('c.getListPeriodoLocacao');
        
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log('Retorno: ' + state);
            if (component.isValid() && state === "SUCCESS") {
                var records = response.getReturnValue();
                //console.log('Response de lista de periodo locacao');
                //console.log(records);
                component.set('v.ListaDePeriodoLocacao', records);
                //console.log('Lista preenchida');
                //console.log('Setando periodo locacao básico');
                component.set('v.CotacaoRequestDto.PeriodoLocacao', records[0]);
                //console.log('Locação basico preenchido');
            }else{
                alert("Erro: "+records);
            }    
        });
        $A.enqueueAction(action);
    },
    getListaPropriedadePorOpportunityESubTipo : function(component, callback) {
        //resgata o tipo de propriedade
        //console.log('Chamando serviço');
        var opportunityId = component.get("v.recordId");
        var subTipo = component.get("v.SubTipoSelecionado");
        
        var action = component.get('c.PesquisarPropriedadeCotacaoMall');
        action.setParams({
            "opportunityId": opportunityId,
            "subTipo": subTipo
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log('Retorno: ' + state);
            if (component.isValid() && state === "SUCCESS") {
                var records = response.getReturnValue();
                //console.log('Itens retornados');
                //console.log(records);
                if(records == null || records.Length < 1)
                    component.set("v.ExiteResultadoPesquisa", false);
                else
                    component.set("v.ExiteResultadoPesquisa", true);
                
                component.set('v.ListaPropriedadesParaShopping', records);
            }else{
                alert("Erro: "+records);
            }    
        });
        $A.enqueueAction(action);
    },
    Salvar : function(component, callback) {
        //resgata o tipo de propriedade
        //console.log('Chamando serviço');
        //console.log(component.get("v.recordId"));
        //console.log(component.get("v.CotacaoRequestDto"));
        //console.log(component.get("v.PropriedadeSelecionda"));
        
        var opportunityId = component.get("v.recordId");
        var requestDto = component.get('v.CotacaoRequestDto');
        var propriedadeSelecionada = component.get('v.PropriedadeSelecionda'); 
        requestDto.NomePropriedade = propriedadeSelecionada.Name;
        
        var action = component.get('c.SalvarCotacao');
        action.setParams({
            "opportunityId": opportunityId,
            "IdPropriedade": propriedadeSelecionada.Id,
            "strCotacao": JSON.stringify(requestDto)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log('Retorno: ' + state);
            
            component.set('v.LabelBtnSalvar', 'Salvar');        
            component.set('v.NaoPermitirAcoes', false);        
            
            if (component.isValid() && state == "SUCCESS") {
                component.set('v.PrimeiraEtapaAtiva',false);
                component.set('v.SegundaEtapaAtiva',false);
                
                //verificando se é tablet ou phone
                var urlAtual   = component.get('v.urlAtual');
                var device 	   = $A.get("$Browser.formFactor");
                
                if(device=='PHONE' || device=='TABLET' || device=='DESKTOP'){
                    if(urlAtual != '' && urlAtual != null){ 
                        component.set('v.CotacaoSucesso',true);
                        component.set("v.exibeBotaoDeVoltar",true);
                    }else{
                        $A.get("e.force:closeQuickAction").fire();
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Sucesso!",
                            "type": "success",
                            "message": "Cotação salva com sucesso!",
                            "mode": 'pester'
                        });
                        toastEvent.fire();
                    }
                }
                else{
                    //desktop
                    if(urlAtual == '' || urlAtual == null){ 
                        $A.get("e.force:closeQuickAction").fire();
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Sucesso!",
                            "type": "success",
                            "message": "Cotação salva com sucesso!",
                            "mode": 'pester'
                        });
                        toastEvent.fire();
                        
                    }else{
                        component.set('v.CotacaoSucesso',true);
                    }
                    
                }
                
            }else{
                alert("Erro em salvar cotação");
                //console.log('Erro em salvar locação de mall: ');
                //console.log(response);
            }    
        });
        $A.enqueueAction(action);
    }
})