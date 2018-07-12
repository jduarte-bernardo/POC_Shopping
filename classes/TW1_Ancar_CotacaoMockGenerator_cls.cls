public class TW1_Ancar_CotacaoMockGenerator_cls {

    public static TW1_Ancar_wrapRecodtypes rec = new TW1_Ancar_wrapRecodtypes();
    
    public static Quote getFeiraoMock(String opportunityId)
    {
    	List<RecordType> recordFeirao = [SELECT Id FROM RecordType WHERE Name = :rec.rec_Cotcao_feiras];
        
        Quote quoteMock = new Quote(
            Name = 'ApexTest QuoteName', 
            RecordTypeId = recordFeirao[0].Id, 
            TW1_Sincronizada__c = false,    
            TW1_Data_inicio_de_vigencia__c = Date.today(),
            TW1_Data_fim_de_vigencia__c = Date.today().AddDays(10),    
            TW1_Prazo__c = 132,      
            TW1_Valor__c = 1,    
            TW1_AMM__c = 10, 
            TW1_AMM_1__c = 10, 
            TW1_AMM_2__c = 10, 
            TW1_AMM_3__c = 10, 
            TW1_AMM_4__c = 10, 
            TW1_AMM_5__c = 10,
            TW1_AMM_6__c = 10, 
            TW1_AMM_7__c = 10, 
            TW1_AMM_8__c = 10, 
            TW1_AMM_9__c = 10, 
            TW1_AMM_10__c = 10,
            OpportunityId = opportunityId
        );
        insert quoteMock;
        
        Quote quote = 
            [SELECT id, TW1_FPP__c, TW1_AMM__c, TW1_AMM_1__c, TW1_AMM_2__c, TW1_AMM_3__c, TW1_AMM_4__c, TW1_AMM_5__c, TW1_Segunda_data_de_pagamento__c,
             TW1_AMM_6__c, TW1_AMM_7__c, TW1_AMM_8__c, TW1_AMM_9__c, TW1_AMM_10__c, TW1_VGL_AMM__c, TW1_Prazo__c, TW1_Valor__c, 
             TW1_Valor_pacote_de_midia__c, TW1_Forma_pagamento_pacote_de_midia__c, TW1_Condominio__c, TW1_Acrescimo_sazonal_maio__c, 
             TW1_Acrescimo_sazonal_novembro__c, TW1_Acrescimo_sazonal_dezembro__c, TW1_Aluguel_Percentual__c, TW1_CDU__c, TW1_Valor_Desconto__c,
             TW1_Forma_de_pagamento_da_CDU__c, TW1_Carencia__c, TW1_Mes_aluguel_dobrado__c, TW1_Data_inicio_de_vigencia__c,
             TW1_Data_fim_de_vigencia__c, TW1_Data_de_pagamento__c, TW1_Atividade__c, TW1_Periodo_de_locacao__c, Description,
             TW1_Taxa_de_transferencia__c, TW1_QuoteRecordTypeName__c, TW1_Area_utilizada__c, RecordTypeId, Name, OpportunityId
             FROM Quote WHERE Id = :quoteMock.Id];
        
        return quote;
    }
    
    public static Quote getMidiaMock(String opportunityId)
    {
    	List<RecordType> recordMidia = [SELECT Id FROM RecordType WHERE Name = :rec.rec_Cotcao_midia];
        
        Quote quoteMock = new Quote(
            Name = 'ApexTest QuoteName',
            RecordTypeId = recordMidia[0].Id, 
            TW1_Sincronizada__c = false,
            TW1_Data_inicio_de_vigencia__c = Date.today(),
            TW1_Data_fim_de_vigencia__c = Date.today().AddDays(10),
            TW1_Prazo__c = 132,
            TW1_Valor_pacote_de_midia__c = 2,
            TW1_AMM__c = 10, 
            TW1_AMM_1__c = 10, 
            TW1_AMM_2__c = 10, 
            TW1_AMM_3__c = 10, 
            TW1_AMM_4__c = 10, 
            TW1_AMM_5__c = 10,
            TW1_AMM_6__c = 10, 
            TW1_AMM_7__c = 10, 
            TW1_AMM_8__c = 10, 
            TW1_AMM_9__c = 10, 
            TW1_AMM_10__c = 10,
            TW1_VGL_AMM__c = 4000,
            TW1_VGL_total__c = 10000,
            OpportunityId = opportunityId
        );
        insert quoteMock;
        
        Quote quote = 
            [SELECT id, TW1_FPP__c, TW1_AMM__c, TW1_AMM_1__c, TW1_AMM_2__c, TW1_AMM_3__c, TW1_AMM_4__c, TW1_AMM_5__c, TW1_Valor__c,
             TW1_AMM_6__c, TW1_AMM_7__c, TW1_AMM_8__c, TW1_AMM_9__c, TW1_AMM_10__c, TW1_VGL_AMM__c, TW1_Prazo__c, TW1_VGL_total__c, 
             TW1_Valor_pacote_de_midia__c, TW1_Forma_pagamento_pacote_de_midia__c, TW1_Condominio__c, TW1_Acrescimo_sazonal_maio__c, 
             TW1_Acrescimo_sazonal_novembro__c, TW1_Acrescimo_sazonal_dezembro__c, TW1_Aluguel_Percentual__c, TW1_CDU__c, TW1_Segunda_data_de_pagamento__c,
             TW1_Forma_de_pagamento_da_CDU__c, TW1_Carencia__c, TW1_Mes_aluguel_dobrado__c, TW1_Data_inicio_de_vigencia__c,TW1_Valor_Desconto__c,
             TW1_Data_fim_de_vigencia__c, TW1_Data_de_pagamento__c, TW1_Atividade__c, TW1_Periodo_de_locacao__c, Description,
             TW1_Taxa_de_transferencia__c, TW1_QuoteRecordTypeName__c, TW1_Area_utilizada__c, RecordTypeId, Name, OpportunityId
             FROM Quote WHERE Id = :quoteMock.Id];
        
        return quote;
    }
    
    public static Quote getMallMock(String opportunityId)
    {
        List<RecordType> recordMall = [SELECT Id FROM RecordType WHERE Name = :rec.rec_Cotcao_mall];
        
        Quote quoteMock = new Quote(
            Name = 'ApexTest QuoteName',
            RecordTypeId = recordMall[0].Id,
            TW1_Sincronizada__c = false,
            TW1_Periodo_de_locacao__c = 'Determinado',
            TW1_Data_inicio_de_vigencia__c = Date.today(),
            TW1_Data_fim_de_vigencia__c = Date.today().AddDays(10),
            TW1_Prazo__c = 132,
            TW1_AMM__c = 10, 
            TW1_AMM_1__c = 10, 
            TW1_AMM_2__c = 10, 
            TW1_AMM_3__c = 10, 
            TW1_AMM_4__c = 10, 
            TW1_AMM_5__c = 10,
            TW1_AMM_6__c = 10, 
            TW1_AMM_7__c = 10, 
            TW1_AMM_8__c = 10, 
            TW1_AMM_9__c = 10, 
            TW1_AMM_10__c = 10,
            TW1_VGL_AMM__c = 4000,
            TW1_VGL_total__c = 10000,
            OpportunityId = opportunityId
        );
        insert quoteMock;
        
        Quote quote = 
            [SELECT id, TW1_FPP__c, TW1_AMM__c, TW1_AMM_1__c, TW1_AMM_2__c, TW1_AMM_3__c, TW1_AMM_4__c, TW1_AMM_5__c, TW1_Valor__c,
             TW1_AMM_6__c, TW1_AMM_7__c, TW1_AMM_8__c, TW1_AMM_9__c, TW1_AMM_10__c, TW1_VGL_AMM__c, TW1_Prazo__c, TW1_VGL_total__c,
             TW1_Valor_pacote_de_midia__c, TW1_Forma_pagamento_pacote_de_midia__c, TW1_Condominio__c, TW1_Acrescimo_sazonal_maio__c, 
             TW1_Acrescimo_sazonal_novembro__c, TW1_Acrescimo_sazonal_dezembro__c, TW1_Aluguel_Percentual__c, TW1_CDU__c, TW1_Segunda_data_de_pagamento__c,
             TW1_Forma_de_pagamento_da_CDU__c, TW1_Carencia__c, TW1_Mes_aluguel_dobrado__c, TW1_Data_inicio_de_vigencia__c,TW1_Valor_Desconto__c,
             TW1_Data_fim_de_vigencia__c, TW1_Data_de_pagamento__c, TW1_Atividade__c, TW1_Periodo_de_locacao__c, Description,
             TW1_Taxa_de_transferencia__c, TW1_QuoteRecordTypeName__c, TW1_Area_utilizada__c, RecordTypeId, Name, OpportunityId
             FROM Quote WHERE Id = :quoteMock.Id];
        
        return quote;
    }
    
    public static Quote getLojaMock(String opportunityId)
    {
    	List<RecordType> recordLoja = [SELECT Id FROM RecordType WHERE Name = :rec.rec_Cotcao_loja]; 
        
        Quote quoteMock = new Quote(
            Name = 'ApexTest QuoteName', 
            RecordTypeId = recordLoja[0].Id, 
            TW1_Sincronizada__c = false,
            TW1_Data_inicio_de_vigencia__c = Date.today(),
            TW1_Data_fim_de_vigencia__c = Date.today().AddDays(10),
            TW1_Prazo__c = 132,
            TW1_Valor_pacote_de_midia__c = 2,
            TW1_AMM__c = 10, 
            TW1_AMM_1__c = 10, 
            TW1_AMM_2__c = 10, 
            TW1_AMM_3__c = 10, 
            TW1_AMM_4__c = 10, 
            TW1_AMM_5__c = 10,
            TW1_AMM_6__c = 10, 
            TW1_AMM_7__c = 10, 
            TW1_AMM_8__c = 10, 
            TW1_AMM_9__c = 10, 
            TW1_AMM_10__c = 10,
            TW1_VGL_AMM__c = 400,
            TW1_VGL_total__c = 100000,
            TW1_Condominio__c = 1234567812345678.22,
      		TW1_FPP__c = 1234567812345678.22,
      		TW1_CDU__c = 1234567812345678.22,
      		TW1_Forma_de_pagamento_da_CDU__c = 'Long Text Area(500)',
            TW1_Aluguel_Percentual__c = 1234567812345678.22,
            TW1_Carencia__c = 'Text Area(255)',
            TW1_IPTU__c =1234567812345678.22,
            TW1_Valor_TR__c = 1234567812345678.22,
            TW1_Mes_aluguel_dobrado__c = 'Janeiro',
            TW1_Forma_pagamento_pacote_de_midia__c = 'Long Text Area(500)',
      		Description = 'Long Text Area(32000)',
            TW1_Acrescimo_sazonal_dezembro__c = 1234567891,
      		TW1_Acrescimo_sazonal_maio__c = 1234567891,
      		TW1_Acrescimo_sazonal_novembro__c = 1234567891,
      		TW1_Periodo_de_locacao__c = 'Indeterminado',
            TW1_Area_utilizada__c = 1234567812345678.22,
      		TW1_Atividade__c = 'Long Text Area(500)',
            TW1_Data_de_pagamento__c = Date.today(),
      		TW1_Valor__c = 1234567812345678.22,
            OpportunityId = opportunityId
        );
        insert quoteMock;
        
        Quote quote = 
            [SELECT id, TW1_FPP__c, TW1_AMM__c, TW1_AMM_1__c, TW1_AMM_2__c, TW1_AMM_3__c, TW1_AMM_4__c, TW1_AMM_5__c, TW1_Valor__c,
             TW1_AMM_6__c, TW1_AMM_7__c, TW1_AMM_8__c, TW1_AMM_9__c, TW1_AMM_10__c, TW1_VGL_AMM__c, TW1_Prazo__c, TW1_VGL_total__c, 
             TW1_Valor_pacote_de_midia__c, TW1_Forma_pagamento_pacote_de_midia__c, TW1_Condominio__c, TW1_Acrescimo_sazonal_maio__c, 
             TW1_Acrescimo_sazonal_novembro__c, TW1_Acrescimo_sazonal_dezembro__c, TW1_Aluguel_Percentual__c, TW1_CDU__c, TW1_Segunda_data_de_pagamento__c,
             TW1_Forma_de_pagamento_da_CDU__c, TW1_Carencia__c, TW1_Mes_aluguel_dobrado__c, TW1_Data_inicio_de_vigencia__c,TW1_Valor_Desconto__c,
             TW1_Data_fim_de_vigencia__c, TW1_Data_de_pagamento__c, TW1_Atividade__c, TW1_Periodo_de_locacao__c, Description,
             TW1_Taxa_de_transferencia__c, TW1_QuoteRecordTypeName__c, TW1_Area_utilizada__c, RecordTypeId, Name, OpportunityId
             FROM Quote WHERE Id = :quoteMock.Id];
        
        return quote;
    }
}