public  class AmendmentSendEmailCtrl {
	public class Approver  {
		public Approver(string uEmail,string uName,string roleName,String uid){
			this.uEmail=uEmail;
			this.uName=uName;
			this.roleName=roleName;
			this.isSelect=true;
			this.uId = uId;
		}
        public boolean isSelect {get;set;}
        public String uEmail {get;set;}         
        public String uName {get;set;}
        public String roleName {get;set;}
        public String uId{get;set;}
	}
	
	public List<Approver> approverList {get;set;}
	public Contract con  {get;set;}
	public Amendment__c am {get;set;}
	
    public Static Boolean noSend = false ;
    
	public AmendmentSendEmailCtrl(ApexPages.StandardController sd){		
		try{
            //noSend = false;
			String amendId = ApexPages.currentPage().getParameters().get('id');	
            am = [select id,
                   RecordTypeId,
                  Order__r.Contract_Owner__c,
                   RecordType.Name,
                   Amendment_Point__c,
                   Amendment1__c,
                  Amendment2__c,
                  Amendment3__c,
                  Amendment4__c,
                  Amendment5__c,
                  Amendment6__c,
                  Amendment7__c,
                   Order__r.ContractId
                   from Amendment__c
                   where Id =: amendId];
                       
           system.debug('-----:' + amendId);
            
			if(String.isEmpty(am.Amendment_Point__c) || 
               (String.isEmpty(am.Amendment1__c)&&
                String.isEmpty(am.Amendment2__c)&&
                String.isEmpty(am.Amendment3__c)&&
                String.isEmpty(am.Amendment4__c)&&
                String.isEmpty(am.Amendment5__c)&&
                String.isEmpty(am.Amendment6__c)&&
                String.isEmpty(am.Amendment7__c))){  
                //nosend = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'You can send remind email until you fill in amendment Point && Amendment details'));
             }

            con = [select id,RecordTypeId from Contract where id =: am.Order__r.ContractId];
            
            system.debug('~~~~~~~~~~~~~~~>con:'+con);
			system.debug('~~~~~~~~~~~>am:'+am);
			
			set<Id> UserIds = new set<Id>();
			if(!Test.isRunningTest()){
                //ID submitJapanRecordTypeId = Schema.ObjectType.Amendment__c.getRecordTypeInfosByName().get('Purchase Agreement (EN)').getRecordTypeId;
                RecordType japanENRecordType = [select name ,SobjectType,id from RecordType where name =: 'Purchase Agreement (EN)' and SobjectType  =: 'Amendment__c']; //obj name
                RecordType japanJPRecordType = [select name ,id from RecordType where name =: 'Purchase Agreement (JP)'and SobjectType  =: 'Amendment__c'];
                RecordType globalRecordType = [select name ,id from RecordType where name =: 'Purchase Agreement'and SobjectType  =: 'Amendment__c'];
                RecordType globalSalesRecordType = [select name ,id from RecordType where name =: 'Sales Contracts'and SobjectType  =: 'Amendment__c'];
                
                if(am.RecordTypeId == japanENRecordType.Id || am.RecordTypeId == japanJPRecordType.Id){   
                    UserIds = SubmitReviewHelper.getContractReviewList(con.id);
	                User uLegalJP = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE  Id =: '00590000002sK0x']; //Legal Japan  name 
                    UserIds.add(uLegalJP.Id);
                    for(GroupMember gm : [Select gm.UserOrGroupId 
                                          from GroupMember gm 
                                          where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Purchase Agreement')]){
                                              UserIds.add(gm.UserOrGroupId);
                    }
                    system.debug('~~~>japanuserIds:'+ UserIds);
                    
                }else if(am.RecordTypeId == globalRecordType.Id || am.RecordTypeId == globalSalesRecordType.Id){                    
                    system.debug('====' + am.RecordType.Name );
                    UserIds = SubmitReviewHelper.getContractReviewList(con.id);
                    system.debug('==== UserIds' + UserIds );
					User uLegal  = [SELECT Id, Name, Email,UserRole.Name FROM User WHERE id =: '005900000012GJT'];//Legal Public
                    UserIds.add(uLegal.Id);                    
                    for(GroupMember gm : [Select gm.UserOrGroupId 
                                          from GroupMember gm 
                                          where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Purchase Agreement')]){
                                              UserIds.add(gm.UserOrGroupId);
                    }
                        
                }

	            RecordType rtp = [select r.Name, r.Id From RecordType r Where r.Name =:'Intercompany Contract' And SobjectType  =: 'Contract'];
	            
	            approverList =new List<Approver>();
	            if(con.RecordTypeId != rtp.Id){
		            for(User u : [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Id in:UserIds]){
		                approverList.add(new Approver(u.Email,u.Name,u.UserRole.Name,u.Id));
		            }
	            }else if(con.RecordTypeId == rtp.Id){
                    User usr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Name =: 'Alex Jiang'];
                    approverList.add(new Approver(usr.Email,usr.Name,usr.UserRole.Name,usr.Id));
	            }
			}
		system.debug('=======noSend: ' + noSend);
		}catch(Exception e){			
            //for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getStackTraceString()));
            //}
		}		
	}
	
    
    public void SelectAll(){
    	for( Approver aper : approverList ){
    		aper.isSelect = true; 
    	}
    }
    
    public void UnselectAll(){
    	for( Approver aper : approverList ){
    		aper.isSelect = false;
    	}
    }
    
    public PageReference sendMail(){
    	try{
            
             system.debug('=======noSend: ' + noSend);
            String amendId = ApexPages.currentPage().getParameters().get('id');
            am = [select id,
                   RecordTypeId,
                  Order__r.Contract_Owner__c,
                   RecordType.Name,
                   Amendment_Point__c,
                   Amendment1__c,
                  Amendment2__c,
                  Amendment3__c,
                  Amendment4__c,
                  Amendment5__c,
                  Amendment6__c,
                  Amendment7__c,
                   Order__r.ContractId
                   from Amendment__c
                   where Id =: amendId];
            if(String.isEmpty(am.Amendment_Point__c) || 
               (String.isEmpty(am.Amendment1__c)&&
                String.isEmpty(am.Amendment2__c)&&
                String.isEmpty(am.Amendment3__c)&&
                String.isEmpty(am.Amendment4__c)&&
                String.isEmpty(am.Amendment5__c)&&
                String.isEmpty(am.Amendment6__c)&&
                String.isEmpty(am.Amendment7__c))){  
                nosend = true;
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'Error: Please fill in Amendment Point and input Amendment detail before you submit for review ！'));
             }

            system.debug('=======noSend: ' + noSend);
	    	List<String> email = new List<String>();
			List<ID> selectUserIds = new List<ID>();
            List<String> selectUserName = new List<String>();
	        for (Approver u : approverList ) {
	        	if(u.isSelect){
	        		system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@'+u.uName);
					email.add(u.uEmail);
					system.debug('~~~~~~~~~~~>email:'+email);
					selectUserIds.add(u.uId);
                    selectUserName.add(u.uName);
	        		system.debug('~~~~~~~~~~~~~~~~~~~>selectUserIds:'+selectUserIds);					
	        	}
	        }
	        
	        system.debug('~~~~~~~~~~~~~~~>发邮件:');
	        List<SubmitForReview__c> reviewList = new List<SubmitForReview__c>();
			
			system.debug('~~~~~~~~>reviewList:' + reviewList);
			for(ID userid : selectUserIds){
				SubmitForReview__c review = new SubmitForReview__c();
				review.Amendment__c = am.Id;
				review.Status__c    = 'Pending';
				review.User__c      = userid;
				
				reviewList.add(review);
                
				System.debug('~~~~~~~~~userid'+userid);
				System.debug('~~~~~~~~~User__c'+review.User__c);
			}
			List<SubmitForReview__c> oldReviewList =[select id,Date__c,
														Remarks__c,
														Role__c,
														Status__c,
														User__c
														from SubmitForReview__c
														where Amendment__c =: am.Id
                                                    	AND User__c in: selectUserIds];
            system.debug('------>oldReviewList:' +  oldReviewList);
            
			if(oldReviewList.size()>0 && oldReviewList != null){
				delete oldReviewList;  //如果所选人员已经在其列表中，将其删除重新发送邮件审批。
			}

			if(reviewList.size() > 0)insert reviewList;	
            //AmendmentSendEmailCtrl.SendAmendmentReviewMail(approverList,am.Id);
            //CommonUtils.SendAmendmentReviewMail(u.uEmail,am.Id);
            system.debug('====== noSend' + noSend);
            if(!noSend){
                 system.debug('=======发送le ' );
                AmendmentSendEmailCtrl.SendAmendmentReviewMail(approverList,am.Id);
            }else{
                //  当为空的时候可以发邮件给 Owner 一封邮件 ，再次提醒！
                 system.debug('=======未发送 ');
            }
	        return Page.ReviewListResult;
	        
    	}catch(Exception ex){
    		for (Integer i = 0; i < ex.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getDmlMessage(i)));
            }
    	}
    	return null;
    }
	
    public void runTest(){
        String run = 'Run Test';
        run = 'Run Test';
    }
    
    public static void SendAmendmentReviewMail(List<Approver> recipients,String amId){
        try{
            
            if(recipients == null) return;
            if(recipients.size() == 0) return;
            List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
            List<EmailTemplate> mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =: 'AmendmentEmaiTemplate'];
            for(Approver user : recipients){
                List<String> emailList = new List<String>();
                Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage(); 
                mail.setSaveAsActivity(false);
                emailList.add(user.uEmail);
                mail.setToAddresses(emailList); 
                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setTargetObjectId(user.uId);
                if(mailTemplate.size()>0){
                    mail.setTemplateId(mailTemplate[0].Id);
                }
                if(amId != null)mail.setWhatId(amId);
                mail.setSenderDisplayName(UserInfo.getName());
                mailList.add(mail);
            }
            Messaging.sendEmail(mailList);
        }catch(Exception e){
            System.debug(String.valueOf(e));
        }
    }
    
}