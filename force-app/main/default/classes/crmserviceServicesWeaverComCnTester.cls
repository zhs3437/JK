@isTest
global class crmserviceServicesWeaverComCnTester implements WebServiceMock{ 
    
    @IsTest private static void testMthd() {
        Test.setMock(WebServiceMock.class, new crmserviceServicesWeaverComCnTester());
        webservicesWorkflowWeaver.Customerinfo customer = new webservicesWorkflowWeaver.Customerinfo();
        crmserviceServicesWeaverComCn.CrmServiceHttpPort service = new crmserviceServicesWeaverComCn.CrmServiceHttpPort();
        service.createCustomerWorkFlow(customer);  
    }
    global void doInvoke(
        Object stub, 
        Object request, 
        Map<String, Object> response, 
        String endpoint, 
        String soapAction, 
        String requestName, 
        String responseNS, 
        String responseName, 
        String responseType) {
            crmserviceServicesWeaverComCn.createCustomerWorkFlowResponse_element val = new crmserviceServicesWeaverComCn.createCustomerWorkFlowResponse_element();
            //val.result = 'mock mock mock';
            response.put('response_x', val);
        }
    
}