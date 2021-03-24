@isTest
public class CrmToBiCtrlTest {
  private testMethod static void DoTestAccount(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Account');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
        CrmToBiCtrl.doGet();
        
    }
    private testMethod static void DoTestAccount2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Account');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestAccount3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'Account');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    private testMethod static void DoTestLead(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Lead');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestLead2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Lead');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestLead3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'Lead');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    private testMethod static void DoTestContact(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Contact');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestContact2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Contact');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestContact3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'Contact');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    private testMethod static void DoTestOpportunity(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Opportunity');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestOpportunity2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Opportunity');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestOpportunity3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'Opportunity');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    private testMethod static void DoTestQuote(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Quote');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestQuote2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Quote');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestQuote3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'Quote');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    private testMethod static void DoTestPayment(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Payment');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestPayment2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Payment');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestPayment3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'Payment');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    private testMethod static void DoTestOpportunityLineItem(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'OpportunityLineItem');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestOpportunityLineItem2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'OpportunityLineItem');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestOpportunityLineItem3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'OpportunityLineItem');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    private testMethod static void DoTestContracts(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Contracts');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestContracts2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Contracts');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestContracts3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'Contracts');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    private testMethod static void DoTestProductDetail(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Product Detail');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestProductDetail2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Product Detail');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestProductDetail3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'Product Detail');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    private testMethod static void DoTestMDA(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'MDA');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestMDA2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'MDA');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestMDA3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'MDA');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    private testMethod static void DoTestOrder(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Order');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestOrder2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Order');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestOrder3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'Order');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    private testMethod static void DoTestOrderItem(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'OrderItem');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestOrderItem2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'OrderItem');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestOrderItem3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'OrderItem');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    private testMethod static void DoTestAmendmentPurchaseAgreement(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Amendment Purchase Agreement');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestAmendmentPurchaseAgreement2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Amendment Purchase Agreement');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestAmendmentPurchaseAgreement3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'Amendment Purchase Agreement');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    private testMethod static void DoTestAmendmentOrderProduct(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Amendment Order Product');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestAmendmentOrderProduct2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Amendment Order Product');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestAmendmentOrderProduct3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'Amendment Order Product');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    private testMethod static void DoTestAmendmentPayment(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Amendment Payment');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestAmendmentPayment2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Amendment Payment');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestAmendmentPayment3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'Amendment Payment');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    private testMethod static void DoTestProduct(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Product');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestProduct2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Product');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestProduct3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'Product');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    
    
    private testMethod static void DoTestProject(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'A');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Project');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestProject2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('EndTime','2020-07-20 00:00:00');
        req.addHeader('SyncObject', 'Project');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
    private testMethod static void DoTestProject3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        

        
        req.requestURI = '/services/apexrest/CrmToBiCtrl/';  
        req.addHeader('SyncType', 'B');
        req.addHeader('StartTime','2020-01-02 00:00:00');
        req.addHeader('SyncObject', 'Project');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        CrmToBiCtrl.ResultWrapper results = CrmToBiCtrl.doPost();
        Test.stopTest();
    }
}