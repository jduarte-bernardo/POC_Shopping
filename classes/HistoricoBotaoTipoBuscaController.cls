public class HistoricoBotaoTipoBuscaController {
	@AuraEnabled
    public static Boolean profileGerenteRegional(){
        
        Id idProfileUser = UserInfo.getProfileId();
        
        Profile perfil = [SELECT Name FROM Profile WHERE Id = :idProfileUser LIMIT 1];
        
        return (perfil.Name == 'Gerente Regional' || perfil.Name == 'Comercial EC' || perfil.Name == 'Administrador do sistema' || perfil.Name == 'System Administrator');
        
    }
}