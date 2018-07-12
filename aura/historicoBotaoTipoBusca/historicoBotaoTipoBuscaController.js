({
	doInit: function(component, event, helper){
        var currentBtn = component.find("btnTipoBusca");
        var tipoBusca = component.get("v.tipoBuscaName");
        
        if(tipoBusca == 'segmento'){
            var action = component.get("c.profileGerenteRegional");
            
            action.setCallback(this, function(response){
                var responseStatus = response.getState();
                if(responseStatus !== 'SUCCESS'){
                    console.log('Failed with response status: ' + responseStatus);
                }else{
                    component.set("v.buttonShow", response.getReturnValue());
                }
            });
            
            $A.enqueueAction(action);
        }else{
            component.set("v.buttonShow", true);
        }
    },
    selecionaTipoBusca : function(component, event, helper) {
        var tipoBusca = event.getSource().get("v.name");
        
        switch(tipoBusca){
            case 'marca':
                var irMarcaEvent = component.getEvent("showBuscaMarca");
                irMarcaEvent.fire();
                break;
            case 'segmento':
                var irSegmentoEvent = component.getEvent("showBuscaSegmento");
                irSegmentoEvent.fire();
                break;
            case 'shopping_luc':
                var irShoppingLucEvent = component.getEvent("showBuscaShoppingLuc");
                irShoppingLucEvent.fire();
                break;
            default:
                break;
        }
	}
})