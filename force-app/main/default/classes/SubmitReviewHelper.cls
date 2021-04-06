/*
* @description This class is used get the Approver of the contract
*/
public class SubmitReviewHelper {
    static Map<String, Contract_Approver_Configuration__mdt> mapCAConfig = new Map<String, Contract_Approver_Configuration__mdt>();
    static{
        //query contract approver configuration
        for(Contract_Approver_Configuration__mdt objCAConfig : [SELECT Id, Label, DeveloperName, IsReceive__c 
                                                                FROM Contract_Approver_Configuration__mdt
                                                                LIMIT 500]){
            mapCAConfig.put(objCAConfig.Label, objCAConfig);
        }
    }
    /*
    * @param conid Contract.Id
    * @return the Approver UserId set
    * @description Get the approver of the contract
    */
    public static set<ID> getContractReviewList(String conid){
        Contract con ;
        Opportunity  opp;
        List<User> userLst =new List<User>();
        ID AustraliaRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
        ID Japan1MWRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        ID Standard1MWRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
        con = [SELECT ID,OWNERID,RecordTypeId,Owner.Name,Owner.email,Opportunity__c,BMO_Dept__c,Finance_Dept__c,Opportunity__r.Cross_Region__c,Sales_Region__c,Destination_Country__c,AccountId,Account.country__c,Region__c,Total_Quantity__c,owner.Contract_Review__c FROM Contract WHERE ID=:conid];
        opp = [Select Id,Region__c,Payment_1MW_Approve__c,vn_fast__c from Opportunity where Id =: con.Opportunity__c];
        User currUser = [SELECT u.Id,u.ManagerId,u.Contract_Approver__c, u.Contract_Review__c,u.Cross_Region_BMO__c ,u.BMO_specialist__c,UserRoleId,UserRole.Name,Country__c FROM USER u WHERE u.Id =: con.OwnerId];
        List<User> NacyApprovers = [Select Id,Name From User Where Name =: 'Anita Li' OR Name =: 'Donald Leo' OR Name =: 'Nigel Cockroft' OR Name =: 'Vicky Sun' OR Name =: 'Nigel Cockroft' OR Name =: 'Nigel Cockroft' ];
        
        /* get User from Review User Group */
        set<Id> UserIds = new set<Id>();
        set<Id> GMIds = new set<Id>();
        set<Id> newGMID =new set<Id>();
        for(GroupMember gm : [SELECT gm.UserOrGroupId 
                                FROM GroupMember gm 
                                WHERE gm.GroupId IN (Select g.Id From Group g WHERE g.Name = 'All GM Group')]){
            GMIds.add(gm.UserOrGroupId);          
        }

        userLst =[Select Id,Region__c from User where Id in:GMIds];
        for(User us :userLst){
            if(us.Region__c == opp.Region__c){
                newGMID.add(us.Id);
            }
        }
        system.debug('3333===============');
        system.debug('GMID--->'+newGMID);
        if(con.RecordTypeId == AustraliaRecordTypeId){
            //澳大利亚 record type
            for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Australia Review')]){
                UserIds.add(gm.UserOrGroupId);
            }
            system.debug('AU====='+UserIds);
            if(con.Owner.Name == 'Susie Pan' || con.Owner.Name == 'Nancy Wang' || con.Owner.Name == 'jaffer Wang' || currUser.UserRole.Name.contains('BMO') ){
                UserIds.addAll(newGMID);
                /**
                for(GroupMember gm : [Select gm.UserOrGroupId 
                    from GroupMember gm 
                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='All GM Group')]){
                                system.debug('gm--->'+gm);
                    UserIds.add(gm.UserOrGroupId);          
                }
                */
            }
            system.debug('-----UserIds: '+ UserIds);
            /*1MW update by jason*/ 
        }else if(con.RecordTypeId == Standard1MWRecordTypeId ){
            for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Group 1MW Review')]){
                UserIds.add(gm.UserOrGroupId);
            }
            if(opp.vn_fast__c==true){
                List<User> nvusr = [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE id =:'0056F00000DgPI2'];
                if(nvusr.size()>0){
                    UserIds.add(nvusr[0].id);
                }
            }
            if(con.Region__c!='North America'){
                UserIds.add(currUser.Contract_Review__c);
            }
            if(con.Owner.Name == 'Susie Pan' || con.Owner.Name == 'Nancy Wang' || currUser.UserRole.Name.contains('BMO')){
                UserIds.addAll(newGMID);
                /**
                for(GroupMember gm : [Select gm.UserOrGroupId 
                    from GroupMember gm 
                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='All GM Group')]){
                                system.debug('gm--->'+gm);
                    UserIds.add(gm.UserOrGroupId);          
                }
                */
            }
            system.debug('全球1MW列表内容'+UserIds);
        }else if(con.RecordTypeId == Japan1MWRecordTypeId){
            for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Japan Review')]){           
              UserIds.add(gm.UserOrGroupId);          
            }
            UserIds.remove('00590000002sK0x');
            UserIds.add(currUser.Contract_Review__c);
            system.debug('JP====='+UserIds);
            if(con.Owner.Name == 'Susie Pan' || con.Owner.Name == 'Nancy Wang' || con.Owner.Name == 'jaffer Wang' || currUser.UserRole.Name.contains('BMO')){
                UserIds.addAll(newGMID);
                /**
                for(GroupMember gm : [Select gm.UserOrGroupId 
                    from GroupMember gm 
                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='All GM Group')]){
                                    system.debug('gm--->'+gm);
                    UserIds.add(gm.UserOrGroupId);          
                }
               */
            }
        }else{
            for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Review Users')]){
                UserIds.add(gm.UserOrGroupId);
                if(con.Sales_Region__c=='EU(Union)' || con.Sales_Region__c=='EU(Non-Eu)'|| con.Sales_Region__c=='ROA'|| con.Sales_Region__c=='North America'|| con.Sales_Region__c=='North Asia'|| con.Sales_Region__c=='Central Asia'|| con.Sales_Region__c=='Key Account'){
                    UserIds.add(Label.JK_Contract_Technic_Reviewer_US_EU_ROA_NA);
                }else if (con.Sales_Region__c=='Middle East&Africa'||con.Sales_Region__c=='MENA'||con.Sales_Region__c=='SSA'|| con.Sales_Region__c=='Latin America&Italy'|| con.Sales_Region__c=='South Asia'){
                    UserIds.add(Label.JK_Contract_Technic_Reviewer_MEA_LATAM_SA_CA);
                }
            }
            if(con.Owner.Name == 'Susie Pan' || con.Owner.Name == 'Nancy Wang' || con.Owner.Name == 'jaffer Wang' || currUser.UserRole.Name.contains('BMO')){
                UserIds.addAll(newGMID);
                /**
                for(GroupMember gm : [Select gm.UserOrGroupId 
                    from GroupMember gm 
                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='All GM Group')]){
                                    system.debug('gm--->'+gm);
                    UserIds.add(gm.UserOrGroupId);          
                }
                */
            }
        }
        //add  Contract Approver 20170116
        if(con.RecordTypeId != AustraliaRecordTypeId){
        /* add Manage User and BMO ID to approverList*/
        //User currUser = [SELECT u.Id,u.ManagerId, u.Contract_Review__c, u.BMO_specialist__c FROM USER u WHERE u.Id=:con.OwnerId];
        
        /*1MW update by jason*/
            if(con.RecordTypeId == Standard1MWRecordTypeId || con.RecordTypeId == Japan1MWRecordTypeId){
                if(currUser.Contract_Review__c !=null){
                    if(con.Region__c!='North America'){
                        UserIds.add(currUser.Contract_Review__c);  
                    }
                }
            }
    
            /* Add End by David, 20130111, for work piece(20130111-00002) */
            
            // add BMO
            if(currUser.BMO_specialist__c !=null && con.Opportunity__r.Cross_Region__c==false){
                UserIds.add(currUser.BMO_specialist__c);
            }else if(mapCAConfig.containsKey('Cross Region SOC') && mapCAConfig.get('Cross Region SOC').IsReceive__c == true 
                    && con.Opportunity__r.Cross_Region__c == true && currUser.Cross_Region_BMO__c !=null){
                System.debug('#####');
                // update on 2021/3/24 by miller
                UserIds.add(currUser.Cross_Region_BMO__c);
            }

            if(con.Owner.Name == 'Susie Pan' || con.Owner.Name == 'Nancy Wang' || con.Owner.Name == 'jaffer Wang' || currUser.UserRole.Name.contains('BMO')){
                UserIds.addAll(newGMID);
                /**
                    for(GroupMember gm : [Select gm.UserOrGroupId 
                        from GroupMember gm 
                        where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='All GM Group')]){
                                system.debug('gm--->'+gm);
                        UserIds.add(gm.UserOrGroupId);          
                    }
                */
            }
        }
        // if(con.Region__c =='North Asia'&& con.Total_Quantity__c <= 50){
            
           // if(currUser.UserRole.Name.contains('GM')){
                
          //  } 
        //  }
        if(currUser.Contract_Approver__c != null ){
            UserIds.add(currUser.Contract_Approver__c);                
        }
        if(con.Region__c =='North Asia' && con.OWNERID!='00590000002Rx9V'){
            UserIds.add(currUser.Contract_Review__c);
        }
        if(con.Region__c =='ROA'){
            for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Aroon Jiamkasemnit(team)')]){
                if(gm.UserOrGroupId==con.OWNERID){
                    GroupMember aroon = [Select gm.UserOrGroupId 
                                            from GroupMember gm 
                                            where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='aroon.jiamkasemnit')][0];
                        UserIds.add(aroon.UserOrGroupId);           
                }
            }
             
            for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Simon Wong')]){
                if(gm.UserOrGroupId==con.OWNERID){
                    GroupMember aroon =   [Select gm.UserOrGroupId 
                                            from GroupMember gm 
                                            where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Simon Wong(Leader)')][0];
                    UserIds.add(aroon.UserOrGroupId);           
                }
            }
             
            for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Bright Wang')]){
                if(gm.UserOrGroupId==con.OWNERID){
                    GroupMember aroon =   [Select gm.UserOrGroupId 
                                            from GroupMember gm 
                                            where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Bright Wang(Leader)')][0];
                    UserIds.add(aroon.UserOrGroupId);           
                }
            }
             
            for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Ekarat Paramawanich')]){
                if(gm.UserOrGroupId==con.OWNERID){
                    GroupMember aroon =   [Select gm.UserOrGroupId 
                                            from GroupMember gm 
                                            where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Ekarat Paramawanich(Leader)')][0];
                    UserIds.add(aroon.UserOrGroupId);           
                }
            }
             
            for(GroupMember gm : [Select gm.UserOrGroupId 
                                    from GroupMember gm 
                                    where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Shehan Talagala')]){
                if(gm.UserOrGroupId==con.OWNERID){
                    GroupMember aroon =   [Select gm.UserOrGroupId 
                                            from GroupMember gm 
                                            where gm.GroupId IN (Select g.Id From Group g WHERE g.Name='Shehan Talagala(Lead)')][0];
                    UserIds.add(aroon.UserOrGroupId);           
                }
            }
        }
       if(con.Region__c =='North Asia'&& con.Total_Quantity__c <= 800 && con.OWNERID!='00590000002Rx9V'){
            User us = [Select id, Name,UserRole.Name from user where UserRole.Name =:'GM North Asia'];
            UserIds.remove(us.Id);
            UserIds.add(currUser.Contract_Review__c);
       }
        /*
        if(con.Region__c =='North Asia'&& con.Total_Quantity__c <= 780 && con.Total_Quantity__c >50){
            User us = [Select id, Name,UserRole.Name from user where UserRole.Name =:'GM North Asia'];
            //部署替换

            UserIds.remove(us.Id);
            UserIds.add('0056F00000C7gXx');
        }
        */
        system.debug('UserIds====='+UserIds);
        //北亚区的合同去掉公共的法务，北亚区以外的去掉日本法务
        if((con.Region__c =='Middle East&Africa'||con.Region__c =='MENA'||con.Region__c =='SSA')&& opp.Payment_1MW_Approve__c == true){
            User us = [Select id, Name,UserRole.Name from user where UserRole.Name =:'GM Africa & Mid-East'];
            UserIds.remove(us.Id);
        }
        if(con.Destination_Country__c =='Japan'){
            UserIds.remove('005900000012GJT');
        }else{
            UserIds.remove('00590000002sK0x');
        }
        User usFinace = [Select id, Name,UserRole.Name from user where Name =:'Alex jiang'];
        if(usFinace !=null && con.RecordTypeId != JK_RecordTypeConstant.CONTRACT_RECORDTYPE_ID_ENERGY){
            UserIds.remove(usFinace.Id);
        }
        if(con.RecordTypeId == JK_RecordTypeConstant.CONTRACT_RECORDTYPE_ID_ENERGY){
            UserIds.remove(Label.JK_Contract_Reviewer_Credit);
        }
        if( (con.Region__c =='Middle East&Africa'||con.Region__c =='MENA'||con.Region__c =='SSA') || con.Region__c=='Latin America&Italy' || con.Region__c=='North America'){
            if(currUser.Contract_Approver__c != null ){
                UserIds.remove(currUser.Contract_Approver__c);                
            }
        }
        if(con.Owner.email == 'adrian.kwong@jinkosolar.com' || con.Owner.email == 'midori.santos@jinkosolar.com' || con.Owner.email == 'david.khuen@jinkosolar.com'
              || con.Owner.email == 'stuart.macleod@jinkosolar.com'){
            User ususer = [Select id, Name,UserRole.Name from user where email =:'soc.usdistribution@jinkosolar.com'];
            userids.add(ususer.ID);
        }
        system.debug('end----:'+userids);
        
        if((con.Region__c=='EU(Union)' || con.Region__c=='EU(Non-Eu)') && (con.Sales_Region__c=='EU(Union)'||con.Sales_Region__c=='EU(Non-Eu)')){
            for(id i: newGMID){
                UserIds.remove(i);
            }
        }
        
        //如果fin或者soc没有approved,去除法务ID
        if(con.Finance_Dept__c !='Approved'||con.BMO_Dept__c!='Approved'){
            UserIds.remove('005900000012GJT');
            UserIds.remove('00590000002sK0x');
            UserIds.remove('0052t000000cYgX');
        }
        return UserIds;
    }
}