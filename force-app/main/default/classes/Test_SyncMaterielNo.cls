@isTest
public class Test_SyncMaterielNo {
	
	@IsTest(SeeAllData=true)
    static void myUnitTest() {
    	Account acc = new Account();
    	acc.Name = 'Account Name';
    	insert acc;
    	
    	Opportunity opp = new Opportunity(name='2MW-JKM180-20120101',AccountId=acc.id,
            CloseDate = Date.today(), StageName='Close Won',Probability=100,delivey_point__c='sad');
    	insert opp;
    	
    	SAP_Product__c sapProduct = new SAP_Product__c();
		sapProduct.Certification__c    = 'TUV';
    	sapProduct.Color_of_Module__c  = '白色';
    	sapProduct.Type_of_module__c   = '非智能组件';
    	sapProduct.Grade__c            = 'A级';
    	sapProduct.Special_required__c = '一般';
    	sapProduct.Bus_bars_of_cell__c = '4BB';
    	sapProduct.Product_Name__c     = 'JKM-260';
    	sapProduct.Product_Code__c     = '24000922';
    	insert sapProduct;
    	
    	Product2 p1 = new Product2(ProductCode = 'testProduct', 
            Name = 'JKM-260');
        insert p1;

        Pricebook2 pb = [Select Id From Pricebook2 Where Name = 'Standard Price Book' limit 1];
        
        PricebookEntry pbe = new PricebookEntry(Product2Id=p1.Id,Pricebook2Id=pb.Id,UnitPrice=10,UseStandardPrice=false,IsActive=true);
        insert pbe;
    	
    	OpportunityLineItem line = new OpportunityLineItem();
    	line.OpportunityId    = opp.Id;  
    	line.PricebookEntryId = pbe.Id;
    	line.Quantity         = 100;
    	line.TotalPrice       = 1000;
    	line.Certification__c    = 'TUV';
    	line.Color_of_Module__c  = '白色';
    	line.Type_of_module__c   = '非智能组件';
    	line.Grade__c            = 'A级';
    	line.Special_required__c = '一般';
    	line.Bus_bars_of_cell__c = '4BB';
    	line.Product_Name__c     = 'JKM-260';
        line.Battery_Type__c= 'Normal Cell';
        line.Guaranteed_Delivery_Date__c	= Date.Today();
    	//line.SAP_Materiel_No__c  = '';
    	System.debug('#########line.Product_Name__c1 : '+line.Product_Name__c);
		insert line;
		
		System.debug('#########line.Product_Name__c2 : '+line.Product_Name__c);
		
    }
}