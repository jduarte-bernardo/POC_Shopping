@isTest
public class TW1_Ancar_Venda_InfHistProp_Rep_Test {
	
    @isTest
    public static void ListarInformacoesHistoricas_Test() {
      
        list<String> propriedades = new list<String>();
        propriedades.add('0000000011');
        propriedades.add('0000000012');
        propriedades.add('0000000013');

        TW1_Ancar_Venda_InfHistProp_Rep infoRep = new TW1_Ancar_Venda_InfHistProp_Rep();
        list<TW1_Propriedade__c> listadeProprieade = infoRep.ListarInformacoesHistoricas('', propriedades);
    	System.debug('saida de propriedade '+listadeProprieade);
        System.assert(listadeProprieade==null);
        
    }
    
    @isTest
    public static void ListarInformacoesHistoricas_Test2() {
     
        TW1_Shopping__c vaShopping = new TW1_Shopping__c();
        vaShopping.Name = 'Shopping Teste';
        vaShopping.TW1_SGL_Empreendimento__c='ST';
        insert vaShopping;
        
        TW1_Propriedade__c propriedade = new TW1_Propriedade__c (
            Name = 'ApexTest Propriedade 1',
            TW1_Status__c = 'Vaga',
            TW1_Shopping__c = vaShopping.Id          
        );
        insert propriedade;
        
        TW1_Propriedade__c propriedade2 = new TW1_Propriedade__c (
            Name = 'ApexTest Propriedade 2',
            TW1_Status__c = 'Vaga',
            TW1_Shopping__c = vaShopping.Id          
        );
        insert propriedade2;
        
        list<String> propriedades = new list<String>();
        propriedades.add(propriedade.Id);
        propriedades.add(propriedade2.Id);
        
        TW1_Ancar_Venda_InfHistProp_Rep infoRep = new TW1_Ancar_Venda_InfHistProp_Rep();
        list<TW1_Propriedade__c> listadeProprieade = infoRep.ListarInformacoesHistoricas('', propriedades);
    	System.debug('saida de propriedade '+listadeProprieade);
        System.assert(listadeProprieade!=null);
        
    }
    @isTest
    public static void ListarInformacoesHistoricas_Test3() {
        
        TW1_Ancar_Venda_InfHistProp_Rep infoRep = new TW1_Ancar_Venda_InfHistProp_Rep();
        list<TW1_Propriedade__c> listadeProprieade = infoRep.ListarInformacoesHistoricas('', null);
        
    }    
        
}