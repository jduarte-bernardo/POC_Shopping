public class TW1_Ancar_HistoricoTipoDeBusca {
    
    public boolean displaySegmento {get; set;}
    public boolean displayMarca {get; set;} 
    public boolean displayLuc {get; set;} 
    public boolean displayshopLuc {get; set;} 
    public boolean displayTabela {get; set;}
    public boolean displayLucBusca{get; set;}
    public boolean SegmentoPerfil{get; set;}
    public string DisplayShopping{get; set;}
    
    
    public boolean displayPesquisaLucVazio {get; set;}
    public boolean displayPesquisaSegmentoVazio {get; set;}
    public boolean displayPesquisaSegmentoAccount {get; set;}
    public boolean displayPesquisaMarcaVazio {get; set;}
    public boolean displayPesquisaMarcaAccount {get; set;}
    public boolean displayBotaoPesquisa {get; set;}
    public boolean displayRetornoPesquisa {get; set;}
    public boolean displayPesquisaMarca {get; set;}
    public boolean displayPesquisaSegmento {get; set;}
    public boolean displayPesquisaLucc {get; set;}
    public boolean displayPesquisaShoppingLucc {get; set;}
    
    public string valorPesquisaMarca {get; set;}
    public string valorPesquisaSegmento {get; set;}
    public string valorPesquisaShoppinLuc {get; set;}
    public string valorPesquisaLuc{get; set;}
    
    public string SegmentoRamo {get; set;}
    
    
    public List<Account> ListMarcas {get; set;}
    public List<TW1_Shopping__c> ListShoppings {get; set;}
    public List<TW1_Shopping__c> ListShoppingsSegmento {get; set;}
    public List<TW1_Shopping__c> ListShoppingsluc {get; set;}
	public List<TW1_Propriedade__c> Listpropriedadeluc {get; set;}
    public List<TW1_Plano_de_mix__c> ListPlanoMix {get; set;}
    public Map<Id,Account> accountsIds {get; set;}
    
    
    public string IdObjetoDisplay {get; set;}
    public boolean displayBotaoRetorno{get; set;}
    public boolean displayBotaoRetornoSegmento{get; set;}
    public boolean displayBotaoRetornoMarca{get; set;}
     public boolean displayBotaoRetornoLuc{get; set;}
    public List<TW1_Informacoes_historicas__c> tabelaHistorica{get; set;}
    public List<TW1_Informacoes_historicas__c> InftabelaHistorica{get; set;}
    
    public string shoppingId{get; set;}
    public string lucName{get; set;}
    Public string marcaBuscada{get; set;}
    public string segmentoBuscado{get; set;}
    public string lucBuscada{get; set;}
    public string shoppingBuscado{get; set;}
    public string tipodeBusca{get; set;}
    public string NomeDoShopping{get; set;}
    public string NomeDoSegmento{get; set;}
    public string NomeDoMarca{get; set;}
    public string NomeDaLuc{get; set;}
    
    
    public TW1_Ancar_HistoricoTipoDeBusca()
    {	
        SegmentoPerfil = profileGerenteRegional();
        displaySegmento = false;
        displayMarca = false;
        displayLuc = false;
        displayLucBusca = false;
        displayTabela = false;
        displayBotaoPesquisa = true;
        displayPesquisaMarca = false;
        displayBotaoRetorno = false;
        displayBotaoRetornoMarca = false;
        displayBotaoRetornoLuc = false;
        displayBotaoRetornoSegmento = false;
        displayPesquisaMarcaAccount = false;
        displayPesquisaSegmentoAccount = false;
        tipodeBusca = 'BUSCA';
        valorPesquisaShoppinLuc = '';
        DisplayShopping ='';
    }
    
    public void BotaoVoltaMarca()
    {         
        displayBotaoRetornoMarca = false;
        displayBotaoRetornoLuc = false;
        displayBotaoRetornoSegmento = false;
        displayPesquisaMarcaAccount = false;
        displayPesquisaMarca = true;
        displayTabela = false;
        displayMarca = true;
        displayPesquisaSegmento = false;
        displayPesquisaSegmentoVazio = false;
        displaySegmento = false;
        displayshopLuc = false;
        displayPesquisaShoppingLucc = false;
    }
    
    public void BotaoVoltaSegmento()
    {         
        displayBotaoRetornoLuc = false;
        displayBotaoRetornoSegmento = false;
        displayPesquisaMarcaVazio = false;                    
        displayPesquisaMarcaAccount = false;
        displayPesquisaMarca = false;
        displayTabela = false;
        displayMarca = false;
        displayPesquisaSegmento = true;
        displayPesquisaSegmentoAccount = false;
        displayPesquisaSegmentoVazio = false;
        displaySegmento = true;
        displayshopLuc = false;
        displayPesquisaShoppingLucc = false;
       
    }
    
    public void BotaoVoltaLuc()
    {         
        displayBotaoRetornoLuc = false;
        displayPesquisaMarcaVazio = false;                    
        displayPesquisaMarcaAccount = false;
        displayPesquisaMarca = false;
        displayTabela = false;
        displayMarca = false;
        displayPesquisaSegmento = false;
        displayPesquisaSegmentoVazio = false;
        displaySegmento = false;
        displayPesquisaLucVazio = false;
        displayPesquisaShoppingLucc = true;
        displayPesquisaLucc = false;
        displayLuc = true;
    }
    
    
    //Visibilidade
    public void TelaInicio()
    {
        DisplayShopping ='';
        displaySegmento = false;
        displayMarca = false;
        displayLuc = false;
        displayLucBusca = false;
        displayTabela = false;
        displayBotaoPesquisa = true;
        displayPesquisaMarcaAccount = false;
        displayPesquisaMarcaVazio = false;
        displayPesquisaSegmentoAccount = false;
        displayPesquisaSegmentoVazio = false;
        displayPesquisaMarca = false;
        ListShoppings = new List<TW1_Shopping__c>();
        Listpropriedadeluc = new List<TW1_Propriedade__c>();
        valorPesquisaMarca ='';
        valorPesquisaLuc ='';
        valorPesquisaSegmento = '';
        valorPesquisaShoppinLuc = '';
        displayBotaoRetorno = false;
        displayBotaoRetornoMarca = false;
        displayshopLuc = false;
        displayPesquisaShoppingLucc = false;
        
    }
    public void MostraPesquisaSegmento() {   
        displaySegmento = true;
        displayMarca = false;
        displayLuc = false;
        displayLucBusca = false;
        displayTabela = false;
        displayBotaoPesquisa = false;
        displayBotaoRetorno = true;
        displayBotaoRetornoMarca = false;
        displayPesquisaSegmentoVazio = false;
        tipodeBusca = 'Segmento';
        
        getShoppingsSegmento();
    } 
    public void MostraPesquisaMarca(){
        displaySegmento = false;
        displayMarca = true;
        displayLuc = false;
        displayLucBusca = false;
        displayTabela = false;
        displayBotaoPesquisa = false;
        displayBotaoRetorno = true;
        displayBotaoRetornoMarca = false;
        tipodeBusca = 'Marca';
        
       getShoppingsByMarca();
    }
    public void MostraPesquisaShopping(){
        displaySegmento = false;
        displayMarca = false;
        displayLuc = true;
        displayLucBusca = true;
        displayTabela = false;
        displayBotaoPesquisa = false;
        displayshopLuc = false;
        displayBotaoRetorno = true;
        displayBotaoRetornoMarca = false;
        displayPesquisaMarcaAccount = false;
        displayPesquisaShoppingLucc = true;
        displayPesquisaLucc = false;
        tipodeBusca = 'ShoppingLuc';
        valorPesquisaMarca = '';
	BuscarShoppingsLuc();
    }
    public void ShowLuc(){
        displayPesquisaLucc = false;
        displayPesquisaShoppingLucc = true;
        displayLuc = true;
        displayshopLuc = true;
        displayLucBusca = false;  
    }
    
    //class HistoricoBotaoTipoBuscaController
    public static Boolean profileGerenteRegional(){
        
        Id idProfileUser = UserInfo.getProfileId();
        
        Profile perfil = [SELECT Name FROM Profile WHERE Id = :idProfileUser LIMIT 1];
        
        return(perfil.Name == 'Gerente Regional' || perfil.Name == 'Comercial EC' || perfil.Name == 'System Administrator' || perfil.Name == 'Administrador do sistema');
    }
    
    
    public void BuscarShoppingsLuc(){
           displayPesquisaLucVazio = false;
        
            List<TW1_Shopping__c> listaShoppings = [SELECT Id, Name FROM TW1_Shopping__c Order By Name Asc];
            
            displayPesquisaShoppingLucc = true;
            
            ListShoppings = listaShoppings; 
        
    }
    
    //getLucsByLuc
    public void getLucsByLuc(){
        displayPesquisaLucVazio = false;
        String strLuc= valorPesquisaShoppinLuc;
        String idShopping = IdObjetoDisplay;
       
        if(strLuc == '' || strLuc == null ){
      	        displayPesquisaLucVazio = true;
			 displayPesquisaShoppingLucc = true;
            displayPesquisaLucc = false;
        }else{
        
        List<TW1_Propriedade__c> luc = getLuc(strLuc, idShopping);
        
        System.debug('luc------------: '+ luc);
        
        if(luc.size() >=1){
            Listpropriedadeluc = luc;
            displayPesquisaLucc = true;
            displayPesquisaShoppingLucc = false;
             shoppingBuscado = IdObjetoDisplay;
        }else{
            //mensagem de erro
            displayPesquisaLucVazio = true;
			 displayPesquisaShoppingLucc = true;
            displayPesquisaLucc = false;
        }
      }
    }
    
    public static List<TW1_Propriedade__c> getLuc(String strLuc, String idShopping){
        
        List<TW1_Propriedade__c> listaLucsEqual = [SELECT Name FROM TW1_Propriedade__c WHERE Name = :strLuc AND TW1_Shopping__c = :idShopping limit 20];
        
        if(listaLucsEqual.size() >= 1){
            return listaLucsEqual;
        }else{
            String strLucLike = '%' + strLuc + '%';
            List<TW1_Propriedade__c> listaLucsLike = [SELECT Name FROM TW1_Propriedade__c WHERE Name LIKE :strLucLike AND TW1_Shopping__c = :idShopping limit 20];
            if(listaLucsLike.size() >= 1){
            return listaLucsLike;
            }else{
                return new List<TW1_Propriedade__c>();
            }
        }
    }

	//getShoppingsBySegmento
    public void getShoppingsSegmento(){
       
        displayPesquisaSegmentoVazio = false;
        
            List<TW1_Shopping__c> listaShoppings = [SELECT Id, Name FROM TW1_Shopping__c Order By Name Asc];
            
            displayPesquisaSegmento = true;
            
            ListShoppings = listaShoppings; 
       
    }
    
     public void getSegmento(){
        
        if(valorPesquisaSegmento == '' || valorPesquisaSegmento == null){
            
            displayPesquisaSegmentoVazio = true;
            
        }else{
	            String strMarcaLike = '%' + this.valorPesquisaSegmento + '%';
           		 List<TW1_Plano_de_mix__c> listaSegmentosLike = [SELECT Id,TW1_Segmento__c FROM TW1_Plano_de_mix__c WHERE TW1_Segmento__c LIKE :strMarcaLike limit 20];
            
        	 displayPesquisaSegmentoAccount = true;
             displayPesquisaSegmento = false;
            displayPesquisaSegmentoVazio = false;
           shoppingBuscado = IdObjetoDisplay;
            
            if(listaSegmentosLike.size() <= 0){
				displayPesquisaSegmentoVazio = true; 
                displayPesquisaSegmento = true;
            }
                    
            
            ListPlanoMix = listaSegmentosLike;            
            
        }               
    }
    
    //getShoppingsByMarca
    public void getShoppingsByMarca(){
       
        displayPesquisaMarcaVazio = false;
        
            List<TW1_Shopping__c> listaShoppings = [SELECT Id, Name FROM TW1_Shopping__c Order By Name Asc];
            
            displayPesquisaMarca = true;
            
            ListShoppings = listaShoppings; 
       
    }
    
    public void getMarca(){
        
        if(valorPesquisaMarca == '' || valorPesquisaMarca == null){
            
            displayPesquisaMarcaVazio = true;
            
        }else{
	            String strMarcaLike = '%' + this.valorPesquisaMarca + '%';
            List<Account> listaMarcasLike = [SELECT Name FROM Account WHERE RecordType.Name='Marca' And Name LIKE :strMarcaLike Order By Name Desc limit 20];     
        	 displayPesquisaMarcaAccount = true;
             displayPesquisaMarca = false;
            displayPesquisaMarcaVazio = false;
           shoppingBuscado = IdObjetoDisplay;
            
              if(listaMarcasLike.size() <= 0)
                    displayPesquisaMarcaVazio = true;
            
            ListMarcas = listaMarcasLike;            
            
        }               
    }
     //TabelaHistoricoController
    public void getTabelaHistoricaLuc(){
        shoppingId = shoppingBuscado.substring(0,15);
        
        displayLuc = false;
        displayBotaoRetornoLuc = true;
        displayPesquisaLucVazio = false;
        displayPesquisaMarcaAccount = false;
        displayPesquisaMarca = false;
        displayTabela = true;
        displayMarca = false;
        displayPesquisaSegmento = false;
        displayPesquisaSegmentoVazio = false;
        displaySegmento = false;
        displayshopLuc = false;
        displayPesquisaShoppingLucc = false;
        displayPesquisaLucc = false;
        tabelaHistorica = new List<TW1_Informacoes_historicas__c>();
          system.debug('NomeDoShopping: '+ NomeDoShopping);
          system.debug('shoppingId: '+ shoppingId);
         InftabelaHistorica = new List<TW1_Informacoes_historicas__c>();
        
            if(NomeDaLuc != null && NomeDaLuc != ''){
                
            List<TW1_Informacoes_historicas__c> Inforr = [
                SELECT 
                TW1_Aluguel_percentual_faturado__c,
                TW1_AMM_faturado__c,
                Name,
                TW1_Condominio_comum__c,
                TW1_Condominio_comum_m2__c,
                TW1_Custo_Ocupacao_Comum__c,
                TW1_Custo_Ocupacao_Comum_m2__c,
                TW1_descricao_aluguel_dobrado__c,
                TW1_FPP_m2__c,
                TW1_FPP_Total_faturado__c,
                TW1_Grocc_Comum_percentual__c,
                TW1_Lucs_secundarias__c,
                TW1_Propriedade1__c,
                TW1_Percentual_sobre_vendas__c,
                TW1_Propriedade__c,
                TW1_Valor_do_Aluguel_m2__c,
                TW1_Venda_Total__c,
                Vendas_Total_m2__c,
                TW1_Area__c,
                TW1_Marca__c,
                TW1_Nome_fantasia__c,
                TW1_Grupo_de_atividade__c,
                TW1_Tipo_de_Atividade__c,
                TW1_Ramo_de_atividade__c
                
                FROM TW1_Informacoes_historicas__c
                WHERE TW1_Shopping__c = :shoppingId And
                TW1_Propriedade1__c = :NomeDaLuc ORDER BY Name DESC
            ];
			system.debug('Inforr: '+ Inforr.Size());      
                
                for(TW1_Informacoes_historicas__c Infor :Inforr)               
                {	
                 system.debug('Infor: '+ Infor);
                Infor.TW1_Aluguel_percentual_faturado__c = (Infor.TW1_Aluguel_percentual_faturado__c == null ? 0:Infor.TW1_Aluguel_percentual_faturado__c);
                Infor.TW1_Venda_Total__c = (Infor.TW1_Venda_Total__c == null ? 0:Infor.TW1_Venda_Total__c);
                Infor.Vendas_Total_m2__c = (Infor.Vendas_Total_m2__c == null ? 0:Infor.Vendas_Total_m2__c);
                Infor.TW1_AMM_faturado__c = (Infor.TW1_AMM_faturado__c == null ? 0:Infor.TW1_AMM_faturado__c);
                Infor.TW1_Valor_do_Aluguel_m2__c = (Infor.TW1_Valor_do_Aluguel_m2__c == null ? 0:Infor.TW1_Valor_do_Aluguel_m2__c);
                Infor.TW1_Condominio_comum__c = (Infor.TW1_Condominio_comum__c == null ? 0:Infor.TW1_Condominio_comum__c);
                Infor.TW1_Condominio_comum_m2__c = (Infor.TW1_Condominio_comum_m2__c == null ? 0:Infor.TW1_Condominio_comum_m2__c);
                Infor.TW1_FPP_Total_faturado__c = (Infor.TW1_FPP_Total_faturado__c == null ? 0:Infor.TW1_FPP_Total_faturado__c);
                Infor.TW1_FPP_m2__c = (Infor.TW1_FPP_m2__c == null ? 0:Infor.TW1_FPP_m2__c);
                Infor.TW1_Custo_Ocupacao_Comum__c = (Infor.TW1_Custo_Ocupacao_Comum__c == null ? 0:Infor.TW1_Custo_Ocupacao_Comum__c);
                Infor.TW1_Custo_Ocupacao_Comum_m2__c = (Infor.TW1_Custo_Ocupacao_Comum_m2__c == null ? 0:Infor.TW1_Custo_Ocupacao_Comum_m2__c);
                Infor.TW1_Grocc_Comum_percentual__c = (Infor.TW1_Grocc_Comum_percentual__c == null ? 0:Infor.TW1_Grocc_Comum_percentual__c);
                Infor.TW1_Percentual_sobre_vendas__c = (Infor.TW1_Percentual_sobre_vendas__c == null ? 0:Infor.TW1_Percentual_sobre_vendas__c);
                Infor.TW1_Area__c = (Infor.TW1_Area__c == null ? 0:Infor.TW1_Area__c);
                InftabelaHistorica.add(Infor);
            }
                if(InftabelaHistorica.size() <= 0){
                    	
                    	displayBotaoRetornoLuc = false;
  					    displayPesquisaMarcaVazio = true;                    
                        displayPesquisaMarcaAccount = true;
                        displayPesquisaMarca = true;
                        displayTabela = false;
                        displayMarca = true;
                    	displayLuc = true;
                        displayPesquisaSegmento = false;
                        displayPesquisaSegmentoVazio = false;
                        displaySegmento = false;
                        displayPesquisaLucVazio = true;
						displayPesquisaShoppingLucc = true;
            			displayPesquisaLucc = false;               
                }
                  
                    
        }
        
        insertAuditoriaInfHistorica(lucName, marcaBuscada, segmentoBuscado, shoppingBuscado, tipodeBusca);
    }
    
    //TabelaHistoricoController
    public void getTabelaHistorica(){
        shoppingId = shoppingBuscado.substring(0,15);
        
        displayPesquisaMarcaAccount = false;
        displayPesquisaMarca = false;
        displayBotaoRetornoMarca = true;
        displayTabela = true;
        displayMarca = false;
        displayPesquisaSegmento = false;
        displayPesquisaSegmentoVazio = false;
        displaySegmento = false;
        displayshopLuc = false;
        displayPesquisaShoppingLucc = false;
        tabelaHistorica = new List<TW1_Informacoes_historicas__c>();
          system.debug('NomeDoShopping: '+ NomeDoShopping);
          system.debug('shoppingId: '+ shoppingId);
         InftabelaHistorica = new List<TW1_Informacoes_historicas__c>();
        //if(valorPesquisaMarca != null && valorPesquisaMarca != ''){
            if(NomeDoMarca != null && NomeDoMarca != ''){
                
            List<TW1_Informacoes_historicas__c> Inforr = [
                SELECT 
                TW1_Aluguel_percentual_faturado__c,
                TW1_AMM_faturado__c,
                Name,
                TW1_Condominio_comum__c,
                TW1_Condominio_comum_m2__c,
                TW1_Custo_Ocupacao_Comum__c,
                TW1_Custo_Ocupacao_Comum_m2__c,
                TW1_descricao_aluguel_dobrado__c,
                TW1_FPP_m2__c,
                TW1_FPP_Total_faturado__c,
                TW1_Grocc_Comum_percentual__c,
                TW1_Lucs_secundarias__c,
                TW1_Percentual_sobre_vendas__c,
                TW1_Propriedade__c,
                TW1_Valor_do_Aluguel_m2__c,
                TW1_Venda_Total__c,
                Vendas_Total_m2__c,
                TW1_Area__c,
                TW1_Marca__c,
                TW1_Nome_fantasia__c,
                TW1_Grupo_de_atividade__c,
                TW1_Tipo_de_Atividade__c,
                TW1_Ramo_de_atividade__c,
                TW1_Propriedade1__c
                
                FROM TW1_Informacoes_historicas__c
                WHERE TW1_Shopping__c = :shoppingId And
				 TW1_Marca__r.Name =:NomeDoMarca ORDER BY Name DESC
            ];
			system.debug('Inforr: '+ Inforr.Size());      
                
                for(TW1_Informacoes_historicas__c Infor :Inforr)               
                {	
                 system.debug('Infor: '+ Infor);
                Infor.TW1_Aluguel_percentual_faturado__c = (Infor.TW1_Aluguel_percentual_faturado__c == null ? 0:Infor.TW1_Aluguel_percentual_faturado__c);
                Infor.TW1_Venda_Total__c = (Infor.TW1_Venda_Total__c == null ? 0:Infor.TW1_Venda_Total__c);
                Infor.Vendas_Total_m2__c = (Infor.Vendas_Total_m2__c == null ? 0:Infor.Vendas_Total_m2__c);
                Infor.TW1_AMM_faturado__c = (Infor.TW1_AMM_faturado__c == null ? 0:Infor.TW1_AMM_faturado__c);
                Infor.TW1_Valor_do_Aluguel_m2__c = (Infor.TW1_Valor_do_Aluguel_m2__c == null ? 0:Infor.TW1_Valor_do_Aluguel_m2__c);
                Infor.TW1_Condominio_comum__c = (Infor.TW1_Condominio_comum__c == null ? 0:Infor.TW1_Condominio_comum__c);
                Infor.TW1_Condominio_comum_m2__c = (Infor.TW1_Condominio_comum_m2__c == null ? 0:Infor.TW1_Condominio_comum_m2__c);
                Infor.TW1_FPP_Total_faturado__c = (Infor.TW1_FPP_Total_faturado__c == null ? 0:Infor.TW1_FPP_Total_faturado__c);
                Infor.TW1_FPP_m2__c = (Infor.TW1_FPP_m2__c == null ? 0:Infor.TW1_FPP_m2__c);
                Infor.TW1_Custo_Ocupacao_Comum__c = (Infor.TW1_Custo_Ocupacao_Comum__c == null ? 0:Infor.TW1_Custo_Ocupacao_Comum__c);
                Infor.TW1_Custo_Ocupacao_Comum_m2__c = (Infor.TW1_Custo_Ocupacao_Comum_m2__c == null ? 0:Infor.TW1_Custo_Ocupacao_Comum_m2__c);
                Infor.TW1_Grocc_Comum_percentual__c = (Infor.TW1_Grocc_Comum_percentual__c == null ? 0:Infor.TW1_Grocc_Comum_percentual__c);
                Infor.TW1_Percentual_sobre_vendas__c = (Infor.TW1_Percentual_sobre_vendas__c == null ? 0:Infor.TW1_Percentual_sobre_vendas__c);
                Infor.TW1_Area__c = (Infor.TW1_Area__c == null ? 0:Infor.TW1_Area__c);
                InftabelaHistorica.add(Infor);
            }
                if(InftabelaHistorica.size() <= 0){
                    	displayBotaoRetornoMarca = false;
  					    displayPesquisaMarcaVazio = true;                    
                        displayPesquisaMarcaAccount = false;
                    	displayPesquisaMarca = true;
                        displayTabela = false;
                        displayMarca = true;
                        displayPesquisaSegmento = false;
                        displayPesquisaSegmentoVazio = false;
                        displaySegmento = false;
                        displayshopLuc = false;
                        displayPesquisaShoppingLucc = false;
                }
                  
                    
        }
        
        insertAuditoriaInfHistorica(lucName, marcaBuscada, segmentoBuscado, shoppingBuscado, tipodeBusca);
    }
    
    public void getTabelaHistoricaSegmento(){   
        
        shoppingId = shoppingBuscado.substring(0,15);
        System.debug('shoppingId ---------- : '+shoppingId);
         System.debug('IdObjetoDisplay ---------- : '+IdObjetoDisplay);
        displayTabela = true;
        displayMarca = false;
        displayPesquisaSegmento = false;
        displayBotaoRetornoSegmento = true;
        displayPesquisaSegmentoVazio = false;
        displaySegmento = false;
        displayshopLuc = false;
        displayPesquisaShoppingLucc = false;
        DisplayShopping = NomeDoShopping;
        
        tabelaHistorica = new List<TW1_Informacoes_historicas__c>();
        
         InftabelaHistorica = new List<TW1_Informacoes_historicas__c>();
        
            if(NomeDoShopping != null && NomeDoShopping != ''){
                
            List<TW1_Informacoes_historicas__c> Inforr = [
                SELECT 
                TW1_Aluguel_percentual_faturado__c,
                TW1_AMM_faturado__c,
                Name,
                TW1_Condominio_comum__c,
                TW1_Condominio_comum_m2__c,
                TW1_Custo_Ocupacao_Comum__c,
                TW1_Custo_Ocupacao_Comum_m2__c,
                TW1_descricao_aluguel_dobrado__c,
                TW1_FPP_m2__c,
                TW1_FPP_Total_faturado__c,
                TW1_Grocc_Comum_percentual__c,
                TW1_Lucs_secundarias__c,
                TW1_Percentual_sobre_vendas__c,
                TW1_Propriedade__c,
                TW1_Propriedade__r.Id,
                TW1_Propriedade__r.Name,
                TW1_Valor_do_Aluguel_m2__c,
                TW1_Venda_Total__c,
                Vendas_Total_m2__c,
                TW1_Area__c,
                TW1_Marca__c,
                TW1_Nome_fantasia__c,
                TW1_Grupo_de_atividade__c,
                TW1_Tipo_de_Atividade__c,
                TW1_Ramo_de_atividade__c,
                TW1_Propriedade1__c
                FROM TW1_Informacoes_historicas__c
                
                WHERE TW1_Shopping__c = :shoppingId
                And TW1_Marca__c IN (
                    SELECT TW1_Marca__c
                    FROM TW1_JuctionMarcaPlanoMix__c
                    WHERE TW1_Plano_de_mix__c = :IdObjetoDisplay
                )
                ORDER BY Name DESC
            ];
			system.debug('Inforr: '+ Inforr.Size());      
                
                for(TW1_Informacoes_historicas__c Infor :Inforr)               
                {	
                 system.debug('Infor: '+ Infor);
                Infor.TW1_Aluguel_percentual_faturado__c = (Infor.TW1_Aluguel_percentual_faturado__c == null ? 0:Infor.TW1_Aluguel_percentual_faturado__c);
                Infor.TW1_Venda_Total__c = (Infor.TW1_Venda_Total__c == null ? 0:Infor.TW1_Venda_Total__c);
                Infor.Vendas_Total_m2__c = (Infor.Vendas_Total_m2__c == null ? 0:Infor.Vendas_Total_m2__c);
                Infor.TW1_AMM_faturado__c = (Infor.TW1_AMM_faturado__c == null ? 0:Infor.TW1_AMM_faturado__c);
                Infor.TW1_Valor_do_Aluguel_m2__c = (Infor.TW1_Valor_do_Aluguel_m2__c == null ? 0:Infor.TW1_Valor_do_Aluguel_m2__c);
                Infor.TW1_Condominio_comum__c = (Infor.TW1_Condominio_comum__c == null ? 0:Infor.TW1_Condominio_comum__c);
                Infor.TW1_Condominio_comum_m2__c = (Infor.TW1_Condominio_comum_m2__c == null ? 0:Infor.TW1_Condominio_comum_m2__c);
                Infor.TW1_FPP_Total_faturado__c = (Infor.TW1_FPP_Total_faturado__c == null ? 0:Infor.TW1_FPP_Total_faturado__c);
                Infor.TW1_FPP_m2__c = (Infor.TW1_FPP_m2__c == null ? 0:Infor.TW1_FPP_m2__c);
                Infor.TW1_Custo_Ocupacao_Comum__c = (Infor.TW1_Custo_Ocupacao_Comum__c == null ? 0:Infor.TW1_Custo_Ocupacao_Comum__c);
                Infor.TW1_Custo_Ocupacao_Comum_m2__c = (Infor.TW1_Custo_Ocupacao_Comum_m2__c == null ? 0:Infor.TW1_Custo_Ocupacao_Comum_m2__c);
                Infor.TW1_Grocc_Comum_percentual__c = (Infor.TW1_Grocc_Comum_percentual__c == null ? 0:Infor.TW1_Grocc_Comum_percentual__c);
                Infor.TW1_Percentual_sobre_vendas__c = (Infor.TW1_Percentual_sobre_vendas__c == null ? 0:Infor.TW1_Percentual_sobre_vendas__c);
                Infor.TW1_Area__c = (Infor.TW1_Area__c == null ? 0:Infor.TW1_Area__c);
                tabelaHistorica.add(Infor);
            }
                if(tabelaHistorica.size() <= 0){
                    	displayBotaoRetornoSegmento = false;
  					    displayPesquisaMarcaVazio = false;                    
                        displayPesquisaMarcaAccount = false;
                        displayPesquisaMarca = false;
                        displayTabela = false;
                        displayMarca = false;
                        displayPesquisaSegmento = true;
                    	displayPesquisaSegmentoAccount = false;
                        displayPesquisaSegmentoVazio = true;
                        displaySegmento = true;
                        displayshopLuc = false;
                        displayPesquisaShoppingLucc = false;
                }else{
                    
                    InftabelaHistorica =  SomatorioSegmento(tabelaHistorica);
                }           
        }
        
        insertAuditoriaInfHistorica(lucName, marcaBuscada, segmentoBuscado, shoppingBuscado, tipodeBusca);
    }
    
     public static List<TW1_Informacoes_historicas__c> SomatorioSegmento(List<TW1_Informacoes_historicas__c> tabelaHistorica)
    {
        Set<String> NomesPeriodo = new Set<String>();
        List<TW1_Informacoes_historicas__c> ListInfSomado = new List<TW1_Informacoes_historicas__c>();
        
        for(TW1_Informacoes_historicas__c InfHisto : tabelaHistorica)
        {  
        	 NomesPeriodo.add(InfHisto.Name);
        }
        
        for(String nome : NomesPeriodo)
        {
            TW1_Informacoes_historicas__c inf = new TW1_Informacoes_historicas__c();
            inf.Name = nome;
            
            	inf.TW1_Aluguel_percentual_faturado__c = (inf.TW1_Aluguel_percentual_faturado__c == null ? 0:inf.TW1_Aluguel_percentual_faturado__c);
                inf.TW1_Venda_Total__c = (inf.TW1_Venda_Total__c == null ? 0:inf.TW1_Venda_Total__c);
                inf.Vendas_Total_m2__c = (inf.Vendas_Total_m2__c == null ? 0:inf.Vendas_Total_m2__c);
                inf.TW1_AMM_faturado__c = (inf.TW1_AMM_faturado__c == null ? 0:inf.TW1_AMM_faturado__c);
                inf.TW1_Valor_do_Aluguel_m2__c = (inf.TW1_Valor_do_Aluguel_m2__c == null ? 0:inf.TW1_Valor_do_Aluguel_m2__c);
                inf.TW1_Condominio_comum__c = (inf.TW1_Condominio_comum__c == null ? 0:inf.TW1_Condominio_comum__c);
                inf.TW1_Condominio_comum_m2__c = (inf.TW1_Condominio_comum_m2__c == null ? 0:inf.TW1_Condominio_comum_m2__c);
                inf.TW1_FPP_Total_faturado__c = (inf.TW1_FPP_Total_faturado__c == null ? 0:inf.TW1_FPP_Total_faturado__c);
                inf.TW1_FPP_m2__c = (inf.TW1_FPP_m2__c == null ? 0:inf.TW1_FPP_m2__c);
                inf.TW1_Custo_Ocupacao_Comum__c = (inf.TW1_Custo_Ocupacao_Comum__c == null ? 0:inf.TW1_Custo_Ocupacao_Comum__c);
                inf.TW1_Custo_Ocupacao_Comum_m2__c = (inf.TW1_Custo_Ocupacao_Comum_m2__c == null ? 0:inf.TW1_Custo_Ocupacao_Comum_m2__c);
                inf.TW1_Grocc_Comum_percentual__c = (inf.TW1_Grocc_Comum_percentual__c == null ? 0:inf.TW1_Grocc_Comum_percentual__c);
            	inf.TW1_Percentual_sobre_vendas__c = (inf.TW1_Percentual_sobre_vendas__c == null ? 0:inf.TW1_Percentual_sobre_vendas__c);
         		inf.TW1_Area__c = (inf.TW1_Area__c == null ? 0:inf.TW1_Area__c);
            	inf.TW1_Grupo_de_atividade__c = '';
            	inf.TW1_Ramo_de_atividade__c = ''; 
                inf.TW1_Tipo_de_Atividade__c = '';
                
            for(TW1_Informacoes_historicas__c InfHisto : tabelaHistorica)
            {
                If(InfHisto.Name == nome)
                {                    
                    inf.TW1_Venda_Total__c = inf.TW1_Venda_Total__c + InfHisto.TW1_Venda_Total__c;
                    inf.TW1_Aluguel_percentual_faturado__c = inf.TW1_Aluguel_percentual_faturado__c + InfHisto.TW1_Aluguel_percentual_faturado__c;
                    inf.Vendas_Total_m2__c = inf.Vendas_Total_m2__c + InfHisto.Vendas_Total_m2__c;
                    inf.TW1_AMM_faturado__c = inf.TW1_AMM_faturado__c + InfHisto.TW1_AMM_faturado__c;
                    inf.TW1_Valor_do_Aluguel_m2__c = inf.TW1_Valor_do_Aluguel_m2__c + InfHisto.TW1_Valor_do_Aluguel_m2__c;
                    inf.TW1_Condominio_comum__c = inf.TW1_Condominio_comum__c + InfHisto.TW1_Condominio_comum__c;
                    inf.TW1_Condominio_comum_m2__c = inf.TW1_Condominio_comum_m2__c + InfHisto.TW1_Condominio_comum_m2__c;
                    inf.TW1_FPP_Total_faturado__c = inf.TW1_FPP_Total_faturado__c + InfHisto.TW1_FPP_Total_faturado__c;
                    inf.TW1_FPP_m2__c = inf.TW1_FPP_m2__c + InfHisto.TW1_FPP_m2__c;
                    inf.TW1_Custo_Ocupacao_Comum__c = inf.TW1_Custo_Ocupacao_Comum__c + InfHisto.TW1_Custo_Ocupacao_Comum__c;
                    inf.TW1_Custo_Ocupacao_Comum_m2__c = inf.TW1_Custo_Ocupacao_Comum_m2__c + InfHisto.TW1_Custo_Ocupacao_Comum_m2__c;
                    inf.TW1_Grocc_Comum_percentual__c = inf.TW1_Grocc_Comum_percentual__c + InfHisto.TW1_Grocc_Comum_percentual__c;
                    inf.TW1_Percentual_sobre_vendas__c = inf.TW1_Percentual_sobre_vendas__c + InfHisto.TW1_Percentual_sobre_vendas__c;
                    inf.TW1_Area__c = inf.TW1_Area__c + InfHisto.TW1_Area__c;
                    inf.TW1_Grupo_de_atividade__c = InfHisto.TW1_Grupo_de_atividade__c != null ? InfHisto.TW1_Grupo_de_atividade__c : inf.TW1_Grupo_de_atividade__c;
                	inf.TW1_Ramo_de_atividade__c = InfHisto.TW1_Ramo_de_atividade__c != null ? InfHisto.TW1_Ramo_de_atividade__c : inf.TW1_Grupo_de_atividade__c;
                	inf.TW1_Tipo_de_Atividade__c = InfHisto.TW1_Tipo_de_Atividade__c != null ? InfHisto.TW1_Tipo_de_Atividade__c : inf.TW1_Grupo_de_atividade__c;
                }
            }
            	
            ListInfSomado.add(inf);
        }


		return ListInfSomado;  
    }
    
    public static void insertAuditoriaInfHistorica(String lucPesquisada, String marcaPesquisada, String segmentoPesquisado, String shoppingPesquisado, String tipoBusca){
        TW1_Auditoria_Inf_Historicas__c auditoria = new TW1_Auditoria_Inf_Historicas__c();
        
        auditoria.TW1_Data_da_pesquisa__c = System.today();
        auditoria.TW1_Shopping_pesquisado__c = shoppingPesquisado;
        auditoria.TW1_Usuario__c = UserInfo.getUserId();
        auditoria.TW1_Tipo_de_pesquisa__c = tipoBusca;
        if(tipoBusca == 'shopping_luc'){
            auditoria.TW1_LUC_pesquisada__c = lucPesquisada;
        }else if(tipoBusca == 'segmento'){
            auditoria.TW1_Segmento_pesquisado__c = segmentoPesquisado;
        }else if(tipoBusca == 'marca'){
            auditoria.TW1_Marca_pesquisada__c = marcaPesquisada;
        }
        
        insert auditoria;
    }  
}