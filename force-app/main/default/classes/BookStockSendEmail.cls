global class BookStockSendEmail {
    webservice static String submit(String bookid){
             
        Apply_Inventory__c bookstockLst =[Select Id,BookStockProductName__c,BookDescription__c,PSC__c,Opportunity__c,OwnerId,SendEmialCounts__c,SendEmialTime__c,Approval_Status__c from Apply_Inventory__c where Id =:bookid];
        try{
                 if(bookstockLst !=null){
                    User us =[Select Id,Name,BMO_specialist__c,BMO_specialist__r.Name,IsActive from User where Name =: System.Label.Japan_BMO and IsActive=true];
                    if(us !=null){
                        SendEmailUtils.sendToSomeOneId(bookstockLst.id,us.Id,'Book_Stock_Approval');
                      //  bookstockLst.
                        if(bookstockLst.SendEmialCounts__c==null){
                            bookstockLst.SendEmialCounts__c =1;
                        }else{
                            bookstockLst.SendEmialCounts__c =bookstockLst.SendEmialCounts__c+1;
                        }
                        bookstockLst.SendEmialTime__c = datetime.now();
                        bookstockLst.Approval_Status__c ='Pending';
                        update bookstockLst;
                         return 'Submit success. '+ us.Name+ ' has received this request.';
                    }
                   }
        }catch(Exception e){
                 System.debug('*********error'+e);
            return 'SendEmail failed';
            }
   
           // SendEmailUtils2.sendToSomeOne(con.Id,con.Owner.Contract_Review__r.name,'Contract_PO_PI_JapanApproval');
     
         return 'SendEmail failed';
        //return  'Submit success. '+ con.Owner.Contract_Review__r.Name+ ' has received this request.';
    }
    

}