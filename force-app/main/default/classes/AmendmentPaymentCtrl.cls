public class AmendmentPaymentCtrl {
    
    public List<Amendment_Payment__c> PaymentList{get;set;}
    public Amendment__c ord{get;set;}
    public String requestId{get;set;}
    public String PaymentStatusText  {get;set;}
    public Boolean PaymentInsertFlag {get;set;}
    public Integer PaymentInsertCount{get;set;}
    
    public String deleteID {get;set;}
    public String editID   {get;set;}
    
    public AmendmentPaymentCtrl(ApexPages.StandardController sd){
        requestId = ApexPages.currentPage().getParameters().get('id');
        if(requestId != null){
            ord = [select Id, Name,Lock__c from Amendment__c where Id = :requestId];
            PaymentList = PaymentModeList();
            PaymentInsertFlag = false;
        }
    }
    
    // Mode Data
    public List<Amendment_Payment__c> PaymentModeList(){
        List<Amendment_Payment__c> gl = new List<Amendment_Payment__c>{};
            try {
                gl = [Select Id,Name,
                      Comments__c,
                      Credit_Valid__c,
                      Days__c,
                      
                      Down_Balance_Payment__c,
                      Payment_Method__c,
                      Payment_Term__c,
                      Percentage__c,
                      Precise_Day__c,
                        PaymentDescription__c
                      From Amendment_Payment__c
                      where Amendment_Purchase_Agreement__c = :ord.Id
                      order by Down_Balance_Payment__c];
                if(gl == null){
                    gl.add(new Amendment_Payment__c(Amendment_Purchase_Agreement__c = ord.Id));
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
            List<Amendment_Payment__c> pmUpsertList = new List<Amendment_Payment__c>(); 
            for( Integer i=0; i < PaymentList.size(); i++ ){
                if(PaymentList.get(i).Id == null){
                    pmUpsertList.add(PaymentList.get(i));
                }
                 Percentage=Percentage+PaymentList.get(i).Percentage__c;
            }
            system.debug('Percentage'+Percentage);
                        if(Percentage<=100){
            upsert pmUpsertList; 
                            }
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
        PaymentList.add(new Amendment_Payment__c(Amendment_Purchase_Agreement__c = ord.Id));
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
            Amendment_Payment__c pay = [SELECT ID,Name FROM Amendment_Payment__c WHERE ID =: deleteID];
            delete pay;
        }
    }
    
    // Update
    public void saveEditPayment() {
        try {
            decimal Percentage=0;
            for(Amendment_Payment__c newPay : PaymentList){
                 Percentage=Percentage+newPay.Percentage__c;
                }
            system.debug('Percentage'+Percentage);
            if(Percentage<=100){
            for(Amendment_Payment__c newPay : PaymentList){
                if(newPay.ID == editID){
                    update newPay;
                }
            }
            }
        } catch (DMLException e) {
            system.debug(e.getMessage());
        }   
    }
    
}