public class TW1_Ancar_Venda_RelatOcupApplication {
    /// Repositório de propriedade
    public TW1_Ancar_Venda_Propriedade_Rep propriedadeRepository = new TW1_Ancar_Venda_Propriedade_Rep();
    
    public List<TW1_Ancar_Venda_RelatOcup_LP_Ctrl.RelatorioOcupacao> ProcessaRelatorio(string idPropriedade, Date dataInicio, Date dataFim)
    {
        system.debug('Consultando relatório: idPropriedade=' + idPropriedade + ' dataInicio=' + dataInicio + ' dataFim=' + dataFim);
        List<TW1_Calendario_de_propriedades__c> listaOcupacao = propriedadeRepository.ListaPeriodosOcupacao(idPropriedade, dataInicio, dataFim);
        system.debug('Lista de ocupação: ' + listaOcupacao);
        return MapRelatorio(listaOcupacao);
    }
    
    private List<TW1_Ancar_Venda_RelatOcup_LP_Ctrl.RelatorioOcupacao> MapRelatorio(List<TW1_Calendario_de_propriedades__c> listaCalendarios)
    {
        system.debug('Criando map relatório de importação');
        List<TW1_Ancar_Venda_RelatOcup_LP_Ctrl.RelatorioOcupacao> listaRetorno = new List<TW1_Ancar_Venda_RelatOcup_LP_Ctrl.RelatorioOcupacao>();
        
        if(listaCalendarios == null)
            return listaRetorno;
        
        for(TW1_Calendario_de_propriedades__c ocupacao : listaCalendarios)
        {
            TW1_Ancar_Venda_RelatOcup_LP_Ctrl.RelatorioOcupacao relatorio = new TW1_Ancar_Venda_RelatOcup_LP_Ctrl.RelatorioOcupacao();
            relatorio.DataInicio = ocupacao.TW1_Data_de_inicio__c;
            relatorio.DataFim = ocupacao.TW1_Data_de_fim__c;
            listaRetorno.add(relatorio);
        }
        
        system.debug('Relatório montado para ser retornado: ' + listaRetorno);
        return listaRetorno;
    }
}