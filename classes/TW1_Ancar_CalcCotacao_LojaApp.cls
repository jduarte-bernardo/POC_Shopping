public class TW1_Ancar_CalcCotacao_LojaApp {
    
    Quote Cotacao;
    
    list<TW1_Propriedade_da_Cotacao__c> ListaDePropriedades;
    
    TW1_Propriedade__c PropriedadeLoja;
    
    public TW1_Ancar_CalcCotacao_LojaApp(Quote pcotacao, list<TW1_Propriedade_da_Cotacao__c> listaPropriedadesCotacao)
    {
        system.debug('Criando instancia calculadora de loja:  ' + Cotacao + ' Propriedade: ' + listaPropriedadesCotacao );
        Cotacao = pcotacao;
        ListaDePropriedades = listaPropriedadesCotacao;
    }
    
    public Quote RealizarCalculo()
    {
        PropriedadeLoja = [SELECT TW1_Res_Perata__c FROM TW1_Propriedade__c WHERe id= :ListaDePropriedades[0].TW1_Propriedade__c];
        system.debug('Propriedade: ' + PropriedadeLoja);
        system.debug('Cotação: ' + Cotacao);
        
        system.debug('Calculando CalculoPeriodoLoja');
        this.DefinirFimVigenciaLoja();
        system.debug('Calculando CGL AMM');
        this.calculoDeVGLAMM();
        system.debug('Calculando VGLTotal');
        this.calculoDeVGLTotal();
        
        system.debug('Retornando cotação de loja calculada: ' + Cotacao);
        return Cotacao;
    }
    
    public void DefinirFimVigenciaLoja()
    {
        System.debug(Cotacao.TW1_Prazo__c);
        System.debug(Cotacao.TW1_Data_inicio_de_vigencia__c);
        integer periodo = integer.valueOf(Cotacao.TW1_Prazo__c);
        Cotacao.TW1_Data_fim_de_vigencia__c = Cotacao.TW1_Data_inicio_de_vigencia__c.addMonths(periodo);
    }
    
    public void calculoDeVGLAMM()
    {
        system.debug('Realizando cálculo de VGL AMM');
        
        integer fatorDobrado = 0;
        
        system.debug('Aplicando fator: ' + Cotacao.TW1_Mes_aluguel_dobrado__c);
        if(Cotacao.TW1_Mes_aluguel_dobrado__c != null && Cotacao.TW1_Mes_aluguel_dobrado__c != '')
            fatorDobrado = 1;
        
        Decimal valorAmm1  = 0;
        Decimal valorAmm2  = 0;
        Decimal valorAmm3  = 0;
        Decimal valorAmm4  = 0;
        Decimal valorAmm5  = 0;
        Decimal valorAmm6  = 0;
        Decimal valorAmm7  = 0;
        Decimal valorAmm8  = 0;
        Decimal valorAmm9  = 0;
        Decimal valorAmm10 = 0;
        
        Decimal ultimoAmm = 0;
        integer contagemAmmUsado = 0;
        
        Integer monthDiff = integer.valueOf(Cotacao.TW1_Prazo__c);
        system.debug('Valor cotação meses: ' + monthDiff);
        
        decimal  yearDiff = monthDiff / 12;
        
        if(cotacao.TW1_AMM_1__c > 0)
        {   
            valorAmm1 = Cotacao.TW1_AMM_1__c * (12 + fatorDobrado);
            ultimoAmm = Cotacao.TW1_AMM_1__c;
            contagemAmmUsado = 1;
        }
        
        if(Cotacao.TW1_AMM_2__c != null && yearDiff >=2)
        {   
            if(Cotacao.TW1_AMM_2__c > 0)
            {    
                valorAmm2 = Cotacao.TW1_AMM_2__c * (12 + fatorDobrado);
                ultimoAmm = Cotacao.TW1_AMM_2__c;
                contagemAmmUsado = 2;
            }
        }
        
        if(Cotacao.TW1_AMM_3__c != null && yearDiff >=3)
        {  
            if(Cotacao.TW1_AMM_3__c > 0) 
            {
                valorAmm3 = Cotacao.TW1_AMM_3__c * (12 + fatorDobrado);
                ultimoAmm = Cotacao.TW1_AMM_3__c;
                contagemAmmUsado = 3;
            }
        }
        
        if(Cotacao.TW1_AMM_4__c != null && yearDiff >=4)
        {  
            if(Cotacao.TW1_AMM_4__c > 0) 
            {
                valorAmm4 = Cotacao.TW1_AMM_4__c * (12 + fatorDobrado);
                ultimoAmm = Cotacao.TW1_AMM_4__c;
                contagemAmmUsado = 4;
            }
        }
        
        if(Cotacao.TW1_AMM_5__c != null && yearDiff >=5)
        {  
            if(Cotacao.TW1_AMM_5__c > 0) 
            {    
                valorAmm5 = Cotacao.TW1_AMM_5__c * (12 + fatorDobrado);
                ultimoAmm = Cotacao.TW1_AMM_5__c;
                contagemAmmUsado = 5;
            }
        }
        
        if(Cotacao.TW1_AMM_6__c != null && yearDiff >=6)
        {  
            if(Cotacao.TW1_AMM_6__c > 0) 
            {
                valorAmm6 = Cotacao.TW1_AMM_6__c * (12 + fatorDobrado);
                ultimoAmm = Cotacao.TW1_AMM_6__c;
                contagemAmmUsado = 6;
            }
        }
        
        if(Cotacao.TW1_AMM_7__c != null && yearDiff >=7)
        {  
            if(Cotacao.TW1_AMM_7__c > 0) 
            {
                valorAmm7 = Cotacao.TW1_AMM_7__c * (12 + fatorDobrado);
                ultimoAmm = Cotacao.TW1_AMM_7__c;
                contagemAmmUsado = 7;
            }
        }
        
        if(Cotacao.TW1_AMM_8__c != null && yearDiff >=8)
        {  
            if(Cotacao.TW1_AMM_8__c > 0) 
            {    
                valorAmm8 = Cotacao.TW1_AMM_8__c * (12 + fatorDobrado);
                ultimoAmm = Cotacao.TW1_AMM_8__c;
                contagemAmmUsado = 8;
            }
        }
        
        if(Cotacao.TW1_AMM_9__c != null && yearDiff >=9)
        {  
            if(Cotacao.TW1_AMM_9__c > 0)
            {
                valorAmm9 = Cotacao.TW1_AMM_9__c * (12 + fatorDobrado);
                ultimoAmm = Cotacao.TW1_AMM_9__c;
                contagemAmmUsado = 9;
            }
        }
        
        if(Cotacao.TW1_AMM_10__c != null && yearDiff >=10)
        {  
            if(Cotacao.TW1_AMM_10__c > 0) 
            {
                valorAmm10 = Cotacao.TW1_AMM_10__c * (12 + fatorDobrado);
                ultimoAmm = Cotacao.TW1_AMM_10__c;
                contagemAmmUsado = 10;
            }
        }
        
        integer totalTempo = contagemAmmUsado * 12;
        system.debug('Total de tempo de contagem usado: ' + contagemAmmUsado);
        decimal restoContrato = 0;
        
        if(monthDiff > totalTempo)
        {
            integer tempoRestante = monthDiff - totalTempo;
            integer dobrado = tempoRestante / 12;
            decimal valorBase = 0;
            
            if(contagemAmmUsado == 1)
                valorBase = Cotacao.TW1_AMM_1__c;
            if(contagemAmmUsado == 2)
                valorBase = Cotacao.TW1_AMM_2__c;
            if(contagemAmmUsado == 3)
                valorBase = Cotacao.TW1_AMM_3__c;
            if(contagemAmmUsado == 4)
                valorBase = Cotacao.TW1_AMM_4__c;
            if(contagemAmmUsado == 5)
                valorBase = Cotacao.TW1_AMM_5__c;
            if(contagemAmmUsado == 6)
                valorBase = Cotacao.TW1_AMM_6__c;
            if(contagemAmmUsado == 7)
                valorBase = Cotacao.TW1_AMM_7__c;
            if(contagemAmmUsado == 8)
                valorBase = Cotacao.TW1_AMM_8__c;
            if(contagemAmmUsado == 9)
                valorBase = Cotacao.TW1_AMM_9__c;
            if(contagemAmmUsado == 10)
                valorBase = Cotacao.TW1_AMM_10__c;
            
            decimal aluguelDobradoRestantante = 0;
            if(fatorDobrado > 0)
            {
                aluguelDobradoRestantante = valorBase * dobrado;
                system.debug('Valor Aluguel dobrado restante: ' + aluguelDobradoRestantante);
            }
            
            system.debug('Cálculando resto de tempo: ' + tempoRestante + ' no valor base: ' + valorBase + ' mais dobrado restante ' + aluguelDobradoRestantante);
            restoContrato = (valorBase * tempoRestante) + aluguelDobradoRestantante;
        }
        
        Cotacao.TW1_VGL_AMM__c = valorAmm1 + valorAmm2 + valorAmm3 + valorAmm4 + valorAmm5 + valorAmm6 + valorAmm7 + valorAmm8 + valorAmm9 + valorAmm10 + restoContrato;
        system.debug('Total de VGL AMM: ' + Cotacao.TW1_VGL_AMM__c);
    }
    
    public void calculoDeVGLTotal(){
        system.debug('Realizando cálculo de VGL Total');
        
        Cotacao.TW1_VGL_total__c = Cotacao.TW1_VGL_AMM__c;
        
        if(Cotacao.TW1_CDU__c != null)
            Cotacao.TW1_VGL_total__c = Cotacao.TW1_VGL_total__c + Cotacao.TW1_CDU__c;
        
        system.debug('Total de VGL: ' + Cotacao.TW1_VGL_total__c);
    }
}