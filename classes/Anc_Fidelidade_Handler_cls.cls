global with sharing class Anc_Fidelidade_Handler_cls {

    @future
    public static void sendWithFuture(){
        executeJob();
    } 
    
    @testVisible
    private static void executeJob(){
        
        Anc_Utils_cls.LogToSystemDebug('Inicio do processamento Anc_Fidelidade_Handler_cls.sendWithFuture');
        try 
        {  
            // get data 
            Anc_Utils_cls.LogToSystemDebug('obtendo dados...');
            getDataToProcess();   
            Anc_Utils_cls.LogToSystemDebug('processando informação...');
        }
        catch(Anc_Utils_cls.Cal_Exception e)  
        {   
            System.debug('Anc_Fidelidade_Handler_cls.sendWithFuture error: ' + e.getMessage()); 
        }
        finally{
            if(!Test.isRunningTest())
                scheaduleJobAgain();
        }  
        Anc_Utils_cls.LogToSystemDebug('Fim do processamento Anc_Fidelidade_Handler_cls.sendWithFuture');
        
    }
    
    
    private static void getDataToProcess(){ 
        
        Map<ID, TW1_Fidelidade__c> MapFidelidade = new Map<ID, TW1_Fidelidade__c>([select TW1_Modalidade__c,TW1_Saldo__c from TW1_Fidelidade__c where TW1_Modalidade__c='Gold' Or TW1_Modalidade__c='Prospect' ORDER BY TW1_Saldo__c DESC limit 100]);
        SET<ID> keys = MapFidelidade.keyset();
        
        List<TW1_Fidelidade__c> ListFidelidade = new List<TW1_Fidelidade__c>();
        List<TW1_Cartoes_Estacionamento__c> cartoes = [select Id,TW1_Data_Fim__c,TW1_Data_inicio__c,TW1_Numero_Fidelidade__c from TW1_Cartoes_Estacionamento__c where TW1_Numero_Fidelidade__c IN :keys And TW1_Status__c ='Ativo'];
        
        List<TW1_Historico__c> ListaHistorico = new List<TW1_Historico__c>();
        
        RecordType recordtype = [Select Id,Name from RecordType where RecordType.Name = 'Cartão Estacionamento'];
        
        for(ID idKey : MapFidelidade.keyset())
        {
            TW1_Fidelidade__c Top100 = MapFidelidade.get(idKey);
            
            Top100.TW1_Modalidade__c = 'Platinum';
            ListFidelidade.add(Top100);
            
            TW1_Historico__c historico = new TW1_Historico__c();
            historico.TW1_Fidelidade__c = Top100.Id;
            historico.TW1_Tipo__c = 'Cartão Estacionamento';
            historico.TW1_Pontos__c = 0 - Top100.TW1_Saldo__c;
            historico.TW1_Data__c = DateTime.now().date();
            historico.RecordTypeId = recordtype.Id;
            ListaHistorico.add(historico);
        }
        
        for(TW1_Cartoes_Estacionamento__c Cartao : cartoes){
            MapFidelidade.remove(Cartao.TW1_Numero_Fidelidade__c);
            
            Cartao.TW1_Data_Fim__c = DateTime.now().addMonths(3).date();
            Cartao.TW1_Data_inicio__c = DateTime.now().date();
        }
         SET<ID> listkeys = MapFidelidade.keyset();
        
        For(ID fidel:listkeys)
        {
           TW1_Cartoes_Estacionamento__c cartao = new TW1_Cartoes_Estacionamento__c();
            cartao.TW1_Numero_Fidelidade__c = fidel;
            Cartao.TW1_Status__c = 'Ativo';
            cartao.TW1_Data_Fim__c = DateTime.now().addMonths(3).date();
            cartao.TW1_Data_inicio__c = DateTime.now().date();
            
            cartoes.add(cartao);
        }
        
        
        insert ListaHistorico;  
        Upsert cartoes Id;
        Update ListFidelidade;
    }
    
    private static void scheaduleJobAgain(){
        //Produção
        Anc_ScheaduleUtils_cls.scheadule('Anc_Fidelidade_sch', DateTime.now().addMonths(3));
    }
}