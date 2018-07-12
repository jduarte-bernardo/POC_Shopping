({
    getShoppingLista : function(component, event, helper) {
        var shoppingBuscado = component.get('v.shoppingBuscado');
        
        var actionGetListaShopping = component.get("c.getListaShoppings");
        actionGetListaShopping.setParam("strShopping", shoppingBuscado);
        actionGetListaShopping.setCallback(this, function(response){
            var responseStatus = response.getState();
            if(responseStatus !== 'SUCCESS'){
                console.log('Failed with response status: ' + responseStatus);
            }else{
                var listaShopping = response.getReturnValue();
                
                component.set('v.listaShopping', listaShopping);
                component.set('v.hideHead', false);
                component.set('v.hideLista', false);
            }
        });
        $A.enqueueAction(actionGetListaShopping);
    },
    limparShoppingBuscado : function(component, event, helper) {
        component.set('v.shoppingBuscado', '');
        
        var shoppingBuscado = component.get('v.shoppingBuscado');
        
        var actionGetListaShopping = component.get("c.getListaShoppings");
        actionGetListaShopping.setParam("strShopping", shoppingBuscado);
        actionGetListaShopping.setCallback(this, function(response){
            var responseStatus = response.getState();
            if(responseStatus !== 'SUCCESS'){
                console.log('Failed with response status: ' + responseStatus);
            }else{
                var listaShopping = response.getReturnValue();
                
                component.set('v.listaShopping', listaShopping);
                component.set('v.hideHead', false);
                component.set('v.hideLista', false);
            }
        });
        $A.enqueueAction(actionGetListaShopping);
    },
    showTabelaDados : function(component, event, helper) {
        var shoppingId = event.getSource().get('v.value');
        var shoppingName = event.getSource().get('v.name');
        
        var actionGetTabelaDados = component.get("c.getLucsByShopping");
        actionGetTabelaDados.setParam("idShopping", shoppingId);
        actionGetTabelaDados.setCallback(this, function(response){
            var responseStatus = response.getState();
            if(responseStatus !== 'SUCCESS'){
                console.log('Failed with response status: ' + responseStatus);
            }else{
                var tabelaDados = response.getReturnValue();
                
                component.set('v.tabelaDados', tabelaDados);
                component.set('v.shoppingName', shoppingName);
                
                component.set('v.hideHead', true);
                component.set('v.hideLista', true);
                component.set('v.hideTabela', false);
            }
        });
        $A.enqueueAction(actionGetTabelaDados);
        
	},
    exibirOcultarColuna : function(component, event, helper) {
        var nomeColuna = event.getParam('nomeColuna');
        var exibeColuna = event.getParam('exibeColuna');
		console.log('fora: '+qtdColunasExibidas);
        if(exibeColuna == true){
            var qtdColunasExibidas = 0;
            console.log('entro: '+qtdColunasExibidas);
            qtdColunasExibidas += (component.get('v.nrLuc') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.piso') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.statusProspeccao') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.status') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.area') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.amm') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.ammM2') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.fundo') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.otn') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.ammOtn') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.valorTr') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.condominio') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.cto') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.resM2') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.resSperata') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.iptu') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.observacao') == true) ? 1 : 0;
           
            if(qtdColunasExibidas > 2){
                exibeColuna = ! exibeColuna;
                console.log('exibe Coluna: '+exibeColuna);
            }
        }
        
        switch(nomeColuna){
            case 'Piso':
                component.set('v.piso', exibeColuna);
                break;
            case 'Status de Prospecção':
                component.set('v.statusProspeccao', exibeColuna);
                break;
            case 'Status':
                component.set('v.status', exibeColuna);
                break;
            case 'Área':
                component.set('v.area', exibeColuna);
                break;
            case 'AMM':
                component.set('v.amm', exibeColuna);
                break;
            case 'AMM/m²':
                component.set('v.ammM2', exibeColuna);
                break;
            case 'Fundo':
                component.set('v.fundo', exibeColuna);
                break;
            case 'OTN':
                component.set('v.otn', exibeColuna);
                break;
            case 'AMM/OTN':
                component.set('v.ammOtn', exibeColuna);
                break;
            case 'Valor TR':
                component.set('v.valorTr', exibeColuna);
                break;
            case 'Condomínio':
                component.set('v.condominio', exibeColuna);
                break;
            case 'CTO':
                component.set('v.cto', exibeColuna);
                break;
            case 'Res/m²':
                component.set('v.resM2', exibeColuna);
                break;
            case 'Res Sperata':
                component.set('v.resSperata', exibeColuna);
                break;
            case 'IPTU':
                component.set('v.iptu', exibeColuna);
                break;
            case 'Observação':
                component.set('v.observacao', exibeColuna);
                break;
        }
    },
    keyUpBusca : function(component, event, helper){
        if(event.getParams().keyCode == 13){
            var shoppingBuscado = component.get('v.shoppingBuscado');
            
            var actionGetListaShopping = component.get("c.getListaShoppings");
            actionGetListaShopping.setParam("strShopping", shoppingBuscado);
            actionGetListaShopping.setCallback(this, function(response){
                var responseStatus = response.getState();
                if(responseStatus !== 'SUCCESS'){
                    console.log('Failed with response status: ' + responseStatus);
                }else{
                    var listaShopping = response.getReturnValue();
                    
                    component.set('v.listaShopping', listaShopping);
                    component.set('v.hideHead', false);
                    component.set('v.hideLista', false);
                }
            });
            $A.enqueueAction(actionGetListaShopping);
        }
    },
    showHead : function(component, event, helper){
        component.set('v.hideHead', false);
        component.set('v.hideLista', false);
        component.set('v.hideTabela', true);
        //console.log('teste');
    }
})