public  class AmendmentPurchaseAgreementCtrl {
	public List<Amendment__c> sas = new List<Amendment__c> ();
	// 创建日期
	class TodayTime{
		public String Day  {get;set;}
		public String Month{get;set;}
		public String Year {get;set;}
		public TodayTime(){
			Day   = String.valueOf(Date.today().Day());
			Month = String.valueOf(Date.today().Month());
			Year  = String.valueOf(Date.today().Year());
		}
	}
	
	// request Id
	public String requestId{get;set;}
	// Amendment Point
	public String amendmentPoint{get;set;}
	// Current Amendment__c
	public Amendment__c sa {get;set;}
	// Current Date
	public TodayTime tt{get;set;}
	// Current Date - Apex Date
	public Date tod{get;set;}
	//Current Amendment RecordType
	
	public String recordType{get;set;}
	
	
	public AmendmentPurchaseAgreementCtrl(){
		
		// init - 创建PA/PI日期
		tt = new TodayTime();
		// init - apex date
		tod = Date.today();
		// init - requestId - Amendment__c Id
		requestId = ApexPages.currentPage().getParameters().get('id');
		system.debug('~~~~~~~~ AmendmentId'+requestId);
		// init - Amendment__c
		if(requestId != null){
			sas = [select id,
						Amendment1__c,
						Amendment2__c,
						Amendment3__c,
						Amendment4__c,
						Amendment5__c,
						Amendment6__c,
						Amendment7__c,
						RecordType.Name,
						Amendment_Point__c,
						Contract_No__c,
						Seller_Name__c,
						Seller_Address__c,
						SEQ__c,
						Buyer_Name__c,
						Billing_Address__c,
						Previous_Amendment_Generation_Date__c,
						Total_MW__c,
						Purchase_Type__c,
						Print_Contract_Date__c
						from Amendment__c
						where Id =:requestId ];
			system.debug('~~~~~~~~ sas'+sas);
		}
		
		if(sas.size() > 0){
			sa = sas[0];
			amendmentPoint = String.valueOf(sa.Amendment_Point__c).replace(';',',');
			if(sa.RecordType.Name == 'Purchase Agreement (EN)'){
				recordType = 'Purchase Agreement';
			}else if(sa.RecordType.Name == 'Purchase Agreement (JP)'){
				recordType = 'Purchase Agreement';
			}else if(sa.RecordType.Name == 'Sales Contracts'){
				recordType = 'Sales Contracts';
			}else if(sa.RecordType.Name == 'Purchase Agreement'){
				recordType = 'Purchase Agreement';
			}
		}
/*
		system.debug('~~~~~~~~ AmendmentId'+'\n\t\t' + sa.Contract_No__c
							+'\n\t\t' + sa.Seller_Name__c
							+'\n\t\t' +  'RecordType.Name' + sa.RecordType.Name);
*/
        try{
			List<Information_of_Seller__c>  sellers = [select id,
															Address__c,
															Authorized_Signatory__c,
															Seller__c,
															Title__c 
															from Information_of_Seller__c 
															where Seller__c =: sa.Seller_Name__c];
															
			system.debug('~~~~~~~~ Information_of_Seller__c'+'\n\t\t' + sellers
							+'\n\t\t' + sa.Seller_Name__c);
							
			if(sellers.size() > 0){
				Information_of_Seller__c infoSeller = sellers[0];
				sa.Seller_Address__c = infoSeller.Address__c;
				
				system.debug('~~~~~~~~ Information_of_Seller__c'+'\n\t\t' + infoSeller.Address__c
							+ '~~~~~~~~ Seller_Address__c'+'\n\t\t' + sa.Seller_Address__c);
				
			}
        }catch(Exception ex){
        	System.debug('------> error: '+ex.getMessage());
        }
		
	}
	
	public void runTest(){
		String run = 'Test';
	}
}