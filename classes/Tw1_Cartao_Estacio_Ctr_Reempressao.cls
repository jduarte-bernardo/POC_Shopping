public class Tw1_Cartao_Estacio_Ctr_Reempressao {
    
    public TW1_Cartao_Estacio_Serv cartaoService = new TW1_Cartao_Estacio_Serv();
    
    public TW1_Cartoes_Estacionamento__c vaCartao {get;set;}
    public TW1_Fidelidade__c vaFidelidade {get;set;}
    public Account vaAccount {get;set;}
    public string CompletarDigitos {get;set;}
    private final TW1_Cartoes_Estacionamento__c acct;
    
    
    public Tw1_Cartao_Estacio_Ctr_Reempressao(ApexPages.StandardController stdController) {
        this.acct = (TW1_Cartoes_Estacionamento__c)stdController.getRecord();
    }
    
    public String CompletarCodigoDeBarras(String paCdBarras){
        String n ='';
        for (integer i=paCdBarras.length();i<=7;i++){
            n+='0';
        }	
        return n;
    }
    
    public void GerarPdf(){
        String idCartaoEstacionamento = ApexPages.currentPage().getParameters().get('id');
        GerarCartao(idCartaoEstacionamento);
    }
    
    public void GerarCartao(String paIdCartaoEstacionamento){
        List<TW1_Cartoes_Estacionamento__c> vaCartaoo = cartaoService.getCartaoEstacionamento(paIdCartaoEstacionamento);
        vaCartao = vaCartaoo.get(0);
        vaFidelidade = cartaoService.getFidelidade(vaCartao.TW1_Numero_Fidelidade__c);
        vaAccount = cartaoService.geAccount(vaFidelidade.TW1_Nome_Cliente__c);
        CompletarDigitos 	= CompletarCodigoDeBarras(vaCartao.TW1_Numero__c);
    }
}