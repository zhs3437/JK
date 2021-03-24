public class MWJapanCtrl{

    public MWJapanCtrl(){}
    public MWJapanCtrl(ApexPages.StandardController controller) {
        requestId = ApexPages.currentPage().getParameters().get('id');
    }

    public String requestId {get;set;}
    
}