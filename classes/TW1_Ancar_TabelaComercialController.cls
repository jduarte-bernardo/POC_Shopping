public with sharing class TW1_Ancar_TabelaComercialController {
    
    
    public boolean displayPesquisa {get;set;}
    public String valorPesquisaShopping {get;set;}
    public List<TW1_Shopping__c> listshoppings{get;set;}
    public string IdObjetoDisplay{get;set;}
    public String nomeDoshopping{get;set;}
    public List<TW1_Propriedade__c> listlucs{get;set;}
    public boolean displayTabela {get;set;}
    
    
    public TW1_Ancar_TabelaComercialController(){
        displayPesquisa = true;
        valorPesquisaShopping = '';
        getListaShoppings();
    }
    
    public void TelaInicio()
    {
        listlucs = new List<TW1_Propriedade__c>();
        displayTabela = false;
        IdObjetoDisplay ='';
        valorPesquisaShopping = '';
        displayPesquisa = true;
    }
    
    public void getLucsByShopping(){
        displayTabela = true;
        displayPesquisa = false;
        String idShopping = IdObjetoDisplay;
        
        listlucs = new List<TW1_Propriedade__c>();
        
        for(TW1_Propriedade__c luc : [
            SELECT
            Name,
            TW1_Piso__c,
            TW1_Status_da_prospecao__c,
            TW1_Status__c,
            TW1_area_m2__c,
            TW1_AMM__c,
            TW1_AMM_M2__c,
            TW1_Fundo__c,
            TW1_OTN__c,
            TW1_AMM_OTN__c,
            TW1_Valor_TR__c,
            TW1_Condominio__c,
            TW1_Nota_de_d_bito_ou_CTO__c,
            TW1_RES_m2__c,
            TW1_Res_Perata__c,
            TW1_IPTU__c,
            TW1_Observacao__c
            FROM TW1_Propriedade__c
            WHERE TW1_Shopping__c = :idShopping And
            RecordType.Name = 'Propriedade de loja'
            AND (TW1_Status__c = 'Vaga' OR TW1_Status__c = 'Repasse')
        ])
        {
            luc.TW1_IPTU__c = (luc.TW1_IPTU__c == null ? 0:luc.TW1_IPTU__c);
            luc.TW1_AMM__c = (luc.TW1_AMM__c == null ? 0:luc.TW1_AMM__c);
            luc.TW1_Condominio__c = (luc.TW1_Condominio__c == null ? 0:luc.TW1_Condominio__c);
            luc.TW1_Fundo__c = (luc.TW1_Fundo__c == null ? 0:luc.TW1_Fundo__c);
            luc.TW1_Nota_de_d_bito_ou_CTO__c = (luc.TW1_Nota_de_d_bito_ou_CTO__c == null ? 0:luc.TW1_Nota_de_d_bito_ou_CTO__c);
            luc.TW1_OTN__c = (luc.TW1_OTN__c == null ? 0:luc.TW1_OTN__c);
            luc.TW1_Valor_TR__c = (luc.TW1_Valor_TR__c == null ? 0:luc.TW1_Valor_TR__c);
            luc.TW1_Res_Perata__c = (luc.TW1_Res_Perata__c == null ? 0:luc.TW1_Res_Perata__c);

            listlucs.add(luc);
        }
    }
    
    public void getListaShoppings(){
        String strShopping = valorPesquisaShopping;
        
        List<TW1_Shopping__c> listaShoppings = new List<TW1_Shopping__c>();
        
        if(strShopping.length() <= 1){
            String strShoppingLike = '%' + strShopping + '%';
            listaShoppings = [SELECT Id, Name FROM TW1_Shopping__c WHERE Name LIKE :strShoppingLike];
        }else{
            List<List<SObject>> searchResult = [FIND :strShopping IN Name Fields RETURNING TW1_Shopping__c(Id, Name)];
            listaShoppings = searchResult[0];
        }
        
        listshoppings = listaShoppings;
    }
}