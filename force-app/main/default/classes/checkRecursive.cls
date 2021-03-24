public class checkRecursive {
    private static boolean run = true;
    private static boolean run2 = true;
        private static boolean run3 = true;
    private static boolean run4 = true;
    private static boolean run5 = true;
    private static boolean run6 = true;
    private static boolean run7 = true;
	private static boolean run8 = true;
	private static boolean run9 = true;
	private static boolean run10 = true;
	private static boolean run11 = true;
    private static boolean run12 = true;
     private static boolean run13 = true;
     private static boolean run14 = true;
     private static boolean run15 = true;
     private static boolean run16 = true;
    private static boolean run17 = true;
         private static boolean run18 = true;
     private static boolean run19 = true;
    private static boolean run20 = true;
        private static boolean run21 = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }
        else{
            return run;
        }
    }
     public static boolean runOnce2(){
        if(run2){
            run2=false;
            return true;
        }
        else{
            return run2;
        }
    }
    public static boolean runOnce3(){
        if(run3){
            run3=false;
            return true;
        }
        else{
            return run3;
        }
    }
      public static boolean runOnce4(){
        if(run4){
            run4=false;
            return true;
        }
        else{
            return run4;
        }
    }
     public static boolean runOnce5(){
        if(run5){
            run5=false;
            return true;
        }
        else{
            return run5;
        }
    }
    
    public static boolean runOnce6(){
        if(run6){
            run6=false;
            return true;
        }
        else{
            return run6;
        }
    }
    //补充MOU
        public static boolean runOnce7(){
        if(run7){
            run7=false;
            return true;
        }
        else{
            return run7;
        }
    }
    //OppSyncTrigger
     public static boolean runOnce8(){
        if(run8){
            run8=false;
            return true;
        }
        else{
            return run8;
        }
    }
    //paymentDescription
    public static boolean runOnce9(){
        if(run9){
            run9=false;
            return true;
        }
        else{
            return run9;
        }
    }
      public static boolean runOnce10(){
        if(run10){
            run10=false;
            return true;
        }
        else{
            return run10;
        }
    }
    public static boolean runOnce11(){
        if(run11){
            run11=false;
            return true;
        }
        else{
            return run11;
        }
    }
    public static boolean runOnce12(){
        if(run12){
            run12=false;
            return true;
        }
        else{
            return run12;
        }
    }
     public static boolean runOnce13(){
        if(run13){
            run13=false;
            return true;
        }
        else{
            return run13;
        }
    }
       public static boolean runOnce14(){
        if(run14){
            run14=false;
            return true;
        }
        else{
            return run14;
        }
    }
    //15 Account
    public static boolean runOnce15(){
        if(run15){
            run15=false;
            return true;
        }
        else{
            return run15;
        }
    }
    //16 Account
    public static boolean runOnce16(){
        if(run16){
            run16=false;
            return true;
        }
        else{
            return run16;
        }
    }
    // OpportunityLineItemTrigger
     public static boolean runOnce17(){
        if(run17){
            run17=false;
            return true;
        }
        else{
            return run17;
        }
    }
    //以下还未使用
         public static boolean runOnce18(){
        if(run18){
            run18=false;
            return true;
        }
        else{
            return run18;
        }
    }
         public static boolean runOnce19(){
        if(run19){
            run19=false;
            return true;
        }
        else{
            return run19;
        }
    }
         public static boolean runOnce20(){
        if(run20){
            run20=false;
            return true;
        }
        else{
            return run20;
        }
    }
         public static boolean runOnce21(){
        if(run21){
            run21=false;
            return true;
        }
        else{
            return run17;
        }
    }
    public static void EmailSend(Integer EmailTimes,Opportunity opp){

        if(EmailTimes==1){
            
            //   Utils.sendEmailWithTemplate2('joel@trixpro.com',opp.id, 'Freight_Notify',opp.Ownerid);

            //北亚√
            IF(opp.Region__c=='North Asia'){
Utils.sendEmailWithTemplate2('yayun.wang@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
				Utils.sendEmailWithTemplate2('shunxia.li@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('lr@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('yu1.chen@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('hong.liu@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('hisashi.sakai@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('jian.zhu@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('hui.wu1@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
            }
            //南亚
             IF(opp.Region__c=='South Asia'){
                Utils.sendEmailWithTemplate2('hong.liu@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('lr@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                }
            //北美√
            else IF(opp.Region__c=='North America'){
                Utils.sendEmailWithTemplate2('marie.wilson@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('issac.li@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('kyle.carpenter@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('rhea.bautista@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('yunsien.tan@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('sheree.tom@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('john.ball@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
            }
            //欧洲√
            else if(opp.Region__c=='EU(Union)' || opp.Region__c=='EU(Non-Eu)' || opp.Destination_Country__c=='Italy'){
                 Utils.sendEmailWithTemplate2('Int.logistics@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
            }
            //中东非√
            else if(opp.Region__c=='Middle East&Africa'||opp.Region__c == 'MENA'||opp.Region__c == 'SSA'){
                 Utils.sendEmailWithTemplate2('MEA.logistics@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
            }
            //拉丁√
            else if(opp.Region__c=='Latin America&Italy'){
                 Utils.sendEmailWithTemplate2('yulan.gong@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('Nubia.razo@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
            }
            //澳洲 √
            else if(opp.Region__c=='ROA' && (opp.Destination_Country__c=='Australia' || opp.Destination_Country__c=='New Zealand')){
                 Utils.sendEmailWithTemplate2('lr@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('chunmei.wang@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('samantha.yong@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                        Utils.sendEmailWithTemplate2('craig.cleland@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
               
            }
            //ROA √
               else if(opp.Region__c=='ROA' && opp.Destination_Country__c!='Australia' && opp.Destination_Country__c!='New Zealand'){
                    Utils.sendEmailWithTemplate2('chunmei.wang@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                    Utils.sendEmailWithTemplate2('yayun.wang@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                   Utils.sendEmailWithTemplate2('hui.wu1@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                   }
            //其他
            else{
                                 Utils.sendEmailWithTemplate2('lr@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
                Utils.sendEmailWithTemplate2('chunmei.wang@jinkosolar.com',opp.id, 'Freight_Notify',opp.Ownerid);
            }


        }

}
    
}