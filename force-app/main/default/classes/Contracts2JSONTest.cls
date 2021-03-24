@isTest
public class Contracts2JSONTest {
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
         Contract con        = TestHelper.createContract(aAccount.Id);
        //convert opportunity to json
		string opportunityId = con.id;
		string resultObject2Json = Contracts2JSON.Object2Json(opportunityId);
		Folder a =new Folder();
        
		// save jason to document
		Folder f = [select id from Folder where Name=:'ConDiffTemplate' limit 1];
		string tempFolderId = f.id;
		//  test saveAsDocument
		Document doc =  Contracts2JSON.saveAsDocument(tempFolderId,resultObject2Json); 
		system.debug('documentId:' + doc.id);

        Folder f1 = [select id from Folder  limit 1];
		string tempFolderId1 = f1.id;
		//  test saveAsDocument
		Document doc1 =  Contracts2JSON.saveAsDocument(tempFolderId1,resultObject2Json); 
		system.debug('documentId:' + doc.id);

		//load document to json
		string documentId = doc.id;
		//  test loadDocument
		String resultLoadDocument =  Contracts2JSON.loadDocument(documentId);
		
		//		
		string jsonContent = resultLoadDocument;
		system.debug('resultObject2Json:' + resultObject2Json);
		//  test Json2Object
		 Contract resultJson2Object = Contracts2JSON.Json2Object(jsonContent);
 Contracts2JSON.Json2LineList(jsonContent);
        Test.stopTest();
        
        

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }


}