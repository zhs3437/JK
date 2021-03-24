global class InterCompanyCreate {
    
   webservice static string onCreateInterCompany (string id){
        Contract con;
        Opportunity op;
         
        Contract ConCopy;
        Opportunity OppCopy;
        
        try{
            con = [select con.AccountId , con.id, con.Contract_NO__c, con.Opportunity__c, con.RecordTypeId, 
			            con.Payment_Term_Description__c, con.ContractTerm, con.Status,con.Destination__c,con.JINKO_OEM__c,
			            con.BillingCity,con.BillingCountry,con.BillingPostalCode,con.BillingState,con.BillingStreet,
			            con.Supply_By__c, con.Factory__c,con.ShippingCity,con.Bonded_Material_Name__c,con.Expected_EXW_Date__c,
			            con.Expected_Delivery_Date__c,con.Delivery_Date_Remark__c,con.Delivery_Date__c,con.Trade_term__c,
			            con.StartDate, con.PO_Remarks_1__c,con.PO_Remarks_2__c,con.SELLER__c,con.BuyerAccount__c,
			            con.PO_Remarks_3__c,con.PO_Remarks_4__c,con.PO_Remarks_5__c 
            		from Contract con where con.Id =: id];
             op = [select id, Name,StageName,CloseDate,
                			AccountId,CurrencyIsoCode,
                			Payment_Method__c,Shipping_Address__c 
        				from Opportunity 
        				where id=: con.Opportunity__c];
                OppCopy = op.clone(false,false,false,false);
                OppCopy.Name = op.Name;
                OppCopy.StageName = op.StageName;
                OppCopy.CloseDate = op.CloseDate;
                OppCopy.AccountId = op.AccountId;
                OppCopy.CurrencyIsoCode = op.CurrencyIsoCode;
                OppCopy.Payment_Method__c = op.Payment_Method__c;
                OppCopy.Use_For__c = 'InterCompany Contract';
                OppCopy.Shipping_Address__c = op.Shipping_Address__c;
                insert OppCopy;            
            //RecordType rt = [select r.Name, r.Id From RecordType r Where r.Name ='Intercompany Contract'];
            ID IntercompanyRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Intercompany Contract').getRecordTypeId();
            //if(con.RecordTypeId == '012O00000000f63'){
            //复制合同
                ConCopy = con.clone(false,false,false,false);
                ConCopy.Contract_NO__c = con.Contract_NO__c + '-INXX';
                system.debug('^^^^^^^^^^^^^' + ConCopy.Contract_NO__c);
                //ConCopy.Payment_Term_Description__c = '';
                ConCopy.ContractTerm = 1;
                ConCopy.Status = 'Draft';
                ConCopy.StartDate = System.Today();
                ConCopy.PO_Remarks_1__c = system.label.Term1;
                ConCopy.PO_Remarks_2__c = system.label.Term2;
                ConCopy.PO_Remarks_3__c = system.label.Term3;
                ConCopy.PO_Remarks_4__c = system.label.Term4;
                ConCopy.PO_Remarks_5__c = system.label.Term5;
                ConCopy.Parent_Contract__c = con.id;
                ConCopy.Payment_Term_Description__c = '100% of the total amount shall be paid by T/T within 90 days after date of shipment';
                ConCopy.RecordTypeId = IntercompanyRecordTypeId;
                ConCopy.Trade_term__c = con.Trade_term__c;
                //ConCopy.Destination = con.Destination__c;
                ConCopy.JINKO_OEM__c = con.JINKO_OEM__c;
                ConCopy.BillingCity = con.BillingCity;
                ConCopy.BillingCountry = con.BillingCountry;
                ConCopy.BillingPostalCode = con.BillingPostalCode;
                ConCopy.BillingState = con.BillingState;
                ConCopy.BillingStreet = con.BillingStreet;
                ConCopy.Supply_By__c = con.Supply_By__c;
                ConCopy.Factory__c = con.Factory__c;
                ConCopy.ShippingCity = con.ShippingCity;
                // remove by jason 2016413  ConCopy.SELLER__c = con.SELLER__c;
                ConCopy.BuyerAccount__c =  con.BuyerAccount__c;
                //ConCopy.Bonded_Material_Name__c = con.Bonded_Material_Name__c;
                ConCopy.Expected_EXW_Date__c = con.Expected_EXW_Date__c;
                ConCopy.Expected_Delivery_Date__c = con.Expected_Delivery_Date__c;
                ConCopy.Delivery_Date_Remark__c = con.Delivery_Date_Remark__c;
                ConCopy.Delivery_Date__c = con.Delivery_Date__c;
                ConCopy.Opportunity__c = OppCopy.id;
                insert ConCopy;
                
                Product_Detail__c[] pds = [Select p.Unit_WM__c, p.Unit_Price__c, p.Total_Price__c, p.Total_MW__c, 
									                p.Tolerance__c, p.Tempered_glass__c, 
									                p.Technical_Requirement__c, p.SystemModstamp, 
									                p.Spec__c, p.Solar_Cell__c, p.Serial_No__c, 
									                p.SAP_Product_Id__c, p.Ribbon__c, p.Quantity__c, 
									                p.Production_Description__c, p.Product__c, p.Product_Name__c, 
									                p.Package__c, p.Others__c, p.Name, p.Maximum_Power_at_STC_Pmax_Wp__c, 
									                p.Marks__c, p.LastModifiedDate, p.LastModifiedById, p.Label__c, 
									                p.Junction_Box__c, p.IsDeleted, p.Insurance_Price__c, p.Id, p.Freight_Price__c,
									                p.Frame__c, p.Frame_Color__c, p.EVA__c, p.CurrencyIsoCode, p.CreatedDate,
									                p.CreatedById, p.Contract_PO_PI__c, p.Cell_Appearance__c, 
									                p.Cable_Length__c, p.Back_Sheet__c 
									        From Product_Detail__c p
							                WHERE Contract_PO_PI__c =: con.Id];
                
                List<Product_Detail__c> pdsCopy = new List<Product_Detail__c>();
                
                for( Product_Detail__c p : pds ){
                    Product_Detail__c newp =  p.clone(false,false,true,false);
                    newp.Contract_PO_PI__c = ConCopy.id;
                    newp.Unit_Price__c = p.Unit_Price__c;
                    pdsCopy.add( newp  );
                }
                insert pdsCopy;
                return ConCopy.id;
                

        }catch(Exception e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
            return e.getStackTraceString();
        }
        
   }
   webservice static string onCreateInterCompanyStep2 (string id,String id2){
        Contract con;
        Opportunity op;
         
        Contract ConCopy;
        Opportunity OppCopy;
        try{
            ConCopy = [select con.AccountId , con.id, con.Contract_NO__c, con.Opportunity__c, con.RecordTypeId, 
			            con.Payment_Term_Description__c, con.ContractTerm, con.Status,con.Destination__c,con.JINKO_OEM__c,
			            con.BillingCity,con.BillingCountry,con.BillingPostalCode,con.BillingState,con.BillingStreet,
			            con.Supply_By__c, con.Factory__c,con.ShippingCity,con.Bonded_Material_Name__c,con.Expected_EXW_Date__c,
			            con.Expected_Delivery_Date__c,con.Delivery_Date_Remark__c,con.Delivery_Date__c,con.Trade_term__c,
			            con.StartDate, con.PO_Remarks_1__c,con.PO_Remarks_2__c,con.SELLER__c,con.BuyerAccount__c,
			            con.PO_Remarks_3__c,con.PO_Remarks_4__c,con.PO_Remarks_5__c 
            		from Contract con where con.Id =: id];
                //插入业务机会
                OppCopy = [select id, Name,StageName,CloseDate,
                			AccountId,CurrencyIsoCode,
                			Payment_Method__c,Shipping_Address__c 
        				from Opportunity 
        				where id=: ConCopy.Opportunity__c];

               Contract con2 = [select Opportunity__c
            		from Contract  where Id =: id2];
                
                //插入业务机会产品条目
                
                OpportunityLineItem[] opls = [Select o.id, o.isJinkoStandard__c, o.UnitPrice, o.Total_Price__c, o.Total_Power_W__c, 
								                o.TotalPrice, o.Tolerance__c, o.Guaranteed_Delivery_Date__c,o.Temperd_Glass__c, o.SystemModstamp, o.Subtotal_Pmax__c, 
								                o.SortOrder, o.Solar_Cell__c, o.ServiceDate, o.Serial_No__c, o.Ribbon__c, o.Quantity, 
								                o.PricebookEntryId, o.Power_W__c, o.Package__c, o.Others__c, o.OpportunityId, 
								                o.Module_size__c, o.ListPrice, o.LastModifiedDate, o.LastModifiedById, o.Label__c, 
								                o.Junction_Box__c, o.IsDeleted, o.Frame__c, o.Frame_Color__c, o.EVA__c, o.Description, 
								                o.CurrencyIsoCode, o.CreatedDate, o.CreatedById,  o.Comment__c, 
								                o.Cell_Appearance__c, o.Cable_Length__c, o.Back_Sheet__c,o.Battery_Line__c, o.Battery_Type__c,
								                o.Junction_Box_Type__c, o.Wire_Length__c ,o.Junction_Box_Brand__c  
							                	From OpportunityLineItem o 
                							  	where o.opportunityid =: con2.Opportunity__c ];
                
                List<OpportunityLineItem> copyolst = new List<OpportunityLineItem>();
                //循环插入产品
                for( OpportunityLineItem olst : opls ){
                    OpportunityLineItem newols =  new OpportunityLineItem();
                    //newols.OpportunityId = op.id;
                    //newols.Total_Price__c = 0;
                    //newols.UnitPrice = olst.UnitPrice;
                    //newols.Quantity = olst.Quantity;
                    newols.OpportunityId = OppCopy.Id;
                    newols.Guaranteed_Delivery_Date__c =olst.Guaranteed_Delivery_Date__c;
                    newols.UnitPrice = olst.UnitPrice;
                    newols.Quantity = olst.Quantity;
                    newols.PricebookEntryId = olst.PricebookEntryId;
                    newols.PricebookEntryId = olst.PricebookEntryId;
                    
                    copyolst.add( newols  );
                }
                insert copyolst;
                //返回新插入的合同界面
                return ConCopy.id;
        }catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
        }
        return '';
    }
    
}