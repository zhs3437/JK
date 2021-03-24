public class PaymentHelper {
    public static string retrivePaymentDescription(list<Payment__c> paymentLst, 
                                                   string Trade_Term,
                                                   boolean tf){
                                                       string Payment_term = convertPaymentTerm(paymentLst, Trade_Term, tf);
                                                       system.debug('Payment_term--->'+Payment_term);
                                                       List<Trade_term_and_payment_term__c> ttpt = [select     Payment_description__c
                                                                                                    from Trade_term_and_payment_term__c
                                                                                                    where Trade_Term__c =:Trade_Term  
                                                                                                    and Payment_term__c =: Payment_term];
                                                       system.debug('ttpt.size()'+ttpt.size());
                                                       
                                                       return Payment_term;
                                                       
                                                   }
    
    private static string convertPaymentTerm(list<Payment__c> paymentLst, 
                                             string Trade_Term,
                                             boolean tf){
                                                 String newPaymentTerm ='';
                                                 List<String> StandFieldValue= new List<String>();
                                                 List<Standard_Template_Teams__c>  stdList = [select id,
                                                                                              Name,
                                                                                              Field_Values__c,
                                                                                              Actual_Values__c,
                                                                                              Actual_Values_Japan__c,
                                                                                              Type__c,
                                                                                              Flag__c
                                                                                              from Standard_Template_Teams__c 
                                                                                              limit 4000];
                                                 String TEXTtotal='';
                                               
                                                 Set<id> ids=new Set<id>();
                                                 
                                                 for(Payment__c p:paymentLst){
                                                     if(p.MOU_Type_Judgment__c==false ||
                                                       (p.Opp_Trade_Term__c !=null &&                   
                    									p.Down_Balance_Payment__c != '' &&
                    									p.Payment_Method__c != '' &&
                    									p.Days__c != null &&
                    									p.Payment_Term__c != '' &&
                   										p.Percentage__c !=0
                   										)
                                                       ){
                                                         
                                                     
                                                       String TEXT='';
                                                     String flag='0';
                                                     if(p.Japan__c!=true){
                                                     for(Standard_Template_Teams__c stt: stdList){
                                                         
                                                         if(stt.Type__c == 'Contain'){  
                                                             if(stt.Name=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
                                                                 StandFieldValue = stt.Field_Values__c.split(':');
                                                                 system.debug('信息汇总:---->'+StandFieldValue[0]+'=='+StandFieldValue[1]+'=='+StandFieldValue[2]+'=='+StandFieldValue[3]);
                                                                 system.debug('信息汇总2:---->'+Trade_term+'=='+p.Down_Balance_Payment__c+'=='+p.Payment_Method__c+'=='+p.Payment_Term__c);
                                                                 if(StandFieldValue[0].indexof(Trade_term)>-1 && StandFieldValue[1].indexof(p.Down_Balance_Payment__c)>-1 && StandFieldValue[2].indexof(p.Payment_Method__c)>-1 && StandFieldValue[3].indexof(p.Payment_Term__c)>-1){
                                                                    
																	    //增加越南逻辑
									  if(p.VietNam__c){
                                          if(stt.Field_Values__c =='EXW:Balance Payment:T/T (Balance):X% OA X days by TT from the BL/Delivery Date secured by Buyer Bank Guarantee'){
                                             TEXT ='Buyer shall pay '+p.Percentage__c+'% of total Price of the Goods by TT no later than '+p.Days__c+' days after the earlier of (a) the related Delivery Date of such Goods and (b)' +
                                                 'the date on which Buyer picks up such Goods from the Delivery Point.'+
                                                 'Buyer shall deliver the Buyer Bank Guarantee no later than 7 days prior to the Delivery Date of the related Goods.'; 
                                          }else{
                                              TEXT =TEXT+'----------'+stt.Actual_Values__c.replace('[填入百分比]',string.valueof(p.Percentage__c));
                                                                     TEXT = TEXT.replace('[填入天数]',string.valueof(p.Days__c));
                                          }
                                    
                                      }
                                                                         else if(p.Pakistan__c){
                                          System.debug('Snake 巴基斯坦');
                                          if(stt.Field_Values__c =='FOB,CIF,CIP,CFR,CPT:Balance Payment:L/C:x% OA by LC at sight'){
                                             TEXT =TEXT+'----------'+
                                                'Buyer shall pay '+p.Percentage__c+'% of total Price of the Goods by a Qualified L/C at sight of the bill of lading for the related Goods. Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                          }else if( stt.Field_Values__c =='DAP,CFR,FOB,CIF,CIP,CPT:Balance Payment:L/C:x% OA by LC X days'){
                                             TEXT =TEXT+'----------'+ 'Buyer shall pay '+p.Percentage__c+'% of total Price of the Goods by a Qualified L/C no later than '+p.Days__c+' days after the bill of lading date of the related Goods.'
                                                 +'Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                           }
                                                                             
                                                                             
                                                                             else{
                                               						  TEXT =TEXT+'----------'+stt.Actual_Values__c.replace('[填入百分比]',string.valueof(p.Percentage__c));
                                                                      TEXT = TEXT.replace('[填入天数]',string.valueof(p.Days__c));
                                          }
}else{
                                           TEXT =TEXT+'----------'+stt.Actual_Values__c.replace('[填入百分比]',string.valueof(p.Percentage__c));
                                                                     TEXT = TEXT.replace('[填入天数]',string.valueof(p.Days__c));
                                      }
                                                                     
                                                                     flag='1';
                                                                 }
                                                             }
                                                             
                                                         }
                                                     }
                                                     if(flag=='0'){
                                                         String miss2='----------[填入比例] % [类型] [填入天数] days by [填入方法]';
                                                         system.debug('--->'+string.valueof(p.Percentage__c));
                                                         if(p.Payment_Term__c.indexof('DP')>-1 || p.Payment_Term__c.indexof('D/P')>-1){
                                                             miss2=miss2.replace('[类型]',string.valueof('DP'));
                                                         }
                                                         else  if(p.Payment_Term__c.indexof('OA')>-1){
                                                             miss2=miss2.replace('[类型]',string.valueof('OA'));
                                                         }
                                                         miss2=miss2.replace('[填入比例]',string.valueof(p.Percentage__c));
                                                         if(p.Days__c!=null){
                                                             miss2=miss2.replace('[填入天数]',string.valueof(p.Days__c));
                                                         }else {
                                                             miss2=miss2.replace('[填入天数]','NK'); 
                                                         }
                                                         miss2=miss2.replace('[填入方法]',string.valueof(p.Payment_Method__c));
                                                         system.debug('--->'+miss2);
                                                         text = TEXT + miss2;
                                                         system.debug('--->'+text);
                                                     }
                                                         }
                                                      if(p.Japan__c==true ){
                         for(Standard_Template_Teams__c stt: stdList){
                        TEXT='';
                        if(stt.Type__c == 'Contain'){  
                            if(stt.Name=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
                                StandFieldValue = stt.Field_Values__c.split(':');
                                system.debug('信息汇总:---->'+StandFieldValue[0]+'=='+StandFieldValue[1]+'=='+StandFieldValue[2]+'=='+StandFieldValue[2]);
                                 if(P.Down_Balance_Payment__c=='Balance Payment'){
                            if(P.Payment_Term__c=='x% OA X days by TT from the EOM'
                               ){
                                   if(P.Days__c==30 ){
                                text=text+'\n\r----------各ロットの製品の対価全額は、納入当月の翌月末日までに、T/T方式にて支払うものとする';
                                   }else if(P.Days__c==60){
                                        text=text+'\n\r----------各ロットの製品の対価全額は、納入当月の翌翌月末日までに、T/T方式にて支払うものとする。';

                                   }
                                    break;
                                   }
                    }
                               else if(StandFieldValue[0].indexof(p.All_Trade_Term__c)>-1 && StandFieldValue[1].indexof(p.Down_Balance_Payment__c)>-1 && StandFieldValue[2].indexof(p.Payment_Method__c)>-1 && StandFieldValue[3].indexof(p.Payment_Term__c)>-1){
                                    system.debug('进入test');    
                                    if(stt.Actual_Values_Japan__c!=null){
                                    String text2 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(p.Percentage__c));
                                   
                                    
                                    text = text2.replace('[填入天数]',string.valueof(p.Days__c));
                                        text2 ='\n\r'+stt.Actual_Values_Japan__c.replace('[填入百分比]',string.valueof(p.Percentage__c));
                                         text = '\n\r----------'+text+text2.replace('[填入天数]',string.valueof(p.Days__c));
                          break;
                                }
                                }
                                
                            
                            }
                            
                        }
                             
                    }
                                                       
                                                         
 system.debug('进入test1'+text); 
                                                          system.debug('进入test1'+text); 
                                                           system.debug('进入test2'+p.Comments_English__c);  
                          system.debug('进入test3'+p.Comments_Japan__c); 
                      if(text==null || text ==''){
                          if(p.Comments_Japan__c!=null){
                                       String text2=p.Comments_Japan__c;
                                    text=text+'----------'+text2;
                          }
                                }
                    }
                                                     
                   texttotal=texttotal+text;
                                                     }
                                                 }
                                                 return texttotal;
                                             }
    
    
    public static string retrivePaymentDescription2(list<Amendment_Payment__c> paymentLst, 
                                                    string Trade_Term,
                                                    boolean tf){
                                                        string Payment_term = convertPaymentTerm2(paymentLst, Trade_Term, tf);
                                                        system.debug('Payment_term--->'+Payment_term);
                                                        
                                                        
                                                        return Payment_term;
                                                        
                                                    }
    
    private static string convertPaymentTerm2(list<Amendment_Payment__c> paymentLst, 
                                              string Trade_Term,
                                              boolean tf){
                                                  String newPaymentTerm ='';
                                                  List<String> StandFieldValue= new List<String>();
                                                  List<Standard_Template_Teams__c>  stdList = [select id,
                                                                                               Name,
                                                                                               Field_Values__c,
                                                                                               Actual_Values__c,
                                                                                               Type__c,
                                                                                               Flag__c
                                                                                               from Standard_Template_Teams__c 
                                                                                               limit 4000];
                                                  String TEXT='';
                                                  Set<id> ids=new Set<id>();
                                                  
                                                  for(Amendment_Payment__c p:paymentLst){
                                                      
                                                      String flag='0';
                                                      for(Standard_Template_Teams__c stt: stdList){
                                                          
                                                          if(stt.Type__c == 'Contain'){  
                                                              if(stt.Name=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
                                                                  StandFieldValue = stt.Field_Values__c.split(':');
                                                                  
                                                                  if(StandFieldValue[0].indexof(Trade_term)>-1 && StandFieldValue[1].indexof(p.Down_Balance_Payment__c)>-1 && StandFieldValue[2].indexof(p.Payment_Method__c)>-1 && StandFieldValue[3].indexof(p.Payment_Term__c)>-1){
                                                                     
                                                                            //增加越南逻辑
									  if(p.VietNam__c){
                                          if(stt.Field_Values__c =='EXW:Balance Payment:T/T (Balance):X% OA X days by TT from the BL/Delivery Date secured by Buyer Bank Guarantee'){
                                             TEXT =TEXT+'----------'+'Buyer shall pay '+p.Percentage__c+'% of total Price of the Goods by TT no later than '+p.Days__c+' days after the earlier of (a) the related Delivery Date of such Goods and (b)' +
                                                 'the date on which Buyer picks up such Goods from the Delivery Point.'+
                                                 'Buyer shall deliver the Buyer Bank Guarantee no later than 7 days prior to the Delivery Date of the related Goods.'; 
                                          }else{
                                               						  TEXT =TEXT+'----------'+stt.Actual_Values__c.replace('[填入百分比]',string.valueof(p.Percentage__c));
                                                                      TEXT = TEXT.replace('[填入天数]',string.valueof(p.Days__c));
                                          }
                                    
                                      }
                                                                      else if(p.Pakistan__c){
                                          System.debug('Snake 巴基斯坦');
                                          if(stt.Field_Values__c =='FOB,CIF,CIP,CFR,CPT:Balance Payment:L/C:x% OA by LC at sight'){
                                             TEXT =TEXT+'----------'+
                                                'Buyer shall pay '+p.Percentage__c+'% of total Price of the Goods by a Qualified L/C at sight of the bill of lading for the related Goods. Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                          }else if( stt.Field_Values__c =='DAP,CFR,FOB,CIF,CIP,CPT:Balance Payment:L/C:x% OA by LC X days'){
                                             TEXT =TEXT+'----------'+ 'Buyer shall pay '+p.Percentage__c+'% of total Price of the Goods by a Qualified L/C no later than '+p.Days__c+' days after the bill of lading date of the related Goods.'
                                                 +'Buyer shall cause its bank to issue the Qualified L/C within 14 days after Execution Date of the Purchase Order. But under any circumstances, the seller shall receive the Qualified L/C within 20 BUSINESS days before the DELIVERY DATE of the related Goods';
                                           }else{
                                               						  TEXT =TEXT+'----------'+stt.Actual_Values__c.replace('[填入百分比]',string.valueof(p.Percentage__c));
                                                                      TEXT = TEXT.replace('[填入天数]',string.valueof(p.Days__c));
                                          }
}
                                                                      
                                                                      
                                                                      else{
                                                 
                                                                      TEXT =TEXT+'----------'+stt.Actual_Values__c.replace('[填入百分比]',string.valueof(p.Percentage__c));
                                                                      TEXT = TEXT.replace('[填入天数]',string.valueof(p.Days__c));
                                                                     
                                                                }       
                                                                      
                                                                      
                                                                      
                                                                      flag='1';
                                                                  }
                                                              }
                                                              
                                                          }
                                                      }
                                                      if(flag=='0'){
                                                          String miss2='----------[填入比例] % OA [填入天数] days by [填入方法]';
                                                          system.debug('--->'+string.valueof(p.Percentage__c));
                                                          miss2=miss2.replace('[填入比例]',string.valueof(p.Percentage__c));
                                                          if(p.Days__c!=null){
                                                              miss2=miss2.replace('[填入天数]',string.valueof(p.Days__c));
                                                          }else {
                                                              miss2=miss2.replace('[填入天数]','NK'); 
                                                          }
                                                          miss2=miss2.replace('[填入方法]',string.valueof(p.Payment_Method__c));
                                                          system.debug('--->'+miss2);
                                                          text = TEXT + miss2;
                                                          system.debug('--->'+text);
                                                      }
                                                      
                                                  }
                                                  return TEXT;
                                              }
    /**
*cerate by jason
*
*/
    
    
    public static String retrivePaymentDescription(list<Payment__c> paymentLst){
        String paymentDescription = '';
        String PayStr1='';
        for(Payment__c tmp : paymentLst){
            if(tmp.MOU_Type_Judgment__c==false ||
               (tmp.Opp_Trade_Term__c !=null &&                   
                    									tmp.Down_Balance_Payment__c != '' &&
                    									tmp.Payment_Method__c != '' &&
                    									tmp.Days__c != null &&
                    									tmp.Payment_Term__c != '' &&
                   										tmp.Percentage__c !=0
                   										)
              ){
                
            
            PayStr1 =tmp.Payment_Term__c;
            PayStr1 =PayStr1.replaceAll('x%', string.valueOf(tmp.Percentage__c)+'%');
            if(!String.isEmpty(String.valueof(tmp.Days__c))){
                PayStr1 =PayStr1.replaceAll('X ', string.valueOf(tmp.Days__c));                
            }
            if(tmp.Down_Balance_Payment__c=='Down Payment'){
                paymentDescription = paymentDescription +'\n'+ 
                    PayStr1+'  '+
                    tmp.Payment_Method__c ;
            }else {
                paymentDescription =  paymentDescription +'\n'+ 
                    // tmp.Payment_Term__c +'  '+
                    PayStr1;
            }
            }
            /**
paymentDescription +=   tmp.Percentage__c + '% ' + 
tmp.Down_Balance_Payment__c + ' ' + 
tmp.Payment_Method__c + ' ' + 
(tmp.Days__c == null ? 'at' : (tmp.Days__c  + ' days '))  + ' '+
(tmp.Precise_Day__c == null ?
PayStr1 :
//tmp.Payment_Term__c :
(tmp.Precise_Day__c.year() + '-' + tmp.Precise_Day__c.month() + '-' + 
tmp.Precise_Day__c.day() ));
*/
            
        }
        
        
        //		System.debug('###other paymentDescription' + paymentDescription );
        return paymentDescription;
    }
    
    public static String retrivePaymentDescription2(list<Amendment_Payment__c> paymentLst){
        String paymentDescription = '';
        String PayStr1='';
        for(Amendment_Payment__c tmp : paymentLst){
            
            PayStr1 =tmp.Payment_Term__c;
            PayStr1 =PayStr1.replaceAll('x%', string.valueOf(tmp.Percentage__c)+'%');
            if(!String.isEmpty(String.valueof(tmp.Days__c))){
                PayStr1 =PayStr1.replaceAll('X ', string.valueOf(tmp.Days__c));                
            }
            if(tmp.Down_Balance_Payment__c=='Down Payment'){
                paymentDescription = paymentDescription +'\n'+ 
                    PayStr1+' '+
                    tmp.Payment_Method__c ;
            }else {
                paymentDescription =  paymentDescription +'\n'+ 
                    // tmp.Payment_Term__c +'  '+
                    PayStr1;
            }
            
            /**
paymentDescription +=   tmp.Percentage__c + '% ' + 
tmp.Down_Balance_Payment__c + ' ' + 
tmp.Payment_Method__c + ' ' + 
(tmp.Days__c == null ? 'at' : (tmp.Days__c  + ' days '))  + ' '+
(tmp.Precise_Day__c == null ?
PayStr1 :
//tmp.Payment_Term__c :
(tmp.Precise_Day__c.year() + '-' + tmp.Precise_Day__c.month() + '-' + 
tmp.Precise_Day__c.day() ));
*/
            
        }
        
        
        //		System.debug('###other paymentDescription' + paymentDescription );
        return paymentDescription;
    }    
    /*
*create by Jason 20160630   //展示 详细的 paymentDescription
**/
    public static String retrivePaymentReview(list<Payment__c> paymentLst){
        String paymentReview = '';
        String str = '';
        String PayStr1='';
        String PayStr2='';
        if(paymentLst[0].MOU_Type_Judgment__c==false ||
          (paymentLst[0].Opp_Trade_Term__c !=null &&                   
                    									paymentLst[0].Down_Balance_Payment__c != '' &&
                    									paymentLst[0].Payment_Method__c != '' &&
                    									paymentLst[0].Days__c != null &&
                    									paymentLst[0].Payment_Term__c != '' &&
                   										paymentLst[0].Percentage__c !=0
                   										)
          ){
            
        
        if(paymentLst.size() == 1){
            Payment__c payment = paymentLst[0];
            PayStr1 =payment.Payment_Term__c;
            PayStr1 =PayStr1.replaceAll('x%', string.valueOf(payment.Percentage__c)+'%');
            if(!String.isEmpty(String.valueof(payment.Days__c))){
                PayStr1 =PayStr1.replaceAll('X ', string.valueOf(payment.Days__c));                
            }
            system.debug('PayStr1-->'+PayStr1);
            if(payment.Down_Balance_Payment__c == 'Down Payment'){
                //TODO
                str =  'The first down payment of' + ' '+
                    payment.Percentage__c +'%'+'|'+ ' '+
                    payment.Amount__c+' '+'shall be paid by'+ ' '+
                    //PayStr1+''+
                    //payment.Payment_Method__c + ' '+
                    (payment.Days__c == null ? 'at' : (payment.Days__c  + ' days '))  + ' '+
                    (payment.Precise_Day__c == null ?
                     PayStr1:
                     //payment.Payment_Term__c :
                     (payment.Precise_Day__c.year() + '-' + payment.Precise_Day__c.month() + '-' + 
                      payment.Precise_Day__c.day() ));
                system.debug('~~~~~~~>Amount:'+payment.Amount__c);
            }
            else if(payment.Down_Balance_Payment__c == 'Balance Payment'){
                str =  'The first balance payment of' +  ' '+
                    payment.Percentage__c +'%'+'|'+ ' '+
                    payment.Amount__c+' '+'shall be paid by'+ ' '+
                    payment.Payment_Method__c + ' '+
                    (payment.Days__c == null ? 'at' : (payment.Days__c  + ' days '))  + ' '+
                    (payment.Precise_Day__c == null ?
                     PayStr1 :
                     //payment.Payment_Term__c :
                     (payment.Precise_Day__c.year() + '-' + payment.Precise_Day__c.month() + '-' + 
                      payment.Precise_Day__c.day() ));
                
            }
            paymentReview = str;
        }
        
        else if(paymentLst.size() == 2){
            
            Payment__c payment1 = paymentLst[0];
            Payment__c payment2 = paymentLst[1];
            PayStr1 =payment1.Payment_Term__c;
            PayStr1 =PayStr1.replace('x%', string.valueOf(payment1.Percentage__c)+'%');
            if(!String.isEmpty(String.valueof(payment1.Days__c))){
                PayStr1 =PayStr1.replace('X ', string.valueOf(payment1.Days__c));                
            }
            PayStr2 =payment2.Payment_Term__c;
            PayStr2 =PayStr2.replace('x%', string.valueOf(payment2.Percentage__c)+'%');
            if(!String.isEmpty(String.valueof(payment2.Days__c))){
                PayStr2 =PayStr2.replace('X days', string.valueOf(payment2.Days__c));                
            }
            if(payment1.Down_Balance_Payment__c == 'Down Payment'){
                str =  'The first down payment of' +  ' '+
                    payment1.Percentage__c +'%'+'|'+ ' '+
                    payment1.Amount__c+' '+'shall be paid by'+ ' '+
                    //PayStr1 +''+
                    payment1.Payment_Method__c + ' '+
                    (payment1.Days__c == null ? 'at' : (payment1.Days__c  + ' days '))  + ' '+
                    (payment1.Precise_Day__c == null ?
                     PayStr1 :
                     //payment1.Payment_Term__c :
                     (payment1.Precise_Day__c.year() + '-' + payment1.Precise_Day__c.month() + '-' + 
                      payment1.Precise_Day__c.day() ));
                if(payment2.Down_Balance_Payment__c == 'Down Payment'){
                    str =  str +'\n'+ 'The second down payment of' +  ' '+
                        payment2.Percentage__c +'%'+'|'+ ' '+
                        payment2.Amount__c+' '+'shall be paid by'+ ' '+
                        //PayStr2 +''+	
                        payment2.Payment_Method__c + ' '+
                        (payment2.Days__c == null ? 'at' : (payment2.Days__c  + ' days '))  + ' '+
                        (payment2.Precise_Day__c == null ?
                         PayStr2 :
                         //	 payment2.Payment_Term__c :
                         (payment2.Precise_Day__c.year() + '-' + payment2.Precise_Day__c.month() + '-' + 
                          payment2.Precise_Day__c.day() ));
                    
                }else if(payment2.Down_Balance_Payment__c == 'Balance Payment'){
                    str =  str +'\n'+ 'The second balance payment of' +  ' '+
                        payment2.Percentage__c +'%'+'|'+ ' '+
                        payment2.Amount__c+' '+'shall be paid by'+ ' '+
                        //PayStr2 +''+	
                        payment2.Payment_Method__c + ' '+
                        (payment2.Days__c == null ? 'at' : (payment2.Days__c  + ' days '))  + ' '+
                        (payment2.Precise_Day__c == null ?
                         PayStr2 :
                         //		 payment2.Payment_Term__c :
                         (payment2.Precise_Day__c.year() + '-' + payment2.Precise_Day__c.month() + '-' + 
                          payment2.Precise_Day__c.day() ));
                }
                paymentReview = str;
            }
            else if(payment1.Down_Balance_Payment__c == 'Balance Payment'){
                str =  'The first balance payment of' +  ' '+
                    payment1.Percentage__c +'%'+'|'+ ' '+
                    payment1.Amount__c+' '+'shall be paid by'+ ' '+
                    //PayStr1 +''+
                    payment1.Payment_Method__c + ' '+
                    (payment1.Days__c == null ? 'at' : (payment1.Days__c  + ' days '))  + ' '+
                    (payment1.Precise_Day__c == null ?
                     PayStr1 :
                     //	 payment1.Payment_Term__c :
                     (payment1.Precise_Day__c.year() + '-' + payment1.Precise_Day__c.month() + '-' + 
                      payment1.Precise_Day__c.day() ));
                
                if(payment2.Down_Balance_Payment__c == 'Down Payment'){
                    str =  str +'\n'+ 'The second down payment of' +  ' '+
                        payment2.Percentage__c +'%'+'|'+ ' '+
                        payment2.Amount__c+' '+'shall be paid by'+ ' '+
                        //PayStr2 +''+	
                        payment2.Payment_Method__c + ' '+
                        (payment2.Days__c == null ? 'at' : (payment2.Days__c  + ' days '))  + ' '+
                        (payment2.Precise_Day__c == null ?
                         PayStr2 :
                         //	 payment2.Payment_Term__c :
                         (payment2.Precise_Day__c.year() + '-' + payment2.Precise_Day__c.month() + '-' + 
                          payment2.Precise_Day__c.day() ));
                }
                else if(payment2.Down_Balance_Payment__c == 'Balance Payment'){
                    str =  str +'\n'+ 'The second balance payment of' +  ' '+
                        payment2.Percentage__c +'%'+'|'+ ' '+
                        payment2.Amount__c+' '+'shall be paid by'+ ' '+
                        //PayStr2 +''+	
                        payment2.Payment_Method__c + ' '+
                        (payment2.Days__c == null ? 'at' : (payment2.Days__c  + ' days '))  + ' '+
                        (payment2.Precise_Day__c == null ?
                         PayStr2 :
                         //	 payment2.Payment_Term__c :
                         (payment2.Precise_Day__c.year() + '-' + payment2.Precise_Day__c.month() + '-' + 
                          payment2.Precise_Day__c.day() ));
                }
                paymentReview = str;
            }
        }
        }
        //	System.debug('###other paymentReview' + paymentReview );
        return paymentReview;
    }
    public static string retriveDeliveryPoint(string Trade_Term){
        List<Trade_term_and_payment_term__c> ttpt = [select     Delivery_Point__c
                                                     from Trade_term_and_payment_term__c
                                                     where Trade_Term__c =:Trade_Term  
                                                     and Delivery_Point__c != '' Limit 10];
        
        
        if(ttpt.size()>0){ 
            return ttpt[0].Delivery_Point__c;
        }
        return '';
    }
    
    public static string retriveGuaranteedDeliveryDate(string Trade_Term){
        List<Trade_term_and_payment_term__c> ttpt = [select     Guaranteed_Delivery_Date__c
                                                     from Trade_term_and_payment_term__c
                                                     where Trade_Term__c =:Trade_Term  
                                                     and Guaranteed_Delivery_Date__c != ''];
        
        
        if(ttpt.size()>0){ 
            return ttpt[0].Guaranteed_Delivery_Date__c;
        }
        return '';
    }
    
}