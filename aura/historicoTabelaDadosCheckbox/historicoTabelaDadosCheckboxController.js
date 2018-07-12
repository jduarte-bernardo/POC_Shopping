({
	checkboxChange : function(component, event, helper) {
        
        component.set('v.exibeColuna', (! component.get('v.exibeColuna') ));
        
        var exibirOcultarColunaEvent = component.getEvent("exibirOcultarColuna");
        exibirOcultarColunaEvent.setParams({
            'nomeColuna' : component.get('v.nomeColuna'),
            'exibeColuna' : component.get('v.exibeColuna')
        });
        exibirOcultarColunaEvent.fire();
	}
})