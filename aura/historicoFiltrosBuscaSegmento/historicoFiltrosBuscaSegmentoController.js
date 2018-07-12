({
	showListaShopping : function(component, event, helper){
        component.set("v.hideShoppingLista", false);
    },
    setListaShopping : function(component, event, helper){
        var listaShoppings = event.getParam("shoppings");
        component.set("v.listaShopping", listaShoppings);
    },
    setSegmentoBuscado : function(component, event, helper){
        var segmentoBuscado = event.getParam("segmentoBuscado");
        component.set("v.segmentoBuscado", segmentoBuscado);
    },
})