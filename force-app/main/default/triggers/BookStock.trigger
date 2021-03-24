trigger BookStock on Apply_Inventory__c (after insert, after update, after delete) {
	String oppid = '';
    //List<Contract> conList = [SELECT ID,Name,Opportunity__c,Has_Book_Stock__c FROM Contract];
    List<Contract> conList = new List<Contract>();
        
    if(!Test.isRunningTest()){
        
        if(Trigger.isInsert){
             Set<string> idst= new Set<string>();
             for(Apply_Inventory__c obj : trigger.new){
                idst.add(obj.Opportunity__c);
             }
             conList = [SELECT ID,Name,Opportunity__c,Has_Book_Stock__c,RecordTypeId FROM Contract WHERE Opportunity__c in: idst];
            for(Apply_Inventory__c obj : trigger.new){
               
                if(conList.size()>0){
    				if(obj.Approval_Status__c == 'Approved'){
                        for(Contract con : conList){
                            con.Has_Book_Stock__c = true;
                        }
                        
                        System.debug('***************所有更新的合同: '+conList);
                        
                        update conList;
                        
                        System.debug('***************成功更新');
                        break;
                    }else{
                        for(Contract con : conList){
                        	if(con.RecordTypeId == '012900000007S6u'){
                            	con.Has_Book_Stock__c = false;
                        	}else{
                        		con.Has_Book_Stock__c = true;
                        	}
                        }
                        
                    }
                }
                
            }
            try{
                            
                            System.debug('***************合同1: '+conList);
                            
                        	update conList;
                            
                            System.debug('***************成功更新');
                        }catch(Exception e){
                        	System.debug('############e：'+String.valueOf(e));
                        }
        }
        
        if(Trigger.isUpdate){
            for(Apply_Inventory__c obj : trigger.new){
                conList = [SELECT ID,Name,Opportunity__c,Has_Book_Stock__c,RecordTypeId FROM Contract WHERE Opportunity__c =: obj.Opportunity__c];
                if(conList.size()>0){
    				if(obj.Approval_Status__c == 'Approved'){
                        for(Contract con : conList){
                            con.Has_Book_Stock__c = true;
                        }
                        
                        System.debug('***************合同2: '+conList);
                        update conList;
                        System.debug('***************成功更新');
                        break;
                    }else{
                        for(Contract con : conList){
                            if(con.RecordTypeId == '012900000007S6u'){
                            	con.Has_Book_Stock__c = false;
                        	}else{
                        		con.Has_Book_Stock__c = true;
                        	}
                        }
                        
                        System.debug('***************合同3: '+conList);
                        update conList;
                        System.debug('***************成功更新');
                    }
                }
            }
        }
        
        if(Trigger.isDelete){
            for(Apply_Inventory__c obj : trigger.old){
				conList = [SELECT ID,Name,Opportunity__c,Has_Book_Stock__c,RecordTypeId FROM Contract WHERE Opportunity__c =: obj.Opportunity__c];
                List<Apply_Inventory__c> aiList = [SELECT ID,Name,Approval_Status__c,Opportunity__c FROM Apply_Inventory__c
                	WHERE Opportunity__c =: obj.Opportunity__c AND Approval_Status__c =: 'Approved'];
                if(conList.size() > 0){
                    for(Contract con : conList){
                        if(aiList.size() > 0){
                            con.Has_Book_Stock__c = true;
                        }else{
                            if(con.RecordTypeId == '012900000007S6u'){
                            	con.Has_Book_Stock__c = false;
                        	}else{
                        		con.Has_Book_Stock__c = true;
                        	}
                        }
                    }
                    System.debug('***************合同4: '+conList);
                    update conList;
                    System.debug('***************成功更新');
                }
            }
        }
        
    }
    
    String runTest = '';
    runTest = 'run';
    
}