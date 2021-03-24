public with sharing class ContractPaymentController {
    String PaymentStatusText;
    List<Payment__c> PaymentGridData;
    Boolean PaymentInsertFlag;
    Integer PaymentInsertCount;
    public Contract crt{get;set;}
    String requestId;
    
    public Integer newCount{get;set;}  //新建计数器
    
    // Constuctor for extending the standard controller
    public ContractPaymentController () {
        requestId = ApexPages.currentPage().getParameters().get('id');
        if([select Id, Name from Contract where Id = :requestId].size() == 0){
            this.crt = new Contract(Id = requestId);
        }else{
            this.crt = [select Id, Name,Destination_Country__c from Contract where Id = :requestId];
        }
        requestId = crt.id;
        PaymentStatusText = '';
        PaymentGridData = PaymentModeList();
        PaymentInsertFlag = false;
        PaymentInsertCount = 0;    
        newCount = 0;       
    }

    public ContractPaymentController (ApexPages.StandardSetController controller) {
    
    }
    
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [Select Credit_Valid__c,Comments__c,Collection_Assurance__c,Incoterm__c,Down_Balance_Payment__c, Payment_Term__c, Payment_Method__c, Contract__c, Name, Id,  Days__c, CurrencyIsoCode,  Precise_Day__c,
                    Condition__c, Collection_Assurance_1__c, Collection_Assurance_2__c, CA_Document_Preparing_Due_Date__c,Percentage__c,Requested_Number__c,AR_Start_Date__c
                    From Payment__c 
                    where Contract__c =: ApexPages.currentPage().getParameters().get('id')
                    order by Down_Balance_Payment__c,createddate]));
            }
            return setCon;
        }
        set;
    }

    // Initialize setCon and return a list of records
    public List<Payment__c> getselectedList() {
        return (List<Payment__c>) setCon.getRecords();
    }

    // Fill PaymentMode list with data
    public List<Payment__c> PaymentModeList(){
        //system.debug('!!!GridData List Start!!!');
        List<Payment__c> gl = new List<Payment__c>{};
        try {
            gl = Database.query( Utils.MakeSelectSql('Payment__c')+' where Contract__c = :requestId order by Down_Balance_Payment__c,createddate'); 

            system.debug('*******'+gl);
            if(gl == null){
                gl.add(new Payment__c(Contract__c = crt.Id,Requested_Number__c = 1));
            }
        } catch (QueryException e){
            system.debug(e.getMessage());
            PaymentStatusText = e.getMessage();
        }

        return gl;
    }

    // Called from Grid to get List of PaymentMode requests
    public List<Payment__c> getPaymentGridData () {
        if (PaymentInsertFlag){
           PaymentGridData.add(new Payment__c(Contract__c = crt.Id, Requested_Number__c = 1));
           PaymentInsertFlag = false;
           newCount++;
        }
        return PaymentGridData;  
    }

    // Called from Page to pass values from PaymentMode grid to controller
    public void setPaymentGridData(List<Payment__c> gd) {
        PaymentGridData = gd;
    }

    // Called from Page to get PaymentMode StatusText
    public String getPaymentStatusText() {
        return PaymentStatusText;
    }

    // Called from Page to get IT Request id
    public String getRequestId() {
        return requestId;
    }
    
    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }
    
    public String getPaymentInsertFlag() {
        if(PaymentInsertCount > 0){
            return 'true';
        }
        else {
            return 'false';
        }
    }
    
    // Called from PaymentMode Grid "Save" Button
    public PageReference savePaymentRequest () {
        //Savepoint sp = Database.setSavepoint();
        try {
            List<Payment__c> pmUpsertList = new List<Payment__c>(); 
            for( Integer i=0; i<PaymentGridData.size(); i++ ){
                if(PaymentGridData.get(i).Id == null){
                    pmUpsertList.add(PaymentGridData.get(i));
                }
            }
            system.debug('pmUpsertList---->' + pmUpsertList);
            newCount = 0;
            upsert pmUpsertList;    
            PaymentStatusText = '';   //保存之后把错误信息置为空        
        } catch (DMLException e) {
            system.debug(e.getMessage());
            PaymentStatusText = '';
            for (Integer i = 0; i < e.getNumDml(); i++) {
                if( e.getDmlMessage(i).contains('insufficient access rights on cross-reference id') ){
                    PaymentStatusText += ('  ● '+ 'insufficient access rights on contract record' );
                }else{
                    PaymentStatusText += ('  ● '+e.getDmlMessage(i));
                }
            }
            //database.rollback(sp);
            return null;
        }   
        PaymentGridData = PaymentModeList();
        PaymentInsertCount = 0;
        

        return null;
    }

    // Called from PaymentMode Grid "Add" Button
    public PageReference addPaymentRequest () {
        PaymentInsertCount++;
        PaymentInsertFlag = true;
        return null;
    }

    // Called from PaymentMode Grid "Cancel" Button
    public PageReference CancelPaymentRequest () {
        PaymentGridData = PaymentModeList();
        PaymentInsertFlag = false;
        PaymentInsertCount = 0;
        PaymentStatusText = '';
        newCount = 0;
        return null;
    }
    
    public void runTest(){
        String run = 'Run Test';
        run = 'Run Test';
    }
    
}