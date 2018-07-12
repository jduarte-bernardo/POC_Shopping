/******************************************************************************************************
Author  : Leonardo Façanha
Date    : 05/12/2017
Update	: 27/12/2017 por Wellington Rodrigues - linha:[23,25]
Purpose : Api Rest para buscar informações do Usuario para a aplicação de promoção
*******************************************************************************************************/
@RestResource(urlMapping='/Login')
global with sharing class LoginManager {
    
    @HttpPost
    global static List<string> doLogin(string login,string senha,string shopping){
        
        List<String> arrayOfoperdaor = new List<String>();
        
        if(login == '' || senha == '' || shopping == ''){
            arrayOfoperdaor.add('Erro - Campos em branco');
            return arrayOfoperdaor;
        }
        
        try{

            date vaData = DateTime.now().date();  
            TW1_Operador__c operador = [Select Id,Name,TW1_Email__c,TW1_Empresa__c,TW1_Nome_do_Usuario__c,TW1_Shopping__c,TW1_Tipo__c From TW1_Operador__c Where TW1_Tipo__c!='Coordenador' And TW1_Email__c=:login And TW1_Senha__c=:senha And TW1_Shopping__c=:shopping limit 1];
            
            TW1_Parametros_Promocao__c promocao = [Select Id,Name,TW1_Imprimir_nome_do_lojista__c,TW1_CampoVendedor__c,TW1_Troca_por__c,TW1_Acumula_Saldo__c,TW1_Contabiliza_Bonus__c,TW1_Formas_de_Pagamento__c,TW1_Concurso_Cultural__c,CreatedDate from TW1_Parametros_Promocao__c where TW1_Shopping__c=:operador.TW1_Shopping__c And TW1_Data_Fim__c >=:vaData Order By CreatedDate Desc limit 1];
           
            List<TW1_Caixa__c> vaCaixa = [select Id,TW1_CxFechado__c From TW1_Caixa__c where CreatedDate>=:vaData And TW1_Operador__c=:operador.id];
            
            if(operador != null || Shopping != null){
                
                If(promocao!=null){
                    arrayOfoperdaor.add(operador.Id);
                    arrayOfoperdaor.add(operador.Name);
                    arrayOfoperdaor.add(operador.TW1_Email__c);
                    arrayOfoperdaor.add(operador.TW1_Empresa__c);
                    arrayOfoperdaor.add(operador.TW1_Tipo__c);
                    arrayOfoperdaor.add(operador.TW1_Shopping__c);
                    arrayOfoperdaor.add(operador.TW1_Nome_do_Usuario__c);
                    arrayOfoperdaor.add(promocao.Id);
                    arrayOfoperdaor.add(promocao.TW1_Troca_por__c);
                    arrayOfoperdaor.add(promocao.TW1_Formas_de_Pagamento__c);
                    arrayOfoperdaor.add(promocao.TW1_Concurso_Cultural__c);
                    arrayOfoperdaor.add(String.valueOf(promocao.TW1_Contabiliza_Bonus__c));
                    arrayOfoperdaor.add(String.valueOf(promocao.TW1_Acumula_Saldo__c));
                    if(vaCaixa.size() >= 1){
                    if(!vaCaixa.get(0).TW1_CxFechado__c){
                        arrayOfoperdaor.add('CaixaAberto');
                    }
                    else {
                        arrayOfoperdaor.add('CaixaFechado');
                    }
                    }else {
                        arrayOfoperdaor.add('CaixaFechado');
                    }
                    arrayOfoperdaor.add('Aberto com Sucesso');
                    arrayOfoperdaor.add(promocao.Name);
                    arrayOfoperdaor.add(String.valueOf(promocao.TW1_CampoVendedor__c));
                    arrayOfoperdaor.add(String.valueOf(promocao.TW1_Imprimir_nome_do_lojista__c));
                }else{
                    arrayOfoperdaor.add('Não existe promoção para este shopping');
                    return arrayOfoperdaor;
                }
                
                return arrayOfoperdaor;
            }           
            
        }Catch(Exception err){
            arrayOfoperdaor.add('Erro no login - Verifique seu usuário e senha ou se o shopping tem promoção vigente!');
            return arrayOfoperdaor;
        }

        return arrayOfoperdaor;
    }
}