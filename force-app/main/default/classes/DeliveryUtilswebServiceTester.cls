@isTest
global class DeliveryUtilswebServiceTester implements WebServiceMock {
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
           
       sapDelivery.TABLE_OF_ZSDO0054 TABLE_OF_ZSDO0054 = new sapDelivery.TABLE_OF_ZSDO0054();
       sapDelivery.ZSDO0054Response_element respElement =   new sapDelivery.ZSDO0054Response_element();   
       response.put('response_x', respElement);
    }
}