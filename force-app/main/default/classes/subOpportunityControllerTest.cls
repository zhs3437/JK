/**
* 
* create by fanzr 20170801
* 
*/
@isTest()
public class subOpportunityControllerTest {
    static PageReference currentPage = Page.subOpportunityPage;
    static testMethod void SAPIDTest(){
        setParameterValue('oppId','00001');
        setParameterValue('oppName','4MW-JKM305P-72-20170629');
        subOpportunityController  soc = new subOpportunityController(); 
        //soc.goto();
    }
    public static String getParameterValue(String key) {
        Test.setCurrentPage(currentPage);
        if(ApexPages.CurrentPage().getParameters().get(key) != null && ApexPages.CurrentPage().getParameters().get(key) != '') {
            return ApexPages.CurrentPage().getParameters().get(key);
        } else {
            return '';
        }
    }
    
    public static void setParameterValue(String key,String value) {
        Test.setCurrentPage(currentPage);
        ApexPages.CurrentPage().getParameters().put(key,value);
    }    
    
}