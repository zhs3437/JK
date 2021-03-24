@isTest
global class AsyncWebservicesCustomerWeaverComCnTest implements WebServiceMock{ 
    
    @IsTest private static void testMthd() {
        Test.setMock(WebServiceMock.class, new AsyncWebservicesCustomerWeaverComCnTest());
        Continuation con = new Continuation(60);
        webservicesWorkflowWeaver.Customerinfo customer = new webservicesWorkflowWeaver.Customerinfo();
        AsyncWebservicesCustomerWeaverComCn.createCustomerWorkFlowResponse_elementFuture cwfr = new AsyncWebservicesCustomerWeaverComCn.createCustomerWorkFlowResponse_elementFuture();
        AsyncWebservicesCustomerWeaverComCn.AsyncCrmServiceHttpPort service = new AsyncWebservicesCustomerWeaverComCn.AsyncCrmServiceHttpPort ();
        //cwfr.getValue();
        service.beginCreateCustomerWorkFlow(con,customer);  
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
            AsyncWebservicesCustomerWeaverComCn.createCustomerWorkFlowResponse_elementFuture val = new AsyncWebservicesCustomerWeaverComCn.createCustomerWorkFlowResponse_elementFuture();
            //AsyncWebserviceServicesWeaverComCn.createCustomerWorkFlowResponse_elementFuture val = new AsyncWebservicesCustomerWeaverComCn.createCustomerWorkFlowResponse_elementFuture();
            //val.result = 'mock mock mock';
            response.put('response_x', val);
        }
    
}