({
	buscarLuc : function(component, event, helper) {
        var lucBuscada = component.get('v.lucBuscada');
        var idShopping = component.get('v.idShopping');
        
        var actionGetLuc = component.get("c.getLuc");
        actionGetLuc.setParams({
            "strLuc" : lucBuscada,
            "idShopping" : idShopping
        });
        actionGetLuc.setCallback(this, function(response){
            
            var responseStatus = response.getState();
            if(responseStatus !== 'SUCCESS'){
                console.log('Failed with response status: ' + responseStatus);
            }else{
                var lucObtida = response.getReturnValue().Name;
                
                //Getting the LUC Buscada to show
                var showListaShoppingEvent = component.getEvent("showListaLuc");
                showListaShoppingEvent.fire();
                
                var setLucBuscadaEvent = component.getEvent("setLucBuscada");
                setLucBuscadaEvent.setParams({
                    "lucBuscada": lucObtida,
                    "idShopping": idShopping
                });
                setLucBuscadaEvent.fire();
                
                //Getting the shoppings list
                var actionGetLucs = component.get("c.getLucsByLuc");
                actionGetLucs.setParams({
                    "strLuc": lucObtida,
                    "idShopping": idShopping
                });
                actionGetLucs.setCallback(this, function(response){
                    var responseStatus = response.getState();
                    if(responseStatus !== 'SUCCESS'){
                        console.log('Failed with response status: ' + responseStatus);
                    }else{
                        var listaLucs = response.getReturnValue();
                        
                        var setListaLuc = component.getEvent("setListaLuc");
                        setListaLuc.setParam("lucs", listaLucs);
                        setListaLuc.fire();
                    }
                });
                $A.enqueueAction(actionGetLucs);
            }
        });
        $A.enqueueAction(actionGetLuc);
	},
    keyUpBusca : function(component, event, helper) {
        if(event.getParams().keyCode == 13){
            var lucBuscada = component.get('v.lucBuscada');
            var idShopping = component.get('v.idShopping');
            
            var actionGetLuc = component.get("c.getLuc");
            actionGetLuc.setParams({
                "strLuc" : lucBuscada,
                "idShopping" : idShopping
            });
            actionGetLuc.setCallback(this, function(response){
                
                var responseStatus = response.getState();
                if(responseStatus !== 'SUCCESS'){
                    console.log('Failed with response status: ' + responseStatus);
                }else{
                    var lucObtida = response.getReturnValue().Name;
                    
                    //Getting the LUC Buscada to show
                    var showListaShoppingEvent = component.getEvent("showListaLuc");
                    showListaShoppingEvent.fire();
                    
                    var setLucBuscadaEvent = component.getEvent("setLucBuscada");
                    setLucBuscadaEvent.setParams({
                        "lucBuscada": lucObtida,
                        "idShopping": idShopping
                    });
                    setLucBuscadaEvent.fire();
                    
                    //Getting the shoppings list
                    var actionGetLucs = component.get("c.getLucsByLuc");
                    actionGetLucs.setParams({
                        "strLuc": lucObtida,
                        "idShopping": idShopping
                    });
                    actionGetLucs.setCallback(this, function(response){
                        var responseStatus = response.getState();
                        if(responseStatus !== 'SUCCESS'){
                            console.log('Failed with response status: ' + responseStatus);
                        }else{
                            var listaLucs = response.getReturnValue();
                            
                            var setListaLuc = component.getEvent("setListaLuc");
                            setListaLuc.setParam("lucs", listaLucs);
                            setListaLuc.fire();
                        }
                    });
                    $A.enqueueAction(actionGetLucs);
                }
            });
            $A.enqueueAction(actionGetLuc);
        }
    }
})