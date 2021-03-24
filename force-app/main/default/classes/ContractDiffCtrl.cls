public without sharing class ContractDiffCtrl {
    public String requestId{get;set;}
    public List<History> HistoryList{get;set;}
    public class History{
        public Integer ApprovalNumbers{get;set;}
        public Double DiffMW{get;set;}
        public Double DiffPrice{get;set;}
        public Integer DiffQuantity{get;set;}
        public Double DiffCommision{get;set;}
        public List<Contract_Difference_Detail__c> conDiffLst{get;set;}
        public List<ContractLineItem_Difference_Detail__c> conLinDiffLst{get;set;}
        public List<Contract_Payment_Difference__c> payDiffLst{get;set;}
        public Contract_Difference_Detail__c condiff{get;set;}
        public History(){
            ApprovalNumbers = 0;
            conDiffLst = new List<Contract_Difference_Detail__c>();
            conLinDiffLst = new List<ContractLineItem_Difference_Detail__c>();
            payDiffLst =new  List<Contract_Payment_Difference__c>();
            condiff   = new Contract_Difference_Detail__c();
        }
        public void add(Contract_Difference_Detail__c cond){
            conDiffLst.add(cond);
            condiff = cond;
        }
        public void addOpplinDiff(ContractLineItem_Difference_Detail__c conlinDiff){
            conLinDiffLst.add(conlinDiff);
        }
        public void addpayDiff(Contract_Payment_Difference__c paydiff){
            payDiffLst.add(paydiff);
        }
    } 
    public Double DiffMW{get;set;}
    public Double DiffPrice{get;set;}
    public Integer DiffQuantity{get;set;}
    public Double DiffCommision{get;set;}
    public List<Contract_Difference_Detail__c> conDiffLst{get;set;}
    public List<ContractLineItem_Difference_Detail__c> conLinDiffLst{get;set;}
    public List<Contract_Payment_Difference__c> payDiffLst{get;set;}
    public Contract_Difference_Detail__c condiff{get;set;}
    public ContractDiffCtrl(ApexPages.StandardController sd){
        system.debug('##进入差异比较##');
        requestId = ApexPages.currentPage().getParameters().get('id');
        system.debug('requestId-->'+requestId);
        system.debug('##进入搜索对象##');
        Set<Id> conDiffID = new  Set<Id>();
        if(requestId !=null){
            conDiffLst =[Select id,CreatedDate,ApprovalNumbers__c,Contract__c,CreateDate__c,
                         DiffMW__c,DiffCommision__c,DiffPrice__c,DiffQuantity__c,
                         Commision_After__c,Commision_Before__c,Destination_Country_After__c,Destination_Country_Before__c,
                         Expect_Price_and_Comments_After__c,Expect_Price_and_Comments_Before__c,Seller_After__c,Seller_Before__c,
                         Total_MW_New__c,Total_MW_Old__c,Total_Price_New__c,Total_Price_Old__c,Total_Quantity_New__c,Total_Quantity_Old__c,
                         Trade_Term_After__c,Trade_Term_Before__c
                         from Contract_Difference_Detail__c where Contract__c =:requestId 
                         ORDER by ApprovalNumbers__c DESC];
            
            system.debug('conDiffLst.size()-->'+conDiffLst.size());
            if(conDiffLst.size()>0){    
                HistoryList = new List<History>();
                History h = new History();
                for(Contract_Difference_Detail__c condd : conDiffLst){
                    conDiffID.add(condd.Id);
                    if(Integer.valueOf(condd.ApprovalNumbers__c) != h.ApprovalNumbers){
                        h = new History();
                        h.ApprovalNumbers = Integer.valueOf(condd.ApprovalNumbers__c);
                        System.debug(' h.ApprovalNumbers-->'+ h.ApprovalNumbers);
                        HistoryList.add(h);
                    }
                    DiffMW = condd.DiffMW__c;
                    DiffPrice =condd.DiffPrice__c;
                    DiffQuantity =Integer.valueOf(condd.DiffQuantity__c);
                    DiffCommision = condd.DiffCommision__c;
                    h.DiffMW = DiffMW; 
                    h.DiffPrice = DiffPrice;       
                    h.DiffQuantity = DiffQuantity; 
                    h.DiffCommision = DiffCommision;
                    h.add(condd);
                }
                
                if(conDiffID.size()>0){
                    conLinDiffLst =[Select id,ApprovalNumbers__c,ProductName__c,Contract_Difference_Detail__c,Quantity_New__c,Quantity_Old__c,Total_MW_New__c,Total_MW_Old__c,
                                    DiffQuantity__c,DiffTotalMW__c,DiffTotoalPrice__c,DiffUnitPrice__c,Guaranteed_Delivery_Date_After__c,Guaranteed_Delivery_Date_Before__c,Type_of_module_After__c,Type_of_module_Before__c,
                                    Total_Price_New__c,Total_Price_Old__c,UnitPrice_New__c,UnitPrice_Old__c from ContractLineItem_Difference_Detail__c where Contract_Difference_Detail__c in: conDiffID];
                      system.debug('12345'+conLinDiffLst.size());
                     if(conLinDiffLst.size()>0){
                        for(ContractLineItem_Difference_Detail__c conLinDiff : conLinDiffLst){
                            
                            for(History h1 : HistoryList){
                                system.debug('6666--'+h1.ApprovalNumbers);
                                if(Integer.valueOf(conLinDiff.ApprovalNumbers__c) == h1.ApprovalNumbers){
                                      h1.addOpplinDiff(conLinDiff);
                                }
                            }
                    
                        }
                    }
                    
                     payDiffLst =[Select id,ApprovalNumbers__c,Contract_Difference_Detail__c,Amount_New__c,Amount_Old__c,Days_New__c,Days_Old__c,
                                 Down_Balance_Payment_After__c,Down_Balance_Payment_Old__c,Payment_Method_New__c,Payment_Method_Old__c,
                                 DiffAmount__c,DiffDays__c,DiffPercentage__c,
                                 Payment_Term_New__c,Payment_Term_Old__c,Percentage_New__c,Percentage_Old__c from Contract_Payment_Difference__c where Contract_Difference_Detail__c in: conDiffID];
                    system.debug('12345'+payDiffLst.size());
                    if(payDiffLst.size()>0){
                        for(Contract_Payment_Difference__c paydiff : payDiffLst){
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