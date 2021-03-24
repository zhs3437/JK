public class ShowDeliveryCtrl {
	
	public List<Delivery__c> existDeliveryList{get;set;}
	
	public String requestId{get;set;}
	
	public ShowDeliveryCtrl(){
		requestId = ApexPages.currentPage().getParameters().get('orderid');
	}
	
	public void ModeList(){
		
		if(requestId != null){
			existDeliveryList = Database.query( Utils.MakeSelectSql('Delivery__c')+' WHERE Order__c =: requestId');
		}
		
	}
	
}