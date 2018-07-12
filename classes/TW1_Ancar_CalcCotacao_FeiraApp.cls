public class TW1_Ancar_CalcCotacao_FeiraApp {
    Quote Cotacao;
    
    list<TW1_Propriedade_da_Cotacao__c> ListaDePropriedades;
    
    /// Repositório de propriedade
    TW1_Ancar_Venda_Propriedade_Rep proprietarioRepositorio = new TW1_Ancar_Venda_Propriedade_Rep();
    
    public TW1_Ancar_CalcCotacao_FeiraApp(Quote pcotacao,  list<TW1_Propriedade_da_Cotacao__c> listaPropriedadesCotacao)
    {
        system.debug('Criando instancia calculadora de Feira:  ' + cotacao + ' Propriedade: ' + listaPropriedadesCotacao );
        Cotacao = pcotacao;
        ListaDePropriedades = listaPropriedadesCotacao;
    }
    
    public Quote RealizarCalculo()
    {
        system.debug('Realizando cálculo de vigencia');
        CalcularVigencia();
        system.debug('Cálculo de vigencia realizado');
        system.debug('Realizando cálculo de período');
        CalculaPeriodoUsado();
        system.debug('Cálculo de período realizado');
        system.debug('Realizando cálculo total');
        CalcularTotal();
        system.debug('Fim do cálculo total');
        system.debug('Realizando cálculo área total');
        CalcularAreaTotal();
        system.debug('Fim do cálculo área total');
        return Cotacao;
    }
    
    private void CalcularVigencia()
    {
        system.debug('Calcular vigência de mída');
        
        Date dataInicioVigencia = Date.today().addYears(100);
        Date dataFimVigencia = Date.today().addYears(-100);
        
        ListaDePropriedades.sort();
        
        for(TW1_Propriedade_da_Cotacao__c propriedade : ListaDePropriedades)
        {
            system.debug('Data de início: ' + dataInicioVigencia);
            system.debug('Data de início corrente da propriedade: ' + propriedade.TW1_Data_de_inicio__c);
            if(dataInicioVigencia > propriedade.TW1_Data_de_inicio__c)
                dataInicioVigencia = propriedade.TW1_Data_de_inicio__c;
            
            system.debug('Data de fim: ' + dataFimVigencia);
            system.debug('Data de dim corrente da propriedade: ' + propriedade.TW1_Data_de_fim__c);
            if(dataFimVigencia <  propriedade.TW1_Data_de_fim__c)
                dataFimVigencia = propriedade.TW1_Data_de_fim__c;
        }
        
        system.debug('Definindo início de fim de vigência - Inicio ' + dataInicioVigencia + ' Fim ' + dataFimVigencia);
        Cotacao.TW1_Data_inicio_de_vigencia__c = dataInicioVigencia;
        Cotacao.TW1_Data_fim_de_vigencia__c = dataFimVigencia;
    }
    
    private void CalculaPeriodoUsado()
    {
        integer totalDiasUsados = 0;
        
        Date ultimaDataInicio = null;
        Date ultimaDataFim = null;
        
        ListaDePropriedades.sort();
        
        for(TW1_Propriedade_da_Cotacao__c propriedade : ListaDePropriedades)
        { 
            system.debug('Verificando diferença entre dias do período');
            System.debug('totalDiasUsados: ' + totalDiasUsados);
            System.debug('propriedade: ' + propriedade);
            totalDiasUsados =  totalDiasUsados +  propriedade.TW1_Data_de_inicio__c.daysBetween(propriedade.TW1_Data_de_fim__c) + 1;
            system.debug('Total de dias: ' + totalDiasUsados);
            
            system.debug('Verificando diferenças entre dias');
            integer diferencaDias = 0;
            
            if(ultimaDataFim != null)
                if(ultimaDataFim > propriedade.TW1_Data_de_inicio__c){
                    system.debug('Realizando diferença de dias');
                    diferencaDias =  propriedade.TW1_Data_de_inicio__c.daysBetween(ultimaDataFim) + 1; 
                    system.debug('Diferença de dias: ' + diferencaDias);
                }
            
            totalDiasUsados = totalDiasUsados - diferencaDias;
            ultimaDataFim = propriedade.TW1_Data_de_fim__c;
        }
        
        system.debug('Definindo prazo da cotação: ' + totalDiasUsados);
        cotacao.TW1_Prazo__c = totalDiasUsados;
    }
    
    private void CalcularTotal()
    {
        decimal total = 0;
        
        for(TW1_Propriedade_da_Cotacao__c propriedade : ListaDePropriedades)
        {
            total = total +  propriedade.TW1_Valor__c;
        }
        
        
        if(Cotacao.TW1_Valor_Desconto__c != null)
            Cotacao.TW1_Valor__c = total - Cotacao.TW1_Valor_Desconto__c;
        else
            Cotacao.TW1_Valor__c = total;
        
        Cotacao.TW1_Valor_Total_Sem_Desconto__c = total ;
        
        system.debug('Definindo valor total: ' +  Cotacao.TW1_Valor__c);
    }
    
    private void CalcularAreaTotal()
    {   
        decimal total = 0;
        
        for(TW1_Propriedade_da_Cotacao__c propriedade : ListaDePropriedades)
        {
            total = total +  propriedade.TW1_Area__c;
        }
        
        Cotacao.TW1_Area_utilizada__c = total;
        system.debug('Definindo valor total de área utilizada: ' + total);
    }
}