@isTest
public class TW1_Sinc_Google_com_ContaHandler_Test {
	
    @isTest static void CriaAccount_Test(){
		
        RecordType vaRecordType  = [select id, Name from RecordType where Name ='Contato' limit 1];

        Contact vaContato = new Contact();
        vaContato.FirstName = 'Teste Google';
        vaContato.LastName = '01';
        vaContato.Phone ='2133334444';
        vaContato.MobilePhone ='21999845758';
        vaContato.Email ='wrodrigues@triscal.com.br';
        vaContato.RecordTypeId = vaRecordType.id;
        
        Test.startTest();
        	Database.SaveResult result1=Database.insert(vaContato,false);
        Test.stopTest();
        
        System.assert(result1.isSuccess()); 

    }
    
   
    
}