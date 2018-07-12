({
	showTipoBusca : function(component, event, helper) {
		component.set("v.hideHistoricoFiltrosBuscaMarca", true);
        component.set("v.hideHistoricoFiltrosBuscaSegmento", true);
        component.set("v.hideHistoricoFiltrosBuscaShoppingLuc", true);
        component.set("v.hideHistoricoTabelaDados", true);
        component.set("v.hideHistoricoTipoBusca", false);
	},
    showBuscaMarca : function(component, event, helper) {
        component.set("v.hideHistoricoTipoBusca", true);
		component.set("v.hideHistoricoFiltrosBuscaSegmento", true);
        component.set("v.hideHistoricoFiltrosBuscaShoppingLuc", true);
        component.set("v.hideHistoricoTabelaDados", true);
        component.set("v.hideHistoricoFiltrosBuscaMarca", false);
	},
    showBuscaSegmento : function(component, event, helper) {
		component.set("v.hideHistoricoTipoBusca", true);
        component.set("v.hideHistoricoFiltrosBuscaMarca", true);
		component.set("v.hideHistoricoFiltrosBuscaShoppingLuc", true);
        component.set("v.hideHistoricoTabelaDados", true);
        component.set("v.hideHistoricoFiltrosBuscaSegmento", false);
	},
    showBuscaShoppingLuc : function(component, event, helper) {
		component.set("v.hideHistoricoTipoBusca", true);
        component.set("v.hideHistoricoFiltrosBuscaMarca", true);
        component.set("v.hideHistoricoFiltrosBuscaSegmento", true);
		component.set("v.hideHistoricoTabelaDados", true);
        component.set("v.hideHistoricoFiltrosBuscaShoppingLuc", false);
	},
    showTabelaDados : function(component, event, helper) {
        var shoppingId = event.getParam("shoppingId")
        component.set("v.shoppingId", shoppingId);
        var shoppingName = event.getParam("shoppingName");
        component.set("v.shoppingName", shoppingName);
        var lucName = event.getParam("lucName");
        component.set("v.lucName", lucName);
        var tipoBusca = event.getParam("tipoBusca");
        component.set("v.tipoBusca", tipoBusca);
        var marcaBuscada = event.getParam("marcaBuscada");
        component.set("v.marcaBuscada", marcaBuscada);
        var segmentoBuscado = event.getParam("segmentoBuscado");
        component.set("v.segmentoBuscado", segmentoBuscado);
        var lucBuscada = event.getParam("lucBuscada");
        component.set("v.lucBuscada", lucName);
        //console.log(lucName);
      	
        var action = component.get("c.getTabelaHistorica");
        action.setParams({
            "shoppingId": shoppingId,
            "lucName": lucName,
            "marcaBuscada": marcaBuscada,
            "segmentoBuscado": segmentoBuscado,
            "lucBuscada": lucBuscada,
            "shoppingBuscado": shoppingName,
            "tipoBusca": tipoBusca
        });
        action.setCallback(this, function(response){
            var responseStatus = response.getState();
            if(responseStatus !== 'SUCCESS'){
                console.log('Failed with response status: ' + responseStatus);
            }else{
                component.set("v.listaHistorico", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
		component.set("v.hideHistoricoTipoBusca", true);
        component.set("v.hideHistoricoFiltrosBuscaMarca", true);
        component.set("v.hideHistoricoFiltrosBuscaSegmento", true);
        component.set("v.hideHistoricoFiltrosBuscaShoppingLuc", true);
		component.set("v.hideHistoricoTabelaDados", false);
	}
})