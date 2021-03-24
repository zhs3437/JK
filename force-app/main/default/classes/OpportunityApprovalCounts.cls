global class  OpportunityApprovalCounts {
    webservice static String ClickPriceApproval(String oppid){
        
        OpportunityApprovalCounts.Addaction(oppid);
        return null;
    }
    
    public static void Addaction(String oppid){
         Opportunity opp = [Select id,ApprovalNumbers__c,ApprovalCountsTime__c,DocumentID__c,Total_MW__c,Total_Power__c,Total_Price__c,Total_Quantity__c,Trade_Term__c,Destination_Country__c,Seller__c,Commision__c,Expect_Price_and_Comments__c from Opportunity where id =:oppid];
        List<OpportunityLineItem> OpplineLst = [Select Id,Total_MW__c,Total_Power_W__c,Total_Price__c,Quantity,UnitPrice,OpportunityId,Product2Id,Type_of_module__c,Guaranteed_Delivery_Date__c from OpportunityLineItem where OpportunityId =:oppid];
        List<Payment__c> payLst = [select id,Amount__c,Percentage__c,Down_Balance_Payment__c,Payment_Method__c,Days__c,Payment_Term__c,Opportunity__c from Payment__c where Opportunity__c =:oppid ];
        string documentId ='';
        Folder f =new Folder();
        f = [select id,Name from Folder where Name=:'OppDiffTemplate' limit 1];
        system.debug('f.id-->'+f.id);
        system.debug('f.Name-->'+f.Name);
        if(opp !=null){
            String counts = String.valueOf(opp.ApprovalNumbers__c);
            if(opp.ApprovalNumbers__c==0 || String.isEmpty(counts)){
                opp.ApprovalNumbers__c =0;
                string resultObject2Json = Opportunity2JSON.Object2Json(opp.Id);
                string tempFolderId = f.id;
                //  test saveAsDocument
                Document doc = Opportunity2JSON.saveAsDocument(tempFolderId,resultObject2Json); 
                system.debug('doc====:'+doc); //sam
                documentId = doc.Id;
                
            }
            if( opp.ApprovalNumbers__c >0){
                
                documentId = opp.DocumentID__c;
                system.debug('documentId-->'+documentId);
                
                //  User loadDocument
                String resultLoadDocument = Opportunity2JSON.loadDocument(documentId);
                string jsonContent = resultLoadDocument;
                Opportunity resultJson2ObjectOld = Opportunity2JSON.Json2Object(jsonContent); 
                system.debug('resultJson2ObjectOld--->'+resultJson2ObjectOld);
                System.debug(' resultJson2ObjectOld.OpportunityLineItems.size()'+ resultJson2ObjectOld.OpportunityLineItems.size());
                System.debug(' resultJson2ObjectOld.Payment__r.size()'+ resultJson2ObjectOld.Payment__r.size());
                //插入一条业务机会差异数据
                
                Opportunity_Differences__c  OppDiff = new Opportunity_Differences__c();
                OppDiff.Opportunity__c = opp.Id;
                
                OppDiff.Opp_Total_MW_New__c = opp.Total_MW__c;
                OppDiff.Opp_Total_Power_New__c =opp.Total_Power__c;
                OppDiff.Opp_Total_Price_New__c = opp.Total_Price__c;
                OppDiff.Opp_Total_Quantity_New__c = opp.Total_Quantity__c ;
                OppDiff.Opp_Total_MW_Old__c =  resultJson2ObjectOld.Total_MW__c;
                OppDiff.Opp_Total_Power_Old__c = resultJson2ObjectOld.Total_Power__c ;
                OppDiff.Opp_Total_Price_Old__c = resultJson2ObjectOld.Total_Price__c ;
                OppDiff.Opp_Total_Quantity_Old__c = resultJson2ObjectOld.Total_Quantity__c;
                OppDiff.ApprovalNumbers__c  = String.valueOf(opp.ApprovalNumbers__c);
                OppDiff.Trade_Term_After__c = opp.Trade_Term__c;
                OppDiff.Seller_After__c = opp.Seller__c;
                OppDiff.Commision_After__c = opp.Commision__c;
                OppDiff.Destination_Country_After__c = opp.Destination_Country__c;
                OppDiff.Expect_Price_and_Comments_After__c = opp.Expect_Price_and_Comments__c;
                OppDiff.Trade_Term_Before__c = resultJson2ObjectOld.Trade_Term__c;
                OppDiff.Seller_Before__c = resultJson2ObjectOld.Seller__c;
                OppDiff.Commision_Before__c = resultJson2ObjectOld.Commision__c;
                OppDiff.Destination_Country_Before__c = resultJson2ObjectOld.Destination_Country__c;
                OppDiff.Expect_Price_and_Comments_Before__c = resultJson2ObjectOld.Expect_Price_and_Comments__c;
                
                insert OppDiff;
                //插入业务机会下的产品差异数据
                
                Integer falg =0;
                List<OpportunityLineItem_Difference__c> OppLinDiffLst = new  List<OpportunityLineItem_Difference__c>();
                for(OpportunityLineItem oppLineItemOld : resultJson2ObjectOld.OpportunityLineItems){
                    falg = 0;
                    for(OpportunityLineItem oppLineItemNew : OpplineLst){
                        if(oppLineItemOld.Id == oppLineItemNew.Id){
                            OpportunityLineItem_Difference__c OppLinDiff = new OpportunityLineItem_Difference__c();
                            OppLinDiff.Opportunity_Difference__c = OppDiff.Id;
                            OppLinDiff.ProductName__c = oppLineItemNew.Product2Id;
                            OppLinDiff.ApprovalNumbers__c =String.valueof(opp.ApprovalNumbers__c);
                            OppLinDiff.Quantity_New__c = oppLineItemNew.Quantity;
                            OppLinDiff.Total_MW_New__c =  oppLineItemNew.Total_MW__c;
                            OppLinDiff.Total_Price_New__c = oppLineItemNew.Total_Price__c;
                            OppLinDiff.UnitPrice_New__c =  oppLineItemNew.UnitPrice;
                            OppLinDiff.Type_of_module_After__c = oppLineItemNew.Type_of_module__c;
                            OppLinDiff.Guaranteed_Delivery_Date_After__c = oppLineItemNew.Guaranteed_Delivery_Date__c; 
                            OppLinDiff.Type_of_module_Before__c = oppLineItemOld.Type_of_module__c;
                            OppLinDiff.Guaranteed_Delivery_Date_Before__c = oppLineItemOld.Guaranteed_Delivery_Date__c;
                            OppLinDiff.Quantity_Old__c = oppLineItemOld.Quantity;
                            OppLinDiff.Total_MW_Old__c = oppLineItemOld.Total_MW__c;
                            OppLinDiff.Total_Price_Old__c = oppLineItemOld.Total_Price__c;
                            OppLinDiff.UnitPrice_Old__c = oppLineItemOld.UnitPrice;
                            OppLinDiffLst.add(OppLinDiff);
                            falg = falg +1;
                        }
                    }
                    if(falg ==0){
                        OpportunityLineItem_Difference__c OppLinDiff = new OpportunityLineItem_Difference__c();
                        OppLinDiff.Opportunity_Difference__c = OppDiff.Id;
                        OppLinDiff.ProductName__c = oppLineItemOld.Product2Id;
                        OppLinDiff.ApprovalNumbers__c =String.valueof(opp.ApprovalNumbers__c);
                        OppLinDiff.Quantity_Old__c =oppLineItemOld.Quantity;
                        OppLinDiff.Total_MW_Old__c =  oppLineItemOld.Total_MW__c;
                        OppLinDiff.Total_Price_Old__c = oppLineItemOld.Total_Price__c;
                        OppLinDiff.UnitPrice_Old__c =  oppLineItemOld.UnitPrice;
                        OppLinDiff.Type_of_module_Before__c = oppLineItemOld.Type_of_module__c;
                        OppLinDiff.Guaranteed_Delivery_Date_Before__c = oppLineItemOld.Guaranteed_Delivery_Date__c;
                        system.debug('111');
                        OppLinDiffLst.add(OppLinDiff);
                    }
                }
                //
                for(OpportunityLineItem oppLineItemNew : OpplineLst){
                    falg = 0;
                    for(OpportunityLineItem oppLineItemOld : resultJson2ObjectOld.OpportunityLineItems){
                        if(oppLineItemOld.Id == oppLineItemNew.Id){
                            falg = falg +1;  
                        }
                    }
                    if(falg ==0){
                        OpportunityLineItem_Difference__c OppLinDiff = new OpportunityLineItem_Difference__c();
                        OppLinDiff.Opportunity_Difference__c = OppDiff.Id;
                        OppLinDiff.ProductName__c = oppLineItemNew.Product2Id;
                        OppLinDiff.ApprovalNumbers__c =String.valueof(opp.ApprovalNumbers__c);
                        OppLinDiff.Quantity_New__c = oppLineItemNew.Quantity;
                        OppLinDiff.Total_MW_New__c =  oppLineItemNew.Total_MW__c;
                        OppLinDiff.Total_Price_New__c =  oppLineItemNew.Total_Price__c;
                        OppLinDiff.UnitPrice_New__c = oppLineItemNew.UnitPrice;
                        OppLinDiff.Type_of_module_After__c = oppLineItemNew.Type_of_module__c;
                        OppLinDiff.Guaranteed_Delivery_Date_After__c = oppLineItemNew.Guaranteed_Delivery_Date__c;
                        system.debug('111');
                        OppLinDiffLst.add(OppLinDiff);
                    }
                }
                if(OppLinDiffLst.size()>0)insert OppLinDiffLst;
                
                //插入业务机会下的付款方式数据
                List<PaymentDifference__c> paydiffLst = new  List<PaymentDifference__c>();
                for(Payment__c payOld : resultJson2ObjectOld.Payment__r){
                    falg = 0;
                    for(Payment__c payNew : payLst){
                        if(payNew.Id == payOld.Id){
                            PaymentDifference__c paydiff =new PaymentDifference__c();
                            paydiff.Opportunity_Difference__c = OppDiff.Id;
                            paydiff.ApprovalNumbers__c =String.valueof(opp.ApprovalNumbers__c);
                            paydiff.Amount_New__c =payNew.Amount__c;
                            paydiff.Days_New__c = payNew.Days__c;
                            paydiff.Down_Balance_Payment_New__c = payNew.Down_Balance_Payment__c;
                            paydiff.Payment_Method_New__c = payNew.Payment_Method__c;
                            paydiff.Payment_Term_New__c = payNew.Payment_Term__c;
                            paydiff.Percentage_New__c  = payNew.Percentage__c;
                            paydiff.Amount_Old__c = payOld.Amount__c;
                            paydiff.Days_Old__c = payOld.Days__c;
                            paydiff.Down_Balance_Payment_Old__c = payOld.Down_Balance_Payment__c;
                            paydiff.Payment_Method_Old__c = payOld.Payment_Method__c;
                            paydiff.Payment_Term_Old__c = payOld.Payment_Term__c;
                            paydiff.Percentage_Old__c =payOld.Percentage__c;
                            paydiffLst.add(paydiff);
                            falg = falg +1;
                        }
                    }
                    if(falg ==0){
                        PaymentDifference__c paydiff =new PaymentDifference__c();
                        paydiff.Opportunity_Difference__c = OppDiff.Id;
                        paydiff.ApprovalNumbers__c =String.valueof(opp.ApprovalNumbers__c);
                        paydiff.Amount_Old__c = payOld.Amount__c;
                        paydiff.Days_Old__c = payOld.Days__c;
                        paydiff.Down_Balance_Payment_Old__c = payOld.Down_Balance_Payment__c;
                        paydiff.Payment_Method_Old__c = payOld.Payment_Method__c;
                        paydiff.Payment_Term_Old__c = payOld.Payment_Term__c;
                        paydiff.Percentage_Old__c = payOld.Percentage__c;
                        paydiffLst.add(paydiff);
                    }
                }
                for(Payment__c payNew : payLst){
                    falg = 0;
                    for(Payment__c payOld : resultJson2ObjectOld.Payment__r){
                        if(payOld.Id == payNew.Id){
                            falg = falg +1;  
                        }
                    }
                    if(falg ==0){
                        PaymentDifference__c paydiff =new PaymentDifference__c();
                        paydiff.Opportunity_Difference__c = OppDiff.Id;
                        paydiff.ApprovalNumbers__c =String.valueof(opp.ApprovalNumbers__c);
                        paydiff.Amount_New__c = payNew.Amount__c;
                        paydiff.Days_New__c = payNew.Days__c;
                        paydiff.Down_Balance_Payment_New__c = payNew.Down_Balance_Payment__c;
                        paydiff.Payment_Method_New__c = payNew.Payment_Method__c;
                        paydiff.Payment_Term_New__c = payNew.Payment_Term__c;
                        paydiff.Percentage_New__c  = payNew.Percentage__c;
                        system.debug('111');
                        paydiffLst.add(paydiff);
                    }
                }
                if(paydiffLst.size()>0)insert paydiffLst;
                
                
                string resultObject2Json = Opportunity2JSON.Object2Json(opp.Id);
                string tempFolderId = f.id;
                //  test saveAsDocument
                system.debug('resultObject2Json'+resultObject2Json);
                Document doc = Opportunity2JSON.saveAsDocument(tempFolderId,resultObject2Json);
                documentId = doc.Id;
                system.debug('OppDiff.Id--->'+OppDiff.Id);
                // SendEmailUtils.sendToSomeOneId(OppDiff.Id,'0059000000126GD', 'test_sgy');
                //SendEmailUtils.sendToSomeOneId(opp.Id,'0059000000126GD', 'SendEmailToFraniceCharliy');
            }
            
            
            opp.ApprovalNumbers__c =  opp.ApprovalNumbers__c +1;
            opp.ApprovalCountsTime__c =datetime.now();
            opp.DocumentID__c  =  documentId;
            update opp;
            
        }
        
    }
    
}