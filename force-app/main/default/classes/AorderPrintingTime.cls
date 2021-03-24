global class AorderPrintingTime {
    webservice static void addtime(String requestId){    
        Amendment__c   ad = [select id,Printing_time__c,lock__c from Amendment__c where id=:requestId];

            Boolean lock =ad.lock__c;
            ad.lock__c=false;

        ad.Printing_time__c=date.today();
        update ad;
            ad.lock__c=lock;
                   update ad;
            
    }
    
        webservice static void Legaladdtime(String requestId){    
        Amendment__c   ad = [select id,Printing_time__c,lock__c,Legal_Preview_Time__c from Amendment__c where id=:requestId];

            Boolean lock =ad.lock__c;
            ad.lock__c=false;

        ad.Legal_Preview_Time__c=datetime.now();
        update ad;
            ad.lock__c=lock;
                   update ad;
            
    }    
        webservice static String HaveUnLockAmend(String requestId){    
        List<Amendment__c>   adLst = [select id,name,Lock__c,Printing_time__c from Amendment__c where Order__c=:requestId];
            String str ='0';
            if(adLst.size()==0){
                str='0';
            }
            if(adLst.size()>0){
        for(Amendment__c ad:adLst){
            if(ad.name.indexof('V')>-1){
            if(ad.Lock__c==false){
                str='1';
            }
                }
            }
            }
            return str;
    }
            webservice static String HaveUnLockCon(String requestId){ 
                List<Amendment__c>   adLst = [select id,name,Lock__c,Printing_time__c from Amendment__c where Contract__c=:requestId];
           String str ='0';
            if(adLst.size()==0){
                str='0';
            }
            if(adLst.size()>0){
        for(Amendment__c ad:adLst){
            if(ad.name.indexof('V')>-1){
            if(ad.Lock__c==false){
                str='1';
            }
                }
            }
            }
            return str;
    }
    webservice static String apprel(String requestId){    
        String flag='0';
        List<SubmitForReview__c>   sfLst = [select id,Status__c from SubmitForReview__c where Amendment__c=:requestId];
        if(sfLst.size()>0){
            for(SubmitForReview__c sf:sfLst){
                if(sf.Status__c!='Approved'){
                    flag='1';
                }
            }
            
        }
        return flag;           
    }
      webservice static String contractTF(String requestId){    
        String flag='0';
        List<order>   sfLst = [select id from order where Contractid=:requestId];
        if(sfLst.size()==0){
flag='1';
                }

        return flag;           
    }
    webservice static void AustraliaEmail(String requestId){    
        Order o = [select id,Lock__c,AustraliaEmailOrNot__c from Order where id=:requestId];
        Boolean od = o.Lock__c;
        if(od == true){
            o.Lock__c = false;
            update o;
            o.AustraliaEmailOrNot__c = true;
            o.Lock__c = true;
            update o;
        }else if(od == false){
            o.AustraliaEmailOrNot__c = true;
            update o;
        }
    }
}