@RestResource(urlMapping='/rc/*')
global without sharing class RC_Rest  {

    static String method = Restcontext.request.requestURI.removeStartIgnoreCase('/rc/');
    static Map<String, Object> params = Restcontext.request.params;
    static RC_Service service;

    static {
        Restcontext.response.addHeader('Access-Control-Allow-Origin', '*');

        if (String.isBlank(method)) {

            Restcontext.response.statuscode = 400;
        } else {

            service = ((RC_Service)Type.forName(RC_Service.class + '.' + method).newInstance()).init(Restcontext.request, Restcontext.response);
        }
    }

    @HttpGet
    global static void sql () {
        RestResponse response =  Restcontext.response;
        if (String.isBlank(method)) return;

        response.responseBody = Blob.valueOf(service.execute(params));
        response.headers.put('Content-Type', 'application/json;charset=UTF-8');
    }

    @HttpPost
    global static void dml () {
        RestResponse response =  Restcontext.response;
        if (String.isBlank(method)) return;

        response.responseBody = Blob.valueOf(service.execute(params));
        response.headers.put('Content-Type', 'application/json;charset=UTF-8');
    }
}