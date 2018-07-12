trigger TW1_Valida_cpf_cnpj on Account (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    //if(!Test.isRunningTest())
    TriggerFactory.createHandler(Account.sObjectType);
    
}