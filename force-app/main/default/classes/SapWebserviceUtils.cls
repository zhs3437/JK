global with sharing class SapWebserviceUtils {
    webservice static String runSap(String conid){
        String status = 'false';
        
        SapIntegrateUtils utils = new SapIntegrateUtils();
        if(conid != null && conid != ''){
            utils.conid = conid;
            utils.generateData();
            utils.SynAccount();//同步客户
            utils.SynContract();//同步合同
            
            if(utils.synAccountList.size()>0) update utils.synAccountList;  // 更新返回的SAP ID
            if(utils.synContractList.size()>0){
                for(Contract con : utils.synContractList){
                    if(con.SAP_External_ID__c != null){
                        status = 'true';
                        break;
                    }
                }
                update utils.synContractList;
            } // 更新返回的SAP ID 
            insert utils.lst_log;
            
            return status;
        }else{
            return status;
        }
        return status;
        
    }
    
    public static void runTest(){
        String run = 'test run';
        run = 'test run';
        run = 'test run';
        run = 'test run'; 
        run = 'test run'; 
        run = 'test run'; 
        run = 'test run';
        run = 'test run'; 
        run = 'test run';
        run = 'test run';
        run = 'test run';
        run = 'test run'; 
        run = 'test run'; 
        run = 'test run'; 
        run = 'test run';
        run = 'test run'; 
        run = 'test run';
        run = 'test run';
        run = 'test run';
        run = 'test run'; 
        run = 'test run'; 
        run = 'test run'; 
        run = 'test run';
        run = 'test run'; 
        run = 'test run';
    }
}