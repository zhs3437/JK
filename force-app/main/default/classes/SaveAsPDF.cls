global without sharing class SaveAsPDF {
    
    //start
    /*
*add by jason 20160520 
*
**/
    
    private static string saveWord( PageReference saveWord,string saId,string fileName){
        string attFileUrl = '';
        saveWord.getParameters().put('id',saId);
        Blob WordBlob = null;
        if ( !Test.isRunningTest() ) {
            WordBlob = saveWord.getContent();
        }else{
            WordBlob = Blob.valueOf('test');
        } 
        try{
            Attachment quoAttach= new Attachment(
                parentId = saId,
                name = fileName ,
                ContentType ='application/msWord',
                body = WordBlob
            );
            upsert quoAttach;
            attFileUrl=URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+quoAttach.Id;
        }catch(DMLException ex){
            system.debug(ex);
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , ex.getDmlMessage(0) ));
        }
        return attFileUrl;
    }
    
    
    webservice static  string doCreateSAGlobal(string saId){
        PageReference saveWord = Page.OrderTemplateSAGlobal;
        return saveWord(saveWord,saId,'SA.doc');
    }
    
    webservice static  string doCreateSAEn(string saId){
        PageReference saveWord = Page.AmendmentPurchaseAgreementENPage;
        return saveWord(saveWord,saId,'SA.doc');
    }
    
    webservice static  string doCreateSAJapan(string saId){
        PageReference saveWord = Page.AmendmentPurchaseAgreementJPPage;
        return saveWord(saveWord,saId,'SA.doc');
    }
    /***********************
* 
*/
    
    webservice static  string doCreateComponentTaskBook(string ordId){
        PageReference savePDF = Page.ComponentTaskBookTemplate;
        return savePdf(savePDF,ordId,'CreateComponentTaskBook.pdf');
    }
@AuraEnabled
    webservice static  string doCreateComponentTaskBookChina(string ordId){
        PageReference savePDF = Page.RC_ComponentTaskBookTemplate2;
        return savePdf(savePDF,ordId,'Component Task Book.pdf');
    }
    
    //end
    webservice static  string doCreatePA1MW(string conId){
        PageReference savePDF = Page.ContractTemplate1MWGlobal;
        return savePdf(savePDF,conId,'PA.pdf');
    }
    webservice static  string doCreatePA1MWJapan(string conId){
        PageReference savePDF = Page.ContractTemplate1MWJapan;
        return savePdf(savePDF,conId,'PA_Japan.pdf');
    }
    
    webservice static  string doCreatePI1MW(string conId){
        PageReference savePDF = Page.Print_PI_1MW;
        return savePdf(savePDF,conId,'PI.pdf');
    }
    webservice static  string doCreatePI1MWAfrica(string conId){
        PageReference savePDF = Page.Print_PI_1MW_Africa;
        return savePdf(savePDF,conId,'PI.pdf');
    }
    webservice static  string doCreatePI1MWJapan(string conId){
        PageReference savePDF = Page.Pint_PI_1MW_Japan;
        return savePdf(savePDF,conId,'PI_Japan.pdf');
    }
    webservice static  string doCreateROAQuote(string oppid){
        PageReference savePDF = Page.ROAQuote;
        return savePdf(savePDF,oppid,'ROAQuote.pdf');
    }
       webservice static  string IsROABMO(string oppid){
         
           Opportunity opp =[select Owner.email,Owner.Region__c from Opportunity where id=:oppid];
           List<User> u=[select Region__c,Profile.name from User where email=:userinfo.getUserEmail()];
           system.debug('sysid'+UserInfo.getProfileId());
           if (u[0].Region__c=='ROA' || UserInfo.getProfileId()=='00e90000000sjacAAA'){
               return '1';
           }else{
           return '0';
           }
           }
    webservice static  string ROAQuoteNotNull(string oppid){
        Opportunity opp =[select Quotation_number__c,Seller_Contact_Email__c,Buyer_Authorized_by__c,Seller_Contact_Name__c,Expiry_date__c,Delivery_Period__c,
                          Contact_name__c,Contact_Email__c from Opportunity where id=:oppid];
        if(opp.Quotation_number__c == null || opp.Expiry_date__c == null ||opp.Delivery_Period__c == null  ||opp.Contact_name__c == null ||opp.Buyer_Authorized_by__c == null||opp.Contact_Email__c == null||opp.Seller_Contact_Name__c==null||opp.Seller_Contact_Email__c==null){
               String errnull='';
               if(opp.Quotation_number__c == null){
                   errnull=errnull+'\r Quotation number ';
                   }
               if(opp.Expiry_date__c == null){
                   errnull=errnull+'\r Expiry date ';
                   }
               if(opp.Delivery_Period__c == null){
                   errnull=errnull+'\r Delivery Period  ';
                   }
              
               if(opp.Contact_name__c == null ||opp.Seller_Contact_Name__c==null){
                   errnull=errnull+'\r Contact name ';
                   }
               if(opp.Contact_Email__c == null ||opp.Seller_Contact_Email__c==null){
                   errnull=errnull+'\r Contact Email ';
                   }
               if(opp.Buyer_Authorized_by__c == null){
                   errnull=errnull+'\r Authorized by ';
                   }
               return errnull;
           }else{
               return '1';
           }
    }
    
    private static string savePdf( PageReference savePDF,string conId,string fileName){
        system.debug('/*****************->savePdf()<-****************/');
        string attFileUrl = '';
        savePDF.getParameters().put('id',conId);
        Blob pdfBlob = null;
        if ( !Test.isRunningTest() ) {
            pdfBlob = savePDF.getContentAsPdf();
        }else{
            pdfBlob = Blob.valueOf('test');
        } 
        //  try{
        Attachment quoAttach= new Attachment(
            
            parentId = conId,
            name = fileName , 
            ContentType ='application/pdf',
            body = pdfBlob
        );
        system.debug('quoAttach-->'+quoAttach);
        insert quoAttach;
        attFileUrl=URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+quoAttach.Id;
        // }catch(DMLException ex){ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , ex.getDmlMessage(0) )); }
        return attFileUrl;
    }
}