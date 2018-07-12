public class Cal_EmailUtils_cls {
    
     public static void sendEmail(String[] paToAddresses, String[] paCcAddresses, String paSubject, 
                                 String paPlainTextBody, String paHtmlBody, String finalString, String NomeAttac ){
                                     
        // First, reserve email capacity for the current Apex transaction to ensure
        // that we won't exceed our daily email limits when sending email after
        // the current transaction is committed.
        Messaging.reserveSingleEmailCapacity(2);
        
        // Processes and actions involved in the Apex transaction occur next,
        // which conclude with sending a single email.
        
        // Now create a new single email message object
        // that will send out a single email to the addresses in the To, CC & BCC list.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Strings to hold the email addresses to which you are sending the email.
        String[] toAddresses = paToAddresses; 
        String[] ccAddresses = paCcAddresses;
                
        //Envio de anexo                             
        if(finalString != null && NomeAttac != null){                             
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
		blob csvBlob = Blob.valueOf(finalString);
		csvAttc.setFileName(NomeAttac);
		csvAttc.setBody(csvBlob);
            
		mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        }
                                                                 
        // Assign the addresses for the To and CC lists to the mail object.
        if(toAddresses != null)
          mail.setToAddresses(toAddresses);
        if(ccAddresses != null)
          mail.setCcAddresses(ccAddresses);
        
        // Specify the address used when the recipients reply to the email. 
        mail.setReplyTo('noreplay@Ancar.com');
        
        // Specify the name used as the display name.
        mail.setSenderDisplayName('Ancar-Salesforce');
        
        // Specify the subject line for your email address.
        mail.setSubject(paSubject);
        
        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);
        
        // Optionally append the salesforce.com email signature to the email.
        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(false);
        
        // Specify the text content of the email.
        mail.setPlainTextBody(paPlainTextBody);
        
        mail.setHtmlBody(paHtmlBody);
        //'Your case:<b> ' + case.Id +' </b>has been created.<p>'+
        //'To view your case <a href=https://***yourInstance***.salesforce.com/'+case.Id+'>click here.</a>');
        
        Boolean vaAtLeastOnEmailToSend = toAddresses != null || toAddresses != null;                                     
    if(vaAtLeastOnEmailToSend) 
        {
          // Send the email you have created.
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });        
        }
  }
}