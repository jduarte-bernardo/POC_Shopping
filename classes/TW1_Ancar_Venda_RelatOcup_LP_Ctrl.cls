public with sharing  class TW1_Ancar_Venda_RelatOcup_LP_Ctrl {
    
    private static TW1_Ancar_Venda_RelatOcupApplication relatorioApplication =  new TW1_Ancar_Venda_RelatOcupApplication();
    
    @AuraEnabled
    public static string ProcessaRelatorio(string strrequest)
    {
        system.debug('Entrara request: ' + strrequest);
        PesquisaRequestDto request = (PesquisaRequestDto)JSON.deserialize(strrequest, PesquisaRequestDto.class);
        system.debug('Parse request: ' + request);
        system.debug('Chamando ProcessaRelatorio');
        
        system.debug('Request chegou relatório: idPropriedade=' + request.idPropriedade + ' dataInicio=' + request.DataInicio + ' dataFim=' + request.DataFim);
        system.debug('Chamada ao relatório de ocupação');
        List<TW1_Ancar_Venda_RelatOcup_LP_Ctrl.RelatorioOcupacao> RetornoMap =  relatorioApplication.ProcessaRelatorio(request.idPropriedade, request.DataInicio, request.DataFim);
        system.debug('Serializando objeto: ' + RetornoMap);
        String listJson = JSON.serialize(RetornoMap);
        system.debug('Retornando objeto serializado: ' + listJson);
        return listJson;
    }
    
    public class RelatorioOcupacao
    {
        public Date DataInicio {get;set;}
        public Date DataFim {get;set;}
    }
    
    public class PesquisaRequestDto
    {   
        public string idPropriedade {get;set;}
        public Date DataInicio {get;set;}
        public Date DataFim {get;set;}
    }
}