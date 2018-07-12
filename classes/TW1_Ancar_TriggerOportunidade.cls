public class TW1_Ancar_TriggerOportunidade {
    
    public static List<PropriedadeReservada> lstPropriedadeManterOcupada { get; set; }
    
    public static void afterAlterStageOportunidade(Opportunity newOpp)
    {           
        Opportunity recordIdField = [SELECT RecordTypeId FROM Opportunity WHERE Id = :newOpp.Id];
        Id recordId = recordIdField.RecordTypeId;
        RecordType record = [SELECT Name FROM RecordType WHERE Id = :recordId];
        
        System.debug('Novo estágio da oportunidade: ' + newOpp.StageName);
        System.debug('record.Name: ' + record.Name);
        
        //Quando atualizado o status da oportunidade  para "Aprovada", alterar o status da(s) propriedade(s) como "Ocupada"
        //E então buscar as oportunidades relacionadas com a(s) propriedade(s) e alterar o status da oportunidade para "Arquivada" (se não está com status "Aprovada")    
        if (newOpp.StageName == 'Aprovada' && record.Name != 'Oportunidade de Loja')
        {
            estagioAprovada(newOpp);
        }
        
        //De acordo com o status "Enviada para integração" da oportunidade, deve-se realizar a integração da mesma
        if (newOpp.StageName == 'Enviada para integração')
        {            
            estagioParaIntegracao(newOpp.Id);
        }
    }
    
    //De acordo com o status "Aprovada" da oportunidade, alterar o status da(s) propriedade(s) como "Ocupada"
    //E então buscar as oportunidades relacionadas com a(s) propriedade(s) (exceto a que startou a trigger) e:
    //1- alterar o status da oportunidade para "Arquivada"
    //2- excluir os calendarios das propriedades
    //Caso a oportunidade esteja no estágio "Em negociação", "Aguardando aprovação" ou "Proposta enviada para o cliente"    
    private static void estagioAprovada(Opportunity opp)
    {           
        System.debug('Oportunidade: ' + opp);
        
        //Busca todos Ids de Propriedade dos objetos junction Oportunidade-Propriedade onde a oportunidade seja a que está sendo trabalhada
        List<TW1_Prpriedade_Oportunidade__c> lstOpportunityProperty = 
            [SELECT TW1_Propriedade__c FROM TW1_Prpriedade_Oportunidade__c 
             WHERE TW1_Oportunidade__c = :opp.Id];
        
        System.debug('Lista TW1_Prpriedade_Oportunidade__c: ' + lstOpportunityProperty);
        
        //Inicializa uma lista de IDs
        List<Id> lstPropriedadeId = new List<Id>();
        
        //Joga os IDs das propriedades relacionadas para a lista
        for (TW1_Prpriedade_Oportunidade__c oppProp : lstOpportunityProperty)
        {
            lstPropriedadeId.add(oppProp.TW1_Propriedade__c);
        }
        
        //Busca as propriedades da Oportunidade atual com os Ids
        List<TW1_Propriedade__c> lstPropriedade = 
            [SELECT Id, Name, TW1_Status__c FROM TW1_Propriedade__c WHERE Id IN :lstPropriedadeId];
        
        System.debug('Lista de Propriedades: ' + lstPropriedade);
        
        //Altera os Calendarios de Propriedades com status "Ocupada" e atualiza data início e fim de vigência
        List<TW1_Calendario_de_propriedades__c> lstCalendar =
            [SELECT TW1_Propriedade__c, TW1_Status__c, TW1_Data_de_inicio__c, TW1_Data_de_fim__c 
             FROM TW1_Calendario_de_propriedades__c
             WHERE TW1_Propriedade__c IN :lstPropriedadeId AND TW1_Opportunidade__c = :opp.Id];
        
        lstPropriedadeManterOcupada = new List<PropriedadeReservada>();
        
        System.debug('Lista Calendario Ocupada: ' + lstCalendar);
        for (TW1_Calendario_de_propriedades__c cal : lstCalendar)
        {            
            cal.TW1_Status__c = 'Ocupada';
            cal.TW1_Data_de_inicio__c = opp.TW1_Data_inicio_de_vigencia__c;
            cal.TW1_Data_de_fim__c = opp.TW1_Data_fim_de_vigencia__c;
            
            PropriedadeReservada guadarCalendario = 
                new PropriedadeReservada(cal.TW1_Propriedade__c, cal.TW1_Data_de_inicio__c, cal.TW1_Data_de_fim__c);
            lstPropriedadeManterOcupada.add(guadarCalendario);
        }
        
        System.debug('Atualizando Lista de Calendários: ' + lstCalendar);
        Database.SaveResult[] srList = Database.update(lstCalendar, false);
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Atualizou calendário. TW1_Calendario_de_propriedades__c ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Erro ao atualiazr calendário TW1_Calendario_de_propriedades__c.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Campos do TW1_Calendario_de_propriedades__c que causaram este erro: ' + err.getFields());
                }
            }
        }
        
        System.debug('Propriedades da Oportunidade atualizada: ' + lstPropriedadeId);        
        
        //Busca todos Ids de Oportunidade dos objetos junction Oportunidade-Propriedade onde a Propriedade foi atualizada
        List<TW1_Prpriedade_Oportunidade__c> lstOpportunityProperty2 = 
            [SELECT Id, TW1_Oportunidade__c, TW1_Propriedade__c FROM TW1_Prpriedade_Oportunidade__c 
             WHERE TW1_Propriedade__c IN :lstPropriedadeId];
        
        System.debug('Junctions OpportunityProperty onde a Propriedade foi atualizada: ' + lstOpportunityProperty2);
        
        //Inicializa uma lista de IDs para guardar as Oportunidades para Arquivar
        List<Id> lstOportunidadeArquivadaId = new List<Id>();
        
        //Busca as oportunidades da lista de Ids, exceto a que startou a trigger, e joga na lista das Oportunidades para Arquivar
        for (TW1_Prpriedade_Oportunidade__c oppProp : lstOpportunityProperty2)
        {
            if (oppProp.TW1_Oportunidade__c != opp.Id)
                lstOportunidadeArquivadaId.add(oppProp.TW1_Oportunidade__c);
        }
        
        System.debug('lstOportunidadeArquivadaId: ' + lstOportunidadeArquivadaId);
        
        //Busca as oportunidades com os Ids da lista das Oportunidades para Arquivar, mas filtrando pelo estágio
        //'Em negociação', 'Aguardando aprovação' ou 'Proposta enviada para o cliente'
        List<Opportunity> lstOportunidadeArquivada = 
            [SELECT Id, StageName FROM Opportunity 
             WHERE Id IN :lstOportunidadeArquivadaId
             AND (StageName = 'Em negociação' 
                  OR StageName = 'Aguardando aprovação' 
                  OR StageName = 'Proposta enviada para o cliente'
                 )
            ];
        
        System.debug('lstOportunidadeArquivada: ' + lstOportunidadeArquivada);
        
        lstOportunidadeArquivadaId = new List<Id>();
        for (Opportunity o : lstOportunidadeArquivada)
        {
            lstOportunidadeArquivadaId.add(o.Id);
        }
        
        System.debug('Lista Oportunidades para arquivar: ' + lstOportunidadeArquivada);
               
        //Lista dos calendários das oportunidades que vão ser arquivadas
        List<TW1_Calendario_de_propriedades__c> cals = 
            [SELECT Id, TW1_Propriedade__c, TW1_Opportunidade__c, TW1_Data_de_inicio__c, TW1_Data_de_fim__c 
             FROM TW1_Calendario_de_propriedades__c WHERE TW1_Opportunidade__c IN :lstOportunidadeArquivadaId];
        
        System.debug('Calendarios a serem excluídos antes de filtrar: ' + cals);
        
        //Remove os calendários das propriedades que não devem ser excluídos
        Boolean propriedadeOcupada = false;
        System.debug('propriedadeOcupada: ' + propriedadeOcupada);
        List<Integer> indexesToRemove = new List<Integer>();
        Integer index = 0;
        for(TW1_Calendario_de_propriedades__c c : cals)
        {            
            //Propriedades Ocupadas
            for (PropriedadeReservada backupCalendar : lstPropriedadeManterOcupada)
            {
                if(c.TW1_Propriedade__c == backupCalendar.propriedadeId)
                {                 
                    propriedadeOcupada = true;
                    System.debug('propriedadeOcupada: ' + propriedadeOcupada);
                    
                    //Não arquiva se...
                    //Se a data início da outra é mais atual que a data fim da principal ou
                    //Se a data fim da outra é mais antiga que a data início da principal
                    if(c.TW1_Data_de_inicio__c > backupCalendar.dataFim || c.TW1_Data_de_fim__c < backupCalendar.dataInicio)
                    {
                        indexesToRemove.add(index);
                        break;
                    }                        
                }
            }
            
            //O calendário é de uma propriedade que não está na oportunidade aprovada, então não deve ser excluído
            if(propriedadeOcupada == false)
            {
                System.debug('Não vai mais excluir o calendário ' + c);
                indexesToRemove.add(index);
            }
            
            index++;
            
            System.debug('Voltando o status para falso');
            propriedadeOcupada = false;
        }
        
        System.debug('cals: ' + cals);
        System.debug('indexesToRemove: ' + indexesToRemove);
        
        List<Integer> reversed = new List<Integer>();
        for(Integer i = indexesToRemove.size() - 1; i >= 0; i--){
            reversed.add(indexesToRemove[i]);
        }
        
        System.debug('Reversed indexesToRemove: ' + reversed);
        
        //Exclui os calendários das oportunidades que vão ser arquivadas
        for(Integer i : reversed)
        {
            cals.remove(i);
            System.debug('Removeu o index e o calendário ficou: ' + cals);
        }
        
        //Guardar os IDs das oportunidades dos calendários que serão excluídos para arquivá-las
        List<Id> lstIdOportunidadesParaArquivar = new List<Id>();
        for(TW1_Calendario_de_propriedades__c c : cals)
        {
            lstIdOportunidadesParaArquivar.add(c.TW1_Opportunidade__c);
        }
        System.debug('IDs oportunidadesParaArquivar: ' + lstIdOportunidadesParaArquivar);
        
        delete cals;            	
        System.debug('Excluiu os calendários: ' + cals);

        if(!lstPropriedadeManterOcupada.isEmpty())
        {
            lstOportunidadeArquivada = 
                [SELECT Id, StageName FROM Opportunity 
                 WHERE Id IN :lstIdOportunidadesParaArquivar
                 AND (StageName = 'Em negociação' 
                      OR StageName = 'Aguardando aprovação' 
                      OR StageName = 'Proposta enviada para o cliente'
                     )
                ];
            
            System.debug('Lista Oportunidades para arquivar: ' + lstOportunidadeArquivada);
        }
        
        //Rejeita o processo de aprovação e altera o status das oportunidades como "Arquivada"
        for (Opportunity op : lstOportunidadeArquivada)
        {            
            rejectRecord(op, opp);
            
            System.debug('op.StageName: ' + op.StageName);  
            if(op.StageName == 'Em negociação' || op.StageName == 'Aguardando aprovação' || op.StageName == 'Proposta enviada para o cliente')
            {
                op.StageName = 'Arquivada';  
            }
        }
        
        update lstOportunidadeArquivada;
    }
    
    private static void rejectRecord(Opportunity opp, Opportunity oppAprovada)
    {
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Esta oportunidade foi rejeitada, pois possui uma ou mais propriedades que estão associadas à Oportunidade "' + oppAprovada.Name + '"" que foi aprovada.');
        req.setAction('Reject');
        
        Id workItemId = getWorkItemId(opp.id); 
        
        if(workItemId == null)
        {
            System.debug('Erro ao tentar rejeitar a oportunidade');
        }
        else
        {
            req.setWorkitemId(workItemId);
            Approval.ProcessResult result =  Approval.process(req);
            
            Opportunity o = [SELECT stagename from Opportunity where id =:opp.Id];
            System.debug('Status da oportunidade: ' + o); 
        }
    }
    
    private static Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;
        
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
                                                 where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
        }
        
        return retVal;
    }
    
    //De acordo com o status "Enviada para integração" da oportunidade, deve-se realizar a integração da mesma
    @future(callout=true) 
    private static void estagioParaIntegracao(Id oppId)
    {   
        System.debug('Método estagioParaIntegracao()');
        Opportunity opp = [SELECT Id, StageName From Opportunity WHERE Id =:oppId];
        
        System.debug('É teste? ' + Test.isRunningTest());
        if (!Test.isRunningTest())
        {            
            String   bodyJS = TW1_Ancar_IntegracaoSOQL.serializarObjetos(opp);
            String   vaRequestBody = 'oportunidade='+EncodingUtil.urlEncode(bodyJS, 'UTF-8');
            String   vaMethod = 'POST';
            Integer  vaTimeout = 120000;
            String   vaClientCertificateName = '';
            //URL Homologação:
            String   vaEndpoint = 'https://vsteste.ancarivanhoe.com.br/?ajax:salesforceINMKT&MKTunity=5120-fe00-6b75-0079-2b07&is_sandbox=1';
            //URL DEV:
            //String   vaEndpoint = 'http://fanatico.vssis.com.br/?ajax:salesforceINMKT&MKTunity=5120-fe00-6b75-0079-2b07&is_sandbox=1';
            //URL DEV: 
            //String   vaEndpoint = 'http://fanatico.vssis.com.br/?ajax:salesforceINMKT&MKTunity=5120-fe00-6b75-0079-2b07&is_sandbox=0';  
            Map<String,String> vaListOfHeaderParameters = null; 
            
            HttpRequest vaHttpRequest = Tw1_Ancar_CalloutUtils_cls.buildRequest(vaListOfHeaderParameters,
                                                                                vaMethod,vaTimeout, vaClientCertificateName, vaRequestBody,vaEndpoint); 
            
            Tw1_Ancar_CalloutUtils_cls.Tw1_CalloutResponse_cls vaCalloutResponse = 
                Tw1_Ancar_CalloutUtils_cls.executeCallout(vaHttpRequest);
            
            System.debug('BodyJS: ' + bodyJS);
            System.debug('Request Body: ' + vaRequestBody);
            System.debug('Response: ' + vaCalloutResponse);
            System.debug('Response Body: ' + vaCalloutResponse.httpResponse.getBody());
            
            if (vaCalloutResponse != null && vaCalloutResponse.httpResponse.getStatusCode() != 200)
            {
                opp.StageName = 'Erro de integração';
                opp.TW1_Descricao_erro_integracao__c = vaCalloutResponse.httpResponse.toString();
                update opp;
            }
        }
        else
        {
            System.debug('É teste! Vai alterar o estágio da oportunidade: ' + opp);
            opp.StageName = 'Integrada';
            opp.TW1_Descricao_erro_integracao__c = '';
            update opp;
            System.debug('Alterou o estágio da oportunidade: ' + opp);
        }
    }
    
    public class PropriedadeReservada
    {
        public String propriedadeId;
        public Date dataInicio;
        public Date dataFim;
        
        public PropriedadeReservada(String idPropriedade, Date inicio, Date fim)
        {
            this.propriedadeId = idPropriedade;
            this.dataInicio = inicio;
            this.dataFim = fim;
        }
    }
}