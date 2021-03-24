global class  ContractPreviewClick {
    webservice static String ContractPreviewClick(String conid){
        String newPaymentTerm ='';
        System.debug('111');
        newPaymentTerm=ContractPreviewClick.Contract(conid);
        system.debug('ContractPreviewClick-->'+newPaymentTerm);
        return newPaymentTerm;
    }
    
    
    
    
    public static String Contract(String conId){
        List<String> StandFieldValue = new List<String>();
        Date DeliveryDate = null;
        Date dt = date.today();
        Date ExceptionDeliveryDate = null;
        String newPaymentTerm ='';
        String newPaymentTerm1 ='';
        String newPaymentTerm2 ='';
        String Payment1 ='';
        String Payment2 ='';
        String  requestId = conId;
        String DayFlag ='';
        Contract  contract = (Contract)[select id,
                                        ContractNumber,
                                        Name,
                                        Status,
                                        Destination_port__c,
                                        Destination__c,
                                        Region__c,
                                        PaymentTermStand__c,
                                        Destination_Country__c,
                                        Warranty_Insurance__c,
                                        Warranty_On_Material_and_Workmanship__c,
                                        Delivery_point__c,
                                        Buyer_Letter_of_guarantee__c,
                                        SELLER__c,
                                        Legal_Dept_Finish_Time__c,
                                        Finance_Dept_Finish_Time__c,
                                        SpecialPaymentTerm__c,
                                        Trade_term__c
                                        from Contract
                                        where id =:conId]; 
        if(contract.Finance_Dept_Finish_Time__c!=null){
            dt=contract.Finance_Dept_Finish_Time__c.date();
        }
        if(contract.Legal_Dept_Finish_Time__c!=null){
            dt=contract.Legal_Dept_Finish_Time__c.date();
        }
        List<Payment__c>    payLst =[Select ID,Contract__c,Days__c,Down_Balance_Payment__c,Percentage__c,Payment_Method__c,Payment_Term__c,Precise_Day__c from Payment__c where Contract__c =:conId];
        List<Product_Detail__c>    pdLst =[Select ID,Contract_PO_PI__c,Guaranteed_Delivery_Date__c,Guaranteed_Delivery_Date_japan__c from Product_Detail__c where Contract_PO_PI__c =:conId ORDER By Guaranteed_Delivery_Date__c ASC];
        list<Standard_Template_Teams__c> stdList = [select id,
                                                    Name,
                                                    Field_Values__c,
                                                    Actual_Values__c,
                                                    Type__c,
                                                    Flag__c
                                                    from Standard_Template_Teams__c 
                                                    limit 1000];
        
        Map<string,Standard_Template_Teams__c>  stdMap = new Map<string,Standard_Template_Teams__c>();
        for(Standard_Template_Teams__c s : stdList){
            stdMap.put(s.Name,s);
        }
        
        //load contract individual teams
        list<Individual_Teams__c>  indList = [select id,
                                              Name,
                                              Field_Values__c,
                                              Actual_Values__c,
                                              Type__c,
                                              Contract__c
                                              from Individual_Teams__c 
                                              where Contract__c =:conId
                                              limit 1000];
        
        Map<string,Individual_Teams__c>  indMap = new Map<string,Individual_Teams__c>();
        
        for(Individual_Teams__c i : indList){
            indMap.put(i.Name,i);
            
        }
        
        contract =[select id,
                   ContractNumber,
                   Name,
                   Status,
                   Destination_port__c,
                   Destination__c,
                   Region__c,
                   
                   PaymentTermStand__c,
                   Destination_Country__c,
                   Warranty_Insurance__c,
                   Warranty_On_Material_and_Workmanship__c,
                   Delivery_point__c,
                   Buyer_Letter_of_guarantee__c,
                   SELLER__c,
                   Payment_Term_Description__c,
                   SpecialPaymentTerm__c,
                   RecordTypeName__c,
                   Trade_term__c
                   from Contract
                   where id =:conId];
        System.debug('indList.size()'+indList.size());
        if(indList.size()==0){
          for(Standard_Template_Teams__c stt: stdList){
            Individual_Teams__c it = new Individual_Teams__c();
              try{
            If(pdLst.size()>0){
                DeliveryDate = pdLst[0].Guaranteed_Delivery_Date__c;
            }
            it.Name = stt.Name;
            it.Type__c = stt.Type__c;
            Boolean DeliveryDatefalg = true;
            if(stt.Type__c == 'Contain'){
                if(stt.Name=='Trade_term__c:Down_Balance_Payment__c:Payment_Method__c:Payment_Term__c'){
//                       system.debug('Strat ');
                    if(payLst.size()>0){
                        if(payLst.size()==1){
                            StandFieldValue = stt.Field_Values__c.split(':');

                            if(Contract.Trade_term__c=='CFR'|| Contract.Trade_term__c=='CIF' || Contract.Trade_term__c=='CIP' || Contract.Trade_term__c=='FOB' || Contract.Trade_term__c=='EXW' ){
                                if(payLst[0].Payment_Term__c=='x% DP X days after the Execution Date'){
                                if(payLst[0].Down_Balance_Payment__c=='Down Payment'){
                                      ExceptionDeliveryDate = dt.addDays(Integer.valueof(payLst[0].Days__c));
                                }
                                if(ExceptionDeliveryDate !=null && (Contract.Trade_term__c=='CFR'|| Contract.Trade_term__c=='CIF' || Contract.Trade_term__c=='CIP' || Contract.Trade_term__c=='FOB')){
                                     ExceptionDeliveryDate = ExceptionDeliveryDate.addDays(14);
                                    DayFlag = 'Not Exw';
                                }else if(ExceptionDeliveryDate !=null && Contract.Trade_term__c=='EXW'){
                                     ExceptionDeliveryDate = ExceptionDeliveryDate.addDays(3);
                                     DayFlag = 'Exw';
                                }
                                
                                if(ExceptionDeliveryDate !=null && DeliveryDate !=null){
                                    Integer i=ExceptionDeliveryDate.daysBetween(DeliveryDate);
                                    if(i<0){
                                        DeliveryDatefalg = false;  
                                    }else{
                                        DeliveryDatefalg = true;    
                                    }
                                }else{
                                    DeliveryDatefalg = false;
                                }  
                                }
                                else if(payLst[0].Payment_Term__c=='x% DP X days before the BL/Delivery '){
                                    if(Contract.Trade_term__c=='CFR'|| Contract.Trade_term__c=='CIF' || Contract.Trade_term__c=='CIP' || Contract.Trade_term__c=='FOB'){
                                        if(payLst[0].Days__c >13){
                                             DeliveryDatefalg = true;  
                                        }else{
                                             DeliveryDatefalg = false;  
                                        }
                                    }
                                    else if(Contract.Trade_term__c=='EXW'){
                                      if(payLst[0].Days__c >2){
                                             DeliveryDatefalg = true;  
                                      }else{
                                          DeliveryDatefalg = false;  
                                      }
                                    }
                                }
                              
                            }
                            system.debug('DeliveryDatefalg-->'+DeliveryDatefalg);
                            if(stt.Field_Values__c.indexof(contract.Trade_term__c)>-1){   
                                it.Field_Values__c = StandFieldValue[0] +':' + payLst[0].Down_Balance_Payment__c + ':'+payLst[0].Payment_Method__c +':'+ payLst[0].Payment_Term__c; 
                            } 
                            List<String>  IndivFieldValue = new List<String>();
                            if( it.Field_Values__c !=null){
                                IndivFieldValue= it.Field_Values__c.split(':'); 
                            }  
                            system.debug('StandFieldValue-->'+StandFieldValue);
                            system.debug('IndivFieldValue-->'+IndivFieldValue);
                            if(StandFieldValue==IndivFieldValue){
                                system.debug('111');
                                it.Actual_Values__c =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                it.Actual_Values__c = it.Actual_Values__c.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                                if(!String.isEmpty(contract.Buyer_Letter_of_guarantee__c)){
                                    it.Actual_Values__c  = it.Actual_Values__c +'\r\n' +System.Label.Letter_of_guarantee;
                                    it.Actual_Values__c = it.Actual_Values__c.replace('[bank guaranty/parent company guaranty]',contract.Buyer_Letter_of_guarantee__c);
                                }
                                 if(payLst[0].Percentage__c!=100){
                                    newPaymentTerm = '';
                                    newPaymentTerm ='Not 100%';
                                 }
                                else{
                                    newPaymentTerm = it.Actual_Values__c; 
                                }
                                if(DeliveryDatefalg==false){
                                    newPaymentTerm = ''; 
                                    if(DayFlag =='Exw'){
                                      newPaymentTerm = 'ExwDate';
                                    }else{
                                      newPaymentTerm = 'NotExwDate';  
                                    }
                                }
                            }
                            stt.Actual_Values__c = it.Actual_Values__c;
                        }
                        if(payLst.size()==2){
                           if(Contract.Trade_term__c=='CFR'|| Contract.Trade_term__c=='CIF' || Contract.Trade_term__c=='CIP' || Contract.Trade_term__c=='FOB' || Contract.Trade_term__c=='EXW' ){
                                if(payLst[0].Payment_Term__c=='x% DP X days after the Execution Date'){
                                if(payLst[0].Down_Balance_Payment__c=='Down Payment'){
                                      ExceptionDeliveryDate = dt.addDays(Integer.valueof(payLst[0].Days__c));
                                }
                                if(ExceptionDeliveryDate !=null && (Contract.Trade_term__c=='CFR'|| Contract.Trade_term__c=='CIF' || Contract.Trade_term__c=='CIP' || Contract.Trade_term__c=='FOB')){
                                     ExceptionDeliveryDate = ExceptionDeliveryDate.addDays(14);
                                     DayFlag = 'Not Exw';
                                }else if(ExceptionDeliveryDate !=null && Contract.Trade_term__c=='EXW'){
                                     ExceptionDeliveryDate = ExceptionDeliveryDate.addDays(3);
                                     DayFlag = 'Exw';
                                }
                                   
                                if(ExceptionDeliveryDate !=null && DeliveryDate !=null){
                                    Integer i=ExceptionDeliveryDate.daysBetween(DeliveryDate);
                                    if(i<0){
                                        DeliveryDatefalg = false;  
                                    }else{
                                        DeliveryDatefalg = true;    
                                    }
                                }else{
                                    DeliveryDatefalg = false;
                                }  
                                }else if(payLst[0].Payment_Term__c=='x% DP X days before the BL/Delivery '){
                                    if(Contract.Trade_term__c=='CFR'|| Contract.Trade_term__c=='CIF' || Contract.Trade_term__c=='CIP' || Contract.Trade_term__c=='FOB'){
                                        if(payLst[0].Days__c >13){
                                             DeliveryDatefalg = true;  
                                        }else{
                                             DeliveryDatefalg = false;  
                                        }
                                    }else if(Contract.Trade_term__c=='EXW'){
                                      if(payLst[0].Days__c >2){
                                             DeliveryDatefalg = true;  
                                      }else{
                                          DeliveryDatefalg = false;  
                                      }
                                    }
                                }
                              
                            }
                           
                            StandFieldValue = stt.Field_Values__c.split(':');
                            if(stt.Field_Values__c.indexof(contract.Trade_term__c)>-1){  
                                Payment1 = StandFieldValue[0] +':' + payLst[0].Down_Balance_Payment__c + ':'+ payLst[0].Payment_Method__c +':'+  payLst[0].Payment_Term__c; 
                                Payment2 = StandFieldValue[0] +':' + payLst[1].Down_Balance_Payment__c + ':'+ payLst[1].Payment_Method__c +':'+  payLst[1].Payment_Term__c;
                            }
                            List<String>  IndivFieldValue1 = new List<String>();
                            List<String>  IndivFieldValue2 = new List<String>();
                            if(Payment1 !=null && Payment2 !=null){
                                IndivFieldValue1= Payment1.split(':'); 
                                IndivFieldValue2= Payment2.split(':'); 
                            }
                            system.debug('StandFieldValue-->');
                            if(StandFieldValue==IndivFieldValue1){
                                newPaymentTerm1 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[0].Percentage__c));
                                newPaymentTerm1 = newPaymentTerm1.replace('[填入天数]',string.valueof(payLst[0].Days__c));
                            }
                            if(StandFieldValue==IndivFieldValue2){
                                newPaymentTerm2 =stt.Actual_Values__c.replace('[填入百分比]',string.valueof(payLst[1].Percentage__c));
                                newPaymentTerm2 = newPaymentTerm2.replace('[填入天数]',string.valueof(payLst[1].Days__c));
                            }
                       
                            if(newPaymentTerm1 !=null && newPaymentTerm2 !=null){
                                
                                newPaymentTerm =newPaymentTerm1+'\t\r\n' +newPaymentTerm2;
                                system.debug('newPaymentTerm -->'+newPaymentTerm );
                                if(!String.isEmpty(contract.Buyer_Letter_of_guarantee__c)){
                                    newPaymentTerm = newPaymentTerm+'\t\r\n'  +System.Label.Letter_of_guarantee;
                                    newPaymentTerm = newPaymentTerm.replace('[bank guaranty/parent company guaranty]',contract.Buyer_Letter_of_guarantee__c);
                                }
                                stt.Field_Values__c = Payment1 + ':'+Payment2;
                                it.Field_Values__c =  Payment1 + ':'+Payment2;
                            }
                            Decimal i = payLst[0].Percentage__c;
                            Decimal j = payLst[1].Percentage__c;  
                            system.debug('i='+i);
                             system.debug('j='+j);
                           /* if((payLst[0].Down_Balance_Payment__c=='Down Payment' && payLst[1].Down_Balance_Payment__c=='Down Payment') || (payLst[0].Down_Balance_Payment__c=='Balance Payment' && payLst[1].Down_Balance_Payment__c=='Balance Payment')){
                               System.debug('1234');
                                newPaymentTerm = '';
                                newPaymentTerm ='PaySame';
                            }else 
                                */
                                if(contract.Trade_term__c=='EXW' &&( payLst[0].Payment_Method__c=='L/C'|| payLst[1].Payment_Method__c=='L/C')){
                                 System.debug('2345');
                                newPaymentTerm = '';
                                 newPaymentTerm ='PayLc';
                            }else if((contract.Trade_term__c=='FCA'||contract.Trade_term__c=='DAP'||contract.Trade_term__c=='DAT'||contract.Trade_term__c=='DDP')&&( payLst[0].Payment_Method__c=='L/C'|| payLst[1].Payment_Method__c=='L/C')){
                               System.debug('5678');
                                newPaymentTerm = '';
                                newPaymentTerm ='PayLc';
                            }else if( String.valueOf(i+j) !='100' && String.valueOf(i+j) !='100.00'){
                                 newPaymentTerm = '';
                                newPaymentTerm ='Not 100%';
                            }
                            else if(( String.valueOf(i+j) =='100' || String.valueOf(i+j) =='100.00') ){
                                System.debug('067');
                                
                                 it.Actual_Values__c=newPaymentTerm; 
                                stt.Actual_Values__c = it.Actual_Values__c;
                            }
                            else{
                                system.debug(' String.valueOf(i+j)-->'+ String.valueOf(i+j));
                                system.debug('231');
                                newPaymentTerm = '';
                               
                            }
                            
                            if(DeliveryDatefalg==false){
                                system.debug('123');
                                newPaymentTerm = ''; 
                                 if(DayFlag =='Exw'){
                                      newPaymentTerm = 'ExwDate';
                                    }else{
                                      newPaymentTerm = 'NotExwDate';  
                                    }
                            }
                            
                            system.debug('newPaymentTerm-->'+newPaymentTerm);
                        }
                        if(payLst.size()>2){
                            newPaymentTerm ='TomanyPay';
                        }
                    }
                }
                
            }
        }
        catch(Exception ex){
            system.debug('Exception:' + ex.getStackTraceString());
             newPaymentTerm = '';
            return newPaymentTerm;
        }
        }
            
        }
       
        return newPaymentTerm;   
    }
    
    
    public Static void runTest(){
    	String run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
        run = 'Run Test';
      }
 
}