public with sharing class Tw1_Ancar_Handler_Oportunidade
implements ITrigger
{	
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    // Construtor
    public Tw1_Ancar_Handler_Oportunidade(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;        
        BatchSize = size;
    }
    
    public void bulkBefore()
    {
        
    }
    
    public void bulkAfter()
    {
    }
    
    public void beforeInsert(SObject so)
    {
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
    }
    
    public void beforeDelete(SObject so)
    {	
        // Adicionando o erro ao objeto
        //Object.addError('Você não pode deletar o seu contato Oportunidade');		
    }
    
    public void afterInsert(SObject so)
    {
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        System.debug('Chegou na trigger');
        
        Opportunity newOpp = (Opportunity)so;
        
        TW1_Ancar_TriggerOportunidade.afterAlterStageOportunidade(newOpp);        
    }
    
    public void afterDelete(SObject so)
    {
    }
    
    public void OnUndelete(SObject restoredSObject){
        
    }
    
    public void andFinally()
    {
        
    }
}