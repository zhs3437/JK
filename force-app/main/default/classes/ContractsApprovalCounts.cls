global class ContractsApprovalCounts {
   webservice static String ClickPriceApproval(String oppid){
        
        ContractsApprovalCounts.Addaction(oppid);
        return null;
    }
    
    public static void Addaction(String oppid){
         Contract con = [Select id,ApprovalCounts__c,DocumentID__c,Approval_Status__c,Commission__c,Expect_Price_and_Comments__c,Total_MW__c,Total_Price__c,Total_Quantity__c,Trade_Term__c,Destination_Country__c,Seller__c from Contract where id =:oppid];
        List<Product_Detail__c> ConlineLst = [Select Id,Total_MW__c,Junction_Box_Type__c,Unit_Price__c,Guaranteed_Delivery_Date__c,Total_Price__c,Quantity__c,UnitPrice__c,Product__c,Delivery_Date__c from Product_Detail__c where Contract_PO_PI__c =:oppid];
        List<Payment__c> payLst = [select id,Amount__c,Percentage__c,Down_Balance_Payment__c,Payment_Method__c,Days__c,Payment_Term__c,Contract__c from Payment__c where Contract__c =:oppid ];
        string documentId ='';
        Folder f =new Folder();
        f = [select id,Name from Folder where Name=:'ConDiffTemplate' limit 1];
        system.debug('f.id-->'+f.id);
        system.debug('f.Name-->'+f.Name);
        if(con !=null){
            String counts = String.valueOf(con.ApprovalCounts__c);
            if(con.ApprovalCounts__c==0 || String.isEmpty(counts)){
                con.ApprovalCounts__c =0;
                string resultObject2Json = Contracts2JSON.Object2Json(con.Id);
                string tempFolderId = f.id;
                //  test saveAsDocument
                Document doc = Contracts2JSON.saveAsDocument(tempFolderId,resultObject2Json); 
                system.debug('doc====:'+doc); //sam
                documentId = doc.Id;
                
            }
            if( con.ApprovalCounts__c >0){
                
                documentId = con.DocumentID__c;
                system.debug('documentId-->'+documentId);
                            
                //  User loadDocument
                String resultLoadDocument = Contracts2JSON.loadDocument(documentId);
                system.debug('resultLoadDocument--->'+resultLoadDocument);
                string jsonContent = resultLoadDocument;
                Contract resultJson2ObjectOld = Contracts2JSON.Json2Object(jsonContent); 
                system.debug('resultJson2ObjectOld--->'+resultJson2ObjectOld);
              //  System.debug(' resultJson2ObjectOld.Payment__r.size()'+ resultJson2ObjectOld.Payment__r.size());
                //插入一条合同差异数据
                
                Contract_Difference_Detail__c  ConDiff = new Contract_Difference_Detail__c();
                ConDiff.Contract__c = con.Id;
                ConDiff.Total_MW_New__c = con.Total_MW__c;
                ConDiff.Total_Price_New__c = con.Total_Price__c;
                ConDiff.Total_Quantity_New__c = con.Total_Quantity__c ;
                ConDiff.Total_MW_Old__c =  resultJson2ObjectOld.Total_MW__c;
                ConDiff.Total_Price_Old__c = resultJson2ObjectOld.Total_Price__c ;
                ConDiff.Total_Quantity_Old__c = resultJson2ObjectOld.Total_Quantity__c;
                ConDiff.ApprovalNumbers__c  = String.valueOf(con.ApprovalCounts__c);
                ConDiff.Trade_Term_After__c = con.Trade_Term__c;
                ConDiff.Seller_After__c = con.Seller__c;
                ConDiff.Commision_After__c = con.Commission__c;
                ConDiff.Destination_Country_After__c = con.Destination_Country__c;
                ConDiff.Expect_Price_and_Comments_After__c = con.Expect_Price_and_Comments__c;
                ConDiff.Trade_Term_Before__c = resultJson2ObjectOld.Trade_Term__c;
                ConDiff.Seller_Before__c = resultJson2ObjectOld.Seller__c;
                ConDiff.Commision_Before__c = resultJson2ObjectOld.Commision__c;
                ConDiff.Destination_Country_Before__c = resultJson2ObjectOld.Destination_Country__c;
                ConDiff.Expect_Price_and_Comments_Before__c = resultJson2ObjectOld.Expect_Price_and_Comments__c;
                
                insert ConDiff;
                //插入业务机会下的产品差异数据
                Integer falg =0;
                List<ContractLineItem_Difference_Detail__c> ConLinDiffLst = new  List<ContractLineItem_Difference_Detail__c>();
                system.debug('resultJson2ObjectOld.Product_Detail__r'+resultJson2ObjectOld.Product_Detail__r);
                for(Product_Detail__c ConLineItemOld : resultJson2ObjectOld.Product_Detail__r){
                    falg = 0;
                    for(Product_Detail__c ConLineItemNew : ConlineLst){
                        if(ConLineItemOld.Id == ConLineItemNew.Id){
                            ContractLineItem_Difference_Detail__c ConLinDiff = new ContractLineItem_Difference_Detail__c();
                            ConLinDiff.Contract_Difference_Detail__c = ConDiff.Id;
                            ConLinDiff.ProductName__c = ConLineItemNew.Product__c;
                            ConLinDiff.ApprovalNumbers__c =String.valueof(con.ApprovalCounts__c);
                            ConLinDiff.Quantity_New__c = ConLineItemNew.Quantity__c;
                            ConLinDiff.Total_MW_New__c =  ConLineItemNew.Total_MW__c;
                            ConLinDiff.Total_Price_New__c = ConLineItemNew.Total_Price__c;
                            ConLinDiff.UnitPrice_New__c =  ConLineItemNew.Unit_Price__c;
                            ConLinDiff.Type_of_module_After__c = ConLineItemNew.Junction_Box_Type__c;
                            ConLinDiff.Guaranteed_Delivery_Date_After__c = ConLineItemNew.Guaranteed_Delivery_Date__c; 
                            ConLinDiff.Type_of_module_Before__c = ConLineItemOld.Junction_Box_Type__c;
                            ConLinDiff.Guaranteed_Delivery_Date_Before__c = ConLineItemOld.Guaranteed_Delivery_Date__c;
                            ConLinDiff.Quantity_Old__c = ConLineItemOld.Quantity__c;
                            ConLinDiff.Total_MW_Old__c = ConLineItemOld.Total_MW__c;
                            ConLinDiff.Total_Price_Old__c = ConLineItemOld.Total_Price__c;
                            ConLinDiff.UnitPrice_Old__c = ConLineItemOld.Unit_Price__c;
                            ConLinDiffLst.add(ConLinDiff);
                            falg = falg +1;
                        }
                    }
                    if(falg ==0){
                        ContractLineItem_Difference_Detail__c ConLinDiff = new ContractLineItem_Difference_Detail__c();
                        ConLinDiff.Contract_Difference_Detail__c = ConDiff.Id;
                        ConLinDiff.ProductName__c = ConLineItemOld.Product__c;
                        ConLinDiff.ApprovalNumbers__c =String.valueof(con.ApprovalCounts__c);
                        ConLinDiff.Quantity_Old__c =ConLineItemOld.Quantity__c;
                        ConLinDiff.Total_MW_Old__c =  ConLineItemOld.Total_MW__c;
                        ConLinDiff.Total_Price_Old__c = ConLineItemOld.Total_Price__c;
                        ConLinDiff.UnitPrice_Old__c =  ConLineItemOld.Unit_Price__c;
                        ConLinDiff.Type_of_module_Before__c = ConLineItemOld.Junction_Box_Type__c;
                        ConLinDiff.Guaranteed_Delivery_Date_Before__c = ConLineItemOld.Guaranteed_Delivery_Date__c;
                        system.debug('111');
                        ConLinDiffLst.add(ConLinDiff);
                    }
                }
                
                
                
                             //
                for(Product_Detail__c ConLineItemNew : ConlineLst){
                    falg = 0;
                    for(Product_Detail__c ConLineItemOld : resultJson2ObjectOld.Product_Detail__r){
                        if(ConLineItemOld.Id == ConLineItemNew.Id){
                            falg = falg +1;  
                        }
                    }
                    if(falg ==0){
                        ContractLineItem_Difference_Detail__c ConLinDiff = new ContractLineItem_Difference_Detail__c();
                        ConLinDiff.Contract_Difference_Detail__c = ConDiff.Id;
                        ConLinDiff.ProductName__c = ConLineItemNew.Product__c;
                        ConLinDiff.ApprovalNumbers__c =String.valueof(con.ApprovalCounts__c);
                        ConLinDiff.Quantity_New__c = ConLineItemNew.Quantity__c;
                        ConLinDiff.Total_MW_New__c =  ConLineItemNew.Total_MW__c;
                        ConLinDiff.Total_Price_New__c =  ConLineItemNew.Total_Price__c;
                        ConLinDiff.UnitPrice_New__c = ConLineItemNew.Unit_Price__c;
                        ConLinDiff.Type_of_module_After__c = ConLineItemNew.Junction_Box_Type__c;
                        ConLinDiff.Guaranteed_Delivery_Date_After__c = ConLineItemNew.Guaranteed_Delivery_Date__c;
                        system.debug('111');
                        ConLinDiffLst.add(ConLinDiff);
                    }
                }
                if(ConLinDiffLst.size()>0)insert ConLinDiffLst;
                
                                //插入业务机会下的付款方式数据
                List<Contract_Payment_Difference__c> paydiffLst = new  List<Contract_Payment_Difference__c>();
                for(Payment__c payOld : resultJson2ObjectOld.Payment__r){
                    falg = 0;
                    for(Payment__c payNew : payLst){
                        if(payNew.Id == payOld.Id){
                            Contract_Payment_Difference__c paydiff =new Contract_Payment_Difference__c();
                            paydiff.Contract_Difference_Detail__c = ConDiff.Id;
                            paydiff.ApprovalNumbers__c =String.valueof(con.ApprovalCounts__c);
                            paydiff.Amount_New__c =payNew.Amount__c;
                            paydiff.Days_New__c = payNew.Days__c;
                            paydiff.Down_Balance_Payment_After__c = payNew.Down_Balance_Payment__c;
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
                        Contract_Payment_Difference__c paydiff =new Contract_Payment_Difference__c();
                        paydiff.Contract_Difference_Detail__c = ConDiff.Id;
                        paydiff.ApprovalNumbers__c =String.valueof(con.ApprovalCounts__c);
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
                        Contract_Payment_Difference__c paydiff =new Contract_Payment_Difference__c();
                        paydiff.Contract_Difference_Detail__c = ConDiff.Id;
                        paydiff.ApprovalNumbers__c =String.valueof(con.ApprovalCounts__c);
                        paydiff.Amount_New__c = payNew.Amount__c;
                        paydiff.Days_New__c = payNew.Days__c;
                        paydiff.Down_Balance_Payment_After__c = payNew.Down_Balance_Payment__c;
                        paydiff.Payment_Method_New__c = payNew.Payment_Method__c;
                        paydiff.Payment_Term_New__c = payNew.Payment_Term__c;
                        paydiff.Percentage_New__c  = payNew.Percentage__c;
                        system.debug('111');
                        paydiffLst.add(paydiff);
                    }
                }
                if(paydiffLst.size()>0)insert paydiffLst;
                
                
                string resultObject2Json = Contracts2JSON.Object2Json(con.Id);
                string tempFolderId = f.id;
                //  test saveAsDocument
                system.debug('resultObject2Json'+resultObject2Json);
                Document doc = Contracts2JSON.saveAsDocument(tempFolderId,resultObject2Json);
                documentId = doc.Id;
                system.debug('OppDiff.Id--->'+ConDiff.Id);
                // SendEmailUtils.sendToSomeOneId(OppDiff.Id,'0059000000126GD', 'test_sgy');
                //SendEmailUtils.sendToSomeOneId(opp.Id,'0059000000126GD', 'SendEmailToFraniceCharliy');
            }
            
            
            con.ApprovalCounts__c =  con.ApprovalCounts__c +1;
            con.ApprovalCountsTime__c =datetime.now();
            con.DocumentID__c  =  documentId;
            update con;
            
        }
        
    }
    
}