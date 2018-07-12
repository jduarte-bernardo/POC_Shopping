global class TW1_OpportunityWebService {
	webservice static WebserviceResponse atualizaStatusProposta (String idOpp, String etapa, String descEtapa)
    {        
        System.debug('Chamou o método atualizaStatusProposta');   
        List<Opportunity> oportunidade = [SELECT Id, TW1_Etapa__c, TW1_Descricao_da_etapa__c
                                    FROM Opportunity
                                    WHERE Id = :idOpp];
        
        System.debug('oportunidade: ' + oportunidade);
        
        if(oportunidade != null && oportunidade.size() > 0)
        {
            oportunidade[0].TW1_Etapa__c = etapa;
        	oportunidade[0].TW1_Descricao_da_etapa__c = descEtapa;
                
            try 
            {
                update oportunidade[0];
                WebserviceResponse res = new WebserviceResponse();
                res.result = 'Success';
                
                return res;
            }
            catch (Exception e)
            {
                WebserviceResponse res = new WebserviceResponse(); res.result = 'Fail'; res.error = e.getMessage();         
                return res;
            }
        }
        else
        {
            String erro = 'Não foi encontrada Opportunity com o Id ' + idOpp;
            WebserviceResponse res = new WebserviceResponse(); res.result = 'Fail'; res.error = erro;
                return res;
        }
    }
    
    webservice static WebserviceResponse atualizaValoresAprovadosComite(String idOpp, Decimal vgl, Decimal abl, 
                                                              Decimal comissao, Integer qtdPropriedade)
    {    
        System.debug('Chamou o método atualizaValoresAprovadosComite');    
        List<Opportunity> oportunidade = [SELECT Id, TW1_VGL_total__c, TW1_ABL_faturada__c, 
                                    TW1_Comissao__c, TW1_Quantidade_de_propriedades__c
                                    FROM Opportunity
                                    WHERE Id = :idOpp];
        
        System.debug('oportunidade: ' + oportunidade);
        
        if(oportunidade != null && oportunidade.size() > 0)
        {
            oportunidade[0].TW1_VGL_total__c = vgl;
            oportunidade[0].TW1_ABL_faturada__c = abl;
            oportunidade[0].TW1_Comissao__c = comissao;
            oportunidade[0].TW1_Quantidade_de_propriedades__c = qtdPropriedade;
            
            try 
            {
                update oportunidade[0];
                WebserviceResponse res = new WebserviceResponse();
                res.result = 'Success';
                
                return res;
            }
            catch (Exception e)
            {
                WebserviceResponse res = new WebserviceResponse(); res.result = 'Fail'; res.error = e.getMessage();
                return res;
            }
        }
        else
        {
            String erro = 'Não foi encontrada Opportunity com o Id ' + idOpp;
            WebserviceResponse res = new WebserviceResponse(); res.result = 'Fail'; res.error = erro;
                return res;
        }
    }
    
    webservice static WebserviceResponse atualizaPropostaGeral(String idOpp, String etapa, String descEtapa, Decimal vgl, 
                                                               Decimal abl, Decimal comissao, Integer qtdPropriedade)
    {
        List<Opportunity> oportunidade = [SELECT Id, TW1_Etapa__c, TW1_Descricao_da_etapa__c, TW1_VGL_total__c, 
                                          TW1_ABL_faturada__c, TW1_Comissao__c, TW1_Quantidade_de_propriedades__c
                                          FROM Opportunity
                                          WHERE Id = :idOpp];
        
        System.debug('oportunidade: ' + oportunidade);
        
        if(oportunidade != null && oportunidade.size() > 0)
        {
            oportunidade[0].TW1_Etapa__c = etapa;
        	oportunidade[0].TW1_Descricao_da_etapa__c = descEtapa;
            oportunidade[0].TW1_VGL_total__c = vgl;
            oportunidade[0].TW1_ABL_faturada__c = abl;
            oportunidade[0].TW1_Comissao__c = comissao;
            oportunidade[0].TW1_Quantidade_de_propriedades__c = qtdPropriedade;
            
            try 
            {
                update oportunidade[0];
                WebserviceResponse res = new WebserviceResponse();
                res.result = 'Success';
                
                return res;
            }
            catch (Exception e)
            {
                WebserviceResponse res = new WebserviceResponse(); res.result = 'Fail'; res.error = e.getMessage();
                return res;
            }
        }
        else
        {
            String erro = 'Não foi encontrada Opportunity com o Id ' + idOpp;
            WebserviceResponse res = new WebserviceResponse(); res.result = 'Fail'; res.error = erro;
                return res;
        }
    }
    
    webservice static WebserviceResponse insereIdProposta (String idOpp, String idExterno)
    {               
        System.debug('Chamou o método insereIdProposta');
        List<Opportunity> oportunidade = [SELECT Id, TW1_Id_VS__c FROM Opportunity WHERE Id = :idOpp];
        
        if(oportunidade != null && oportunidade.size() > 0)
        {
        	oportunidade[0].TW1_Id_VS__c = idExterno;        
            try 
            {
                update oportunidade[0];
                WebserviceResponse res = new WebserviceResponse();
                res.result = 'Success';
                
                return res;
            }
            catch (Exception e)
            {
                WebserviceResponse res = new WebserviceResponse(); res.result = 'Fail'; res.error = e.getMessage();
                return res;
            }
        }
        else
        {
            String erro = 'Não foi encontrada Opportunity com o Id ' + idOpp;
            WebserviceResponse res = new WebserviceResponse(); res.result = 'Fail'; res.error = erro;
                return res;
        }
    }
    
    webservice static WebserviceResponse atualizaEstagioProposta (String idOpp, Boolean integrada, String descErroIntegracao)
    {        
        System.debug('Chamou o WebserviceResponse atualizaEstagioProposta');
        System.debug(idOpp);
        System.debug(integrada);
        System.debug(descErroIntegracao);
        
        List<Opportunity> oportunidade = [SELECT Id, StageName, TW1_Descricao_erro_integracao__c FROM Opportunity WHERE Id = :idOpp];
        
        System.debug('oportunidade: ' + oportunidade);
        
        if(oportunidade != null && oportunidade.size() > 0)
        {
            System.debug('oportunidade.size()' + oportunidade.size());
            
            if (integrada)
            {
                oportunidade[0].StageName = 'Integrada';
                oportunidade[0].TW1_Descricao_erro_integracao__c = '';
            }
            else
            {
                oportunidade[0].StageName = 'Erro de integração';
                oportunidade[0].TW1_Descricao_erro_integracao__c = descErroIntegracao;
            }
            
            try 
            {
                update oportunidade[0];
                WebserviceResponse res = new WebserviceResponse();
                res.result = 'Success';
                
                return res;
            }
            catch (Exception e)
            {
                System.debug('Exception: ' + e);
                WebserviceResponse res = new WebserviceResponse(); res.result = 'Fail'; res.error = e.getMessage();
                return res;
            }
        }
        else
        {
            String erro = 'Não foi encontrada Opportunity com o Id ' + idOpp;
            WebserviceResponse res = new WebserviceResponse(); res.result = 'Fail'; res.error = erro;
                return res;
        }
    }
    
    global class WebserviceResponse {
        webservice String result = '';
        webservice String error = '';
    }    
}