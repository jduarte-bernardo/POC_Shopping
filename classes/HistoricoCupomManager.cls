/******************************************************************************************************
Author  	: Leonardo Façanha
Date    	: 22/12/2017
Purpose 	: Api Rest para buscar informações do Historico Cupon para a aplicação de promoção
*******************************************************************************************************/
@RestResource(urlMapping='/HistoricoCupon/*')
global with sharing class HistoricoCupomManager {
    
    @HttpGet
    global static requestWrapper getHistoricoCuponPorId(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String accountId = req.params.get('IdCliente');
        String ShoppingId = req.params.get('IdShopping');
		requestWrapper acc = new requestWrapper();
        date vaData = DateTime.now().date();

        TW1_Parametros_Promocao__c Promocao = [Select Id,TW1_Data_Inicio__c,TW1_Data_Fim__c,TW1_Valor_Min_NTFS__c,TW1_Max_Brinde_Clientes__c,Max_Cupom__c,Max_Bonus_Cliente__c,TW1_Acumula_Saldo__c,TW1_Troca_por__c,TW1_Condicoes_especiais_cart_credito__c,TW1_Contabiliza_Bonus__c,Max_Brindes_por_Troca__c From TW1_Parametros_Promocao__c Where TW1_Shopping__c=:ShoppingId And TW1_Data_Fim__c >=:vaData Limit 1];
        List<TW1_Condicoes_Especiais__c> CondicoesEspeciais = [Select Id,TW1_Bonus_Mult_Brinde__c,TW1_Bonus_Mult_Cupom__c,TW1_Cartao__c,TW1_Promocao__c From TW1_Condicoes_Especiais__c where TW1_Promocao__c=:Promocao.Id];
        List<TW1_Cupom__c> Cupons = [Select Id,Name From TW1_Cupom__c Where TW1_Nome_do_Cliente__c=:accountId And TW1_Parametro_Promocao__c=:Promocao.Id];	
        List<TW1_Brindes_Entregues__c> BrindesEntregues = [Select Id,TW1_Brinde__c,TW1_Cliente__c,Parametros_da_Promocao__c,Quantidade__c from TW1_Brindes_Entregues__c Where Parametros_da_Promocao__c=:Promocao.Id And TW1_Cliente__c=:accountId];
        //(public string Saldo) CHEGANDO A SOMA Do Saldo(R$) e Numero de Cupon de direito
        List<NTFS__c> notasFiscais = [select Id,TW1_Forma_de_pagamento__c,TW1_Valor_RS__c From NTFS__c Where TW1_Cliente__c=:accountId And TW1_Shopping__c=:ShoppingId And TW1_Data_da_Nota__c >=:promocao.TW1_Data_Inicio__c And TW1_Data_da_Nota__c <=:promocao.TW1_Data_Fim__c];    
		        
        If(Promocao != null && notasFiscais.size() >=1){
        HistoricoCupom historicoCupom = getHistoricoPorIdCliente(Promocao,CondicoesEspeciais,Cupons,notasFiscais);
        HistoricoBrinde historicoBrinde = getHistoricoPorIdClienteBrinde(Promocao,CondicoesEspeciais,BrindesEntregues,notasFiscais);
            
        acc.historicoCupom = historicoCupom;
        acc.historicoBrinde = historicoBrinde;
        
        return acc;
            
        }else{
            HistoricoCupom historicoCupomZerado = new HistoricoCupom();
              historicoCupomZerado.Saldo = 0;
              historicoCupomZerado.SaldoExtra = 0;
              historicoCupomZerado.NTrocados = 0;
              historicoCupomZerado.NDireito = 0;
        	 acc.historicoCupom = historicoCupomZerado;
            
            HistoricoBrinde historicoBrindeZerado = new HistoricoBrinde();
            historicoBrindeZerado.Saldo = 0;
            historicoBrindeZerado.SaldoExtra = 0;
            historicoBrindeZerado.NTrocados = 0;
            historicoBrindeZerado.NDireito = 0;
        	 acc.historicoBrinde = historicoBrindeZerado;
            return acc;
        }
    }
    public static HistoricoBrinde getHistoricoPorIdClienteBrinde(TW1_Parametros_Promocao__c Promocao,List<TW1_Condicoes_Especiais__c> CondicoesEspeciais,List<TW1_Brindes_Entregues__c> BrindesEntregues,List<NTFS__c> notasFiscais){
          
         HistoricoBrinde historicoBrinde = new HistoricoBrinde();

        Decimal SobraBonus = 0;
        Decimal Sobra = 0;
        Decimal ValorTotalBonus = 0;
        Integer Quantidadebonus = 0;
        Decimal ValorTotal = 0;
        Set<string> SetIdsNotasEspeciais = new Set<string>();
        
          If(Promocao.TW1_Troca_por__c == 'Ambos' || Promocao.TW1_Troca_por__c == 'Brinde'){

              Integer vahistoricoNtrocados = 0;
              //FAZER COM O RELACIONAMENTO QUE O MANOEL VAI CRIAR
              for(TW1_Brindes_Entregues__c brindes : BrindesEntregues){
                  vahistoricoNtrocados = vahistoricoNtrocados + Integer.valueOf(brindes.Quantidade__c);
              }
              
               historicoBrinde.NTrocados = vahistoricoNtrocados;
        
              //Calculando a quantidade de Cupom bonus
            If(CondicoesEspeciais.size() >= 1 && Promocao.TW1_Contabiliza_Bonus__c)
            {
                for(TW1_Condicoes_Especiais__c condicoes : CondicoesEspeciais)
                {
                     for(NTFS__c nota : notasFiscais)
                    {
                       List<String> formas = condicoes.TW1_Cartao__c.split(';', 15);
                        for(String forma : formas){
                        If(nota.TW1_Forma_de_pagamento__c == forma){
                            ValorTotalBonus = ValorTotalBonus + nota.TW1_Valor_RS__c;
                            SetIdsNotasEspeciais.add(nota.Id);
                        }
                      }
                    }
                    
                Decimal Quanti =  ValorTotalBonus / promocao.TW1_Valor_Min_NTFS__c;
                Integer QuantidadeCorrente = Quanti.intValue();
                //Quantidadebonus = Quantidadebonus + (QuantidadeCorrente * condicoes.TW1_Bonus_Mult_Brinde__c.intValue());
                 Quantidadebonus = QuantidadeCorrente * condicoes.TW1_Bonus_Mult_Cupom__c.intValue();
                    
                If(promocao.TW1_Acumula_Saldo__c)
                SobraBonus = ValorTotalBonus - (QuantidadeCorrente * promocao.TW1_Valor_Min_NTFS__c);
               }
                  If(promocao.TW1_Acumula_Saldo__c){
                    if(SobraBonus >= promocao.TW1_Valor_Min_NTFS__c) {
                    Decimal Totalsobra = SobraBonus / promocao.TW1_Valor_Min_NTFS__c;
        		
                    Integer IntotalSobra = Totalsobra.intValue();
                    Quantidadebonus = Quantidadebonus + IntotalSobra;
                    SobraBonus = SobraBonus - (IntotalSobra*promocao.TW1_Valor_Min_NTFS__c); 
                    }}
              
                If(Promocao.Max_Brindes_por_Troca__c != 0 && Quantidadebonus > Promocao.Max_Brindes_por_Troca__c)
                    Quantidadebonus = Promocao.Max_Brindes_por_Troca__c.intValue();
            }

            //Calculando a quantidade de brinde
         for(NTFS__c nota : notasFiscais)
            {
                If(!SetIdsNotasEspeciais.contains(nota.Id)){
 
                   ValorTotal = ValorTotal + nota.TW1_Valor_RS__c;
                }
            }

        Decimal Numero = ValorTotal / promocao.TW1_Valor_Min_NTFS__c;
        Integer NumeroDireitoNormal = Numero.intValue();
        Integer NumeroDireitoTotal = Quantidadebonus + NumeroDireitoNormal;


        If(promocao.TW1_Acumula_Saldo__c){
            Sobra = Sobra + (ValorTotal - (NumeroDireitoNormal * promocao.TW1_Valor_Min_NTFS__c));

        Decimal Totalsobra = (SobraBonus + Sobra) / promocao.TW1_Valor_Min_NTFS__c;
        Integer IntotalSobra = Totalsobra.intValue();

        NumeroDireitoTotal = NumeroDireitoTotal + IntotalSobra;
        historicoBrinde.Saldo = IntotalSobra < 1 ? (SobraBonus + Sobra) :(SobraBonus + Sobra) - (IntotalSobra*promocao.TW1_Valor_Min_NTFS__c);
        historicoBrinde.Saldo = historicoBrinde.Saldo.setscale(2);
        }

        If(promocao.TW1_Max_Brinde_Clientes__c != 0 && NumeroDireitoTotal > promocao.TW1_Max_Brinde_Clientes__c)
        historicoBrinde.NDireito = promocao.TW1_Max_Brinde_Clientes__c.intValue() - historicoBrinde.NTrocados;
        else
         historicoBrinde.NDireito = NumeroDireitoTotal - historicoBrinde.NTrocados;
              

        }

          return historicoBrinde;
     }
    
    public static HistoricoCupom getHistoricoPorIdCliente(TW1_Parametros_Promocao__c Promocao,List<TW1_Condicoes_Especiais__c> CondicoesEspeciais,List<TW1_Cupom__c> Cupons,List<NTFS__c> notasFiscais){
 
        HistoricoCupom historicoCupom = new HistoricoCupom();

        Decimal SobraBonus = 0;
        Decimal Sobra = 0;
        Decimal ValorTotalBonus = 0;
        Integer Quantidadebonus = 0;
        Decimal ValorTotal = 0;
        Set<string> SetIdsNotasEspeciais = new Set<string>();

    If(Promocao.TW1_Troca_por__c == 'Ambos' || Promocao.TW1_Troca_por__c == 'Cupom'){

         historicoCupom.NTrocados = Cupons.size();

        //Calculando a quantidade de Cupom bonus
        If(CondicoesEspeciais.size() >= 1 && Promocao.TW1_Contabiliza_Bonus__c)
            {
                for(TW1_Condicoes_Especiais__c condicoes : CondicoesEspeciais)
                {
                     for(NTFS__c nota : notasFiscais)
                    {   
                        System.debug('NotaFiscal ID--'+ nota.Id + 'Valor: '+ nota.TW1_Valor_RS__c + 'Forma: '+ nota.TW1_Forma_de_pagamento__c);
                        
                        List<String> formas = condicoes.TW1_Cartao__c.split(';', 15);
                        for(String forma : formas){
                        If(nota.TW1_Forma_de_pagamento__c == forma){
                            System.debug('NotaFiscal ID--'+ nota.Id + 'Forma Corrente: ' + forma + 'Forma nota: '+ nota.TW1_Forma_de_pagamento__c);
                            ValorTotalBonus = ValorTotalBonus + nota.TW1_Valor_RS__c;
                            System.debug('ValorTotalBonus: ' + ValorTotalBonus);
                            SetIdsNotasEspeciais.add(nota.Id);
                        }
                      }
                    }
                    
                Decimal Quanti =  ValorTotalBonus / promocao.TW1_Valor_Min_NTFS__c;
                
                    System.debug('Quanti: ' + Quanti);
                
                Integer QuantidadeCorrente = Quanti.intValue();
                //Quantidadebonus = Quantidadebonus + (QuantidadeCorrente * condicoes.TW1_Bonus_Mult_Cupom__c.intValue());
                Quantidadebonus = QuantidadeCorrente * condicoes.TW1_Bonus_Mult_Cupom__c.intValue();
                
                    System.debug('Quantidadebonus: ' + Quantidadebonus);
                
                If(promocao.TW1_Acumula_Saldo__c)
                SobraBonus = ValorTotalBonus - (QuantidadeCorrente * promocao.TW1_Valor_Min_NTFS__c);
                //SobraBonus = SobraBonus + (ValorTotalBonus - (QuantidadeCorrente * promocao.TW1_Valor_Min_NTFS__c));
                    System.debug('SobraBonus --'+ SobraBonus);
               }
                 System.debug('Quantidadebonus - Antes - Acumula Saldo'+ Quantidadebonus);
                // Verificar se a quantidade de SobraBonus da algum cupom/brinde - ver linhas 186-189 
                If(promocao.TW1_Acumula_Saldo__c){
                    System.debug('SobraBonus >= promocao.TW1_Valor_Min_NTFS__c -'+ SobraBonus + '>=' + promocao.TW1_Valor_Min_NTFS__c );
                    if(SobraBonus >= promocao.TW1_Valor_Min_NTFS__c) {
                    Decimal Totalsobra = SobraBonus / promocao.TW1_Valor_Min_NTFS__c;
        				System.debug('Totalsobra: '+ Totalsobra);
                    Integer IntotalSobra = Totalsobra.intValue();
                    Quantidadebonus = Quantidadebonus + IntotalSobra;
                        System.debug('Quantidadebonus -depois-'+ Quantidadebonus);
                    SobraBonus = SobraBonus - (IntotalSobra*promocao.TW1_Valor_Min_NTFS__c);
                        System.debug('SobraBonus- '+ SobraBonus);
                    }}
                
                System.debug('Quantidadebonus- '+ Quantidadebonus + 'Promocao.Max_Bonus_Cliente__c: '+ Promocao.Max_Bonus_Cliente__c );
                If(Promocao.Max_Bonus_Cliente__c != 0 && Quantidadebonus > Promocao.Max_Bonus_Cliente__c)
                    Quantidadebonus = Promocao.Max_Bonus_Cliente__c.intValue();
                
                System.debug('Quantidadebonus- Total: '+ Quantidadebonus);
            }
    
        //Calculando a quantidade de cupom
         for(NTFS__c nota : notasFiscais)
            {
                If(!SetIdsNotasEspeciais.contains(nota.Id)){
                    System.debug('Nota- SEM CONDIÇAO ESPECIAL: '+ nota.Id );
                   ValorTotal = ValorTotal + nota.TW1_Valor_RS__c;
                }
            }

        Decimal Numero = ValorTotal / promocao.TW1_Valor_Min_NTFS__c;
        Integer NumeroDireitoNormal = Numero.intValue();
        Integer NumeroDireitoTotal = Quantidadebonus + NumeroDireitoNormal;
        
        System.debug('Quantidadebonus + NumeroDireitoNormal: '+ Quantidadebonus +' + '+ NumeroDireitoNormal );

        If(promocao.TW1_Acumula_Saldo__c){
            Sobra = Sobra + (ValorTotal - (NumeroDireitoNormal * promocao.TW1_Valor_Min_NTFS__c));
        System.debug(SobraBonus+' --SobraBonus -- Sobra '+ Sobra);
        Decimal Totalsobra = (SobraBonus + Sobra) / promocao.TW1_Valor_Min_NTFS__c;
        Integer IntotalSobra = Totalsobra.intValue();
        NumeroDireitoTotal = NumeroDireitoTotal + IntotalSobra;
        historicoCupom.Saldo = IntotalSobra < 1 ? (SobraBonus + Sobra) :(SobraBonus + Sobra) - (IntotalSobra*promocao.TW1_Valor_Min_NTFS__c);  
        historicoCupom.Saldo = historicoCupom.Saldo.setscale(2);
        System.debug('historicoCupom.Saldo: '+ historicoCupom.Saldo);
        }

        If(promocao.Max_Cupom__c != 0 && NumeroDireitoTotal > promocao.Max_Cupom__c){
        	historicoCupom.NDireito = promocao.Max_Cupom__c.intValue() - historicoCupom.NTrocados;
        System.debug('promocao.Max_Cupom__c.intValue(): '+ promocao.Max_Cupom__c.intValue() +'-'+ historicoCupom.NTrocados);
        }else{
            historicoCupom.NDireito = NumeroDireitoTotal - historicoCupom.NTrocados;
            System.debug('NumeroDireitoTotal - historicoCupom.NTrocados: '+ NumeroDireitoTotal +'-'+ historicoCupom.NTrocados);
        }
        }

        return historicoCupom;
        
    }
    
    global class requestWrapper 
    {
        public HistoricoCupom historicoCupom;
        public HistoricoBrinde historicoBrinde;

    }
    global class HistoricoCupom 
    {
        public decimal Saldo;
        public decimal SaldoExtra;
        public Integer NTrocados;
        public Integer NDireito;
    }
    global class HistoricoBrinde 
    {
        public decimal Saldo;
        public decimal SaldoExtra;
        public Integer NTrocados;
        public Integer NDireito;
    }
}