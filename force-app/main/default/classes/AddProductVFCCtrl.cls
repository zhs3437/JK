global with sharing class AddProductVFCCtrl {
global String requestId{get;set;}
global List<Product_Application_Detail__c> ppList {get{return [select id,Guaranteed_Delivery_Date__c,Cost__c,Sales_Price__c,w__C,NAME,Discount__c,comments__c from Product_Application_Detail__c where Product_Application__c=:requestId
			];
                                                       
        }
        set;
    }   
    global Product_Application__c pp {get{return [select TCM__c from Product_Application__c where id=:requestId 
			];
                                                       
        }
        set;
    }  
    global List<Product_Application_Detail__c> ppLists {get;set;}
        global Product_Application__c p {get;set;}
        public AddProductVFCCtrl() {
            }
        public AddProductVFCCtrl(ApexPages.standardController std) {
              p = (Product_Application__c)std.getRecord();
            p=[select TCM__c,TCM_approval_Feedback__c from Product_Application__c where id=:p.Id ];
            ppLists=[select id,Guaranteed_Delivery_Date__c,Sales_Price__c,w__C,NAME,Discount__c,Cost__c,comments__c,Module_size__c
			from Product_Application_Detail__c
			where Product_Application__c=:p.Id
			];
        }
     public void save() {
         for(Product_Application_Detail__c p:ppLists){
                 if(p.cost__c==null){
                       Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '必须填入额外成本才能同意审批,无额外成本填写0.'));
                return ;
                 }
                 }
         update ppLists;
         p.TCM__c='Approved';
          update p;
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.info, '更新成功,已发送邮件给财务做最后审批.'));
            }
     public void save2() {
         if(p.TCM_approval_Feedback__c==null){
              Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '请在整体备注中填写理由.'));
         }
         else{
         update ppLists;
         p.TCM__c='Rejected';
          update p;
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.info, '已拒绝本次审批,已通知销售本人.'));
             }
            }
}