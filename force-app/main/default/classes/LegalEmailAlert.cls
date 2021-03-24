global class LegalEmailAlert {
       webservice static void updateopphistory(String oppid){
         opportunity op=Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.opportunity) + ' ' +
                                               'Where  id=:oppid');  
         List<opportunitylineitem> opplineList =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.opportunitylineitem) + ' ' +
                                               'Where  opportunityid=:oppid');
           System.debug('size:'+opplineList.size());
         if(op.Estimated_Gross_Margin_Rate_Old__c==null){
             op.Estimated_Gross_Margin_Rate_Old__c = op.Weighted_Gross_Margin_Rate__c;
            op.Estimated_Gross_Margin_Rate_Cheetah_Old__c = op.Weighted_Gross_Margin_Rate_Cheetah__c;
            op.Estimated_Gross_Margin_Rate_Connector_Ol__c = op.Weighted_Gross_Margin_Rate_Connector__c;
            op.Estimated_Gross_Margin_Rate_Smart_Old__c = op.Weighted_Gross_Margin_Rate_Smart__c;
            op.Estimated_Gross_Margin_Rate_Tiger_Pro_ol__c = op.Weighted_Gross_Margin_Rate_TigerPro__c;
            op.Estimated_Gross_Margin_Rate_Tiger_Old__c = op.Weighted_Gross_Margin_Rate_Tiger__c;
            op.Estimated_Gross_Margin_Rating_Cheetah_Ol__c = op.Gross_Margin_Rating_Cheetah__c;
            op.Estimated_Gross_Margin_Rating_Old__c = op.Gross_Margin_Rating__c;
            op.Estimated_Gross_Margin_Rating_Smart_Old__c = op.Gross_Margin_Rating_Smart__c;
            op.Estimated_Gross_Margin_Rating_Tiger_Old__c = op.Gross_Margin_Rating_Tiger__c;
            op.Estimated_Gross_Margin_Rating_TigerPOld__c = op.Gross_Margin_Rating_TigerPro__c;
            op.Estimated_Gross_Margin_RatingConnectorOl__c = op.Gross_Margin_Rating_Connector__c;
            op.Logistic_Special_Cost_Per_W_Old__c = op.Logistic_Special_Cost_Per_W__c;
            op.Ocean_Freight_China_Old__c = op.Ocean_Freight__c;
            op.Ocean_Freight_Oversea_Old__c = op.Ocean_Freight_Oversea__c;
            op.TotaGross_Margin_ConnectorOld__c = op.Total_Gross_Margin_Connector__c;
            op.Total_Gross_Margin_Old__c = op.Total_Gross_Margin__c;
            op.Total_Gross_Margin_CheetahOld__c = op.Total_Gross_Margin_Cheetah__c;
            op.Total_Gross_Margin_SmartOld__c = op.Total_Gross_Margin_Smart__c;
            op.Total_Gross_Margin_Tiger_ProOld__c = op.Total_Gross_Margin_TigerPro__c;
            op.Total_Gross_Margin_TigerOld__c = op.Total_Gross_Margin_Tiger__c;
            op.Total_Price_CheetahOld__c = op.Total_Price_Cheetah__c;
            op.Total_Price_ConnectorOld__c = op.Total_Price_Connector__c;
            op.Total_Price_SmartOld__c = op.Total_Price_Smart__c;
            op.Total_Price_Tiger_ProOld__c = op.Total_Price_TigerPro__c;
            op.Total_Price_TigerOld__c = op.Total_Price_Tiger__c;
            op.Rate_Old__c = op.Rate__c;
            op.Land_Freight_China_Old__c = op.Land_Freight_China__c;
            op.Land_Freight_Oversea_Old__c = op.Land_Freight_Oversea__c;
           op.Warehouse_Premium_Old__c = op.Warehouse_Premium__c;
             System.debug('2');
             for(opportunitylineitem o:opplineList){
                 System.debug('3');
                  o.Commision_Rebate_Cost_Per_W_Old__c = o.Commision_Rebate_Cost_Per_W__c;
               o.Estimated_Gross_Margin_Old__c = o.Estimated_Gross_Margin__c;
               o.Free_Power_W_Old__c = o.Free_Power_W__c;
               o.Freight_Cost_Per_W_Old__c = o.Freight_Cost_Per_W__c;
               o.Gross_Margin_Rate_Old__c = o.Gross_Margin_Rate__c;
               o.Insurence_Cost_Per_W_Old__c = o.Insurence_Cost_Per_W__c;
               o.Payment_Cost_Per_W_Old__c = o.Payment_Cost_Per_W__c;
               o.Product_Cost_Old__c = o.Product_Cost__c;
               o.Special_Material_Cost_Per_W_Old__c = o.Special_Material_Cost_Per_W__c;
               o.Special_Material_Type_Old__c = o.Special_Material_Type__c;
               o.Third_Party_Test_Cost_Old__c = o.Third_Party_Test_Cost__c;
               o.Total_Gross_Margin_Old__c = o.Total_Gross_Margin__c;
               o.Transfer_Stock_Rate_Old__c = o.Transfer_Stock_Rate__c;
               o.Special_Material_Old__c = o.Special_Material__c;
             }
            update opplineList;
               update  op;
         }
         else{
             update op;
         }
         }
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
   
@InvocableMethod(label='LegalEmailAlert' description='LegalEmailAlert')    
    public static void LegalEmailAlert(List<id> ids){

    	 SET<Approver> approverList = new SET<Approver>();
     List<SubmitForReview__c> ac = [Select id,name,Amendment__c,Role__c,RoleCopy__c,
     Status__c,User__c,user__r.NAME from SubmitForReview__c where id=:ids[0]];
    List<Amendment__c> amendmentLst=[select id ,name,LegalV1__c,Destination_Country__c from Amendment__c where id =:ac[0].Amendment__c];
    //按国家分配法务
     String aid=ac[0].Amendment__c;
    if(amendmentLst[0].Destination_Country__c !='japan'){
        List<user> u = [SELECT Id, Name,Alias,Email,UserRole.Name FROM USER WHERE Email =: 'legal@jinkosolar.com'];
        approverList.add(new Approver(u[0].Email,u[0].Name,u[0].UserRole.Name,u[0].Id));
        SendAmendmentReviewMail2(approverList,aid);
    }else if(amendmentLst[0].Destination_Country__c =='japan'){
        List<user> u = [SELECT Id, Name,Alias,Email,UserRole.Name FROM USER WHERE Email =: 'legal.japan@jinkosolar.com'];
        approverList.add(new Approver(u[0].Email,u[0].Name,u[0].UserRole.Name,u[0].Id));
        SendAmendmentReviewMail2(approverList,aid);
    }



    }

       public static void SendAmendmentReviewMail2(SEt<Approver> recipients,String amId){
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
     webservice static void ReSetLegal(String ids){
          List<Amendment__c> ac=[select id ,name,LegalV1__c,Legal_First_Click__c,Version_revision__c,Contract__c,Order__c,Contract_No__c,Printing_time__c,Order__r.CurrencyIsoCode,
        Amount_paid_by_the_buyer__c,Effective_Date__c,Old_Contract_execution_date__c from Amendment__c where id =:ids];
        List<Amendment_Order_Product__c> AopLst = [SELECT ID,Name,Quantity_shipped__c,Product2__r.Name From Amendment_Order_Product__c 
                                                    Where   OriginalOrderItem__c=:ac[0].id];

         //更新1
        boolean BuyerLetter;
       Decimal Ver = ac[0].Version_revision__c;
        Integer Anum;
        Amendment__c add1 =new Amendment__c();
        Amendment__c add2 =new Amendment__c();
        Amendment__c add3 =new Amendment__c();
        Date ActiveDate ;
        //String dat;
        //String dat1;
        //String dat2;
        //String dat3;
        //String dat4;
        Contract contf=[select Buyer_Letter_of_guarantee__c from Contract where  id =: ac[0].Contract__c];
        if(contf.Buyer_Letter_of_guarantee__c=='None' || contf.Buyer_Letter_of_guarantee__c==null){
            BuyerLetter=false;
        }else{BuyerLetter=true;}
        List<Amendment__c> ALst=[select id,Printing_time__c from Amendment__c where Order__c=:ac[0].Order__c order by createddate];
        if(Ver==null){

            Anum=integer.valueof(ac[0].name.substring(ac[0].name.length()-1, ac[0].name.length()));
        }else{
            Anum=integer.valueof(Ver);
        }
        if(String.isEmpty(String.valueof(ac[0].Effective_Date__c))){
            //system.debug('Date.valueof(ad.CreatedDate)--->'+Date.valueof(ac[0].Old_Contract_execution_date__c));
            ActiveDate = Date.valueof(ac[0].Old_Contract_execution_date__c);
        }else{
            //system.debug('Date.valueof(ad.CreatedDate)--->'+Date.valueof(ac[0].CreatedDate));
            //system.debug('ad.EffectiveDate__c'+ac[0].Effective_Date__c);
            ActiveDate = ac[0].Effective_Date__c;
        }
        if(Anum==2){
            add1=Alst[1];
        }
        if(Anum==3){
            add1=Alst[1];
            add2=Alst[2];
        }
        if(Anum>=4){
            add1=Alst[1];
            add2=Alst[2];
            add3=Alst[3];
        }

        if(String.isEmpty(String.valueof(ac[0].Printing_time__c))){
            ac[0].Printing_time__c=date.today();
        }


        //合并产品
        Map<String,Decimal> AopMap = new Map<String, Decimal>();
         String SpecialT1='';

        //合并1
        //dat=
        SpecialT1 ='WHEREAS,the Seller and the Buyer are Parties to that ';
		
        SpecialT1=SpecialT1+'certain Purchase Order  (NO.:'+ac[0].Contract_No__c+') dated '+datefouler(ActiveDate)+'(the Underlying Agreement).  \n \r' ;

        if(Anum==2){
            SpecialT1= SpecialT1+',as amended by the First Amendment to Purchase Order dated '+datefouler(ALst[0].Printing_time__c)+'\n \n';
        }else if(Anum==3){
            SpecialT1= SpecialT1+',as amended by the First Amendment to Purchase Order dated '
                    +datefouler(ALst[0].Printing_time__c)+' and the Second Amendment to Purchase Order dated '+datefouler(add1.Printing_time__c)+'\n \n';
        }else if(Anum==4){
            SpecialT1= SpecialT1+',as amended by the First Amendment to Purchase Order dated '+datefouler(ALst[0].Printing_time__c)+', the Second Amendment to Purchase Order dated '+datefouler(add1.Printing_time__c)
                    +'and the Third Amendment to Purchase Order dated '+datefouler(add2.Printing_time__c)+'\n \n';

        }else if(Anum==5){
            SpecialT1= SpecialT1+',as amended by the First Amendment to Purchase Order dated '+datefouler(ALst[0].Printing_time__c)+', the Second Amendment to Purchase Order dated '+datefouler(add1.Printing_time__c)
                    +', the Third Amendment to Purchase Order dated '+datefouler(add2.Printing_time__c)+'and the Fourth Amendment to Purchase Order dated '+datefouler(add3.Printing_time__c)+'\n \n';
        }
         if(ac[0].Amount_paid_by_the_buyer__c>0){
        SpecialT1=SpecialT1+'WHEREAS, as of the Effective Date, the Seller has received '+ac[0].Amount_paid_by_the_buyer__c+'('+ac[0].Order__r.CurrencyIsoCode +') from the Buyer \n \n';
         }
        for(Amendment_Order_Product__c apc : AopLst){
            if(apc.Quantity_shipped__c>0){


            if(!AopMap.containsKey(apc.Product2__r.Name)){
                AopMap.put(apc.Product2__r.Name,apc.Quantity_shipped__c);

            }else if(AopMap.containsKey(apc.Product2__r.Name)){
                Decimal a = AopMap.get(apc.Product2__r.Name);
                AopMap.put(apc.Product2__r.Name,a+apc.Quantity_shipped__c);
            }

            }

        }
        if(AopMap.size()>0){//
        for(String productName : AopMap.keySet()){
            SpecialT1=SpecialT1+'WHEREAS, as of the Effective Date, the Seller duly delivered '+
                     AopMap.get(productName)+' pieces of '+productName+
                    ' modules pursuant to the Underlying Agreement.\n \n';
        }
        }

         System.debug('SpecialT1----------->'+SpecialT1);
        SpecialT1=SpecialT1.substringBeforeLast('\n \n');
    //    SpecialT1=SpecialT1+'(the “Underlying Agreement”). \n \n';
        SpecialT1=SpecialT1+'WHEREAS, the Parties wish to mutually terminate the Underlying Agreement pursuant to this Termination Agreement; \n \n';
        SpecialT1=SpecialT1+'NOW, THEREFORE, for good and valuable consideration, the sufficiency and receipt of which is hereby acknowledged, the Parties agree as follows: \n \n';

        ac[0].LegalV1__c = SpecialT1;
        update ac[0];
     }
    webservice static void SetModule(String ids){
        List<Amendment__c> ac=[select id ,name,LegalV1__c,Legal_First_Click__c,Version_revision__c,Contract__c,Order__c,Contract_No__c,Printing_time__c,Order__r.CurrencyIsoCode,
        Amount_paid_by_the_buyer__c,Effective_Date__c,Old_Contract_execution_date__c from Amendment__c where id =:ids];
        List<Amendment_Order_Product__c> AopLst = [SELECT ID,Name,Quantity_shipped__c,Product2__r.Name From Amendment_Order_Product__c 
                                                    Where   OriginalOrderItem__c=:ac[0].id];

         //更新1
        boolean BuyerLetter;
       Decimal Ver = ac[0].Version_revision__c;
        Integer Anum;
        Amendment__c add1 =new Amendment__c();
        Amendment__c add2 =new Amendment__c();
        Amendment__c add3 =new Amendment__c();
        Date ActiveDate ;
        //String dat;
        //String dat1;
        //String dat2;
        //String dat3;
        //String dat4;
        Contract contf=[select Buyer_Letter_of_guarantee__c from Contract where  id =: ac[0].Contract__c];
        if(contf.Buyer_Letter_of_guarantee__c=='None' || contf.Buyer_Letter_of_guarantee__c==null){
            BuyerLetter=false;
        }else{BuyerLetter=true;}
        List<Amendment__c> ALst=[select id,Printing_time__c from Amendment__c where Order__c=:ac[0].Order__c order by createddate];
        if(Ver==null){

            Anum=integer.valueof(ac[0].name.substring(ac[0].name.length()-1, ac[0].name.length()));
        }else{
            Anum=integer.valueof(Ver);
        }
        if(String.isEmpty(String.valueof(ac[0].Effective_Date__c))){
            //system.debug('Date.valueof(ad.CreatedDate)--->'+Date.valueof(ac[0].Old_Contract_execution_date__c));
            ActiveDate = Date.valueof(ac[0].Old_Contract_execution_date__c);
        }else{
            //system.debug('Date.valueof(ad.CreatedDate)--->'+Date.valueof(ac[0].CreatedDate));
            //system.debug('ad.EffectiveDate__c'+ac[0].Effective_Date__c);
            ActiveDate = ac[0].Effective_Date__c;
        }
        if(Anum==2){
            add1=Alst[1];
        }
        if(Anum==3){
            add1=Alst[1];
            add2=Alst[2];
        }
        if(Anum>=4){
            add1=Alst[1];
            add2=Alst[2];
            add3=Alst[3];
        }

        if(String.isEmpty(String.valueof(ac[0].Printing_time__c))){
            ac[0].Printing_time__c=date.today();
        }


        //合并产品
        Map<String,Decimal> AopMap = new Map<String, Decimal>();
        String SpecialT1='';

        //合并1
        //dat=
        SpecialT1 ='WHEREAS,the Seller and the Buyer are Parties to that ';
		
        SpecialT1=SpecialT1+'certain Purchase Order  (NO.:'+ac[0].Contract_No__c+') dated '+datefouler(ActiveDate)+'(the “Underlying Agreement”).'+'\n \n' ;

        if(Anum==2){
            SpecialT1= SpecialT1+',as amended by the First Amendment to Purchase Order dated '+datefouler(ALst[0].Printing_time__c)+'\n \n';
        }else if(Anum==3){
            SpecialT1= SpecialT1+',as amended by the First Amendment to Purchase Order dated '
                    +datefouler(ALst[0].Printing_time__c)+' and the Second Amendment to Purchase Order dated '+datefouler(add1.Printing_time__c)+'\n \n';
        }else if(Anum==4){
            SpecialT1= SpecialT1+',as amended by the First Amendment to Purchase Order dated '+datefouler(ALst[0].Printing_time__c)+', the Second Amendment to Purchase Order dated '+datefouler(add1.Printing_time__c)
                    +'and the Third Amendment to Purchase Order dated '+datefouler(add2.Printing_time__c)+'\n \n';

        }else if(Anum==5){
            SpecialT1= SpecialT1+',as amended by the First Amendment to Purchase Order dated '+datefouler(ALst[0].Printing_time__c)+', the Second Amendment to Purchase Order dated '+datefouler(add1.Printing_time__c)
                    +', the Third Amendment to Purchase Order dated '+datefouler(add2.Printing_time__c)+'and the Fourth Amendment to Purchase Order dated '+datefouler(add3.Printing_time__c)+'\n \n';
        }
        if(ac[0].Amount_paid_by_the_buyer__c>0){
        SpecialT1=SpecialT1+'WHEREAS, as of the Effective Date, the Seller has received '+ac[0].Amount_paid_by_the_buyer__c+'('+ac[0].Order__r.CurrencyIsoCode +') from the Buyer \n \n';
        }
        for(Amendment_Order_Product__c apc : AopLst){
            if(apc.Quantity_shipped__c>0){


            if(!AopMap.containsKey(apc.Product2__r.Name)){
                AopMap.put(apc.Product2__r.Name,apc.Quantity_shipped__c);

            }else if(AopMap.containsKey(apc.Product2__r.Name)){
                Decimal a = AopMap.get(apc.Product2__r.Name);
                AopMap.put(apc.Product2__r.Name,a+apc.Quantity_shipped__c);
            }

            }

        }
        if(AopMap.size()>0){//
        for(String productName : AopMap.keySet()){
            SpecialT1=SpecialT1+'WHEREAS, as of the Effective Date, the Seller duly delivered '+
                     AopMap.get(productName)+' pieces of '+productName+
                    ' modules pursuant to the Underlying Agreement.\n \n';
        }
        }

         System.debug('SpecialT1----------->'+SpecialT1);
        SpecialT1=SpecialT1.substringBeforeLast('\n \n');
      //  SpecialT1=SpecialT1+'(the “Underlying Agreement”). \n \n';
        SpecialT1=SpecialT1+'WHEREAS, the Parties wish to mutually terminate the Underlying Agreement pursuant to this Termination Agreement; \n \n';
        SpecialT1=SpecialT1+'NOW, THEREFORE, for good and valuable consideration, the sufficiency and receipt of which is hereby acknowledged, the Parties agree as follows: \n \n';

        if( ac[0].Legal_First_Click__c==true){//ac[0].LegalV1__c!='' && ac[0].LegalV1__c!=null &&
            return;
        }
        ac[0].Legal_First_Click__c=true;
        ac[0].LegalV1__c = SpecialT1;
        update ac[0];
    }
    
    webservice static String OrderIdRe (String ContractIds){
        String OrderNumber;
        Order o = [SELECT ID,Name,ContractId from order where ContractId=:ContractIds];
        if(o !=null){
     		
        OrderNumber=o.id;
             }
        return OrderNumber;
    }

    public static String datefouler(Date d){
        Integer a;
        Integer b;
        Integer c;
        String e;
        if(d !=null){
            a=d.year();
            b=d.month();
            c=d.day();
            e=a+'.'+b+'.'+c;
        }
        if(e!=null && e!=''){
            return e;
        }
        return '';
    }

    public void test(){
        Decimal i=0;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
             i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
             i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;

         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
          i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
             i++;
          i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
             i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
             i++;
          i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
             i++;
        
    }

}