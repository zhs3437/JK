/*
 * create by： Jason
 * create date : 20160420
 * Description: 当业务机会中 Payment 信息更改时 本业务机会对应的 Payment_Term_Description__c 信息随之改变
 */

trigger PaymentDescription on Payment__c (after insert, after update,before insert, before update,  after delete,before delete) {

    //if(checkRecursive.runOnce9()){
        
    
    //重置MOUOpportunity审批
//    new TriggerManager()
//            .bind(TriggerManager.Event.BEFORE_UPDATE, new MOUPaymentResetApprovalHandler())
//            .bind(TriggerManager.Event.BEFORE_INSERT, new MOUPaymentResetApprovalHandler())
//            .manage();
    //重置MOUOpportunity审批
    Set<Id> MOUOppIdSet = new Set<Id>();
    Map<Id, Payment__c> oldPaymentMap = Trigger.oldMap;
    Map<Id, Payment__c> newPaymentMap = Trigger.newMap;

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            for(Payment__c payment:Trigger.new){
                MOUOppIdSet.add(payment.Opportunity__c);
            }
        }
        if(Trigger.isUpdate){
            for (Id newPaymentId : newPaymentMap.keySet()) {
                Payment__c newPayment = newPaymentMap.get(newPaymentId);

                //if (oldLineItemMap != null) {
                Payment__c oldPayment = oldPaymentMap.get(newPayment.Id);
                if (oldPayment != null ) {
                    if ((newPayment.Percentage__c != oldPayment.Percentage__c ||
                                    newPayment.Amount__c != oldPayment.Amount__c ||
                                    newPayment.Down_Balance_Payment__c != oldPayment.Down_Balance_Payment__c ||
                                    newPayment.Payment_Method__c != oldPayment.Payment_Method__c ||
                                    newPayment.Days__c != oldPayment.Days__c ||
                                    newPayment.Payment_Term__c != oldPayment.Payment_Term__c ||
                                    newPayment.Credit_Valid__c != oldPayment.Credit_Valid__c ||
                                    newPayment.Precise_Day__c != oldPayment.Precise_Day__c ||
                                    newPayment.PaymentDescription__c != oldPayment.PaymentDescription__c) && newPayment.check_mou__c !=true) {
                        MOUOppIdSet.add(newPayment.Opportunity__c);
                    }
                }
            }
        }
        if(Trigger.isDelete){
            for(Payment__c payment:Trigger.old){
                System.debug('PaymentDescription---------------------------------->payment ====='+payment);
                MOUOppIdSet.add(payment.Opportunity__c);
            }
        }
        if(trigger.isUpdate){
        List<Opportunity> opportunityList = [
                SELECT Id,
                        SOC_Dept__c,
                        Finance_Approval_Status__c,
                        GM_approval_Status__c,
                        Legal_Dept__c,
                        Technical_Dept_Status__c,
                        Technical_Dept_Comments__c,
                        SOC_Dept_Comments__c,
                        Finance_Dept_Comments__c,
                        GM_approval_Comments__c,
                        Legal_Dept_Comments__c,
                        Roll_up_SFA_Counts__c
                FROM Opportunity
                WHERE Id IN :MOUOppIdSet
                AND MOU_Type_Judgment__c = true
        ];
        //审批初始化
        if (opportunityList.size() != 0) {
            for (Opportunity newOpp : opportunityList) {
                if (newOpp.Roll_up_SFA_Counts__c == 0) {
                    newOpp.SOC_Dept__c = '';
                    newOpp.Finance_Approval_Status__c = '';
                    newOpp.GM_approval_Status__c = '';
                    newOpp.Legal_Dept__c = '';
                    newOpp.Technical_Dept_Status__c = '';
                    newOpp.Technical_Dept_Comments__c = '';
                    newOpp.SOC_Dept_Comments__c = '';
                    newOpp.Finance_Dept_Comments__c = '';
                    newOpp.GM_approval_Comments__c = '';
                    newOpp.Legal_Dept_Comments__c = '';
                }
            }
            update opportunityList;
        }
                     
        }
    }

    system.debug('~~~~~~~~~~~~~~~~~~~>paymentTrigger');
    Set<string> oppIds = new Set<string>();
    Set<string> conIds = new Set<string>();
    Set<string> ordIds = new Set<string>();
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            
            if(checkRecursive.runOnce2()){
               /* Opportunity opp = new Opportunity();
                for(Payment__c pay: Trigger.new){
                    system.debug('pay.MOU_Type_Judgment__c ----->'+pay.MOU_Type_Judgment__c );
                system.debug('----->kaishi '+pay.All_Trade_Term__c);
                if(pay.Opportunity__c !=null){
                    opp = [SELECT id,MOU_Type_Judgment__c from Opportunity where id =:pay.Opportunity__c];
                    System.debug('opp.MOU_Type_Judgment__c @@@@@@@@@@@@@@@@@@'+opp.MOU_Type_Judgment__c);
                }
                }*/
                
            for(Payment__c pay: Trigger.new){
                // neo
                if((pay.MOU_Type_Judgment__c == false && pay.IsChina__c == false) ||
                   (pay.Opp_Trade_Term__c !=null &&                   
                    pay.Down_Balance_Payment__c != '' &&
                    pay.Payment_Method__c != '' &&
                    pay.Days__c != null &&
                    pay.Payment_Term__c != '' &&
                   	pay.Percentage__c !=0
                   )){
                  system.debug('pay.MOU_Type_Judgment__c ----->'+pay.MOU_Type_Judgment__c );  
                
                system.debug('----->kaishi '+pay.All_Trade_Term__c);
               
                
                // 2019.9.2 天数限制判断
                /*
                                IF(Pay.Payment_Method__c.contains('T/T')&& Pay.japan__c==true ){
                    if(Pay.Down_Balance_Payment__c=='Balance Payment'){
                            if(Pay.Payment_Term__c=='x% OA X days by TT from the EOM'
                               && Pay.Days__c!=30 &&  Pay.Days__c!=60){
                                   Pay.addError( '日本 x% OA X days by TT from the EOM 只可以30天 或者60天');
                                   return;
                               }
                        
                    }
                }
                */
                
                if(pay.All_Trade_Term__c!=''){
                    system.debug('----->kaishi ');
                    string payment_descritpion = '';
                    List<Standard_Template_Teams__c>  stdList = [select id,
                                                                 Name,
                                                                 Field_Values__c,
                                                                 Actual_Values__c,
                                                                 Type__c,
                                                                 Flag__c,
                                                                 Actual_Values_Japan__c
                                                                 from Standard_Template_Teams__c 
                                                                 limit 4000];
                    String flag='0';
                    List<String> StandFieldValue= new List<String>();
                    
                    for(Standard_Template_Teams__c stt: stdList){
                        
                        if(stt.Type__c == 'Contain'){  
                            if(stt.Name=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
                                StandFieldValue = stt.Field_Values__c.split(':');                      
                                system.debug('信息汇总:---->'+StandFieldValue[0]+'=='+StandFieldValue[1]+'=='+StandFieldValue[2]+'=='+StandFieldValue[3]);
                                
                                                                
                                if(StandFieldValue[0].indexof(pay.All_Trade_Term__c)>-1 && StandFieldValue[1].indexof(pay.Down_Balance_Payment__c)>-1 &&
                                   StandFieldValue[2].indexof(pay.Payment_Method__c)>-1 && StandFieldValue[3].indexof(pay.Payment_Term__c)>-1){
                                       //增加越南逻辑
									  if(pay.VietNam__c){
                                          if(stt.Field_Values__c =='EXW:Balance Payment:T/T (Balance):X% OA X days by TT from the BL/Delivery Date secured by Buyer Bank Guarantee'){
                                              
                                             payment_descritpion ='Buyer shall pay '+pay.Percentage__c+'% of total Price of the Goods by TT no later than '+pay.Days__c+' days after the earlier of (a) the related Delivery Date of such Goods and (b)' +
                                                 'the date on which Buyer picks up such Goods from the Delivery Point.'+
                                                 'Buyer shall deliver the Buyer Bank Guarantee no later than 7 days prior to the Delivery Date of the related Goods.'; 
                                               }else{
                                                   payment_descritpion =payment_descritpion+'\n'+stt.Actual_Values__c.replace('[填入百分比]',string.valueof(pay.Percentage__c));
                                    			   payment_descritpion = payment_descritpion.replace('[填入天数]',string.valueof(pay.Days__c));
                                               }
                                    
                                      }
                                       else  if(pay.Pakistan__c){
                                          if(stt.Field_Values__c =='FOB,CIF,CIP,CFR,CPT:Balance Payment:L/C:x% OA by LC at sight'){
                                              
                                             payment_descritpion = 'Buyer shall pay '+pay.Percentage__c+'% of total Price of the Goods by a Qualified L/C at sight of the bill of lading for the related Goods. Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                               }
                                           
                                           else if(	stt.Field_Values__c =='DAP,CFR,FOB,CIF,CIP,CPT:Balance Payment:L/C:x% OA by LC X days'){
                                             payment_descritpion = 'Buyer shall pay '+pay.Percentage__c+'% of total Price of the Goods by a Qualified L/C no later than '+pay.Days__c+' days after the bill of lading date of the related Goods.'
                                                 +'Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                           }
                                           else{
                                                   payment_descritpion =payment_descritpion+'\n'+stt.Actual_Values__c.replace('[填入百分比]',string.valueof(pay.Percentage__c));
                                    			   payment_descritpion = payment_descritpion.replace('[填入天数]',string.valueof(pay.Days__c));
                                               }
                                    
                                      }
                                       //原逻辑
                                       else{                                        
                                    payment_descritpion =payment_descritpion+'\n'+stt.Actual_Values__c.replace('[填入百分比]',string.valueof(pay.Percentage__c));
                                    payment_descritpion = payment_descritpion.replace('[填入天数]',string.valueof(pay.Days__c));
                                    
                                    }
                                  flag='1';     
                                }
                            }
                            
                        }
                    }
                    if(flag=='0' && !pay.IsChina__c){
                        String miss2='[填入比例] % [类型] [填入天数] days by [填入方法]\n';
                        system.debug('--->'+string.valueof(pay.Percentage__c));
                          if(pay.Payment_Term__c.indexof('DP')>-1 || pay.Payment_Term__c.indexof('D/P')>-1){
                                                             miss2=miss2.replace('[类型]',string.valueof('DP'));
                                                         }
                                                         else  if(pay.Payment_Term__c.indexof('OA')>-1){
                                                             miss2=miss2.replace('[类型]',string.valueof('OA'));
                                                         }
                        miss2=miss2.replace('[填入比例]',string.valueof(pay.Percentage__c));
                        if(pay.Days__c!=null){
                        miss2=miss2.replace('[填入天数]',string.valueof(pay.Days__c));
                        }else {
                           miss2=miss2.replace('[填入天数]','NK'); 
                        }
                        miss2=miss2.replace('[填入方法]',string.valueof(pay.Payment_Method__c));
                        system.debug('--->'+miss2);
                        payment_descritpion = payment_descritpion + miss2;
                        system.debug('--->'+payment_descritpion);
                    }
             
                    pay.PaymentDescription__c=payment_descritpion;
                    system.debug('----->kaishi '+payment_descritpion);
                    
                    
                    //插入越南情况
                  /* for(Standard_Template_Teams__c stt: stdList){
                    if(stt.Type__c == 'Contain'){
                        if(stt.Name=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
                           StandFieldValue = stt.Field_Values__c.split(':');
                           system.debug('信息汇总:---->'+StandFieldValue[0]+'=='+StandFieldValue[1]+'=='+StandFieldValue[2]+'=='+StandFieldValue[3]); 
                             if(StandFieldValue[0].indexof(pay.All_Trade_Term__c)>-1 && StandFieldValue[1].indexof(pay.Down_Balance_Payment__c)>-1 && 
                                StandFieldValue[2].indexof(pay.Payment_Method__c)>-1 && StandFieldValue[3].indexof(pay.Payment_Term__c)>-1){
                                    if(pay.VietNam__c){
                                        
                                    }
                            
                            
                                }                            
                        } 
                    }
                    }*/
                    
                    
                    //插入日本情况
                    if(pay.Japan__c==true ){
                        payment_descritpion='';
                        string payment_descritpionJP='';
                         for(Standard_Template_Teams__c stt: stdList){
                        
                        if(stt.Type__c == 'Contain'){  
                            if(stt.Name=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
                                StandFieldValue = stt.Field_Values__c.split(':');
                                system.debug('信息汇总:---->'+StandFieldValue[0]+'=='+StandFieldValue[1]+'=='+StandFieldValue[2]+'=='+StandFieldValue[2]);
                                if(StandFieldValue[0].indexof(pay.All_Trade_Term__c)>-1 && StandFieldValue[1].indexof(pay.Down_Balance_Payment__c)>-1 && StandFieldValue[2].indexof(pay.Payment_Method__c)>-1 && StandFieldValue[3].indexof(pay.Payment_Term__c)>-1){
                             if(stt.Actual_Values_Japan__c!=null){
                                    payment_descritpion =payment_descritpion+'\n'+stt.Actual_Values__c.replace('[填入百分比]',string.valueof(pay.Percentage__c));
                                    payment_descritpion = payment_descritpion.replace('[填入天数]',string.valueof(pay.Days__c));
                                    
                                    payment_descritpionJP = payment_descritpionJP+'\n'+stt.Actual_Values_Japan__c.replace('[填入百分比]',string.valueof(pay.Percentage__c));
                                    payment_descritpionJP = payment_descritpionJP.replace('[填入天数]',string.valueof(pay.Days__c));
                                   }
                                }
                            }
                            
                        }
                    }
                           if(Pay.Down_Balance_Payment__c=='Balance Payment'){
                            if(Pay.Payment_Term__c=='x% OA X days by TT from the EOM'
                              ){
                                  if( Pay.Days__c==30){
                                payment_descritpionJP='各ロットの製品の対価全額は、 納入当月の翌月末日までに、 T/T方式にて支払うものとする';
                                  } else if(Pay.Days__c==60){
                                      payment_descritpionJP='各ロットの製品の対価全額は、 納入当月の翌翌月末日までに、 T/T方式にて支払うものとする。';
  
                                  }
                                  else{payment_descritpionJP='';}
                              }
                    }
                                   
                    pay.PaymentDescription_Japan__c=payment_descritpionJP;
                    system.debug('----->kaishi '+payment_descritpion);
                    }
                    
                    
                    }

                }
            }
        }
        }
    }
        if(Trigger.isAfter){
            List<Trade_term_and_payment_term__c> ttpts = [select Trade_Term__c, 
                                                          Payment_term__c,
                                                          Delivery_Point__c,
                                                          Guaranteed_Delivery_Date__c,
                                                          Payment_description__c
                                                          from Trade_term_and_payment_term__c];
            if(Trigger.isInsert || Trigger.isUpdate){
                   if(checkRecursive.runOnce3()){
                system.debug('atfer1');
                for(Payment__c pay : Trigger.new){
                    if(string.isNotEmpty(pay.Opportunity__c) && !oppIds.contains(pay.Opportunity__c)){
                        oppIds.add(pay.Opportunity__c);
                         system.debug('atfer2');
                    } 
                    if(string.isNotEmpty(pay.Contract__c) && !conIds.contains(pay.Contract__c)){
                        conIds.add(pay.Contract__c);
                    }
                    if(string.isNotEmpty(pay.Order__c) && !ordIds.contains(pay.Order__c)){
                        ordIds.add(pay.Order__c);
                    } 
                    
                    
                }
                
                
                
                map<id,Opportunity> oppMap = new map<id,Opportunity> ([Select ID,Name,
                                                                       RecordType.name,
                                                                       Payment_Term_Description__c,
                                                                       Region__c,
                                                                       Destination_Country__c,
                                                                       Trade_Term__c,
                                                                       Cross_Region__c,
                                                                       Local_Warehouse__c,
                                                                       Special_Terms__c,
                                                                       Total_MW__c 
                                                                       From Opportunity
                                                                       where id in : oppIds]) ;
                map<id,Contract> conMap = new map<id,Contract> ([Select ID,Name,Payment_Term_Description__c,
                                                                 Trade_term__c, RecordType.name   
                                                                 From Contract
                                                                 where id in : conIds]) ;
                map<id,Order> ordMap = new map<id,Order>([SELECT ID,Name,Payment_Term_Description__c,Trade_term__c
                                                          FROM Order
                                                          WHERE id in: ordIds]);
                
                set<id> updateOppIds = new set<id> ();
                set<id> updateConIds = new set<id> ();
                set<id> updateOrdIds = new set<id> ();
                
                list<Opportunity> updateOppList = new list<Opportunity>();
                list<Contract> updateConList = new list<Contract>();
                list<Order> updateOrdList = new list<Order>();
                
                for(Payment__c pay: Trigger.new){
                    string payment_descritpion = '';
                    // update contract payment description
                    /*
if(conMap.containsKey(pay.Contract__c)){
Contract con = conMap.get(pay.Contract__c); 
list<Payment__c> relatePayments = [Select Down_Balance_Payment__c, 
Payment_Term__c, 
Payment_Method__c,  
Name, Id,  
Days__c, 
CurrencyIsoCode,  
Precise_Day__c,
Opp_Trade_Term__c,
Opportunity__c, 
Percentage__c,
Amount__c
From Payment__c 
Where Contract__c =: con.id];
//if...else... by sam 20170920

if(con.RecordType.name == 'USA Contract'){
payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments);

}else{
payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments, con.Trade_term__c, false);

}

//payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments, con.Trade_term__c, false);		       	 	

if(!string.isNotEmpty(payment_descritpion )){
payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments);
con.Payment_Reivew_Approval__c = PaymentHelper.retrivePaymentReview(relatePayments);

system.debug('~~~~~~~~~~~~~~~>con.Payment_Reivew_Approval__c:'+ con.Payment_Reivew_Approval__c);

}
if(string.isNotEmpty(payment_descritpion) && !updateConIds.contains(con.id)){
con.Payment_Term_Description__c = payment_descritpion;
updateConList.add(con);
updateConIds.add(con.id);
}

}
*/
                    // update opportunity payment description
                    if(oppMap.containsKey(pay.Opportunity__c)){
                         system.debug('atfer3');
                        Opportunity opp = oppMap.get(pay.Opportunity__c);
                        list<Payment__c> relatePayments = [Select Down_Balance_Payment__c, 
                                                           Payment_Term__c, 
                                                           Payment_Method__c,  
                                                           Name, Id,  
                                                           Days__c, 
                                                           Japan__c,
                                                           type__c,
                                                           Comments_Japan__c,
                                                           All_Trade_Term__c,
                                                           CurrencyIsoCode,  
                                                           Precise_Day__c,
                                                           Opp_Trade_Term__c,
                                                           Opportunity__c, 
                                                           Percentage__c,
                                                           Amount__c,
                                                           Comments_English__c,
                                                           VietNam__c,
                                                           Pakistan__c,
                                                           MOU_Type_Judgment__c
                                                           From Payment__c 
                                                           Where Opportunity__c =: opp.id];
                        Opportunity  opp2 = [SELECT ID,AccountId,
                                 StageName,
                                 RecordType.Name,
                                 Payment_1MW_Approve__c,
                                 Total_MW__c,
                                 Trade_Term__c,
                                 Total_Quantity__c,
                                 Payment_Term_Description__c,
                                 whether_pick_up_batch__c,
                                 Price_Approval_Status__c,
                                 Sales_manager_approval__c,
                                 Customer_Type__c,
                                 Allow_new_process_for_Japan_picklist__c,
                                 Seller__c,
                                 Special_Terms__c,
                                 Region__c,
                                 Price_Approval_Trigger_Time__c,
                                 Contract__c,
                                 Contract_No__c,
                                 Account.credit_good__c,
                                 Owner.Name,
                                 MOU_Type_Judgment__c
                                 FROM Opportunity 
                                 WHERE id =:opp.id];
                        
                        if(opp.RecordType.name != 'Japan'  && opp.RecordType.name != 'USA' ){
                            if((opp.Region__c!='Middle East&Africa' &&opp.Region__c != 'MENA'&&opp.Region__c != 'SSA'&& opp.Region__c!='ROA'&& opp.Total_MW__c <= 1.0)||(opp.Region__c=='Middle East&Africa' && opp.Total_MW__c <= 5.0)||(opp.Region__c=='ROA' && opp.Total_MW__c <= 5.0)){
                            payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments, opp.Trade_Term__c, false);
                            //payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments, pay.Opp_Trade_Term__c, false,ttpts);
                            if(string.isNotEmpty(payment_descritpion) && !updateOppIds.contains(opp.id)){
                                opp.Payment_Term_Description__c = payment_descritpion;
                                /*
if(relatePayments[0].Down_Balance_Payment__c == 'Down Payment' && opp.Trade_Term__c == 'EXW'){
opp.Sales_Print_PAPI_Confirm_Log__c = 'sales confirmed payment description';
}else{
opp.Sales_Print_PAPI_Confirm_Log__c = 'sales didn' + '\''+ 't confirm payment description.';
}
*/
                                opp.Payment_Reivew_Approval__c  = '';
                              
                                if(opp.Destination_Country__c=='VietNam' && opp.Local_Warehouse__c=='Vietnam Warehouse' && (opp.Trade_Term__c == 'DDP' || opp.Trade_Term__c == 'EXW') && opp.Cross_Region__c==false){
                                opp.vn_fast__c=true;
                                 }
                                else{
                                    opp.vn_fast__c=false;
                                    
                                }

                                for(Payment__c p:relatePayments){ 
                                                                        if(opp.Region__c=='ROA' && opp.Trade_Term__c != 'CIF' && opp.Trade_Term__c != 'EXW' && opp.Trade_Term__c != 'FOB' && opp.Trade_Term__c != 'DAP' && opp.Trade_Term__c != 'DDP' && opp.Trade_Term__c != 'CFR'&& opp.Trade_Term__c != 'CPT')
                                    {opp.Payment_1MW_Approve__c = false;
                                     break;}   
                                    if(p.Down_Balance_Payment__c=='Balance Payment'){
                                        if(p.Payment_Method__c=='T/T' || p.Payment_Method__c=='T/T (Balance)'||opp.Cross_Region__c==true){
                                            SYSTEM.DEBUG('0');
                                            opp.Payment_1MW_Approve__c = false;
                                            break;
                                        }else if(p.Payment_Method__c=='L/C' && (opp.Trade_Term__c=='FOB' || opp.Trade_Term__c=='CIF'|| opp.Trade_Term__c=='CIP'||opp.Trade_Term__c=='CPT'||opp.Trade_Term__c=='DAP' || opp.Trade_Term__c=='CFR')){
                                            opp.Payment_1MW_Approve__c = true;
                                            SYSTEM.DEBUG('1');
                                        }else{
                                            SYSTEM.DEBUG('2');
                                            opp.Payment_1MW_Approve__c = false;
                                            break;
                                        }
                                    }
                                    if(p.Payment_Term__c=='x% OA by LC X days'){
                                        if(p.Days__c>90||opp.Cross_Region__c==true){
                                            SYSTEM.DEBUG('4');
                                            opp.Payment_1MW_Approve__c = false;
                                            break;
                                        }else{
                                            opp.Payment_1MW_Approve__c = true;
                                        }
                                    }
                                    if(p.Payment_Term__c=='x% DP X days before the BL/Delivery Date'){
                                        if(p.Days__c<15||opp.Cross_Region__c==true){
                                            SYSTEM.DEBUG('5');
                                            opp.Payment_1MW_Approve__c = false;
                                            break;
                                        }else{
                                            opp.Payment_1MW_Approve__c = true;
                                        }
                                    }
                                    if(p.Payment_Term__c=='x% DP X days after the Execution Date'){
                                        if(p.Days__c>5||opp.Cross_Region__c==true){
                                            SYSTEM.DEBUG('6');
                                            opp.Payment_1MW_Approve__c = false;
                                            break;
                                        }else{
                                            opp.Payment_1MW_Approve__c = true;
                                        }
                                    }
     if(p.Down_Balance_Payment__c=='Balance Payment' && p.Payment_Method__c=='T/T' && opp.Region__c.contains('EU')){
            opp.Payment_1MW_Approve__c = false;
                                            break;
         }
                                       
                                    opp.Payment_1MW_Approve__c = true;
                                    
                                 
                                }
                                
                                for(Payment__c p:relatePayments){
                                      if(opp.Destination_Country__c=='VietNam'  && opp.Local_Warehouse__c=='Vietnam Warehouse' &&  (opp.Trade_Term__c == 'DDP' || opp.Trade_Term__c == 'EXW')  && opp.Cross_Region__c==false){
                                          system.debug('0211');
                                       if(p.Down_Balance_Payment__c=='Down Payment'){
                                           system.debug('0211.2');
                                       }
                                       
                                           else{ 
                                               if(p.Down_Balance_Payment__c=='Balance Payment'){
                                                   if(p.Payment_Term__c=='X% OA X days by TT from the BL/Delivery Date secured by Buyer Guarantee'){}
                                                   else{ 
                                                       system.debug('0211.3');
                                                       opp.vn_fast__c=false;
                                                   }
                                           
                                       }
                                               }
                                   }
                                    
                                }
                              
if(opp.Region__c.contains('EU') &&  opp.Total_MW__c > 3 ){
            opp.Payment_1MW_Approve__c = false;
                                           
         }
                                if(opp.Region__c.contains('EU') &&  opp.Trade_Term__c != 'CIF' &&  opp.Trade_Term__c != 'FOB'
                                  &&  opp.Trade_Term__c != 'DDP' &&  opp.Trade_Term__c != 'DAP' &&  opp.Trade_Term__c != 'EXW'){
            opp.Payment_1MW_Approve__c = false;
                                           
         }
                                if(opp.Trade_Term__c=='FCA'||opp.Cross_Region__c==true){
                                    SYSTEM.DEBUG('7');
                                    opp.Payment_1MW_Approve__c = false;
                                }
                                 if(opp.Special_Terms__c!=null){
                                     SYSTEM.DEBUG('8'+opp.Special_Terms__c);
                                    opp.Payment_1MW_Approve__c = false;
                                }
                                if((opp.Region__c=='Middle East&Africa'||opp.Region__c == 'MENA'||opp.Region__c == 'SSA')  && opp.Total_MW__c <= 2.0 && opp2.Account.credit_good__c==true && opp.Cross_Region__c!=false){
                                     opp.Payment_1MW_Approve__c = true;
                                }
                                updateOppList.add(opp);
                                updateOppIds.add(opp.id);
                                System.debug('@@@@@@@opp.Payment_Term_Description__c :' + opp.Payment_Term_Description__c );
                                System.debug('@@@@@@@opp.Payment_1MW_Approve__c :' + opp.Payment_1MW_Approve__c );
                                
                            }
                        }
                            else{  
                                 payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments, opp.Trade_Term__c, false);
                                 opp.Payment_Term_Description__c = payment_descritpion;
                                opp.Payment_1MW_Approve__c = false;
                                }
                            updateOppList.add(opp);
                                updateOppIds.add(opp.id);
                             system.debug('atfer4');
                        } 
                        
                        else if(string.isEmpty(payment_descritpion) && !updateOppIds.contains(opp.id)){
                            opp.Payment_Term_Description__c = PaymentHelper.retrivePaymentDescription(relatePayments);
                            opp.Payment_Reivew_Approval__c  = PaymentHelper.retrivePaymentReview(relatePayments);               
                            opp.Payment_1MW_Approve__c = false;
                            updateOppList.add(opp);
                            updateOppIds.add(opp.id);
                            System.debug('@@@@@@@opp.Payment_Term_Description__c == japan :' + opp.Payment_Term_Description__c );
                            System.debug('@@@@@@@opp.Payment_1MW_Approve__c :' + opp.Payment_1MW_Approve__c );
                        }
                    }
                    
                    // update order payment description
                    if(ordMap.containsKey(pay.Order__c)){
                        Order ord = ordMap.get(pay.Order__c);
                        System.debug('************ order: '+ord);                    
                        list<Payment__c> relatePayments = [Select Down_Balance_Payment__c, 
                                                           Payment_Term__c, 
                                                           Payment_Method__c,  
                                                           Name, Id,  
                                                           VietNam__c ,
                                                           Pakistan__c,
                                                           Days__c, 
                                                           CurrencyIsoCode,  
                                                           Precise_Day__c,
                                                           Opp_Trade_Term__c,
                                                           Opportunity__c, 
                                                           Japan__c,
                                                           type__c,
                                                           All_Trade_Term__c,
                                                           Comments_Japan__c,
                                                           Comments_English__c,
                                                           Percentage__c,
                                                           MOU_Type_Judgment__c
                                                           From Payment__c 
                                                           Where Order__c =: ord.id];
                        system.debug('------->relatePayments:' + relatePayments);
                        system.debug('------->ord.Trade_term__c:' + ord.Trade_term__c);
                        system.debug('------->pay.Opp_Trade_Term__c:' + pay.Opp_Trade_Term__c);
                        
                        payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments, ord.Trade_term__c, false);    
                        //payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments, pay.Opp_Trade_Term__c, false,ttpts);
                        System.debug('************ description1: '+payment_descritpion);              
                        if(!string.isNotEmpty(payment_descritpion)){
                            payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments);
                            System.debug('************ description2: '+payment_descritpion);                  
                        }
                        if(string.isNotEmpty(payment_descritpion) && !updateOrdIds.contains(ord.id)){
                            ord.Payment_Term_Description__c = payment_descritpion;
                            updateOrdList.add(ord);
                            updateOrdIds.add(ord.id);
                        }
                    }
                }
                
                // DML - update
                if(updateOppList.size()>0){
                    List<Opportunity> OPPlist= new List<Opportunity>();
                    Set<id> idslst=new Set<id>();
                    for(Opportunity opp:updateOppList){
                   if(idslst.contains(opp.id)){
                       
                       }
                        else{
                         idslst.add(opp.id); 
                            OPPlist.add(opp);
                            }
                        }
                    upsert OPPlist;
                }
                if(updateConList.size()>0){
                     List<contract> contractlist= new List<contract>();
                    Set<id> idslst=new Set<id>();
                    for(contract con:updateConList){
                     if(idslst.contains(con.id)){
                       
                       }
                        else{
                         idslst.add(con.id); 
                            contractlist.add(con);
                            }
                        }
                    upsert contractlist;
                }
                if(updateOrdList.size()>0){
                      List<order> orderlist= new List<order>();
                    Set<id> idslst=new Set<id>();
                   for(order ord:updateOrdList){
                   if(idslst.contains(ord.id)){
                       
                       }
                        else{
                         idslst.add(ord.id); 
                            orderlist.add(ord);
                            }
                        }
                      upsert orderlist;
                }
                   } 
            }
            else if(Trigger.isDelete){
                
                for(Payment__c pay : Trigger.old){
                    if(!oppIds.contains(pay.Opportunity__c)){
                        oppIds.add(pay.Opportunity__c);
                    }
                    if(!ordIds.contains(pay.Order__c)){
                        ordIds.add(pay.Order__c);
                    }                
                }
                
                
                map<id,Opportunity> oppMap = new map<id,Opportunity> ([Select 
                                                                       ID,Name,
                                                                       RecordType.name,
                                                                       Payment_Term_Description__c,
                                                                       Region__c,
                                                                       Trade_Term__c,
                                                                       Destination_Country__c,
                                                                       Cross_Region__c,
                                                                       Special_Terms__c,
                                                                       Payment_Reivew_Approval__c,
                                                                       Local_Warehouse__c,
                                                                       Total_MW__c 
                                                                       From Opportunity
                                                                       where id in : oppIds]) ;
                map<id,Order> ordMap = new map<id,Order>([SELECT ID,Name,Payment_Term_Description__c
                                                          FROM Order
                                                          WHERE id in: ordIds]);
                
                set<id> updateOppIds = new set<id> ();
                set<id> updateOrdIds = new set<id> ();
                
                list<Opportunity> updateOppList = new list<Opportunity>();
                list<Order> updateOrdList = new list<Order>();
                for(Payment__c pay: Trigger.old){
                    Opportunity opp = oppMap.get(pay.Opportunity__c);
                    Order ord = ordMap.get(pay.Order__c);
                    
                    if(opp != null){
                        list<Payment__c> relatePayments = [Select Down_Balance_Payment__c, 
                                                           Payment_Term__c, 
                                                           Payment_Method__c,  
                                                           Name, Id,  
                                                           Days__c, 
                                                           CurrencyIsoCode,  
                                                           Precise_Day__c,
                                                           Opp_Trade_Term__c,
                                                           Opportunity__c, 
                                                           Percentage__c,
                                                           Amount__c,
                                                           Japan__c,
                                                           type__c,
                                                           All_Trade_Term__c,
                                                           Comments_Japan__c,
                                                           Comments_English__c,
                                                           VietNam__c,
                                                           Pakistan__c,
                                                           MOU_Type_Judgment__c
                                                           From Payment__c 
                                                           Where Opportunity__c =: opp.id];
                        if(relatePayments.size()==0 && !updateOppIds.contains(opp.id)){
                            opp.Payment_Term_Description__c = '';
                            opp.Payment_Reivew_Approval__c = '';
                            opp.Payment_1MW_Approve__c = false;
                            updateOppList.add(opp);
                            updateOppIds.add(opp.id);
                        }
                        string payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments, pay.Opp_Trade_Term__c, false);
                        //string payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments, pay.Opp_Trade_Term__c, false,ttpts);
                        if(string.isNotEmpty(payment_descritpion) && !updateOppIds.contains(opp.id)){
                            opp.Payment_Term_Description__c = payment_descritpion;
                            if(opp.Destination_Country__c=='VietNam'  && opp.Local_Warehouse__c=='Vietnam Warehouse' &&  (opp.Trade_Term__c == 'DDP' || opp.Trade_Term__c == 'EXW') && opp.Cross_Region__c==false){
                                opp.vn_fast__c=true;
                                 }
                                else{
                                    opp.vn_fast__c=false;
                                    
                                }
                            for(Payment__c p:relatePayments){
                                  if(opp.Region__c=='ROA' && opp.Trade_Term__c != 'CIF' && opp.Trade_Term__c != 'EXW' && opp.Trade_Term__c != 'FOB' && opp.Trade_Term__c != 'DAP' && opp.Trade_Term__c != 'DDP' && opp.Trade_Term__c != 'CFR'&& opp.Trade_Term__c != 'CPT')
                                    {opp.Payment_1MW_Approve__c = false;
                                     break;} 
                                if(p.Down_Balance_Payment__c=='Balance Payment'){
                                    if(p.Payment_Method__c=='T/T' || p.Payment_Method__c=='T/T (Balance)'||opp.Cross_Region__c==true){
                                        opp.Payment_1MW_Approve__c = false;
                                        break;
                                    }else{
                                        opp.Payment_1MW_Approve__c = true;
                                    }
                                }
                                if(p.Payment_Term__c=='x% OA by LC X days'){
                                    if(p.Days__c>90||opp.Cross_Region__c==true){
                                        opp.Payment_1MW_Approve__c = false;
                                        break;
                                    }else{
                                        opp.Payment_1MW_Approve__c = true;
                                    }
                                }
                                if(p.Payment_Term__c=='x% DP X days before the BL/Delivery Date'){
                                    if(p.Days__c<15||opp.Cross_Region__c==true){
                                        opp.Payment_1MW_Approve__c = false;
                                        break;
                                    }else{
                                        opp.Payment_1MW_Approve__c = true;
                                    }
                                }
                                if(p.Payment_Term__c=='x% DP X days after the Execution Date'){
                                    if(p.Days__c>5||opp.Cross_Region__c==true){
                                        opp.Payment_1MW_Approve__c = false;
                                        break;
                                    }else{
                                        opp.Payment_1MW_Approve__c = true;
                                    }
                                }
                                 if(p.Down_Balance_Payment__c=='Balance Payment' && p.Payment_Method__c=='T/T' && opp.Region__c.contains('EU')){
            opp.Payment_1MW_Approve__c = false;
                                            break;
         }
                                opp.Payment_1MW_Approve__c = true;
                            }
                            for(Payment__c p:relatePayments){
                                      if(opp.Destination_Country__c=='VietNam'  && opp.Local_Warehouse__c=='Vietnam Warehouse' &&  (opp.Trade_Term__c == 'DDP' || opp.Trade_Term__c == 'EXW')  && opp.Cross_Region__c==false){
                                          system.debug('0211');
                                       if(p.Down_Balance_Payment__c=='Down Payment'){
                                           system.debug('0211.2');
                                       }
                                       
                                           else{ 
                                               if(p.Down_Balance_Payment__c=='Balance Payment'){
                                                   if(p.Payment_Term__c=='X% OA X days by TT from the BL/Delivery Date secured by Buyer Guarantee'){}
                                                   else{ 
                                                       system.debug('0211.3');
                                                       opp.vn_fast__c=false;
                                                   }
                                           
                                       }
                                               }
                                   }
                                    
                                }
                            if(opp.Trade_Term__c=='FCA'||opp.Cross_Region__c==true){
                                    SYSTEM.DEBUG('7');
                                    opp.Payment_1MW_Approve__c = false;
                                }
                            if(opp.Special_Terms__c!=null || opp.Special_Terms__c !=''){
                                    opp.Payment_1MW_Approve__c = false;
                                }
                             if(opp.Region__c.contains('EU') &&  opp.Total_MW__c > 3 ){
            opp.Payment_1MW_Approve__c = false;
                                           
         }
                                if(opp.Region__c.contains('EU') &&  opp.Trade_Term__c != 'CIF' &&  opp.Trade_Term__c != 'FOB'
                                  &&  opp.Trade_Term__c != 'DDP' &&  opp.Trade_Term__c != 'DAP' &&  opp.Trade_Term__c != 'EXW'){
            opp.Payment_1MW_Approve__c = false;
                                           
         }
                            updateOppList.add(opp);
                            updateOppIds.add(opp.id);
                        }
                        else if(string.isEmpty(payment_descritpion) && !updateOppIds.contains(opp.id)){
                            opp.Payment_Term_Description__c = PaymentHelper.retrivePaymentDescription(relatePayments); 
                            opp.Payment_Reivew_Approval__c  = PaymentHelper.retrivePaymentReview(relatePayments);               
                            opp.Payment_1MW_Approve__c = false;
                            updateOppList.add(opp);
                            updateOppIds.add(opp.id);
                        }
                    }
                    
                    if(ord != null){
                        list<Payment__c> relatePayments = [Select  Down_Balance_Payment__c, 
                                                           Payment_Term__c, 
                                                           Payment_Method__c,  
                                                           Name, Id,  
                                                           Days__c, 
                                                           CurrencyIsoCode,  
                                                           Precise_Day__c,
                                                           Opp_Trade_Term__c,
                                                           Opportunity__c, 
                                                           Percentage__c,
                                                           Amount__c,
                                                           Japan__c,
                                                           VietNam__c,
                                                           Pakistan__c,
                                                           type__c,
                                                           All_Trade_Term__c,
                                                           Comments_Japan__c,
                                                           Comments_English__c,
                                                           MOU_Type_Judgment__c
                                                           From Payment__c 
                                                           Where Order__c =: ord.id];
                        system.debug('---------->relatePayments:' + relatePayments);
                        if(relatePayments.size()==0 && !updateOrdIds.contains(ord.id)){
                            ord.Payment_Term_Description__c = '';
                            updateOrdList.add(ord);
                            updateOrdIds.add(ord.id);
                        }
                        string payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments, pay.All_Trade_Term__c, false);
                        //string payment_descritpion = PaymentHelper.retrivePaymentDescription(relatePayments, pay.Opp_Trade_Term__c, false,ttpts);
                        if(string.isNotEmpty(payment_descritpion) && !updateOrdIds.contains(ord.id)){
                            ord.Payment_Term_Description__c = payment_descritpion;
                            updateOrdList.add(ord);
                            updateOrdIds.add(ord.id);
                        }
                        else if(string.isEmpty(payment_descritpion) && !updateOrdIds.contains(ord.id)){
                            ord.Payment_Term_Description__c = PaymentHelper.retrivePaymentDescription(relatePayments);                
                            updateOrdList.add(ord);
                            updateOrdIds.add(ord.id);
                        }
                    }
                    
                }
                if(updateOppList.size()>0){
                    upsert updateOppList;
                }
                if(updateOrdList.size()>0){
                    upsert updateOrdList;
                }  
            }
        }
      //  }
    }