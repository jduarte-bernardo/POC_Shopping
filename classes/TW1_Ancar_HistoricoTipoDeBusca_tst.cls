@isTest
public class TW1_Ancar_HistoricoTipoDeBusca_tst {
		
    
     @isTest
    static void TestgetLucsByShopping(){
        Test.startTest();
        	
        	recordtype RT = [Select Id,Name from recordtype where Name='Marca'];
        
        	TW1_Shopping__c shopping = new TW1_Shopping__c(Name='Teste Shopping 2',TW1_SGL_Empreendimento__c = 'BPS');
        	insert shopping;
        
        	TW1_Propriedade__c propriedade = new TW1_Propriedade__c();
        	propriedade.Name = 'Luc1';
        	propriedade.TW1_Shopping__c = shopping.Id;
        	propriedade.TW1_Status__c = 'Vaga';
        	insert propriedade;
        
        	Account acc = new Account();
        	acc.Name = 'dfds';
        	acc.RecordTypeId = RT.Id;
			insert acc; 
                
        	TW1_Informacoes_historicas__c iNF = new TW1_Informacoes_historicas__c();
        	iNF.Name = 'ssss';
        	iNF.TW1_Shopping__c =  shopping.Id;
        	iNF.TW1_Propriedade__c = propriedade.Id;
            iNF.TW1_Propriedade1__c = propriedade.Name;
        	iNF.TW1_Marca__c = acc.Id;
        	iNF.TW1_Venda_Total__c = 1;
        	iNF.TW1_Aluguel_percentual_faturado__c = 1;
            iNF.Vendas_Total_m2__c = 1;
            iNF.TW1_AMM_faturado__c = 1;
            iNF.TW1_Valor_do_Aluguel_m2__c =1; 
            iNF.TW1_Condominio_comum__c = 1;
            iNF.TW1_Condominio_comum_m2__c =1; 
            iNF.TW1_FPP_Total_faturado__c = 1;
            iNF.TW1_FPP_m2__c = 1;
            iNF.TW1_Custo_Ocupacao_Comum__c =1; 
            iNF.TW1_Custo_Ocupacao_Comum_m2__c =1; 
            iNF.TW1_Grocc_Comum_percentual__c = 1;
            iNF.TW1_Percentual_sobre_vendas__c = 1;
            iNF.TW1_Area__c = 1;
            iNF.TW1_Grupo_de_atividade__c = '';
            iNF.TW1_Ramo_de_atividade__c = ''; 
            iNF.TW1_Tipo_de_Atividade__c = '';
			insert iNF;
        
        	TW1_Informacoes_historicas__c iNFF = new TW1_Informacoes_historicas__c();
        	iNFF.Name = 'ssss';
        	iNFF.TW1_Shopping__c =  shopping.Id;
        	iNFF.TW1_Propriedade__c = propriedade.Id;
            iNFF.TW1_Propriedade1__c = propriedade.Name;
        	iNFF.TW1_Marca__c = acc.Id;
        	iNFF.TW1_Venda_Total__c = 1;
        	iNFF.TW1_Aluguel_percentual_faturado__c = 1;
            iNFF.Vendas_Total_m2__c = 1;
            iNFF.TW1_AMM_faturado__c = 1;
            iNFF.TW1_Valor_do_Aluguel_m2__c =1; 
            iNFF.TW1_Condominio_comum__c = 1;
            iNFF.TW1_Condominio_comum_m2__c =1; 
            iNFF.TW1_FPP_Total_faturado__c = 1;
            iNFF.TW1_FPP_m2__c = 1;
            iNFF.TW1_Custo_Ocupacao_Comum__c =1; 
            iNFF.TW1_Custo_Ocupacao_Comum_m2__c =1; 
            iNFF.TW1_Grocc_Comum_percentual__c = 1;
            iNFF.TW1_Percentual_sobre_vendas__c = 1;
            iNFF.TW1_Area__c = 1;
            iNFF.TW1_Grupo_de_atividade__c = '';
            iNFF.TW1_Ramo_de_atividade__c = ''; 
            iNFF.TW1_Tipo_de_Atividade__c = '';
			insert iNFF;
        
        	TW1_Plano_de_mix__c plano = new TW1_Plano_de_mix__c();
        	plano.Name = 'sdf';
        	plano.Ramo_de_atividade__c = 'sads';
            plano.TW1_Grupo_de_atividade__c = 'asd';
            plano.TW1_Tipo_de_atividade__c = 'sadsa';
        	plano.Id_Externo__c = 'sadsa';
        	insert plano;
        
        	TW1_JuctionMarcaPlanoMix__c junction = new TW1_JuctionMarcaPlanoMix__c();
        	junction.TW1_Marca__c = acc.Id;
        	junction.Name = 'safdsa';
        	junction.TW1_Plano_de_mix__c = plano.Id;
       		insert junction;
        

        
        	TW1_Ancar_HistoricoTipoDeBusca tabelaHistorico = new TW1_Ancar_HistoricoTipoDeBusca();
        	tabelaHistorico.displayTabela = true;
            //tabelaHistorico.valorPesquisaShopping = shopping.Name;
        	tabelaHistorico.IdObjetoDisplay = shopping.Id; 
        	tabelaHistorico.MostraPesquisaSegmento();
        	tabelaHistorico.TelaInicio();
        	tabelaHistorico.MostraPesquisaMarca();
        	tabelaHistorico.MostraPesquisaShopping();
        	tabelaHistorico.ShowLuc();
        	tabelaHistorico.valorPesquisaSegmento = '';
        	tabelaHistorico.valorPesquisaLuc = '1';
        	tabelaHistorico.valorPesquisaMarca = acc.Id;
        	tabelaHistorico.tabelaHistorica = New List<TW1_Informacoes_historicas__c>();
   			tabelaHistorico.InftabelaHistorica = New List<TW1_Informacoes_historicas__c>();
    	    tabelaHistorico.ListShoppingsSegmento = new List<TW1_Shopping__c>();
   			tabelaHistorico.ListShoppingsluc = new List<TW1_Shopping__c>();
            tabelaHistorico.shoppingId = '';
            tabelaHistorico.lucName = '';
            tabelaHistorico.marcaBuscada = '';
            tabelaHistorico.segmentoBuscado = '';
            tabelaHistorico.lucBuscada = '';
            tabelaHistorico.shoppingBuscado = '';
        	tabelaHistorico.NomeDoMarca = acc.Name;
            tabelaHistorico.NomeDaLuc = propriedade.Name;   
        	tabelaHistorico.shoppingBuscado = shopping.Id;
        	tabelaHistorico.displayRetornoPesquisa =true;
            tabelaHistorico.SegmentoRamo = '';
            tabelaHistorico.accountsIds = new Map<Id,Account>();
            tabelaHistorico.NomeDoSegmento ='';
        
        
        	tabelaHistorico.getShoppingsSegmento();
        
        	tabelaHistorico.valorPesquisaSegmento = 'dolar';
        	tabelaHistorico.getSegmento();
        	tabelaHistorico.valorPesquisaSegmento = '';
        	tabelaHistorico.getSegmento();
        
        	//TW1_Shopping__c dd = TW1_Ancar_HistoricoTipoDeBusca.getShopping('Teste Shopping 2');
       		//TW1_Shopping__c dc = TW1_Ancar_HistoricoTipoDeBusca.getShopping('');
       		tabelaHistorico.valorPesquisaShoppinLuc = 'Luc';
        	tabelaHistorico.getLucsByLuc();
        	tabelaHistorico.valorPesquisaShoppinLuc = '';
        	tabelaHistorico.getLucsByLuc();
        	tabelaHistorico.valorPesquisaShoppinLuc = 'zzcxz';
        	tabelaHistorico.getLucsByLuc();
        	
        	tabelaHistorico.getTabelaHistorica();
        	tabelaHistorico.tipodeBusca = 'marca';
        	tabelaHistorico.NomeDoMarca = 'zoa';
        	tabelaHistorico.getTabelaHistorica();
        
        	tabelaHistorico.valorPesquisaLuc = '';
        	tabelaHistorico.getShoppingsByMarca();
        	tabelaHistorico.getLucsByLuc();
        	List<TW1_Propriedade__c> listluc = TW1_Ancar_HistoricoTipoDeBusca.getLuc('Luc1', shopping.Id);
        	List<TW1_Propriedade__c> listlucc = TW1_Ancar_HistoricoTipoDeBusca.getLuc('L', shopping.Id);
        	tabelaHistorico.getMarca();
            tabelaHistorico.valorPesquisaMarca ='';
       		tabelaHistorico.getMarca();
        
        	tabelaHistorico.tipodeBusca = 'shopping_luc';
        	tabelaHistorico.getTabelaHistoricaLuc();
        
        	tabelaHistorico.NomeDaLuc = 'xzc';
        	tabelaHistorico.getTabelaHistoricaLuc();
        	tabelaHistorico.IdObjetoDisplay = plano.Id;
        	tabelaHistorico.shoppingId = shopping.Id;
        	tabelaHistorico.NomeDoShopping = 'Nova';
       		tabelaHistorico.tipodeBusca = 'segmento';
        	tabelaHistorico.getTabelaHistoricaSegmento();
        	tabelaHistorico.shoppingBuscado = 'a010R000000n9V7';
        	tabelaHistorico.getTabelaHistoricaSegmento();
        	
        
        	List<TW1_Informacoes_historicas__c> tabelaHistorica = new List<TW1_Informacoes_historicas__c>();
        	tabelaHistorica.add(iNF);
       		tabelaHistorica.add(iNFF);
        	List<TW1_Informacoes_historicas__c> s = TW1_Ancar_HistoricoTipoDeBusca.SomatorioSegmento(tabelaHistorica);
        
        	

        Test.stopTest();
    }
  }