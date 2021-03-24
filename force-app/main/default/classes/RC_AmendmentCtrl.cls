public without sharing class RC_AmendmentCtrl {
    public String ContractDate{get;set;}
    public String prDate{get;set;}
    public String ContractNumber{get;set;}
    public String ordName{get;set;}
    public String amdName{get;set;}
    public Decimal ordMW{get;set;}
    public String ordQuantity{get;set;}
    public String amdQuantity{get;set;}
    public Decimal ordTotalPrice{get;set;}
    //
    public String Address{get;set;}
    public String AuthorizedSignatory{get;set;}
    public String Title{get;set;}
    public String SellerVATNO{get;set;}
    public String phone{get;set;}
    public String postCode{get;set;}
    public String fax{get;set;}
    public String sales{get;set;}
    public Account buyer{get;set;}
    public String buyerAddress{get;set;}
    public String contactPeople{get;set;}
    //买方银行信息
    public String buyerName {get;set;}
    public String sellerBankName {get;set;} 
    public String sellerBankCode {get;set;}
    public String buyerPostCode {get;set;}
    public String buyerFax {get;set;} 
    public String buyerPhone {get;set;}
    public String VAT {get;set;}
    public RC_AmendmentCtrl(ApexPages.StandardController ctrl) {
        String req = ApexPages.currentPage().getParameters().get('id');
        String ord = ApexPages.currentPage().getParameters().get('ord');
        String amd = ApexPages.currentPage().getParameters().get('amd');
        prDate = DateFormula(date.today());
        Amendment_Agreement__c amendmentOrder = Database.query(Utils.MakeSelectSql('Amendment_Agreement__c') + ' WHERE Id =: req');
        String oid = amendmentOrder.Agreement__c;
        Agreement__c ChinaOrder = Database.query(Utils.MakeSelectSql('Agreement__c') + ' WHERE Id =: oid');
        
        
        List<Information_of_Seller__c>  sellers = [
            SELECT id,
            Address__c,
            Authorized_Signatory__c,
            Seller__c,
            Title__c,
            Seller_VAT_NO__c,
            Fax__c,
            // phone__c,
            Postcode__c
            FROM Information_of_Seller__c 
            WHERE  Seller__c =: amendmentOrder.SELLER__c
        ];
        //获取卖方地址                                           
        if(sellers.size() > 0){            
            Address = '';
            AuthorizedSignatory = '';
            Title = '';
            SellerVATNO ='';
            phone ='';
            postCode ='';
            fax ='';                                               
            Information_of_Seller__c infoSeller = sellers[0];            
            Address = infoSeller.Address__c;
            AuthorizedSignatory = infoSeller.Authorized_Signatory__c;
            Title = infoSeller.Title__c;
            SellerVATNO=infoSeller.Seller_VAT_NO__c;
            // phone = String.valueOf(infoSeller.phone__c);
            postCode = infoSeller.Postcode__c;
            fax = infoSeller.Fax__c;
            User s = [SELECT ID,Name FROM User WHERE ID =:amendmentOrder.OwnerId];
            sales = s.Name;
        }
        //获取买方地址
        buyer =[
            SELECT id,
            Name,
            BillingAddress,
            BillingCountry,
            BillingCity,
            BillingState,
            BillingStreet,
            BillingPostalCode,
            VAT_NO__c,
            Fax,
            Phone,
            Bank_Account__c,                        
            Bank_Code__c,
            Bank_Country__c,
            Bank_Name__c,
            Bank_Region__c,
            Bank_Street__c
            FROM   Account       
            WHERE  id = :amendmentOrder.Account__c Limit 1
        ];
        buyerAddress = 	buyer.BillingCountry +' '+ buyer.BillingCity +' '+ buyer.BillingState +' '+ buyer.BillingStreet; 
        sellerBankName = buyer.Bank_Name__c;
        sellerBankCode = buyer.Bank_Code__c;
        buyerPostCode = buyer.BillingPostalCode;
        buyerFax = buyer.Fax;
        buyerPhone = buyer.Phone;
        buyerName = buyer.Name;
        VAT = buyer.VAT_NO__c;
        //获取联系人
        List<Contact> contactLst = [
            SELECT id,
            Name,
            AccountId
            FROM   Contact
            WHERE  AccountId = : buyer.Id
        ];
        if (contactLst.size()>0) {
            contactPeople = contactLst[0].Name;
        }
         ContractDate = DateFormula(Date.valueOf(ChinaOrder.CreatedDate));
            ContractNumber = amendmentOrder.Contract_No__c;
        if(ord !=null && amd !=null){
            //获取订单产品行        
            Agreement_Component__c orderPds = Database.query(Utils.MakeSelectSql('Agreement_Component__c') + ' WHERE Id =: ord ');
            //获取补充订单产品行
            Amendment_Agreement_Product__c AmendmentPds = Database.query(Utils.MakeSelectSql('Amendment_Agreement_Product__c') + ' WHERE Id =: amd');
            
           
            System.debug('ContractNumber-->'+ContractNumber);
            ordName = orderPds.Name;
            ordMW = orderPds.Total_MW_Individual_Product__c; 
            ordQuantity = String.valueOf(orderPds.Quantity__c);
            ordTotalPrice = ChinaOrder.Total_Price__c;
            amdName = AmendmentPds.Name;
            amdQuantity = String.valueOf(AmendmentPds.Quantity__c);
        }
    }
    //中文格式化日期
    public String DateFormula(Date Formula){
        String printDate;
        String Year = String.valueOf(Formula.year());
        String Month = String.valueOf(Formula.month());
        String Day = String.valueOf(Formula.day());   
        printDate = Year+'年'+Month+'月'+Day+'日';
        return printDate;
    }
}