({
    doInit : function(component, event, helper) {
        
    },
    RefinarRelatorioOcupacao: function(component, event, helper) {
        var params = event.getParam('arguments');
        console.log('Parâmetro');
        console.log(params);
        if (params) {
            console.log('Propriedade recebida por parâmetro');
            console.log(params.propriedade);
            component.set('v.PropriedadeRelatorio', params.propriedade);
            console.log("Inicio de refinação de relatório");
            component.set('v.LabelBtnPesquisar', 'Refinando lista...');
            component.set('v.NaoPermitirPesquisar', true);
            helper.PostRefinarRelatorio(component);
        }
    },
    Refinar:function(component, event, helper) {
        console.log("Inicio de refinação de relatório");
        component.set('v.LabelBtnPesquisar', 'Refinando lista...');
        component.set('v.NaoPermitirPesquisar', true);
        helper.PostRefinarRelatorio(component);
    }
    
})