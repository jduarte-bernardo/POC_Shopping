({
    doinit: function(component, event, helper) {
        
        if(component.get('v.TipoRegistro') == '' || component.get('v.TipoRegistro') == null)
        {
             helper.getObjectById(component);
        }        
    }
})