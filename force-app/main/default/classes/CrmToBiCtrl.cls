@RestResource(urlMapping='/CrmToBiCtrl/*')
global without sharing class  CrmToBiCtrl {
    @HttpGet
    global static String doGet(){ 
        try{
            system.debug('0701');
            // return todo();
            return null;
        }
        catch(Exception ex){
            return ex.getMessage();
        }        
    }
    @HttpPost
    global static ResultWrapper doPost() {
        ///try{
            system.debug('0702');
            RestRequest req = RestContext.request;
            Map<string,string> Str2= req.headers;
            system.debug('Srt2'+Str2);
            String str3=Str2.get('SyncType');
            Integer page ;
        system.debug('page'+Page);
            if(Str2.get('Page') == null){
                page = 1;
            }else{
                page = Integer.valueOf(Str2.get('Page'));
            }
            Integer pageSize = 200;
            Integer pas = pageSize * (page-1);
            //String pageLimit = 'Offset  '+''+ pas+ '' +'  limit '+pageSize;
                    String pageLimit = ' limit '+pageSize + ' Offset  '+''+ pas ;

        system.debug('pageLimit'+pageLimit);
            String startTime=Str2.get('StartTime');
            DateTime startTimes ;
            
            if(startTime !=null && startTime !=''){
               startTimes = dateTime.valueOf(startTime); 
                startTimes=startTimes.addHours(8);
            }
            
            String endTime=Str2.get('EndTime'); 
            DateTime endTimes ;
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
            }
            
            String TimeValue = Str2.get('TimeValue');
            String CreateOrModifiedDate = '';
            String CreateOrModifiedDate2 = '';
            if(TimeValue == 'CreatedDate'){
               CreateOrModifiedDate  = 'Where CreatedDate >=: startTimes and CreatedDate <=: endTimes';
               CreateOrModifiedDate2 = 'CreatedDate >=: startTimes';
            }else if(TimeValue == 'ModifiedDate'){
               CreateOrModifiedDate  = 'Where LastModifiedDate >=: startTimes and LastModifiedDate <=: endTimes';
               CreateOrModifiedDate2 = 'LastModifiedDate >=: startTimes';
            }
            
            String SyncObject = Str2.get('SyncObject');
            System.debug('Str3:'+str3);
            
            
            string jsonContent = '';
            if(SyncObject == 'Account'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<Account> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Account));
                    system.debug('obj'+obj.size());
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    system.debug(objSize);
                    Decimal oceil = Math.ceil(objSize);
                    //jsonContent = JSON.serialize(obj);
                    system.debug('pageLimit'+pageLimit);
                    List<Account> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Account) + ' ' +
                                          pageLimit);
                    system.debug('objs'+objs.size());
                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    system.debug('wrapper'+wrapper);
                    return wrapper;
                }else if(str3 == 'B'){
                    
                    if(endTime != null && endTime != ''){
                        List<Account> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Account) + ' ' +
                                          CreateOrModifiedDate);
                        system.debug('obj'+obj.size());
                        Decimal n=(Decimal)obj.size();
                        system.debug('obj'+n);
                        Decimal objSize = n/200;
                        system.debug('obj'+objSize);
                        Decimal oceil = Math.ceil(objSize);
                        system.debug('obj'+oceil);
                        List<Account> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Account) + ' ' +
                                          CreateOrModifiedDate+ ' '+pageLimit);
                        system.debug('objs'+objs.size());
                        ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    
                    return wrapper;
                    }else{
                        List<Account> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Account) + ' ' +
                                          CreateOrModifiedDate2);
                        system.debug('obj'+obj.size());
                        Decimal n=(Decimal)obj.size();
                        system.debug('obj'+n);
                        Decimal objSize = n/200;
                        system.debug('obj'+objSize);
                        Decimal oceil = Math.ceil(objSize);
                        system.debug('obj'+oceil);
                         List<Account> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Account) + ' ' +
                                          CreateOrModifiedDate2 + ' '+pageLimit);
                        system.debug('obj'+objs.size());
                        ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            
            if(SyncObject == 'Lead'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<Lead> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Lead));
                    Decimal n=(Decimal)obj.size();
                        Decimal objSize = n/200;
                        Decimal oceil = Math.ceil(objSize);
                        List<Lead> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Lead)+' '+pageLimit);

                        ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
                system.debug('endTimes'+endTimes);
            }
                    if(endTime != null && endTime != ''){
                        List<Lead> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Lead) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                        Decimal objSize = n/200;
                        Decimal oceil = Math.ceil(objSize);
                        List<Lead> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Lead)+ ' ' +
                                          CreateOrModifiedDate+' '+pageLimit);

                        ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }else{
                        List<Lead> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Lead) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                        Decimal objSize = n/200;
                        Decimal oceil = Math.ceil(objSize);
                        List<Lead> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Lead)+ ' ' +
                                          CreateOrModifiedDate2+' '+pageLimit);

                        ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            if(SyncObject == 'User'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<User> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.User));
                    Decimal n=(Decimal)obj.size();
                        Decimal objSize = n/200;
                        Decimal oceil = Math.ceil(objSize);
                        List<User> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.User)+' '+pageLimit);

                        ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
                system.debug('endTimes'+endTimes);
            }
                    if(endTime != null && endTime != ''){
                        List<User> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.User) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                        Decimal objSize = n/200;
                        Decimal oceil = Math.ceil(objSize);
                        List<User> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.User)+ ' ' +
                                          CreateOrModifiedDate+' '+pageLimit);

                        ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }else{
                        List<User> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.User) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                        Decimal objSize = n/200;
                        Decimal oceil = Math.ceil(objSize);
                        List<User> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.User)+ ' ' +
                                          CreateOrModifiedDate2+' '+pageLimit);

                        ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            
            if(SyncObject == 'Contact'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<Contact> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Contact));
                    Decimal n=(Decimal)obj.size();
                        Decimal objSize = n/200;
                        Decimal oceil = Math.ceil(objSize);
                    List<Contact> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Contact)+' '+pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
                system.debug('endTimes'+endTimes);
            }
                    if(endTime != null && endTime != ''){
                        List<Contact> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Contact) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                        Decimal objSize = n/200;
                        Decimal oceil = Math.ceil(objSize);
                        List<Contact> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Contact)+ ' ' +
                                          CreateOrModifiedDate+' '+pageLimit);

                                                Map<String,Decimal> objc = new Map<String,Decimal>();//Page:1
                   ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }else{
                        List<Contact> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Contact) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                        Decimal objSize = n/200;
                        Decimal oceil = Math.ceil(objSize);
                        List<Contact> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Contact)+ ' ' +
                                          CreateOrModifiedDate2+' '+pageLimit);

                     ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            
            if(SyncObject == 'Opportunity'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<Opportunity> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Opportunity));
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Opportunity> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Opportunity)+' '+pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
                system.debug('endTimes'+endTimes);
            }
                    if(endTime != null && endTime != ''){
                        List<Opportunity> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Opportunity) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Opportunity> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Opportunity)+ ' ' +
                                          CreateOrModifiedDate+' '+pageLimit);

                     ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }else{
                        List<Opportunity> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Opportunity) + ' ' +
                                          CreateOrModifiedDate2);
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Opportunity> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Opportunity)+ ' ' +
                                          CreateOrModifiedDate2+' '+pageLimit);

                   ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            
            if(SyncObject == 'Quote'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<Quote> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Quote));
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Quote> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Quote)+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
                system.debug('endTimes'+endTimes);
            }
                    if(endTime != null && endTime != ''){
                        List<Quote> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Quote) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Quote> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Quote)+ ' ' +
                                          CreateOrModifiedDate+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }else{
                        List<Quote> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Quote) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Quote> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Quote)+ ' ' +
                                          CreateOrModifiedDate2+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            
            if(SyncObject == 'Payment'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<Payment__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Payment__c));
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Payment__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Payment__c)+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
                system.debug('endTimes'+endTimes);
            }
                    if(endTime != null && endTime != ''){
                        List<Payment__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Payment__c) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Payment__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Payment__c)+ ' ' +
                                          CreateOrModifiedDate+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }else{
                        List<Payment__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Payment__c) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Payment__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Payment__c)+ ' ' +
                                          CreateOrModifiedDate2+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            
            if(SyncObject == 'OpportunityLineItem'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<OpportunityLineItem> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OpportunityLineItem));
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<OpportunityLineItem> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OpportunityLineItem)+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
                system.debug('endTimes'+endTimes);
            }
                    if(endTime != null && endTime != ''){
                        List<OpportunityLineItem> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OpportunityLineItem) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<OpportunityLineItem> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OpportunityLineItem)+ ' ' +
                                          CreateOrModifiedDate+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }else{
                        List<OpportunityLineItem> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OpportunityLineItem) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<OpportunityLineItem> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OpportunityLineItem)+ ' ' +
                                          CreateOrModifiedDate2+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            
            if(SyncObject == 'Contracts'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<Contract> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Contract));
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Contract> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Contract)+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
                system.debug('endTimes'+endTimes);
            }
                    if(endTime != null && endTime != ''){
                        List<Contract> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Contract) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Contract> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Contract)+ ' ' +
                                          CreateOrModifiedDate+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }else{
                        List<Contract> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Contract) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Contract> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Contract)+ ' ' +
                                          CreateOrModifiedDate2+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            
            if(SyncObject == 'Product Detail'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<Product_Detail__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Product_Detail__c));
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Product_Detail__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Product_Detail__c)+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
                system.debug('endTimes'+endTimes);
            }
                    if(endTime != null && endTime != ''){
                        List<Product_Detail__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Product_Detail__c) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Product_Detail__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Product_Detail__c)+ ' ' +
                                          CreateOrModifiedDate+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }else{
                        List<Product_Detail__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Product_Detail__c) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Product_Detail__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Product_Detail__c)+ ' ' +
                                          CreateOrModifiedDate2+ ' ' +pageLimit);

                     ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;

                    }
                }
            }
            
            if(SyncObject == 'MDA'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<Component_Task_Book__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Component_Task_Book__c));
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Component_Task_Book__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Component_Task_Book__c)+ ' ' +pageLimit);

                     ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
                system.debug('endTimes'+endTimes);
            }
                    if(endTime != null && endTime != ''){
                        List<Component_Task_Book__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Component_Task_Book__c) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Component_Task_Book__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Component_Task_Book__c)+ ' ' +
                                          CreateOrModifiedDate+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;

                    }else{
                        List<Component_Task_Book__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Component_Task_Book__c) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Component_Task_Book__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Component_Task_Book__c)+ ' ' +
                                          CreateOrModifiedDate2+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            
            if(SyncObject == 'Order'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<Order> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order));
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Order> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order)+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
                system.debug('endTimes'+endTimes);
            }
                    if(endTime != null && endTime != ''){
                        List<Order> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Order> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order)+ ' ' +
                                          CreateOrModifiedDate+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }else{
                        List<Order> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Order> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Order)+ ' ' +
                                          CreateOrModifiedDate2+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            
            if(SyncObject == 'OrderItem'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<OrderItem> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OrderItem));
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<OrderItem> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OrderItem)+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
                system.debug('endTimes'+endTimes);
            }
                    if(endTime != null && endTime != ''){
                        List<OrderItem> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OrderItem) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<OrderItem> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OrderItem)+ ' ' +
                                          CreateOrModifiedDate+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;     
                        return wrapper;
                    }else{
                        List<OrderItem> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OrderItem) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<OrderItem> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OrderItem)+ ' ' +
                                          CreateOrModifiedDate2+ ' ' +pageLimit);

                     ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;    
                        return wrapper;
                    }
                }
            }
            
            if(SyncObject == 'Amendment Purchase Agreement'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<Amendment__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c));
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Amendment__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c)+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
                system.debug('endTimes'+endTimes);
            }
                    if(endTime != null && endTime != ''){
                        List<Amendment__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Amendment__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c)+ ' ' +
                                          CreateOrModifiedDate+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }else{
                        List<Amendment__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Amendment__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment__c)+ ' ' +
                                          CreateOrModifiedDate2+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            
            if(SyncObject == 'Amendment Order Product'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<Amendment_Order_Product__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Order_Product__c));
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Amendment_Order_Product__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Order_Product__c)+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
                system.debug('endTimes'+endTimes);
            }
                    if(endTime != null && endTime != ''){
                        List<Amendment_Order_Product__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Order_Product__c) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Amendment_Order_Product__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Order_Product__c)+ ' ' +
                                          CreateOrModifiedDate+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }else{
                        List<Amendment_Order_Product__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Order_Product__c) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Amendment_Order_Product__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Order_Product__c)+ ' ' +
                                          CreateOrModifiedDate2+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            
            if(SyncObject == 'Amendment Payment'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<Amendment_Payment__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Payment__c));
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Amendment_Payment__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Payment__c)+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
                system.debug('endTimes'+endTimes);
            }
                    if(endTime != null && endTime != ''){
                        List<Amendment_Payment__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Payment__c) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Amendment_Payment__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Payment__c)+ ' ' +
                                          CreateOrModifiedDate+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }else{
                        List<Amendment_Payment__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Payment__c) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Amendment_Payment__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Amendment_Payment__c)+ ' ' +
                                          CreateOrModifiedDate2+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            
            if(SyncObject == 'Product'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<Product2> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Product2));
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Product2> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Product2)+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
            }
                    if(endTime != null && endTime != ''){
                        List<Product2> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Product2) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Product2> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Product2)+ ' ' +
                                          CreateOrModifiedDate+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }else{
                        List<Product2> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Product2) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Product2> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Product2)+ ' ' +
                                          CreateOrModifiedDate2+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            
        if(SyncObject == 'Project'){
                if(str3 == 'A'){
                    system.debug('111111');
                    List<Project__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Project__c));
                    Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Project__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Project__c)+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                    return wrapper;
                }else if(str3 == 'B'){
            if(endTime !=null && endTime !=''){
               endTimes = dateTime.valueOf(endTime); 
                endTimes = endTimes.addHours(8);
            }
                    if(endTime != null && endTime != ''){
                        List<Project__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Project__c) + ' ' +
                                          CreateOrModifiedDate);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Project__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Project__c)+ ' ' +
                                          CreateOrModifiedDate+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }else{
                        List<Project__c> obj = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Project__c) + ' ' +
                                          CreateOrModifiedDate2);
                        Decimal n=(Decimal)obj.size();
                    Decimal objSize = n/200;
                    Decimal oceil = Math.ceil(objSize);
                    List<Project__c> objs = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.Project__c)+ ' ' +
                                          CreateOrModifiedDate2+ ' ' +pageLimit);

                    ResultWrapper wrapper = new ResultWrapper();
                    wrapper.pageNumber = Integer.valueOf(oceil);
                    wrapper.pageSize = 200;
                    wrapper.objs = objs;
                        return wrapper;
                    }
                }
            }
            
            return null;
            
            
            
        //}
        //catch(Exception ex){
        //    system.debug(ex.getMessage());
        //    return ex.getMessage();
       // }
    }
    
    global class ResultWrapper{
        public Integer pageSize;
        public Integer pageNumber;
        public List<SObject> objs;
    }
    
}