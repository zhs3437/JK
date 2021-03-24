@isTest
public  class SendEmailCtrl2Test {
    public static Contract con  ;
  //  public static Contract_Submit_Review__c csr; 
  private static testMethod void Email1(){
     Account acc = TestHelper.createAccount();
    con = TestHelper.createContract(acc.Id); 
     String conId=con.Id;
   //    csr =new Contract_Submit_Review__c();
   //   csr.Contract__c = conId;
   //   insert csr;
                 
      //  ContractSpecialSubmitReviewSendEmailCtrl.sendEmail(conId);

     //   ContractSpecialSubmitReviewSendEmailCtrl.checkConSubmit(conId);  
        
        SendEmailUtils2.sendToSomeOne(conId, acc.Name, '');
        SendEmailUtils2.sendToSomeOneId(conId, acc.Id, '');

    }
    /**
    private static testMethod void Email2()  {
             Account acc = TestHelper.createAccount();
     Contract con = TestHelper.createContract(acc.Id); 
     String conId=con.Id;
      ContractSpecialSubmitReviewSendEmailCtrl.checkConSubmit(conId); 
    }  
**/
    
}