/******************************************************************************************************
Author  	: Leonardo Façanha
Date    	: 05/01/2017
Purpose 	: Api Rest para buscar/Inserir informações do fluxo de Caixa para a aplicação de promoção
*******************************************************************************************************/
@RestResource(urlMapping='/FluxoCaixa/*')
global with sharing class FluxoCaixaManager {
    
    
    @HttpGet
    global static string getAberturaCaixaPorId(){
        RestRequest req = RestContext.request;
        
        String vaTerminalId = req.params.get('IdTerminal');
        String vaOperadorId = req.params.get('IdOperador');
        String vaValor = req.params.get('Valor');
        string TipoOperacao = req.params.get('TipoOperacao');
        
        If((vaTerminalId != null && vaTerminalId != '' && vaTerminalId != 'null') && (vaOperadorId != null && vaOperadorId != '' && vaOperadorId != 'null') && (vaValor != null && vaValor != '' && vaValor != 'null') && TipoOperacao == null){
            
            TW1_Terminal__c terminal = new TW1_Terminal__c();
            terminal.Id = vaTerminalId;
            terminal.TW1_Operador__c = vaOperadorId;
            Update terminal;
            
            TW1_Caixa__c caixa = new TW1_Caixa__c();
            caixa.TW1_Operador__c = vaOperadorId;
            caixa.TW1_Data_de_Abertura__c = DateTime.now().date();
            caixa.Name = terminal.Name;
            insert caixa;
            
            TW1_Extrato__c extrato = new TW1_Extrato__c();
            extrato.TW1_Tipo__c = 'ValorAbertura';
            extrato.TW1_Valor__c = Decimal.valueOf(vaValor);
            extrato.TW1_Data__c = datetime.now();
            extrato.TW1_Caixa__c = caixa.Id;
            
            insert extrato;
            
            return 'Caixa aberto com sucesso!';
        }
        
         Savepoint sp = Database.setSavepoint();
        
        try{

          If((vaTerminalId != null && vaTerminalId != '' && vaTerminalId != 'null') && (vaOperadorId != null && vaOperadorId != '' && vaOperadorId != 'null') && (vaValor != null && vaValor != '' && vaValor != 'null')){
          	
              TW1_Caixa__c caixa = [Select Id,Name from TW1_Caixa__c where TW1_Operador__c=:vaOperadorId order by CreatedDate desc limit 1];
              TW1_Terminal__c terminal = [select Id from TW1_Terminal__c where TW1_Operador__c=:vaOperadorId limit 1];
              
              caixa.TW1_CxFechado__c = true;
              
              TW1_Extrato__c extrato = new TW1_Extrato__c();
              extrato.TW1_Caixa__c = caixa.Id;
              extrato.TW1_Data__c = DateTime.now();
              extrato.TW1_Tipo__c = 'ValorFechamento';
              extrato.TW1_Valor__c = double.valueOf(vaValor);
              
              terminal.TW1_Operador__c = null;
              
              update caixa;
              update terminal;
              insert extrato;
              return 'Caixa fechado com sucesso!';
          }
               }catch (Exception ce) {
                    Database.rollback(sp);
                    return 'Erro na operação: '+ce.getMessage();
            }  

        
        if(TipoOperacao != null && vaTerminalId == null)
        {
            TW1_Caixa__c caixa = [Select Id,Name,TW1_Valor_de_Abertura_Sum__c,TW1_Valor_Total_Sum__c from TW1_Caixa__c where TW1_Operador__c=:vaOperadorId order by CreatedDate desc limit 1];
            
            string infCaixa = caixa.TW1_Valor_de_Abertura_Sum__c+';'+caixa.TW1_Valor_Total_Sum__c;
                
            return infCaixa;
        }
        
        return 'Erro na operação!';
    } 
}