public class TW1_Ancar_Venda_Propriedade_Rep {
    
    public TW1_Propriedade__c GetPropriedadeCotacaoLoja(string vaCotacaoId)
    {
        TW1_Propriedade_da_Cotacao__c Consulta = [SELECT Id,TW1_Propriedade__c FROM TW1_Propriedade_da_Cotacao__c WHERE TW1_Cotacao__c= :vaCotacaoId limit 1];
        
        if(Consulta != null)
            return GetPropriedadeById(Consulta.TW1_Propriedade__c);
        else
            return null;
    }
    
    public TW1_Propriedade__c GetPropriedadeByIdCotacaoMALL(string vaCotacaoId)
    {
        try{
            TW1_Propriedade_da_Cotacao__c listaConsulta = [SELECT TW1_Propriedade__c FROM TW1_Propriedade_da_Cotacao__c WHERE TW1_Cotacao__c= :vaCotacaoId limit 1];
            
            
            
            TW1_Propriedade__c vaPropriedade = [
                Select
                id,
                Name,
                TW1_Shopping__c,
                TW1_Subtipo__c,
                TW1_Piso__c,
                TW1_area_m2__c, 
                TW1_Observacao__c,
                TW1_Status__c,
                TW1_Ativa__c,
                TW1_Status_da_prospecao__c,
                TW1_AMM__c,
                TW1_Fundo__c,
                TW1_OTN__c,
                TW1_Condominio__c,
                TW1_Nota_de_d_bito_ou_CTO__c,
                TW1_Res_Perata__c,
                TW1_IPTU__c,
                TW1_Valor_TR__c,
                TW1_Valor_de_tabela__c,
                TW1_Localizacao__c
                from 
                TW1_Propriedade__c 
                where
                Id=:listaConsulta.TW1_Propriedade__c limit 1];
            
            return vaPropriedade;
            
        }catch(Exception ex){
            system.debug('Erro em consultar ListarPropriedadeLoja EX:' +ex);
            return null;
        }
        
    }
    
    public List<TW1_Propriedade_da_Cotacao__c> GetPropriedadeCotacao(string vaCotacaoId)
    {
        List<TW1_Propriedade_da_Cotacao__c> listaConsulta = [SELECT Id,TW1_Data_de_fim__c,TW1_Data_de_inicio__c,TW1_Valor__c,TW1_Propriedade__c,TW1_Localizacao__c,TW1_Area__c FROM TW1_Propriedade_da_Cotacao__c WHERE TW1_Cotacao__c= :vaCotacaoId];
        
        
        if(listaConsulta.size()  > 0)
            return listaConsulta;
        else
            return null;
    }
    
    public List<SObject> ListarPropriedadeLoja(Id idShopping)
    {
        try{
            
            List<TW1_Propriedade__c> vaPropriedade = [
                Select
                id,
                Name,
                TW1_Shopping__c,
                TW1_Subtipo__c,
                TW1_Piso__c,
                TW1_area_m2__c, 
                TW1_Observacao__c,
                TW1_Status__c,
                TW1_Ativa__c,
                TW1_Status_da_prospecao__c,
                TW1_AMM__c,
                TW1_Fundo__c,
                TW1_OTN__c,
                TW1_Condominio__c,
                TW1_Nota_de_d_bito_ou_CTO__c,
                TW1_Res_Perata__c,
                TW1_IPTU__c,
                TW1_Valor_TR__c,
                TW1_Valor_de_tabela__c
                from 
                TW1_Propriedade__c 
                where
                TW1_Ativa__c = true and
                TW1_Shopping__c =:idShopping and 
                (
                    TW1_Status__c='Vaga' or 
                    TW1_Status__c='Repasse'
                ) and
                (
                    TW1_Subtipo__c ='Âncora' or
                    TW1_Subtipo__c ='Megaloja' or
                    TW1_Subtipo__c ='Satélite'
                )
            ];
            
            System.debug('Propriedade loja' + vaPropriedade);
            if(vaPropriedade.size() >= 1){
                return vaPropriedade;
            }else{
                return null;
            }
            
        }catch(Exception ex){
            system.debug('Erro em consultar ListarPropriedadeLoja EX:' +ex);
            return null;
        }
    }
    
    public TW1_Propriedade__c GetPropriedadeById(Id idPropriedade)
    {
        List<TW1_Propriedade__c> listaConsulta = [SELECT TW1_Piso__c,
                                                  TW1_Shopping__c,
                                                  TW1_Subtipo__c,
                                                  TW1_area_m2__c, 
                                                  TW1_Observacao__c,
                                                  TW1_Status__c,
                                                  TW1_Ativa__c,
                                                  TW1_Status_da_prospecao__c,
                                                  TW1_AMM__c,
                                                  TW1_Fundo__c,
                                                  TW1_OTN__c,
                                                  TW1_Condominio__c,
                                                  TW1_Nota_de_d_bito_ou_CTO__c,
                                                  TW1_Res_Perata__c,
                                                  TW1_Valor_TR__c,
                                                  TW1_Valor_de_tabela__c,
                                                  TW1_IPTU__c,Name
                                                  FROM TW1_Propriedade__c WHERe id= :idPropriedade];
        
        if(listaConsulta.size()  > 0)
            return listaConsulta[0];
        else
            return null;
    }
    
    public List<SObject> ListarPorpriedadeMidiaFeira(Id idShopping, String paPropriedadeSubtipo, Date paDtini, Date paDtfim)
    {
        string IdShoppingsub = idShopping;
        IdShoppingsub = IdShoppingsub.substring(0,15);
        
        try{
            List<TW1_Propriedade__c> vaPropriedade = [
                select 
                Id,
                Name,
                TW1_Shopping__c,
                TW1_Subtipo__c,
                TW1_Piso__c,
                TW1_area_m2__c, 
                TW1_Observacao__c,
                TW1_Status__c,
                TW1_Ativa__c,
                TW1_Status_da_prospecao__c,
                TW1_AMM__c,
                TW1_Fundo__c,
                TW1_OTN__c,
                TW1_Condominio__c,
                TW1_Nota_de_d_bito_ou_CTO__c,
                TW1_Res_Perata__c,
                TW1_IPTU__c,
                TW1_Valor_TR__c,
                TW1_Valor_de_tabela__c,
                TW1_Localizacao__c
                from 
                TW1_Propriedade__c
                where
                TW1_Ativa__c = true and
                TW1_Subtipo__c=:paPropriedadeSubtipo and
                TW1_Shopping__c=:idShopping 
                and
                Id NOT IN
                (Select TW1_Propriedade__c from TW1_Calendario_de_propriedades__c 
                 where TW1_ShoppingId__c=:IdShoppingsub and 
                 TW1_Data_de_inicio__c <=:paDtfim and
                 TW1_Data_de_fim__c >=:paDtini and 
                 TW1_Status__c ='Ocupada'
                )
            ];	
            
            
            
            if(vaPropriedade.size() >= 1){
                return vaPropriedade;
            }else{
                return null;
            }
            
        }catch(Exception ex){
            return null;
        }
    }
    
    public List<SObject> ListarPorpriedadeMidiaFeiraOcupadas(Id idShopping, String paPropriedadeSubtipo, Date paDtini, Date paDtfim)
    {
        string IdShoppingsub = idShopping;
        IdShoppingsub = IdShoppingsub.substring(0,15);
        
        try{
            List<TW1_Propriedade__c> vaPropriedade = [
                select 
                Id,
                Name,
                TW1_Shopping__c,
                TW1_Subtipo__c,
                TW1_Piso__c,
                TW1_area_m2__c, 
                TW1_Observacao__c,
                TW1_Status__c,
                TW1_Ativa__c,
                TW1_Status_da_prospecao__c,
                TW1_AMM__c,
                TW1_Fundo__c,
                TW1_OTN__c,
                TW1_Condominio__c,
                TW1_Nota_de_d_bito_ou_CTO__c,
                TW1_Res_Perata__c,
                TW1_IPTU__c,
                TW1_Valor_TR__c,
                TW1_Valor_de_tabela__c,
                TW1_Localizacao__c
                from 
                TW1_Propriedade__c
                where
                TW1_Ativa__c = true and
                TW1_Subtipo__c=:paPropriedadeSubtipo and
                TW1_Shopping__c=:idShopping 
                and
                Id IN
                (Select TW1_Propriedade__c from TW1_Calendario_de_propriedades__c 
                 where TW1_ShoppingId__c=:IdShoppingsub and 
                 TW1_Data_de_inicio__c <=:paDtfim and
                 TW1_Data_de_fim__c >=:paDtini and 
                 TW1_Status__c ='Ocupada'
                )
            ];	
            
            if(vaPropriedade.size() >= 1){
                return vaPropriedade;
            }else{
                return null;
            }
            
        }catch(Exception ex){
            return null;
        }
    }
    
    public List<SObject> ListarPropriedadeMall(Id idShopping, String paPropriedadeSubtipo)
    {
        try{
            List<TW1_Propriedade__c> vaPropriedade = [
                SELECT 
                id,
                Name,
                TW1_Shopping__c,
                TW1_Subtipo__c,
                TW1_Piso__c,
                TW1_area_m2__c, 
                TW1_Observacao__c,
                TW1_Status__c,
                TW1_Ativa__c,
                TW1_Status_da_prospecao__c,
                TW1_AMM__c,
                TW1_Fundo__c,
                TW1_OTN__c,
                TW1_Condominio__c,
                TW1_Nota_de_d_bito_ou_CTO__c,
                TW1_Res_Perata__c,
                TW1_IPTU__c,
                TW1_Valor_TR__c,
                TW1_Valor_de_tabela__c,
                TW1_Localizacao__c
                from 
                TW1_Propriedade__c
                where
                TW1_Ativa__c = true and
                TW1_Subtipo__c =:paPropriedadeSubtipo and
                TW1_Shopping__c =:idShopping]; 
            
            if(vaPropriedade.size() >= 1){
                return vaPropriedade;
            }else{
                return null;
            }
            
        }catch(Exception ex){
            return null;
        }
        
    }
    
    public List<TW1_Calendario_de_propriedades__c> ListaPeriodosOcupacao(string idPropriedade, Date dataInicio, Date dataFim)
    {
        List<TW1_Calendario_de_propriedades__c> listaRetorno = [SELECT 
                                                                TW1_Propriedade__c,
                                                                TW1_Data_de_inicio__c,
                                                                TW1_Data_de_fim__c,
                                                                TW1_Status__c
                                                                FROM TW1_Calendario_de_propriedades__c 
                                                                where TW1_Propriedade__c=:idPropriedade and 
                                                                TW1_Data_de_inicio__c <=:dataFim and
                                                                TW1_Data_de_fim__c >=:dataInicio and 
                                                                TW1_Status__c ='Ocupada'];
        
        if(listaRetorno.size() > 0)
            return listaRetorno;
        else
            return null;
    }
    
}