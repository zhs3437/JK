trigger UpdateExchangeRate on Account (before insert, before update) {
	try{
        GlobalSetting__c gsflag = GlobalSetting__c.getOrgDefaults();
    System.debug('gsflag.Account_Flag__c---->@@@'+gsflag.Account_Flag__c);
    if(gsflag.Account_Flag__c){
        if(Trigger.isUpdate){
            for ( Account account : trigger.new) {
            	
                //货币转换
                If(account.CurrencyIsoCode == 'GBP'){
                     account.Exchanged_Amount__c = 'GBP ' + string.valueOf((account.New_Available_Credit__c / Decimal.valueOf(system.Label.Rate_For_GBP_Credit)).setScale(4));
                     
                }If(account.CurrencyIsoCode == 'EUR'){
                     account.Exchanged_Amount__c = 'EUR ' + string.valueOf((account.New_Available_Credit__c / Decimal.valueOf(system.Label.Rate_For_EUR_Credit)).setScale(4));
                     
                }If(account.CurrencyIsoCode == 'AUD'){
                     account.Exchanged_Amount__c = 'AUD ' + string.valueOf((account.New_Available_Credit__c / Decimal.valueOf(system.Label.Rate_For_AUD_Credit)).setScale(4));
                     
                }If(account.CurrencyIsoCode == 'CAD'){
                     account.Exchanged_Amount__c = 'CAD ' + string.valueOf((account.New_Available_Credit__c / Decimal.valueOf(system.Label.Rate_For_CAD_Credit)).setScale(4));
                     
                }If(account.CurrencyIsoCode == 'JPY'){
                     account.Exchanged_Amount__c = 'JPY ' + string.valueOf((account.New_Available_Credit__c / Decimal.valueOf(system.Label.JYP_Rate_Credit)).setScale(4));
                     
                }If(account.CurrencyIsoCode == 'ZAR'){
                     account.Exchanged_Amount__c = 'ZAR ' + string.valueOf((account.New_Available_Credit__c / Decimal.valueOf(system.Label.Rate_For_ZAR_Credit)).setScale(4));
                    
                }
            } // end for new
        }
    }
    }catch( Exception e ){}
        
}