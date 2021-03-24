global class PrintPAEUCtrl {
    public String company {get;set;}
    public String format{get;set;}
    public String viewUrl{get;set;}
    public ID viewId{get;set;}
    public ID setId{get;set;}
    
    
    public PrintPAEUCtrl(ApexPages.StandardController sc){
        if(sc.getRecord()!=null){
            viewId=((Contract)sc.getRecord()).Id;
            //viewId = '8000w0000000r2G';
            setId =  ApexPages.currentPage().getParameters().get('q');
            system.debug('--------setId' +setId);
            system.debug('-------:viewId' + viewId);
            
        }
        viewUrl=null;
    }
      
    public List<SelectOption> getFormatItems(){
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Pdf','Pdf'));
            //options.add(new SelectOption('Excel','Excel')); 
        return options; 
    }
    
    
    
    public PageReference doBack(){
        PageReference qu=new PageReference('/'+viewId);
        return qu;
    }
    
    public PageReference doGenerate(){
          Contract con=[SELECT id, Name FROM Contract where id=:viewId][0];
        system.debug('111');
        if( format == 'Pdf'){
            PageReference savePDF = Page.ContractPDF;
                return savePdf(savePDF);
        }else if(format == 'Excel'){
            PageReference saveExcel = Page.ContractPDFEU;
                return saveExcel(saveExcel);
        }else{
            return null;
        }
        
        }
    
    
    private PageReference savePdf( PageReference savePDF){
        savePDF.getParameters().put('id',viewId);
        Contract con=[SELECT id,  Name  FROM Contract where id=:viewId][0];
        String strFileName = 'Contract'+'.pdf';
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
    private PageReference saveExcel( PageReference saveExcel){ 
        saveExcel.getParameters().put('id',viewId);
        saveExcel.getParameters().put('company',company);
        Contract con=[SELECT id,  Name  FROM Contract where id=:viewId][0];
        String strFileName = 'Contract'+'.xls';
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
    
}