@isTest
public class TW1_Ancar_TabelaComercial_tst {
  @isTest
    static void TestgetLucsByShopping(){
        Test.startTest();
        	
        	recordtype rt = [Select Id,Name from recordtype where Name='Propriedade de loja'];
        
        	TW1_Shopping__c shopping = new TW1_Shopping__c(Name='Teste Shopping 2',TW1_SGL_Empreendimento__c = 'BPS');
        	insert shopping;
        
        	TW1_Propriedade__c propriedade = new TW1_Propriedade__c();
        	propriedade.Name = '1';
        	propriedade.TW1_Shopping__c = shopping.Id;
        	propriedade.RecordTypeId = rt.Id;
        	propriedade.TW1_Status__c = 'Vaga';
        	insert propriedade;
        
        	TW1_Ancar_TabelaComercialController tabelaComercial = new TW1_Ancar_TabelaComercialController();
        	tabelaComercial.displayPesquisa = true;
        	tabelaComercial.displayTabela = true;
            tabelaComercial.valorPesquisaShopping = shopping.Name;
        	tabelaComercial.IdObjetoDisplay = shopping.Id; 
        
        	tabelaComercial.getLucsByShopping();
        	tabelaComercial.TelaInicio();
        	tabelaComercial.getListaShoppings();

        Test.stopTest();
    }
      @isTest
    static void TestgetLucsByShoppingSoSL(){
        Test.startTest();
        	
        	recordtype rt = [Select Id,Name from recordtype where Name='Propriedade de loja'];
        	
        	TW1_Shopping__c shopping = new TW1_Shopping__c(Name='Teste Shopping 2',TW1_SGL_Empreendimento__c = 'BPS');
        	insert shopping;
        
        	TW1_Propriedade__c propriedade = new TW1_Propriedade__c();
        	propriedade.Name = '1';
        	propriedade.TW1_Shopping__c = shopping.Id;
        	propriedade.RecordTypeId = rt.Id;
        	propriedade.TW1_Status__c = 'Vaga';
        	insert propriedade;
        
        	TW1_Ancar_TabelaComercialController tabelaComercial = new TW1_Ancar_TabelaComercialController();
        	tabelaComercial.displayPesquisa = true;
        	tabelaComercial.displayTabela = true;
            tabelaComercial.valorPesquisaShopping = 'gcsacsacsacf';
        	tabelaComercial.IdObjetoDisplay = shopping.Id; 
        
        	tabelaComercial.getLucsByShopping();
        	tabelaComercial.TelaInicio();
        	tabelaComercial.valorPesquisaShopping = 'gfscszczsc';
        	tabelaComercial.getListaShoppings();

        Test.stopTest();
    }
    
    @isTest
    static void TestgetLucsByShopping2(){
        Test.startTest();

        	TW1_Ancar_TabelaComercialController tabelaComercial = new TW1_Ancar_TabelaComercialController();
        	tabelaComercial.displayPesquisa = false;
        	tabelaComercial.displayTabela = false;
            tabelaComercial.valorPesquisaShopping = '';
        	tabelaComercial.nomeDoshopping = '';
        	tabelaComercial.IdObjetoDisplay = ''; 
        
        	tabelaComercial.getLucsByShopping();
        	tabelaComercial.TelaInicio();
			tabelaComercial.getListaShoppings();

        Test.stopTest();
    }
    
}