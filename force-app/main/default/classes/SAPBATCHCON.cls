global without sharing class SAPBATCHCON {
    webService static void clickUpdate(  String id  ){
        try{
     Contract Con =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Contract) + ' ' +
                                          'Where id =: id');
        String conid=con.id;
          List<Order> ord=new List<order>();
        List<jinkosolarComEccContractInfo.T_I_CRM_CONTR_element> jctLst =new List<jinkosolarComEccContractInfo.T_I_CRM_CONTR_element>();
        jinkosolarComEccContractInfo.T_I_CRM_CONTR_element jct =new  jinkosolarComEccContractInfo.T_I_CRM_CONTR_element();
        jct.ZCRMCONTRID=con.id;
        jct.BSTKD=con.Contract_NO__c;
        jct.ZOPID=con.Opportunity__c;
        jct.ZCREATEFLAG='X';
       // jct.ZCLOSEFLAG='X'; 关闭时间目前停用
        String month;
        String day;
        if(con.CloseDate__c!=null){
        if(con.CloseDate__c.month()==1){
            month='01';
        }
        else if(con.CloseDate__c.month()==2){
            month='02';
        }   else if(con.CloseDate__c.month()==3){
            month='03';
        }   else if(con.CloseDate__c.month()==4){
            month='04';
        }   else if(con.CloseDate__c.month()==5){
            month='05';
        }   else if(con.CloseDate__c.month()==6){
            month='06';
        }   else if(con.CloseDate__c.month()==7){
            month='07';
        }   else if(con.CloseDate__c.month()==8){
            month='08';
        }   else if(con.CloseDate__c.month()==9){
            month='09';
        }
            else{
                 month=con.CloseDate__c.month()+'';
            }
         if(con.CloseDate__c.day()==1){
            day='01';
        }
        else if(con.CloseDate__c.day()==2){
            day='02';
        }   else if(con.CloseDate__c.day()==3){
            day='03';
        }   else if(con.CloseDate__c.day()==4){
            day='04';
        }   else if(con.CloseDate__c.day()==5){
            day='05';
        }   else if(con.CloseDate__c.day()==6){
            day='06';
        }   else if(con.CloseDate__c.day()==7){
            day='07';
        }   else if(con.CloseDate__c.day()==8){
            day='08';
        }   else if(con.CloseDate__c.day()==9){
            day='09';
        }
            else{
                day=con.CloseDate__c.day()+'';
            }
            
              jct.ZCLOSEDATE=con.CloseDate__c.YEAR()+''+month+day;
        }
      
        //jct.ZCLOSETIME=''; 关闭时间目前停用
        jct.ZCLOSENAME=con.ownerid;
       
            ord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order) + ' ' +
                                          'Where ContractID =: conid');


        if(ord.size()>0){
        jct.ZSIGNFLAG='X';
            jct.ZCRMORFLAG='X';
            jct.ZSIGNDATE=timechange(ord[0].CreatedDate.YEAR()+'')+timechange(ord[0].CreatedDate.month()+'')+timechange(ord[0].CreatedDate.day()+'');
jct.ZSIGNTIME=timechange(ord[0].CreatedDate.hour()+'')+timechange(ord[0].CreatedDate.minute()+'')+timechange(ord[0].CreatedDate.second()+'');
   
           
        

                        System.debug('ZSIGNDATE:'+jct.ZSIGNDATE);
                System.debug('ZSIGNTIME:'+jct.ZSIGNTIME);
        jct.ZCRMORDERNO=ord[0].id;
            if(ord[0].Transit_Fees__c==null){
                ord[0].Transit_Fees__c=0;
            }
            if((ord[0].Trade_term__c=='CIF' || ord[0].Trade_term__c=='CIP')&& ord[0].Destination_Region__c=='Middle East&Africa'){
                jct.ZCRMORAMT=String.valueOf(ord[0].Total_Price__c*(1.2/10000+1));
            }
             else if(ord[0].Trade_term__c!='CIF' && ord[0].Trade_term__c!='FOB' && ord[0].Destination_Country__c=='Japan'){
                jct.ZCRMORAMT=String.valueOf((ord[0].Total_Price__c+ord[0].Transit_Fees__c)*1.1);
            } else if(ord[0].Destination_Country__c=='Vietnam' && ord[0].Seller__c=='Jinkosolar (Vietnam) Co., Ltd.'){
                    system.debug('5');
                   
                    jct.ZCRMORAMT=String.valueOf((ord[0].Total_Price__c+ord[0].Transit_Fees__c)*1.1);
                }
            
                else{
             jct.ZCRMORAMT=String.valueOf(ord[0].Total_Price__c+ord[0].Transit_Fees__c);
                }
            jct.vbeln=ord[0].SAP_Order_ID__c;
            if(jct.vbeln!=null){
                jct.ZSYNCSAPFLAG='X';
            }
        }
        
          System.debug('ZCLOSETIME:'+jct.ZCLOSETIME);
          System.debug('ZCLOSENAME:'+jct.ZCLOSENAME);
          System.debug('ZCLOSEDATE:'+jct.ZCLOSEDATE);
            
             if(con.Transit_Fees__c==null){
                con.Transit_Fees__c=0;
            }
            if((con.Trade_term__c=='CIF' || con.Trade_term__c=='CIP' ) && con.Destination_Region__c=='Middle East&Africa'){
            jct.ZCONTRAMT=String.valueOf(con.Total_Price__c*(1.2/10000+1));
            }
             else if(con.Trade_term__c!='CIF' && con.Trade_term__c!='FOB' && con.Destination_Country__c=='Japan'){
                jct.ZCONTRAMT=String.valueOf((con.Total_Price__c+con.Transit_Fees__c)*1.1);
            }
             else if(con.Destination_Country__c=='Vietnam' && con.Seller__c=='Jinkosolar (Vietnam) Co., Ltd.'){
                    system.debug('5');
                   
                 jct.ZCONTRAMT=String.valueOf((con.Total_Price__c+con.Transit_Fees__c)*1.1);
                }
            else{
               jct.ZCONTRAMT=String.valueOf(con.Total_Price__c+con.Transit_Fees__c); 
            }
            jct.waers=con.CurrencyIsoCode;
            jct.ZCNTROWEN=con.OwnerId;
            jctLst.add(jct);
            jinkosolarComCrmContractInfo.HTTPS_Port send =new jinkosolarComCrmContractInfo.HTTPS_Port();
            jinkosolarComEccContractInfo.DT_ContractInfo_Response response=send.SI_CRM2ECC_ContractInfo_Out(jctLst);
            String i='';
            i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
                i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
            i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
            i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
            i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
            i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
            i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
            i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
            i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
            i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
             i='';
            i='';
                i='';
            i='';
            i='';
            system.debug('response:'+response.E_MSGTY);
            system.debug('response:'+response.E_MSGTXT);
        }catch(Exception e){ System.debug('------------> Exception: '+e.getMessage());}
    }
    webService static String timechange(  String num  ){
        if(num=='1'){
            return '01';
        }else if(num=='2'){
            return '02';
        }
        else if(num=='3'){
            return '03';
        }
        else if(num=='4'){
            return '04';
        }
        else if(num=='5'){
            return '05';
        }
        else if(num=='6'){
            return '06';
        }
        else if(num=='7'){
            return '07';
        }
        else if(num=='8'){
            return '08';
        }
        else if(num=='9'){
            return '09';
        }
      
        
        else{
        return num;
        }
    }

    

}