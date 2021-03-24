global class AddOppItemCtrl {
    public String OppID { get; set; }
    public List<quote> quoteLst { get; set; }
    public List<OpportunityLineItem> OppItemLst { get; set; }
    public String EditID { get; set; }
    public Opportunity opp { get; set; }
    public AddOppItemCtrl(ApexPages.StandardController std) {
        OppID= ApexPages.currentPage().getParameters().get('Id');
        opp=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Opportunity) + ' ' +
                           'Where ID =: OppID');
        quoteLst =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.quote) + ' ' +
                                 'Where OpportunityID =: OppID');
        OppItemLst=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OpportunityLineItem) + ' ' +
                                  'Where OpportunityID =: OppID');
    }
    webservice static integer number(string oppid2){
        List<quote> quoteLst2 =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.quote) + ' ' +
                                              'Where OpportunityID =: OppID2');
        if(quoteLst2.size()==0){
            return 0;
        }
        else if(quoteLst2.size()==1){
            return 1;
        }
        else if(quoteLst2.size()>1){
            return 2;
        }
        return 3;
    }
    public PageReference Edit(){
        PageReference r = new PageReference('/apex/AddQuoteProduct?addTo='+Editid+'&retURL=%2F'+Editid+'&id='+Editid);
        return r;
    }
    webservice static void UpdateQuoteItem2(string oppid2){
         quote quote3 =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.quote) + ' ' +
                                              'Where OpportunityID =: OppID2');
         Opportunity  opp2=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Opportunity) + ' ' +
                                         'Where ID =: OppID2');
        quote3.pricebook2id=OPP2.pricebook2id;
        update quote3;
        String quote3id=quote3.id;
        List<QuoteLineItem> quoteLst =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.QuoteLineItem) + ' ' +
                                                     'Where QuoteID =: quote3id');
        List<OpportunityLineItem> OppItemLst2=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OpportunityLineItem) + ' ' +
                                  'Where OpportunityID =: oppid2');
        List<QuoteLineItem> deletequoteLst = new List<QuoteLineItem>();
        for(QuoteLineItem qli:quoteLst){
            deletequoteLst.add(qli);
        }
        delete deletequoteLst;
        List<QuoteLineItem> UpdateQuoteLst = new List<QuoteLineItem>();
        for(OpportunityLineItem oppitem:OppItemLst2){
            QuoteLineItem qit =new QuoteLineItem();
            qit.Quoteid=quote3.id;
            qit.Product2id=oppitem.Product2id;
            qit.pricebookentryid=oppitem.pricebookentryid;
            qit.Quantity=oppitem.Quantity;
            qit.Battery_Type__c=oppitem.Battery_Type__c;
            qit.UnitPrice=oppitem.UnitPrice;
            qit.MP__c=oppitem.MP__c;
            qit.Certification__c=oppitem.Certification__c;
            qit.Wire_Length__c=oppitem.Wire_Length__c;
            qit.ConnectorLine__c=oppitem.ConnectorLine__c;
            qit.Type_of_module__c=oppitem.Type_of_module__c;
            qit.Grade__c=oppitem.Grade__c;
            qit.Color_of_Module__c=oppitem.Color_of_Module__c;
            qit.Special_required__c=oppitem.Special_required__c;
            qit.Bus_bars_of_cell__c=oppitem.Bus_bars_of_cell__c;
            qit.Guaranteed_Delivery_Date__c=oppitem.Guaranteed_Delivery_Date__c;
            qit.Guaranteed_Delivery_Date_japan__c=oppitem.Guaranteed_Delivery_Date_japan__c;
            qit.Expected_Delivery_Date__c=oppitem.Expected_Delivery_Date__c;
            qit.FOB_Sales_Price__c=oppitem.FOB_Sales_Price__c;
            qit.Japan_Rate_Tax__c=oppitem.Japan_Rate_Tax__c;
            qit.Total_Price_Tax_Japan__c=oppitem.Total_Price_Tax_Japan__c;
            UpdateQuoteLst.add(qit);
        }
        insert UpdateQuoteLst;   

        
    }
    public PageReference UpdateQuoteItem(){
        quote quote3 =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.quote) + ' ' +
                                              'Where id =: EditID');
        String OppID2=quote3.Opportunityid;
        Opportunity  opp2=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Opportunity) + ' ' +
                                         'Where ID =: OppID2');
        quote3.pricebook2id=OPP2.pricebook2id;
        update quote3;
        List<QuoteLineItem> quoteLst =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.QuoteLineItem) + ' ' +
                                                     'Where QuoteID =: EditID');
        List<QuoteLineItem> deletequoteLst = new List<QuoteLineItem>();
        for(QuoteLineItem qli:quoteLst){
            deletequoteLst.add(qli);
        }
        delete deletequoteLst;
        List<QuoteLineItem> UpdateQuoteLst = new List<QuoteLineItem>();
        for(OpportunityLineItem oppitem:OppItemLst){
            QuoteLineItem qit =new QuoteLineItem();
            qit.Quoteid=EditID;
            qit.Product2id=oppitem.Product2id;
            qit.pricebookentryid=oppitem.pricebookentryid;
            qit.Quantity=oppitem.Quantity;
            qit.Battery_Type__c=oppitem.Battery_Type__c;
            qit.UnitPrice=oppitem.UnitPrice;
            qit.MP__c=oppitem.MP__c;
            qit.Certification__c=oppitem.Certification__c;
            qit.Wire_Length__c=oppitem.Wire_Length__c;
            qit.ConnectorLine__c=oppitem.ConnectorLine__c;
            qit.Type_of_module__c=oppitem.Type_of_module__c;
            qit.Grade__c=oppitem.Grade__c;
            qit.Color_of_Module__c=oppitem.Color_of_Module__c;
            qit.Special_required__c=oppitem.Special_required__c;
            qit.Bus_bars_of_cell__c=oppitem.Bus_bars_of_cell__c;
            qit.Guaranteed_Delivery_Date__c=oppitem.Guaranteed_Delivery_Date__c;
            qit.Guaranteed_Delivery_Date_japan__c=oppitem.Guaranteed_Delivery_Date_japan__c;
            qit.Expected_Delivery_Date__c=oppitem.Expected_Delivery_Date__c;
            qit.FOB_Sales_Price__c=oppitem.FOB_Sales_Price__c;
                        qit.Japan_Rate_Tax__c=oppitem.Japan_Rate_Tax__c;
            qit.Total_Price_Tax_Japan__c=oppitem.Total_Price_Tax_Japan__c;
            UpdateQuoteLst.add(qit);
        }
        insert UpdateQuoteLst;   
        return new ApexPages.StandardController(opp).view();
    }
    public PageReference AddOppProduct(){
        PageReference p = new PageReference('/apex/AddProduct?addTo='+OppId+'&retURL=%2F'+OppId+'&id='+OppId);
        return p;
    }
    public PageReference AddQuote(){
        PageReference f = new PageReference('/setup/ui/recordtypeselect.jsp?ent=Quote&retURL=%2F'+OppId+'&save_new_url=%2F0Q0%2Fe%3FretURL%3D%252F'+OppId+'%26oppid%3D'+oppid);
        return f;
    }
      public PageReference back(){
    return new ApexPages.StandardController(opp).view();
          }
}