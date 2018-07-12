/******************************************************************************************************
Author  	: Leonardo Façanha
Date    	: 22/11/2017
Atualizada 	: 15/12/2017 - Wellingto N. Rodrigues
Purpose 	: Api Rest para buscar informações do cliente para a aplicação de promoção
*******************************************************************************************************/
@RestResource(urlMapping='/Cliente/*')
global with sharing class ClienteManager {
    
    @HttpGet
    global static List<Cliente> getClientePorId(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<Cliente> listaClientes = new List<Cliente>();
        
        recordtype rtAcc = [Select Id,Name From recordtype where Name='Conta pessoal padrão' Limit 1];
        recordtype rtCont = [Select Id,Name From recordtype where Name='Cadastro de Funcionário' Limit 1];
        recordtype rtContrecord = [Select Id,Name From recordtype where Name='Loja' Limit 1];
        
        
        System.debug('Conta pessoal padrão: ' + rtAcc.Id);
        System.debug('Cadastro de Funcionário: ' + rtCont.Id);

        String Id = req.params.get('Id');
        String IdPromocao = req.params.get('IdPromocao');
        System.debug('Id: '+Id);
        System.debug('IdPromocao: '+IdPromocao);
        
        If(Id != null && Id != '' && Id != 'null'){
            
            try{
                
                List<Account> listaClientePorId =
                    [ 
                        SELECT 
                        Id,
                        
                        FirstName,
                        LastName,
                        TW1_Av_Rua__c,
                        TW1_Numero__c,
                        TW1_Bairro__c,
                        CEP__c,
                        TW1_Complemento__c,
                        TW1_Estado_civil__c,
                        TW1_Sexo__c,
                        TW1_Cidade__c,
                        TW1_UF__c,
                        TW1_CPF__c,
                        TW1_Identidade__c,
                        PersonEmail,
                        TW1_Permite_SMS__c,
                        TW1_Data_Nascimento__c,
                        DDD__c,
                        TW1_DDI__c,
                        Phone,
                        TW1_EmailCB__c,
                        TW1_TelefoneCB__c,
                        LastModifiedDate,
                        TW1_Correspondencia__c,
                        recordtypeId
                        FROM Account 
                        WHERE 
                        Id=:Id LIMIT 1
                    ];
                return MapCliente(listaClientePorId,IdPromocao);
                
            }catch(exception e){
                return new List<Cliente>();
            }
        }
        else{
            
            String nome = req.params.get('nome');
            Boolean Espaco = nome.contains('-');
            
            String Sobrenome = req.params.get('sobrenome');
            Boolean EspacoSobrenome = Sobrenome.contains('-');
            
            System.debug('nome: '+nome);
            
		If(EspacoSobrenome)
        Sobrenome = Sobrenome.replace('-', ' ');
            System.debug('sobrenome:' +Sobrenome);
        If(Espaco)
        nome = nome.replace('-', ' ');

        String cpf = req.params.get('cpf');
                  
             System.debug('cpf: '+cpf);
            
            if(nome == '' && Sobrenome == '' && cpf == ''){
                return listaClientes;
            }
            else{
                List<Account> listaAccount;
                List<Contact> listaContact;
                
                
                //SELECT Id,FirstName,LastName,Name,recordtypeId FROM Account WHERE recordtypeId='0121I0000006xf9QAA' And ((FirstName LIKE 'Pedro%') And (LastName LIKE '%Silva%')) Order by LastName Asc
                
                
                    String strQuery = 'SELECT Id,LastModifiedDate,FirstName,LastName,TW1_Av_Rua__c,TW1_Numero__c,TW1_Bairro__c,CEP__c,TW1_Complemento__c,TW1_Estado_civil__c,TW1_Sexo__c,TW1_Cidade__c,TW1_UF__c,TW1_CPF__c,TW1_Identidade__c,PersonEmail,TW1_Permite_SMS__c,TW1_Data_Nascimento__c,DDD__c,TW1_DDI__c,Phone,TW1_EmailCB__c,TW1_TelefoneCB__c,TW1_Correspondencia__c,Name,recordtypeId FROM Account '; 
                	 strQuery += 'WHERE recordtypeId=' + '\'' + rtAcc.Id + '\'';
                
                If((nome != null && nome != '') || (Sobrenome != null && Sobrenome != '') ){
                    strQuery += ' And ((FirstName LIKE ' + '\'' + nome + '%\''+ ') And (LastName LIKE ' + '\'%' + Sobrenome + '%\'' + ')) Order by LastName Asc limit 51';}
					else{
                    strQuery += ' And (TW1_CPF__c !=' + '\'' + '\'' + ' And TW1_CPF__c=' + '\'' + cpf + '\'' + ')';}
                
                 System.debug('Query Account: '+strQuery);
                listaAccount = Database.query(strQuery);
                
                 system.debug('lista Account :' +listaAccount);
                
                    String sstrQuery = 'SELECT Id, Name,FirstName,LastName,TW1_CPF__c,AccountId,Account.recordtypeId,recordtypeId FROM Contact ';
                 	sstrQuery += 'WHERE (recordtypeId=' + '\'' + rtCont.Id + '\'' + 'OR recordtypeId='+ '\''+'\''+') And '; 
                	sstrQuery += '(Account.recordtypeId='+ '\'' + rtContrecord.Id + '\'' + ')';
                    
                If((nome != null && nome != '') || (Sobrenome != null && Sobrenome != '')){
                    sstrQuery += ' And ((FirstName LIKE ' + '\'' + nome + '%\''+ ') And (LastName LIKE ' + '\'%' + Sobrenome + '%\'' + ')) Order by LastName Asc ';}
                else{
                        sstrQuery += ' And (TW1_CPF__c !=' + '\'' + '\'' + ' And TW1_CPF__c=' + '\'' + cpf + '\'' + ')';}
                
					System.debug('Query Contact: '+sstrQuery);
                
                  listaContact = Database.query(sstrQuery);
                
                if(listaContact.size() > 50 || listaAccount.size() > 50){
                    List<Cliente> listcliente = new List<Cliente>();
                    Cliente cli = new Cliente();
                    cli.MesagemErro='A consulta retornou mais de 50 registros, refaça sua consulta!';
                    listcliente.add(cli);
                    return listcliente;
                }else{
       				system.debug('lista Contact :' +listaContact);
                
                listaClientes.addAll(MapCliente(listaAccount,IdPromocao));
                listaClientes.addAll(MapCliente(listaContact,IdPromocao));
                }
            }        
            return listaClientes;
        }
    }
    
    @HttpPost
    global static string UpsertCliente(requestWrapper RequestWrapper){
        try{          
            recordtype rtAcc = [Select Id,Name From recordtype where Name='Conta pessoal padrão' Limit 1];
            RequestWrapper.cliente.recordtypeId = rtAcc.Id;
            Account account = MapAccount(RequestWrapper.cliente);
            System.debug(account.ID);
            if(account.Id != null){
                update account; 
                return account.Id;
            }else{
                account.TW1_Origem__c = 'Promoção';
                insert account;
                return account.Id;
            }
        } catch (Exception ce) {
            return 'Erro: '+ ce.getMessage();
        }  
    }
    
    global class requestWrapper
    {
        public Cliente cliente;
    }
    
    global class Cliente 
    {
        public string Id;
        public string Name;
        public string Sobrenome;
        public string Av_Rua;
        public decimal Numero;
        public string Bairro;
        public decimal CEP;
        public string Complemento;
        public string Estado_civil;
        public string Sexo;
        public string Cidade;
        public string UF_de_emissao;
        public string CPF;
        public string Identidade;
        public string Email;
        public Boolean Permite_SMS;
        public date Data_Nascimento;
        public decimal DDD;
        public decimal DDI;
        public string Phone;
        public Boolean EmailCB;
        public Boolean TelefoneCB;
        public Boolean Correspondencia;
        public Boolean contato;
        public string LojaId;
        public string LojaName;
        public string recordtypeId;
        public Boolean BlackList;
        public Boolean Erro;
        public String MesagemErro; 
        public DateTime DataModificacao;
        
    }
    
    Private static Account MapAccount(Cliente cliente){
        Account account = new Account();
        
        account.Id = cliente.Id;
        account.FirstName = cliente.Name;
        account.LastName = cliente.Sobrenome;
        account.TW1_Av_Rua__c = cliente.Av_Rua;
        account.TW1_Numero__c = cliente.Numero;
        account.TW1_Bairro__c = cliente.Bairro;
        account.CEP__c = cliente.CEP;
        account.TW1_Complemento__c = cliente.Complemento;
        account.TW1_Estado_civil__c = cliente.Estado_civil;
        account.TW1_Sexo__c = cliente.Sexo;
        account.TW1_Cidade__c = cliente.Cidade;
        account.TW1_UF__c = cliente.UF_de_emissao;
        account.TW1_CPF__c = cliente.CPF;
        account.TW1_Identidade__c = cliente.Identidade;
        account.PersonEmail = cliente.Email;
        if(cliente.Permite_SMS == null)
            cliente.Permite_SMS = false;
        
        account.TW1_Permite_SMS__c = cliente.Permite_SMS;
        account.TW1_Data_Nascimento__c = cliente.Data_Nascimento;
        account.DDD__c = cliente.DDD;
        account.TW1_DDI__c = cliente.DDI;
        account.Phone = cliente.Phone;
        if(cliente.TelefoneCB == null)
            cliente.TelefoneCB = false;
        
        account.TW1_TelefoneCB__c = cliente.TelefoneCB;
       
        if(cliente.EmailCB == null)
            cliente.EmailCB = false;
        
        account.TW1_EmailCB__c = cliente.EmailCB;
        
        if(cliente.Correspondencia == null)
            cliente.Correspondencia = false;
        
        account.TW1_Correspondencia__c = cliente.Correspondencia;
        account.RecordTypeId = cliente.recordtypeId;
        
        return account;
    } 
    
    Private static List<Cliente> MapCliente(List<Account> listaccount,string IdPromocao){
        
        List<Cliente> listCliente = new List<Cliente>();
        
        Set<string> Cpfs = new Set<string>();
        Set<Id> ListBacklist = new Set<Id>();
        
        for(Account item :listaccount){
            Cpfs.add(item.Id);
        }
        System.debug('MAPAccount - Cpfs: '+Cpfs);
        
        List<TW1_Black_List__c> BlackList = [SELECT Id,TW1_Contato__c From TW1_Black_List__c where TW1_Promocao__c=:IdPromocao And TW1_Contato__c In:Cpfs];
         
        System.debug('MAPAccount - BlackList: '+BlackList);
        
        for(TW1_Black_List__c item:BlackList){
            ListBacklist.add(item.TW1_Contato__c);
        }
        
        for(Account account :listaccount){
            
            Cliente cliente = new Cliente();
            
           
             
            cliente.Id = account.Id; cliente.DataModificacao = account.LastModifiedDate; cliente.Name = account.FirstName;cliente.Sobrenome = account.LastName;cliente.Av_Rua = account.TW1_Av_Rua__c;cliente.Numero = account.TW1_Numero__c;cliente.Bairro = account.TW1_Bairro__c;cliente.CEP = account.CEP__c;cliente.Complemento = account.TW1_Complemento__c;cliente.Estado_civil = account.TW1_Estado_civil__c;cliente.Sexo = account.TW1_Sexo__c;cliente.Cidade = account.TW1_Cidade__c; cliente.UF_de_emissao = account.TW1_UF__c;cliente.CPF = account.TW1_CPF__c;cliente.Identidade = account.TW1_Identidade__c;cliente.Email = account.PersonEmail;cliente.Permite_SMS = account.TW1_Permite_SMS__c;cliente.Data_Nascimento = account.TW1_Data_Nascimento__c; cliente.DDD = account.DDD__c ;cliente.DDI = account.TW1_DDI__c; cliente.Phone = account.Phone;cliente.EmailCB = account.TW1_EmailCB__c; cliente.TelefoneCB = account.TW1_TelefoneCB__c;Cliente.contato = False;Cliente.BlackList = ListBacklist.contains(account.Id); cliente.Correspondencia = account.TW1_Correspondencia__c; cliente.recordtypeId = account.RecordTypeId;
            
            listCliente.add(cliente);
        }
        System.debug('MAPAccount - listCliente: '+listCliente);
        return listCliente;
    } 
    
    Private static List<Cliente> MapCliente(List<Contact> listcontact,string IdPromocao){
        
        List<Cliente> listCliente = new List<Cliente>();
        Set<Id> Idslojas = new Set<Id>();
        Set<string> Cpfs = new Set<string>();
        Set<string> ListBacklist = new Set<string>();
        
        for(Contact item :listcontact){
            Idslojas.add(item.AccountId);
            Cpfs.add(item.Id);
        }
        System.debug('MAPcontact - Cpfs.Id: '+Cpfs);
        System.debug('MAPcontact - listCliente: '+Idslojas);
        
        List<TW1_Black_List__c> BlackList = [SELECT Id,TW1_Contato__c From TW1_Black_List__c where TW1_Promocao__c=:IdPromocao And TW1_Contato__c In:Cpfs ];
      
        System.debug('MAPcontact - BlackList: '+BlackList);
        
        List<Account> listAcc = [SELECT Id,Name From Account Where Id In:Idslojas];
        Map<Id,Account> loja = new Map<Id,Account>(listAcc);
        
        for(TW1_Black_List__c item:BlackList){
            ListBacklist.add(item.TW1_Contato__c);
        }
        
        for(Contact contact : listcontact){
            
            Cliente cliente = new Cliente();
            Account lojaCorrente = loja.get(contact.AccountId);
            
            cliente.Id = contact.Id;
            cliente.Name = contact.Name;
            //cliente.Name = contact.FirstName;
            //cliente.Sobrenome = contact.LastName;
            cliente.CPF = contact.TW1_CPF__c;
            Cliente.LojaId = contact.AccountId;
            Cliente.LojaName = lojaCorrente.Name;
            Cliente.contato = true;
            Cliente.BlackList = ListBacklist.contains(contact.Id);
            cliente.recordtypeId = contact.RecordTypeId;
            
            listCliente.add(cliente);
        }
        
        return listCliente;
    } 
}