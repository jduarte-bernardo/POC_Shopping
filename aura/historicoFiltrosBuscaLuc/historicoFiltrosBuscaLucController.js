({
	showListaLuc : function(component, event, helper){
        component.set("v.hideLucLista", false);
    },
    setListaLuc : function(component, event, helper){
        var listaLucs = event.getParam("lucs");
        component.set("v.listaLuc", listaLucs);
    },
    setLucBuscada : function(component, event, helper){
        var lucBuscada = event.getParam("lucBuscada");
        component.set("v.lucBuscada", lucBuscada);
    },
})