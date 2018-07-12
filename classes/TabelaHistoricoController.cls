public class TabelaHistoricoController {
    @AuraEnabled
    public static List<	TW1_Informacoes_historicas__c> getTabelaHistorica(String shoppingId, String lucName, String marcaBuscada, Map<Id,Account> AccountsIds, String segmentoBuscado, String lucBuscada, String shoppingBuscado, String tipoBusca){
        List<TW1_Informacoes_historicas__c> tabelaHistorica = new List<TW1_Informacoes_historicas__c>();
        List<TW1_Informacoes_historicas__c> InftabelaHistorica = new List<TW1_Informacoes_historicas__c>();
	
        if(marcaBuscada != null && tipoBusca=='marca'){
            
            List<Account> marca = getListMarca(marcaBuscada);
			Map<Id,Account> accountsId = new Map<Id,Account>(marca);
            
            tabelaHistorica = 
                [
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
                    TW1_Ramo_de_atividade__c
                    FROM TW1_Informacoes_historicas__c
                    WHERE TW1_Shopping__c = :shoppingId
                    AND TW1_Marca__c IN :accountsId.keySet() ORDER BY Name DESC
                ];
        }else if(segmentoBuscado != null && tipoBusca=='segmento'){
            TW1_Plano_de_mix__c segmentoId = getSegmento(segmentoBuscado);
            tabelaHistorica = 
                [
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
                    TW1_Ramo_de_atividade__c
                    
                    FROM TW1_Informacoes_historicas__c
                    WHERE TW1_Shopping__c = :shoppingId And
                    TW1_Marca__c IN (
                	SELECT TW1_Marca__c
                    FROM TW1_JuctionMarcaPlanoMix__c
                    WHERE TW1_Plano_de_mix__c = :segmentoId.Id
                ) ORDER BY Name DESC
                ];
        }else if(lucBuscada != null && tipoBusca=='shopping_luc'){
            
            TW1_Propriedade__c prop = [SELECT Id FROM TW1_Propriedade__c where Name =:lucName];
            
            tabelaHistorica = 
                [
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
                    TW1_Ramo_de_atividade__c
                    
                    FROM TW1_Informacoes_historicas__c
                    WHERE TW1_Shopping__c = :shoppingId And
                    TW1_Propriedade__c = :prop.Id ORDER BY Name DESC
                ];
        }
        
         InftabelaHistorica = new List<TW1_Informacoes_historicas__c>();
        
        Set<String> IdsHisto = new Set<String>();

        for(TW1_Informacoes_historicas__c tabhisto : tabelaHistorica){
            IdsHisto.add(tabhisto.TW1_Marca__c);
        }
            
        List<TW1_JuctionMarcaPlanoMix__c> listMap = [select TW1_Plano_de_mix__c,Name,TW1_Marca__c from TW1_JuctionMarcaPlanoMix__c where TW1_Marca__c IN :IdsHisto];
        Map<Id,TW1_JuctionMarcaPlanoMix__c> listjunt = new Map<Id,TW1_JuctionMarcaPlanoMix__c>(listMap);
        
        List<account> accc = [Select Id,Name From account where Id IN :listjunt.keySet()];
        Map<Id,account> acontMap = new Map<Id,account>(accc);
        
		 Set<String> IdsPlanoMix = new Set<String>();
        
        for(TW1_Informacoes_historicas__c listtabelaHistorica : tabelaHistorica){
        for(TW1_JuctionMarcaPlanoMix__c juntionMixx : listMap){          
                if(juntionMixx.TW1_Marca__c == listtabelaHistorica.TW1_Marca__c){
                    IdsPlanoMix.add(juntionMixx.TW1_Plano_de_mix__c);
                }
        }} 
        
         List<TW1_Plano_de_mix__c> ListPlanoMix = [select TW1_Grupo_de_atividade__c,Ramo_de_atividade__c,TW1_Tipo_de_atividade__c from TW1_Plano_de_mix__c where Id IN :IdsPlanoMix];
         Map<Id,TW1_Plano_de_mix__c> MapPlanoMix = new Map<Id,TW1_Plano_de_mix__c>(ListPlanoMix);
        
        
        for(TW1_Informacoes_historicas__c InfHistorico : tabelaHistorica)
        {
            InfHistorico.TW1_Nome_fantasia__c = '';
            InfHistorico.TW1_Grupo_de_atividade__c = '';
            InfHistorico.TW1_Ramo_de_atividade__c = '';
            InfHistorico.TW1_Tipo_de_Atividade__c = '';
            List<TW1_JuctionMarcaPlanoMix__c> ListJuntionMix = new List<TW1_JuctionMarcaPlanoMix__c>(); 

            for(TW1_JuctionMarcaPlanoMix__c juntionMix : listMap){
                if(juntionMix.TW1_Marca__c == InfHistorico.TW1_Marca__c){
                    ListJuntionMix.add(juntionMix);
                }
            }
            
            for(TW1_JuctionMarcaPlanoMix__c Junction : ListJuntionMix)
            {
                
                account acc = acontMap.get(Junction.TW1_Marca__c);
                
                if(acc != null)
                InfHistorico.TW1_Nome_fantasia__c = acc.Name == null ? '':acc.Name;
                
                TW1_Plano_de_mix__c PlanoMixJunction = MapPlanoMix.get(Junction.TW1_Plano_de_mix__c); 
                
                    if(PlanoMixJunction.TW1_Grupo_de_atividade__c != null)
                        InfHistorico.TW1_Grupo_de_atividade__c = InfHistorico.TW1_Grupo_de_atividade__c + PlanoMixJunction.TW1_Grupo_de_atividade__c +'/';
                    if(PlanoMixJunction.Ramo_de_atividade__c != null)
                        InfHistorico.TW1_Ramo_de_atividade__c = InfHistorico.TW1_Ramo_de_atividade__c + PlanoMixJunction.Ramo_de_atividade__c +'/';
                    if(PlanoMixJunction.TW1_Tipo_de_atividade__c != null)
                        InfHistorico.TW1_Tipo_de_Atividade__c = InfHistorico.TW1_Tipo_de_Atividade__c + PlanoMixJunction.TW1_Tipo_de_atividade__c +'/';				                        
            }
            InftabelaHistorica.add(InfHistorico);
        }
        
        insertAuditoriaInfHistorica(lucName, marcaBuscada, segmentoBuscado, shoppingBuscado, tipoBusca);
        
        if(segmentoBuscado != null && (tipoBusca=='segmento' || tipoBusca=='shopping_luc'))
        {
            return SomatorioSegmento(InftabelaHistorica);
        }  
        
        
        return InftabelaHistorica;
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
            	//System.debug('2----- Infor.TW1_Venda_Total__c' + inf.TW1_Venda_Total__c);
                //System.debug('2----- Infor.Vendas_Total_m2__c' + inf.Vendas_Total_m2__c);
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
                    //System.debug('3----- inf.TW1_Venda_Total__c + InfHisto.TW1_Venda_Total__c' + inf.TW1_Venda_Total__c);
                	//System.debug('3----- inf.Vendas_Total_m2__c + InfHisto.Vendas_Total_m2__c' + inf.Vendas_Total_m2__c);
                    
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
    
    public static List<Account> getListMarca(String strMarca){
        List<Account> listaMarcasEqual = [SELECT Name FROM Account WHERE RecordType.Name='Marca' And Name = :strMarca];
        
        if(listaMarcasEqual.size() >= 1){
            return listaMarcasEqual;
        }else{
            String strMarcaLike = '%' + strMarca + '%';
            List<Account> listaMarcasLike = [SELECT Name FROM Account WHERE RecordType.Name='Marca' And Name LIKE :strMarcaLike ];
            
            if(listaMarcasLike.size() >= 1){
                return listaMarcasLike;
            }else{
                return new List<Account>();
                
            }
        }
    }

    public static TW1_Plano_de_mix__c getSegmento(String strSegmento){

        List<TW1_Plano_de_mix__c> listaSegmentosEqual = [SELECT Name,Ramo_de_atividade__c FROM TW1_Plano_de_mix__c WHERE Ramo_de_atividade__c = :strSegmento];

        if(listaSegmentosEqual.size() >= 1){
            return listaSegmentosEqual.get(0);
        }else{
            String strSegmentoLike = strSegmento + '%';
            List<TW1_Plano_de_mix__c> listaSegmentosLike = [SELECT Name,Ramo_de_atividade__c FROM TW1_Plano_de_mix__c WHERE Ramo_de_atividade__c LIKE :strSegmentoLike ];
            
            if(listaSegmentosLike.size() == 0)
              return null;
                
            return listaSegmentosLike.get(0);
            /*
            if(listaSegmentosLike.size() >= 1){
                List<String> listaSegmentosLikeStr = new List<String>();
                for(TW1_Plano_de_mix__c segmentoLike : listaSegmentosLike){
                    listaSegmentosLikeStr.add(segmentoLike.Ramo_de_atividade__c);
                }
                Integer moreSimilarSegmentoIndex = Util.getClosestString(strSegmento, listaSegmentosLikeStr);
               
                return listaSegmentosLike.get(moreSimilarSegmentoIndex);
            }else{
                List<TW1_Plano_de_mix__c> listaSegmentosAll = [SELECT Ramo_de_atividade__c FROM TW1_Plano_de_mix__c];
                
                List<String> listaSegmentosAllStr = new List<String>();
                for(TW1_Plano_de_mix__c segmentoAll : listaSegmentosAll){
                    listaSegmentosAllStr.add(segmentoAll.Ramo_de_atividade__c);
                }
                
                Integer moreSimilarSegmentoIndex = Util.getClosestString(strSegmento, listaSegmentosAllStr);
                
                return listaSegmentosAll.get(moreSimilarSegmentoIndex);
                
            }*/
        }
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