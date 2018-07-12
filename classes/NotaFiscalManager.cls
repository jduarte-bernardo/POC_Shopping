/******************************************************************************************************
Author  	: Leonardo Façanha
Date    	: 22/11/2017
Purpose 	: Api Rest para buscar informações do NotaFiscal para a aplicação de promoção
*******************************************************************************************************/
@RestResource(urlMapping='/NotaFiscal/*')
global with sharing class NotaFiscalManager {
    
    @HttpGet
    global static List<NTFS__c> getNotaFiscalPorId(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<NTFS__c> listaNTFSPorId = new List<NTFS__c>();

        String NTFSId = req.params.get('Id');
        string NumeroNTFS = req.params.get('NumeroNTFS');
        string IdCliente = req.params.get('IdCliente');
        string IdPromocao = req.params.get('IdPromocao');
        
        If(NTFSId != null && NTFSId != '' && NTFSId != 'null'){
            
            try{
                
                listaNTFSPorId = 
                    [ 
                        SELECT Id,
                        Name,
                        TW1_Cliente__c,
                        TW1_Data_da_Nota__c,
                        TW1_Forma_de_pagamento__c,
                        TW1_Loja__c,
                        TW1_Valor_RS__c 
                        FROM NTFS__c 
                        WHERE Id=:NTFSId LIMIT 1
                    ];
                
                return listaNTFSPorId; 
                
            }catch(exception e){return null;}  
        }
        
        If((IdPromocao != null && IdPromocao != '' && IdPromocao != 'null') && ( NumeroNTFS != null && NumeroNTFS != '' && NumeroNTFS != 'null') && (IdCliente != null && IdCliente != '' && IdCliente != 'null')){
            try{
                
                list<NTFS__c> listaNTFS =
                    [ 
                        SELECT Id,
                        Name,
                        TW1_Cliente__r.Name,
                        TW1_Data_da_Nota__c,
                        TW1_Forma_de_pagamento__c,
                        TW1_Loja__r.Name,
                        TW1_Valor_RS__c 
                        FROM NTFS__c
                        WHERE TW1_Promocao__c=:IdPromocao and TW1_Cliente__c=:IdCliente and Name Like:'%'+NumeroNTFS+'%'
                    ];
                                
                return listaNTFS; 

            }catch(exception e){return null;}  
        }else{
            
              list<NTFS__c> listaAllNTFS =
                    [ 
                        SELECT Id,
                        Name,
                        TW1_Cliente__r.Name,
                        TW1_Data_da_Nota__c,
                        TW1_Forma_de_pagamento__c,
                        TW1_Loja__r.Name,
                        TW1_Valor_RS__c 
                        FROM NTFS__c
                        WHERE TW1_Promocao__c=:IdPromocao and TW1_Cliente__c=:IdCliente
                    ];
                                
                return listaAllNTFS; 
        }

        return listaNTFSPorId; 
    }
    
    @HttpPost
    global static string UpsertNotaFiscal(requestWrapper RequestWrapper){

        try{          
            NTFS__c ntfs = MapNTFS(RequestWrapper.notaFiscal);
            
            if(ntfs.Id != null && ntfs.Id != ''){
                update ntfs; 
                return 'Atualizado com Sucesso!';
            }else{
                Boolean DataValida = GetDataNotaFiscal(RequestWrapper.notaFiscal,RequestWrapper.notaFiscal.IdPromocao);

                If(DataValida==true){insert ntfs;return 'Inserido com Sucesso!';}else{return 'A data da nota fiscal não está dentro do prazo desta promoção!';}                
            }
        } catch (Exception ce) {return 'Erro ao inserir a nota fiscal, verifique os campos preenchidos!';}  
    }
    
   @HttpPut
    global static String deleteNTFS(String IdCliente,String IdNotaFiscal,String IdPromocao,string NumeroCupom,string NumeroBrinde) {
        RestRequest req = RestContext.request;
        
         Savepoint sp = Database.setSavepoint();
        Try{
            date vaData = DateTime.now().date();
            TW1_Parametros_Promocao__c Promocao = [Select Id,TW1_Data_Inicio__c,TW1_Data_Fim__c,TW1_Valor_Min_NTFS__c,TW1_Max_Brinde_Clientes__c,Max_Cupom__c,Max_Bonus_Cliente__c,TW1_Acumula_Saldo__c,TW1_Troca_por__c,TW1_Condicoes_especiais_cart_credito__c,TW1_Contabiliza_Bonus__c,Max_Brindes_por_Troca__c From TW1_Parametros_Promocao__c Where Id=:IdPromocao Limit 1];
        	List<TW1_Condicoes_Especiais__c> CondicoesEspeciais = [Select Id,TW1_Bonus_Mult_Brinde__c,TW1_Bonus_Mult_Cupom__c,TW1_Cartao__c,TW1_Promocao__c From TW1_Condicoes_Especiais__c where TW1_Promocao__c=:Promocao.Id];

             list<NTFS__c> listaAllNTFS =
                    [ 
                        SELECT Id,
                        Name,
                        TW1_Cliente__r.Name,
                        TW1_Data_da_Nota__c,
                        TW1_Forma_de_pagamento__c,
                        TW1_Loja__r.Name,
                        TW1_Valor_RS__c 
                        FROM NTFS__c
                        WHERE TW1_Promocao__c=:IdPromocao and TW1_Cliente__c=:IdCliente
                    ];    
             
            
            if(Promocao.TW1_Contabiliza_Bonus__c){
                if(Promocao.TW1_Troca_por__c == 'Brinde' || Promocao.TW1_Troca_por__c == 'Ambos'){
                    
                  Integer ContSubtracao = 0;
                    
                    for(TW1_Condicoes_Especiais__c condicoes :CondicoesEspeciais){
                        for(NTFS__c listNotasEspecial:listaAllNTFS){     List<String> formas = condicoes.TW1_Cartao__c.split(';', 15); for(String forma : formas){If(listNotasEspecial.TW1_Forma_de_pagamento__c == forma){if(listNotasEspecial.TW1_Valor_RS__c >= Promocao.TW1_Valor_Min_NTFS__c)ContSubtracao = ContSubtracao + (Integer.valueOf(condicoes.TW1_Bonus_Mult_Brinde__c)- 1);
                       				 }
                     			}
                         }
                   	 }
                    
                    
                     Double valorMinTrocado = 0.0;
                     Double valorTotal = 0.0;
                     valorMinTrocado = Promocao.TW1_Valor_Min_NTFS__c * (NumeroBrinde == null || NumeroBrinde == ''? 0 :Integer.valueOf(NumeroBrinde) - ContSubtracao);
                     Integer NCupom = NumeroCupom == null || NumeroCupom == ''? 0 :Integer.valueOf(NumeroCupom);
                     
                     if(Promocao.TW1_Troca_por__c == 'Ambos' && (NCupom > Integer.valueOf(NumeroBrinde)))
                     valorMinTrocado = Promocao.TW1_Valor_Min_NTFS__c * NCupom;
                     
                     NTFS__c NotaParaDeletar;
                     
                     for(NTFS__c listNota : listaAllNTFS){
                         valorTotal = valorTotal + listNota.TW1_Valor_RS__c;
                         if(IdNotaFiscal == listNota.Id)
                             NotaParaDeletar = listNota;
                     }
                     
                     Double valorSubtraido = valorTotal - NotaParaDeletar.TW1_Valor_RS__c;
                     
                     if(valorSubtraido >= valorMinTrocado){
                         delete NotaParaDeletar;
                     
                     return 'Nota Fiscal excluída com sucesso!';
                     }else{
                          return 'A Nota Fiscal não pode ser excluída!';
                     }   
                    
                 //parte Cupom
                }else{
                    
                     Integer ContSubtracao = 0;
                    
                    for(TW1_Condicoes_Especiais__c condicoes :CondicoesEspeciais){
                        for(NTFS__c listNotasEspecial:listaAllNTFS){
                            List<String> formas = condicoes.TW1_Cartao__c.split(';', 15);
                        		for(String forma : formas){
                        			If(listNotasEspecial.TW1_Forma_de_pagamento__c == forma){
                                        condicoes.TW1_Bonus_Mult_Cupom__c = condicoes.TW1_Bonus_Mult_Cupom__c == 0? 1:condicoes.TW1_Bonus_Mult_Cupom__c;
                           				 if(listNotasEspecial.TW1_Valor_RS__c >= Promocao.TW1_Valor_Min_NTFS__c)
                                             ContSubtracao = ContSubtracao + (Integer.valueOf(condicoes.TW1_Bonus_Mult_Cupom__c) - 1);
                       				 }
                     			}
                         }
                   	 }
                    
                    Double valorMinTrocado = 0.0;
                     Double valorTotal = 0.0;
                     valorMinTrocado = Promocao.TW1_Valor_Min_NTFS__c * (NumeroCupom == null || NumeroCupom == ''? 0 :Integer.valueOf(NumeroCupom) - ContSubtracao);
                     Integer NCupom = NumeroCupom == null || NumeroCupom == ''? 0 :Integer.valueOf(NumeroCupom);
                     
                     if(Promocao.TW1_Troca_por__c == 'Ambos' && (NCupom > Integer.valueOf(NumeroBrinde)))
                     valorMinTrocado = Promocao.TW1_Valor_Min_NTFS__c * NCupom;
                     
                     NTFS__c NotaParaDeletar;
                     
                     for(NTFS__c listNota : listaAllNTFS){
                         valorTotal = valorTotal + listNota.TW1_Valor_RS__c;
                         if(IdNotaFiscal == listNota.Id)
                             NotaParaDeletar = listNota;
                     }
                     
                     Double valorSubtraido = valorTotal - NotaParaDeletar.TW1_Valor_RS__c;
                     
                     if(valorSubtraido >= valorMinTrocado){
                         delete NotaParaDeletar;
                     
                     return 'Nota Fiscal excluída com sucesso!';
                     }else{
                          return 'A Nota Fiscal não pode ser excluída!';
                     }
                    
                }
                //Sem Condições especiais
            }else{
                 if(Promocao.TW1_Troca_por__c == 'Brinde' || Promocao.TW1_Troca_por__c == 'Ambos'){
                  	 
                     Double valorMinTrocado = 0.0;
                     Double valorTotal = 0.0;
                     valorMinTrocado = Promocao.TW1_Valor_Min_NTFS__c * (NumeroBrinde == null || NumeroBrinde == ''? 0 :Integer.valueOf(NumeroBrinde));
                     Integer NCupom = NumeroCupom == null || NumeroCupom == ''? 0 :Integer.valueOf(NumeroCupom);
                     
                     if(Promocao.TW1_Troca_por__c == 'Ambos' && (NCupom > Integer.valueOf(NumeroBrinde)))
                     valorMinTrocado = Promocao.TW1_Valor_Min_NTFS__c * NCupom;
                     
                     NTFS__c NotaParaDeletar;
                     
                     for(NTFS__c listNota : listaAllNTFS){
                         valorTotal = valorTotal + listNota.TW1_Valor_RS__c;
                         if(IdNotaFiscal == listNota.Id)
                             NotaParaDeletar = listNota;
                     }
                     
                     Double valorSubtraido = valorTotal - NotaParaDeletar.TW1_Valor_RS__c;
                     
                     if(valorSubtraido >= valorMinTrocado){
                         delete NotaParaDeletar;
                     
                     return 'Nota Fiscal excluída com sucesso!';
                     }else{
                          return 'A Nota Fiscal não pode ser excluída!';
                     }
                //Parte de cupom
                }else{
                     
                     Double valorMinTrocado = 0.0;
                     Double valorTotal = 0.0;
                     
                     Integer NCupom = NumeroCupom == null || NumeroCupom == ''? 0 :Integer.valueOf(NumeroCupom);
                     valorMinTrocado = Promocao.TW1_Valor_Min_NTFS__c * NCupom;
                     
                     NTFS__c NotaParaDeletar;
                     
                     for(NTFS__c listNota : listaAllNTFS){
                         valorTotal = valorTotal + listNota.TW1_Valor_RS__c;
                         if(IdNotaFiscal == listNota.Id)
                             NotaParaDeletar = listNota;
                     }
                     
                     Double valorSubtraido = valorTotal - NotaParaDeletar.TW1_Valor_RS__c;
                     
                     if(valorSubtraido >= valorMinTrocado){
                         delete NotaParaDeletar;
                     
                     return 'Nota Fiscal excluída com sucesso!';
                     }else{
                          return 'A Nota Fiscal não pode ser excluída!';
                     }
                }
            }
            
        }catch (Exception ce) {
                    Database.rollback(sp);
                    return 'Erro na operacao';
            }  
      }
    
    global class requestWrapper 
    {
        public NotaFiscal notaFiscal;
    }
    
    global class NotaFiscal 
    {
        public string Id;
        public string NumeroNota;
        public string IdLoja;
        public string IdShopping;
        public string FormaPagamento;
        public string IdCliente;
        public string IdPromocao;
        public Date DataNota;
        public string Valor;
        public string NomeVendedor;
    }
    
    Private static NTFS__c MapNTFS(NotaFiscal notaFiscal){
        NTFS__c ntfs = new NTFS__c();
        
        ntfs.Id = notaFiscal.Id;
        ntfs.Name = notaFiscal.NumeroNota;
        ntfs.TW1_Cliente__c = notaFiscal.IdCliente;
        ntfs.TW1_Data_da_Nota__c = notaFiscal.DataNota;
        ntfs.TW1_Shopping__c = notaFiscal.IdShopping;
        ntfs.TW1_Forma_de_pagamento__c = notaFiscal.FormaPagamento;
        ntfs.TW1_Loja__c = notaFiscal.IdLoja;
        ntfs.TW1_Valor_RS__c = decimal.valueOf(notaFiscal.Valor);
        ntfs.TW1_Promocao__c = notaFiscal.IdPromocao;
        ntfs.TW1_NomeVendedor__c = notaFiscal.NomeVendedor;
        
        return ntfs;
    } 

     Public static Boolean GetDataNotaFiscal(NotaFiscal notaFiscal,string IdPromocao)
     {
            TW1_Parametros_Promocao__c Promocao = [Select Id,TW1_Data_Inicio__c,TW1_Data_Fim__c From TW1_Parametros_Promocao__c where Id=:IdPromocao Limit 1];

                 If(notaFiscal.DataNota >= Promocao.TW1_Data_Inicio__c && notaFiscal.DataNota <= Promocao.TW1_Data_Fim__c)
                    return true;
            
                return False;
       }
}