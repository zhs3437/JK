public class RC_AmendmentProductCtrl {
    Public List<Agreement_Component__c> orderPds {get;set;}
    Public List<Amendment_Agreement_Product__c> AmendmentPds {get;set;}
    Public boolean flag {get;set;}
    Public String req {get;set;}
    public RC_AmendmentProductCtrl(ApexPages.StandardController ctrl) {
        req = ApexPages.currentPage().getParameters().get('id');
        flag = false;
        Amendment_Agreement__c amendmentOrder = Database.query(Utils.MakeSelectSql('Amendment_Agreement__c') + ' WHERE Id =: req');
        String oid = amendmentOrder.Agreement__c;
        Agreement__c ChinaOrder = Database.query(Utils.MakeSelectSql('Agreement__c') + ' WHERE Id =: oid');
        String ChinaOrderId = ChinaOrder.id;
        String amendmentOrderId = amendmentOrder.id;
        //获取订单产品行        
        orderPds = Database.query(Utils.MakeSelectSql('Agreement_Component__c') + ' WHERE Agreement__c =: ChinaOrderId ORDER BY Guaranteed_Delivery_Date__c');
        //获取补充订单产品行
        AmendmentPds = Database.query(Utils.MakeSelectSql('Amendment_Agreement_Product__c') + ' WHERE Amendment_Agreement__c =: amendmentOrderId ORDER BY Guaranteed_Delivery_Date__c');
    }
    public void nextStep(){
        flag = true;
    }   
    public void reStep(){
        flag = false;
    }   
    public PageReference Print(){
        List<Agreement_Component__c> orderPds2 = new List<Agreement_Component__c>();
        List<Amendment_Agreement_Product__c> AmendmentPds2 = new List<Amendment_Agreement_Product__c>();
        for(Amendment_Agreement_Product__c a : AmendmentPds){
            if(a.check_box__c == true){
                AmendmentPds2.add(a);
            }
            
        } 
         for(Agreement_Component__c ac : orderPds){
             if(ac.check_box__c == true){
                 orderPds2.add(ac);
             }
        } 
        if(AmendmentPds2.size() == orderPds2.size() && AmendmentPds2.size() == 1){
            return new PageReference('/apex/RC_AmendmentPDF?id='+req+'&amd='+AmendmentPds2[0].id+'&ord='+ orderPds2[0].id);
            
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, '请选择一个要变更的补充协议产品和订单产品'));          
            return null;
        }
    }  
}