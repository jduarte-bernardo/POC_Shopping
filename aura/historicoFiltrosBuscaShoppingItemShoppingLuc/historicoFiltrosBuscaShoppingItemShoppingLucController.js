({
	showBuscaLuc : function(component, event, helper) {
		var irBuscaLucEvent = component.getEvent("showBuscaLuc");
        
        irBuscaLucEvent.setParams({
            "idShopping" : component.get("v.shoppingId"),
            "nomeShopping" : component.get("v.shoppingName")
        });
        irBuscaLucEvent.fire();
	}
})