@isTest
public class sapUnbookTest {
    
    static testMethod void testCallout(){
        sapEccUnbook.Unbook_element[] Unbook = new sapEccUnbook.Unbook_element[]{};
        sapUnbook.HTTPS_Port  s_hp = new sapUnbook.HTTPS_Port();
        sapEccUnbook.UnbookReturn_element[] s_ure =s_hp.SI_CRM2ECC_Unbook_Out(Unbook);
        Test.setMock(WebServiceMock.class, new SapUnbookWebServiceMock());
    }
}