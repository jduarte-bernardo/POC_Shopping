trigger Tw1_Ancar_OportunidadeTrigger on Opportunity (before update, after update, before insert, before delete, 
                                                      after insert, after delete, after undelete) 
{    
    TriggerFactory.createHandler(Opportunity.sObjectType);   
}