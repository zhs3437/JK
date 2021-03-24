public class RC_AmendmentPaymentCtrl {    
    public List<Payment__c> PaymentList{get;set;}
    public Amendment_Agreement__c ord{get;set;}
    public String requestId{get;set;}
    public String PaymentStatusText  {get;set;}
    public Boolean PaymentInsertFlag {get;set;}
    public Integer PaymentInsertCount{get;set;}
    
    public String deleteID {get;set;}
    public String editID   {get;set;}
    
    public RC_AmendmentPaymentCtrl(ApexPages.StandardController sd){
        requestId = ApexPages.currentPage().getParameters().get('id');
        if(requestId != null){
            ord = [select Id, Name,Lock__c from Amendment_Agreement__c where Id = :requestId];
            PaymentList = PaymentModeList();
            PaymentInsertFlag = false;
        }
    }
    
    // Mode Data
    public List<Payment__c> PaymentModeList(){
        List<Payment__c> gl = new List<Payment__c>{};
            try {
                gl = [Select Id,Name,
                      Comments__c,
                      Credit_Valid__c,
                      Days__c,
                      Amendment_Agreement__c,
                      Down_Balance_Payment__c,
                      Payment_Method__c,
                      Payment_Term__c,
                      Percentage__c,
                      Precise_Day__c,
                      PaymentDescription__c,
                      Payment_Method_China__c,
                      Payment_Stage_China__c,
                      Payment_Term_China__c
                      From Payment__c
                      where Amendment_Agreement__c = :ord.Id
                     order by Down_Balance_Payment__c
                     ]; 
                if(gl == null){
                    gl.add(new Payment__c(Amendment_Agreement__c = ord.Id));//
                }
            } catch (QueryException e){
                system.debug(e.getMessage());
                PaymentStatusText = e.getMessage();
            }
        return gl;
    }
    
    // Insert
    public PageReference savePaymentRequest () {
        //Savepoint sp = Database.setSavepoint();
        try {
            decimal Percentage=0;
            List<Payment__c> pmUpsertList = new List<Payment__c>(); 
            for( Integer i=0; i < PaymentList.size(); i++ ){
                if(PaymentList.get(i).Id == null){
                    pmUpsertList.add(PaymentList.get(i));
                }
                Percentage=Percentage+PaymentList.get(i).Percentage__c;
            }
            system.debug('Percentage'+Percentage);
            if (Percentage<=100) upsert pmUpsertList;
            else throw new QW_Utils.QWException('百分比不应超过100%');
            PaymentList = PaymentModeList();
            // return ApexPages.currentPage();
        } catch (Exception e) {
            // system.debug(e.getMessage());
            // PaymentStatusText = '';
            // for (Integer i = 0; i < e.getNumDml(); i++) {
            //     if( e.getDmlMessage(i).contains('insufficient access rights on cross-reference id') ){
            //         PaymentStatusText += ('  ● '+ 'insufficient access rights on Opportunity record' );
            //     }else{
            //         PaymentStatusText += ('  ● '+e.getDmlMessage(i));
            //     }
            // }
            PaymentStatusText = e.getMessage();
            ApexPages.addMessages(e);
            //database.rollback(sp);
        }
        
        PaymentInsertFlag = false;
        return null;
    }
    
    // Add
    public PageReference addPaymentRequest () {
        PaymentInsertFlag = true;
        PaymentList.add(new Payment__c(Amendment_Agreement__c = ord.Id));//
        return null;
    }
    
    // Cancel
    public PageReference CancelPaymentRequest () {
        PaymentList        = PaymentModeList();
        PaymentInsertFlag  = false;
        PaymentStatusText  = '';
        editID             = '';
        return null;
    }
    
    // Delete
    public void DeletePay(){
        if(deleteID != null && deleteID != ''){
            Payment__c pay = [SELECT ID,Name FROM Payment__c WHERE ID =: deleteID];
            delete pay;
        }
    }
    
    // Update
    public void saveEditPayment() {
        try {
            decimal Percentage=0;
            for(Payment__c newPay : PaymentList){
                 Percentage=Percentage+newPay.Percentage__c;
                }
            System.debug('Percentage'+Percentage);
            if(Percentage<=100){
                for(Payment__c newPay : PaymentList){
                    if(newPay.ID == editID){
                        update newPay;
                    }
                }
            }
            else throw new QW_Utils.QWException('百分比不应超过100%');
        } catch (Exception e) {
            system.debug(e.getMessage());
            PaymentStatusText = e.getMessage();
            ApexPages.addMessages(e);
        }   
    }
}