global class PritePADateClass {

    webservice static String submit(String conid){
       //  String printPADate = ApexPages.currentPage().getParameters().get('id');
       List<Contract> con = [select Print_PA_Date__c from Contract where id =: conid];
        for( Contract co:con){
            co.Print_PA_Date__c =date.today();
                      
            system.debug(co.Print_PA_Date__c );
        }
        update con;
         return '';
    }
   

}