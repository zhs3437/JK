global class UpdateAmendent {
    
	@InvocableMethod(label='UpdateAmendent' description='UpdateAmendent')    
    public static void UpdateAmendent(List<Id>  boxIds) {
        List<Amendment__c> Aord =new List<Amendment__c>();
       Aord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                          'Where id =: boxIds');
        if(Aord[0].Header_Change__c==true || Aord[0].Product_Change__c==true ||  Aord[0].Delivery_Date_Change__c==true || Aord[0].Payment_Change__c==true){
             OrderApprovalCounts.Changetoemail(Aord[0].id);
        
    }
    
}
}