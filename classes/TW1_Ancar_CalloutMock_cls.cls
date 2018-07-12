global class TW1_Ancar_CalloutMock_cls implements HttpCalloutMock{
   
    global HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('http://api.postmon.com.br/v1/cep/24350326', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
       
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"bairro": "Piratininga", "cidade": "Niter\u00f3i", "logradouro": "Rua Delfina de Jesus (Lot Sto Ant\u00f4nio)", "estado_info": {"area_km2": "43.781,566", "codigo_ibge": "33", "nome": "Rio de Janeiro"}, "cep": "24350326", "cidade_info": {"area_km2": "133,919", "codigo_ibge": "3303302"}, "estado": "RJ"}');
        res.setStatusCode(200);
        return res;
    }
}