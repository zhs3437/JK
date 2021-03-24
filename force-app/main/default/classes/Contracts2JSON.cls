public class Contracts2JSON {
    public static string Object2Json(string opportunityId){
    	string jsonContent = '';
		try{
	    	List<Contract> obj = [Select id,ApprovalCounts__c,Approval_Status__c,Total_MW__c,Total_Price__c,Total_Quantity__c,Trade_Term__c,Destination_Country__c,Seller__c ,
                                        (select id,Amount__c,Percentage__c,Down_Balance_Payment__c,Payment_Method__c,Days__c,Payment_Term__c,Contract__c from Payment__r ),
	    	                         	(Select Id,Total_MW__c,Guaranteed_Delivery_Date__c,Total_Price__c,Quantity__c,Unit_Price__c,Contract_PO_PI__c,Product__c,Delivery_Date__c,Junction_Box_Type__c from Product_Detail__r ) 
	    	                         	from Contract
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
    public static Contract Json2Object(string jsonContent){
    	Contract obj = null;
        try{
			obj = (Contract)JSON.deserialize( jsonContent , Contract.class );
		}catch( Exception ex ){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error JSON deserialize'));
		}
    	return obj;
    }
    public static  List<Product_Detail__c> Json2LineList(string jsonContent){
        system.debug('jsonContent===:'+jsonContent);
        List<Product_Detail__c>  ConLineLst = null;
        try{
                      
             ConLineLst.addAll((List<Product_Detail__c>)JSON.deserialize(jsonContent , Product_Detail__c.class));
        }catch( Exception ex ){
            system.debug('出错了！！！');  //sam
			//ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error JSON deserialize'));
		}
        return ConLineLst;
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
            system.debug('-----------------'+e.getMessage());
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