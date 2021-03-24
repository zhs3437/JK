public class ROAQuoteCtrl {
    public String requestId{get;set;}
    public Opportunity opp{get;set;}
    public List<OpportunityLineitem> opplst{get;set;}
    public date today{get;set;}
    public String selleraddress {get;set;}
  
    public ROAQuoteCtrl(ApexPages.StandardController ctrl){
       today= date.today();

        requestId = ApexPages.currentPage().getParameters().get('id');
        opp = Database.query(Utils.MakeSelectSql('Opportunity')  + ' WHERE Id =: requestId');
        opplst =[select id,Quantity,Product2.name,UnitPrice,Goods_Description__c,Total_MW__c,TotalPrice,Total_Price__c,Expected_Delivery_Date__c,Guaranteed_Delivery_Date__c from OpportunityLineitem WHERE Opportunityid =: requestId];
       List<Information_of_Seller__c> ios=[select Address__c from Information_of_Seller__c where Seller__c=:opp.Seller__c];
        if(ios.size()>0){
            selleraddress=ios[0].Address__c;
        }
    }
}