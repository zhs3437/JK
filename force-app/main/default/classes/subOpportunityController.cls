public class subOpportunityController {
	
    public String currentId {get;set;} 
    public String oppId{get;set;}
    public String orgServiceUrl{get;set;}
    public String oppName{get;set;}
    public String oppfaopp{get;set;}
    public String pageId{get;set;}
    public String oppType{get;set;}
    public String quantity{get;set;}
    public String price{get;set;}
    public String mw{get;set;}
    public String power{get;set;}
    public String FinanceApprovalDate{get;set;}
    public String PriceFinanceApprovalFinishTime{get;set;}
    public String PriceGMApprovalFinishTime{get;set;}
    public String PriceApprovalTriggerTime{get;set;}
    
    
    public subOpportunityController(){
        
    }
    public subOpportunityController(ApexPages.StandardSetController controller){
        currentId = ApexPages.currentPage().getParameters().get('oppId');
        oppId  = ApexPages.currentPage().getParameters().get('oppId');
        oppName= ApexPages.currentPage().getParameters().get('oppName');
        //自定义设置，自由改变页面ID
        system.debug('=========currentId: ' + currentId );
        SubOppParam__c sop = SubOppParam__c.getOrgDefaults();
        orgServiceUrl = sop.OrgServiceUrl__c;
        pageId 		= sop.oppId__c;
        oppName 	= sop.oppName__c;        
        oppType 	= sop.Opp_Type__c;
        quantity 	= sop.Total_Sub_Opp_Quantity__c;
        price		= sop.Total_Sub_Opp_Price__c;
        mw			= sop.Total_Sub_Opp_MW__c;
        power		= sop.Total_Sub_Opp_Power__c;
        FinanceApprovalDate 			= sop.Finance_Approval_Date__c;
        PriceFinanceApprovalFinishTime	= sop.Price_Finance_Approval_Finish_time__c;
        PriceGMApprovalFinishTime 		= sop.Price_GM_Approval_Finish_Time__c;
        PriceApprovalTriggerTime 		= sop.Price_Approval_Trigger_Time__c;
        
    }
    public PageReference goto(){
        Opportunity o =[Select id,Name,faOpportunity__c from Opportunity where id =:oppId ];
        PageReference newPage = new PageReference(orgServiceUrl+oppId+'/e?clone=1&retURL='+oppId);
       
        newPage.getParameters().put(pageId,o.Id);
        newPage.getParameters().put(oppName,o.Name); 
        newPage.getParameters().put(quantity,'');
        newPage.getParameters().put(price,'');
        newPage.getParameters().put(mw,'');
        newPage.getParameters().put(power,'');
        newPage.getParameters().put(FinanceApprovalDate,'');
        newPage.getParameters().put(PriceFinanceApprovalFinishTime,'');
        newPage.getParameters().put(PriceGMApprovalFinishTime,'');
        newPage.getParameters().put(PriceApprovalTriggerTime,'');        
        newPage.getParameters().put(oppType,'Under Frame');
        
        /*
        newPage.getParameters().put('CF00N0l000000W2FM_lkid',oppId);
        newPage.getParameters().put('CF00N0l000000W2FM',oppName); 
        newPage.getParameters().put('00N6F00000E23u6','Under Frame');
        newPage.getParameters().put('00N0l000000W5X9','');
        newPage.getParameters().put('00N0l000000W5Wz','');
        newPage.getParameters().put('00N0l000000W5WB','');
        newPage.getParameters().put('00N0l000000W5Wa','');
        newPage.getParameters().put('00N90000002wjOH','');
        newPage.getParameters().put('00N6F00000E27bd','');
	*/
        Opportunity opp =[Select id,Name,faOpportunity__c from Opportunity where id =:oppId ];
        
        if(String.isNotEmpty(opp.faOpportunity__c)){		//主业务机会下面的所有产品
            List<OpportunityLineItem> olLst = [Select id,OpportunityId From OpportunityLineItem Where OpportunityId =: opp.Id];    
            for(OpportunityLineItem oli : olLst){
                OpportunityLineItem ol = new OpportunityLineItem();
                ol.OpportunityId		= opp.id;
                ol.PricebookEntryId 	= oli.PricebookEntryId;
                //ol.Product2Id			= oli.Product2Id;
                ol.Quantity				= oli.Quantity;
                //ol.SAP_Materiel_No__c	= oli.SAP_Materiel_No__c;
                insert ol;
                
            }   
        }
      
        system.debug('=========currentId: ' + currentId );
        return newPage;
        
        
        
    }
    
}