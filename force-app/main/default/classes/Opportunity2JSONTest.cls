@isTest
public class Opportunity2JSONTest {
    static testMethod void test_all() {

 Test.startTest();


	    Account aAccount= new Account(Name = 'Test');
	    insert aAccount;       
		
		
        Product2 p = new Product2(name ='Product' + Math.random());
        insert p;
        
        PriceBookEntry entry =new PriceBookEntry(
                PriceBook2ID= Test.getStandardPriceBookID(),
                product2ID= p.id,
                unitPrice = 120,
                UseStandardPrice =false,
                isActive = true
        );
        insert entry;
        Opportunity opp = new Opportunity();
        OpportunityLineItem oppLineItem = new OpportunityLineItem(
                OpportunityId               = opp.id,
                Quantity                    = 100,
                TotalPrice                  = 120.00,
                PricebookEntryId            = entry.id
            );
        
        //convert opportunity to json
		string opportunityId = opp.id;
		string resultObject2Json = Opportunity2JSON.Object2Json(opportunityId);
		
		// save jason to document
		Folder f = [select id from Folder limit 1];
		string tempFolderId = f.id;
		//  test saveAsDocument
		Document doc = Opportunity2JSON.saveAsDocument(tempFolderId,resultObject2Json); 
		system.debug('documentId:' + doc.id);

		//load document to json
		string documentId = doc.id;
		//  test loadDocument
		String resultLoadDocument = Opportunity2JSON.loadDocument(documentId);
		
		//		
		string jsonContent = resultLoadDocument;
		system.debug('resultObject2Json:' + resultObject2Json);
		//  test Json2Object
		Opportunity resultJson2Object = Opportunity2JSON.Json2Object(jsonContent);
Opportunity2JSON.Json2LineList(jsonContent);
        Test.stopTest();
        
        

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }


}