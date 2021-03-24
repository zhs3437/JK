public with sharing class InventoryList { 
	public string warehouse{get;set;}
	public string ProductType{get;set;}
	public List<Inventory__c> Inventorys{
		get{
			return [select Name, warehouse__c,BL_NO__c,Product_Type__c,Booked_Quantity__c,
				Expected_Time_Of_Delivery__c,Remaining_Quantity__c,Container_Type__c,Expected_Time_Of_Arrival__c
			from Inventory__c 
			where warehouse__c =:warehouse 
			and Remaining_Quantity__c > 0 
			and Product_Type__c =:ProductType
			limit 2000];
		}
		set;
	}
	
	public static testMethod void onTest(){
   	Product2 p1 = new Product2(ProductCode = 'testProduct1', Name = 'TestProduct1');
   	Product2 p2 = new Product2(ProductCode = 'testProduct2', Name = 'TestProduct2');
   	insert p1;
   	insert p2;
   	Warehouse__c w1 = new Warehouse__c(Name = 'Warehouse1');
   	Warehouse__c w2 = new Warehouse__c(Name = 'Warehouse2');
   	insert w1;
   	insert w2;
		Inventory__c i1=new Inventory__c(warehouse__c=w1.Id,Product_Type__c=p1.Id,Quantity__c=700,BL_NO__c ='NL00');
		Inventory__c i2=new Inventory__c(warehouse__c=w1.Id,Product_Type__c=p2.Id,Quantity__c=700,BL_NO__c ='NL01');
		Inventory__c i3=new Inventory__c(warehouse__c=w2.Id,Product_Type__c=p2.Id,Quantity__c=700,BL_NO__c ='NL03');
   	insert i1;
   	insert i2;
   	insert i3;
   	InventoryList il=new InventoryList();
   	il.warehouse=w1.Id;
   	il.ProductType=p1.Id;
   	System.assertEquals(il.Inventorys.size(), 1);
	}
}