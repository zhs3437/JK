public with sharing class Opportunity2JSON {
	/*
	 * convert opportunity object to xml
	 * paramter: opportunity object id.
	 */
    public static string Object2Json(string opportunityId){
    	string jsonContent = '';
		try{
	    	List<Opportunity> obj = [select id,Total_MW__c,Total_Power__c,Total_Price__c,Total_Quantity__c,Trade_Term__c,Destination_Country__c,Seller__c,Commision__c,Expect_Price_and_Comments__c,
                                        (select id,Amount__c,Percentage__c,Down_Balance_Payment__c,Payment_Method__c,Days__c,Payment_Term__c,Opportunity__c from Payment__r ),
	    	                         	(select id,Total_Power_W__c,Total_MW__c,Tolerance__c,Quantity,UnitPrice,Total_Price__c,Product2Id,Product__c,Type_of_module__c,Guaranteed_Delivery_Date__c from OpportunityLineItems ) 
	    	                         	from Opportunity 
	    	                         	where id=:opportunityId limit 1];
            system.debug('obj=====:'+obj);  //sam
	    	if(obj.size()>0){
	    		jsonContent = JSON.serialize( obj.get(0));
                system.debug('jsonContent=====:'+jsonContent);  //sam
	    	}
		}catch( Exception ex ){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error JSON serialize'));
		}
    	return jsonContent;
    }
	/*
	 * convert xml to opportunity
	 * paramter: xml Content.
	 */
    public static Opportunity Json2Object(string jsonContent){
    	Opportunity obj = null;
       // List<OpportunityLineItem> OpportunityLineItemsList = new List<OpportunityLineItem>();
       // List<Payment__c> PayLst =new List<Payment__c>();
		try{
			obj = (Opportunity)JSON.deserialize( jsonContent , Opportunity.class );
         //   OpportunityLineItemsList.add((OpportunityLineItem)JSON.deserialize(jsonContent , OpportunityLineItem.class));
        //    system.debug('OpportunityLineItemsList-->'+OpportunityLineItemsList);
        //    PayLst.add((Payment__c)JSON.deserialize(jsonContent , Payment__c.class));
        //    system.debug('PayLst-->'+PayLst);
		}catch( Exception ex ){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error JSON deserialize'));
		}
    	return obj;
    }
    public static  List<OpportunityLineItem> Json2LineList(string jsonContent){
        system.debug('jsonContent===:'+jsonContent);
        List<OpportunityLineItem>  OppLineLst = null;
        try{
              system.debug('123123123');            
             OppLineLst.addAll((List<OpportunityLineItem>)JSON.deserialize(jsonContent , OpportunityLineItem.class));
        }catch( Exception ex ){
            system.debug('出错了！！！');  //sam
			//ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error JSON deserialize'));
		}
        return OppLineLst;
    }
    

	/*
	 * save json to document file
	 * paramter: tempFolderId temp folder id and json Content.
	 */
    public static Document saveAsDocument(string tempFolderId,string jsonContent){
    	Document document = new document(Name='tempDocument');
		document.AuthorId = UserInfo.getUserId();
		if(!string.isEmpty(tempFolderId)){
			document.FolderId = tempFolderId;
		}
		Blob blobRecord = Blob.valueOf( jsonContent );
		document.Body = blobRecord;
		document.IsPublic = true;
		try {
			insert document;
			return document;
		} catch (Exception e) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file:' + e.getMessage()));
		} 
		return document;
    }
    
	/*
	 * save json to document file
	 * paramter: tempFolderId temp folder id and json Content.
	 */
    public static string loadDocument(string documentId){
		try {
			Document document = [SELECT Id,
	    	            Body, 
	    	            Name
    				FROM Document
    				Where Id=:documentId limit 1];
			Blob docBlob = document.Body;
			String jsonContent = docBlob.toString();
			return jsonContent;
		} catch (Exception e) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error load json file:' + e.getMessage()));
		} 
		return null;
    }
}