//Generated by wsdl2apex

public class AsyncWebservicesCustomerWeaverComCn {
    public class createCustomerWorkFlowResponse_elementFuture extends System.WebServiceCalloutFuture {
        public String getValue() {
            crmserviceServicesWeaverComCn.createCustomerWorkFlowResponse_element response = (crmserviceServicesWeaverComCn.createCustomerWorkFlowResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.out;
        }
    }
    public class AsyncCrmServiceHttpPort {
        public String endpoint_x = System.Label.JSI_ACCOUNT_ENDPOINT_URL;//'http://114.80.172.92/services/CrmService';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'webservices.customer.weaver.com.cn', 'crmserviceServicesWeaverComCn', 'http://webservices.workflow.weaver', 'webservicesWorkflowWeaver'};
        public AsyncWebservicesCustomerWeaverComCn.createCustomerWorkFlowResponse_elementFuture beginCreateCustomerWorkFlow(System.Continuation continuation,webservicesWorkflowWeaver.Customerinfo in0) {
            crmserviceServicesWeaverComCn.createCustomerWorkFlow_element request_x = new crmserviceServicesWeaverComCn.createCustomerWorkFlow_element();
            request_x.in0 = in0;
            return (AsyncWebservicesCustomerWeaverComCn.createCustomerWorkFlowResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncWebservicesCustomerWeaverComCn.createCustomerWorkFlowResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'webservices.customer.weaver.com.cn',
              'createCustomerWorkFlow',
              'webservices.customer.weaver.com.cn',
              'createCustomerWorkFlowResponse',
              'crmserviceServicesWeaverComCn.createCustomerWorkFlowResponse_element'}
            );
        }
    }
}