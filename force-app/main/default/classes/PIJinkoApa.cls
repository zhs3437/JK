public class PIJinkoApa {
    Public String viewid{get;set;}
	Public Amendment__c ade{get;set;}
    Public String TradeTerm{get;set;}
    Public String LongPaymentTerm{get;set;}
    Public Decimal fright{get;set;}
    Public Date tod{get;set;}
    Public Date dt{get;set;}
    Public String ContactEmail{get;set;}
    Public String ContactTel{get;set;}
    
    public PIJinkoApa(ApexPages.StandardController controller) {
        if (!Test.isRunningTest()){ controller.addFields(new List<String>{'Trade_term__c' });}
        viewId=((Amendment__c)controller.getRecord()).Id;
        ade = (Amendment__c)[select id,Contract__c,Opportunity__c,Payment_Term_Description__c,ChangeContractPerson__c,Contract_No__c,Contact_Person__c,Long_Trade_Term__c,Trade_term__c,Destination__c,Long_Payment_Term__c from Amendment__c where id =:viewId];
        system.debug('');
         if(ade.Long_Trade_Term__c != null){
            TradeTerm = ade.Long_Trade_Term__c;
        }else{
            TradeTerm = ade.Trade_term__c+' '+ade.Destination__c;
        }
        if(ade.Long_Payment_Term__c != null){
            LongPaymentTerm = ade.Long_Payment_Term__c;
        }else{
            LongPaymentTerm = ade.Payment_Term_Description__c;
        }
        system.debug('TradeTerm'+TradeTerm);
//计算运费
        List<opportunity> opp=[select id
                               ,Land_Freight_Oversea__c,
                               Land_Freight_China__c,
                               Ocean_Freight__c,
                               Ocean_Freight_Oversea__c,
                               Warehouse_Premium__c
                               from opportunity where id =:ade.Opportunity__c]; 
        system.debug('opp个数:'+opp.size());
        if(opp.size()>0){
            if(opp[0].Land_Freight_Oversea__c==null){
                opp[0].Land_Freight_Oversea__c=0;
            }
            if(opp[0].Warehouse_Premium__c==null){
                opp[0].Warehouse_Premium__c=0;
            }
            if(opp[0].Land_Freight_China__c==null){
               opp[0].Land_Freight_China__c=0;
            }
            if(opp[0].Ocean_Freight__c==null){
              opp[0].Ocean_Freight__c=0;
            }if(opp[0].Ocean_Freight_Oversea__c==null){
              opp[0].Ocean_Freight_Oversea__c=0;
            }
              if(opp[0].Land_Freight_Oversea__c!=null && opp[0].Land_Freight_China__c!=null
               && opp[0].Ocean_Freight__c!=null && opp[0].Warehouse_Premium__c!=null && opp[0].Ocean_Freight_Oversea__c!=null){
          fright  =opp[0].Land_Freight_Oversea__c+opp[0].Ocean_Freight__c+opp[0].Warehouse_Premium__c+opp[0].Ocean_Freight_Oversea__c;
            }
            system.debug('fright:'+fright);
            }


        //item 的条数
        // init - apex date
		tod = Date.today();
         dt = date.today();

if (ade.Contact_Person__c != null) {
              if(ade.ChangeContractPerson__c !=null){
                  
                String TotaContact =ade.ChangeContractPerson__c;
			    ContactEmail 	= TotaContact.split(';')[0];
	    		ContactTel 		= TotaContact.split(';')[1];
            }
          
		}
		
    }
    
    
    
	public PIJinkoApa(){
		
		
	}
	}