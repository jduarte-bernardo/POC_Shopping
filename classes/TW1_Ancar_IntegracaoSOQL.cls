public class TW1_Ancar_IntegracaoSOQL {
    
    public static String serializarObjetos(Opportunity opp)
    {        
        TW1_Shopping__c shopping = buscarShopping(opp);        
        Account marca = buscarMarca(opp);
        Account cliente = buscarCliente(opp);
        Opportunity oportunidade = buscarOportunidade(opp); 
        User owner = buscarColaborador(oportunidade.OwnerId);       
        Quote cotacao = buscarCotacao(opp);
        List<TW1_Propriedade_da_Cotacao__c> lstPropriedadeCotacao = buscarPropriedadeCotacao(cotacao);
        List<TW1_Propriedade__c> lstPropriedade = buscarPropriedade(lstPropriedadeCotacao);      
        
        Apex2JSON obj = new Apex2JSON();
        obj.opportunity = oportunidade;
        obj.marca = marca;
        obj.cliente = cliente;
        obj.owner = owner;
        obj.TW1_Shopping = shopping;
        obj.quote = cotacao;
        obj.TW1_Propriedade_da_Cotacao = lstPropriedadeCotacao;
        obj.TW1_Propriedade = lstPropriedade;
        
        string jsonData = JSON.serialize(obj);
        
        return jsonData;
    }
    
    private static TW1_Shopping__c buscarShopping(Opportunity opp)
    {
        System.debug('Buscando Shopping...');
        
        Opportunity idShoppingField = [SELECT TW1_Shopping__c FROM Opportunity WHERE Id = :opp.Id];
        Id idShopping = idShoppingField.TW1_Shopping__c;
        
        //Shopping
        TW1_Shopping__c shopping = [SELECT Name, TW1_SGL_Empreendimento__c, TW1_Id_Externo_VS__c 
                                    FROM TW1_Shopping__c WHERE Id = :idShopping];
               
        System.debug('Shopping: ' + shopping);
        return shopping;
    }
    
    private static Account buscarMarca(Opportunity opp)
    {
        System.debug('Buscando Marca...');
        
        Opportunity idMarcaField = [SELECT TW1_Marca__c FROM Opportunity WHERE Id = :opp.Id];
        Id idMarca = idMarcaField.TW1_Marca__c;
        
        //Marca
        Account marca = [SELECT Name, RecordTypeId, TW1_AccountRecordTypeName__c, TW1_ID_Externo__c, TW1_Status__c
                                    FROM Account WHERE Id = :idMarca];
               
        return marca;
    }
    
    private static Account buscarCliente(Opportunity opp)
    {        
        System.debug('Buscando Cliente...');
        
        Opportunity idClienteField = [SELECT AccountId FROM Opportunity WHERE Id = :opp.Id];
        Id idCliente = idClienteField.AccountId;
        
        //Cliente
        Account cliente = [SELECT TW1_ID_Externo__c, Firstname, LastName, TW1_CPF__c, TW1_Marca_pretendida__c, OwnerId, 
                           TW1_Telefone_comercial__c, TW1_Celular__c, TW1_Email_comercial__c, CEP__c, TW1_Av_Rua__c, TW1_Numero__c,
                           TW1_Complemento__c, TW1_Bairro__c, TW1_Cidade__c, TW1_Estado__c, TW1_Pais__c, TW1_Razao_Social__c, TW1_Nome_fantasia__c,
                           TW1_CNPJ__c, TW1_Status__c
                           FROM Account WHERE Id = :idCliente];
        System.debug('cliente: ' + cliente);
        
        return cliente;
    }    
    
    private static Opportunity buscarOportunidade(Opportunity opp)
    {
        System.debug('Buscando Oportunidade...');
        
        //Oportunidade
		Opportunity oportunidade = [SELECT Name, TW1_Shopping__c, TW1_Marca__c, AccountId, TW1_Id_VS__c, RecordTypeId, TW1_OpportunityRecordTypeName__c,
                                    OwnerId, CloseDate, StageName, Probability, NextStep, Description, Loss_Reason__c, TW1_Prazo__c,
                                    TW1_Status__c, TW1_Valor__c, TW1_VGL_faturado__c, TW1_Data_inicio_de_vigencia__c, 
                                    TW1_Data_fim_de_vigencia__c, TW1_ABL_faturada__c, TW1_Comissao__c, 
                                    TW1_Descricao_erro_integracao__c, TW1_Possui_midia_inaugural__c, TW1_Quantidade_de_propriedades__c, 
                                    TW1_VGL_AMM__c, TW1_VGL_total__c, TW1_Etapa__c, TW1_Descricao_da_etapa__c
                                    FROM Opportunity WHERE Id = :opp.Id];
        
		return oportunidade;
    }
    
    private static Quote buscarCotacao(Opportunity opp)
    {   
        System.debug('Buscando Cotação...');
        //Shopping
        List<Quote> quote = [SELECT OpportunityId, Name, RecordTypeId, TW1_QuoteRecordTypeName__c, TW1_AMM_1__c, TW1_AMM_2__c, TW1_AMM_3__c, TW1_AMM_4__c,TW1_AMM_5__c,
                           TW1_AMM_6__c, TW1_AMM_7__c, TW1_AMM_8__c, TW1_AMM_9__c, TW1_AMM_10__c, TW1_Condominio__c, TW1_FPP__c,
                           TW1_CDU__c, TW1_Forma_de_pagamento_da_CDU__c, TW1_Aluguel_Percentual__c, TW1_Carencia__c, TW1_IPTU__c, 
                           TW1_Valor_TR__c, TW1_Mes_aluguel_dobrado__c, TW1_Valor_pacote_de_midia__c, TW1_Forma_pagamento_pacote_de_midia__c,
                           Description, TW1_AMM__c, TW1_Acrescimo_sazonal_dezembro__c, TW1_Acrescimo_sazonal_maio__c, TW1_Acrescimo_sazonal_novembro__c,
                           TW1_Periodo_de_locacao__c, TW1_Prazo__c, TW1_Area_utilizada__c, TW1_Atividade__c, TW1_Data_inicio_de_vigencia__c,
                           TW1_Data_fim_de_vigencia__c, TW1_Data_de_pagamento__c, TW1_Valor__c, TW1_Sincronizada__c
                       FROM Quote 
                       WHERE OpportunityId = :opp.Id AND TW1_Sincronizada__c = true];
        
        System.debug('quote: ' + quote);
        if (!quote.isEmpty())
        {
            return quote[0];
        }	
        else
        {
            System.debug('Nenhuma cotação');
            Quote q = new Quote(Name='');
            return q;
        }
    }
    
    private static User buscarColaborador(String userId)
    {
        System.debug('Buscando colaborador...');
        
        List<User> colaborador = [SELECT Email FROM User WHERE Id = :userId];
        System.debug('colaborador: ' + colaborador);
        
        return colaborador[0];
    }
    
    private static List<TW1_Propriedade_da_Cotacao__c> buscarPropriedadeCotacao(Quote cotacao)
    {
        System.debug('Buscando Propriedades da Cotação...');
        
        //Propriedade_da_Cotacao
        List<TW1_Propriedade_da_Cotacao__c> lstPropCot = 
            [SELECT TW1_Propriedade__c, TW1_Cotacao__c, TW1_Data_de_fim__c, TW1_Data_de_inicio__c, TW1_Valor__c
            FROM TW1_Propriedade_da_Cotacao__c WHERE TW1_Cotacao__c = :cotacao.Id];
                     
        return lstPropCot;     
    }
    
    private static List<TW1_Propriedade__c> buscarPropriedade(List<TW1_Propriedade_da_Cotacao__c> lstPropriedadeCotacao)
    { 
        System.debug('Buscando Propriedades...');
        
        List<Id> lstIdPropriedade = new List<Id>();
        for (TW1_Propriedade_da_Cotacao__c idPropCotField : lstPropriedadeCotacao)
        {
            lstIdPropriedade.add(idPropCotField.TW1_Propriedade__c);
        }
        
        //Propriedade
        List<TW1_Propriedade__c> lstPropriedade = 
            [SELECT Name, TW1_Shopping__c, TW1_Piso__c, TW1_area_m2__c, TW1_Observacao__c, TW1_Status__c, TW1_Ativa__c, 
             TW1_Status_da_prospecao__c, TW1_AMM__c, TW1_Fundo__c, TW1_OTN__c, TW1_Condominio__c, TW1_Nota_de_d_bito_ou_CTO__c,
             TW1_Res_Perata__c, TW1_IPTU__c, TW1_Valor_TR__c, TW1_Id_Externo__c, TW1_Valor_de_tabela__c
             FROM TW1_Propriedade__c
             WHERE Id IN :lstIdPropriedade];

        
        System.debug(lstPropriedade);        
        return lstPropriedade;
    }
        
    private class Apex2JSON 
    {
        public Opportunity opportunity;
        public User owner;
        public Account marca;
		public Account cliente;
        public TW1_Shopping__c TW1_Shopping;
		public Quote quote;
		public List<TW1_Propriedade_da_Cotacao__c> TW1_Propriedade_da_Cotacao;
		public List<TW1_Propriedade__c> TW1_Propriedade;
	}
}