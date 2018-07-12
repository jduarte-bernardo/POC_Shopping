({
	buscarSegmento : function(component, event, helper) {
        var segmentoBuscado = component.get('v.segmentoBuscado');
        
        var actionGetSegmento = component.get("c.getSegmento");
        actionGetSegmento.setParams({
            "strSegmento" : segmentoBuscado
        });
        console.log('000 '+segmentoBuscado);
        actionGetSegmento.setCallback(this, function(response){

            var responseStatus = response.getState();
            if(responseStatus !== 'SUCCESS'){
                console.log('Failed with response status: ' + responseStatus);
            }else{
                var segmentoObtido = response.getReturnValue().Ramo_de_atividade__c;
				
                //Getting the Marca Buscada to show
                var showListaShoppingEvent = component.getEvent("showListaShopping");
                showListaShoppingEvent.fire();
                
                var setSegmentoBuscadoEvent = component.getEvent("setSegmentoBuscado");
                setSegmentoBuscadoEvent.setParam("segmentoBuscado", segmentoObtido);
                setSegmentoBuscadoEvent.fire();

                //Getting the shoppings list
                var actionGetShoppings = component.get("c.getShoppingsBySegmento");
                
                actionGetShoppings.setParam("strSegmento", segmentoObtido);
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
        $A.enqueueAction(actionGetSegmento);
    },
    keyUpBusca : function(component, event, helper) {
        if(event.getParams().keyCode == 13){
            var segmentoBuscado = component.get('v.segmentoBuscado');
            
            var actionGetSegmento = component.get("c.getSegmento");
            actionGetSegmento.setParams({
                "strSegmento" : segmentoBuscado
            });
            actionGetSegmento.setCallback(this, function(response){
                
                var responseStatus = response.getState();
                if(responseStatus !== 'SUCCESS'){
                    console.log('Failed with response status: ' + responseStatus);
                }else{
                    var segmentoObtido = response.getReturnValue().Name;
                    
                    //Getting the Marca Buscada to show
                    var showListaShoppingEvent = component.getEvent("showListaShopping");
                    showListaShoppingEvent.fire();
                    
                    var setSegmentoBuscadoEvent = component.getEvent("setSegmentoBuscado");
                    setSegmentoBuscadoEvent.setParam("segmentoBuscado", segmentoObtido);
                    setSegmentoBuscadoEvent.fire();
                    
                    //Getting the shoppings list
                    var actionGetShoppings = component.get("c.getShoppingsBySegmento");
                    
                    actionGetShoppings.setParam("strSegmento", segmentoObtido);
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
            $A.enqueueAction(actionGetSegmento);
        }
    }
})