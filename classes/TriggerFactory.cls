/**
 * Classe TriggerFactory
 *
 * Usada para instanciar e executar Trigger Handlers associados a objetos.
 */
global with sharing class TriggerFactory
{
	//@future
	public static void createHandler(Schema.sObjectType soType)
	{	
		//Recebe o handle apropriado para o objeto processado
		ITrigger handler = getHandler(soType);

		// Verifica se existe um handler registrado, caso não tenha, subimos uma exception
		if (handler == null)
		{
			throw new TriggerException('Nâo Existe uma Trigger Handler registrada para esse tipo de Objeto: ' + soType);
		}
		
		// Executa o handler correspondente a sua trigger
		execute(handler);
	}
	
	private static void execute(ITrigger handler)
	{
		// Before Trigger
		if (Trigger.isBefore)
		{
			// Call the bulk before to handle any caching of data and enable bulkification
			handler.bulkBefore();
			
			// Iterate through the records to be deleted passing them to the handler.
			if (Trigger.isDelete)
			{
				for (SObject so : Trigger.old)
				{
					handler.beforeDelete(so);
				}
			}
			// Iterate through the records to be inserted passing them to the handler.
			else if (Trigger.isInsert)
			{
				for (SObject so : Trigger.new)
				{
					handler.beforeInsert(so);
				}
			}
			// Iterate through the records to be updated passing them to the handler.
			else if (Trigger.isUpdate)
			{
				for (SObject so : Trigger.old)
				{
					handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
				}
			}
		}
		else
		{
			// Call the bulk after to handle any caching of data and enable bulkification
			handler.bulkAfter();
			
			// Iterate through the records deleted passing them to the handler.
			if (Trigger.isDelete)
			{
				for (SObject so : Trigger.old)
				{
					handler.afterDelete(so);
				}
			}
			// Iterate through the records inserted passing them to the handler.
			else if (Trigger.isInsert)
			{
				for (SObject so : Trigger.new)
				{
					handler.afterInsert(so);
				}
			}
			// Iterate through the records updated passing them to the handler.
			else if (Trigger.isUpdate)
			{
				for (SObject so : Trigger.old)
				{
					handler.afterUpdate(so, Trigger.newMap.get(so.Id));
				}
			}
			else if(Trigger.isUnDelete){
				for (SObject so : Trigger.new)
				{
					handler.OnUndelete(so);   
				}
			}
		}
		
		// Perform any post processing
		handler.andFinally();
	}
	
	
	private static ITrigger getHandler(Schema.sObjectType soType)
	{
		if (soType == Contact.sObjectType)
		{
			return new TW1_Ancar_Handler_Contact(Trigger.isExecuting, Trigger.size);
		}
        
        if (soType == Account.sObjectType)
		{
			return new TW1_Valida_cpf_cnpjHandler(Trigger.isExecuting, Trigger.size);
		}
		
        if (soType == Opportunity.sObjectType)
		{
			return new Tw1_Ancar_Handler_Oportunidade(Trigger.isExecuting, Trigger.size);
		}
        
		return null;
	}
}