public class TW1_Ancar_PropriedadeMockGenerator_cls {
    
    //private static List<TW1_Shopping__c> shopping = [SELECT Id FROM TW1_Shopping__c LIMIT 1];
    
    public static TW1_Ancar_wrapRecodtypes rec = new TW1_Ancar_wrapRecodtypes();
    
    public static TW1_Shopping__c criaShopping(){
        
        TW1_Shopping__c vaShopping = new TW1_Shopping__c();
        vaShopping.Name = 'Shopping Teste';
        vaShopping.TW1_SGL_Empreendimento__c='ST';
        insert vaShopping;
        
        return vaShopping;
    }
    
    public static TW1_Propriedade__c getFeiraoMock(String quoteId)
    {
        List<RecordType> recordFeirao = [SELECT Id FROM RecordType WHERE Name = :rec.rec_Prop_Feiras];
        
        TW1_Propriedade__c propriedade = new TW1_Propriedade__c (
            Name = 'ApexTest Propriedade 1',
            TW1_Status__c = 'Vaga',
            RecordTypeId = recordFeirao[0].Id,
            TW1_Shopping__c = criaShopping().Id          
        );
        insert propriedade;
        
        TW1_Propriedade_da_Cotacao__c cotProp = new TW1_Propriedade_da_Cotacao__c(
            TW1_Propriedade__c = propriedade.Id,
            TW1_Cotacao__c = quoteId,
            TW1_Data_de_inicio__c = Date.today(),
            TW1_Data_de_fim__c = Date.today().addDays(10),
            TW1_Localizacao__c = 'Localização',
            TW1_Valor__c = 16.20,
            TW1_Area__c = 40
        );        
        insert cotProp; 
        
        TW1_Propriedade__c prop = 
            [SELECT TW1_Piso__c, TW1_Shopping__c, TW1_Subtipo__c, TW1_area_m2__c, TW1_Observacao__c, TW1_Status__c,
             TW1_Ativa__c, TW1_Status_da_prospecao__c, TW1_AMM__c, TW1_Fundo__c, TW1_OTN__c, TW1_Condominio__c,
             TW1_Nota_de_d_bito_ou_CTO__c, TW1_Res_Perata__c, TW1_Valor_TR__c, TW1_Valor_de_tabela__c, TW1_IPTU__c, Name
             FROM TW1_Propriedade__c WHERE Id= :propriedade.Id];
        
        return prop;
    }
    
    public static TW1_Propriedade__c getMidiaMock(String quoteId)
    {
        List<RecordType> recordMidia = [SELECT Id FROM RecordType WHERE Name = :rec.rec_Prop_Midia];
        
        TW1_Propriedade__c propriedade = new TW1_Propriedade__c (
            Name = 'DEV Propriedade Midia',
            TW1_Status__c = 'Vaga',
            RecordTypeId = recordMidia[0].Id,
            TW1_Shopping__c = criaShopping().Id 
        );
        insert propriedade;
        
        TW1_Propriedade_da_Cotacao__c cotProp = new TW1_Propriedade_da_Cotacao__c(
            TW1_Propriedade__c = propriedade.Id,
            TW1_Cotacao__c = quoteId,
            TW1_Data_de_inicio__c = Date.today(),
            TW1_Data_de_fim__c = Date.today().addDays(10),            
            TW1_Area__c = 40
        );        
        insert cotProp; 
        
        TW1_Propriedade__c prop = 
            [SELECT TW1_Piso__c, TW1_Shopping__c, TW1_Subtipo__c, TW1_area_m2__c, TW1_Observacao__c, TW1_Status__c,
             TW1_Ativa__c, TW1_Status_da_prospecao__c, TW1_AMM__c, TW1_Fundo__c, TW1_OTN__c, TW1_Condominio__c,
             TW1_Nota_de_d_bito_ou_CTO__c, TW1_Res_Perata__c, TW1_Valor_TR__c, TW1_Valor_de_tabela__c, TW1_IPTU__c, Name
             FROM TW1_Propriedade__c WHERE Id= :propriedade.Id];
        
        return prop;
    }
    
    public static TW1_Propriedade__c getLojaMock(String quoteId)
    {   
        List<RecordType> recordLoja = [SELECT Id FROM RecordType WHERE Name = :rec.rec_Prop_Loja];
        
        TW1_Propriedade__c propriedade = new TW1_Propriedade__c (
            Name = 'ApexTest Propriedade 1',
            TW1_Status__c = 'Vaga',
            RecordTypeId = recordLoja[0].Id,
            TW1_Shopping__c = criaShopping().Id         
        );
        insert propriedade; 
        
        TW1_Propriedade_da_Cotacao__c cotProp = new TW1_Propriedade_da_Cotacao__c(
            TW1_Propriedade__c = propriedade.Id,
            TW1_Cotacao__c = quoteId,
            TW1_Data_de_inicio__c = Date.today(),
            TW1_Data_de_fim__c = Date.today().addDays(10), 
            TW1_Valor__c = 16.20,           
            TW1_Area__c = 40
        );        
        insert cotProp; 
        
        TW1_Propriedade__c prop = 
            [SELECT TW1_Piso__c, TW1_Shopping__c, TW1_Subtipo__c, TW1_area_m2__c, TW1_Observacao__c, TW1_Status__c,
             TW1_Ativa__c, TW1_Status_da_prospecao__c, TW1_AMM__c, TW1_Fundo__c, TW1_OTN__c, TW1_Condominio__c,
             TW1_Nota_de_d_bito_ou_CTO__c, TW1_Res_Perata__c, TW1_Valor_TR__c, TW1_Valor_de_tabela__c, TW1_IPTU__c, Name
             FROM TW1_Propriedade__c WHERE Id= :propriedade.Id];
        
        return prop;
    }
    
    public static TW1_Propriedade__c getMallMock(String quoteId)
    {   
        List<RecordType> recordMall = [SELECT Id FROM RecordType WHERE Name = :rec.rec_Prop_Mall];
        
        TW1_Propriedade__c propriedade = new TW1_Propriedade__c (
            Name = 'ApexTest Propriedade 1',
            TW1_Status__c = 'Vaga',
            RecordTypeId = recordMall[0].Id,
            TW1_Shopping__c = criaShopping().Id          
        );
        insert propriedade;
        
        TW1_Propriedade_da_Cotacao__c cotProp = new TW1_Propriedade_da_Cotacao__c(
            TW1_Propriedade__c = propriedade.Id,
            TW1_Cotacao__c = quoteId,
            TW1_Data_de_inicio__c = Date.today(),
            TW1_Data_de_fim__c = Date.today().addDays(10),            
            TW1_Area__c = 40
        );        
        insert cotProp; 
        
        TW1_Propriedade__c prop = 
            [SELECT TW1_Piso__c, TW1_Shopping__c, TW1_Subtipo__c, TW1_area_m2__c, TW1_Observacao__c, TW1_Status__c,
             TW1_Ativa__c, TW1_Status_da_prospecao__c, TW1_AMM__c, TW1_Fundo__c, TW1_OTN__c, TW1_Condominio__c,
             TW1_Nota_de_d_bito_ou_CTO__c, TW1_Res_Perata__c, TW1_Valor_TR__c, TW1_Valor_de_tabela__c, TW1_IPTU__c, Name
             FROM TW1_Propriedade__c WHERE Id= :propriedade.Id];
        
        return prop;
    }
    
    public static TW1_Calendario_de_propriedades__c getCalendarioOcupado(string idPropriedade, Date dataInicio, Date dataFim)
    {
        TW1_Calendario_de_propriedades__c calendario = new TW1_Calendario_de_propriedades__c();
        
        calendario.TW1_Propriedade__c = idPropriedade;
        calendario.TW1_Data_de_inicio__c = dataInicio;
        calendario.TW1_Data_de_fim__c = dataFim;
        calendario.TW1_Status__c ='Ocupada';
        insert calendario;
        
        return calendario;
    }
}