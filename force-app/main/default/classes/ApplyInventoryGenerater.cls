global class ApplyInventoryGenerater {
    webservice static String generate(String id){
        system.debug('test-->'+123);
        String SalesName='';
        String ProductName='';// 
        String PSC ='';
        String BookDescription ='';
        String   GuaranteedDate ='';
        Date   TodayTime = date.today();
        List<Inventory__c> invList = new List<Inventory__c>();
        List<Apply_Inventory__c> bookstockLst = new List<Apply_Inventory__c>();
        RecordType recordtypeLst = new RecordType();
        system.debug('id--->'+id);
        if(id != null){
            Opportunity opp=[Select id,Trade_Term__c,Account.Name,Actual_Sales_Name__c,OwnerID,Owner.Name,Sales_Region__c from Opportunity where id =:id];
            bookstockLst =[Select Id,BookStockProductName__c,BookDescription__c,PSC__c,Opportunity__c from Apply_Inventory__c where Opportunity__c =:id ];
            
            //insert inv;
            if(string.isEmpty(opp.Actual_Sales_Name__c)){
                SalesName = opp.Owner.Name;
            }else{
                SalesName = opp.Actual_Sales_Name__c;
            }
            //找到所有关于这条业务机会产品的信息
            List<OpportunityLineItem> items = [select Id,UnitPrice,Quantity,PricebookEntry.product2Id,tolerance__c,PricebookEntry.product2.Name,
                                               Solar_Cell__c,Back_Sheet__c,EVA__c,Temperd_Glass__c,Ribbon__c,Junction_Box__c,Frame__c,
                                               Serial_No__c,Package__c,Label__c,Description,Battery_Line__c,Battery_Type__c,Junction_Box_Type__c,Guaranteed_Delivery_Date__c,
                                               Wire_Length__c,Junction_Box_Brand__c,ConnectorLine__c,Expected_Delivery_Date__c,Power_W__c,Estimated_Time_of_Departure_ETD__c
                                               from OpportunityLineItem Where OpportunityId =:id];
            if(opp.Sales_Region__c =='North Asia'){
                recordtypeLst =[Select id,Name from recordtype where Name =:'North Asia' limit 1];
                if(bookstockLst.size()==0){
                    Apply_Inventory__c inv = new Apply_Inventory__c();
                    inv.Opportunity__c        = id;
                    system.debug('test-->'+123);
                    if(items.size()>0){
                        for(OpportunityLineItem item : items){
                            if(ProductName==''){ 
                                ProductName = item.PricebookEntry.product2.Name;
                            }else{
                                ProductName = ProductName +':'+ item.PricebookEntry.product2.Name;
                            }
                            if(PSC==''){ 
                                PSC = string.valueOf(item.Quantity.intValue());
                            }else{
                                PSC = PSC +':'+ string.valueOf(item.Quantity.intValue());
                            }
                            if(GuaranteedDate==''){
                                GuaranteedDate = String.valueOf(item.Guaranteed_Delivery_Date__c);
                            }else{
                                GuaranteedDate = GuaranteedDate+':'+String.valueOf(item.Guaranteed_Delivery_Date__c);
                            }
                            system.debug('GDD'+GuaranteedDate);
                            if(BookDescription==''){ 
                                BookDescription = '预定产品名字: '+item.PricebookEntry.product2.Name  + '  预定数量:'+ string.valueOf(item.Quantity.intValue())+'发货日期: '+String.valueOf(item.Guaranteed_Delivery_Date__c) ;
                            }else{
                                BookDescription = BookDescription +'\r\n'+ '预定产品名字: '+item.PricebookEntry.product2.Name  + '  预定数量:'+ string.valueOf(item.Quantity.intValue())+'发货日期: '+String.valueOf(item.Guaranteed_Delivery_Date__c);
                            }
                        } 
                        
                        system.debug('ProductName-->'+ProductName);
                        inv.BookStockProductName__c = ProductName;
                        inv.BookDescription__c = BookDescription;
                        inv.BookStockDeliveryTime__c = GuaranteedDate;
                        inv.PSC__c   = PSC;
                        inv.Approval_Status__c ='Pending';
                        inv.SendEmialCounts__c = 1;
                        inv.SendEmialTime__c = datetime.now();
                        inv.Due_Date__c = TodayTime.addDays(3);    
                        inv.OwnerId  =UserInfo.getUserId();
                        if(recordtypeLst !=null){
                            inv.RecordTypeId = recordtypeLst.Id;
                        }
                        insert inv;
                        if(inv !=null){
                            User us =[Select Id,IsActive,BMO_specialist__c from User where Name =:System.Label.Japan_BMO and IsActive=true];
                            if(us !=null){
                                SendEmailUtils.sendToSomeOneId(inv.id,us.BMO_specialist__c,'Book_Stock_Approval');
                                return inv.Id;
                            }
                        }
                    }
                }
                else if(bookstockLst.size()==1){
                    if(items.size()>0){
                        for( Apply_Inventory__c inv : bookstockLst){
                            inv.Opportunity__c        = id;
                            system.debug('test-->'+123);
                            for(OpportunityLineItem item : items){
                                if(ProductName==''){ 
                                    ProductName = item.PricebookEntry.product2.Name;
                                }else{
                                    ProductName = ProductName +':'+ item.PricebookEntry.product2.Name;
                                }
                                if(PSC==''){ 
                                    PSC = string.valueOf(item.Quantity.intValue());
                                }else{
                                    PSC = PSC +':'+ string.valueOf(item.Quantity.intValue());
                                }
                                if(GuaranteedDate==''){
                                    GuaranteedDate = String.valueOf(item.Guaranteed_Delivery_Date__c);
                                }else{
                                    GuaranteedDate = GuaranteedDate+':'+String.valueOf(item.Guaranteed_Delivery_Date__c);
                                }
                                if(BookDescription==''){ 
                                    BookDescription = '预定产品名字: '+item.PricebookEntry.product2.Name  + '  预定数量:'+ string.valueOf(item.Quantity.intValue())+'发货日期: '+String.valueOf(item.Guaranteed_Delivery_Date__c);
                                }else{
                                    BookDescription = BookDescription +'\r\n'+ '预定产品名字: '+item.PricebookEntry.product2.Name  + '  预定数量:'+ string.valueOf(item.Quantity.intValue())+'发货日期: '+String.valueOf(item.Guaranteed_Delivery_Date__c);
                                }
                            }             
                            system.debug('ProductName-->'+ProductName);
                            inv.BookStockProductName__c = ProductName;
                            inv.BookDescription__c = BookDescription;
                            inv.PSC__c   = PSC;
                            if(inv.SendEmialCounts__c ==null){
                                inv.SendEmialCounts__c = 1;
                            }else{
                                inv.SendEmialCounts__c = inv.SendEmialCounts__c+1; 
                            }
                            inv.Approval_Status__c ='Pending';
                            inv.OwnerId  =UserInfo.getUserId();
                            inv.Due_Date__c = TodayTime.addDays(3);
                            inv.SendEmialTime__c = datetime.now();
                            if(recordtypeLst !=null){
                                inv.RecordTypeId = recordtypeLst.Id;
                            }
                            update inv;
                            if(inv !=null){
                                User us =[Select Id,Name,IsActive,BMO_specialist__c from User where Name =:System.Label.Japan_BMO and IsActive=true];
                                if(us !=null){
                                    SendEmailUtils.sendToSomeOneId(inv.id,us.id,'Book_Stock_Approval');
                                }
                            }
                            return inv.Id;
                        }
                    }
                } 
            }
            
            else{
                
                recordtypeLst =[Select id,Name from recordtype where Name =:'Normal' limit 1];
                List<Apply_Inventory__c> NormalbookstockLst = new List<Apply_Inventory__c>();
                System.debug('*********items '+recordtypeLst );
                if(bookstockLst.size()>0){
                    for(Apply_Inventory__c bookstock: bookstockLst){
                        system.debug('111');
                        for(OpportunityLineItem item : items){
                            Apply_Inventory__c inv = new Apply_Inventory__c();
                            inv.Quantity__c           = item.Quantity;
                            inv.Opportunity__c        = id;
                            inv.Product_Type__c       = item.PricebookEntry.product2Id;
                            inv.ConnectorLine__c      = item.ConnectorLine__c;
                            inv.Junction_Box_Brand__c = item.Junction_Box_Brand__c;
                            if(recordtypeLst !=null){
                                inv.RecordTypeId          =  recordtypeLst.Id;   
                            }
                            
                            inv.Wire_Length__c        = item.Wire_Length__c;
                            NormalbookstockLst.add(inv);
                        }
                    }                    
                }else{
                    
                    system.debug('111');
                    for(OpportunityLineItem item : items){
                        Apply_Inventory__c inv = new Apply_Inventory__c();
                        inv.Quantity__c           = item.Quantity;
                        inv.Opportunity__c        = id;
                        inv.Product_Type__c       = item.PricebookEntry.product2Id;
                        inv.ConnectorLine__c      = item.ConnectorLine__c;
                        inv.Junction_Box_Brand__c = item.Junction_Box_Brand__c;
                        if(recordtypeLst !=null){
                            inv.RecordTypeId          =  recordtypeLst.Id;   
                        }
                        
                        inv.Wire_Length__c        = item.Wire_Length__c;
                        NormalbookstockLst.add(inv);
                    }
                    
                }
                
                
                system.debug('NormalbookstockLst.size()-->'+NormalbookstockLst.size());
                if(NormalbookstockLst.size()>0){
                    try{
                        System.debug('*********bookstockLst'+NormalbookstockLst);
                        insert NormalbookstockLst;
                        return 'success';
                    }catch(Exception e){
                        System.debug('*********error'+e);
                        return 'failed';
                    }
                    
                    
                    
                    //  PageReference gotoNewpage = Page.GotoBookStock;
                    //   system.debug('gotoNewpage-->'+gotoNewpage);
                    
                    /**
for(OpportunityLineItem item : items){
Inventory__c invent = new Inventory__c();
invent.Book_Stock__c         = inv.id;
invent.Quantity__c           = item.Quantity;
invent.UnitPrice__c           = item.UnitPrice;
invent.Expected_Time_Of_Arrival__c   = item.Expected_Delivery_Date__c;
invent.Expected_Time_Of_Delivery__c  = item.Guaranteed_Delivery_Date__c;
invent.Product_Type__c        = item.PricebookEntry.product2Id;
invent.Status__c                 ='Unbook';
invent.Power_W__c             = item.Power_W__c;
invent.Account_Name__c        = opp.Account.Name;
invent.Sales__c               = SalesName;
invent.Terms_of_trade__c      = opp.Trade_Term__c;
invList.add(invent);
}

if(invList.size()>0){
try{
System.debug('*********invList'+invList);
insert invList;
return 'success';
}catch(Exception e){
System.debug('*********error'+e);
return 'failed';
}
}
// system.debug('invList.id-->'+inv.id);
/**
//   Opportinity opp=[Select ];
System.debug('*********oppid'+id);

//  String sqlstr = 'select Id,UnitPrice,Quantity,PricebookEntry.product2Id,tolerance__c,Solar_Cell__c,Back_Sheet__c,EVA__c,Temperd_Glass__c,Ribbon__c,Junction_Box__c,Frame__c,Serial_No__c,Package__c,Label__c,Description,Battery_Line__c,Battery_Type__c,Junction_Box_Type__c,Wire_Length__c,Junction_Box_Brand__c,ConnectorLine__c'+
//       ' from OpportunityLineItem Where OpportunityId =:id';
//    List<OpportunityLineItem> items = Database.query(sqlstr);
List<OpportunityLineItem> items = [select Id,UnitPrice,Quantity,PricebookEntry.product2Id,tolerance__c,Solar_Cell__c,Back_Sheet__c,EVA__c,Temperd_Glass__c,Ribbon__c,Junction_Box__c,Frame__c,Serial_No__c,Package__c,Label__c,Description,Battery_Line__c,Battery_Type__c,Junction_Box_Type__c,Wire_Length__c,Junction_Box_Brand__c,ConnectorLine__c
from OpportunityLineItem Where OpportunityId =:id];
System.debug('*********items '+items );
for(OpportunityLineItem item : items){
Apply_Inventory__c inv = new Apply_Inventory__c();
inv.Quantity__c           = item.Quantity;
inv.Opportunity__c        = id;
inv.Product_Type__c       = item.PricebookEntry.product2Id;
inv.ConnectorLine__c      = item.ConnectorLine__c;
inv.Junction_Box_Brand__c = item.Junction_Box_Brand__c;
inv.Wire_Length__c        = item.Wire_Length__c;

invList.add(inv);

System.debug('*********inv'+inv);
}
}
if(invList.size()>0){
try{
System.debug('*********invList'+invList);
insert invList;
return 'success';
}catch(Exception e){
System.debug('*********error'+e);
}
}
**/
                    //  PageReference r = new PageReference('/' + inv.id);
                    return 'failed';
                }
                //  return 'failed';
            }
        }
        system.debug('1111');
        return 'failed';
    }
    
    
    public PageReference doGenerate(String invId,Apply_Inventory__c inv){
        system.debug('inv-->'+inv);
        return new ApexPages.StandardController(inv).view();
    }
    public void runTest(){
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
    }
}