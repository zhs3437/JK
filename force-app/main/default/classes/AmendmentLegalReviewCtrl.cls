public class AmendmentLegalReviewCtrl {
    
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
    
    // public List<Approver> approverList {get;set;}
    // public Contract con  {get;set;}
    //public SET<Approver> approverList {get;set;}
    public List<Approver> approverList {get;set;}
    /**
* for Legal Review button
*/
    public AmendmentLegalReviewCtrl(ApexPages.StandardController sd){
        try{
            String theId = ApexPages.currentPage().getParameters().get('id');
            //获取当前补充协议所有字段值
            Amendment__c Aord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                              'Where id =:theId');
            
            Id id1=Aord.Order__c;
            //查询终止协议关联的订单
            Order ord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order) + ' ' +
                                      'Where id =: id1');
            //审批人集合
          //  SET<Approver> approverList = new SET<Approver>();
             approverList = new List<Approver>();
            //查询终止协议中全部的在审批对象中的审批人   此步为了重置审批
        /*    List<SubmitForReview__c> fullReviews =[select id,Date__c,
                                                   Remarks__c,
                                                   Role__c,
                                                   Status__c,
                                                   User__c
                                                   from SubmitForReview__c
                                                   where Amendment__c =: theId];*/
            
           // if(fullReviews.size()>0){
           //     delete fullReviews;
          //  }
            
            
            
            //查询财务审批人 
            List<User> usr = [SELECT Id, Name,Alias,Email,UserRole.Name FROM USER WHERE Alias =: 'Alexjian'];
            //审批人集合添加财务 approverList
            if(usr.size()>0){
                approverList.add(new Approver(usr[0].Email,usr[0].Name,usr[0].UserRole.Name,usr[0].Id));
            }
            SYStem.debug('发邮件给 f');
            //查询订单的关联字段，由于database.query无法查询到关联字段，所以用sql的方法查询
            Order ordAmen =[Select id,Contract_Owner__c,Contract_Owner__r.BMO_specialist__c,Contract_Owner__r.Cross_Region_BMO__c,Destination_Region__c,Region__c FROM Order where id =:Aord.Order__c];
            //如果这不是个跨区订单，发邮件给SOC
            if(Aord.Cross_Region__c==false){
                //查询SOC
                List<User> usr2 = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE id =: ordAmen.Contract_Owner__r.BMO_specialist__c];
                if(usr.size()>0){
                    approverList.add(new Approver(usr2[0].Email,usr2[0].Name,usr2[0].UserRole.Name,usr2[0].Id)); 
                }
                SYStem.debug('发邮件给 SOC');
            }
            //如果跨区，发给跨区SOC
            else if(Aord.Cross_Region__c==true){
                //查询跨区SOC
                List<User> usr3 = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE id =: ordAmen.Contract_Owner__r.Cross_Region_BMO__c];
                if(usr.size()>0){
                    approverList.add(new Approver(usr3[0].Email,usr3[0].Name,usr3[0].UserRole.Name,usr3[0].Id)); 
                }
                SYStem.debug('发邮件给  跨区 SOC'); 
            }
            //我也不知道为啥写这条sql，都是谜语，我是复制前辈的
            List<Amendment__c> Aord2 =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                                     'Where id =:theId');
            if(Aord2.size()>0){
                //userid 是合同的owner
                String Userid= Aord2[0].Contract_Owner__c;
                //查询合同owner的GM邮箱和组长邮箱
                User us=[select id,Contract_Approver__r.Email,Contract_Review__r.Email from user where id =:userid];
                //这里放的GM
                String RegionHeadEmail = us.Contract_Approver__r.Email;
                //这里放的组长
                String RegionHeadEmail3 = us.Contract_Review__r.Email;
                //如果GM邮箱有值
                if(RegionHeadEmail !=null && RegionHeadEmail !=''){
                    //查询到GM的所有信息，包括职位
                    List<User> usr4 =[Select id,Name,Email,UserRole.Name from User where Email =:RegionHeadEmail];
                    
                    
                    if(usr4.size()>0){
                        approverList.add(new Approver(usr4[0].Email,usr4[0].Name,usr4[0].UserRole.Name,usr4[0].Id)); 
                    }
                    SYStem.debug('发邮件给 gm');
                    
                }
            }
            if(ordAmen!=null){
                if(ordAmen.Region__c=='Middle East&Africa'  ||ordAmen.Region__c == 'MENA'||ordAmen.Region__c == 'SSA'|| ordAmen.Region__c== 'Latin America&Italy' || ordAmen.Region__c== 'South Asia'){
                    List<User> usr5 = [SELECT Id, Name, Email,UserRole.Name,Alias FROM USER WHERE Alias =: 'technic2'];
                    //System.debug('1.user5.szie()----'+usr5.szie());
                    approverList.add(new Approver(usr5[0].Email,usr5[0].Name,usr5[0].UserRole.Name,usr5[0].Id)); 
                }else if(ordAmen.Region__c.contains('EU') || ordAmen.Region__c== 'ROA' ||ordAmen.Region__c== 'North America' ||
                  ordAmen.Region__c== 'North Asia' ||ordAmen.Region__c== 'Central Asia'){
                    List<User> usr5 = [SELECT Id, Name, Email,UserRole.Name,Alias FROM USER WHERE Alias =: 'tech'];
                    approverList.add(new Approver(usr5[0].Email,usr5[0].Name,usr5[0].UserRole.Name,usr5[0].Id));
                    //System.debug('2.user5.szie()----'+usr5.szie()); 
                }
            }
            //reviewlist
            List<SubmitForReview__c> reviewList = new List<SubmitForReview__c>();
            List<String> ApproverName = new List<String>(); 
            SET<Id> ApproverId = new SET<Id>();
            List<String> email = new List<String>();
            //循环所有审批人
            for (Approver u : approverList ) {          
                system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@'+u.uName);
                //添加审批人邮箱在邮箱集合中
                email.add(u.uEmail);
                system.debug('~~~~~~~~~~~>email:'+email);
                //添加审批人id在审批人id集合中
                ApproverId.add(u.uId);
                //添加审批人名字在审批人姓名集合中
                ApproverName.add(u.uName);
                system.debug('~~~~~~~~~~~~~~~~~~~>ApproverId:'+ApproverId);					           
            }
            system.debug('~~~~~~~~>reviewList:' + reviewList);
            system.debug('~~~~~~~~>approverList:' + approverList);
             system.debug('~~~~~~~~>approverList.size():' + approverList.size());
            //循环所有审批人id放进审批对象中
        /*    for(ID userid : ApproverId){
                SubmitForReview__c review = new SubmitForReview__c();
                review.Amendment__c = theId;
                review.Status__c    = 'Pending';
                review.User__c      = userid;            
                reviewList.add(review);            
                System.debug('~~~~~~~~~userid'+userid);
                System.debug('~~~~~~~~~User__c'+review.User__c);
            }
            
            //查询终止协议中在审批id集合中存在的审批人    
            List<SubmitForReview__c> oldReviewList =[select id,Date__c,
                                                     Remarks__c,
                                                     Role__c,
                                                     Status__c,
                                                     User__c
                                                     from SubmitForReview__c
                                                     where Amendment__c =: theId
                                                     AND User__c in: ApproverId];
            system.debug('------>oldReviewList:' +  oldReviewList);
            //查询终止协议中全部的在审批对象中的审批人
            List<SubmitForReview__c> fullReview =[select id,Date__c,
                                                  Remarks__c,
                                                  Role__c,
                                                  Status__c,
                                                  User__c
                                                  from SubmitForReview__c
                                                  where Amendment__c =: theId];
            
            //if(reviewList.size() > 0)insert reviewList;	       
           // AmendmentLegalReviewCtrl.SendAmendmentReviewMail2(approverList,theId);
            String emailnamelist='';
            if(ApproverName.size()>0){
                for(String emailname:ApproverName){
                    emailnamelist+=emailname+ ' ';
                }
            }    */                    
            
            
        }
        catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
        }
    }
    
    
    /* Add Start by Javen, 20130111, for work piece(20130111-00002) */
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
    
    
    public static void SendAmendmentReviewMail2(List<Approver> recipients,String amId){
        // try{
        System.debug('recipients------2830----'+recipients.size());
        if(recipients == null) return;
        if(recipients.size() == 0) return;
        List<Messaging.Singleemailmessage> mailList = new List<Messaging.Singleemailmessage>();
        List<EmailTemplate> mailTemplate = [SELECT ID FROM EmailTemplate WHERE developerName =:'AmendmentPurchaseAgreementEmail'];
        System.debug('mailTemplate---'+mailTemplate.size());
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
        System.debug('mailList---'+mailList.size());
        Messaging.sendEmail(mailList);   
        //  }catch(Exception e){System.debug(String.valueOf(e));  }
    }
    
     public PageReference sendMail(){
       // try{
           String theId = ApexPages.currentPage().getParameters().get('id');
            List<SubmitForReview__c> fullReviews =[select id,Date__c,
                                                   Remarks__c,
                                                   Role__c,
                                                   Status__c,
                                                   User__c
                                                   from SubmitForReview__c
                                                   where Amendment__c =: theId];



            List<String> email = new List<String>();            
            for (Approver u : approverList ) {
                if(u.isSelect){
                    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@'+u.uName);
                    email.add(u.uEmail);

                  /*if(u.roleName.contains('Technical')){
                  SubmitForReview__c s = new SubmitForReview__c();
                  s.Status__c= 'Pending';
                  s.User__c=u.uId;
                  s.Amendment__c=theId;
                  insert s;
                  }*/
                 }
            
            }

            //查找重复的审批人，重置审批
            List<SubmitForReview__c> reviewers = new List<SubmitForReview__c>();
            for(SubmitForReview__c reviewer :fullReviews){
                if (reviewer.Role__c.contains('Legal')) {
                  delete reviewer;
                }

              for (Approver u : approverList ) {
                if(u.uId == reviewer.User__c && u.isSelect){
                  reviewer.Status__c= 'Pending';
                  reviewers.add(reviewer);
                }
                /*else if(u.uId == reviewer.User__c && u.isSelect && u.roleName.contains('Technical')){
                    System.debug('[reviewers.remove(fullReviews.indexOf(reviewer))::String]:watches' +
                            JSON.serialize(reviewers.remove(fullReviews.indexOf(reviewer))));
                    reviewers.remove(fullReviews.indexOf(reviewer));
                }*/

              }
            }
            update reviewers;



          System.debug('测试23333-------->'+email);
            
         
           AmendmentLegalReviewCtrl.SendAmendmentReviewMail2(approverList,theId);
          
         
            
            
         

          
                       
               
            return Page.ReviewListResult;
      /*  }catch(Exception ex){
            for (Integer i = 0; i < ex.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getDmlMessage(i)));
            }
        }*/
        //return null;
    }
    
    
    
}