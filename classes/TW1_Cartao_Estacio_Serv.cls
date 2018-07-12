public class TW1_Cartao_Estacio_Serv {
    
    public List<TW1_Cartoes_Estacionamento__c> getCartaoEstacionamento(String Id){
       
            List<TW1_Cartoes_Estacionamento__c> listaCartaoEstacionamento = [
                select 
                id,
                Name,
                TW1_Cartao_Gerado__c,
                TW1_Numero__c,
                TW1_Numero_Fidelidade__c,
                TW1_Data_inicio__c,
                TW1_Data_Fim__c,
                TW1_Status__c
                from TW1_Cartoes_Estacionamento__c 
                where id=:Id
            ];
            
            return listaCartaoEstacionamento;
    }
    
    public TW1_Fidelidade__c getFidelidade(String IdFidelidade){
       
            TW1_Fidelidade__c listarFidelidade = [
                Select 
                Id,
                Name,
                TW1_Nome_Cliente__c,
                TW1_Saldo__c
                from
                TW1_Fidelidade__c
                where 
                Id=:IdFidelidade Limit 1
            ];
            return listarFidelidade;
    }
    
    public Account geAccount(String IdCliente){
      
            Account listarAccount= [
                Select 
                Id,
                Name,
                TW1_Apelido__c
                from
                Account
                where 
                Id=:IdCliente Limit 1
            ];
            return listarAccount;
    }
    
     public void UpdateCartaoGeradoInativo(String IdCartao){
        TW1_Cartoes_Estacionamento__c CartaoGerado = [
            select 
            Id,
            Name,
            TW1_Cartao_Gerado__c,
            TW1_Numero__c,
            TW1_Numero_Fidelidade__c,
            TW1_Data_inicio__c,
            TW1_Data_Fim__c,
            TW1_Status__c
            from TW1_Cartoes_Estacionamento__c 
            where Id=:IdCartao limit 1 
        ];
        
        CartaoGerado.TW1_Status__c = 'Inativo';
      
            Update CartaoGerado;
            
           TW1_Cartoes_Estacionamento__c CartaoGeradoCopy = new TW1_Cartoes_Estacionamento__c();
       
            CartaoGeradoCopy.TW1_Data_Fim__c = CartaoGerado.TW1_Data_Fim__c;
            CartaoGeradoCopy.TW1_Data_inicio__c = CartaoGerado.TW1_Data_inicio__c;
            CartaoGeradoCopy.TW1_Cartao_Gerado__c = false;
            CartaoGeradoCopy.TW1_Status__c = 'Ativo';
            CartaoGeradoCopy.TW1_Numero_Fidelidade__c = CartaoGerado.TW1_Numero_Fidelidade__c;
            CartaoGeradoCopy.TW1_Marca__c = CartaoGerado.TW1_Marca__c;
            CartaoGeradoCopy.TW1_Modelo__c = CartaoGerado.TW1_Modelo__c;
            CartaoGeradoCopy.TW1_Placa__c = CartaoGerado.TW1_Placa__c;
          
            Insert CartaoGeradoCopy;
    }
    
    public void GerarHistorico(String IdFidelidade){
        
        recordtype rc = [select Id,Name from recordtype where Name='Cartão Estacionamento' Limit 1];
        TW1_Historico__c historico = new TW1_Historico__c();
        historico.TW1_Fidelidade__c = IdFidelidade;
        historico.RecordTypeId = rc.Id;
        historico.TW1_Tipo__c = 'Cartão Estacionamento';
        historico.TW1_Data__c = DateTime.now().date();
        historico.TW1_Pontos__c = -1000;
        
        insert historico;
        
    }
    
    public TW1_Cartoes_Estacionamento__c UpdateCartaoGerado(String IdCartao){
        TW1_Cartoes_Estacionamento__c CartaoGerado = [
            select 
            Id,
            Name,
            TW1_Cartao_Gerado__c,
            TW1_Numero__c,
            TW1_Numero_Fidelidade__c,
            TW1_Data_inicio__c,
            TW1_Data_Fim__c,
            TW1_Status__c
            from TW1_Cartoes_Estacionamento__c 
            where Id=:IdCartao limit 1 
        ];
        
        CartaoGerado.TW1_Cartao_Gerado__c = true;
       
            Update CartaoGerado;
            return CartaoGerado;
    }
}