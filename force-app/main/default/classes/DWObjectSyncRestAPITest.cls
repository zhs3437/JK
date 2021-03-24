@isTest
public class DWObjectSyncRestAPITest {
    @isTest
    public static void testSync() {
        Contact contact = new Contact(LastName = 'Acme');
        insert contact;
        
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < 300; i++) {
            contacts.add(new Contact(LastName = 'Test' + i));
        }
        insert contacts;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/DWObjectSyncRestAPI'; 
        req.addParameter('tableName', 'contact');
        req.addParameter('pageSize', '200');
        req.addParameter('maxLength', '1');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        DWObjectSyncRestAPI.doGet();
    }
}