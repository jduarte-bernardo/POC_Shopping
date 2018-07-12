({
	showTabelaDados : function(component, event, helper) {
		var irTabelaDadosEvent = component.getEvent("showTabelaDados");
        
        irTabelaDadosEvent.setParam("shoppingId", component.get("v.shoppingId"));
        irTabelaDadosEvent.setParam("shoppingName", component.get("v.shoppingName"));
        irTabelaDadosEvent.setParam("tipoBusca", component.get("v.tipoBusca"));
        if(component.get("v.tipoBusca") == 'marca'){
        	irTabelaDadosEvent.setParam("marcaBuscada", component.get("v.itemBuscado"));
        }else if(component.get("v.tipoBusca") == 'segmento'){
            irTabelaDadosEvent.setParam("segmentoBuscado", component.get("v.itemBuscado"));
        }
    
        irTabelaDadosEvent.fire();
	}
})