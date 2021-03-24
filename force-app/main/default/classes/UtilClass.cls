public with sharing class UtilClass {
	public static string MakeSelectSql(Schema.DescribeSObjectResult DescSobject){
		string sqlStr = '';
		Map<String, Schema.SObjectField> fieldsmap = DescSobject.fields.getMap();
    for (String fName : fieldsmap.keySet()){
        if(fName == 'billingaddress' || fName == 'shippingaddress' || fName == 'otheraddress' || fName == 'mailingaddress')continue;
        sqlstr = sqlstr + fName+',';
    }
    if(sqlstr.length()>0){
        sqlstr = sqlstr.substring(0,sqlstr.length()-1);
    }
    sqlstr = 'select '+sqlstr+' from '+ DescSobject.name;
 		//limit check
 		if(sqlstr.length()== 0) throw new MakeSqlException('The Object not exist'); 
 		//if(sqlstr.length()> 10000) throw new MakeSqlException('sql length over 10000'); 
		return sqlStr;
	}
	/**
	* GetObjByID
	* return [select * from Object where id=:id]
	*/
	public static sObject GetObjByID(Schema.DescribeSObjectResult DescSobject,string id){
        //return Database.query(MakeSelectSql(DescSobject)+' Where id =:id');
        List<sObject> objList = getObjsByID(DescSobject, id);
        if(objList != null && objList.size() > 0){
        	return objList[0];
        }

        return null;
	}
    	public class MakeSqlException extends Exception {}
    	public static List<sObject> getObjsByID(Schema.DescribeSObjectResult DescSobject,string id){
		return Database.query(MakeSelectSql(DescSobject)+' Where id =:id');
	}
}