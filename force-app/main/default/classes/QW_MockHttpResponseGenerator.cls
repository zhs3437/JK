@isTest
global class QW_MockHttpResponseGenerator implements HttpCalloutMock, WebServiceMock {
    
    global HttpResponse res = new HttpResponse();
    global Object responseElement;
    global String body = '{}';

    global HTTPResponse respond(HTTPRequest req) {
        res.setHeader('Content-Type', 'application/json');
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }

    global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {

        response.put('response_x', responseElement); 
   }
}