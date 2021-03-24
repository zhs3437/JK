/*
 * 此类为业务机会的各个按钮调用的工具类
*/
global class PriceApprovalTools {
    Webservice static void main(String opid){
        if(opid !=null){
            //通过此子对象id查询到主对象
            Opportunity opp = [SELECT ID,Name,
                               Opportunity_Type__c,
                               Frame_Contract_opportunity__c,
                               Total_MW__c,
                               Rebate__c,
                               Rebate_Per_w__c,
                               Discount_new__c,
                               Discount_Per_W__c,
                               Discount__c,
                               Frame_Contract_opportunity__r.Total_MW_Framework_Text__c,
                               Frame_Contract_opportunity__r.MOU_Type_Judgment__c
                               From Opportunity
                               Where ID =: opid]; 
            opp.Rebate__c	=String.valueOf(opp.Rebate_Per_w__c);
            opp.Discount__c	=String.valueOf(opp.Discount_Per_W__c);
            System.debug( opp.Rebate__c+','+opp.Discount__c+','+opp.Rebate_Per_w__c+','+opp.Discount_Per_W__c);
            update opp;
            if(opp.Opportunity_Type__c == 'Under Frame' && opp.Frame_Contract_opportunity__c !=null && opp.Frame_Contract_opportunity__r.MOU_Type_Judgment__c==true){   
            //找到主对象所有子对象
            List<Opportunity>SonOppLst = [SELECT ID,Name,
                                          Frame_Contract_opportunity__c,
                                          Total_MW__c
                                          From Opportunity
                                          Where Frame_Contract_opportunity__c =: opp.Frame_Contract_opportunity__c                
                                         ];
            //找到主对象，为了赋值
            Opportunity MainOpp = [SELECT ID,Name,                                          	
                                   Total_MW_Framework_Text__c,
                                   PO_received_MW__c,
                                   rest_MW__c,
                                   Lock__c
                                   From Opportunity
                                   Where ID =: opp.Frame_Contract_opportunity__c                
                                  ];
            //计算所有子对象的瓦数作为主对象已收到的兆瓦数
            Decimal recivedMW = 0;
            if(SonOppLst.size()>0){
                for(Opportunity ops : SonOppLst){
                    recivedMW = recivedMW + ops.Total_MW__c;
                }  
            }
            //给主对象赋值
            MainOpp.Lock__c = false;            
            MainOpp.PO_received_MW__c = recivedMW;//已收到的
            MainOpp.rest_MW__c = MainOpp.Total_MW_Framework_Text__c - recivedMW;//未收到的
            Update MainOpp;
            MainOpp.Lock__c = true; 
            Update MainOpp;
            }
        }	
    }
    Webservice static void SetPODate(String opid){
        Opportunity opp = [SELECT ID,Name,
                               Signature_Date__c,
                               Lock__c,
                           	   Double_sign_completed__c,
                           	   StageName
                               From Opportunity
                               Where ID =: opid
                              ];
        if(opp.Lock__c == false){
            opp.Signature_Date__c = date.today();
            opp.Double_sign_completed__c = true;
            opp.StageName = 'Closed Won';
            update opp;
        }else if(opp.Lock__c == true){
            opp.Lock__c = false;
            opp.Signature_Date__c = date.today();
            opp.Double_sign_completed__c = true;
            opp.StageName = 'Closed Won';
            update opp;
            opp.Lock__c = true;
            update opp;
        }

    }
    
    @Future
    Webservice static void MouUpdate(String opid,String tradeterm){
        Opportunity MainOpp = [SELECT ID,Name,                                          	
                                   Total_MW_Framework_Text__c,
                                   PO_received_MW__c,
                                   rest_MW__c,
                                   Lock__c,
                               	   Trade_Term__c,
                               	   Payment_Term_Description__c
                                   From Opportunity
                                   Where ID =: opid                
                                  ];
        
       
        List<Payment__c> ppLst = [SELECT ID,Name,Opportunity__c,PaymentDescription__c,PaymentDescription_Japan__c from Payment__c where Opportunity__c=:opid];
        System.debug('ppLst----------->'+ppLst.size() );
        
        if(tradeterm == ''){
            if(MainOpp.Trade_Term__c !=null){
                
            
            MainOpp.Trade_Term__c = tradeterm;
            MainOpp.Payment_Term_Description__c ='';
            for(Payment__c p :ppLst){
                p.PaymentDescription__c = '';
                p.PaymentDescription_Japan__c = '';
            }
            update MainOpp; 
            update ppLst;
            }
        }else{
            if(MainOpp.Trade_Term__c != tradeterm){
                MainOpp.Trade_Term__c = tradeterm;
        	update MainOpp; 
            update ppLst;
            }
            
            
        }
        
    }
}