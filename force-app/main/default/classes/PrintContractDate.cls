global class PrintContractDate {
	webservice static void print(String conid){
		if(conid != null){
			Contract con = [SELECT ID FROM Contract WHERE ID =: conid].size() > 0 ? [SELECT ID,Print_Contract_Date__c FROM Contract WHERE ID =: conid] : null;
			if(con != null){
				con.Print_Contract_Date__c = Date.today();
				update con;
			}
		}
	}
}