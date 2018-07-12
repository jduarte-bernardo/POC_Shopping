public with sharing class TW1_Cartao_Estacio_Ctr_GerarPDFT {
    
    public TW1_Cartao_Estacio_Serv cartaoService = new TW1_Cartao_Estacio_Serv();
    
    public TW1_Cartoes_Estacionamento__c vaCartao {get;set;}
    public TW1_Fidelidade__c vaFidelidade {get;set;}
    public Account vaAccount {get;set;}
    public String DataVencimento {get;set;}
    public string CompletarDigitos {get;set;}
    private final TW1_Cartoes_Estacionamento__c acct;
    public boolean MensagemErro {get;set;}
    public boolean validoAte {get;set;}
    public string messageError {get;set;}
    
    
    public TW1_Cartao_Estacio_Ctr_GerarPDFT(ApexPages.StandardController stdController) {
        this.acct = (TW1_Cartoes_Estacionamento__c)stdController.getRecord();
    }
    
    public String CompletarCodigoDeBarras(String paCdBarras){
        String n ='';
        for (integer i=paCdBarras.length();i<=7;i++){
            n+='0';
        }	
        return n;
    }
    
    public void UpdateCartaoGerado(String Idcartao){
        cartaoService.UpdateCartaoGerado(Idcartao);
    }
    
    public void GerarPdf(){
        
        String idCartaoEstacionamento = ApexPages.currentPage().getParameters().get('id');
        
        List<TW1_Cartoes_Estacionamento__c> vaCartaoo = cartaoService.getCartaoEstacionamento(idCartaoEstacionamento);
        
        If(!vaCartaoo.isEmpty()){
            MensagemErro = false;
            validoAte = true;
            vaCartao = vaCartaoo.get(0);
            vaFidelidade = cartaoService.getFidelidade(vaCartao.TW1_Numero_Fidelidade__c);
            
            if(vaCartao.TW1_Cartao_Gerado__c == true ){
                if(vaFidelidade.TW1_Saldo__c >= 1000){
                    vaAccount 			= cartaoService.geAccount(vaFidelidade.TW1_Nome_Cliente__c);
            		CompletarDigitos 	= CompletarCodigoDeBarras(vaCartao.TW1_Numero__c);
                    //criar novo registro no historioc
                    cartaoService.UpdateCartaoGeradoInativo(vaCartao.Id);
                    cartaoService.GerarHistorico(vaFidelidade.Id);
                    
                     messageError = 'Segunda via gerada com sucesso, acesse o novo registro';
            		 MensagemErro = true;
                     validoAte = false;
                     vaCartao = new TW1_Cartoes_Estacionamento__c();
                     vaAccount = new Account();
                     vaFidelidade = new TW1_Fidelidade__c();
                    
                }else{
                     messageError = 'Saldo insuficiente para segunda via';
            		 MensagemErro = true;
                     validoAte = false;
                     vaCartao = new TW1_Cartoes_Estacionamento__c();
                }
                
 
            }else{
                vaAccount 			= cartaoService.geAccount(vaFidelidade.TW1_Nome_Cliente__c);
            	CompletarDigitos 	= CompletarCodigoDeBarras(vaCartao.TW1_Numero__c);
                UpdateCartaoGerado(vaCartao.Id);
            }
      
        	 //PageReference PaginaAtual = Page.TW1_Gerar_Cartao_Estacionamento;
        	 //new TW1_GeraPDF().saveAndOpenPDF(vaCartao.id,PaginaAtual,'Teste');
     
        }else{
            messageError = 'Este cartão está inativo!';
            MensagemErro = true;
            validoAte = false;
        }
    }
    

}