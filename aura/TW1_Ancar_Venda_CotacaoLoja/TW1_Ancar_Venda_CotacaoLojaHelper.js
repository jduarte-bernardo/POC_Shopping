({
    
    
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
              
                component.set("v.PropriedadeSelecionda", result.Propriedade);
                
           		 var listmes = result.MesAluguelDobrado.split(';');
      
                for(var j =0; j > listmes.leght; j++)
                {
                     var selectCmp = cmp.find("mesdoalugueldobrado");
         			 var resultCmp = cmp.find(listmes[j]);
         			 resultCmp.set("v.value", selectCmp.get("v.value"));
                }
                
               component.find('mesdoalugueldobrado').set('v.value',result.MesAluguelDobrado);
               //component.find('TaxaDeTransferencia').set('v.value',result.TaxaTransferencia);
              
               component.set('v.recordId', result.OpportunityId);
                
            }else{
                alert("Erro: "+records);
            }    
        });
        $A.enqueueAction(action);
    },
    
    MontarListaProprieadesDisponiveis : function(component, callback){
        
        /// Montando lista de parâmetros
        var opportunityId = component.get("v.recordId");;
        console.log('Oportunidade: ' + opportunityId);
        
        var action = component.get('c.getListaPropriedadesDisponiveis');
        action.setParams({
            "opportunityId": opportunityId
        });
        
        /// Executando ação
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Retorno: ' + state);
            
            if (component.isValid() && state === "SUCCESS") {
                
                var response = response.getReturnValue();
                console.log('response: ' + response);
                component.set('v.ExibeListaPropriedade', true);
                component.set('v.ListaPropriedadesParaShopping', response);
                
            }else{
                alert("Erro: "+response);
            }
        });
        $A.enqueueAction(action);
    },
    MontarListaMesesAluguelDobrado : function(component, callback) {
        /// Montando lista de parâmetros
        console.log('Executando chamada ao serviço para buscar meses de aluguel dobrado');
        var action = component.get('c.getListaMeses');
        console.log('Action criada');
        /// Executando ação
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Retorno: ' + state);
            
            if (component.isValid() && state === "SUCCESS") {
                
                var response = response.getReturnValue();
                console.log('response: ' + response);
                component.set('v.ListaMesesAluguelDobrado', response);
                
            }else{
                alert("Erro: "+response);
            }
        });
        $A.enqueueAction(action);
    },
    BuscarDataAtual : function(component, callback){
        /// Montando lista de parâmetros
        console.log('Executando chamada ao serviço para buscar meses de aluguel dobrado');
        var action = component.get('c.getDataAtual');
        console.log('Action criada');
        /// Executando ação
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Retorno: ' + state);
            
            if (component.isValid() && state === "SUCCESS") {
                
                var response = response.getReturnValue();
                console.log('response: ' + response);
                component.set('v.DataAtual', response);
                
            }else{
                alert("Erro: "+response);
            }
        });
        $A.enqueueAction(action);
    },
    Salvar :function(component, callback){
       
        /// Montando lista de parâmetros
        console.log('Executando chamada ao serviço para salvar cotação');
        /// Montando lista de parâmetros
        var opportunityId = component.get("v.recordId");
        console.log('Oportunidade: ' + opportunityId);    

        var propriedade = component.get("v.PropriedadeSelecionda");
        var cotacaoDto = component.get("v.CotacaoRequestDto");
        
        cotacaoDto.Propriedade = propriedade;
        
        var action = component.get('c.SalvarCotacao');
        console.log('Action criada');
        action.setParams({
            "opportunityId": opportunityId,
            "idPropriedade": propriedade.Id,
            "strCotacaoDto": JSON.stringify(cotacaoDto)
        });
        
        /// Executando ação
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Retorno CallBack: ' + state);
            
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
        });
        $A.enqueueAction(action);
    }
   
})