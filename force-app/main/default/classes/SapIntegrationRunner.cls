public class SapIntegrationRunner {
    @future(callout=true)
    public static void Run(){
        try{
            SapIntegrateUtils utils = new SapIntegrateUtils();
            utils.SynAccount();//同步客户
            utils.SynContract();//同步合同
        
            System.debug('++++++++++++++++++++++++++++++synAccountList: '+utils.synAccountList);
            System.debug('++++++++++++++++++++++++++++++size: '+utils.synAccountList.size());
            // 必须在同步的下面执行DML
            if(utils.synAccountList.size()>0) update utils.synAccountList;  // 更新返回的SAP ID
            
            if(utils.synContractList.size()>0)    update utils.synContractList; // 更新返回的SAP ID
            System.debug('++++++++++++++++++++++++++++++synContractList: '+utils.synContractList);
            System.debug('++++++++++++++++++++++++++++++size: '+utils.synContractList.size());
            
            
            insert utils.lst_log;
        }catch(Exception e){
            System.debug('***************************Exception: '+e);
        }
    }
}