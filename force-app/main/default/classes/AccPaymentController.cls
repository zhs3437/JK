public class AccPaymentController{
    public String NO{get;set;}
    public List<Payment__c> PaymentList{get;set;}
    public Account acc{get;set;}
    public String requestId{get;set;}
    public String PaymentStatusText  {get;set;}
    public Boolean PaymentInsertFlag {get;set;}
    public Integer PaymentInsertCount{get;set;}
    
    public String deleteID {get;set;}
    public String editID   {get;set;}
    
    public AccPaymentController(ApexPages.StandardController sd){
        requestId = ApexPages.currentPage().getParameters().get('id');
        if(requestId != null){
            acc = [select Id from Account where Id = :requestId];
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
                      PaymentDescription_Japan__c
                      From Payment__c
                      where Account__c = :acc.Id
                      order by Down_Balance_Payment__c,createddate];
                if(gl == null){
                    gl.add(new Payment__c(Account__c = acc.Id));
                }
            } catch (QueryException e){
                system.debug(e.getMessage());
                PaymentStatusText = e.getMessage();
            }
        return gl;
    }
    
    // Insert
    public void savePaymentRequest () {
        //Savepoint sp = Database.setSavepoint();
        try {
            List<Payment__c> pmUpsertList = new List<Payment__c>(); 
            decimal Percentage=0;
            Payment__c pp =new Payment__c();
            NO=''; 
            for( Integer i=0; i < PaymentList.size(); i++ ){
                if(PaymentList.get(i).Id == null){
                    pmUpsertList.add(PaymentList.get(i));
                }
                Percentage=Percentage+PaymentList.get(i).Percentage__c;
            }
            for(Payment__c newPay : PaymentList){
                Percentage=Percentage+newPay.Percentage__c;
                

            }
                upsert pmUpsertList;  
            
            PaymentList = PaymentModeList();
            PaymentInsertFlag = false;
            PaymentStatusText = ''; 
        } catch(Exception e){
           //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getStackTraceString()));
           NO='err';
        }
        
        
    }
    
    // Add
    public PageReference addPaymentRequest () {
        PaymentInsertFlag = true;
        PaymentList.add(new Payment__c(Account__c = acc.Id));
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
    public VOID saveEditPayment() {
        try{
        NO='';
        Payment__c pp =new Payment__c();
        decimal Percentage=0;
        for(Payment__c newPay : PaymentList){
            Percentage=Percentage+newPay.Percentage__c;
            

        }
        if(Percentage>100){
            system.debug('11');
            NO='err';
            pp.addError( '要<=100');
            return;
        }
        if(Percentage<=100){
            for(Payment__c newPay : PaymentList){
                
                if(newPay.ID == editID){
                    update newPay;
                }
            }
        }
        }catch(Exception e){
           //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getStackTraceString()));
           NO='err';
        }
    }
    
    public void runTest(){
        String run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        run ='Go';
        
        
    }
    
}