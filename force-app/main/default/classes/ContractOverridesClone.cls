public with sharing class ContractOverridesClone {
        
        public Contract cpyContract {get;set;}
        

    public ContractOverridesClone(ApexPages.StandardController ctrl) {
        
        Contract srcContract = (Contract)ctrl.getRecord();
       
        List<Contract> lstContract = [Select c.Warranty_On_Material_and_Workmanship__c, 
         c.Volume__c, c.Using_Green_Channel__c, c.Trade_term__c, 
         c.Total_Quantity__c, c.Total_Price__c, c.Total_MW__c,
         c.Technical_Dept__c, c.Technical_Dept_Comments__c, c.SystemModstamp, 
         c.Stock_Coordinator_Comments__c, c.StatusCode, c.Status, 
         c.StartDate, c.Standard_Trade_Term__c, c.SpecialTerms, 
         c.ShippingStreet, c.ShippingState, c.ShippingPostalCode,
         c.ShippingCountry, c.ShippingCity, c.Sales_Dept__c,
         c.Sales_Dept_Comments__c, c.SELLER__c, c.RecordTypeId,
          c.Price__c, c.Prepayment_Amount__c,
         c.Prepaid__c, c.Pick_up_by_Customer__c, c.Phone__c, 
         c.Perpayment__c, c.Payment_Term__c, c.Payment_Term_Description__c,
         c.Payment_Method__c, c.PO_Remarks_9__c, c.PO_Remarks_8__c, 
         c.PO_Remarks_7__c, c.PO_Remarks_6__c, c.PO_Remarks_5__c, 
         c.PO_Remarks_4__c, c.PO_Remarks_3__c, c.PO_Remarks_2__c, 
         c.PO_Remarks_1__c, c.PO_Remarks_13__c, c.PO_Remarks_12__c, 
         c.PO_Remarks_11__c, c.PO_Remarks_10__c, c.PO_PI_Month__c, 
         c.PO_PI_Date__c, c.PMC_Dept__c, c.PMC_Dept_Comments__c,
         c.OwnerId, c.OwnerExpirationNotice, c.Opportunity__c, 
         c.Opportunity_Status__c, c.Legal_Dept__c, c.Legal_Dept_Comments__c, 
         c.LastActivityDate, c.JINKO_OEM__c, c.IsDeleted, c.Frame_Contract__c,
         c.Frame_Contract_No__c, c.Finance_Dept__c, c.Finance_Dept_Comments__c, 
         c.Fax__c, 
         c.Expected_Shipment_Date__c, c.EndDate, c.Email__c, c.Downpayment__c,
         c.Pick_up_Date__c,c.Type_Of_Warranty__c,
         c.Downpayment_Amount__c, c.Destination__c, c.Description,
         c.Delivery_Date__c, c.Customer_name__c, c.Customer_country__c, 
         c.Customer_Grade__c, c.Customer_Business_Scale__c, 
         c.CustomerSignedTitle, c.CustomerSignedId, c.CustomerSignedDate,
         c.CurrencyIsoCode, c.Credit_Days__c,  c.Contract_NO__c, 
         c.Contract_Approver__c, c.ContractTerm, c.ContractNumber, 
         c.Contact_Name__c, c.CompanySignedId, c.CompanySignedDate,
         c.CanPrint__c, c.CMO_Dept__c, c.CMO_Dept_Comments__c, 
         c.CEO_or_Delegated__c, c.Buyer_Contact_Person__c, c.BillingStreet,
         c.BillingState, c.BillingPostalCode, c.BillingCountry, 
         c.BillingCity, c.Bank_Information_Content__c, c.BankInfo__c,
         c.Balance_Payment__c, c.BUYER__c,c.BuyerAccount__c, c.BMO_Specialist__c, 
         c.BMO_Manager_Comments__c, c.BMO_Dept__c, c.BMO_Dept_Comments__c, 
         c.Avg_Price_W__c, c.Approval_Status__c, c.Address__c, c.ActivatedDate, 
         c.ActivatedById, c.AccountId 
         From Contract c where c.id = :srcContract.id];
        
        if( lstContract!=null && lstContract.size()>0 ){
                srcContract = lstContract[0];
        }
        // clone Contract whether ID
        cpyContract = srcContract.clone(false,true,false,false);
        
        // clear approval values
        
        cpyContract.Sales_Dept__c = null;
        cpyContract.Sales_Dept_Comments__c = null;
        cpyContract.Legal_Dept__c = null;
        cpyContract.Legal_Dept_Comments__c = null;
        cpyContract.Technical_Dept__c = null;
        cpyContract.Technical_Dept_Comments__c = null;
        cpyContract.PMC_Dept__c = null;
        cpyContract.PMC_Dept_Comments__c = null;
        cpyContract.CMO_Dept__c = null;
        cpyContract.CMO_Dept_Comments__c = null;
        cpyContract.Finance_Dept__c = null;
        cpyContract.Finance_Dept_Comments__c = null;
        cpyContract.BMO_Dept__c = null;
        cpyContract.BMO_Dept_Comments__c = null;
        cpyContract.BMO_Manager_Comments__c = null;
        cpyContract.Stock_Coordinator_Comments__c = null;
        cpyContract.Approval_Status__c = null;
        
    }
    
    
    public PageReference doSave(){
        try{
                if( cpyContract!=null ){
                insert cpyContract;
                }
                        return new PageReference('/'+cpyContract.Id);
                        
        }catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
        }
        return null;
    }
    

}