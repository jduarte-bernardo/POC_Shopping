({
	buscarShopping : function(component, event, helper) {
        var shoppingBuscado = component.get('v.shoppingBuscado');
        
        //Getting the Shopping Buscado to show
        var showListaShoppingEvent = component.getEvent("showListaShopping");
        showListaShoppingEvent.fire();
        
        var setShoppingBuscadoEvent = component.getEvent("setShoppingBuscado");
        setShoppingBuscadoEvent.setParam("shoppingBuscado", shoppingBuscado);
        setShoppingBuscadoEvent.fire();
        
        //Getting the shoppings list
        var actionGetShoppings = component.get("c.getShoppingsByShopping");
        actionGetShoppings.setParam("strShopping", shoppingBuscado);
        actionGetShoppings.setCallback(this, function(response){
            var responseStatus = response.getState();
            if(responseStatus !== 'SUCCESS'){
                console.log('Failed with response status: ' + responseStatus);
            }else{
                var listaShoppings = response.getReturnValue();
                
                var setShoppingLista = component.getEvent("setListaShopping");
                setShoppingLista.setParam("shoppings", listaShoppings);
                setShoppingLista.fire();
            }
        });
        $A.enqueueAction(actionGetShoppings);
	},
    limparShoppingBuscado : function(component, event, helper) {
        component.set('v.shoppingBuscado', '');
        
        var shoppingBuscado = component.get('v.shoppingBuscado');
        
        //Getting the Shopping Buscado to show
        var showListaShoppingEvent = component.getEvent("showListaShopping");
        showListaShoppingEvent.fire();
        
        var setShoppingBuscadoEvent = component.getEvent("setShoppingBuscado");
        setShoppingBuscadoEvent.setParam("shoppingBuscado", shoppingBuscado);
        setShoppingBuscadoEvent.fire();
        
        //Getting the shoppings list
        var actionGetShoppings = component.get("c.getShoppingsByShopping");
        actionGetShoppings.setParam("strShopping", shoppingBuscado);
        actionGetShoppings.setCallback(this, function(response){
            var responseStatus = response.getState();
            if(responseStatus !== 'SUCCESS'){
                console.log('Failed with response status: ' + responseStatus);
            }else{
                var listaShoppings = response.getReturnValue();
                
                var setShoppingLista = component.getEvent("setListaShopping");
                setShoppingLista.setParam("shoppings", listaShoppings);
                setShoppingLista.fire();
            }
        });
        $A.enqueueAction(actionGetShoppings);
    },
    keyUpBusca : function(component, event, helper) {
       if(event.getParams().keyCode == 13){
           var shoppingBuscado = component.get('v.shoppingBuscado');
           
            //Getting the Shopping Buscado to show
            var showListaShoppingEvent = component.getEvent("showListaShopping");
            showListaShoppingEvent.fire();
            
            var setShoppingBuscadoEvent = component.getEvent("setShoppingBuscado");
            setShoppingBuscadoEvent.setParam("shoppingBuscado", shoppingBuscado);
            setShoppingBuscadoEvent.fire();
            
            //Getting the shoppings list
            var actionGetShoppings = component.get("c.getShoppingsByShopping");
            actionGetShoppings.setParam("strShopping", shoppingBuscado);
            actionGetShoppings.setCallback(this, function(response){
                var responseStatus = response.getState();
                if(responseStatus !== 'SUCCESS'){
                    console.log('Failed with response status: ' + responseStatus);
                }else{
                    var listaShoppings = response.getReturnValue();
                    
                    var setShoppingLista = component.getEvent("setListaShopping");
                    setShoppingLista.setParam("shoppings", listaShoppings);
                    setShoppingLista.fire();
                }
            });
            $A.enqueueAction(actionGetShoppings);
        }
    }
})