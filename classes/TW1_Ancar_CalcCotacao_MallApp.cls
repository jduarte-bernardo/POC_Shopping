public class TW1_Ancar_CalcCotacao_MallApp {
    
    Quote Cotacao;
    
    list<TW1_Propriedade_da_Cotacao__c> ListaDePropriedades;
    
    TW1_Propriedade__c PropriedadeLoja;
    
    public TW1_Ancar_CalcCotacao_MallApp(Quote pcotacao, list<TW1_Propriedade_da_Cotacao__c> listaPropriedadesCotacao)
    {
        system.debug('Criando instancia calculadora de Mall:  ' + pcotacao + ' Propriedade: ' + listaPropriedadesCotacao );
        Cotacao = pcotacao;
        ListaDePropriedades = listaPropriedadesCotacao;
    }
    
    public Quote RealizarCalculo()
    {
        system.debug('Calculando prazo');
        CalcularPrazo();
        system.debug('Prazo calculado com sucesso');
        return Cotacao;
    }
    
    
    private void CalcularPrazo()
    {
        system.debug('Calculando prazo com período de locação: ' + Cotacao.TW1_Periodo_de_locacao__c);
        if(Cotacao.TW1_Periodo_de_locacao__c == 'Indeterminado')
        {
            system.debug('Zerando prazo em caso de Indeterminado');
            Cotacao.TW1_Prazo__c = 0;
            return;
        }
        
        system.debug('Executando cálculos em dias de prazo');
        Cotacao.TW1_Prazo__c = Cotacao.TW1_Data_inicio_de_vigencia__c.daysBetween(Cotacao.TW1_Data_fim_de_vigencia__c) + 1;
        system.debug('Prazo total: ' + Cotacao.TW1_Prazo__c);
    }
}