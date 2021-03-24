public class paymentVCctrl {
      public String requestId{get;set;}
    public list<payment__c> paylst  {get{
            return [Select id,Percentage__c,Amount__c,Down_Balance_Payment__c,Payment_Method__c,Days__c,Payment_Term__c from payment__c where opportunity__c =: requestId limit 1000];
    } set;
    }
   public String requestId2{get;
                            set;}
    public String requestId3{get;
                             set;}
       public String requestId4{get;
                            set;}
    public String requestId5{get;
                             set;}
     public String requestId6{get;
                            set;}
    public String requestId7{get;
                             set;}
}