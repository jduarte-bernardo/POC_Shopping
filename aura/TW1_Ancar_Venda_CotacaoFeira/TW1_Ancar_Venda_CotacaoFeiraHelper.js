({
    helperMethod : function() {
        
    },
    
    getCotacaoClone : function(component, callback) {
        //resgata a cotação a ser clonada
        console.log('Chamando serviço');
        var cotacaoId = component.get("v.recordId");
        var action = component.get('c.GetCotacaoClone');
        action.setParams({
            "vaCotacaoId": cotacaoId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Retorno: ' + state);
            if (component.isValid() && state === "SUCCESS") {
                var records = response.getReturnValue();
                var result = JSON.parse(records);
                
                component.set('v.CotacaoRequestDto', result);
                component.set("v.recordId", result.OpportunityId);
            }else{
                alert("Erro: "+records);
            }    
        });
        $A.enqueueAction(action);
    },
    
    getTipoDePropriedade : function(component, callback) {
        //resgata o tipo de propriedade
        console.log('Chamando serviço de busca de tipo de propriedade');
        var action = component.get('c.getListTipoDePropriedade');
        
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Retorno: ' + state);
            if (component.isValid() && state === "SUCCESS") {
                var records = response.getReturnValue();
                component.set('v.ListaTipoDePropriedade', records);
                
                var dto = component.get('v.RequestPesquisarPropriedadeDto');
                dto.Tipo = records[0];
                component.set('v.RequestPesquisarPropriedadeDto', dto);
                
                this.getSubTipoDePropriedade(component);
                
            }else{
                alert("Erro: "+records);
            }    
        });
        $A.enqueueAction(action);
    },
    
    getSubTipoDePropriedade: function(component)
    {
        //resgata o tipo de propriedade
        console.log('Chamando serviço de consulta subtipo');
        
        var dtoPesquisaPropriedade = component.get('v.RequestPesquisarPropriedadeDto');
        
        var action = component.get('c.getListarSubTipoPorTipo');
        action.setParams({
            "tipo": dtoPesquisaPropriedade.Tipo
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Retorno: ' + state);
            if (component.isValid() && state === "SUCCESS") {
                var records = response.getReturnValue();
                component.set('v.SubTipoDePropriedade', records);
                
                var dto = component.get('v.RequestPesquisarPropriedadeDto');
                dto.SubTipo = records[0];
                component.set('v.RequestPesquisarPropriedadeDto', dto);
            }else{
                alert("Erro: "+records);
            }    
        });
        $A.enqueueAction(action);
    },
    getDataAtual : function(component, callback) {
        //resgata o tipo de propriedade
        console.log('Chamando serviço');
        var action = component.get('c.GetCurrentDate');
        /*action.setParams({
            "vaRecordId": paRecordId
        });*/
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Retorno: ' + state);
            if (component.isValid() && state === "SUCCESS") {
                var records = response.getReturnValue();
                component.set('v.DataAtual', records);
            }else{
                alert("Erro: "+records);
            }    
        });
        $A.enqueueAction(action);
    },
    PesquisaPropriedade : function(component, callback){
        
        /// Montando lista de parâmetros
        var opportunityId = component.get("v.recordId");
        var request = component.get('v.RequestPesquisarPropriedadeDto');
        
        console.log('Request montado: ' + JSON.stringify(request));
        console.log('Oportunidade: ' + opportunityId);
        
        var action = component.get('c.PesquisaPropriedade');
        
        action.setParams({
            "opportunityId": opportunityId,
            "strrequest": JSON.stringify(request)
        });
        
        /// Executando ação
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var responseHelp = JSON.parse(response.getReturnValue());
                
                if(responseHelp != null)
                { 
                    if(responseHelp.length > 0)
                    {
                        component.set('v.ExisteResultadoParaFiltro', true);
                        component.set('v.ResultadoFiltroPropriedades', responseHelp);
                    }
                }
                else
                {
                    component.set('v.ExisteResultadoParaFiltro', false);
                    component.set('v.ResultadoFiltroPropriedades', []);
                }
            }else{
                alert("Erro: "+response);
            }    
            
            /// Liberando botão para consulta
            component.set('v.NaoPermitirPesquisar', false);
            component.set('v.LabelBtnPesquisar', 'Pesquisar');
        });
        $A.enqueueAction(action);
    },
    SalvarCotacao : function(component, callback)
    {
        var opportunityId = component.get("v.recordId");
        var request = component.get('v.CotacaoRequestDto');
        console.log('Salvando uma nova cotação');
        
        var action = component.get('c.PostSalvarCotacao');
        action.setParams({
            "opportunityId": opportunityId,
            "strrequest": JSON.stringify(request)
        });
        /// Executando ação
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Retorno: ' + state);
            
            if (component.isValid() && state === "SUCCESS") {
                
                component.set('v.PrimeiraEtapaAtiva',false);
                component.set('v.SegundaEtapaAtiva',false);
                
                //verificando se é tablet ou phone
                var urlAtual   = component.get('v.urlAtual');
                var device 	   = $A.get("$Browser.formFactor");
                
                if(device=='PHONE' || device=='TABLET' || device=='DESKTOP'){
                    if(urlAtual != '' || urlAtual != null){ 
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
                alert("Erro: "+response);
            }    
            
            /// Liberando botão para consulta
            component.set('v.NaoPermitirAcoes', false);
            component.set('v.LabelBtnSalvar', 'Salvar');
        });
        
        $A.enqueueAction(action);
    },
    toastThis : function(message, title) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title || "Error:",
            "message": message,
            "type": "error",
            "mode": 'pester'
        });
        toastEvent.fire();
    }
})