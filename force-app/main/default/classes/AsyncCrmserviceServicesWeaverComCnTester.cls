@isTest
global class AsyncCrmserviceServicesWeaverComCnTester implements WebServiceMock{ 
    
    @IsTest private static void testMthd() {
        Test.setMock(WebServiceMock.class, new AsyncCrmserviceServicesWeaverComCnTester());
        Continuation con = new Continuation(60);
        webservicesWorkflowWeaver.Customerinfo customer = new webservicesWorkflowWeaver.Customerinfo();
        AsyncCrmserviceServicesWeaverComCn.createCustomerWorkFlowResponse_elementFuture cwfr = new AsyncCrmserviceServicesWeaverComCn.createCustomerWorkFlowResponse_elementFuture();
        AsyncCrmserviceServicesWeaverComCn.AsyncCrmServiceHttpPort service = new AsyncCrmserviceServicesWeaverComCn.AsyncCrmServiceHttpPort ();
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
            AsyncCrmserviceServicesWeaverComCn.createCustomerWorkFlowResponse_elementFuture val = new AsyncCrmserviceServicesWeaverComCn.createCustomerWorkFlowResponse_elementFuture();
            //val.result = 'mock mock mock';
            response.put('response_x', val);
        }
    
}