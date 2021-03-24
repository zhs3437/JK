public without sharing class OppDiffCtrl {
    public String requestId{get;set;}
    public List<History> HistoryList{get;set;}
    public class History{
        public Integer ApprovalNumbers{get;set;}
        public Double DiffMW{get;set;}
        public Double DiffPow{get;set;}
        public Double DiffPrice{get;set;}
        public Integer DiffQuantity{get;set;}
        public Double DiffCommision{get;set;}
        public List<Opportunity_Differences__c> oppDiffLst{get;set;}
        public List<OpportunityLineItem_Difference__c> oppLinDiffLst{get;set;}
        public List<PaymentDifference__c> payDiffLst{get;set;}
        public Opportunity_Differences__c oppdiff{get;set;}
        public History(){
            ApprovalNumbers = 0;
            oppDiffLst = new List<Opportunity_Differences__c>();
            oppLinDiffLst = new List<OpportunityLineItem_Difference__c>();
            payDiffLst =new  List<PaymentDifference__c>();
            oppdiff   = new Opportunity_Differences__c();
        }
        public void add(Opportunity_Differences__c oppd){
            oppDiffLst.add(oppd);
            oppdiff = oppd;
        }
        public void addOpplinDiff(OpportunityLineItem_Difference__c opplinDiff){
            oppLinDiffLst.add(opplinDiff);
        }
        public void addpayDiff(PaymentDifference__c paydiff){
            payDiffLst.add(paydiff);
        }
    } 
    public Double DiffMW{get;set;}
    public Double DiffPow{get;set;}
    public Double DiffPrice{get;set;}
    public Integer DiffQuantity{get;set;}
    public Double DiffCommision{get;set;}
    public List<PaymentDifference__c> payDiffLst{get;set;}
    public List<Opportunity_Differences__c> oppDiffLst{get;set;} 
    public List<OpportunityLineItem_Difference__c> oppLinDiffLst{get;set;}
    public OppDiffCtrl(ApexPages.StandardController sd){
        system.debug('##进入差异比较##');
        requestId = ApexPages.currentPage().getParameters().get('id');
        system.debug('requestId-->'+requestId);
        system.debug('##进入搜索对象##');
        Set<Id> oppDiffID = new  Set<Id>();
        if(requestId !=null){
            oppDiffLst =[Select id,CreatedDate,ApprovalNumbers__c,Opportunity__c,
                          DiffMW__c,DiffPow__c,DiffPrice__c,DiffQuantity__c,DiffCommision__c,                       
                         Opp_Total_MW_New__c,Opp_Total_MW_Old__c,
                         Opp_Total_Power_New__c,Opp_Total_Power_Old__c,Opp_Total_Price_New__c,Opp_Total_Price_Old__c,
                         Opp_Total_Quantity_New__c,Opp_Total_Quantity_Old__c,
                         Trade_Term_After__c,Trade_Term_Before__c,
                          Seller_After__c,Seller_Before__c,
                         Commision_After__c,Commision_Before__c,
                          Destination_Country_After__c,Destination_Country_Before__c,Expect_Price_and_Comments_After__c,Expect_Price_and_Comments_Before__c from Opportunity_Differences__c where Opportunity__c =:requestId 
                         ORDER by ApprovalNumbers__c DESC];
            system.debug('oppDiffLst.size()-->'+oppDiffLst.size());
            if(oppDiffLst.size()>0){    
                HistoryList = new List<History>();
                History h = new History();
                for(Opportunity_Differences__c oppdd : oppDiffLst){
                    oppDiffID.add(oppdd.Id);
                    if(Integer.valueOf(oppdd.ApprovalNumbers__c) != h.ApprovalNumbers){
                        h = new History();
                        h.ApprovalNumbers = Integer.valueOf(oppdd.ApprovalNumbers__c);
                             System.debug(' h.ApprovalNumbers-->'+ h.ApprovalNumbers);
                        HistoryList.add(h);
                    }
                    DiffMW = oppdd.DiffMW__c;
                    DiffPow =oppdd.DiffPow__c;
                    DiffPrice =oppdd.DiffPrice__c;
                    DiffQuantity =Integer.valueOf(oppdd.DiffQuantity__c);
                    DiffCommision = oppdd.DiffCommision__c;
                    h.DiffMW = DiffMW; 
                    h.DiffPow = DiffPow;       
                    h.DiffPrice = DiffPrice;       
                    h.DiffQuantity = DiffQuantity; 
                    h.DiffCommision = DiffCommision;
                    h.add(oppdd);
                }
                if(oppDiffID.size()>0){
                    oppLinDiffLst =[Select id,ApprovalNumbers__c,ProductName__c,Opportunity_Difference__c,Quantity_New__c,Quantity_Old__c,Total_MW_New__c,Total_MW_Old__c,
                                    DiffQuantity__c,DiffTotalMW__c,DiffTotoalPrice__c,DiffUnitPrice__c,Guaranteed_Delivery_Date_After__c,Guaranteed_Delivery_Date_Before__c,Type_of_module_After__c,Type_of_module_Before__c,
                                    Total_Price_New__c,Total_Price_Old__c,UnitPrice_New__c,UnitPrice_Old__c from OpportunityLineItem_Difference__c where Opportunity_Difference__c in: oppDiffID];
                      system.debug('12345'+oppLinDiffLst.size());
                    if(oppLinDiffLst.size()>0){
                        for(OpportunityLineItem_Difference__c oppLinDiff : oppLinDiffLst){
                            
                            for(History h1 : HistoryList){
                                system.debug('6666--'+h1.ApprovalNumbers);
                                if(Integer.valueOf(oppLinDiff.ApprovalNumbers__c) == h1.ApprovalNumbers){
                                      h1.addOpplinDiff(oppLinDiff);
                                }
                            }
                    
                        }
                    }
                    
                    payDiffLst =[Select id,ApprovalNumbers__c,Opportunity_Difference__c,Amount_New__c,Amount_Old__c,Days_New__c,Days_Old__c,
                                 Down_Balance_Payment_New__c,Down_Balance_Payment_Old__c,Payment_Method_New__c,Payment_Method_Old__c,
                                 DiffAmount__c,DiffDays__c,DiffPercentage__c,
                                 Payment_Term_New__c,Payment_Term_Old__c,Percentage_New__c,Percentage_Old__c from PaymentDifference__c where Opportunity_Difference__c in: oppDiffID];
                    system.debug('12345'+payDiffLst.size());
                    if(payDiffLst.size()>0){
                        for(PaymentDifference__c paydiff : payDiffLst){
                                for(History h1 : HistoryList){
                                if(Integer.valueOf(paydiff.ApprovalNumbers__c) == h1.ApprovalNumbers){
                                      h1.addpayDiff(paydiff);
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
}