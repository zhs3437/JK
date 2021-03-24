@isTest
public class SapNewEccStatusChangeTest {
    @isTest static void testCallout() {
        SapNewEccStatusChange.DT_StatusChange sne = new SapNewEccStatusChange.DT_StatusChange();
        SapNewEccStatusChange.StatusChangeReturn_element ssc = new SapNewEccStatusChange.StatusChangeReturn_element();
        SapNewEccStatusChange.StatusChange_element  sse = new SapNewEccStatusChange.StatusChange_element();
        SapNewEccStatusChange.DT_StatusChange  sds = new SapNewEccStatusChange.DT_StatusChange();
        Test.setMock(WebServiceMock.class, new SapChangeStatusWebServiceMock());
    }
}