public class CommissionApplicationVFCtrl {
    public Commission_Application__c ca{get;set;}  
    public Commission_Application__c caold;
    public List<Commission_Application__c> calst{get;set;}  
    public opportunity opp;
        public String num{get;set;}
    public String oppCurrencyIsoCode{get;set;}
    public String requestId{get;set;} 

    public   Transient blob blob1 {get;set;}
    public   String blob1name {get;set;} 
    public    Transient blob blob14 {get;set;} 
    public   String blob14name {get;set;} 
    public    Transient blob blob15 {get;set;} 
    public   String blob15name {get;set;} 
    public   Transient blob blob16 {get;set;} 
    public   String blob16name {get;set;} 
    public   Transient blob blob17 {get;set;} 
    public   String blob17name {get;set;} 
    public   Transient blob blob23 {get;set;} 
    public   String blob23name {get;set;} 
    public   Transient blob blob24 {get;set;} 
    public   String blob24name {get;set;} 
    public   Transient blob blob25 {get;set;} 
    public   String blob25name {get;set;} 
    public   Transient blob blob26 {get;set;} 
    public   String blob26name {get;set;} 
    public   Transient blob blob27 {get;set;} 
    public   String blob27name {get;set;} 
    public   Transient blob blob29 {get;set;} 
    public   String blob29name {get;set;}
    public   Transient blob blob211 {get;set;} 
    public   String blob211name {get;set;}
    public   Transient blob blob212 {get;set;} 
    public   String blob212name {get;set;}
    public   Transient blob blob213 {get;set;} 
    public   String blob213name {get;set;}
    public   Transient blob blob215 {get;set;} 
    public   String blob215name {get;set;}
    public   Transient blob blob219 {get;set;}
    public   String blob219name {get;set;}
    public   String haha {get;set;}
    
    
    public CommissionApplicationVFCtrl(ApexPages.StandardController ctrl){
        requestId=ctrl.getid();
        num=ApexPages.currentPage().getParameters().get('num');
        system.debug('num='+num);
          ID mainid    = Schema.SObjectType.Commission_Application__c.getRecordTypeInfosByName().get('Main').getRecordTypeId();
        ID secondid          = Schema.SObjectType.Commission_Application__c.getRecordTypeInfosByName().get('Second').getRecordTypeId();
        ID thirdid     = Schema.SObjectType.Commission_Application__c.getRecordTypeInfosByName().get('Third').getRecordTypeId();
         opp=[select id,name,Actual_Commission2__c,Actual_Commission3__c,Commission_Type2__c,Commission_Type3__c,CurrencyIsoCode,Total_Price__c,Total_MW__c,CommissionOver1__c from opportunity where id=:requestId];
        oppCurrencyIsoCode=opp.CurrencyIsoCode;
        calst= new List<Commission_Application__c>();
        if(num=='1'){
            system.debug('start1');
            calst =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application__c) + ' ' +
                              'Where opportunity__c =: requestId and RecordTypeid =:mainid order by CreatedDate DESC');}
        if(num=='2'){
            system.debug('start2');
            calst =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application__c) + ' ' +
                              'Where opportunity__c =: requestId and RecordTypeid =:secondid order by CreatedDate DESC');}
        if(num=='3'){
            system.debug('start3');
            calst =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application__c) + ' ' +
                              'Where opportunity__c =: requestId and RecordTypeid =:thirdid order by CreatedDate DESC');}
        
        system.debug('calst='+calst);        
        if(num=='1'){
        if(calst.size()==0){
            ca =new Commission_Application__c();
            ca.name=opp.name+'  V1';
            ca.opportunity__c=ctrl.getid();
            ca.RecordTypeid=mainid;
        }else if(calst.size()>0){
            ca=calst[0];
            List<Commission_Application__c> caoldlist =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application__c) + ' ' +
                                                                      'Where opportunity__c =: requestId and RecordTypeid =:mainid order by CreatedDate DESC');
            caold=caoldlist[0];
            
        }
        }
        
        else if(num=='2'){
        if(calst.size()==0){
            ca =new Commission_Application__c();
            ca.name=opp.name+'  S1';
            ca.opportunity__c=ctrl.getid();
            ca.RecordTypeid=secondid;
        }else if(calst.size()>0){
            ca=calst[0];
            List<Commission_Application__c> caoldlist =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application__c) + ' ' +
                                                                      'Where opportunity__c =: requestId and RecordTypeid =:secondid order by CreatedDate DESC');
            caold=caoldlist[0];
            
        }
        }
        
       else if(num=='3'){
        if(calst.size()==0){
            ca =new Commission_Application__c();
            ca.name=opp.name+'  T1';
            ca.opportunity__c=ctrl.getid();
            ca.RecordTypeid=thirdid;
        }else if(calst.size()>0){
            ca=calst[0];
            List<Commission_Application__c> caoldlist =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application__c) + ' ' +
                                                                      'Where opportunity__c =: requestId and RecordTypeid =:thirdid order by CreatedDate DESC');
            caold=caoldlist[0];
            
        }
        }
        else{
            if(calst.size()==0){
            ca =new Commission_Application__c();
            ca.name=opp.name+'  V1';
            ca.opportunity__c=ctrl.getid();
            ca.RecordTypeid=thirdid;
        }else if(calst.size()>0){
            ca=calst[0];
            List<Commission_Application__c> caoldlist =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Commission_Application__c) + ' ' +
                                                                      'Where opportunity__c =: requestId  order by CreatedDate DESC');
            caold=caoldlist[0];
            
        }
            
        }
        
    }

    public void Addsobj(){ 
        system.debug(blob1);
                system.debug(blob14);
        system.debug(blob1name);
        if(calst.size()==0){
            system.debug(blob1);
            Attachment Attachment1 = new Attachment();
            Attachment Attachment14 = new Attachment();
            Attachment Attachment15 = new Attachment();
            Attachment Attachment16 = new Attachment();
            Attachment Attachment17 = new Attachment();
            Attachment Attachment23 = new Attachment();
            Attachment Attachment24 = new Attachment();
            Attachment Attachment25 = new Attachment();
            Attachment Attachment26 = new Attachment();
            Attachment Attachment27 = new Attachment();
            Attachment Attachment29 = new Attachment();
            Attachment Attachment211 = new Attachment();
            Attachment Attachment212 = new Attachment();
            Attachment Attachment213 = new Attachment();
            Attachment Attachment215 = new Attachment();
            Attachment Attachment219 = new Attachment();
            Attachment1.body=blob1;Attachment14.body=blob14;Attachment15.body=blob15;
            Attachment16.body=blob16;Attachment17.body=blob17;Attachment23.body=blob23;Attachment24.body=blob24;
            Attachment25.body=blob25;Attachment26.body=blob26;Attachment27.body=blob27;Attachment29.body=blob29;
            Attachment211.body=blob211;Attachment212.body=blob212;Attachment213.body=blob213;Attachment215.body=blob215;
            Attachment219.body=blob219;
            system.debug(Attachment1.body);
            if(opp.Total_MW__c>0){
                 if(num=='1'){
             if(ca.Commission_Per_watt__c>opp.Total_Price__c/(opp.Total_MW__c *1000000)/100 && opp.CommissionOver1__c==false){
                  ca.addError( 'Please note there is a mandatory 1% cap for any commission requested. In case a higher commission is necessary, please provide all related info to Gener, Charlie and Jeffrey for email approval, after which you could request David from IT to unlock this restriction of 1% .');
                  return;
              }
                     }
                }
            if( ca.Role_of_Buyer_in_the_project__c=='Others' && (ca.Role_of_Buyer_in_the_project_Text__c==null || ca.Role_of_Buyer_in_the_project_Text__c=='')
               
              ){
                  ca.addError( '14.2: You must enter a value');
                  return;
              }
            if( ca.X15_1__c=='YES' && (ca.X15_1_TEXT__c==null || ca.X15_1_TEXT__c=='')
               
              ){
                  ca.addError( '15.1: Explain the business and historical contracts with Jinko');
                  return;
              }
            if( ca.X15_2__c=='YES' && (ca.X15_2_TEXT__c==null || ca.X15_2_TEXT__c=='')
               
              ){
                  ca.addError( '15.2: Please specify the name and position');
                  return;
              }
            if( ca.X15_3__c=='YES' && (ca.X15_3_TEXT__c==null || ca.X15_3_TEXT__c=='')
               
              ){
                  ca.addError( '15.3: Please specify the name and position');
                  return;
              }
            if( ca.X18_1__c=='YES' && (ca.X18_1_TEXT__c==null || ca.X18_1_TEXT__c=='')
               
              ){
                  ca.addError( '18.1: Please specify the share holding percentage');
                  return;
              }
            if( ca.X18_2__c=='YES' && (ca.X18_2_TEXT__c==null || ca.X18_2_TEXT__c=='')
               
              ){
                  ca.addError( '18.2: Please specify the share holding percentage');
                  return;
              }
            if( ca.X18_3__c=='YES' && (ca.X18_3_TEXT__c==null || ca.X18_3_TEXT__c=='')
               
              ){
                  ca.addError( '18.3: Please specify how this actual control is achieved ');
                  return;
              }
            if( ca.X18_4__c=='YES' && (ca.X18_4_TEXT__c==null || ca.X18_4_TEXT__c=='')
               
              ){
                  ca.addError( '18.4: Please specify how this actual control is achieved ');
                  return;
              }
            if( ca.X18_5__c=='YES' && (ca.X18_5_TEXT__c==null || ca.X18_5_TEXT__c=='')
               
              ){
                  ca.addError( '18.5: Please specify the position');
                  return;
              }
            if( ca.X18_6__c=='YES' && (ca.X18_6_TEXT__c==null || ca.X18_6_TEXT__c=='')
               
              ){
                  ca.addError( '18.6: Please specify the position');
                  return;
              }
            if( ca.X18_7__c=='YES' && (ca.X18_7_TEXT__c==null || ca.X18_7_TEXT__c=='')
               
              ){
                  ca.addError( '18.7: Please specify the position');
                  return;
              }
             if( (Attachment1.body ==null
               
               || Attachment14.body ==null|| Attachment15.body ==null|| Attachment16.body ==null|| Attachment17.body ==null
               || Attachment23.body ==null|| Attachment24.body ==null|| Attachment25.body ==null|| Attachment26.body ==null|| Attachment27.body ==null
               || Attachment29.body ==null|| Attachment211.body ==null|| Attachment212.body ==null|| Attachment213.body ==null|| Attachment215.body ==null
               || Attachment219.body ==null)
               
              ){
                  if(Attachment1.body ==null ){
                  ca.addError( '因Part 1 item2 Business license & Tax registration certificate 文件未上传 ,请重新添加 所有 必须附件');
                  ca.addError( 'Part 1 item2 uploading failed, please re-attach all the documents.');
                      return;
                  }
                if(Attachment14.body ==null){
                 ca.addError( '因Part 1 item4 Business card or staff card 文件未上传 ,请重新添加 所有 必须附件');
                    ca.addError( 'Part 1 item4 uploading failed, please re-attach all the documents.');
                    return;
                  }
                if(Attachment15.body ==null){
                  ca.addError( '因Part 1 item5 Staff card or business card 文件未上传 ,请重新添加 所有 必须附件');
                    ca.addError( 'Part 1 item5 uploading failed, please re-attach all the documents.');
                    return;
                  }
                if(Attachment16.body ==null){
                 ca.addError( '因Part 1 item6 Any official documentation proof 文件未上传 ,请重新添加 所有 必须附件'); 
                      ca.addError( 'Part 1 item6 uploading failed, please re-attach all the documents.');
                    return;
                  }
                if(Attachment17.body ==null){
                 ca.addError( '因Part 1 item 7 Organization chart 文件未上传 ,请重新添加 所有 必须附件');
                   ca.addError( 'Part 1 item 7 uploading failed, please re-attach all the documents.');
                    return;
                  }
                if(Attachment23.body ==null){
                 ca.addError( '因Part 2 item3 Business card or staff card 文件未上传 ,请重新添加 所有 必须附件');
                    ca.addError( 'Part 2 item3 uploading failed, please re-attach all the documents.');
                    return;
                  }
                if(Attachment24.body ==null){
                  ca.addError( '因Part 2 item 4  Staff card or business card 文件未上传 ,请重新添加 所有 必须附件');
                    ca.addError( 'Part 2 item 4 uploading failed, please re-attach all the documents.');
                    return;
                  }
                if(Attachment25.body ==null){
                  ca.addError( '因Part 2 item 5 Business card or staff card 文件未上传 ,请重新添加 所有 必须附件');
                    ca.addError( 'Part 2 item 5 uploading failed, please re-attach all the documents.');
                    return;
                  }
                if(Attachment26.body ==null){
                  ca.addError( '因Part 2 item 6 ID card 文件未上传 ,请重新添加 所有 必须附件');
                    ca.addError( 'Part 2 item 6 uploading failed, please re-attach all the documents.');
                    return;
                  }
                if(Attachment27.body ==null){
                  ca.addError( '因Part 2 item 7 Business license & Tax registration certificate 文件未上传 ,请重新添加 所有 必须附件');
                    ca.addError( 'Part 2 item 7 uploading failed, please re-attach all the documents.');
                    return;
                  }
                if(Attachment29.body ==null){
                  ca.addError( '因Part 2 item 9 Any official documentation proof 文件未上传 ,请重新添加 所有 必须附件');
                    ca.addError( 'Part 2 item 9 uploading failed, please re-attach all the documents.');
                    return;
                  }
                if(Attachment211.body ==null){
                  ca.addError( '因Part 2 item 11 Organization Chart 文件未上传 ,请重新添加 所有 必须附件');
                    ca.addError( 'Part 2 item 11 uploading failed, please re-attach all the documents.');
                    return;
                  }
                if(Attachment212.body ==null){
                  ca.addError( '因Part 2 item 12 ID card 文件未上传 ,请重新添加 所有 必须附件');
                      ca.addError( 'Part 2 item 12 uploading failed, please re-attach all the documents.');
                  return;
                  }
                if(Attachment213.body ==null){
                  ca.addError( '因Part 2 item 13 ID card 文件未上传 ,请重新添加 所有 必须附件');
                      ca.addError( 'NO.2/13 uploading failed, please re-attach all the documents.');
                  return;
                  }
                if(Attachment215.body ==null){
                  ca.addError( '因Part 2 item 15 Contracts / Emails / other documentary record 文件未上传 ,请重新添加 所有 必须附件');
                    ca.addError( 'Part 2 item 15 uploading failed, please re-attach all the documents.');
                    return;
                  }
                if(Attachment219.body ==null){
                  ca.addError( '因Part 2 item 19 Emails / audio / vedio / other documentary record (Multiple) 文件未上传 ,请重新添加 所有 必须附件');
                    ca.addError( 'Part 2 item 19 uploading failed, please re-attach all the documents.');
                    return;
                  }
              }

            upsert ca;
            
            system.debug('ca.id:'+ca.id);
            system.debug('Attachment1:'+Attachment1);
            Attachment1.name = blob1name;
            Attachment1.parentId = ca.id; 
            Attachment14.name = blob14name;
            Attachment14.parentId = ca.id;
            Attachment15.name = blob15name;
            Attachment15.parentId = ca.id;
            Attachment16.name = blob16name;
            Attachment16.parentId = ca.id;
            Attachment17.name = blob17name;
            Attachment17.parentId = ca.id;
            Attachment23.name = blob23name;
            Attachment23.parentId = ca.id;
            Attachment24.name = blob24name;
            Attachment24.parentId = ca.id;
            Attachment25.name = blob25name;
            Attachment25.parentId = ca.id;
            Attachment26.name = blob26name;
            Attachment26.parentId = ca.id;
            Attachment27.name = blob27name;
            Attachment27.parentId = ca.id;
            Attachment29.name = blob29name;
            Attachment29.parentId = ca.id;
            Attachment211.name = blob211name;
            Attachment211.parentId = ca.id;
            Attachment212.name = blob212name;
            Attachment212.parentId = ca.id;
            Attachment213.name = blob213name;
            Attachment213.parentId = ca.id;
            Attachment215.name = blob215name;
            Attachment215.parentId = ca.id;
            Attachment219.name = blob219name;
            Attachment219.parentId = ca.id;
            
            List<Attachment> alst= new List<Attachment>();
            alst.add(Attachment1);
            
            alst.add(Attachment14);
            
            alst.add(Attachment15);
            alst.add(Attachment16);
            alst.add(Attachment17);
            alst.add(Attachment23);
            alst.add(Attachment24);
            alst.add(Attachment25);
            alst.add(Attachment26);
            alst.add(Attachment27);
            alst.add(Attachment29);
            alst.add(Attachment211);
            alst.add(Attachment212);
            alst.add(Attachment213);
            alst.add(Attachment215);
            alst.add(Attachment219);
            if(alst.size()>0){
            insert alst;
            ca.file_id__c=Attachment1.id;
            
            ca.X1_4_file_id__c=Attachment14.id;
            ca.X1_5_file_id__c=Attachment15.id;
            ca.X1_6_file_id__c=Attachment16.id;
            ca.X1_7_file_id__c=Attachment17.id;
            ca.X2_3_file_id__c=Attachment23.id;
            ca.X2_4_file_id__c=Attachment24.id;
            ca.X2_5_file_id__c=Attachment25.id;
            ca.X2_6_file_id__c=Attachment26.id;
            ca.X2_7_file_id__c=Attachment27.id;
            ca.X2_9_file_id__c=Attachment29.id;
            ca.X2_11_file_id__c=Attachment211.id;
            ca.X2_12_file_id__c=Attachment212.id;
            ca.X2_13_file_id__c=Attachment213.id;
            ca.X2_15_file_id__c=Attachment215.id;
            ca.X2_19_file_id__c=Attachment219.id;
            ca.CurrencyIsoCode=opp.CurrencyIsoCode;
           
                }
                   if(num=='1'){
            String flag=sandboxemailtoCEO();
                       if(flag=='1'){upsert ca;}
                   }else{
             upsert ca;
                               ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.WARNING , 'Save Successful'));
                       }
        }
        if(calst.size()>0){
            system.debug('>1的情况');
             if(opp.Total_MW__c>0){
                 if(num=='1'){
              if(ca.Commission_Per_watt__c>opp.Total_Price__c/(opp.Total_MW__c *1000000)/100&& opp.CommissionOver1__c==false){
                  ca.addError( 'Amount exceed error, commission amount is not allow exceed 1% of total amount, for more details please contact with Finance Alex or CFO assistant Russell. Thanks!');
                  return;
}
                 }
                 }
            if( ca.Role_of_Buyer_in_the_project__c=='Others' && (ca.Role_of_Buyer_in_the_project_Text__c==null || ca.Role_of_Buyer_in_the_project_Text__c=='')
               
              ){
                  ca.addError( '14.2: You must enter a value');
                  return;
              }
            if( ca.X15_1__c=='YES' && (ca.X15_1_TEXT__c==null || ca.X15_1_TEXT__c=='')
               
              ){
                  ca.addError( '15.1: Explain the business and historical contracts with Jinko');
                  return;
              }
            if( ca.X15_2__c=='YES' && (ca.X15_2_TEXT__c==null || ca.X15_2_TEXT__c=='')
               
              ){
                  ca.addError( '15.2: Please specify the name and position');
                  return;
              }
            if( ca.X15_3__c=='YES' && (ca.X15_3_TEXT__c==null || ca.X15_3_TEXT__c=='')
               
              ){
                  ca.addError( '15.3: Please specify the name and position');
                  return;
              }
            if( ca.X18_1__c=='YES' && (ca.X18_1_TEXT__c==null || ca.X18_1_TEXT__c=='')
               
              ){
                  ca.addError( '18.1: Please specify the share holding percentage');
                  return;
              }
            if( ca.X18_2__c=='YES' && (ca.X18_2_TEXT__c==null || ca.X18_2_TEXT__c=='')
               
              ){
                  ca.addError( '18.2: Please specify the share holding percentage');
                  return;
              }
            if( ca.X18_3__c=='YES' && (ca.X18_3_TEXT__c==null || ca.X18_3_TEXT__c=='')
               
              ){
                  ca.addError( '18.3: Please specify how this actual control is achieved ');
                  return;
              }
            if( ca.X18_4__c=='YES' && (ca.X18_4_TEXT__c==null || ca.X18_4_TEXT__c=='')
               
              ){
                  ca.addError( '18.4: Please specify how this actual control is achieved ');
                  return;
              }
            if( ca.X18_5__c=='YES' && (ca.X18_5_TEXT__c==null || ca.X18_5_TEXT__c=='')
               
              ){
                  ca.addError( '18.5: Please specify the position');
                  return;
              }
            if( ca.X18_6__c=='YES' && (ca.X18_6_TEXT__c==null || ca.X18_6_TEXT__c=='')
               
              ){
                  ca.addError( '18.6: Please specify the position');
                  return;
              }
            if( ca.X18_7__c=='YES' && (ca.X18_7_TEXT__c==null || ca.X18_7_TEXT__c=='')
               
              ){
                  ca.addError( '18.7: Please specify the position');
                  return;
              }
            
            Attachment Attachment1 = new Attachment();
            Attachment Attachment14 = new Attachment();
            Attachment Attachment15 = new Attachment();
            Attachment Attachment16 = new Attachment();
            Attachment Attachment17 = new Attachment();
            Attachment Attachment23 = new Attachment();
            Attachment Attachment24 = new Attachment();
            Attachment Attachment25 = new Attachment();
            Attachment Attachment26 = new Attachment();
            Attachment Attachment27 = new Attachment();
            Attachment Attachment29 = new Attachment();
            Attachment Attachment211 = new Attachment();
            Attachment Attachment212 = new Attachment();
            Attachment Attachment213 = new Attachment();
            Attachment Attachment215 = new Attachment();
            Attachment Attachment219 = new Attachment();
            Attachment1.body=blob1;Attachment14.body=blob14;Attachment15.body=blob15;
            Attachment16.body=blob16;Attachment17.body=blob17;Attachment23.body=blob23;Attachment24.body=blob24;
            Attachment25.body=blob25;Attachment26.body=blob26;Attachment27.body=blob27;Attachment29.body=blob29;
            Attachment211.body=blob211;Attachment212.body=blob212;Attachment213.body=blob213;Attachment215.body=blob215;
            Attachment219.body=blob219;           
            if(caold.Office_address_of_Buyer__c!=ca.Office_address_of_Buyer__c || caold.Contact_person_of_Buyer__c !=ca.Contact_person_of_Buyer__c
               || caold.Position_of_contact_person_in_the_Buyer__c != ca.Position_of_contact_person_in_the_Buyer__c 
                || caold.Commission2_Type__c != ca.Commission2_Type__c 
                || caold.Commission3_Type__c != ca.Commission3_Type__c 
                || caold.Contract_Commission2__c != ca.Contract_Commission2__c 
                || caold.Contract_Commission3__c != ca.Contract_Commission3__c 
               || caold.Shareholder_of_Buyer__c!=ca.Shareholder_of_Buyer__c || caold.Contract_Unit_price__c!= ca.Contract_Unit_price__c
               || caold.Project_Location_Coutry__c !=ca.Project_Location_Coutry__c ||caold.Project_location_Address__c!= ca.Project_location_Address__c
               || caold.Role_of_Buyer_in_the_project__c != ca.Role_of_Buyer_in_the_project__c ||caold.Nature_of_project__c!=ca.Nature_of_project__c
               || caold.Commission_Per_watt__c != ca.Commission_Per_watt__c || caold.Commission_Payee_Company__c != ca.Commission_Payee_Company__c
               || caold.Name_of_contact_person_of_Payee__c != ca.Name_of_contact_person_of_Payee__c || caold.Position_of_contact_person_in_the_Payee__c!= ca.Position_of_contact_person_in_the_Payee__c
               || caold.Mobile_Number_of_contact_person_of_Payee__c != ca.Mobile_Number_of_contact_person_of_Payee__c
               || caold.The_photocopy_of_ID_card__c !=ca.The_photocopy_of_ID_card__c || caold.X7_1_TEXT__c!= ca.X7_1_TEXT__c
               || caold.X7_2_TEXT__c!=ca.X7_2_TEXT__c || caold.X7_3__c != ca.X7_3__c ||caold.X7_4_TEXT__c!=ca.X7_4_TEXT__c
               || caold.Address_of_Payee__c !=ca.Address_of_Payee__c || caold.Shareholder_of_Payee__c !=ca.Shareholder_of_Payee__c
               || caold.The_actual_controller_of_Payee__c != ca.The_actual_controller_of_Payee__c || caold.The_photocopy_of_ID_card_of_shareholders__c != ca.The_photocopy_of_ID_card_of_shareholders__c
               || caold.The_photocopy_of_ID_card_of_actual_contr__c !=ca.The_photocopy_of_ID_card_of_actual_contr__c || caold.Number_of_employees_of_Payee__c!=ca.Number_of_employees_of_Payee__c
               || caold.X15_1_TEXT__c != ca.X15_1_TEXT__c ||caold.X15_2_TEXT__c !=ca.X15_2_TEXT__c || caold.X15_3_TEXT__c!=ca.X15_3_TEXT__c
               || caold.Role_of_the_Payee_in_the_Project__c != ca.Role_of_the_Payee_in_the_Project__c 
               || caold.Work_done_by_the_Payee_for_Jinko__c != ca.Work_done_by_the_Payee_for_Jinko__c
               || caold.X18_1_TEXT__c !=ca.X18_1_TEXT__c || caold.X18_2_TEXT__c!=ca.X18_2_TEXT__c || caold.X18_3_TEXT__c!=ca.X18_3_TEXT__c
               || caold.X18_4_TEXT__c != ca.X18_4_TEXT__c ||caold.X18_5_TEXT__c!= ca.X18_5_TEXT__c || caold.X18_6_TEXT__c != ca.X18_6_TEXT__c
               || caold.X18_7_TEXT__c != ca.X18_7_TEXT__c || caold.Brief_Record_of_the_Discussion__c != ca.Brief_Record_of_the_Discussion__c
               ||Attachment1.body!=null || Attachment14.body!=null || Attachment15.body!=null 
               ||Attachment16.body!=null ||Attachment17.body!=null || Attachment23.body!=null ||Attachment24.body!=null
               ||Attachment25.body!=null ||Attachment26.body!=null || Attachment27.body!=null ||Attachment29.body!=null
               ||Attachment211.body!=null ||Attachment212.body!=null ||Attachment213.body!=null ||Attachment215.body!=null
               ||Attachment219.body!=null){
                   if(num=='1'){
                   system.debug('>1的情况V2');
                   Opportunity opp = [select id,
                                      Commission_Type__c,
                                      Commision__c,
                                      name,
                                      RecordType.name
                                      from Opportunity
                                      where id =:requestId];
                   opp.Commission_Type__c='';
                   opp.Commision__c=null;
                   opp.IsCommission__c=true;
                   opp.CEO_Approval_Status__c='Pending';
                   opp.CFO_Approval_Status__c='Pending';
                   opp.VP_Approval_Status__c='Pending';
                   opp.CEO_Approval_comments__c='';
                   opp.CFO_Approval_comments__c='';
                   opp.VP_Approval_comments__c='';
                   update opp;
                       }
                   List<Attachment> alst= new List<Attachment>();
                   system.debug('>1的情况V3');
                   if(Attachment1.body!=null){
                       Attachment1.name = blob1name;
                       Attachment1.parentId = ca.id; 
                       system.debug('附件1已覆盖');
                       alst.add(Attachment1);
                   }
                   if(Attachment14.body!=null){
                       Attachment14.name = blob14name;
                       Attachment14.parentId = ca.id; 
                       alst.add(Attachment14);
                   }
                   if(Attachment15.body!=null){
                       Attachment15.name = blob15name;
                       Attachment15.parentId = ca.id; 
                       alst.add(Attachment15);
                   }
                   if(Attachment16.body!=null){
                       Attachment16.name = blob16name;
                       Attachment16.parentId = ca.id; 
                       alst.add(Attachment16);
                   }
                   if(Attachment17.body!=null){
                       Attachment17.name = blob17name;
                       Attachment17.parentId = ca.id; 
                       alst.add(Attachment17);
                   }
                   if(Attachment23.body!=null){
                       Attachment23.name = blob23name;
                       Attachment23.parentId = ca.id; 
                       alst.add(Attachment23);
                   }
                   if(Attachment24.body!=null){
                       Attachment24.name = blob24name;
                       Attachment24.parentId = ca.id; 
                       alst.add(Attachment24);
                   }
                   if(Attachment25.body!=null){
                       Attachment25.name = blob25name;
                       Attachment25.parentId = ca.id; 
                       alst.add(Attachment25);
                   }
                   if(Attachment26.body!=null){
                       Attachment26.name = blob26name;
                       Attachment26.parentId = ca.id; 
                       alst.add(Attachment26);
                   }
                   if(Attachment27.body!=null){
                       Attachment27.name = blob27name;
                       Attachment27.parentId = ca.id; 
                       alst.add(Attachment27);
                   }
                   if(Attachment29.body!=null){
                       Attachment29.name = blob29name;
                       Attachment29.parentId = ca.id; 
                       alst.add(Attachment29);
                   }
                   if(Attachment211.body!=null){
                       Attachment211.name = blob211name;
                       Attachment211.parentId = ca.id; 
                       alst.add(Attachment211);
                   }
                   if(Attachment212.body!=null){
                       Attachment212.name = blob212name;
                       Attachment212.parentId = ca.id; 
                       alst.add(Attachment212);
                   }
                   if(Attachment213.body!=null){
                       Attachment213.name = blob213name;
                       Attachment213.parentId = ca.id; 
                       alst.add(Attachment213);
                   }
                   if(Attachment215.body!=null){
                       Attachment215.name = blob215name;
                       Attachment215.parentId = ca.id; 
                       alst.add(Attachment215);
                   }
                   if(Attachment219.body!=null){
                       Attachment219.name = blob219name;
                       Attachment219.parentId = ca.id; 
                       alst.add(Attachment219);
                   }
                   insert alst;
                   if(Attachment1.body!=null){
                       ca.file_id__c=Attachment1.id;
                   }
                   if(Attachment14.body!=null){
                       ca.X1_4_file_id__c=Attachment14.id;
                   }
                   if(Attachment15.body!=null){
                       ca.X1_5_file_id__c=Attachment15.id;
                   }
                   if(Attachment16.body!=null){
                       ca.X1_6_file_id__c=Attachment16.id;
                   }
                   if(Attachment17.body!=null){
                       ca.X1_7_file_id__c=Attachment17.id;
                   }
                   if(Attachment23.body!=null){
                       ca.X2_3_file_id__c=Attachment23.id;
                   }
                   if(Attachment24.body!=null){
                       ca.X2_4_file_id__c=Attachment24.id;
                   }
                   if(Attachment25.body!=null){
                       ca.X2_5_file_id__c=Attachment25.id;
                   }
                   if(Attachment26.body!=null){
                       ca.X2_6_file_id__c=Attachment26.id;
                   }
                   if(Attachment27.body!=null){
                       ca.X2_7_file_id__c=Attachment27.id;
                   }
                   if(Attachment29.body!=null){
                       ca.X2_9_file_id__c=Attachment29.id;
                   }
                   if(Attachment211.body!=null){
                       ca.X2_11_file_id__c=Attachment211.id;
                   }
                   if(Attachment212.body!=null){
                       ca.X2_12_file_id__c=Attachment212.id;
                   }
                   if(Attachment213.body!=null){
                       ca.X2_13_file_id__c=Attachment213.id;
                   }
                   if(Attachment215.body!=null){
                       ca.X2_15_file_id__c=Attachment215.id;
                   }
                   if(Attachment219.body!=null){
                       ca.X2_19_file_id__c=Attachment219.id;
                   }
                  Commission_Application__c ca1 =ca.clone();
                   if(num=='1'){
                   ca1.name=opp.name+'  V'+(calst.size()+1);
                   }
                   if(num=='2'){
                   ca1.name=opp.name+'  S'+(calst.size()+1);
                       opp.Commission_Type2__c=ca1.Commission2_Type__c;
                      opp.Actual_Commission2__c=ca1.Contract_Commission2__c;
                       update opp;
                   }
                   if(num=='3'){
                   ca1.name=opp.name+'  T'+(calst.size()+1);
                         opp.Commission_Type3__c=ca1.Commission3_Type__c;
                        opp.Actual_Commission3__c=ca1.Contract_Commission3__c;
                        update opp;
                   }
                       if(num=='1'){insert ca1;
            String flag2=sandboxemailtoCEO(ca1.id);
                       
                   }else{
             insert ca1;
                               ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.WARNING , 'Save Successful'));
                       }
                  
               }else{
                   /**
                   Opportunity opp2 = [select id,
                                       Commission_Type__c,
                                       Commision__c,
                                       RecordType.name
                                       from Opportunity
                                       where id =:requestId];
                   String str;
                   if(opp2.RecordType.name=='Japan' && userinfo.getUserId()!='00590000002rep3AAA'){
                       str= PriceApprove.submit2NothAisa(requestId);
                       ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.INFO , str));
                   }
                   else if(opp2.RecordType.name=='Japan' && userinfo.getUserId()=='00590000002rep3AAA'){
                       opp2.IsCommission__c=true;
                       
                       sandboxemailtoCEO(); 
                   }else{
                       str= PriceApprove.submit(requestId);
                       ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.INFO , str));
                   }
                   **/
                    ca.addError( 'No changes tracked, please select "Price approval(Without commission)"');
                  return;
               }
            
        }
    }
    
    public String sandboxemailtoCEO(){
        if(string.isEmpty(requestId)){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.WARNING ,'Opporunity Id is null' ));
            return '0';
        }
        Opportunity opp = [select id,
                           Total_MW__c,
                           Total_Quantity__c,
                           Region__c,
                           Special_Terms__c,
                           Land_Freight_China__c,
                           Land_Freight_Oversea__c,
                           Destination_Country__c,
                           Ocean_Freight__c,
                           Trade_Term__c,
                           Expect_Price_and_Comments__c,
                           RecordType.name,
                           Customer_Type__c,
                           Allow_new_process_for_Japan_picklist__c,
                           whether_pick_up_batch__c,
                           OwnerId,
                           Payment_1MW_Approve__c,
                           Owner.Contract_Approver__c,
                           Owner.Cross_Region_BMO__c,
                           Owner.Region__c,
                           Owner.Contract_Approver__r.Name,
                           Owner.Contract_Review__r.Name,
                           Cross_Region__c,
                           Sales_manager_approval__c,
                           Cross_region_GM_approval__c,
                           Price_Approval_Status__c,
                           Price_GM_Approval_Start_Time__c,
                           Price_Approval_Trigger_Count__c,
                           Price_Approval_Trigger_Time__c,
                           Price_Review_Approval_Start_Time__c,
                           Price_Finance_Approval_Finish_time__c,
                           Price_GM_Approval_Finish_Time__c,
                           ApprovalNumbers__c,
                           CFO_Approval_Status__c,
                           CEO_Approval_Status__c,
                           VP_Approval_Status__c,
                           Owner.name
                           from Opportunity
                           where id =:requestId];
        
        Opportunity  opp2 = [SELECT ID,AccountId,
                             StageName,
                             RecordType.Name,
                             Payment_1MW_Approve__c,
                             Total_MW__c,
                             Trade_Term__c,
                             Total_Quantity__c,
                             Payment_Term_Description__c,
                             whether_pick_up_batch__c,
                             Price_Approval_Status__c,
                             Sales_manager_approval__c,
                             Customer_Type__c,
                             Allow_new_process_for_Japan_picklist__c,
                             Seller__c,
                             Special_Terms__c,
                             Region__c,
                             Price_Approval_Trigger_Count__c,
                             Price_Approval_Trigger_Time__c,
                             
                             Contract__c,
                             Contract_No__c,
                             Account.credit_good__c,
                             Owner.Name
                             FROM Opportunity 
                             WHERE id =:opp.id];
        List<Payment__c> payList = [SELECT ID,
                                    Payment_Method__c 
                                    FROM Payment__c 
                                    WHERE Opportunity__c =: requestId AND (Payment_Method__c =: 'T/T' OR Payment_Method__c =: 'T/T (Balance)')];
        
        if(
            opp.Land_Freight_China__c==null && 
            opp.Land_Freight_Oversea__c==null
            && opp.Ocean_Freight__c==null &&
            (!(opp.Trade_Term__c == 'EXW'
               || opp.Trade_Term__c == 'CIF'
               || opp.Trade_Term__c == 'FOB'))
            && opp.Region__c != 'North Asia' && opp.Region__c != 'North America'){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.WARNING , ' There is no transit fees. please contact logistic to fill in.'));
                return '0';
                
            } 
        else if(string.isEmpty(opp.Expect_Price_and_Comments__c) && opp.RecordType.name != 'USA'){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.WARNING ,  'Please fill in \'Expect Price and Comments\' information and click submit again.'));
            return '0';
            
        }else{ 
            if(opp.RecordType.name=='Japan' && userinfo.getUserId()!='00590000002rep3AAA'){
                if(opp.CFO_Approval_Status__c=='Approved'){
                    opp.CFO_Approval_Status__c='';
                    opp.CFO_Approval_comments__c='';
                }
                if(opp.CEO_Approval_Status__c=='Approved'){
                    opp.CEO_Approval_Status__c='';
                    opp.CEO_Approval_comments__c='';
                }
                if(opp.VP_Approval_Status__c=='Approved'){
                    opp.VP_Approval_Status__c='';
                    opp.VP_Approval_comments__c='';
                }
                if(opp.Sales_manager_approval__c=='Approved'){
                    opp.Sales_manager_approval__c='';
                    opp.GM_approval_Feedback__c='';
                }
                if(opp.Price_Approval_Status__c=='Approved'){
                    opp.Price_Approval_Status__c='';
                    opp.Price_Approval_Feedback_Comments__c='';
                }
                if(opp.Cross_region_GM_approval__c=='Approved'){
                    opp.Cross_region_GM_approval__c='';
                    opp.Cross_region_GM_feedback__c='';
                }
                opp.Commision__c=null;
                opp.Commission_Type__c='';
                 if(opp.ApprovalNumbers__c==null){
            opp.ApprovalNumbers__c=1;
        }if(opp.ApprovalNumbers__c!=null){
            opp.ApprovalNumbers__c=opp.ApprovalNumbers__c+1;
        }
                update opp;
                User us4=[select id from User where id=:'00590000002rep3'];//credit
                SendEmailUtils2.sendToSomeOneId(opp.ID,us4.id,'Special_Price_for_Commisson');
                
                ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.WARNING ,  'Send Email Successful'));
            }ELSE{
                system.debug('申请佣金非跨区');
                User us=[select id from User where id=:'0056F000007apFw'];//CFO固定(QQ邮箱 416010231@qq.com)
                User us2=[select id from User where id=:'00590000002rC82'];//CMO固定(Snake@trixpro.com)
                User us3=[select id from User where id=:'0059000000126GN'];//VP固定(163 qq416010231@163.com)
              //  SendEmailUtils2.sendToSomeOneId(ca.ID,us.id,'CommissionApplicationEmail');//CFO邮件
                SendEmailUtils2.sendToSomeOneId(ca.ID,us2.id,'CommissionApplicationEmail');//CMO邮件
                SendEmailUtils2.sendToSomeOneId(ca.ID,us3.id,'CommissionApplicationEmail');//VP邮件
                SendEmailUtils2.sendToSomeOneId(opp.ID,opp.Owner.Contract_Approver__c,'Special_Price_for_Commisson');//GM邮件(163.qq416010232@163.com)
                
              //  opp.CFO_Commission_Email__c=true;
               // opp.CFO_Commission_Email_Time__c=datetime.now();
                opp.CMO_Commission_Email__c=true;
                opp.CMO_Commission_Email_Time__c=datetime.now();
                opp.VP_Commission_Email__c=true;
                opp.VP_Commission_Email_Time__c=datetime.now();
                opp.GM_Commission_Email__c=true;
                opp.GM_Commission_Email_Time__c=datetime.now();
                if(opp.CFO_Approval_Status__c=='Approved'){
                    opp.CFO_Approval_Status__c='';
                    opp.CFO_Approval_comments__c='';
                }
                if(opp.CEO_Approval_Status__c=='Approved'){
                    opp.CEO_Approval_Status__c='';
                    opp.CEO_Approval_comments__c='';
                }
                if(opp.VP_Approval_Status__c=='Approved'){
                    opp.VP_Approval_Status__c='';
                    opp.VP_Approval_comments__c='';
                }
                if(opp.Sales_manager_approval__c=='Approved'){
                    opp.Sales_manager_approval__c='';
                    opp.GM_approval_Feedback__c='';
                }
                if(opp.Price_Approval_Status__c=='Approved'){
                    opp.Price_Approval_Status__c='';
                    opp.Price_Approval_Feedback_Comments__c='';
                }
                if(opp.Cross_region_GM_approval__c=='Approved'){
                    opp.Cross_region_GM_approval__c='';
                    opp.Cross_region_GM_feedback__c='';
                }
                opp.Commision__c=null;
                opp.Commission_Type__c='';
                 if(opp.ApprovalNumbers__c==null){
            opp.ApprovalNumbers__c=1;
        }if(opp.ApprovalNumbers__c!=null){
            opp.ApprovalNumbers__c=opp.ApprovalNumbers__c+1;
        }
                update opp;
                if(opp.Cross_Region__c == true ){
                    String RegionHeadName ='';
                    String RegionHeadEmail ='';
                    if(opp.Region__c =='EU'|| opp.Region__c=='Non EU'){
                        RegionHeadEmail=Label.Area_EU;
                    }
                    else if(opp.Region__c =='EU(Union)'|| opp.Region__c=='EU(Non-Eu)'){
                        RegionHeadEmail=Label.Area_EU;
                    }
                    else if(opp.Region__c =='ROA'){
                        RegionHeadEmail=Label.Area_ROA;
                    }else if(opp.Region__c =='North Asia'){
                        RegionHeadEmail=Label.Area_North_Asia;
                    }else if(opp.Region__c =='South Asia'){
                        RegionHeadEmail=Label.Area_South_Asia;
                    }else if(opp.Region__c =='North America'){
                        RegionHeadEmail=Label.Area_North_America;
                    }else if(opp.Region__c =='Middle East&Africa' || opp.Region__c =='SSA' || opp.Region__c =='MENA'){
                        RegionHeadEmail=Label.Area_Middle_east_africa;
                    }else if(opp.Region__c =='Latin America&Italy'){
                        RegionHeadEmail=Label.Area_Latin_America_Italy;
                    }else if(opp.Region__c =='Middle East North Africa'){
                        RegionHeadEmail=Label.Middle_East_North_Africa;
                    }else if(opp.Region__c =='Sub-Saharan Africa'){
                        RegionHeadEmail=Label.Sub_Saharan_Africa;
                    }
                    if(RegionHeadEmail !=null && RegionHeadEmail !=''){
                        User us4 =[Select id,Name,Email from User where Email =:RegionHeadEmail];
                        system.debug('*********user.Email***'+us4.Email);
                        system.debug('1111');
                        if(us4 !=null){
                            RegionHeadName =us4.id;
                        }}
                    SendEmailUtils2.sendToSomeOneId(opp.ID,RegionHeadName,'Special_Price');//可能的跨区GM邮件
                }
                ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.WARNING , 'Send Email Successful'));
            }
        }

        return '1';
    }
    public String sandboxemailtoCEO(String ca){
        if(string.isEmpty(requestId)){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.WARNING ,'Opporunity Id is null' ));
            return '0' ;
        }
        Opportunity opp = [select id,
                           Total_MW__c,
                           Total_Quantity__c,
                           Region__c,
                           Special_Terms__c,
                           Land_Freight_China__c,
                           Land_Freight_Oversea__c,
                           Destination_Country__c,
                           Ocean_Freight__c,
                           Trade_Term__c,
                           Expect_Price_and_Comments__c,
                           RecordType.name,
                           Customer_Type__c,
                           Allow_new_process_for_Japan_picklist__c,
                           whether_pick_up_batch__c,
                           OwnerId,
                           Payment_1MW_Approve__c,
                           Owner.Contract_Approver__c,
                           Owner.Cross_Region_BMO__c,
                           Owner.Region__c,
                           Owner.Contract_Approver__r.Name,
                           Owner.Contract_Review__r.Name,
                           Cross_Region__c,
                           Sales_manager_approval__c,
                           Cross_region_GM_approval__c,
                           Price_Approval_Status__c,
                           Price_GM_Approval_Start_Time__c,
                           Price_Approval_Trigger_Count__c,
                           Price_Approval_Trigger_Time__c,
                           Price_Review_Approval_Start_Time__c,
                           Price_Finance_Approval_Finish_time__c,
                           Price_GM_Approval_Finish_Time__c,
                           CFO_Approval_Status__c,
                           CEO_Approval_Status__c,
                           ApprovalNumbers__c,
                           VP_Approval_Status__c,
                           Owner.name
                           from Opportunity
                           where id =:requestId];
        
        Opportunity  opp2 = [SELECT ID,AccountId,
                             StageName,
                             RecordType.Name,
                             Payment_1MW_Approve__c,
                             Total_MW__c,
                             Trade_Term__c,
                             Total_Quantity__c,
                             Payment_Term_Description__c,
                             whether_pick_up_batch__c,
                             Price_Approval_Status__c,
                             Sales_manager_approval__c,
                             Customer_Type__c,
                             Allow_new_process_for_Japan_picklist__c,
                             Seller__c,
                             Special_Terms__c,
                             Region__c,
                             Price_Approval_Trigger_Count__c,
                             Price_Approval_Trigger_Time__c,
                             
                             Contract__c,
                             Contract_No__c,
                             Account.credit_good__c,
                             Owner.Name
                             FROM Opportunity 
                             WHERE id =:opp.id];
        List<Payment__c> payList = [SELECT ID,
                                    Payment_Method__c 
                                    FROM Payment__c 
                                    WHERE Opportunity__c =: requestId AND (Payment_Method__c =: 'T/T' OR Payment_Method__c =: 'T/T (Balance)')];
        
        if(
            opp.Land_Freight_China__c==null && 
            opp.Land_Freight_Oversea__c==null
            && opp.Ocean_Freight__c==null &&
            (!(opp.Trade_Term__c == 'EXW'
               || opp.Trade_Term__c == 'CIF'
               || opp.Trade_Term__c == 'FOB'))
            && opp.Region__c != 'North Asia' && opp.Region__c != 'North America'){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.WARNING , ' There is no transit fees. please contact logistic to fill in.'));
                return '0';
                
            } 
        else if(string.isEmpty(opp.Expect_Price_and_Comments__c) && opp.RecordType.name != 'USA'){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.WARNING ,  'Please fill in \'Expect Price and Comments\' information and click submit again.'));
            return '0';
            
        }else{ 
            if(opp.RecordType.name=='Japan' && userinfo.getUserId()!='00590000002rep3AAA'){
                if(opp.CFO_Approval_Status__c=='Approved'){
                    opp.CFO_Approval_Status__c='';
                    opp.CFO_Approval_comments__c='';
                }
                if(opp.CEO_Approval_Status__c=='Approved'){
                    opp.CEO_Approval_Status__c='';
                    opp.CEO_Approval_comments__c='';
                }
                if(opp.VP_Approval_Status__c=='Approved'){
                    opp.VP_Approval_Status__c='';
                    opp.VP_Approval_comments__c='';
                }
                if(opp.Sales_manager_approval__c=='Approved'){
                    opp.Sales_manager_approval__c='';
                    opp.GM_approval_Feedback__c='';
                }
                if(opp.Price_Approval_Status__c=='Approved'){
                    opp.Price_Approval_Status__c='';
                    opp.Price_Approval_Feedback_Comments__c='';
                }
                if(opp.Cross_region_GM_approval__c=='Approved'){
                    opp.Cross_region_GM_approval__c='';
                    opp.Cross_region_GM_feedback__c='';
                }
                opp.Commision__c=null;
                opp.Commission_Type__c='';
                 if(opp.ApprovalNumbers__c==null){
            opp.ApprovalNumbers__c=1;
        }if(opp.ApprovalNumbers__c!=null){
            opp.ApprovalNumbers__c=opp.ApprovalNumbers__c+1;
        }
                update opp;
                User us4=[select id from User where id=:'00590000002rep3'];//credit
                SendEmailUtils2.sendToSomeOneId(opp.ID,us4.id,'Special_Price_for_Commisson');
                
                ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.WARNING ,  'Send Email Successful'));
            }ELSE{
                system.debug('申请佣金非跨区');
                User us=[select id from User where id=:'0056F000007apFw'];//CFO固定(QQ邮箱 416010231@qq.com)
                User us2=[select id from User where id=:'00590000002rC82'];//CMO固定(Snake@trixpro.com)
                User us3=[select id from User where id=:'0059000000126GN'];//VP固定(163 qq416010231@163.com)
                if(!Test.isRunningTest()){
              //  SendEmailUtils2.sendToSomeOneId(ca,us.id,'CommissionApplicationEmail');//CFO邮件
                SendEmailUtils2.sendToSomeOneId(ca,us2.id,'CommissionApplicationEmail');//CMO邮件
                SendEmailUtils2.sendToSomeOneId(ca,us3.id,'CommissionApplicationEmail');//VP邮件
                SendEmailUtils2.sendToSomeOneId(opp.ID,opp.Owner.Contract_Approver__c,'Special_Price_for_Commisson');//GM邮件(163.qq416010232@163.com)
               }
             //       opp.CFO_Commission_Email__c=true;
             //   opp.CFO_Commission_Email_Time__c=datetime.now();
                opp.CMO_Commission_Email__c=true;
                opp.CMO_Commission_Email_Time__c=datetime.now();
                opp.VP_Commission_Email__c=true;
                opp.VP_Commission_Email_Time__c=datetime.now();
                opp.GM_Commission_Email__c=true;
                opp.GM_Commission_Email_Time__c=datetime.now();

                
                
                if(opp.CFO_Approval_Status__c=='Approved'){
                    opp.CFO_Approval_Status__c='';
                    opp.CFO_Approval_comments__c='';
                }
                if(opp.CEO_Approval_Status__c=='Approved'){
                    opp.CEO_Approval_Status__c='';
                    opp.CEO_Approval_comments__c='';
                }
                if(opp.VP_Approval_Status__c=='Approved'){
                    opp.VP_Approval_Status__c='';
                    opp.VP_Approval_comments__c='';
                }
                if(opp.Sales_manager_approval__c=='Approved'){
                    opp.Sales_manager_approval__c='';
                    opp.GM_approval_Feedback__c='';
                }
                if(opp.Price_Approval_Status__c=='Approved'){
                    opp.Price_Approval_Status__c='';
                    opp.Price_Approval_Feedback_Comments__c='';
                }
                if(opp.Cross_region_GM_approval__c=='Approved'){
                    opp.Cross_region_GM_approval__c='';
                    opp.Cross_region_GM_feedback__c='';
                }
                opp.Commision__c=null;
                opp.Commission_Type__c='';
                 if(opp.ApprovalNumbers__c==null){
            opp.ApprovalNumbers__c=1;
        }if(opp.ApprovalNumbers__c!=null){
            opp.ApprovalNumbers__c=opp.ApprovalNumbers__c+1;
        }
                update opp;
                if(opp.Cross_Region__c == true ){
                    String RegionHeadName ='';
                    String RegionHeadEmail ='';
                    if(opp.Region__c =='EU'|| opp.Region__c=='Non EU'){
                        RegionHeadEmail=Label.Area_EU;
                    }
                    else if(opp.Region__c =='EU(Union)'|| opp.Region__c=='EU(Non-Eu)'){
                        RegionHeadEmail=Label.Area_EU;
                    }
                    else if(opp.Region__c =='ROA'){
                        RegionHeadEmail=Label.Area_ROA;
                    }else if(opp.Region__c =='North Asia'){
                        RegionHeadEmail=Label.Area_North_Asia;
                    }else if(opp.Region__c =='South Asia'){
                        RegionHeadEmail=Label.Area_South_Asia;
                    }else if(opp.Region__c =='North America'){
                        RegionHeadEmail=Label.Area_North_America;
                    }else if(opp.Region__c =='Middle East&Africa' || opp.Region__c =='SSA' || opp.Region__c =='MENA'){
                        RegionHeadEmail=Label.Area_Middle_east_africa;
                    }else if(opp.Region__c =='Latin America&Italy'){
                        RegionHeadEmail=Label.Area_Latin_America_Italy;
                    }else if(opp.Region__c =='Middle East North Africa'){
                        RegionHeadEmail=Label.Middle_East_North_Africa;
                    }else if(opp.Region__c =='Sub-Saharan Africa'){
                        RegionHeadEmail=Label.Sub_Saharan_Africa;
                    }
                    if(RegionHeadEmail !=null && RegionHeadEmail !=''){
                        User us4 =[Select id,Name,Email from User where Email =:RegionHeadEmail];
                        system.debug('*********user.Email***'+us4.Email);
                        system.debug('1111');
                        if(us4 !=null){
                            RegionHeadName =us4.id;
                        }}
                    SendEmailUtils2.sendToSomeOneId(opp.ID,RegionHeadName,'Special_Price');//可能的跨区GM邮件
                }
                ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.WARNING , 'Send Email Successful'));
               
            }
        }
         return '1';
    }
      public PageReference aback(){ 
              return    new PageReference('/apex/CommissionCheck?id='+requestId); 
    }
    
}