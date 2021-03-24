@isTest

public class ReportDetailClassTest {
     static testMethod void myTest(){
                 ApexPages.StandardController sd;
          ApexPages.currentPage().getParameters().put('tp','SAP');    
          ApexPages.currentPage().getParameters().put('num','1');   
        ReportDetailClass ap =new ReportDetailClass(sd);
        ap.addPayment();
         ap.deleteID='1';
        ap.DeletePay ();
        ap.SelectDailyDetail () ;
         ReportDetailClass ap1 =new ReportDetailClass(sd);
         ApexPages.currentPage().getParameters().put('tp','OA');    
          ApexPages.currentPage().getParameters().put('num','1');   
        
     }

}