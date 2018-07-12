global without sharing class Anc_Fidelidade_sch implements Schedulable { 
  global Anc_Fidelidade_sch() {
  } 
    global void execute(SchedulableContext paSchedulableContext) { 
    Anc_ScheaduleUtils_cls.abortScheadule(paSchedulableContext);  
      Anc_Fidelidade_Handler_cls.sendWithFuture(); 
  }
}