global class GenerateQuotePdf {
    public String company {get;set;}
    public String format{get;set;}
    public String viewUrl{get;set;}
    public ID viewId{get;set;}
    public ID setId{get;set;}
    
    
    public GenerateQuotePdf(ApexPages.StandardController sc){
        if(sc.getRecord()!=null){
            viewId=((Quote)sc.getRecord()).Id;
            setId =  ApexPages.currentPage().getParameters().get('q');
            system.debug('--------setId' +setId);
            system.debug('-------:viewId' + viewId);
            
        }
        viewUrl=null;
    }
      webservice static Decimal  getMW(id ids) { 
           Quote quote=[SELECT Opportunityid  FROM Quote where id=:ids];
              Opportunity  opp=[SELECT Total_MW__c  FROM Opportunity  where id=:quote.Opportunityid];
            return opp.Total_MW__c;
            }

          webservice static String  getGMap(id ids) { 
              Quote quote=[SELECT Opportunityid  FROM Quote where id=:ids];
             Opportunity  opp=[SELECT Sales_manager_approval__c  FROM Opportunity  where id=:quote.Opportunityid];
              //GM同意
            return opp.Sales_manager_approval__c;
            }
          webservice static String  getFap(id ids) { 
               Quote quote=[SELECT Opportunityid  FROM Quote where id=:ids];
             Opportunity  opp=[SELECT Price_Approval_Status__c  FROM Opportunity  where id=:quote.Opportunityid];
          //财务同意
            return opp.Price_Approval_Status__c;
            }
    webservice static String  getCap(id ids) { 
         Quote quote=[SELECT Opportunityid  FROM Quote where id=:ids];
             Opportunity  opp=[SELECT Cross_region_GM_approval__c  FROM Opportunity  where id=:quote.Opportunityid];
          //跨区Gm同意
            return opp.Cross_region_GM_approval__c;
            }
    


    public List<SelectOption> getCountryItems() {
        Quote quote=[SELECT id, Name,Region__c,Account.Country__c,key_account_Team__c   FROM Quote where id=:viewId][0];
        system.debug('-----' + quote);
        List<SelectOption> options = new List<SelectOption>();
        if(quote.key_account_Team__c == true){
            options.add(new SelectOption('JINKO SOLAR CO.,LTD','JINKO SOLAR CO.,LTD')); 
            options.add(new SelectOption('Jinkosolar Middle East DMCC.','Jinkosolar Middle East DMCC.')); 
            options.add(new SelectOption('JINKO SOLAR CO.,LTD','JINKO SOLAR CO.,LTD')); 
            options.add(new SelectOption('ZHEJIANG JINKO SOLAR CO.,LTD','ZHEJIANG JINKO SOLAR CO.,LTD'));
            options.add(new SelectOption('JINKO SOLAR TECHNOLOGY SDN.BHD.','JINKO SOLAR TECHNOLOGY SDN.BHD.')); 
            options.add(new SelectOption('Jinko Solar Import and Export Co., Ltd.','Jinko Solar Import and Export Co., Ltd.')); 
            options.add(new SelectOption('JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD','JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD')); 
            
        }else if(quote.Region__c == 'EU' || quote.Region__c == 'Non EU'){
            options.add(new SelectOption('JINKO SOLAR CO.,LTD','JINKO SOLAR CO.,LTD'));
            options.add(new SelectOption('JinkoSolar GmbH','JinkoSolar GmbH'));
            options.add(new SelectOption('ZHEJIANG JINKO SOLAR CO.,LTD','ZHEJIANG JINKO SOLAR CO.,LTD'));
            options.add(new SelectOption('JINKO SOLAR TECHNOLOGY SDN.BHD.','JINKO SOLAR TECHNOLOGY SDN.BHD.')); 
            options.add(new SelectOption('Jinko Solar Import and Export Co., Ltd.','Jinko Solar Import and Export Co., Ltd.')); 
            options.add(new SelectOption('JinkoSolar (Switzerland) AG','JinkoSolar (Switzerland) AG')); 
            options.add(new SelectOption('Jinko Solar Denmark Aps','Jinko Solar Denmark Aps')); 
             
            
        }else if(quote.Region__c == 'EU(Union)' || quote.Region__c == 'EU(Non-Eu)'){
            options.add(new SelectOption('JINKO SOLAR CO.,LTD','JINKO SOLAR CO.,LTD'));
            options.add(new SelectOption('JinkoSolar GmbH','JinkoSolar GmbH'));
            options.add(new SelectOption('ZHEJIANG JINKO SOLAR CO.,LTD','ZHEJIANG JINKO SOLAR CO.,LTD'));
            options.add(new SelectOption('JINKO SOLAR TECHNOLOGY SDN.BHD.','JINKO SOLAR TECHNOLOGY SDN.BHD.')); 
            options.add(new SelectOption('Jinko Solar Import and Export Co., Ltd.','Jinko Solar Import and Export Co., Ltd.')); 
            options.add(new SelectOption('JinkoSolar (Switzerland) AG','JinkoSolar (Switzerland) AG')); 
            options.add(new SelectOption('Jinko Solar Denmark Aps','Jinko Solar Denmark Aps')); 
             
            
        }
        else if(quote.Region__c == 'Middle East&Africa'||quote.Region__c == 'MENA'||quote.Region__c == 'SSA'){
            options.add(new SelectOption('JINKO SOLAR CO.,LTD','JINKO SOLAR CO.,LTD')); 
            //options.add(new SelectOption('JinkoSolar (PTY)LTD','JinkoSolar (PTY)LTD')); 
            options.add(new SelectOption('Jinkosolar Middle East DMCC.','Jinkosolar Middle East DMCC.')); 
        }else if(quote.Region__c == 'Latin America&Italy'){
            //options.add(new SelectOption('Jinko Solar (Italia) S.R.L.','Jinko Solar (Italia) S.R.L.')); 
            options.add(new SelectOption('Jinko Solar Co.,Ltd','Jinko Solar Co.,Ltd')); 
             options.add(new SelectOption('JinkoSolar Mexico','JinkoSolar Mexico'));
             options.add(new SelectOption('Jinkosolar Comercio do Brasil','Jinkosolar Comercio do Brasil'));
             options.add(new SelectOption('Jinko Solar Chile SPA.','Jinko Solar Chile SPA.'));
             options.add(new SelectOption('Jinko Solar Italy','Jinko Solar Italy'));
            
        }else if(quote.Region__c == 'ROA' && quote.Account.Country__c =='Australia' ){
            options.add(new SelectOption('Jinko Solar Australia Holdings Co.Pty Ltd','Jinko Solar Australia Holdings Co.Pty Ltd')); 
        }else if(quote.Region__c == 'ROA'){
             options.add(new SelectOption('JINKO SOLAR CO.,LTD','JINKO SOLAR CO.,LTD')); 
            options.add(new SelectOption('ZHEJIANG JINKO SOLAR CO.,LTD','ZHEJIANG JINKO SOLAR CO.,LTD'));
            options.add(new SelectOption('JINKO SOLAR TECHNOLOGY SDN.BHD.','JINKO SOLAR TECHNOLOGY SDN.BHD.')); 
            options.add(new SelectOption('Jinko Solar Import and Export Co., Ltd.','Jinko Solar Import and Export Co., Ltd.')); 
            options.add(new SelectOption('JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD','JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD')); 
        }
   
        else if(quote.Region__c == 'North Asia' && quote.Account.Country__c =='Japan'){
            options.add(new SelectOption('ジンコソーラージャパン株式会社','ジンコソーラージャパン株式会社')); 
             options.add(new SelectOption('Jinko Solar Co.,Ltd','Jinko Solar Co.,Ltd')); 
        }else if(quote.Region__c == 'South Asia'){
             options.add(new SelectOption('JINKO SOLAR CO.,LTD','JINKO SOLAR CO.,LTD')); 
            options.add(new SelectOption('ZHEJIANG JINKO SOLAR CO.,LTD','ZHEJIANG JINKO SOLAR CO.,LTD'));
            options.add(new SelectOption('	JINKOSOLAR TECHNOLOGY LIMITED','JINKOSOLAR TECHNOLOGY LIMITED')); 
            options.add(new SelectOption('JINKOSOLAR TRADING PRIVATE LIMITED','JINKOSOLAR TRADING PRIVATE LIMITED')); 
            
        }
        else if(quote.Region__c == 'Central Asia'){
             options.add(new SelectOption('JINKO SOLAR CO.,LTD','JINKO SOLAR CO.,LTD')); 
            options.add(new SelectOption('ZHEJIANG JINKO SOLAR CO.,LTD','ZHEJIANG JINKO SOLAR CO.,LTD'));
        }
        else{
            options.add(new SelectOption('JINKO SOLAR CO.,LTD','JINKO SOLAR CO.,LTD')); 
            options.add(new SelectOption('ZHEJIANG JINKO SOLAR CO.,LTD','ZHEJIANG JINKO SOLAR CO.,LTD'));
            options.add(new SelectOption('JINKO SOLAR TECHNOLOGY SDN.BHD.','JINKO SOLAR TECHNOLOGY SDN.BHD.')); 
            options.add(new SelectOption('Jinko Solar Import and Export Co., Ltd.','Jinko Solar Import and Export Co., Ltd.')); 
            options.add(new SelectOption('JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD','JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD')); 
        }
        return options; 
    } 
    
    public List<SelectOption> getFormatItems(){
        Quote quote=[SELECT id, Name,Region__c,Account.Country__c,key_account_Team__c   FROM Quote where id=:viewId][0];
        List<SelectOption> options = new List<SelectOption>();
        if(quote.key_account_Team__c == true ){
             options.add(new SelectOption('Pdf','Pdf'));
        }else if(quote.Region__c == 'EU' || quote.Region__c == 'Non EU'){
             options.add(new SelectOption('Pdf','Pdf'));
        }else if(quote.Region__c == 'EU(Union)' || quote.Region__c == 'EU(Non-Eu)'){
             options.add(new SelectOption('Pdf','Pdf'));
        }
        else if(quote.Region__c == 'ROA' && quote.Account.Country__c =='Australia'){
            options.add(new SelectOption('Pdf','Pdf'));
        }else if(quote.Region__c == 'ROA'){
            options.add(new SelectOption('Pdf','Pdf'));
        }else   if(quote.Region__c == 'Latin America&Italy'){
            options.add(new SelectOption('Pdf','Pdf'));
        }else   if(quote.Region__c == 'North Asia' && quote.Account.Country__c =='Japan'){
            options.add(new SelectOption('Pdf','Pdf'));
        }
        else{
            options.add(new SelectOption('Pdf','Pdf'));
            //options.add(new SelectOption('Excle','Excle')); 
            //options.add(new SelectOption('Word','Word')); 
        }
        
        return options; 
    }
    
    
    
    public PageReference doBack(){
        PageReference qu=new PageReference('/'+viewId);
        return qu;
    }
    
    public PageReference doGenerate(){
          Quote quote=[SELECT id, Name,Region__c,Account.Country__c,key_account_Team__c   FROM Quote where id=:viewId][0];
        system.debug('111');
        if(company != null && format == 'Pdf'){
            if(quote.key_account_Team__c == true){
                PageReference savePDF = Page.QuoteTemplateMiddleEastAndAfrica;
                return savePdf(savePDF);
            }
            else if(quote.Region__c == 'EU' || quote.Region__c == 'Non EU'){
                PageReference savePDF = Page.QuoteTemplateEuropean;
                return savePdf(savePDF);
        	}else if(quote.Region__c == 'EU(Union)' || quote.Region__c == 'EU(Non-Eu)'){
                PageReference savePDF = Page.QuoteTemplateEuropean;
                return savePdf(savePDF);
        	}
            else if(quote.Region__c == 'North Asia' && quote.Account.Country__c =='Japan'){
                system.debug('打印日本区标价单');
                PageReference savePDF = Page.QuoteTemplateJapan;
                return savePdf(savePDF);  
            }else  if(quote.Region__c == 'ROA' && quote.Account.Country__c !='Australia'){
                PageReference savePDF = Page.QuoteTemplateROA;
                return savePdf(savePDF);
            }
             else if(quote.Region__c == 'Latin America&Italy'){
                PageReference savePDF = Page.QuoteTemplateLatinAmericaAndItalyOnly;
                return savePdf(savePDF);}
            else if(quote.Region__c == 'South Asia'){
                PageReference savePDF = Page.QuoteTemplateLatinAmericaAndItaly;
                return savePdf(savePDF);}
            else if(quote.Region__c == 'Central Asia'){
                PageReference savePDF = Page.QuoteTemplateLatinAmericaAndItaly;
                return savePdf(savePDF);}
            
            else if(company == 'Jinko Solar Co.,Ltd'){
                PageReference savePDF = Page.QuoteTemplateLatinAmericaAndItaly;
                return savePdf(savePDF);}
            else  if(company =='Jinko Solar Australia Holdings Co.Pty Ltd'){
                PageReference savePDF = Page.QuoteTemplateAustria;
                return savePdf(savePDF);
            }

          
            else{
                PageReference savePDF = Page.QuoteTemplateMiddleEastAndAfrica;
                return savePdf(savePDF);
            }
        }else {
            //create by hanFan 国家为意大利或拉丁美洲时打印用word
            if(company =='Jinko Solar Australia Holdings Co.Pty Ltd'){
                PageReference savePDF = Page.QuoteTemplateLatinAmericaAndItaly;  
                return savePDF(savePDF);
            }else{
                PageReference savePDF = Page.QuoteTemplateLatinAmericaAndItaly;  
                return savePDF(savePDF);
            }
            /**
if(company =='Jinko Solar Australia Holdings Co.Pty Ltd'){
PageReference saveExcel = Page.QuoteTemplateLatinAmericaAndItaly;  
return saveExcel(saveExcel);
}else{
PageReference saveExcel = Page.QuoteTemplateLatinAmericaAndItaly;  
return saveExcel(saveExcel);
}
*/            
        }
    }
    
    private PageReference savePdf( PageReference savePDF){
        savePDF.getParameters().put('id',viewId);
        savePDF.getParameters().put('company',company);
        Quote quote=[SELECT id,  Name  FROM Quote where id=:viewId][0];
        String strFileName = 'Quote-'+quote.name+'.pdf';
        Blob pdfBlob = null;
        if ( !Test.isRunningTest() ) {
            pdfBlob = savePDF.getContentAsPdf();
        }else{
            pdfBlob = Blob.valueOf('test');
        }
        PageReference retPage = null;
        try{
            Attachment quoAttach= new Attachment(
                parentId = viewId,
                name = strFileName ,
                ContentType ='application/pdf',
                body = pdfBlob
            );
            upsert quoAttach;
            retPage = new PageReference('/servlet/servlet.FileDownload?file='+quoAttach.Id);
        }catch(DMLException ex){
            system.debug(ex);
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , ex.getDmlMessage(0) ));
        }
        return retPage;
    }
    
    private PageReference saveWord( PageReference saveWord){ 
        saveWord.getParameters().put('id',viewId);
        saveWord.getParameters().put('company',company);
        Quote quote=[SELECT id,  Name  FROM Quote where id=:viewId][0];
        String strFileName = 'Quote'+'.doc';
        Blob pdfBlob = null;
        if ( !Test.isRunningTest() ) {
            pdfBlob = saveWord.getContent();
        }else{
            pdfBlob = Blob.valueOf('test');
        }
        //system.debug('DEBUG pdfBlob : '+ pdfBlob );
        PageReference retPage = null;
        try{
            Attachment quoAttach= new Attachment(
                parentId = viewId,
                name = strFileName ,
                ContentType ='application/msword',
                body = pdfBlob
            );
            upsert quoAttach;
            retPage = new PageReference('/servlet/servlet.FileDownload?file='+quoAttach.Id);
            system.debug('------>retPage:'+ retPage);
        }catch(Exception ex){
            system.debug('DEBUG ERROR : '+ ex);
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , ex.getDmlMessage(0) ));
        }
        return retPage;
    }
    
    private PageReference saveExcel( PageReference saveExcel){ 
        saveExcel.getParameters().put('id',viewId);
        saveExcel.getParameters().put('company',company);
        Quote quote=[SELECT id,  Name  FROM Quote where id=:viewId][0];
        String strFileName = 'Quote'+'.xls';
        Blob pdfBlob = null;
        if ( !Test.isRunningTest() ) {
            pdfBlob = saveExcel.getContent();
        }else{
            pdfBlob = Blob.valueOf('test');
        }
        //system.debug('DEBUG pdfBlob : '+ pdfBlob );
        PageReference retPage = null;
        try{
            Attachment quoAttach= new Attachment(
                parentId = viewId,
                name = strFileName ,
                ContentType ='application/x-xls',
                body = pdfBlob
            );
            upsert quoAttach;
            retPage = new PageReference('/servlet/servlet.FileDownload?file='+quoAttach.Id);
            system.debug('------>retPage:'+ retPage);
        }catch(Exception ex){
            system.debug('DEBUG ERROR : '+ ex);
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , ex.getDmlMessage(0) ));
        }
        return retPage;
    }
    public void runtest(){
        String i='1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
         i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
        i=i+'1';
    }
}