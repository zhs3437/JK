public class OANoticeSiteCtrl {
    public void createObj(){
        Log__c log = new Log__c(
            Type__c='Order',
            StartTime__c = System.now()
        );        
        try{          
            string oasta1 =null; 
            oasta1 ='';
            oasta1 ='';
            String oasta=ApexPages.currentPage().getParameters().get('oasta');   //OA审批订单状态         
            string con1 =null; 
            con1 =''; 
            con1 =''; 
            String con=ApexPages.currentPage().getParameters().get('con');      //OA 审批流水号               
            system.debug('oasta--->'+oasta);
            system.debug('con--->'+con);
            
            
            if(!string.isEmpty(con)){
                List<Order> o=[SELECT ID,Contract_No__c,OA_Notice_Status__c,OA_Notice_NO__c,Lock__c from order where OA_Notice_NO__c=:con];
                boolean oldb=o[0].Lock__c;
                 o[0].lock__c=false;
               o[0].OA_Notice_Status__c=oasta;
                update o[0];
                o[0].lock__c=oldb;
                update o[0];
                
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Successful:'+oasta+';'+ con));
        }
        catch(Exception ex){
            log.Error_Message__c     = ex.getMessage();
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,ex.getMessage()));
        }
        if(log !=null){
            log.EndTime__c           = System.now();
            insert log; 
        }
        
    }
}