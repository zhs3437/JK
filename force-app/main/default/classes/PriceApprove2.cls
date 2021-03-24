global class PriceApprove2 {
	webservice static String submit(String conid){
        Contract con = [Select id,
                        Name,
                        OwnerId,
                        Owner.Name,
                        Owner.Contract_Review__r.Name,
                        Owner.Contract_Review__c
                        From Contract
                       where id = :conId];
        
            SendEmailUtils2.sendToSomeOne(con.Id,con.Owner.Contract_Review__r.name,'Contract_PO_PI_JapanApproval');
     
            
        return  'Submit success. '+ con.Owner.Contract_Review__r.Name+ ' has received this request.';
    }
    	webservice static String Addproduct(String productAppid){
        Product_Application__c p=[select TCM__c,Owner.name,Destination_Region__c,Own_GM_Email__c,Own_Review_Email__c from Product_Application__c where id=:productAppid];
            p.Finance_approval__c='';
                p.Finance_approval_Feedback__c='';
                p.GM_approval__c='';
                p.GM_approval_Feedback__c='';
                p.TCM__c='';
            update p;
            List<user> u =new List<user>();
            u =[select id,name from User where email=:p.Own_GM_Email__c];
            List<user> us = new List<user>();
            us= [select id,name from User where email=:p.Own_Review_Email__c];
            if(p.Destination_Region__c=='North Asia'&&u.size()>0&&us.size()>0&&u[0].name!=us[0].name){
            SendEmailUtils2.sendToSomeOne(productAppid,us[0].name,'ProductAPP');
            }
            else if(u.size()>0){
            SendEmailUtils2.sendToSomeOne(productAppid,u[0].name,'ProductAPP');
            }
            if(p.Destination_Region__c=='EU(Union)' || p.Destination_Region__c=='EU(Non-Eu)'|| p.Destination_Region__c=='ROA'|| p.Destination_Region__c=='North America'|| p.Destination_Region__c=='North Asia'|| p.Destination_Region__c=='Central Asia'|| p.Destination_Region__c=='Key Account'){
                                                    SendEmailUtils2.sendToSomeOne(productAppid,'Technic(US EU ROA NA CA)','ProductAPPtoTH');
                                              }else if (p.Destination_Region__c=='Middle East&Africa'||p.Destination_Region__c == 'MENA'||p.Destination_Region__c == 'SSA'|| p.Destination_Region__c=='Latin America&Italy'|| p.Destination_Region__c=='South Asia'){
                                                   SendEmailUtils2.sendToSomeOne(productAppid,'Technic(MEA LATAM SA)','ProductAPPtoTH');
                                              }//售前
             SendEmailUtils2.sendToSomeOne(productAppid,'PM','ProductAPPtoTH');//PMC
           
     
            
        return  '1';
    }
    webservice static String Addproductstock(String productAppid){
        String usId =Label.Product_Application_Approval;
        User us=[select id,name from User where id=:usId];
            SendEmailUtils2.sendToSomeOne(productAppid,us.name,'ProductAPPstock');
     
            
        return  '1';
    }
        webservice static String Productfastprocess(String productAppid){
           List<Product_Application_Detail__c> paList = [Select id,name,Fast_process__c from Product_Application_Detail__c where Product_Application__c =: productAppid];
            String flag='0';
            for(Product_Application_Detail__c p:paList){
                if(p.Fast_process__c==true){
                    flag='1';
                                            }
else{
    flag='0';
}
              
            }
          return flag;
        }
}