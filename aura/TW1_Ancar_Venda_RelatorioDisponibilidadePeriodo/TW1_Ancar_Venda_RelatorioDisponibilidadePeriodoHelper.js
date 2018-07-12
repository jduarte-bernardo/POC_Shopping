({
    PostRefinarRelatorio : function(component) {
        console.log("Refinando lista");
        
        //resgata a cotação a ser clonada
        console.log('Chamando serviço');
        var propriedadeRelatorio = component.get("v.PropriedadeRelatorio");
        console.log('Propriedade sendo consultada');
        console.log(propriedadeRelatorio);
        
        var requestPesquisa = {
            idPropriedade: propriedadeRelatorio.IdPropriedade,
            DataInicio: propriedadeRelatorio.DataInicio,
            DataFim: propriedadeRelatorio.DataFim
        }; 
        
        console.log('Request montado: ' + JSON.stringify(requestPesquisa));
        
        var action = component.get('c.ProcessaRelatorio');
        action.setParams({
            "strrequest": JSON.stringify(requestPesquisa)            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Retorno: ' + state);
            if (component.isValid() && state === "SUCCESS") {
                var records = response.getReturnValue();
                console.log('Retorno do serviço');
                console.log(records);
                console.log('Parse objeto');
                var result = JSON.parse(records);
                console.log(result);
                
                component.set('v.Ocupacoes', result);
                
                if(result.length > 0)
                    component.set('v.ExisteOportunidadesNoPeriodo', true);
                else
                    component.set('v.ExisteOportunidadesNoPeriodo', false);
                
                component.set('v.NaoPermitirPesquisar', false);
                component.set('v.LabelBtnPesquisar', 'Refinar');
            }else{
                alert("Erro: "+records);
            }    
        });
        $A.enqueueAction(action);
    }
})