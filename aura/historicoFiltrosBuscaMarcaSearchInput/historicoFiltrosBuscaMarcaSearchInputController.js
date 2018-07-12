({
	buscarMarca : function(component, event, helper) {
        var marcaBuscada = component.get('v.marcaBuscada');
        
        var actionGetMarca = component.get("c.getMarca");
        actionGetMarca.setParams({
            "strMarca" : marcaBuscada
        });
        actionGetMarca.setCallback(this, function(response){
            
            var responseStatus = response.getState();
            if(responseStatus !== 'SUCCESS'){
                console.log('Failed with response status: ' + responseStatus);
            }else{
                var marcaObtida = response.getReturnValue().Name;
                
                //Getting the Marca Buscada to show
                var showListaShoppingEvent = component.getEvent("showListaShopping");
                showListaShoppingEvent.fire();
                
                var setMarcaBuscadaEvent = component.getEvent("setMarcaBuscada");
                setMarcaBuscadaEvent.setParam("marcaBuscada", marcaObtida);
                setMarcaBuscadaEvent.fire();
                
                //Getting the shoppings list
                var actionGetShoppings = component.get("c.getShoppingsByMarca");
                actionGetShoppings.setParam("strMarca", marcaObtida);
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
        });
        $A.enqueueAction(actionGetMarca);

	},
    keyUpBusca : function(component, event, helper) {
        if(event.getParams().keyCode == 13){
            var marcaBuscada = component.get('v.marcaBuscada');
            
            var actionGetMarca = component.get("c.getMarca");
            actionGetMarca.setParams({
                "strMarca" : marcaBuscada
            });
            actionGetMarca.setCallback(this, function(response){
                
                var responseStatus = response.getState();
                if(responseStatus !== 'SUCCESS'){
                    console.log('Failed with response status: ' + responseStatus);
                }else{
                    var marcaObtida = response.getReturnValue().Name;
                    
                    //Getting the Marca Buscada to show
                    var showListaShoppingEvent = component.getEvent("showListaShopping");
                    showListaShoppingEvent.fire();
                    
                    var setMarcaBuscadaEvent = component.getEvent("setMarcaBuscada");
                    setMarcaBuscadaEvent.setParam("marcaBuscada", marcaObtida);
                    setMarcaBuscadaEvent.fire();
                    
                    //Getting the shoppings list
                    var actionGetShoppings = component.get("c.getShoppingsByMarca");
                    actionGetShoppings.setParam("strMarca", marcaObtida);
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
            });
            $A.enqueueAction(actionGetMarca);
        }
    }
})