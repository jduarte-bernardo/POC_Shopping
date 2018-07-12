({
	showListaShopping : function(component, event, helper){
        component.set("v.hideShoppingLista", false);
    },
    setListaShopping : function(component, event, helper){
        var listaShoppings = event.getParam("shoppings");
        component.set("v.listaShopping", listaShoppings);
    },
    setShoppingBuscado : function(component, event, helper){
        var shoppingBuscado = event.getParam("shoppingBuscado");
        component.set("v.shoppingBuscado", shoppingBuscado);
    },
})