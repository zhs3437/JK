@isTest
public with sharing class UtilClassTest {
    @isTest
    public  static void testIRR(){
    	decimal[] income = new decimal[]{ -7009.07 , 1204.54 , 3864.73 , 3957.91 , 3126.13 , 2993.30 , 2857.18 , 2796.50 , 2045.56 , -119.57 , 162.26 };


    }
    
	//Test Method

	//Test Method

	//Test Method
	public static testMethod void testGetObjByID(){
		System.assert( UtilClass.MakeSelectSql(SObjectType.Lead).startsWith('select'));
		Lead acc= new Lead(LastName= 'Test', Company='Company',Country__c='Algeria');
    insert acc;
    
		Lead acc2 = (Lead)UtilClass.GetObjByID(SObjectType.Lead,acc.id);
		System.assertEquals( acc.id,acc2.id);			
	}
	
}