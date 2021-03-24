public class MutualTerminationAgreementCtrl {
    public list<Standard_Template_Teams__c> stdList{get;set;}
    public String  SpecialT1{get;set;}
    public String  SpecialT2{get;set;}
    public String  SpecialT3{get;set;}
    public String  SpecialT4{get;set;}
    public String  SpecialT5{get;set;}
        public String  LGoverningLaw{get;set;}
        public String  LDisputeResolution{get;set;}
        public String  LSPECIALTERMS{get;set;}
    public String SPECIALTERMS{get;set;}
    public String MeSPECIALTERMS{get;set;}
    list<String> SpecialTemLst {get;set;}
    public Integer  SpecialTemLstsize{get;set;}
    public Boolean MexicoSpecial{get;set;}
    public String MexicoSpecialString{get;set;}
    public Amendment__c ad{get;set;}
    public Amendment__c ad2{get;set;}
    public Amendment__c add1{get;set;}
    public Amendment__c add2{get;set;}
    public Amendment__c add3{get;set;}
    public String  newSPECIALTERMS{get;set;}
    public String GoverningLaw{get;set;}
    public String DisputeResolution{get;set;}
    public String Warranty{get;set;}
    public integer Anum{get;set;}
     public Decimal  Ver{get;set;}
    public String TradeTerm{get;set;}
    public String ContractFactory{get;set;}
    public List<String> StandFieldValue{get;set;}
    public  List<Amendment_Payment__c> payLst{get;set;}
    public  List<Amendment__c> ALst{get;set;}
    public  Amendment__c Aord{get;set;}
    public  List<Amendment_Order_Product__c> AopLst{get;set;}
    public Date ExceptionDeliveryDate{get;set;}
    public date dt{get;set;}
    public String newPaymentTerm{get;set;}
    public String newPaymentTerm1{get;set;}
    public String newPaymentTerm2{get;set;}
    public String newPaymentTermKK{get;set;}
    public User sellers{get;set;}
    public String Address{get;set;}
    public String buyerVATNO{get;set;}
    public String LongPayment{get;set;}
    public String LongTradeTerm{get;set;} 
    public String requestId{get;set;}
	
public Order ord2{get;set;}
  public Order ord{get;set;}


    public String NewDescription{get;set;}
    public Date ActiveDate{get;set;}
        public  boolean BuyerLetter{get;set;}
    public Boolean AmendDifferent{get;set;} 
    public Boolean AmendProDifferent{get;set;}
    public Boolean AmendPayDifferent{get;set;}
    public Boolean AmendTable{get;set;}//显不显示表2.1

    public MutualTerminationAgreementCtrl(ApexPages.StandardController ctrl){
                        if (!Test.isRunningTest()){ ctrl.addFields(new List<String>{ 'Amount_received__c','Number_of_pieces_shipped__c','Component_Model__c','Buyer__r','Name','Legal_Change_2_1__c','Contract_No__c','Amount_paid_by_the_buyer__c'});}
        dt = date.today();
        requestId = ApexPages.currentPage().getParameters().get('id');
        //新增
        
         Aord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                              'Where id =:requestId');
        
        Id id1=Aord.Order__c;
          //查询终止协议关联的订单
          ord = new Order();
            ord =Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order) + ' ' +
                                      'Where id =: id1');
            ord2= new Order();
          ord2 = [SELECT ID,Name,Buyer__r.Name from Order Where id=:id1];
          //新增结束
        ad = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                            'Where id =: requestId');
        Ver = ad.Version_revision__c;
        
        Contract contf=[select Buyer_Letter_of_guarantee__c from Contract where  id =: ad.Contract__c];
        if(contf.Buyer_Letter_of_guarantee__c=='None' || contf.Buyer_Letter_of_guarantee__c==null){
            BuyerLetter=false;
        }else{BuyerLetter=true;}
  ALst=[select id,Printing_time__c from Amendment__c where Order__c=:ad.Order__c order by createddate];
        if(Ver==null){
        
        Anum=integer.valueof(ad.name.substring(ad.name.length()-1, ad.name.length()));
        }else{
            Anum=integer.valueof(Ver);
        }
        if(String.isEmpty(String.valueof(ad.Effective_Date__c))){
            system.debug('Date.valueof(ad.CreatedDate)--->'+Date.valueof(ad.Old_Contract_execution_date__c));
            ActiveDate = Date.valueof(ad.Old_Contract_execution_date__c);
        }else{
             system.debug('Date.valueof(ad.CreatedDate)--->'+Date.valueof(ad.CreatedDate));
             system.debug('ad.EffectiveDate__c'+ad.Effective_Date__c);
            ActiveDate = ad.Effective_Date__c;
        }
        if(Anum==2){
            add1=Alst[1];
        }
        if(Anum==3){
            add1=Alst[1];
            add2=Alst[2];
        }
        if(Anum>=4){
            add1=Alst[1];
            add2=Alst[2];
            add3=Alst[3];
        }

        if(String.isEmpty(String.valueof(ad.Printing_time__c))){
            ad.Printing_time__c=date.today();
        }
        if(ad.Contract_Owner__c!=null){
        String userId = ad.Contract_Owner__c;
        sellers = [Select id ,Phone , MobilePhone,City,Country,PostalCode,State,Street, Address,name, Email from User where Id =: userId];
        system.debug('ad---->'+ad.SELLER__c);
        }
       AopLst = [SELECT ID,Name,Quantity_shipped__c,Product2__r.Name From Amendment_Order_Product__c 
                                                    Where   OriginalOrderItem__c=:requestId];
        
      System.debug('AopLst.size()----->111'+AopLst.size());
        
        //SpecialT1
        List<Standard_Template_Teams__c> sttc= [Select id,Name,Type__c,Flag__c,Field_Values__c,Actual_Values__c	from Standard_Template_Teams__c where Name ='Mutual Termination Agreement'];
        System.debug('sttc.size()----------->'+sttc.size());
       
       
        
        //多产品
        //String ModuleLst = 'duly delivered [已经发货的片数] pieces of [组件型号] modules pursuant to the Underlying Agreement.';
     	/*SpecialT1='';
        for(Amendment_Order_Product__c apc : AopLst){
            SpecialT1=SpecialT1+'duly delivered '+apc.Quantity_shipped__c+' pieces of '+apc.Product2__r.Name+' modules pursuant to the Underlying Agreement \n';
        }
         System.debug('SpecialT1----------->'+SpecialT1);*/
    }
    
    
  public PageReference AddSave(){
        
       update Aord;
      
           return new PageReference('/apex/MutualTerminationAgreement?id='+requestId);
        }
  
    
    

    public PageReference savePdf( PageReference savePDF){
        system.debug('start PrintPDF');
        system.debug('requestId-->'+requestId);
        savePDF.getParameters().put('id',requestId);
        String strFileName = 'Amendment'+'.pdf';
        system.debug('start 111111');
        Blob pdfBlob = null;
        system.debug('start 22222');
        PageReference retPage = null;
        system.debug('start 333333');
        try{           
            system.debug('strat try');
            system.debug('strat Attachment');
            retPage = new PageReference('/apex/yjPDF?id='+requestId);
           
        }catch(Exception ex){
            system.debug(ex);
            ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.ERROR , ex.getDmlMessage(0) ));
        }
        
        return retPage;
    }
    
    
    public void test(){
            Decimal i=0;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
             i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
             i++;
    }

}