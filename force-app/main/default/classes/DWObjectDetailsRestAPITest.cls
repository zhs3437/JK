@isTest
public class DWObjectDetailsRestAPITest {
    @isTest
    public static void testApi() {        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/DWObjectDetailsRestAPI'; 
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;        
        DWObjectDetailsRestAPI.doGet();
    }
}