public class TW1_Ancar_OpportunityMockGenerator_cls {
    
    public static TW1_Ancar_wrapRecodtypes rec = new TW1_Ancar_wrapRecodtypes();
    
    public static List<RecordType> recordMarca = [SELECT Id FROM RecordType WHERE Name = :rec.rec_Marca LIMIT 1];
    
    public static Account criaMarca(){
        list<RecordType> recMarca = [SELECT Id FROM RecordType WHERE Name = :rec.rec_Marca Limit 1];   
        
        Account vaMarca = new Account();
        vaMarca.Name = 'Apex Text Marca';
        vaMarca.RecordTypeId = recMarca.get(0).Id;
        vaMarca.TW1_ID_Externo__c = 'TextoId 20';
        vaMarca.TW1_Status__c = 'Ativa';
        Insert vaMarca;
        return vaMarca;
        
    }
    public static Account criaCliente(String cpf){
        list<RecordType> recContato_PF = [SELECT Id FROM RecordType WHERE Name = :rec.rec_Contato_Comercial_PF Limit 1];   
        
        Account vaContato = new Account();
        vaContato.TW1_ID_Externo__c = 'Texto id externo';
        vaContato.Firstname = 'Text(40)';
        vaContato.LastName = 'Text(80)';
        vaContato.TW1_CPF__c = cpf;
        vaContato.TW1_Marca_pretendida__c = 'Text(80)';
        vaContato.TW1_Telefone_comercial__c = '26090000';
        vaContato.TW1_Celular__c = '26090000';
        vaContato.TW1_Email_comercial__c = 'email@email.com';
        vaContato.CEP__c = 8;
        vaContato.TW1_Av_Rua__c = 'Text(100)';
        vaContato.TW1_Numero__c = 8;
        vaContato.TW1_Complemento__c = 'Text(50)';
        vaContato.TW1_Bairro__c = 'Text(50)';
        vaContato.TW1_Cidade__c = 'Text(50)';
        vaContato.TW1_Estado__c = 'Text(20)';
        vaContato.TW1_Pais__c = 'Brasil';
        vaContato.TW1_Razao_Social__c = 'Text(100)';
        vaContato.TW1_Nome_fantasia__c = 'Text(100)';
        vaContato.TW1_Status__c = 'Ativa';
        vaContato.RecordTypeId = recContato_PF.get(0).Id;        
        
        Insert vaContato;
        System.debug('vaContato:'+vaContato);
        return vaContato;
        
    }
    public static TW1_Shopping__c criaShopping(String uniqueExternalID){
        
        System.debug('uniqueExternalID: ' + uniqueExternalID);
        TW1_Shopping__c vaShopping = new TW1_Shopping__c();
        vaShopping.Name = 'Shopping Teste';
        vaShopping.TW1_SGL_Empreendimento__c='ST';
        vaShopping.TW1_Id_Externo_VS__c = uniqueExternalID;
        insert vaShopping;
        system.debug('Shopping: ' + vaShopping);
        return vaShopping;        
    }
    public static User criaOwner(String uniqueUsername)
    {
        Profile pf= [Select Id from profile where Name='System Administrator' or Name='Administrador do sistema']; 
        
        User user =new User(
            firstname = 'ABC', 
            lastName = 'XYZ', 
            email = uniqueUsername, 
            Username = uniqueUsername, 
            EmailEncodingKey = 'ISO-8859-1', 
            Alias = uniqueUsername.substring(0, 4), 
            TimeZoneSidKey = 'America/Los_Angeles', 
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US', 
            ProfileId = pf.Id
        ); 
        insert user;
        
        User manager = new User(
            firstname = 'ABC', 
            lastName = 'XYZ', 
            email = 'manager' + uniqueUsername, 
            Username = 'manager' + uniqueUsername, 
            EmailEncodingKey = 'ISO-8859-1', 
            Alias = uniqueUsername.substring(0, 4), 
            TimeZoneSidKey = 'America/Los_Angeles', 
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey = 'en_US', 
            ProfileId = pf.Id
        ); 
        insert manager;
        
        user.ManagerId = manager.Id;
        update user;
        
        return user;
    }
    
    public static Opportunity getFeiraoMock()
    {
        List<RecordType> recordFeirao = [SELECT Id FROM RecordType WHERE Name = :rec.rec_feiras];
        
        //Criando uma oportunidade de feiras e eventos        
        Opportunity opportunity = new Opportunity(       
            RecordTypeId = recordFeirao[0].Id,            
            Name = 'ApexTest Opportunity Feirao',
            TW1_Cotacao_sincronizada__c = null,
            TW1_Data_inicio_de_vigencia__c = Date.today().AddDays(2),
            TW1_Data_fim_de_vigencia__c = Date.today().AddDays(3),
            StageName = 'Em negociação',
            TW1_Prazo__c = 0,
            CloseDate = Date.newInstance(2018,04,18),
            TW1_Oportunidade_aprovada__c = true,
            TW1_Marca__c = criaMarca().Id,
            TW1_Shopping__c = criaShopping('ID_EXTERNO').Id,
            AccountId = criaCliente('56430245519').Id,
            OwnerId = criaOwner('testAncar@test.com.br').Id //ownerId
        );                  
        insert opportunity; 
        
        return opportunity;
    }
    
    public static Opportunity getMallMock()
    {
        List<RecordType> recordMall = [SELECT Id FROM RecordType WHERE Name = :rec.rec_mall];
                
        //Criando uma oportunidade de Mall
        Opportunity opportunity = new Opportunity(        
            Name = 'ApexTest Opportunity Mall',
            TW1_Cotacao_sincronizada__c = null,
            TW1_Data_inicio_de_vigencia__c = Date.today().AddDays(9),
            TW1_Data_fim_de_vigencia__c = Date.today().AddDays(15),
            StageName = 'Em negociação',
            TW1_Prazo__c = 0,
            CloseDate = Date.today(),
            TW1_Oportunidade_aprovada__c = true,
            RecordTypeId = recordMall[0].Id,  
            TW1_Marca__c = criaMarca().Id,
            TW1_Shopping__c = criaShopping('ID_EXTERNO').Id,
            AccountId = criaCliente('56430245519').Id,
            OwnerId = criaOwner('testAncar@test.com.br').Id //ownerId
        );
        insert opportunity; 
        
        return opportunity;
    }
    
    public static Opportunity getMidiaMock()
    {
        System.debug('Mídia Mock');
        List<RecordType> recordMidia = [SELECT Id FROM RecordType WHERE Name = :rec.rec_midia];
         
        //Criando uma oportunidade de Mídia        
        Opportunity opportunity = new Opportunity(              
            Name = 'ApexTest Opportunity Mídia',
            TW1_Cotacao_sincronizada__c = null,
            TW1_Data_inicio_de_vigencia__c = Date.today().AddDays(9),
            TW1_Data_fim_de_vigencia__c = Date.today().AddDays(10),
            StageName = 'Em negociação',
            TW1_Prazo__c = 0,
            CloseDate = Date.today(),   
            TW1_Oportunidade_aprovada__c = true, 
            RecordTypeId = recordMidia[0].Id, 
            TW1_Marca__c = criaMarca().Id,
            TW1_Shopping__c = criaShopping('ID_EXTERNO').Id,
            TW1_Possui_midia_inaugural__c = false,
            AccountId = criaCliente('56430245519').Id,
            OwnerId = criaOwner('testAncar@test.com.br').Id
        );                  
        insert opportunity;
        
        return opportunity;
    }
    
    public static Opportunity getLojaMock()
    {        
        List<RecordType> recordLoja = [SELECT Id FROM RecordType WHERE Name = :rec.rec_loja];

        //Criando uma oportunidade
        Opportunity opportunity = new Opportunity(                 
            Name = 'ApexTest Opportunity 1',
            TW1_Cotacao_sincronizada__c = null,
            TW1_Data_inicio_de_vigencia__c = Date.today().AddDays(9),
            TW1_Data_fim_de_vigencia__c = Date.today().AddDays(10),
            StageName = 'Em negociação',
            CloseDate = Date.today(),  
            TW1_Oportunidade_aprovada__c = true,
            RecordTypeId = recordLoja[0].Id, 
            TW1_Marca__c = criaMarca().Id,
            TW1_Shopping__c = criaShopping('ID_EXTERNO').Id,
            AccountId = criaCliente('56430245519').Id,
            TW1_Id_VS__c = 'ID_Opp_VS',
            NextStep = 'Texto 255',
            Description = 'Long Text Area(32000)',
            Loss_Reason__c = 'Price',
            TW1_Prazo__c = 1234567891,
            TW1_Status__c = 'Quente',
            TW1_Valor__c = 1234567812345678.22,
            TW1_VGL_faturado__c = 1234567812345678.22,
            TW1_ABL_faturada__c = 1234567812345678.22,
            TW1_Comissao__c = 1234567812345678.22,
            TW1_Descricao_erro_integracao__c = 'Text Area(255)',
            TW1_Quantidade_de_propriedades__c = 1234567891,
            TW1_VGL_AMM__c = 1234567812345678.22,
            TW1_VGL_total__c = 1234567812345678.22,
            TW1_Etapa__c = 'Texto',
            TW1_Descricao_da_etapa__c = 'Texto',
            OwnerId = criaOwner('testAncar@test.com.br').Id //ownerId        
        );
        insert opportunity; 
        
        opportunity = [SELECT Id, Name, TW1_Cotacao_sincronizada__c, TW1_Data_inicio_de_vigencia__c, 
                       TW1_Data_fim_de_vigencia__c, StageName, CloseDate, TW1_Oportunidade_aprovada__c, 
                       RecordTypeId, TW1_Marca__c, TW1_Shopping__c, AccountId, OwnerId
                       FROM Opportunity
                       WHERE Id = :opportunity.Id];
        
        return opportunity;
    }
    
    public static Opportunity getMidiaUniqueOwnerMock(String ownerUniqueUsername, String cpf)
    {        
        List<RecordType> recordMidia = [SELECT Id FROM RecordType WHERE Name = :rec.rec_midia];
 
        //Criando uma oportunidade
        Opportunity opportunity = new Opportunity(                 
            Name = 'ApexTest Opportunity 1',
            TW1_Cotacao_sincronizada__c = null,
            TW1_Data_inicio_de_vigencia__c = Date.today().AddDays(9),
            TW1_Data_fim_de_vigencia__c = Date.today().AddDays(10),
            StageName = 'Em negociação',
            CloseDate = Date.today(),  
            TW1_Oportunidade_aprovada__c = true,
            RecordTypeId = recordMidia[0].Id, 
            TW1_Marca__c = criaMarca().Id,
            TW1_Shopping__c = criaShopping(ownerUniqueUsername.substring(0, 10)).Id,
            AccountId = criaCliente(cpf).Id,
            TW1_Id_VS__c = 'ID_Opp_VS',
            NextStep = 'Texto 255',
            Description = 'Long Text Area(32000)',
            Loss_Reason__c = 'Price',
            TW1_Prazo__c = 1234567891,
            TW1_Status__c = 'Quente',
            TW1_Valor__c = 1234567812345678.22,
            TW1_VGL_faturado__c = 1234567812345678.22,
            TW1_ABL_faturada__c = 1234567812345678.22,
            TW1_Comissao__c = 1234567812345678.22,
            TW1_Descricao_erro_integracao__c = 'Text Area(255)',
            TW1_Quantidade_de_propriedades__c = 1234567891,
            TW1_VGL_AMM__c = 1234567812345678.22,
            TW1_VGL_total__c = 1234567812345678.22,
            TW1_Etapa__c = 'Texto',
            TW1_Descricao_da_etapa__c = 'Texto',
            OwnerId = criaOwner(ownerUniqueUsername).Id        
        );
        insert opportunity; 
        
        opportunity = [SELECT Id, Name, TW1_Cotacao_sincronizada__c, TW1_Data_inicio_de_vigencia__c, 
                       TW1_Data_fim_de_vigencia__c, StageName, CloseDate, TW1_Oportunidade_aprovada__c, 
                       RecordTypeId, TW1_Marca__c, TW1_Shopping__c, AccountId, OwnerId
                       FROM Opportunity
                       WHERE Id = :opportunity.Id];
        
        return opportunity;
    }
}