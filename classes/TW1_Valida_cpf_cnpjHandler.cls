public with sharing class TW1_Valida_cpf_cnpjHandler implements ITrigger{
    
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    // Construtor
    public TW1_Valida_cpf_cnpjHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void bulkBefore()
    {
        
    }
    
    public void bulkAfter()
    {
    }
    
    public void beforeInsert(SObject so)
    {	
        Account acc = (Account)so;
        validaCpfCnpj(acc);
        verificarSeexiste(acc);
        validaPhone(acc);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        Account oldacc = (Account)oldSo;
        Account newacc = (Account)so;
        validaCpfCnpj(newacc);
        if((newacc.TW1_CPF__c != null && vaReplace(newacc.TW1_CPF__c) != vaReplace(oldacc.TW1_CPF__c)) || (newacc.TW1_CNPJ__c != null && newacc.TW1_CNPJ__c != oldacc.TW1_CNPJ__c)){
            verificarSeexiste(newacc);
        }
        validaPhone(newacc);

    }
    
    public void beforeDelete(SObject so)
    {	
        
    }
    
    public void afterInsert(SObject so)
    {	
        
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        
    }
    
    public void afterDelete(SObject so)
    {
    }
    
    public void OnUndelete(SObject restoredSObject){
    }
    
    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    }
    
    public boolean IsVisualforcePageContext{
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsWebServiceContext{
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsExecuteAnonymousContext{
        get{ return !IsTriggerContext;}
    }
    
    public void andFinally()
    {
        
    }
    
    //Métodos de apoio a trigger
    
    public static void validaCpfCnpj(Account acct){
        
        if(acct.TW1_CPF__c != null){
            //acct.TW1_CPF__c.addError('O campo CPF obrigatório.');
            //}else{ 
            //if( validaCPF(acct.TW1_CPF__c.replace('.','').replace('-','')) ){
            if( validaCPF(acct.TW1_CPF__c) ){
                //acct.TW1_CPF__c = imprimeCPF(acct.TW1_CPF__c.replace('.','').replace('-',''));
                acct.TW1_CPF__c = acct.TW1_CPF__c;
            }else{
                acct.TW1_CPF__c.addError('O CPF está inválido.');  
            }
        }
        
        if(acct.TW1_CNPJ__c != null){
            //acct.TW1_CNPJ__c.addError('O campo CNPJ obrigatório.');
            //}else{
            //if( validaCNPJ(acct.TW1_CNPJ__c.replace('.','').replace('/','').replace('-','')) ){
            if( validaCNPJ(acct.TW1_CNPJ__c) ){
                //acct.TW1_CNPJ__c = imprimeCNPJ(acct.TW1_CNPJ__c.replace('.','').replace('/','').replace('-',''));
                acct.TW1_CNPJ__c = acct.TW1_CNPJ__c;
            }else{    
                acct.TW1_CNPJ__c.addError('O CNPJ está inválido.');  
            }
        }   
    }
    
    public static boolean validaCPF(String CPF) {
        System.debug(''+cpf);
        if (CPF.equals('00000000000') || CPF.equals('11111111111') ||
            CPF.equals('22222222222') || CPF.equals('33333333333') ||
            CPF.equals('44444444444') || CPF.equals('55555555555') ||
            CPF.equals('66666666666') || CPF.equals('77777777777') ||
            CPF.equals('88888888888') || CPF.equals('99999999999') ||
            (CPF.length() != 11))
            return(false);
        
        Integer dig10, dig11, sm, i, r, num, peso;
        sm = 0;
        peso = 10;
        List<String> cpfString = cpf.split('');
        for (i=0; i<9; i++) {
            num = Integer.valueOf(cpfString[i]); 
            sm = sm + (num * peso);
            peso = peso - 1;
        }
        
        r = 11 - (math.mod(sm,11));
        if ((r == 10) || (r == 11)){
            dig10 = 0;
        }else{ 
            dig10 = r;
        }
        
        // Calculo do 2o. Digito Verificador
        sm = 0;
        peso = 11;
        for(i=0; i<10; i++) {
            num = Integer.valueOf(cpfString[i]);
            sm = sm + (num * peso);
            peso = peso - 1;
        }
        
        r = 11 - (math.mod(sm,11));
        if ((r == 10) || (r == 11)){
            dig11 = 0;
        }else{ 
            dig11 = r;    
        }       
        
        // Verifica se os digitos calculados conferem com os digitos informados.
        if (dig10 == Integer.valueOf(cpfString[9]) && dig11 == Integer.ValueOf(cpfString[10])){
            return true;
        }else{
            return false;
        }
    }
    /* 
    public static String imprimeCPF(String CPF) {
        return(CPF.substring(0, 3) + '.' + CPF.substring(3, 6) + '.' +
               CPF.substring(6, 9) + '-' + CPF.substring(9, 11));
    }*/
    
    public static boolean validaCNPJ(String CNPJ) {
        // considera-se erro CNPJ's formados por uma sequencia de numeros iguais
        if (CNPJ.equals('00000000000000') || CNPJ.equals('11111111111111') ||
            CNPJ.equals('22222222222222') || CNPJ.equals('33333333333333') ||
            CNPJ.equals('44444444444444') || CNPJ.equals('55555555555555') ||
            CNPJ.equals('66666666666666') || CNPJ.equals('77777777777777') ||
            CNPJ.equals('88888888888888') || CNPJ.equals('99999999999999') ||
            (CNPJ.length() != 14))
            return false;
        
        Integer sm, i, r, num, peso, dig13, dig14;
        List<String> cnpjString = CNPJ.split('');
        sm = 0;
        peso = 2;
        for (i=11; i>=0; i--) {
            num = Integer.valueOf(cnpjString[i]);
            sm = sm + (num * peso);
            peso = peso + 1;
            if (peso == 10){
                peso = 2;
            }    
        }
        
        r = math.mod(sm, 11);
        if ((r == 0) || (r == 1)){
            dig13 = 0;
        }else{
            dig13 = Integer.valueOf(11-r);
        }
        
        // Calculo do 2o. Digito Verificador
        sm = 0;
        peso = 2;
        for (i=12; i>=0; i--) {
            num = Integer.valueOf(cnpjString[i]);
            sm = sm + (num * peso);
            peso = peso + 1;
            if (peso == 10){
                peso = 2;
            }    
        }
        
        r = math.mod(sm, 11);
        if ((r == 0) || (r == 1)){
            dig14 = 0;
        }else{
            dig14 = Integer.valueOf(11-r);
        }
        
        // Verifica se os dígitos calculados conferem com os dígitos informados.
        if (dig13 == Integer.valueOf(cnpjString[12]) && dig14 == Integer.valueOf(cnpjString[13])){
            return true;
        }else{
            return false;
        }
    }
    /*
    public static String imprimeCNPJ(String CNPJ) {
        return(CNPJ.substring(0, 2) + '.' + CNPJ.substring(2, 5) + '.' +
               CNPJ.substring(5, 8) + '/' + CNPJ.substring(8, 12) + '-' +
               CNPJ.substring(12, 14));
    }
    */
    public static Boolean verificarSeexiste(Account acct){
        String cpf = '';
        String cnpj = '';

        if(acct.TW1_CNPJ__c!=null || acct.TW1_CPF__c!=null){
            
            if(acct.TW1_CPF__c!=null){
                //cpf = acct.TW1_CPF__c.replace('.','').replace('-','');
                cpf = acct.TW1_CPF__c;
            }else{
                //cnpj = acct.TW1_CNPJ__c.replace('.','').replace('/','').replace('-','');
                cnpj = acct.TW1_CNPJ__c;
            }
            
            List<Account> vaAccount = [SELECT TW1_CPF__c, TW1_CNPJ__c  FROM Account  where ((TW1_CPF__c=:cpf and TW1_CPF__c != '') OR (TW1_CNPJ__c =:cnpj AND TW1_CNPJ__c != '' )) AND (recordType.Name='Conta pessoal padrão' OR recordType.Name='Loja' OR recordType.Name='Contato comercial PF' OR recordType.Name='Contato comercial PJ') Limit 2];        
            if(vaAccount.size() >= 1){
                if(vaAccount[0].TW1_CPF__c!=null){
                    acct.TW1_CPF__c.addError('CPF já existe.');
                }else{
                    acct.TW1_CNPJ__c.addError('CNPJ já existe.');
                }
                return false;
            }else{
                return true;
            }
            
        }else{
            return true;
        }

    }
    public String vaReplace(String campo){
		string stReplace = campo.replace('.','');
        stReplace = stReplace.replace('-','');
        stReplace = stReplace.replace('/','');
        //return campo.replace('.','').replace('-','');
        return stReplace;
    }
	
    public static void validaPhone(Account acc){
        /*if((acc.Phone).isNumeric()){
 			acc.Phone=(acc.Phone).replaceAll('\\D', '');
        }else{ 
            acc.Phone.addError('Este campo só deve conter números.');  
        }
        if((acc.PersonMobilePhone).isNumeric()){
            acc.PersonMobilePhone=(acc.PersonMobilePhone).replaceAll('\\D', '');
        }else{
            acc.PersonMobilePhone.addError('Este campo só deve conter números.');  
        }*/
        //acc.Phone=(acc.Phone).replaceAll('\\D', '');
        //acc.PersonMobilePhone=(acc.PersonMobilePhone).replaceAll('\\D', '');
    }
    
}