@isTest
public class ValidacaoCpfCnpjAnnotation_test {
	
    @isTest static void test_ValidacaoCpfCnpjAnnotation_CPF(){
        
        Account acct = new Account();
        acct.Name='Test de validação cpf e cnpj';
        acct.TW1_CPF__c='74745710569';
        acct.TW1_CNPJ__c='27364928000101';
        insert acct;

        list<String> vaact = new list<String>();
        vaact.add('95707321055');
        vaact.add('94683228076');
        vaact.add('31411762053');
        
        Test.startTest();
        	list<String> cpf = ValidacaoCpfCnpjAnnotation.validar_cpf_cnpj(vaact);
        	System.debug('valido'+cpf);
        	System.assertEquals('valido', cpf.get(0));
        Test.stopTest();

    }
    @isTest static void test_ValidacaoCpfCnpjAnnotation01_CNPJ(){
        
        Account acct = new Account();
        acct.Name='Test de validação cpf e cnpj';
        acct.TW1_CPF__c='74745710569';
        acct.TW1_CNPJ__c='89911379000103';
        insert acct;
		
        
        list<String> vaact = new list<String>();
        vaact.add('39945925000140');
        vaact.add('47055177000159');
        vaact.add('89911379000103');
        
        Test.startTest();
        	list<String> cpf = ValidacaoCpfCnpjAnnotation.validar_cpf_cnpj(vaact);
        	System.debug('valido'+cpf);
        	System.assertEquals('valido', cpf.get(0));
        Test.stopTest();

    }
   	@isTest static void test_ValidacaoCpfCnpjAnnotation01_CNPJ_Util(){

        list<String> haystack = new list<String>();
        haystack.add('200');
        haystack.add('300');
        haystack.add('400');
        
        Test.startTest();
        	Util.getClosestString('200',haystack);
        	Util.levenshtein('2','3');
        Test.stopTest();

    }
    
}