/**
 *create by Jason 20160621
 *生成补充协议
 */
public class CreateAmendmentCtrl {
	
	public Amendment__c amendment{get;set;}
	
	
	public CreateAmendmentCtrl(ApexPages.Standardcontroller sd){
		amendment = (Amendment__c)sd.getRecord();
	}
	
	public PageReference generateAmendment(){
		
		//TODO: filling the values
		Order ord = new Order();
		try{
			List<Order> ordList = [select id,
										SEQ__c,
										Buyer__r.Name,
										BillingCountry,
										BillingPostalCode,
										BillingState,
										BillingCity,
										BillingStreet,
										Contract_NO__c,
										SELLER__c,
										Total_MW__c,
										ContractId,
										Previous_Amendment_Generation_Date__c,
										Lock__c
										from Order
										where id =: amendment.Order__c];
			if(ordList.size() > 0){
				ord = ordList[0];
			}
			
			System.debug('~~~~~~>Ord.BillingCountry:' + ord.BillingCountry);
			System.debug('~~~~~~>Ord.BillingPostalCode:' + ord.BillingPostalCode);
			System.debug('~~~~~~>Ord.BillingState:' + ord.BillingState);
			System.debug('~~~~~~>Ord.BillingCity:' + ord.BillingCity);
			System.debug('~~~~~~>Ord.BillingStreet:' + ord.BillingStreet);
			System.debug('~~~~~~>Ord.id:' + ord.id);
			
			amendment.Buyer_Name__c = ord.Buyer__r.Name;			//买方名

			String billing = '';
			if(ord.BillingCountry != null){
				billing += ord.BillingCountry + '\n';
			}
			if(ord.BillingPostalCode != null){
				billing += ord.BillingPostalCode + '\n';
			}
			if(ord.BillingState != null){
				billing += ord.BillingState + '\n';
			}
			if(ord.BillingCity != null){
				billing += ord.BillingCity + '\n';
			}
			if(ord.BillingStreet != null){
				billing += ord.BillingStreet;
			}
				
			amendment.Billing_Address__c = billing;		//买方的地址
			
			amendment.Contract_No__c = ord.Contract_NO__c;			//合同号
			//amendment.Contract_Creation_Date__c = 				//原合同的生成日
			//amendment.Previous_Contract_Creation_Date__c = 		//历次修改协议的日期
			//amendment.Amendment_Point__c = 						//手动选择的项目的信息
			amendment.SEQ__c = ord.SEQ__c;   						//生成补充协议的编号
			amendment.Seller_Name__c = ord.SELLER__c;				//卖方名 
		    //amendment.Seller_Address__c = 				//卖方的地址 
			amendment.Total_MW__c = ord.Total_MW__c;				//合同中货物的总量
			
			System.debug('~~~~~~~~> BillingAddress:' + amendment.Billing_Address__c);	
		
			insert amendment;
			
			if(ord.Previous_Amendment_Generation_Date__c == null)ord.Previous_Amendment_Generation_Date__c = '';
			if(ord.SEQ__c != 1){
				ord.Previous_Amendment_Generation_Date__c += String.valueOf(Date.today())+',';
			}
			ord.SEQ__c += 1;
			if(ord.Lock__c == true){
				ord.Lock__c = false;
				update ord;
				ord.Lock__c = true;
				update ord;
			}else if(ord.Lock__c == false){
				update ord;
			}
				
			return new ApexPages.StandardController(amendment).view();
		
		}catch(Exception e){
			System.debug('-----> '+e.getMessage());
	}
	return null;
	}
    public void runTest(){
        String run = 'runTest';
        run = 'runTest';
    }
}