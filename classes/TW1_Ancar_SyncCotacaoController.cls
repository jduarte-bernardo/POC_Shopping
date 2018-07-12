public with sharing class TW1_Ancar_SyncCotacaoController {
    
    public String IdOpportunity { get; set; }
    public String IdQuote { get; set; }
    public Boolean RenderizarDesktop { get; set; }
    public Boolean RenderizarMobile { get; set; }
    public List<TW1_Prpriedade_Oportunidade__c> lstOppProp { get; set; }
    public List<TW1_Calendario_de_propriedades__c> lstCalendario { get; set; }
    
    public TW1_Ancar_SyncCotacaoController(ApexPages.StandardController stdController) {
    }
    
    public void sincronizarCotacao() {         
        
        if(Test.isRunningTest())
        {
            RenderizarDesktop = true;
        }
        else
        {
            String userAgent = ApexPages.currentPage().getHeaders().get('User-Agent');
            
            if (userAgent.contains('iPhone')) {
                RenderizarMobile = true;
            } else if (userAgent.contains('iPad')) {
                RenderizarMobile = true;
            } else if (userAgent.contains('Salesforce')) {
                RenderizarMobile = true;
            } else if (userAgent.contains('BlackBerry')) {
                RenderizarMobile = true;
            } else {
                RenderizarDesktop = true;
            }
        }
        
        //Busca a cotação pelo ID do parâmetro
        List<Quote> quoteSync = [SELECT Id, Name, TW1_Data_fim_de_vigencia__c, TW1_Data_inicio_de_vigencia__c, TW1_Prazo__c, 
                                 OpportunityId, TW1_Valor_pacote_de_midia__c, TW1_VGL_AMM__c, TW1_VGL_total__c, TW1_Valor__c, TW1_Sincronizada__c
                                 FROM Quote WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        
        if(!quoteSync.isEmpty() && quoteSync.size() > 0)
        {
            Quote quote = quoteSync[0];
            
            System.debug('quote.TW1_Sincronizada__c: ' + quote.TW1_Sincronizada__c);
            if(quote.TW1_Sincronizada__c == false)
            {
                IdQuote = quote.Id;
                
                //Busca os juctions Cotação-Propriedade que a cotação está relacionada
                List<TW1_Propriedade_da_Cotacao__c> lstPropriedadeRel = 
                    [SELECT Id, TW1_Propriedade__c, TW1_Data_de_inicio__c, TW1_Data_de_fim__c 
                     FROM TW1_Propriedade_da_Cotacao__c WHERE TW1_Cotacao__c = :quote.Id];
                
                //Busca a Oportunidade relacionada à cotação
                Opportunity opportunity = [SELECT Id, Name, TW1_Prazo__c, TW1_OpportunityRecordTypeName__c, StageName, 
                                           TW1_Data_inicio_de_vigencia__c, TW1_Data_fim_de_vigencia__c,
                                           TW1_VGL_AMM__c, TW1_VGL_total__c, TW1_Cotacao_sincronizada__c, TW1_Valor__c 
                                           FROM Opportunity WHERE Id = :quote.OpportunityId];
                
                IdOpportunity = opportunity.Id;
                System.debug('Opp: ' + opportunity);
                
                //Valida pelo estágio se ela pode sincronizar
                List<String> stagesDontSync = new List<String>();
                stagesDontSync.add('Enviada para integração');
                stagesDontSync.add('Aguardando aprovação');
                stagesDontSync.add('Integrada');
                stagesDontSync.add('Arquivada');
                stagesDontSync.add('Erro de integração');
                
                System.debug('Estágio da oportunidade: ' + opportunity.StageName);
                Boolean sincronizar = true;
                for(String stage : stagesDontSync)
                {
                    if(opportunity.StageName == stage)
                    {
                        sincronizar = false;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'Não foi possível sincronizar, pois a oportunidade está no estágio "' + stage +'"'));
                    }    
                }
                
                if(sincronizar)
                {
                    System.debug('Pegando o prazo da cotação: ' + quote.TW1_Prazo__c);
                    opportunity.TW1_Prazo__c = quote.TW1_Prazo__c;
                    opportunity.TW1_Data_inicio_de_vigencia__c = quote.TW1_Data_inicio_de_vigencia__c;
                    opportunity.TW1_Data_fim_de_vigencia__c = quote.TW1_Data_fim_de_vigencia__c;
                    opportunity.TW1_Cotacao_sincronizada__c = quote.Id;
                    opportunity.CloseDate = Date.today();
                    
                    System.debug('Campo record.Name: ' + opportunity.TW1_OpportunityRecordTypeName__c);
                    
                    //Caso a oportunidade seja de Loja
                    if (opportunity.TW1_OpportunityRecordTypeName__c == 'Oportunidade de Loja') 
                    {
                        System.debug('Sincronizando cotação em Oportunidade de Loja');
                        System.debug('Campo quote.TW1_Valor_pacote_de_midia__c: ' + quote.TW1_Valor_pacote_de_midia__c);
                        
                        //Se o campo TW1_Valor_pacote_de_midia__c estiver com valor, marcar a checkbox TW1_Possui_midia_inaugural__c        
                        if (quote.TW1_Valor_pacote_de_midia__c != null && quote.TW1_Valor_pacote_de_midia__c > 0)
                        {
                            System.debug('Atualizou opportunity: TW1_Possui_midia_inaugural__c = true');
                            opportunity.TW1_Possui_midia_inaugural__c = true;
                        }
                        else //Se não, desmarcar
                        {
                            System.debug('Atualizou opportunity: TW1_Possui_midia_inaugural__c = false');
                            opportunity.TW1_Possui_midia_inaugural__c = false;
                        }
                        
                        //Atualiza a Oportunidade com VGL AMM e VGL Total da cotação
                        opportunity.TW1_VGL_AMM__c = quote.TW1_VGL_AMM__c;
                        opportunity.TW1_VGL_total__c = quote.TW1_VGL_total__c;
                        
                        //Deleta os junctions atuais na Oportunidade
                        deletaJunctionAtualOportunidade(opportunity.Id);
                        
                        //Cria os novos junctions na Oportunidade
                        newJunctionAtualOportunidade(opportunity, lstPropriedadeRel);
                    }
                    
                    //Caso a oportunidade seja de Mall
                    if (opportunity.TW1_OpportunityRecordTypeName__c == 'Oportunidade de Mall') 
                    {            
                        System.debug('Sincronizando cotação em Oportunidade de Mall');
                        
                        //Atualiza a Oportunidade com o Valor da cotação
                        opportunity.TW1_Valor__c = quote.TW1_Valor__c;
                        
                        System.debug('opportunity.TW1_Valor__c: ' + opportunity.TW1_Valor__c);
                        System.debug('quote.TW1_Valor__c: ' + quote.TW1_Valor__c);
                        
                        //Deleta os junctions atuais na Oportunidade
                        deletaJunctionAtualOportunidade(opportunity.Id);
                        
                        //Cria os novos junctions na Oportunidade
                        newJunctionAtualOportunidade(opportunity, lstPropriedadeRel);           
                    }   
                    
                    //Se a oportunidade for de mídia, atualiza as propriedades para "reservada"        
                    if (opportunity.TW1_OpportunityRecordTypeName__c == 'Oportunidade de Mídia')
                    {                
                        System.debug('Sincronizando cotação em Oportunidade de Mídia');   
                        
                        //Atualiza a Oportunidade com o Valor da cotação
                        opportunity.TW1_Valor__c = quote.TW1_Valor__c;
                        
                        System.debug('opportunity.TW1_Valor__c: ' + opportunity.TW1_Valor__c);
                        System.debug('quote.TW1_Valor__c: ' + quote.TW1_Valor__c);
                        
                        //Deleta os junctions atuais na Oportunidade
                        deletaJunctionAtualOportunidade(opportunity.Id);
                        
                        //Cria os novos junctions na Oportunidade
                        newJunctionAtualOportunidade(opportunity, lstPropriedadeRel); 
                    }
                    
                    if (opportunity.TW1_OpportunityRecordTypeName__c == 'Oportunidade de Feiras e Eventos')
                    {        
                        System.debug('Sincronizando cotação em Oportunidade de Feiras e Eventos');       
                        
                        //Atualiza a Oportunidade com o Valor da cotação
                        opportunity.TW1_Valor__c = quote.TW1_Valor__c;
                        
                        System.debug('opportunity.TW1_Valor__c: ' + opportunity.TW1_Valor__c);
                        System.debug('quote.TW1_Valor__c: ' + quote.TW1_Valor__c);
                        
                        //Deleta os junctions atuais na Oportunidade
                        deletaJunctionAtualOportunidade(opportunity.Id);
                        
                        //Cria os novos junctions na Oportunidade
                        newJunctionAtualOportunidade(opportunity, lstPropriedadeRel); 
                    }
                    
                    //Salva as alterações
                    try 
                    {                             
                        System.debug('Atualizando opportunity: ' + opportunity);
                        update(opportunity);        
                        
                        //Busca todas as cotações da oportunidade, exceto a da página que chamou a controller
                        List<Quote> quotesNotSync = [SELECT Id, name, TW1_Sincronizada__c, OpportunityId from Quote where OpportunityId = :opportunity.Id AND Id != :quote.Id ];
                        
                        //Desmarca a flag de sincronizada da cotação que estava anteriormente sincronizada com a oportunidade
                        //E exclui os registros de calendário da propriedade das outras cotações da mesma oportunidade
                        if(!quotesNotSync.isEmpty())
                        {
                            System.debug('Cotações da oportunidade: ' + quotesNotSync);
                            
                            //Lista de IDs das cotações não sincronizadas
                            List<Id> idQuotesNotSync = new List<Id>();
                            for(Quote quoteNotSync : quotesNotSync)
                            {
                                //Salvando os IDs das cotações não sincronizadas
                                idQuotesNotSync.add(quoteNotSync.Id);
                                
                                //Desmarca a flag da que era sincronizada
                                if (quoteNotSync.TW1_Sincronizada__c == true)
                                {
                                    System.debug('Desmarcando a flag de sincronizada da cotacao: ' + quoteNotSync);
                                    quoteNotSync.TW1_Sincronizada__c = false;
                                }
                            }          
                            System.debug('Atualizando cotações não sincronizadas');
                            update quotesNotSync;
                            
                            //Pega os objetos TW1_Propriedade_da_Cotacao__c da lista de IDs de cotação não sincronizada
                            List<TW1_Propriedade_da_Cotacao__c> lstPropCotacaoNaoSync = 
                                [SELECT Id, TW1_Propriedade__c, TW1_Data_de_inicio__c, TW1_Data_de_fim__c 
                                 FROM TW1_Propriedade_da_Cotacao__c WHERE TW1_Cotacao__c IN :idQuotesNotSync];
                            
                            //Lista de IDs de TW1_Propriedade__c da lista de TW1_Propriedade_da_Cotacao__c para excluir os calendários
                            List<ID> lstIdPropriedade = new List<ID>();
                            for (TW1_Propriedade_da_Cotacao__c propCotacaoNaoSync : lstPropCotacaoNaoSync)
                            {
                                lstIdPropriedade.add(propCotacaoNaoSync.TW1_Propriedade__c);
                            }
                            
                            //Busca os TW1_Calendario_de_propriedades__c para excluir de cada TW1_Propriedade__c da lista de TW1_Propriedade_da_Cotacao__c
                            List<TW1_Calendario_de_propriedades__c> lstCalendarDelete =
                                [SELECT Id FROM TW1_Calendario_de_propriedades__c 
                                 WHERE TW1_Propriedade__c IN :lstIdPropriedade AND TW1_Opportunidade__c =:opportunity.Id];
                            
                            System.debug('Lista de Calendario da propriedade a ser excluída: ' + lstCalendarDelete);
                            if (!lstCalendarDelete.isEmpty())
                            {                
                                System.debug('Excluindo a lista de calendários');                
                                delete lstCalendarDelete; 
                            }
                        }
                        
                        system.debug('Lista para Insert: '+lstOppProp);
                        
                        Database.SaveResult[] srList = Database.insert(lstOppProp, false);
                        // Iterate through each returned result
                        for (Database.SaveResult sr : srList) {
                            if (sr.isSuccess()) {
                                // Operation was successful, so get the ID of the record that was processed
                                System.debug('Inseriu junction. TW1_Prpriedade_Oportunidade__c ID: ' + sr.getId());
                            }
                            else {
                                // Operation failed, so get all errors                
                                for(Database.Error err : sr.getErrors()) {
                                    System.debug('Erro ao inserir junction TW1_Prpriedade_Oportunidade__c.');                    
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('Campos da TW1_Prpriedade_Oportunidade__c que causaram este erro: ' + err.getFields());
                                }
                            }
                        }
                        
                        srList = Database.insert(lstCalendario, false);
                        // Iterate through each returned result
                        for (Database.SaveResult sr : srList) {
                            if (sr.isSuccess()) {
                                // Operation was successful, so get the ID of the record that was processed
                                System.debug('Inseriu Calendário. Calendar ID: ' + sr.getId());
                            }
                            else {
                                // Operation failed, so get all errors                
                                for(Database.Error err : sr.getErrors()) {
                                    System.debug('Ocorreu um erro ao inserir Calendário.');                    
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('Campos de Calendário que causaram este erro: ' + err.getFields());
                                }
                            }
                        }
                        
                        //Marca que a cotação foi sincronizada
                        quote.TW1_Sincronizada__c = true;
                        update quote;
                    } 
                    catch(System.DMLException e) {
                        ApexPages.addMessages(e);
                        System.debug('Erro: ' + e);
                    }
                }
            }
            else
            {
                //Busca a Oportunidade relacionada à cotação
                Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Id = :quote.OpportunityId];                
                IdOpportunity = opportunity.Id;
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Esta cotação já está sincronizada.'));
                System.debug('Esta cotação já está sincronizada: ' + quoteSync);
            }
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'Não foi possível sincronizar, erro ao buscar cotação'));
            System.debug('ERRO ao recuperar cotação. Lista vazia: ' + quoteSync);
        }
    }
    
    private void deletaJunctionAtualOportunidade(String idOpp) 
    {
        System.debug('método deletaJunctionAtualOportunidade() parâmetro: ' + idOpp);
        
        //Deleta os junctions atuais de TW1_Prpriedade_Oportunidade__c da Oportunidade sendo atualizada 
        List<TW1_Prpriedade_Oportunidade__c> lstPropOpp = 
            [SELECT Id from TW1_Prpriedade_Oportunidade__c Where TW1_Oportunidade__c = :idOpp];
        
        System.debug('lstPropOpp: ' + lstPropOpp);
        if(!lstPropOpp.isEmpty())
        {
            delete (lstPropOpp);
            System.debug('Deletou a lista dos junctions - ' + lstPropOpp);
        }
    }
    
    //Cria os novos junctions na Oportunidade
    private void newJunctionAtualOportunidade(Opportunity opp, List<TW1_Propriedade_da_Cotacao__c> lstPropCotacao)
    {                  
        System.debug('método newJunctionAtualOportunidade() Oportunidade: ' + opp);
        System.debug('método newJunctionAtualOportunidade() lstPropCotacao: ' + lstPropCotacao);
        
        List<TW1_Propriedade__c> lstPropriedade = new List<TW1_Propriedade__c>();
        lstCalendario = new List<TW1_Calendario_de_propriedades__c>();
        
        //Para cada Propriedade da Cotação...
        for (TW1_Propriedade_da_Cotacao__c propCotacao : lstPropCotacao)
        {
            //Pega a propriedade do junction
            TW1_Propriedade__c prop = 
                [SELECT Id, RecordTypeId FROM TW1_Propriedade__c WHERE Id =:propCotacao.TW1_Propriedade__c];
            
            //Salva ela em uma lista para ser utilizada futuramente
            lstPropriedade.Add(prop);
        }
        
        if (opp.TW1_OpportunityRecordTypeName__c == 'Oportunidade de Mídia')
        {
            System.debug('É uma oportunidade de Mídia');
            
            //Cria um objeto TW1_Calendario_de_propriedades__c para reservar as propriedades
            for (TW1_Propriedade_da_Cotacao__c propCotacao : lstPropCotacao)
            {
                TW1_Calendario_de_propriedades__c calendario = new TW1_Calendario_de_propriedades__c();
                calendario.TW1_Data_de_inicio__c = propCotacao.TW1_Data_de_inicio__c;
                calendario.TW1_Data_de_fim__c = propCotacao.TW1_Data_de_fim__c;
                calendario.TW1_Propriedade__c = propCotacao.TW1_Propriedade__c;
                calendario.TW1_Status__c = 'Reservada';
                calendario.TW1_Opportunidade__c = opp.Id;
                lstCalendario.add(calendario);      
            }            
        }
        
        if (opp.TW1_OpportunityRecordTypeName__c == 'Oportunidade de Feiras e Eventos')
        {  
            System.debug('É uma oportunidade de Feiras e Eventos');
            
            //Para cada Propriedade da Cotação...
            for (TW1_Propriedade_da_Cotacao__c propCotacao : lstPropCotacao)
            {
                //Pega a propriedade do junction
                TW1_Propriedade__c prop = 
                    [SELECT Id, RecordTypeId FROM TW1_Propriedade__c WHERE Id =:propCotacao.TW1_Propriedade__c];
                
                System.debug('Propriedade: ' + prop);
                
                //Pega o RecordType da Propriedade
                RecordType propRecord = [SELECT Id, Name FROM RecordType WHERE Id = :prop.RecordTypeId];
                
                System.debug('Recordtype da propriedade: ' + propRecord);
                
                //Se a propriedade é de mídia, cria-se um objeto TW1_Calendario_de_propriedades__c para reservá-la
                if(propRecord.Name == 'Propriedade de Mídia' || propRecord.Name == 'Propriedade Feiras e Eventos')
                {
                    System.debug('Criando calendário da Propriedade: ' + prop);
                    TW1_Calendario_de_propriedades__c calendario = new TW1_Calendario_de_propriedades__c();
                    calendario.TW1_Data_de_inicio__c = propCotacao.TW1_Data_de_inicio__c;
                    calendario.TW1_Data_de_fim__c = propCotacao.TW1_Data_de_fim__c;
                    calendario.TW1_Propriedade__c = propCotacao.TW1_Propriedade__c;
                    calendario.TW1_Status__c = 'Reservada';
                    calendario.TW1_Opportunidade__c = opp.Id;
                    lstCalendario.add(calendario);       
                    System.debug('Lista de Calendário: ' + lstCalendario);
                }
            }    
        }        
        
        //Cria uma lista de junctions Oportunidade-Propriedade
        lstOppProp = new List<TW1_Prpriedade_Oportunidade__c>();
        
        System.debug('lstPropriedade: ' + lstPropriedade);
        integer index = 0;
        
        //Para cada propriedade da lista, cria uma nova junction Propriedade-Oportunidade            
        for (TW1_Propriedade__c prop : lstPropriedade)
        {    
            System.debug('Cria uma nova junction TW1_Prpriedade_Oportunidade__c');
            
            TW1_Prpriedade_Oportunidade__c oppProp = new TW1_Prpriedade_Oportunidade__c(
                TW1_Oportunidade__c = opp.Id,
                TW1_Propriedade__c = prop.Id
            );
            
            System.debug('oppProp: ' + oppProp);
            
            index++;
            lstOppProp.add(oppProp);
        }
    }
}