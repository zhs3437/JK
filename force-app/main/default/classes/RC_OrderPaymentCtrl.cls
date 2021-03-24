public class RC_OrderPaymentCtrl {
  
    public List<Payment__c> PaymentList{get;set;}
    public Agreement__c ord{get;set;}
    public String requestId{get;set;}
    public String PaymentStatusText  {get;set;}
    public Boolean PaymentInsertFlag {get;set;}
    public Integer PaymentInsertCount{get;set;}
    
    public String deleteID {get;set;}
    public String editID   {get;set;}
    
    public RC_OrderPaymentCtrl(ApexPages.StandardController sd){
        requestId = ApexPages.currentPage().getParameters().get('id');
        if(requestId != null){
            this.ord = [select Id, Name,Lock__c,Destination_Country__c from Agreement__c where Id = :requestId];
            PaymentList = PaymentModeList();
            PaymentInsertFlag = false;
        }
    }

    // Mode Data
    public List<Payment__c> PaymentModeList(){
        List<Payment__c> gl = new List<Payment__c>{};
        try {
            gl = [Select Id,Name,
                      Down_Balance_Payment__c, 
                      Payment_Term__c, 
                      Payment_Method__c, 
                      Opportunity__c,
                      Days__c, 
                      Comments_Japan__c,
                      Comments_English__c,
                      CurrencyIsoCode,  
                      Precise_Day__c,
                      Percentage__c,
                      Requested_Number__c,
                      Opp_Trade_Term__c,
                      Comments__c,
                      Credit_Valid__c,
                      Amount__c,
                      TYPE__c,
                      PaymentDescription__c,
                  PaymentDescription_Japan__c,
                  Payment_Method_China__c,
                  Payment_Stage_China__c,
                  Payment_Term_China__c
                         From Payment__c
                         where China_Order__c = :ord.Id
                         order by Down_Balance_Payment__c,createddate];
            if(gl == null){
                gl.add(new Payment__c(China_Order__c = ord.Id));
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
            List<Payment__c> pmUpsertList = new List<Payment__c>(); 
            for( Integer i=0; i < PaymentList.size(); i++ ){
                if(PaymentList.get(i).Id == null){
                    pmUpsertList.add(PaymentList.get(i));
                }
            }
            upsert pmUpsertList;    
            PaymentStatusText = ''; 
        } catch (DMLException e) {
            system.debug(e.getMessage());
            PaymentStatusText = '';
            for (Integer i = 0; i < e.getNumDml(); i++) {
                if( e.getDmlMessage(i).contains('insufficient access rights on cross-reference id') ){
                    PaymentStatusText += ('  ● '+ 'insufficient access rights on Opportunity record' );
                }else{
                    PaymentStatusText += ('  ● '+e.getDmlMessage(i));
                }
            }
            //database.rollback(sp);
            return null;
        }
           
        PaymentList = PaymentModeList();
        PaymentInsertFlag = false;
        return null;
    }
    
    // Add
    public PageReference addPaymentRequest () {
        PaymentInsertFlag = true;
        PaymentList.add(new Payment__c(China_Order__c = ord.Id));
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
            for(Payment__c newPay : PaymentList){
                if(newPay.ID == editID){
                    update newPay;
                }
            }
        } catch (DMLException e) {
            system.debug(e.getMessage());
        }   
    }
}