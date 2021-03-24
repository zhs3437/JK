public class ContractTemplat1MWCtrl{

    public ContractTemplat1MWCtrl(){}
    public ContractTemplat1MWCtrl(ApexPages.StandardController controller) {
        requestId = ApexPages.currentPage().getParameters().get('id');
        Contract con = [select Warranty_On_Material_and_Workmanship__c from Contract where id =:controller.getId()];
        String Warranty =con.Warranty_On_Material_and_Workmanship__c ;
        if(Warranty  == '10 linear warranty'){
            DocId = '015p000000099rj';
        }
        else{
            DocId='015p000000099ro';
        }
    }
    public String requestId {get;set;}
    public String DocId{get;set;}   
    
    
}