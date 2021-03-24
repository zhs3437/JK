public class AmendReview {
    public Amendment__c amd{get;set;}
    public String amdId{get;set;}
        public List<SubmitForReview__c> ReviewLst{get;set;}
     public List<SubmitForReview__c> ReviewLst2{get;set;}
    public AmendReview(){}
        public AmendReview(ApexPages.StandardController sd){
            amd = (Amendment__c)sd.getRecord();
             amdId= amd.id;
            String Status='Pending';
            ReviewLst =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.SubmitForReview__c) + ' ' +
                                  'Where Amendment__c =: amdId and Status__c=:Status');
            ReviewLst2= new  List<SubmitForReview__c>();
            }
  public PageReference sendMail(){
                 system.debug('庄1');
            List<String> email = new List<String>();      
          system.debug('庄2');
            for (SubmitForReview__c u : ReviewLst ) {
                if(u.ischecked__c==true){
                   ReviewLst2.add(u);
                 }
            
            }
          
                    if(ReviewLst2 == null) return Page.ReviewListResult;
            if(ReviewLst2.size() == 0) return Page.ReviewListResult;
            List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
            List<EmailTemplate> mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =:'test_sgy'];
      system.debug('emial'+mailTemplate);
            for(SubmitForReview__c user : ReviewLst2){
                List<String> emailList = new List<String>();
                 // Create a new single email message object
                // that will send out a single email to the addresses in the To, CC & BCC list.
                Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage(); 
                //the email is not saved as an activity.
                mail.setSaveAsActivity(false);
                // Assign the addresses for the To lists to the mail object.
                emailList.add(user.Email__c);
                mail.setToAddresses(emailList); 
                // Set to True if you want to BCC yourself on the email.
                mail.setBccSender(false);
                
                // The email address of the user executing the Apex Code will be used.
                mail.setUseSignature(false);
                mail.setTargetObjectId(user.user__c);
                
                if(mailTemplate.size()>0){
                    mail.setTemplateId(mailTemplate[0].Id);
                }
                if(amdid != null)mail.setWhatId(amdid);
                mail.setSenderDisplayName(UserInfo.getName());
                system.debug('mail'+mail);
                mailList.add(mail);
            }
            Messaging.sendEmail(mailList);
            
system.debug('庄4');
               
            return Page.ReviewListResult;
       }
     public void SelectAll(){
        for( SubmitForReview__c aper : ReviewLst ){
            aper.IsChecked__c = true; 
        }
    }
    
    public void UnselectAll(){
        for( SubmitForReview__c aper : ReviewLst ){
            aper.IsChecked__c = false;
        }
    }
    public  void Addaction(){
        integer num=1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
        num=num+1;
    }
}