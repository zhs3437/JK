trigger PriceControl on OpportunityLineItem (before insert) {
    
    String runTest = '';
    
    /*
    List<OpportunityLineItem> all_opp_items = trigger.new;
    List<ID> pb_ids = new List<ID>();
    for(OpportunityLineItem item : all_opp_items){
        pb_ids.add(item.PricebookEntryId);
    }
    
    List<PricebookEntry> pbList = [SELECT Product2Id FROM PricebookEntry WHERE ID in: pb_ids];
    
    List<ID> prod_ids = new List<ID>();
    for(PricebookEntry pb : pbList){
        prod_ids.add(pb.Product2Id);
    }
    List<Product2> all_prods = [SELECT ID,Name,No_of_cells__c,Maximum_Power_at_STC_Pmax__c,SAP_Materiel_No__c,
        Maxim20MW__c,Maxim50MW__c,Maxim5MW__c,Solaredge20MW__c,Solaredge50MW__c,Solaredge5MW__c,Tigo20MW__c,Tigo50MW__c,Tigo5MW__c
        FROM Product2
        WHERE ID in: prod_ids];
    
    //初始化 Product2 Map
    Map<ID,Product2> map_prods = new Map<ID,Product2>();
    for(Product2 prod : all_prods){
        for(PricebookEntry pb : pbList){
            if(pb.Product2Id == prod.Id){
                map_prods.put(pb.ID,prod);
            }
        }
    }
    
    
    List<ID> opp_ids = new List<ID>();
    for(OpportunityLineItem item : all_opp_items){
        opp_ids.add(item.OpportunityId);
    }
    List<Opportunity> all_opps = [SELECT ID,Name,Country__c,Destination_Port__c,Trade_Term__c,Special_Price__c,Price_Approval_Status__c
        FROM Opportunity
        WHERE ID in: opp_ids];
    
    //初始化 Opportunity Map
    Map<ID,Opportunity> map_opps = new Map<ID,Opportunity>();
    for(Opportunity opp : all_opps){
        map_opps.put(opp.ID,opp);
    }
    
    //初始化Transit Fees Database
    List<Transit_Fees_Database__c> tfdList = new List<Transit_Fees_Database__c>();
    tfdList = [SELECT Port__c,Price__c,Size__c FROM Transit_Fees_Database__c];

    
    for(OpportunityLineItem opp_item : all_opp_items){
        Product2 product = map_prods.get(opp_item.PricebookEntryId);
        Opportunity opp  = map_opps.get(opp_item.OpportunityId);
        
        String junction_type = opp_item.Junction_Box_Brand__c;//接线盒类型
        Decimal total_mw     = 0;//兆瓦 - 1兆瓦= 1百万瓦
        
        String cell          = product.No_of_cells__c;// 60-60 || 72-72
        Decimal Pmax         = 0;
        Decimal cellNum      = 0;
        
        Pmax = product.Maximum_Power_at_STC_Pmax__c;
        
        if(cell.contains('72')){
            cellNum = 600;
        }else if(cell.contains('60')){
            cellNum = 700;
        }
        
        if(opp_item.CurrencyIsoCode == 'CNY'){
            total_mw     = (opp_item.Quantity * opp_item.UnitPrice * Pmax) / 6.2 / 1000000;
        }else{
            total_mw     = (opp_item.Quantity * opp_item.UnitPrice * Pmax) / 1000000;
        }
        
        
        //得出对比价
        Decimal compareNum = 0;
        if(junction_type == 'Tigo'){
            if(total_mw <= 5){
                compareNum = product.Tigo5MW__c;
            }else if(total_mw <= 20){
                compareNum = product.Tigo20MW__c;
            }else if(total_mw <= 50){
                compareNum = product.Tigo50MW__c;
            }
        }else if(junction_type == 'Maxim'){
            if(total_mw <= 5){
                compareNum = product.Maxim5MW__c;
            }else if(total_mw <= 20){
                compareNum = product.Maxim20MW__c;
            }else if(total_mw <= 50){
                compareNum = product.Maxim50MW__c;
            }
        }else if(junction_type == 'Solaredge'){
            if(total_mw <= 5){
                compareNum = product.Solaredge5MW__c;
            }else if(total_mw <= 20){
                compareNum = product.Solaredge20MW__c;
            }else if(total_mw <= 50){
                compareNum = product.Solaredge50MW__c;
            }
        }
        
        if(compareNum == null)compareNum = 0;
        
        
        //得出海运费    --  海运费（40）/700(60cell)||600(72Cell)/最大功率数   陆运费（40，记得转换成美金）
        Decimal tf_price = 0;
        if(opp.Trade_Term__c.contains('FOB')){
            
            for(Transit_Fees_Database__c tfd : tfdList){
                if(tfd.Size__c == '40HQ' && tfd.Port__c == opp.Destination_Port__c){
                    tf_price = tfd.Price__c;
                    break;
                }
            }
            
            if(Pmax != 0 && tf_price != 0)tf_price = tf_price / cellNum / Pmax;
            
        }
        
        //得出陆运费
        Decimal land_price = 0;
        if(opp.Trade_Term__c == 'CIF Shangrao'){
            land_price = 5574.9 / 6.2 / cellNum / Pmax;
        }else if(opp.Trade_Term__c == 'CIF Haining'){
            land_price = 4245 / 6.2 / cellNum / Pmax;
        }
        
        
        //用户填写的价格
        Decimal exist_price = 0;
        if(opp_item.CurrencyIsoCode == 'CNY'){
            exist_price = opp_item.UnitPrice / 6.2;
        }else{ //USD
            exist_price = opp_item.UnitPrice;
        }
        
        System.debug('***********total_mw: '+total_mw);
        System.debug('***********compareNum: '+compareNum);
        System.debug('***********land_price: '+land_price);
        System.debug('***********tf_price: '+tf_price);
        System.debug('***********exist_price: '+exist_price);
        
        //报错
        if(exist_price < (land_price+tf_price+compareNum) && opp.Price_Approval_Status__c != 'Approved'){
            opp_item.addError('The lowest price can not less than['+(land_price+tf_price+compareNum).setScale(3)+'],please turn back to Opportunity and click on [submit for special price] button to get approve if the price is special.');
        }
        
    }
    */
}