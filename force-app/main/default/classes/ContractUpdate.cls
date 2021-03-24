global without sharing class ContractUpdate {
    public static Contract con{get;set;}
    public static Opportunity op{get;set;}
    public static OpportunityLineItem[] opls{get;set;} 
    public static String conRecordType{get;set;}
    public static String currRecordType{get;set;}
    
    /**
* for Contract Refresh Data button
*/
    webService static void clickUpdate(  String id  ){
        
        system.debug('-------> :cleck update' );
        ID AustraliaRecordTypeId    = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
        ID Japan1MWRecordTypeId     = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Japan Contract').getRecordTypeId();
        ID Standard1MWRecordTypeId  = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Global Standard Contract').getRecordTypeId();
        ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
        ID InventoryRecordTypeId 	= Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Inventory Contract').getRecordTypeId();
        Contract currCon = [Select id,RecordTypeId,Opp_approval__c,Region__c,Destination_Country__c,Tax_Rate__c,History_Record_Type_ID__c From Contract where id =: id];
       if(currCon.Opp_approval__c==true || currCon.Region__c=='North America'){
        List<String> email = new List<String>();
        Boolean BMOemail=false;
        Boolean Finemail=false;
        con  = CvtOpps2Contract.initCon( id );  
        String oldTradeterm=con.Trade_term__c;
           String oldSeller=con.SELLER__c;
        op   = CvtOpps2Contract.initOpp( con.Opportunity__c  );    
        
        opls = CvtOpps2Contract.initOpls( op.Id );
        system.debug('1');
        try{
            con = CvtOpps2Contract.CpyAccInfo(op, con);
            system.debug('2');
            Contract con2=[select Refresh_Data_Times__c,Legal_Dept__c from Contract where id=:con.id];
            if(con2.Refresh_Data_Times__c==null){
                con2.Refresh_Data_Times__c=0;
            }
            con2.Refresh_Data_Times__c=con2.Refresh_Data_Times__c+1;
            update con2;
           
            /*
            List<Payment__c> oldconPays = [Select Amount__c,Collection_Assurance__c,Incoterm__c,Down_Balance_Payment__c, Payment_Term__c, Payment_Method__c, Contract__c, Name, Id,  Days__c, CurrencyIsoCode,  Precise_Day__c,
                                           Condition__c,Opportunity__c, Collection_Assurance_1__c, Collection_Assurance_2__c, CA_Document_Preparing_Due_Date__c,Percentage__c,Requested_Number__c,AR_Start_Date__c,Comments__c
                                           From Payment__c Where Contract__c =: con.ID];
*/
           boolean flag= CvtOpps2Contract.updatePayments(op, con); 
             String newTradeter=con.Trade_term__c;
            String newSeller=con.SELLER__c;
            if(oldTradeterm!=newTradeter || flag ==true){
                if(con2.Legal_Dept__c=='Approved'){
                con.Legal_Dept__c='';
                    con.LegalRepair__c=false;
                BMOemail=true;
                    }
            }
            if(oldSeller!=newSeller){
                con.bankinfo__c=null;
            }
           /*
            List<Payment__c> newconPays = [Select Amount__c,Collection_Assurance__c,Incoterm__c,Down_Balance_Payment__c, Payment_Term__c, Payment_Method__c, Contract__c, Name, Id,  Days__c, CurrencyIsoCode,  Precise_Day__c,
                                           Condition__c,Opportunity__c, Collection_Assurance_1__c, Collection_Assurance_2__c, CA_Document_Preparing_Due_Date__c,Percentage__c,Requested_Number__c,AR_Start_Date__c,Comments__c
                                           From Payment__c Where Contract__c =: con.ID];
            system.debug('3');
            if(oldconPays.size()!=newconPays.size()){
                con.Finance_Dept__c='';
                Finemail=true;
            }
            else{
                system.debug('开始判断是不是修改了付款方式');
                String Tf='0';
                for(Payment__c new2:newconPays){
                    for(Payment__c old :oldconPays){
                        if(new2.Percentage__c==old.Percentage__c && new2.Down_Balance_Payment__c==old.Down_Balance_Payment__c && new2.Payment_Method__c==old.Payment_Method__c  && new2.Days__c==old.Days__c && new2.Payment_Term__c==old.Payment_Term__c ){
                            system.debug('找到相同');
                            Tf='0';
                            break;
                        }else{
                            Tf='1';
                        }
                    }   
                    if(tf=='1'){
                    con.Finance_Dept__c='';
                        break;
                    Finemail=true;
                    //发送邮件给财务
                }
                }
                
                
            }
            */
            currRecordType = currCon.RecordTypeId;
            system.debug('=====当前合同的记录类型' + currRecordType);
            //更新合同RecordType             
            conRecordType = ContractHelper.refreshDateRecordTypeId(op);
            // 当不满足快速流程 recordType 自动变为 库存合同  并把 审批状态自动变为 pedding  add By Jason
            system.debug('======= 要更新的记录类型:' + conRecordType); 
            system.debug('@@@@@@@@1'+con);
            if (currCon.RecordTypeId != IntercompanyRecordTypeId) {
                if(String.isNotEmpty(conRecordType)){
                    con.RecordTypeId = conRecordType;
                    system.debug('====改变记录类型' + con.RecordTypeId);
                }else{
                    con.RecordTypeId = con.History_Record_Type_ID__c;
                    system.debug('====不改变记录类型' + con.RecordTypeId);
                }    
            } else {
                
            }
            
            
            update con; 
            Contract c = [Select id,RecordTypeId,Destination_Country__c,Tax_Rate__c,History_Record_Type_ID__c From Contract where id =: id];
            system.debug('======更改后的记录类型' + c.RecordTypeId);
            system.debug('======更改前的记录类型' + currRecordType);
            if(currRecordType != c.RecordTypeId){                
                ContractHelper.refreshRecord(c);
                update c;

            }
            system.debug('=======RecordType:'+c.RecordTypeId);
            system.debug('@@@@@@@@2'+con);
            
            // delete the old order lines
            Product_Detail__c[] olsold = [Select Id, Name,Product__r.name,Product__c,Guaranteed_Delivery_Date__c,Quantity__c From Product_Detail__c WHERE Contract_PO_PI__c =: con.Id];
            
            system.debug('=====opls = null: '+(opls==null));
            //new order lines according to the new opportunity
            Product_Detail__c[] olsnew = CvtOpps2Contract.CpyOppsLineItem(opls, con);
            delete olsold;
            insert olsnew;
            /*
            olsnew = [Select Id, Name,Product__r.name,Product__c,Guaranteed_Delivery_Date__c,Quantity__c From Product_Detail__c WHERE Contract_PO_PI__c=: con.Id];
            if(olsold.size()!=olsnew.size()){
                con.BMO_Dept__c='';
                BMOemail=true;
            }
            else{
                system.debug('开始判断是不是修改了交期,名字,数量');
                String Tf='0';
                for(Product_Detail__c new2:olsnew){
                    for(Product_Detail__c old :olsold){
                        system.debug('new2.Product__r.name'+new2.Product__r.name);
                        system.debug('old.Product__r.name'+old.Product__r.name);
                        system.debug('new2.Guaranteed_Delivery_Date__c'+new2.Guaranteed_Delivery_Date__c);
                        system.debug('old.Guaranteed_Delivery_Date__c'+old.Guaranteed_Delivery_Date__c);
                        if(new2.Product__r.name==old.Product__r.name && new2.Quantity__c==old.Quantity__c && new2.Guaranteed_Delivery_Date__c==old.Guaranteed_Delivery_Date__c){
                            system.debug('找到没有修改交期的');
                            Tf='0';
                            break;
                        }else{
                            Tf='1';
                        }
                    } 
                     if(tf=='1'){
                    con.BMO_Dept__c='';
                    BMOemail=true;
                         break;
                    //发送邮件给BMO
                    
                }
                }
               
                
            }
            
            update con; 
*/
            
            if(BMOemail=true){
                List<Individual_Teams__c> ind=[select id from Individual_Teams__c where Contract__c=:con.id];
                System.debug('20200603');
                if(ind.size()>0){
                     System.debug('20200603V1');
                    delete ind;
                }
                    if(con.Region__c=='North Asia'){
                        email.add('legal.japan@jinkosolar.com');
                        System.debug('可以查到的email'+email);
                    }
                else{
                    email.add('legal@jinkosolar.com');
                        System.debug('可以查到的email'+email);
                    
                }
                }
                
            
            /*
            if(Finemail=true){
                
                set<Id> UserIds = new set<Id>(); 
                UserIds = SubmitReviewHelper.getContractReviewList(con.id);
                System.debug('可以查到的数量'+UserIds.size());
                for(User u : [SELECT Id, Name, Email,UserRole.Name FROM USER WHERE Id in:UserIds]){
                    System.debug('可以查到的用户角色'+u.UserRole.Name);
                    System.debug('可以查到的用户'+u.Name);
                    if(u.UserRole.Name =='Finance Assistance' ){
                        email.add(u.Email);
                        System.debug('可以查到的email'+email);
                    }
                }
                
            }
*/ 
            if(email.size()>0){
                system.debug('发送给相关人员'+email);
                CommonUtils.SendReviewMail1(con.Id,email,'Contract_Review_Mail');
            }
            
           
            //update Distribution Stock's Contract ID
            CvtOpps2Contract.updateInventory( op, con);
            //update Distribution Stock's Contract ID
            CvtOpps2Contract.updateProductionScheduled( op, con);
            //return to the order standard page
            
            //update Payments from Opportunity
            //CvtOpps2Contract.updatePayments(op, con);
            
            
        }
        catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                /**ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));*/
                System.debug( '------> ContractUpdate = ' + e.getDmlMessage(i) );
            }
        }
    }
        }
}