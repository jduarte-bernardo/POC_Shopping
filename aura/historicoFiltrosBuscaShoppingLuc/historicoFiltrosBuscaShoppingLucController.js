({
	showBuscaShopping : function(component, event, helper) {
		component.set("v.hideFiltrosBuscaLuc", true);
        component.set("v.hideFiltrosBuscaShopping", false);
	},
    showBuscaLuc : function(component, event, helper) {
		component.set("v.hideFiltrosBuscaShopping", true);
        
        component.set("v.idShopping", event.getParam("idShopping"));
        component.set("v.nomeShopping", event.getParam("nomeShopping"));
        
        component.set("v.hideFiltrosBuscaLuc", false);
	}
})