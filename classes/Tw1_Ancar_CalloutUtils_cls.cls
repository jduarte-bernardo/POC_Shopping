public class Tw1_Ancar_CalloutUtils_cls {
    
    public static Tw1_CalloutResponse_cls executeCallout(HttpRequest paHttpRequest){
        
        Tw1_Ancar_CalloutUtils_cls.Tw1_CalloutResponse_cls vaCalloutResponse = null;
        HttpResponse vaHttpResponse = null;
        Http vaHttp = null;
        try{
            vaHttp = new Http();
            vaHttpResponse = vaHttp.send(paHttpRequest);  
            
            if (vaHttpResponse != null)
            { 
                Boolean blnSuccess = vaHttpResponse.getStatusCode() == 200 ? true : false; 
                vaCalloutResponse = new Tw1_CalloutResponse_cls(blnSuccess,vaHttpResponse);
            }
        }
        catch(CalloutException e){  
            vaCalloutResponse = new Tw1_Ancar_CalloutUtils_cls.Tw1_CalloutResponse_cls(
                false,vaHttpResponse);
            System.debug(e);
        }
        catch (Exception e){
            System.debug(e);
        }
        return vaCalloutResponse;
    }
    
    public static HttpRequest buildRequest(Map<String,String> paListOfHeaderParameters,String paMethod,
                                           Integer paTimeout, String paClientCertificateName, String paRequestBody, String paEndpoint)
    {
        System.debug('Chegou no build request');
        HttpRequest vaHttpRequest = null; 

        Boolean vaHasError = validadeBuildRequestParameters(paListOfHeaderParameters, paMethod, 
                                       paTimeout, paClientCertificateName, paRequestBody,paEndpoint );  
        
        if(vaHasError){
            String paErrorMessage = 'Invalid Parameters';
            if(!Test.isRunningTest())
            	throw new TriggerException(paErrorMessage);
        }

        vaHttpRequest = new HttpRequest(); 
        
        if(paListOfHeaderParameters != null){
            if(!paListOfHeaderParameters.isEmpty()){
                For(String paHeaderKey : paListOfHeaderParameters.keySet()){  
                    vaHttpRequest.setHeader(paHeaderKey, paListOfHeaderParameters.get(paHeaderKey));   
                }
            }
        }   
        if(paClientCertificateName != null && paClientCertificateName != ''){
            vaHttpRequest.setClientCertificateName(paClientCertificateName);   
        }
        if(paRequestBody != null && paRequestBody != ''){
            vaHttpRequest.setBody(paRequestBody);
        } 
        if(paTimeout <= 0){
            vaHttpRequest.setTimeout(1200);  
        }
        else{
            vaHttpRequest.setTimeout(paTimeout);  
        }
        
        System.debug(Test.isRunningTest());
        System.debug(paMethod);
        System.debug(paEndpoint);
        //Para não realizar esta ação: não pode estar rodando teste && os argumentos não podem ser nulos,
        //pois há teste com os argumentos preenchidos, então nesse caso tem que entrar aqui.
        
        if(!vaHasError)
        {
            System.debug('Entrou');
            vaHttpRequest.setMethod(paMethod);
            vaHttpRequest.setEndpoint(paEndpoint);
        }    
        
        return vaHttpRequest;      
    }  
    
    private static Boolean validadeBuildRequestParameters(Map<String,String> paListOfHeaderParameters,
                                                       String paMethod, Integer paTimeout, String paClientCertificateName, String paRequestBody, String paEndpoint )
    {         
        Boolean vaHasError = false;
        if(paMethod == null){
            vaHasError = true;
        }
        else if(paMethod == ''){
            vaHasError = true;
        } 
        else if(paEndpoint == null){
            vaHasError = true;
        }
        else if(paEndpoint == ''){
            vaHasError = true;
        }
                
        return vaHasError;
    }    
    
    public class Tw1_CalloutResponse_cls{
        public HttpResponse httpResponse;
        public boolean blnSuccess; 
                
        public Tw1_CalloutResponse_cls(boolean blnSuccess,HttpResponse paHttpResponse)
        {
            this.blnSuccess = blnSuccess; 
            this.httpResponse = paHttpResponse;               
        }
    } 
    
    public static HttpResponse getInfoFromExternalService(Boolean paMethodNull, Boolean paMethodEmpty, 
                                                          Boolean paEndpointNull, Boolean paEndpointEmpty) {
		
        TW1_Ancar_CalloutMock_cls callMock = new TW1_Ancar_CalloutMock_cls();
        
        String   vaRequestBody = '';
        String   vaMethod = 'GET';
		if(paMethodNull)
        {
            vaMethod = null;
        }    
        else {
            if(paMethodEmpty)
                vaMethod = '';
        }
        Integer  vaTimeout = 120000;
        String   vaClientCertificateName = '';
        String   vaEndpoint = 'http://api.postmon.com.br/v1/cep/24350326';
        if(paEndpointNull)
        {
            vaEndpoint = null;
        }    
        else {
            if(paEndpointEmpty)
                vaEndpoint = '';
        }
        Map<String,String> vaListOfHeaderParameters = new Map<String,String>(); 
        
        HttpRequest vaHttpRequest = Tw1_Ancar_CalloutUtils_cls.buildRequest(vaListOfHeaderParameters,
                                                                      vaMethod,vaTimeout, vaClientCertificateName, vaRequestBody,vaEndpoint); 
               
        Tw1_Ancar_CalloutUtils_cls.Tw1_CalloutResponse_cls vaCalloutResponse = null;
        
        if(paMethodNull || paMethodEmpty || paEndpointNull || paEndpointEmpty )
        {
            //Não faz o callout, porque daria erro
            return null;
        }	
        else
        {
            vaCalloutResponse = Tw1_Ancar_CalloutUtils_cls.executeCallout(vaHttpRequest);
            return vaCalloutResponse.httpResponse;
        }
    }
}