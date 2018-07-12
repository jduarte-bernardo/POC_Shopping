public with sharing class TW1_Sinc_Google_com_ContaHandler {
    
    public static void CriaAccount(Contact vaContato){   
        
        RecordType vaRecordType  = [select id,Name from RecordType where id =:vaContato.RecordTypeId limit 1];
        RecordType vaRecordType2 = [select id,Name from RecordType where Name='Prospect' limit 1];
        
        if(vaRecordType.Name == 'Contato'){
            
            list<Account> conta = new list<Account>();
            
            Account act = new Account(
                FirstName = vaContato.FirstName,
                LastName  = vaContato.LastName,
                //Phone = formatString(vaContato.Phone),
                PersonMobilePhone = formatString(vaContato.MobilePhone),
                PersonEmail = vaContato.Email,
                TW1_Email__c = vaContato.Email,
                TW1_Email_comercial__c = vaContato.Email,
                RecordTypeId = vaRecordType2.Id
            );

            conta.add(act);
            Contact ctc = [select id from Contact where id=:vaContato.id limit 1];
            list<Account> actlist = [ Select PersonEmail,TW1_Email__c,TW1_Email_comercial__c from Account where recordType.Name ='Prospect' and  TW1_Email_comercial__c=:vaContato.Email limit 1];
            
            if(actlist.size() > 0){
                Account acc = [ select id from Account where recordType.Name ='Prospect' and TW1_Email_comercial__c =:vaContato.Email LIMIT 1 ];
                acc.FirstName = vaContato.FirstName;  acc.LastName  = vaContato.LastName; acc.Phone = formatString(vaContato.Phone); acc.PersonMobilePhone=formatString(vaContato.MobilePhone); acc.TW1_Email_comercial__c = vaContato.Email;
                upsert acc;
                Delete ctc;
            }else{
                try{
                    if (conta.size() > 0) {
                        insert conta;
                        Delete ctc;
                    }
                }catch(Exception ex){ 
                    System.debug(ex.getMessage());
                }
            }	
        }
    }
    public static String formatString(String vaEntrada){
        return vaEntrada.replace('[]','').replace('&quot;','').replace('(','').replace(')','').replace(' ','').replace('-','');
    }
    
    
}