@isTest
public class PrintContractDateTester {
    static testMethod void print(){
        Account acc = TestHelper.createAccount();
        Contract con  = TestHelper.createContract(acc.Id,false);
        con.Print_Contract_Date__c = Date.today();
        insert con;
        PrintContractDate.print(con.Id);
    }
}