({
    doInit: function(component, event, helper) {
    },
    showTipoBusca : function(component, event, helper) {
        var irTipoBuscaEvent = component.getEvent("showTipoBusca");
        irTipoBuscaEvent.fire();
    },
    showBuscaMarca : function(component, event, helper) {
        var irMarcaEvent = component.getEvent("showBuscaMarca");
        irMarcaEvent.fire();
    },
    showBuscaSegmento : function(component, event, helper) {
        var irSegmentoEvent = component.getEvent("showBuscaSegmento");
        irSegmentoEvent.fire();
    },
    showBuscaShoppingLuc : function(component, event, helper) {
        var irShoppingLucEvent = component.getEvent("showBuscaShoppingLuc");
        irShoppingLucEvent.fire();
    },
    exibirOcultarColuna : function(component, event, helper) {
        var nomeColuna = event.getParam('nomeColuna'); 
        var exibeColuna = event.getParam('exibeColuna');
        
        if(exibeColuna == true){
            var qtdColunasExibidas = 0;
            
            qtdColunasExibidas += (component.get('v.nrLuc') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.areaLuc') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.aluguelPercentual') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.vlrVendaTotal') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.vlrVendaTotalM2') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.amm') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.ammM2') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.vlrCondominioComum') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.vlrCondominioComumM2') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.vlrFpp') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.vlrFppM2') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.vlrCustoOcupComum') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.vlrCustoOcupComumM2') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.vlrGroccComum') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.aluguelDobrado') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.nomeFantasia') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.grupoAtividadeBr') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.ramoAtividadeBr') == true) ? 1 : 0;
            qtdColunasExibidas += (component.get('v.tipoAtividadeBr') == true) ? 1 : 0;
            
            if(qtdColunasExibidas > 2){
                exibeColuna = ! exibeColuna;
            }
        }
        
        switch(nomeColuna){
            case 'Nr Luc':
                component.set('v.nrLuc', exibeColuna);
                break;
            case 'Área LUC':
                component.set('v.areaLuc', exibeColuna);
                break;
            case 'Aluguel %':
                component.set('v.aluguelPercentual', exibeColuna);
                break;
            case 'Vlr Venda Total':
                component.set('v.vlrVendaTotal', exibeColuna);
                break;
            case 'Vlr Venda Total/m²':
                component.set('v.vlrVendaTotalM2', exibeColuna);
                break;
            case 'AMM':
                component.set('v.amm', exibeColuna);
                break;
            case '% Sobre Vendas':
                component.set('v.porcentagemSobreVendas', exibeColuna);
                break;
            case 'AMM/m²':
                component.set('v.ammM2', exibeColuna);
                break;
            case 'Vlr Condomínio Comum':
                component.set('v.vlrCondominioComum', exibeColuna);
                break;
            case 'Vlr Condomínio Comum/m²':
                component.set('v.vlrCondominioComumM2', exibeColuna);
                break;
            case 'Vlr FPP':
                component.set('v.vlrFpp', exibeColuna);
                break;
            case 'Vlr FPP/m²':
                component.set('v.vlrFppM2', exibeColuna);
                break;
            case 'Vlr Custo Ocup - Comum':
                component.set('v.vlrCustoOcupComum', exibeColuna);
                break;
            case 'Vlr Custo Ocup - Comum/m²':
                component.set('v.vlrCustoOcupComumM2', exibeColuna);
                break;
            case 'Vlr Grocc - Comum':
                component.set('v.vlrGroccComum', exibeColuna);
                break;
            case 'Aluguel Dobrado':
                component.set('v.aluguelDobrado', exibeColuna);
                break;
            case 'Nome Fantasia':
                component.set('v.nomeFantasia', exibeColuna);
                break;
            case 'Grupo Atividade':
                component.set('v.grupoAtividadeBr', exibeColuna);
                break;
            case 'Ramo Atividade':
                component.set('v.ramoAtividadeBr', exibeColuna);
                break;
            case 'Tipo Atividade':
                component.set('v.tipoAtividadeBr', exibeColuna);
                break;
        }
    }
})