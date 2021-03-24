public class AmendmentSubmitApprovalCtrl {
    public boolean flag{
        get;set;
    }
    public Amendment__c ad{
        get;set;
    }
    public boolean flags{
        get;set;
    }
    public boolean flage{
        get;set;
    }

    public AmendmentSubmitApprovalCtrl(apexpages.StandardController std) {
        ad = [select id,Delivery_Date_Change__c,Header_Change__c,Payment_Change__c,Product_Change__c,name,Number_of_Approve__c,Number_of_Reviews__c
        from Amendment__c
        where id =: std.getId()];
        flag = false;
        flags = false;
        flage = false;
        if (ad.Delivery_Date_Change__c == true ||ad.Header_Change__c == true ||ad.Payment_Change__c == true ||ad.Product_Change__c == true ) {
            flag = true;
        }
        if(ad.Delivery_Date_Change__c == false && ad.Header_Change__c == false &&ad.Payment_Change__c == false &&ad.Product_Change__c == false ){
            if(ad.Number_of_Approve__c!=ad.Number_of_Reviews__c  ){
                flags = true;
            }else if(ad.Number_of_Approve__c==ad.Number_of_Reviews__c && ad.Number_of_Approve__c !=0 ){
                flage = true;
            }
        }
        
    }
}