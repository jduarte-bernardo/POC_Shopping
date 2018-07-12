/******************************************************************************************************
Author  	: Wellington Rodrigues
Date    	: 16/01/2018
Purpose 	: Api Rest para buscar informações do Cordenador para a aplicação de promoção
*******************************************************************************************************/
@RestResource(urlMapping='/Cordenador/*')
global with sharing class CordenadorManager {
    
    @HttpGet
    global static List<TW1_Operador__c> getCordenadorPorShopping(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        List<TW1_Operador__c> listaCordenadorPorShopping = new List<TW1_Operador__c>();
        
        String vaIdShopping = req.params.get('IdShopping');
            String vaIdOperador= req.params.get('IdOperador');
        String vaSenha = req.params.get('SenhaOperaodor');
        
        If(vaIdShopping != null && vaIdShopping != '' && vaIdShopping != 'null'){
            
            try{
                listaCordenadorPorShopping = [
                    select 
                    id,
                    name,
                    TW1_Shopping__c
                    from 
                    TW1_Operador__c
                    where TW1_Tipo__c='Coordenador' and TW1_Shopping__c=:vaIdShopping
                ];  
                return listaCordenadorPorShopping; 
                
            }catch(exception e){return null;}}
        
        If(vaIdOperador != null && vaIdOperador != '' && vaIdOperador != 'null' || vaSenha != null && vaSenha != '' && vaSenha != 'null'){
            
            try{
                listaCordenadorPorShopping = [
                    select 
                    id,
                    name,
                    TW1_Shopping__c,
                    TW1_Senha__c
                    from 
                    TW1_Operador__c
                    where id=:vaIdOperador and TW1_Senha__c=:vaSenha limit 1
                ];  
                return listaCordenadorPorShopping; 
                
            }catch(exception e){return null;}
        }

        return listaCordenadorPorShopping;
    }
    
}