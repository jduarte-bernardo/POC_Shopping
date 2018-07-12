({
	showTipoBusca : function(component, event, helper) {
		var irTipoBuscaEvent = component.getEvent("showTipoBusca");
        irTipoBuscaEvent.fire();
	},
    showBuscaShopping : function(component, event, helper) {
		var irBuscaShoppingEvent = component.getEvent("showBuscaShopping");
        irBuscaShoppingEvent.fire();
	}
})