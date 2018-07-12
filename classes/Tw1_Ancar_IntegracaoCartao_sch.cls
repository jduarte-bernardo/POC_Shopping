global without sharing class Tw1_Ancar_IntegracaoCartao_sch implements Schedulable { 
  global Tw1_Ancar_IntegracaoCartao_sch() {
  } 
    global void execute(SchedulableContext paSchedulableContext) { 
    Anc_ScheaduleUtils_cls.abortScheadule(paSchedulableContext);  
      Tw1_Ancar_IntegracaoCartao_Handler_cls.sendWithFuture(); 
  }
}