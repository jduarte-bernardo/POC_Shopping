({
	getObjectById : function(component, callback) {
        
       /// Montando lista de parâmetros
        var opportunityId = component.get("v.recordId");
        
        var action = component.get('c.getObjectById');
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        //alert(opportunityId);
        /// Executando ação
        action.setCallback(this, function(response){
            var state = response.getState();
           
            if (component.isValid() && state === "SUCCESS") {
                
                var response = response.getReturnValue();
                var result = JSON.parse(response);
  				
                 component.set('v.TipoChamada', result.TipoChamada);
                 component.set('v.TipoRegistro', result.TipoRegistro);
              
            }else{
                //alert("Erro: "+response);
            }
        });
        $A.enqueueAction(action); 
    }
})