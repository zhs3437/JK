public with sharing class AmendmentSubmitReviewCtrl {

	public String requestId{get;set;}
    public String userId{get;set;}
    public String remark{get;set;}
    public String revId{get;set;}
    
	public list<SubmitForReview__c> existReviews {get;set;}
	public Amendment__c Amendment{get;set;}
	
	public AmendmentSubmitReviewCtrl(ApexPages.StandardController sd){
		try{
			//amendment = (Amendment__c)sd.getRecord();
			requestId = ApexPages.currentPage().getParameters().get('id');
	        userId    = UserInfo.getUserId();
			system.debug('userId-->'+userId);
			Amendment = [SELECT Id,Name, RecordTypeId,CreatedById FROM Amendment__c WHERE Id =: requestId];

			if(Amendment != null){
				existReviews = [SELECT Id,
										Name,
										Date__c,
										Remarks__c,
										Status__c,
										Role__c,
										User__c
										FROM SubmitForReview__c 
										WHERE Amendment__c =: Amendment.Id];
				System.debug('~~~~~~~> existReviews: '+existReviews);
			}
			
		}catch(DmlException e){
			 for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
		}
		
	}

	public void SubmitApprove(){
        system.debug('同意');
    	if(revId != null && revId != ''){
                    system.debug('有值');
    		try{
            
    			SubmitForReview__c review =  [SELECT Id,Name,Remarks__c, Status__c, User__c, Date__c FROM SubmitForReview__c WHERE Id =: revId];
    			review.Status__c = 'Approved';
    			for(SubmitForReview__c rev : existReviews){
	    			if(rev.Id == revId){
	    				review.Remarks__c = rev.Remarks__c;
                        review.RoleCopy__c = review.Role__c;
	    			}
	    			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'OK'));
	    		}
	    		review.Date__c  = DateTime.now();
    			update review;
                //update Amendment;
    		}catch(Exception e){System.debug('-----> Error: '+String.valueOf(e));}
    	}
    }
    
    public void SubmitReject(){
    	if(revId != null && revId != ''){
    		try{
    			SubmitForReview__c review =  [SELECT Id,Name,Remarks__c, Status__c, User__c, Date__c FROM SubmitForReview__c WHERE Id =: revId];
    			review.Status__c = 'Rejected';
    			for(SubmitForReview__c rev : existReviews){
	    			if(rev.Id == revId){
	    				review.Remarks__c = rev.Remarks__c;
	    			}
	    		}
	    		review.Date__c  = DateTime.now();
    			update review;
    		}catch(Exception e){
    			System.debug('-----> Error: '+String.valueOf(e));
    		}
    	}
    }

}