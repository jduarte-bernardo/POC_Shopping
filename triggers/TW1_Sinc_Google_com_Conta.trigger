trigger TW1_Sinc_Google_com_Conta on Contact (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    
    TriggerFactory.createHandler(Contact.sObjectType);

}