/* Create By Jason 20161020 
	当付款说明为信息更新的时候 更新字段	Sales Print PAPI Confirm Log 并留操作历史记录
*/
global class UpdateSalesPrintPAPIConfirmLog {
	webservice static String submit(String conid){
        String str = 'business days before picking up Goods.';
		if(string.isEmpty(conid))return 'Contract Id is null';
        
        Contract con = [Select id,Payment_Method__c
                       			,Payment_Reivew_Approval__c
                       			,Payment_Term__c
                        		,Trade_term__c
                        		,Payment_Term_Description__c
                       			From Contract
                       			Where id =: conid ];					
					
		List<Payment__c> payList = [SELECT ID
										, Down_Balance_Payment__c
										, Payment_Term__c
										, Percentage__c
										, Payment_Method__c 
										FROM Payment__c 
										WHERE Contract__c =: conid 
										AND Percentage__c =: 100 
										AND Down_Balance_Payment__c =: 'Down Payment'
										AND Payment_Term__c =: 'after PO date'];
		if((payList.size()>0 && con.Trade_term__c == 'EXW')||con.Payment_Term_Description__c.contains(str)){
			con.Sales_Print_PAPI_Confirm_Log__c = 'sales confirmed payment description ';
			update con;
		}
		return null;
	}
    webservice static String cancel(String conid){
		
		if(string.isEmpty(conid))return 'Contract Id is null';
        
        Contract con = [Select id,Payment_Method__c
                       			,Payment_Reivew_Approval__c
                       			,Payment_Term__c
                        		,Payment_Term_Description__c
                        		,Trade_term__c
                        		,Sales_Print_PAPI_Confirm_Log__c
                       			From Contract
                       			Where id =: conid ];
        if(con.Trade_term__c == 'EXW'){
        	con.Sales_Print_PAPI_Confirm_Log__c = 'sales didn'+ '\'' +'t confirm payment description.'; 
        }
        
        update con;
		
		return null;
	}
}