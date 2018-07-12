/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@isTest(SeeAllData=true)
private class TW1_Ancar_Venda_RelatOcup_LP_Ctrl_Test {
    
    static string IdPropriedadeTeste = '';
    
    private static void Init()
    {
        system.debug('Inserindo oportunidades');
        Opportunity opportunity = TW1_Ancar_OpportunityMockGenerator_cls.getLojaMock();
        system.debug('Oportunidade inserida');
        system.debug('Inserindo Quote');
        Quote quote = TW1_Ancar_CotacaoMockGenerator_cls.getLojaMock(opportunity.Id);   
        system.debug('Quote inserida');
        system.debug('Inserindo propriedade');
        TW1_Propriedade__c propriedade = TW1_Ancar_PropriedadeMockGenerator_cls.getLojaMock(quote.Id);
        IdPropriedadeTeste = propriedade.Id;
        system.debug('Propriedade inserida');
        system.debug('Inserindo calendário');
        TW1_Calendario_de_propriedades__c calendario = TW1_Ancar_PropriedadeMockGenerator_cls.getCalendarioOcupado(propriedade.Id, Date.today(), Date.today().addMonths(1));
        system.debug('Calendário inserido');
    }    
    
    private static testMethod void TesteBuscaRelatorio()
    {
        try
        {
            system.debug('Iniciando teste de relatorio de ocupação');
            system.debug('Inserindo objetos');
            Init();
            system.debug('Montando request de pesquisa');
            TW1_Ancar_Venda_RelatOcup_LP_Ctrl.PesquisaRequestDto pesquisaDto = new TW1_Ancar_Venda_RelatOcup_LP_Ctrl.PesquisaRequestDto();
            pesquisaDto.idPropriedade = IdPropriedadeTeste;
            pesquisaDto.DataInicio = Date.today();
            pesquisaDto.DataFim = pesquisaDto.DataInicio.addMonths(1);
            system.debug('Request montado');
            system.debug('Relalizando busca');
            string retorno = TW1_Ancar_Venda_RelatOcup_LP_Ctrl.ProcessaRelatorio(JSON.serialize(pesquisaDto));
            system.debug('Retorno da busca: ' + retorno);
            system.debug('Realizando parse da consulta');
            List<TW1_Ancar_Venda_RelatOcup_LP_Ctrl.RelatorioOcupacao> relatorio = (List<TW1_Ancar_Venda_RelatOcup_LP_Ctrl.RelatorioOcupacao>)JSON.deserialize(retorno, List<TW1_Ancar_Venda_RelatOcup_LP_Ctrl.RelatorioOcupacao>.class);
            system.debug('Parse realizado: ' + relatorio);
            system.assert(relatorio.Size() > 0);
        }
        catch(Exception ex)
        {
            System.debug('Erroe: ' + ex);
            system.assert(false);
        }      
    }
}