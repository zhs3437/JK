/**
 * 
 * create by fanzr 20170320
 * 
 */
@isTest()
public class SAPIDCtrlTest {
    static PageReference currentPage = Page.SAPID;
     static testMethod void SAPIDTest(){
        QW_MockHttpResponseGenerator mock = new QW_MockHttpResponseGenerator();
        mock.body = '{"token_type": "", "access_token": ""}';
        Test.setMock(HttpCalloutMock.class, mock);
       setParameterValue('sapid','00001');
       setParameterValue('sfid','00002');
       setParameterValue('sapde','00003');
       SAPIDCtrl  spc = new SAPIDCtrl(); 
       spc.createObj();
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