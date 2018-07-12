({
    showListaShopping : function(component, event, helper){
        component.set("v.hideShoppingLista", false);
    },
    setListaShopping : function(component, event, helper){
        var listaShoppings = event.getParam("shoppings");
        component.set("v.listaShopping", listaShoppings);
    },
    setMarcaBuscada : function(component, event, helper){
        var marcaBuscada = event.getParam("marcaBuscada");
        component.set("v.marcaBuscada", marcaBuscada);
    }
})