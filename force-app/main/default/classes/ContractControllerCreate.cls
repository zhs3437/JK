public class ContractControllerCreate {
    
    public Contract con{get;set;}
    public Opportunity op{get;set;}
    public OpportunityLineItem[] opls{get;set;} 
    public String ContractMC{get;set;}
    public String InventoryRecordTypeId{get;set;}
    public String conRecordTypeId{get;set;}

    public ContractControllerCreate(ApexPages.Standardcontroller sd){
            System.debug('################### ContractControllerCreate');
            con = (Contract)sd.getRecord();
            RecordType rt = [Select id,name from RecordType where name=:'Inventory Contract'];
            String p = rt.id+'';
            InventoryRecordTypeId = p.substring(0, 15);
        
            String coR = con.recordTypeId+'';
        system.debug('coR'+coR);
        if(con.recordTypeId!=null){
            conRecordTypeId = coR.substring(0, 15);
        }
system.debug('InventoryRecordTypeId'+InventoryRecordTypeId);
        system.debug('con'+con.recordTypeId);
        System.debug('con信息OPP:'+con.Opportunity__c);
        Opportunity usopp=[select id,RecordTypeId,Sales_Region__c,Region__c,Branch__c,Destination_Country__c,Ownerid,Today__c,Cross_Region__c from Opportunity where id =:con.Opportunity__c];
        // if(usopp.Region__c == 'North Asia' && conRecordTypeId == InventoryRecordTypeId){
        //     con.InventoryArea__c = 'Own inventory';
        // }
        /*if(usopp.Cross_Region__c == true && conRecordTypeId == InventoryRecordTypeId){
            con.InventoryArea__c = 'Other regions';
        }else if(usopp.Cross_Region__c == false && conRecordTypeId == InventoryRecordTypeId){
            con.InventoryArea__c = 'Own inventory';
        }*/

        //查询业务机会下所有产品行项目
      /*  List<OpportunityLineItem> oppItem =[SELECT id,
                                                   Name,
                                                   Opportunity.Id
                                            FROM OpportunityLineItem
                                            WHERE Opportunity.Id = :con.Opportunity__c];

        list<Payment__c> paymentList = [SELECT Percentage__c,
                                                Amount__c,
                                                Down_Balance_Payment__c,
                                                Payment_Method__c,
                                                Days__c,
                                                Payment_Term__c,
                                                PaymentDescription__c,
                                                Opportunity__r.Id
                                        FROM Payment__c
                                        WHERE Opportunity__r.Id = :con.Opportunity__c];

        for (OpportunityLineItem oppLineItem : oppItem) {
            if (oppLineItem.Name == 'epd' ){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'You cannot create Contract when the product name contain "epd"'));
            }
        }

        for (Payment__c payment : paymentList){
            if (payment.Percentage__c == null ||
                    payment.Amount__c == null ||
                    payment.Down_Balance_Payment__c == '' ||
                    payment.Payment_Method__c == '' ||
                    payment.Days__c == null ||
                    payment.Payment_Term__c == '' ||
                    payment.PaymentDescription__c == ''

            ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot create Contract when payment field is null'));
            }
        }


*/








        System.debug('con信息Sales Region:'+usopp.Sales_Region__c);
        System.debug('con信息Owner:'+usopp.Ownerid);
        Date d = Date.newInstance(usopp.Today__c.year(),1,1);
         if(usopp.Today__c.month()<4){
         d = Date.newInstance(usopp.Today__c.year(),1,1);
        }else if(usopp.Today__c.month()<7){
            d = Date.newInstance(usopp.Today__c.year(),4,1);
        }else if(usopp.Today__c.month()<10){
              d = Date.newInstance(usopp.Today__c.year(),7,1);
        }else if(usopp.Today__c.month()<13){
              d = Date.newInstance(usopp.Today__c.year(),10,1);
        }
       
            List<contract>  conlst =new  List<contract>();
        conlst=[select id from contract where ownerid=:usopp.Ownerid and createdDate>=:d];
        User us=[select id,suoxie__c from User where id=:usopp.Ownerid ];
        System.debug('User信息Owner:'+us.id);
            ContractMC='';
        //区域
        if(usopp.Sales_Region__c=='Middle East&Africa'||usopp.Sales_Region__c=='MENA'||usopp.Sales_Region__c=='SSA'){
            ContractMC='MCMA';
        }else if(usopp.Sales_Region__c=='' || usopp.Sales_Region__c == null){
            ContractMC='Service';
        }
        else if(usopp.Sales_Region__c.contains('EU') && usopp.Destination_Country__c!='Germany'){
            ContractMC='MCEU';
                }
        else if(usopp.Sales_Region__c.contains('EU') && usopp.Destination_Country__c=='Germany'){
            ContractMC='MCGE';
                }
        else if(usopp.Sales_Region__c=='North America'){
            ContractMC='MCUS';
                }
        else if(usopp.Sales_Region__c=='Latin America&Italy' && usopp.Destination_Country__c=='Italy'){
            ContractMC='MCIT';
                }
         else if(usopp.Sales_Region__c=='Latin America&Italy'  && usopp.Destination_Country__c!='Italy'){
            ContractMC='MCLA';
                }
         else if(usopp.Sales_Region__c=='North Asia'){
            ContractMC='MCNA';
                }
           else if(usopp.Sales_Region__c=='South Asia'){
            ContractMC='MCSA';
                }
           else if(usopp.Sales_Region__c=='Central Asia'){
            ContractMC='MCCA';
                }
         else if(usopp.Sales_Region__c=='ROA'){
            ContractMC='MCAP';
                }
         else if(usopp.Sales_Region__c=='CN'){
            ContractMC='MCCN';
                }
         else if(usopp.Sales_Region__c=='Key Account'){
            ContractMC='MCKA';
                }
        else{ContractMC='MC??';}
        if(us.suoxie__c==''||us.suoxie__c==null){
            ContractMC=ContractMC+'';
        }else{
            ContractMC=ContractMC+''+us.suoxie__c;
        }
        String year=usopp.Today__c.year()+'';
        String month='';
        if(usopp.Today__c.month()<4){
            month='1';
        }else if(usopp.Today__c.month()<7){
            month='2';
        }else if(usopp.Today__c.month()<10){
            month='3';
        }else if(usopp.Today__c.month()<13){
            month='4';
        }
        ContractMC=ContractMC+year.Substring(2,4)+'Q'+month;
        
        if(conlst==null || conlst.size()==0){
              ContractMC=ContractMC+'001';
        }
        else{
            if(conlst.size()>0 && conlst.size()<10){
              ContractMC=ContractMC+'00'+(conlst.size()+1);
            }else if(conlst.size()>9 && conlst.size()<100){
              ContractMC=ContractMC+'0'+(conlst.size()+1);
            }else{ContractMC=ContractMC+''+(conlst.size()+1);}
        }
        con.Contract_NO__c=ContractMC;
            RecordType rtt = [select r.Name, r.Id From RecordType r Where r.Name ='Intercompany Contract'];
            if(con.RecordTypeId != rtt.Id){
                con.ContractTerm = 1;
                con.Status = 'Draft';
                con.StartDate = System.Today();
                String remark2 = '2. All supplied Goods remain the Seller’s property (reserved property) until the Buyer has paid all outstanding accounts resulting from their business relationships.With regard to processing or manufacturing of the supplied Goods, the Seller shall be deemed to be manufacturer without committing him in any way. The processed or manufactured Goods shall be regarded too as reserved property within the meaning of the above said conditions. If the Buyer manufactures, combines or mixes the supplied Goods with other goods, the Seller shall obtain co-ownership in the new goods in proportion to the invoiced price of the supplied Goods to the invoiced price of the goods of the other sellers. If, by such converting of Goods, the Seller’s ownership expires, the Buyer herewith transfers to the Seller any rights which the Buyer will have in the new stock or goods in proportion of the invoiced price of the supplied Goods, and the Buyer will keep them in safe custody free of charge for the Seller. The Seller’s co-ownership rights shall be regarded as reserved property within the meaning of the above-said conditions.The Buyer may resell the reserved property only within the normal course of his business and only as long as he is not in default of payment. The Buyer shall not be entitled to dispose of the reserved property in any other way.The Buyer hereby assigns to the Seller any claims resulting from the resale of the reserved property. Such claims shall serve as the Seller’s security to the same extent as the reserved property itself. In the case of resale of Goods in which the Seller has co-ownership rights, the assignment shall be limited to the part which corresponds to the Seller’s co-ownership rights.As long as the Seller does not withdraw this right, the Buyer shall be entitled to collect any receivables resulting from the resale of the reserved property. The Seller is entitled to withdraw this right if the Buyer defaults in payment with a significant amount, fails to honour a bill of exchange or files for insolvency proceedings. In this case, the Seller shall be entitled to prohibit the Buyer from reselling, converting the purchased Goods and to take them back. If the Seller takes back the reserved property, this shall not be regarded as withdrawal from the Agreement.';
                String remark1 = '1.Deliveries by Seller are subject only to the following terms and conditions. Any terms and conditions used by Buyer shall not apply. The Goods are Jinko standard modules (Tolerance: -3%~+3%) and shall be covered by Jinko Limited Warranty (as attached hereto) under which (1) 5 years for material defects and workmanship from the Warranty Start Date as defined in Jinko Limited Warranty; (2) 90% rated power output at standard test condition (“STC”) for first 12 years from the Warranty Start Date; and (3) 80% rated power output for years 13 through 25 at STC.The Parties agree that the warranty on material and workmanship of the Goods under this Purchase Agreement shall be extended to 10 years.The Goods shall be subject to Jinko Limited Warranty, provided, however, that Buyer acknowledges and agrees that if (and for as long as) Buyer is in breach of its payment obligations hereunder, Seller shall have no obligation to comply with Jinko Limited Warranty. The express remedies set forth in this Agreement and in Jinko Limited Warranty and provided by Seller are the sole and exclusive remedies for any breach of representation or warranty, and the express warranties provided herein are in lieu of all other warranties express or implied, including, without limitation, any warranty of non-infringement, merchantability or fitness for a particular purpose. Except as expressly provided herein, the Goods are provided “as is”.';
                String Remark9 = '9. Either Party shall be entitled to terminate this Agreement, if the other Party is bankrupt, liquidated or becomes insolvent. Notice shall be given to the other Party of such bankruptcy, liquidation or insolvency within 30 days after such Party is or should be aware of such situation or procedure. However, Seller’s right to claim payment for delivered or manufactured Goods and right to other remedies shall not in any event be prejudiced by termination of this Agreement in accordance with this Section.';
                String Remark10 = '10. Unless this Agreement is terminated by Buyer pursuant to Section 9 above, the Buyer shall purchase all the Goods set forth above and pay the price accordingly, failing of which Buyer shall pay liquidated damages amounting to 15% of the total price of the unrealized quantity without prejudice to Seller’s other remedies under this Agreement.';
                
                con.PO_Remarks_1__c = System.Label.PO_Remark_1_part1 +'\n'+ System.Label.PO_Remarks_1_part2;
                system.debug('*************');
                con.PO_Remarks_2__c = System.Label.PO_Remarks_2_part1 + System.Label.PO_Remarks_2_part2 +'\n'+ System.Label.PO_Remarks_2_part3 + System.Label.PO_Remarks_2_part4;
                con.PO_Remarks_3__c = System.Label.PO_Remarks_3;
                con.PO_Remarks_4__c = System.Label.PO_Remarks_4;
                con.PO_Remarks_5__c = System.Label.PO_Remarks_5;
                con.PO_Remarks_6__c = System.Label.PO_Remarks_6;
                //con.PO_Remarks_7__c = System.Label.PO_Remarks_7;
                con.PO_Remarks_7__c = System.Label.PO_Remarks_7;
                con.PO_Remarks_8__c = System.Label.PO_Remarks_8;
                con.PO_Remarks_9__c = System.Label.PO_Remarks_9;
                con.PO_Remarks_10__c = System.Label.PO_Remarks_10;
                con.PO_Remarks_11__c = System.Label.PO_Remarks_11;
                con.PO_Remarks_12__c = System.Label.PO_Remarks_12;
                 system.debug('*************');
            }else if(con.RecordTypeId == rtt.Id){
                 system.debug('*************');
                con.ContractTerm = 1;
                con.Status = 'Draft';
                con.StartDate = System.Today();
                con.PO_Remarks_1__c = system.label.Term1;
                con.PO_Remarks_2__c = system.label.Term2;
                con.PO_Remarks_3__c = system.label.Term3;
                system.debug('^^^^^^' + system.label.Term3);
                system.debug('^^^^^^' + con.PO_Remarks_3__c);
                
                con.PO_Remarks_4__c = system.label.Term4;
                con.PO_Remarks_5__c = system.label.Term5;
                 system.debug('*************');
            
            }
    }
    
    public PageReference onCreate(){
        system.debug('Start onCreate------>');
       try{
            System.debug('################### PageReference onCreate');
            String oppid;
            op   = CvtOpps2Contract.initOpp(con.Opportunity__c);
            op.Estimated_Gross_Margin_Rate_Old__c = op.Weighted_Gross_Margin_Rate__c;
            op.Estimated_Gross_Margin_Rate_Cheetah_Old__c = op.Weighted_Gross_Margin_Rate_Cheetah__c;
            op.Estimated_Gross_Margin_Rate_Connector_Ol__c = op.Weighted_Gross_Margin_Rate_Connector__c;
            op.Estimated_Gross_Margin_Rate_Smart_Old__c = op.Weighted_Gross_Margin_Rate_Smart__c;
            op.Estimated_Gross_Margin_Rate_Tiger_Pro_ol__c = op.Weighted_Gross_Margin_Rate_TigerPro__c;
            op.Estimated_Gross_Margin_Rate_Tiger_Old__c = op.Weighted_Gross_Margin_Rate_Tiger__c;
            op.Estimated_Gross_Margin_Rating_Cheetah_Ol__c = op.Gross_Margin_Rating_Cheetah__c;
            op.Estimated_Gross_Margin_Rating_Old__c = op.Gross_Margin_Rating__c;
            op.Estimated_Gross_Margin_Rating_Smart_Old__c = op.Gross_Margin_Rating_Smart__c;
            op.Estimated_Gross_Margin_Rating_Tiger_Old__c = op.Gross_Margin_Rating_Tiger__c;
            op.Estimated_Gross_Margin_Rating_TigerPOld__c = op.Gross_Margin_Rating_TigerPro__c;
            op.Estimated_Gross_Margin_RatingConnectorOl__c = op.Gross_Margin_Rating_Connector__c;
            op.Logistic_Special_Cost_Per_W_Old__c = op.Logistic_Special_Cost_Per_W__c;
            op.Ocean_Freight_China_Old__c = op.Ocean_Freight__c;
            op.Ocean_Freight_Oversea_Old__c = op.Ocean_Freight_Oversea__c;
            op.TotaGross_Margin_ConnectorOld__c = op.Total_Gross_Margin_Connector__c;
            op.Total_Gross_Margin_Old__c = op.Total_Gross_Margin__c;
            op.Total_Gross_Margin_CheetahOld__c = op.Total_Gross_Margin_Cheetah__c;
            op.Total_Gross_Margin_SmartOld__c = op.Total_Gross_Margin_Smart__c;
            op.Total_Gross_Margin_Tiger_ProOld__c = op.Total_Gross_Margin_TigerPro__c;
            op.Total_Gross_Margin_TigerOld__c = op.Total_Gross_Margin_Tiger__c;
            op.Total_Price_CheetahOld__c = op.Total_Price_Cheetah__c;
            op.Total_Price_ConnectorOld__c = op.Total_Price_Connector__c;
            op.Total_Price_SmartOld__c = op.Total_Price_Smart__c;
            op.Total_Price_Tiger_ProOld__c = op.Total_Price_TigerPro__c;
            op.Total_Price_TigerOld__c = op.Total_Price_Tiger__c;
            op.Rate_Old__c = op.Rate__c;
            op.Land_Freight_China_Old__c = op.Land_Freight_China__c;
            op.Land_Freight_Oversea_Old__c = op.Land_Freight_Oversea__c;
           op.Warehouse_Premium_Old__c = op.Warehouse_Premium__c;
           // update op;
           
        if (op.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Service').getRecordTypeId()) {
            op.Price_Approval_Status__c = 'Approved';
            op.Sales_manager_approval__c = 'Approved';
            op.Cross_region_GM_approval__c = 'Approved';
            OpportunityLineItemGrossMarginHandler.skipTrigger = true;
            update op; 
        }
            opls = CvtOpps2Contract.initOpls(con.Opportunity__c);
            //  return null as break , if no green channel no price approval
            // or if no credit approval no green channel
            //if( ! validation() ) return null;
 /*
            Map<ID,RecordType> fullRecords  = new Map<Id,RecordType>([SELECT ID,Name FROM RecordType]);
            system.debug('~~~~~~>fullRecords:' + fullRecords);
*/
           
           List<OpportunityLineItem> oppItem =[SELECT id,
                                                   Name,
                                                   Opportunity.Id,
                                               Product2.Name,
                                               Commision_Rebate_Cost_Per_W_Old__c,
                                               Commision_Rebate_Cost_Per_W__c,
                                               Estimated_Gross_Margin_Old__c,
                                               Estimated_Gross_Margin__c,
                                               Free_Power_W__c,
                                               Free_Power_W_Old__c,
                                               Freight_Cost_Per_W_Old__c,
                                               Freight_Cost_Per_W__c,
                                               Gross_Margin_Rate_Old__c,
                                               Gross_Margin_Rate__c,
                                               Insurence_Cost_Per_W_Old__c,
                                               Insurence_Cost_Per_W__c,
                                               Payment_Cost_Per_W_Old__c,
                                               Payment_Cost_Per_W__c,
                                               Product_Cost_Old__c,
                                               Product_Cost__c,
                                               Special_Material_Cost_Per_W_Old__c,
                                               Special_Material_Cost_Per_W__c,
                                               Special_Material_Type_Old__c,
                                               Special_Material_Type__c,
                                               Third_Party_Test_Cost_Old__c,
                                               Third_Party_Test_Cost__c,
                                               Total_Gross_Margin_Old__c,
                                               Total_Gross_Margin__c,
                                               Transfer_Stock_Rate_Old__c,
                                               Transfer_Stock_Rate__c,
                                               Special_Material_Old__c,
                                               Special_Material__c
                                            FROM OpportunityLineItem
                                            WHERE Opportunity.Id = :op.ID];
           for(OpportunityLineItem o : oppItem){
               o.Commision_Rebate_Cost_Per_W_Old__c = o.Commision_Rebate_Cost_Per_W__c;
               o.Estimated_Gross_Margin_Old__c = o.Estimated_Gross_Margin__c;
               o.Free_Power_W_Old__c = o.Free_Power_W__c;
               o.Freight_Cost_Per_W_Old__c = o.Freight_Cost_Per_W__c;
               o.Gross_Margin_Rate_Old__c = o.Gross_Margin_Rate__c;
               o.Insurence_Cost_Per_W_Old__c = o.Insurence_Cost_Per_W__c;
               o.Payment_Cost_Per_W_Old__c = o.Payment_Cost_Per_W__c;
               o.Product_Cost_Old__c = o.Product_Cost__c;
               o.Special_Material_Cost_Per_W_Old__c = o.Special_Material_Cost_Per_W__c;
               o.Special_Material_Type_Old__c = o.Special_Material_Type__c;
               o.Third_Party_Test_Cost_Old__c = o.Third_Party_Test_Cost__c;
               o.Total_Gross_Margin_Old__c = o.Total_Gross_Margin__c;
               o.Transfer_Stock_Rate_Old__c = o.Transfer_Stock_Rate__c;
               o.Special_Material_Old__c = o.Special_Material__c;
           }
        //   update oppItem;
           
        list<Payment__c> paymentList = [SELECT Percentage__c,
                                                Amount__c,
                                                Down_Balance_Payment__c,
                                                Payment_Method__c,
                                                Days__c,
                                                Payment_Term__c,
                                                PaymentDescription__c,
                                                Opportunity__r.Id
                                        FROM Payment__c
                                        WHERE Opportunity__r.Id = :op.ID];
    
        for (OpportunityLineItem oppLineItem : oppItem) { 
            System.debug('oppLineItem.Product2.Name-----@@@'+oppLineItem.Product2.Name);
            if (oppLineItem.Product2.Name == 'EPD' ){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'You cannot create Contract when the product name contain "EPD"'));
                return null;
            }
        }

        for (Payment__c payment : paymentList){
            if (payment.Percentage__c == null ||
                    payment.Amount__c == null ||
                    payment.Down_Balance_Payment__c == '' ||
                    payment.Payment_Method__c == '' ||
                    payment.Days__c == null ||
                    payment.Payment_Term__c == '' ||
                    payment.PaymentDescription__c == ''

            ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot create Contract when payment field is null'));
                return null;
            }
        }
           
           
           
           
            List<Apply_Inventory__c> appList = [SELECT ID,Name,Approval_Status__c,Opportunity__c FROM Apply_Inventory__c
                WHERE Opportunity__c =: op.ID]; 
             List<Account> accList = [SELECT Billingcity,Billingcountry,BillingStreet FROM Account
                WHERE id =: op.AccountID]; 
            ID InventoryRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Inventory Contract').getRecordTypeId();
            ID SampleOrder = '0126F000001vBpq';
            //ID AustraliaRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('1MW Australia Contract').getRecordTypeId();
            system.debug('------->InventoryRecordTypeId:' + InventoryRecordTypeId);
            //system.debug('------->AustraliaRecordTypeId:' + AustraliaRecordTypeId);
            system.debug('------->con.RecordTypeId:' + con.RecordTypeId);
            //system.debug('------->AustraliaRecordTypeId:' + AustraliaRecordTypeId == con.RecordTypeId);

            //Added by Leo 2018/05/09  for Check the Payment term description Whether empty on Oppty
             if(accList[0].BillingStreet ==null )
            {
                //ApexPages.addMessages(new ApexPages.Message(ApexPages.Severity.ERROR,'Payment term description missing — please update before converting the opportunity into a contract'));
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please fill in Buyer Billing address in Buyer detail page. Thanks.'));
                return null;
            }
            if(op.Payment_Term_Description__c == null && op.RecordTypeId != Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Service').getRecordTypeId())
            {
                //ApexPages.addMessages(new ApexPages.Message(ApexPages.Severity.ERROR,'Payment term description missing — please update before converting the opportunity into a contract'));
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Payment term description missing — please update before converting the opportunity into a contract.'));
                return null;
            }
            //Snake 7/1 德国免费订单判断 非德国单子报错
             if(con.RecordTypeId == SampleOrder && op.Region__c!='EU(Union)' && op.Region__c!='EU(Non-Eu)'){
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Your region does not support SampleOrder'));
                return null;
            }
            // add by han 2018/05/07 North Asia bookStock EXW DDP 
            /*
            if(con.RecordTypeId == InventoryRecordTypeId && appList.size() == 0){
           
                   if(op.Region__c !='North Asia' && op.Region__c !='North America'){ 
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You didn\'t book Stock yet. please book stock before you create contract'));
                                return null;
                  }
             
                else if(op.Region__c =='North Asia' && (op.Trade_Term__c =='DDP' || op.Trade_Term__c =='EXW')){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You didn\'t book Stock yet. please book stock before you create contract'));
                                return null;
                   }

       
            }
            */
            //当业务机会为澳洲区时两个审批有一个同意就能创建合同
         
            if(op.RecordType.Name == 'Australia'&&op.Price_Approval_Status__c!='Approved' && op.Sales_manager_approval__c !='Approved' && op.Total_MW__c>1){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You can not create Contract, because you didn\'t get price approve.'));
                return null;
            }
            if(op.Roll_up__c > 0 && op.Price_Approval_Status__c!='Approved' && op.Total_MW__c>1){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You can not create Contract, because you didn\'t get price approve.'));
                return null;
            }

            system.debug('op.Destination_Country__c:'+op.Destination_Country__c);
            system.debug('op.SWIFT_Buyer__c:'+op.SWIFT_Buyer__c);
            if(op.Destination_Country__c == 'Ukraine'&& op.Not_Ukraine_Company__c==false && (op.SWIFT_Buyer__c==null || op.BankInfo_Addr_Buyer__c ==null || op.BankInfo_Name_Buyer__c ==null|| op.BENEFICIARY_s_A_C_Buyer__c ==null|| op.BENEFICIARY_s_Name_Buyer__c ==null|| op.BENEFICIARY_s_Address_Buyer__c ==null)){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' Required information is missing, Please find section "Buyer Bank Info(Ukraine)" and fill in all information. Thanks.'));
                return null;
            }
            if(op.Region__c == 'Latin America&Italy' && (op.BillingCountry__c==null || op.BillingState__c ==null || op.BillingStreet__c ==null|| op.ShippingCity__c ==null|| op.BillingCountry__c=='' || op.BillingState__c =='' || op.BillingStreet__c ==''|| op.ShippingCity__c =='')){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' <Bill Address> information in Account is missing, Please find "Bill Address" and fill in all information. Thanks. Url:https://ap4.salesforce.com/'+op.accountid));
                return null;
            }
            if(op.Region__c == 'Latin America&Italy' && (op.Warranty_On_Material_and_Workmanship__c==null || op.Warranty_Insurance__c==null)){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' <Warranty On Material and Workmanship> or <Warranty Insurance> is missing, Please find "Warranty On Material and Workmanship"/"Warranty Insurance" and fill in all information. Thanks. '));
                return null;
            }
            //当业务机会小于日本区1MW时，GM只有审批通过才能生成合同
            system.debug('op.RecordType.Name ------------------>'+op.RecordType.Name );
             system.debug('op.Sales_manager_approval__c  ------------------>'+op.Sales_manager_approval__c  );
             system.debug('op.Cross_Region__c ------------------>'+op.Cross_Region__c );
             system.debug('op.Total_MW__c ------------------>'+op.Total_MW__c );
            if(op.RecordType.Name == 'Japan' && op.Total_MW__c< 1 && (op.Sales_manager_approval__c !='Approved' || op.Sales_manager_approval__c == null) && op.Cross_Region__c ==false){
                  System.debug('11111');
                  
                  ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You can not create Contract, because you didn\'t get price approve.'));
                     
                return null;
                
            }
               //当为跨区业务机会时并且不满足快速流程，必须要两个GM和财务都审批同意后才能创建合同
            system.debug('跨区域开始');
           //储能不走此流程？？？
            if(op.Cross_Region__c == true && op.RecordType.name != 'Energy Storage System' && ((op.Price_Approval_Status__c!='Approved' && op.Total_MW__c>1) || op.Sales_manager_approval__c !='Approved'||op.Cross_region_GM_approval__c !='Approved')){
                String RegionHeadName ='';
                String RegionHeadEmail ='';
                if(op.Region__c =='EU(Union)'|| op.Region__c=='EU(Non-Eu)'){
                    RegionHeadEmail=Label.Area_EU;
                }else if(op.Region__c =='ROA'){
                    RegionHeadEmail=Label.Area_ROA;
                }else if(op.Region__c =='North Asia'){
                    RegionHeadEmail=Label.Area_North_Asia;
                }else if(op.Region__c =='South Asia'){
                    RegionHeadEmail=Label.Area_South_Asia;
                }else if(op.Region__c =='North America'){
                    RegionHeadEmail=Label.Area_North_America;
                }else if(op.Region__c =='Middle East&Africa'){
                    RegionHeadEmail=Label.Area_Middle_east_africa;
                }else if(op.Region__c =='Latin America&Italy'){
                    RegionHeadEmail=Label.Area_Latin_America_Italy;
                }else if(op.Region__c =='MENA'){
                    RegionHeadEmail=Label.Middle_East_North_Africa;
                }else if(op.Region__c =='SSA'){
                    RegionHeadEmail=Label.Sub_Saharan_Africa;
                }else if(op.Region__c =='Central Asia'){
                    RegionHeadEmail=Label.Area_Central_Asia;
                }
                if(RegionHeadEmail !=null){
                    system.debug('123');
                    system.debug('RegionHeadEmail'+RegionHeadEmail);
                    User us =[Select id,Name,Email from User where Email =:RegionHeadEmail];
                    system.debug('456');
                    if(us !=null){
                        RegionHeadName =us.Name;
                    }
                }
                String approveName ='';
                if(op.Price_Approval_Status__c!='Approved'  && op.Total_MW__c>1){
                    approveName =approveName+'Alex,';
                }
                if(op.Sales_manager_approval__c !='Approved'){
                    Opportunity opp =[Select id,Owner.Contract_Approver__r.Name from Opportunity where id =:op.Id];
                    if(opp !=null){
                    approveName =approveName+opp.Owner.Contract_Approver__r.Name+','; 
                    }
                }
                if(op.Cross_region_GM_approval__c !='Approved'){
                    approveName =approveName+RegionHeadName;
                }
                system.debug('快速流程结束');
           
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' you can not create contract until  '+ approveName + '  approved.'));
                return null;
                 
            }
            //一般合同Price Approval Status 不为 Approved 无法创建合同
            /*if(op.Price_Approval_Status__c != 'Approved' && con.RecordTypeId  != '01290000001Lyqh' && con.RecordTypeId  != '0126F000001BRq1'){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You can not create Contract, because you didn\'t get price approve.'));
                return null;
            }*/
            
            //create the order and copy the info from account and opportunity
            con = CvtOpps2Contract.CpyAccInfo(op, con);
            
            //add by kane 2015/09/05 : 没有Approved的Book Stock 审批将直接被拒
            List<Apply_Inventory__c> appList2 = [SELECT ID,Name,Approval_Status__c,Opportunity__c FROM Apply_Inventory__c
                WHERE Opportunity__c =: op.ID AND Approval_Status__c =: 'Approved'];
            if(appList2.size() > 0)con.Has_Book_Stock__c = true;
            if(con.RecordTypeId != InventoryRecordTypeId)con.Has_Book_Stock__c = true;
            //if(con.RecordTypeId == '0126F000001BRq1')con.Tax_Rate__c = 10;
            //add for japan 20151116
            //if(op.Is_GTAC_Formula__c != null)con.Is_GTAC__c = op.Is_GTAC_Formula__c;
            //add by kane 20151119 Buyer = Account,SELLER = opp.SELLER
            // remove by jason 2016413 if(op.Seller__c != null)con.SELLER__c = op.Seller__c;
            if(op.AccountId != null)con.BuyerAccount__c = op.AccountId;
            //add by kane 20151216 : Destination country & Destination Auto value
            if(op.Destination_Country__c != null)con.Destination_Country__c = op.Destination_Country__c;
            if(op.delivey_point__c != null)con.Destination__c = op.delivey_point__c;
            if(op.Region__c != null)con.Region__c = op.Region__c;
            system.debug('测试'+con.Region__c);
            // create by :jason 20160421
            
            
            
              //合同自动变成1MW的记录类型（日本区域和澳大利亚区域除外）
            //create by jsaon 20160417
            List<Opportunity> opps = [select id,Total_MW__c,
                                                Region__c,
                                                Total_Quantity__c,
                                                Seller__c,
                                                RecordType.name,
                                                Special_Terms__c,
                                                Payment_1MW_Approve__c ,
                                                Allow_new_process_for_Japan_picklist__c,
                                                Customer_Type__c,
                                                delivey_point__c,
                                                Trade_Term__c,
                                                Price_Approval__c,
                                                Green_Channel_Approval__c,
                                                Credit_Control_Approval__c
                                                from Opportunity 
                                                where  id =: con.Opportunity__c];
            if(opps.size()>0){
                oppid = opps[0].Id;
                op    = opps[0];
            } 
            
            List<Payment__c> fullPayments = [Select Collection_Assurance__c, 
                                                    Incoterm__c,
                                                    Down_Balance_Payment__c, 
                                                    Payment_Term__c, 
                                                    Payment_Method__c,
                                                    Contract__c,
                                                    Name, Id,  
                                                    Days__c, 
                                                    CurrencyIsoCode,  
                                                    Precise_Day__c,                 
                                                    Condition__c,
                                                    Opportunity__r.Trade_Term__c,
                                                    Opportunity__c, 
                                                    Collection_Assurance_1__c, 
                                                    Collection_Assurance_2__c, 
                                                    CA_Document_Preparing_Due_Date__c,
                                                    Percentage__c,
                                                    Requested_Number__c,
                                                    AR_Start_Date__c
                                                    From Payment__c 
                                                    Where Opportunity__c =: oppid];
           
           
           /* 当业务机会不满足1MW条件的时候 业务机会中的Delivey point字段为空的话不提示为空信息*/ 
            if(String.isEmpty(op.delivey_point__c)
              && op.RecordType.name == 'USA'
              && op.Trade_Term__c == 'DDP'){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You can not create Contract, Because of Delivey point is  Null.'));
                        return null;
            }
           //start 
            if(op.RecordType.name != 'USA'){
                if(op.Total_MW__c < 1.0
                && op.Payment_1MW_Approve__c == true
                && (op.Trade_Term__c == 'CIF'
                        || op.Trade_Term__c == 'EXW'
                        || op.Trade_Term__c == 'FOB'
                        || op.Trade_Term__c == 'DAP'
                        || op.Trade_Term__c == 'DDP'
                        || op.Trade_Term__c == 'CFR')){
                
                    if(String.isEmpty(op.delivey_point__c)
                        && op.RecordType.name != 'Japan' 
                        && op.Region__c != 'North Of America'
                        && !(op.RecordType.name == 'Australia' && op.Total_Quantity__c < 2800 )
                     ){
                        System.debug('@@@@@@ Region__c :'+ op.Region__c);
                        System.debug('@@@@@@ RecordType.name :'+ op.RecordType.name);
                    
                              ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You can not create Contract, Because of Delivey point is  Null.')); 
                         
                      
                        return null;
                    }
                
                }
            }
             
           //end
           
           

           //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'RecordTypeId:' + con.RecordTypeId));
           system.debug('Charliy'+con);
         //  OpportunityLineItemGrossMarginHandler.skipTrigger=false;
            insert con;
         //  OpportunityLineItemGrossMarginHandler.skipTrigger=true;
            List<CapacityReservation__c> caLst= new List<CapacityReservation__c>();
               caLst= [select id from CapacityReservation__c where Opportunity__c=:con.Opportunity__c];
            if(caLst.size()>0){
                for(CapacityReservation__c cr:caLst)
                    {
                        cr.contract__c=con.id;
                    }
                update caLst;
            }
        SyncContract.creatMDA(con.Opportunity__c,con.id);
        /**
        List<Component_Task_Book__c> mdaLst= new List<Component_Task_Book__c>();
               mdalst= [select id from Component_Task_Book__c where Opportunity__c=:con.Opportunity__c];
            if(mdalst.size()>0){
                for(Component_Task_Book__c cr:mdalst)
                    {
                        cr.contract__c=con.id;
                    }
                update mdalst;
            }
**/
          List<Reserve_inventory_information__c> RiiLstQ= new List<Reserve_inventory_information__c>();
          RiiLstQ= Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Reserve_inventory_information__c) + ' ' +
                                               'Where  Opportunity__c=:oppid ');  
            if(RiiLstQ.size()>0){
                for(Reserve_inventory_information__c rii:RiiLstQ)
                    {
                        rii.contract__c=con.id;
                    }
            }
                update RiiLstQ;
      
      
            
            /*
            Contract c = [Select id , RecordTypeId From Contract Where id =: '0126F000001BRq1'];
            if(c.RecordTypeId != null) con.Tax_Rate__c = 10;
            update con;
      */
            system.debug('~~~~~~>con:' +con);
            //create the order line item according to the opportunity item
            Product_Detail__c[] pds = CvtOpps2Contract.CpyOppsLineItem(opls, con);
            insert pds;
            
            //update Distribution Stock's Contract ID
            CvtOpps2Contract.updateInventory( op, con);
            //update Distribution Stock's Contract ID
            CvtOpps2Contract.updateProductionScheduled( op, con);
            CvtOpps2Contract.historyOpp(op.id);
            
          //return to the order standard page
          return new ApexPages.StandardController(con).view();
       
    }catch(Exception e){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getStackTraceString()));
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getMessage()));
        }  
        return null;
    }
    
    private boolean validation(){
        boolean res = true;
        
        // if no green channel no price approval
        if(op.Price_Approval__c == false && op.Green_Channel_Approval__c==false && op.total_MW__c>=1){//joel 20200308
            // error message
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING,'Price Approval is not pass.');
            ApexPages.addMessage(msg);
            res = false;
        }
        // if no credit approval no green channel
        if(op.Credit_Control_Approval__c == false && op.Green_Channel_Approval__c == false){
            //alert message
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING,'Credit Approval is not pass.');
            ApexPages.addMessage(msg);
            res = false;
        }
        
        return res;
    }
    
    public void runTest(){
        String run = 'run test';
        run = 'run test';
    }


  /*
     public static testMethod void onTest(){
        system.debug('------------- prepare date ----------------');
        //testPrepare testdata = new testPrepare();
        Account acc = TestHelper.createAccount();  
        Opportunity o2 = new Opportunity();
        o2.name              = '2MW-JKM190-20130101';
        o2.AccountId          = acc.id;
        o2.Credit_Control_Approval__c  = true;
        o2.Price_Approval__c      = true; 
        o2.Green_Channel_Approval__c  = false;
        o2.CloseDate           = Date.today(); 
        o2.StageName          = 'Close Won';
        o2.Probability          = 100;
        insert o2;
        
        Contract c1 = TestHelper.createContract(acc.Id, false);
        c1.AccountId    = acc.Id;
        c1.Opportunity__c  = o2.Id;
        c1.Status      = 'Draft';
        c1.Contract_NO__c  = '2011-JKZJXS-ZQPM-1984';
        insert c1;
        
        system.debug('------------- prepare date done!----------------');
         // part one
        ApexPages.currentPage().getParameters().put('id', o2.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(c1);
        ContractControllerCreate crt = new ContractControllerCreate(sc);
        crt.onCreate();
        system.assertEquals(  crt.validation() , true );
        system.assertNotEquals( crt.con , null );
        
        
     }
    */
}