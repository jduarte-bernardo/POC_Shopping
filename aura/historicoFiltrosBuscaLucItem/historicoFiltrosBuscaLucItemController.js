({
	showTabelaDados : function(component, event, helper) {
		var irTabelaDadosEvent = component.getEvent("showTabelaDados");
        
        irTabelaDadosEvent.setParam("shoppingId", component.get("v.shoppingId"));
        irTabelaDadosEvent.setParam("shoppingName", component.get("v.shoppingName"));
        irTabelaDadosEvent.setParam("lucName", component.get("v.luc.Name"));
        irTabelaDadosEvent.setParam("tipoBusca", 'shopping_luc');
        irTabelaDadosEvent.setParam("lucBuscada", component.get("v.luc.Name"));
        
        irTabelaDadosEvent.fire();
	}
})