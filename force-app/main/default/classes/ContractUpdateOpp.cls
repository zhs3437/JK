global class ContractUpdateOpp {
    webservice static void main(String con){
        Contract co=[SELECT id,Name,RecordTypeName__c,Legal_Dept__c,BMO_Dept__c,Destination_Region__c,Opp_approval__c,CMO_Dept__c,Opportunity__c from Contract where id=:con];
        if(co !=null){
            Opportunity opp = [SELECT ID,AccountId,
                                 StageName,
                                 RecordType.Name,
                                 Payment_1MW_Approve__c,
                                 Total_MW__c,
                                 Trade_Term__c,
                                 Total_Quantity__c,
                                 Payment_Term_Description__c,
                                 whether_pick_up_batch__c,
                                 Price_Approval_Status__c,
                                 Sales_manager_approval__c,
                                 Customer_Type__c,
                                 Allow_new_process_for_Japan_picklist__c,
                                 Seller__c,
                                 Destination_Country__c,
                                 Special_Terms__c,
                                 Region__c,
                                 QuoteNum__c,
                                 Price_Approval_Trigger_Time__c,
                                 Contract__c,
                                 Contract_No__c,
                                 Account.credit_good__c,
                                 Owner.Name,
                                 Sales_Region__c,
                                 Owner.Region__c,
                                 Probability
                                 FROM Opportunity 
                                 WHERE id =:co.Opportunity__c ];
            
            if(co.RecordTypeName__c !='1MW Australia Contract' && co.RecordTypeName__c !='1MW Global Standard Contract' && co.RecordTypeName__c !='1MW Japan Contract'){
                    System.debug('20200618------------>1');
                    if(co.Legal_Dept__c=='Approved'){
                        
                        if(opp != null && opp.Probability<100){
                            System.debug('@@--@@1');
                            System.debug('opp------1>'+opp.StageName);
                            System.debug('opp.id------>'+opp.Id);
                            opp.StageName='PO Imminent';
                            opp.Probability=75;
                            System.debug('opp------2>'+opp.StageName);
                            update opp;
                            System.debug('走完'+opp.StageName);
                        }
                    }
                }else if(co.RecordTypeName__c =='1MW Australia Contract' || co.RecordTypeName__c =='1MW Global Standard Contract' || co.RecordTypeName__c =='1MW Japan Contract'){
                    System.debug('20200618------------>2');
                    
                    System.debug('opp.Probability----------->'+opp.Probability);
                    if(co.BMO_Dept__c =='Approved' ){
                        if(((co.Destination_Region__c=='Middle East&Africa' ||co.Destination_Region__c == 'MENA'||co.Destination_Region__c == 'SSA' || co.Destination_Region__c=='Latin America&Italy' || co.Destination_Region__c=='EU(Union)' || co.Destination_Region__c=='EU(Non-Eu)') && co.Opp_approval__c==true) || co.CMO_Dept__c=='Approved'){
                            if(opp != null && opp.Probability<100){
                                System.debug('@@--@@2');
                                System.debug('opp------1>'+opp.StageName);
                                System.debug('opp.id------>'+opp.Id);
                                opp.StageName='PO Imminent';
                                opp.Probability=75;
                                System.debug('opp------2>'+opp.StageName);
                                update opp;
                                System.debug('走完'+opp.StageName);
                            }
                        }
                    }
                }

        }
}

}