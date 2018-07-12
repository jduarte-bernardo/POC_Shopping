global with sharing class Tw1_Ancar_IntegracaoCartao_Handler_cls {
    
    @future
    public static void sendWithFuture(){
        executeJob();
    } 
    
    @testVisible
    private static void executeJob(){ 
        
        Anc_Utils_cls.LogToSystemDebug('Inicio do processamento Tw1_Ancar_IntegracaoCartao_Handler_cls.sendWithFuture');
        try 
        {  
            // get data 
            Anc_Utils_cls.LogToSystemDebug('obtendo dados...');
            getDataToProcess();   
            Anc_Utils_cls.LogToSystemDebug('processando informação...');
        }
        catch(Anc_Utils_cls.Cal_Exception e)
        {   
            System.debug('Tw1_Ancar_IntegracaoCartao_Handler_cls.sendWithFuture error: ' + e.getMessage()); 
        }
        finally{
            if(!Test.isRunningTest())
                scheaduleJobAgain();
        }  
        Anc_Utils_cls.LogToSystemDebug('Fim do processamento Tw1_Ancar_IntegracaoCartao_Handler_cls.sendWithFuture');
        
    }
    
    private static void getDataToProcess(){ 
        
        string stringAttac = '';
        List<TW1_Fidelidade__c> Listfidelidade = [select TW1_Modalidade__c,TW1_Saldo__c,TW1_Nome_Cliente__c from TW1_Fidelidade__c where Tw1_Modalidade__c != 'Prospect'];
        Map<Id,TW1_Fidelidade__c> Listfidelidadee = new Map<Id,TW1_Fidelidade__c>(Listfidelidade);
		List<TW1_Cartoes_Estacionamento__c> Listcartao = [select Id,TW1_Numero__c,TW1_Data_Fim__c,TW1_Data_inicio__c,TW1_Status__c,TW1_Numero_Fidelidade__c from TW1_Cartoes_Estacionamento__c where TW1_Numero_Fidelidade__c IN :Listfidelidadee.keySet()];
        List<Account> Listacc = [Select Id,Name from Account where recordtype.Name = 'Conta pessoal padrão'];

        for(TW1_Fidelidade__c fidelidade : Listfidelidade)
        {
            for(TW1_Cartoes_Estacionamento__c cartao : Listcartao)
            {	
                if(cartao.TW1_Numero_Fidelidade__c == fidelidade.Id){
                Account acc;
                    for(Account item:Listacc)
                    {
                        if(item.Id == fidelidade.TW1_Nome_Cliente__c)
                           acc = item;
                    }
                date dataIni = cartao.TW1_Data_inicio__c;
                date dataFim = cartao.TW1_Data_Fim__c;
                
                string Iniciodia = string.valueOf(dataIni.day());
                string InicioMes = string.valueOf(dataIni.month());
                string InicioAno = string.valueOf(dataIni.year());
                string Fimdia = string.valueOf(dataFim.day());
                string FimMes = string.valueOf(dataFim.month());
                string FimAno = string.valueOf(dataFim.year());
                
                string numero = CompletarCodigoDeBarras(cartao.TW1_Numero__c);
                
                
                string stringAttachment = '20,'; 
                stringAttachment = stringAttachment +  (numero + cartao.TW1_Numero__c);
                stringAttachment = stringAttachment + (',' + string.valueOf( acc.Name));
                stringAttachment = stringAttachment + (',FIDELIDADE ' + string.valueOf(fidelidade.TW1_Modalidade__c));
                stringAttachment = stringAttachment + (',' + Iniciodia + InicioMes + InicioAno);
                stringAttachment = stringAttachment + (',' + Fimdia + FimMes + FimAno + ',');
                stringAttachment = stringAttachment + (cartao.TW1_Status__c == 'Ativo'? 'A' : 'I');
                stringAttachment = stringAttachment + '\n';
                
            	stringAttac = stringAttac + stringAttachment;
                }
            }
        }
        
       // if(!Test.isRunningTest()){ 
            Cal_EmailUtils_cls.sendEmail( new String[] {'estacionamento.barra@riodesign.com.br' },null,'Informações do Cliente - Cartão Estacionamento', 'teste Ancar envio de email', '<h3>Ancar - Integração Cartão Estacionamento</h3>',stringAttac,'CartaoEstacionamento.txt');
        //}
    }
    
    public static String CompletarCodigoDeBarras(String paCdBarras){
        String n ='';
        for (integer i=paCdBarras.length();i<=7;i++){
            n+='0';
        }	
        return n;
    }
    
    private static void scheaduleJobAgain(){
        //Produção
        Anc_ScheaduleUtils_cls.scheadule('Tw1_Ancar_IntegracaoCartao_sch', DateTime.now().addMinutes(480));
    }
}