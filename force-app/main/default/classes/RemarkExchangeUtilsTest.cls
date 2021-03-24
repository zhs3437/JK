@isTest
public class RemarkExchangeUtilsTest {
    static testMethod void myUnitTest() {
        Account acc = TestHelper.createAccount();
        Contract con = TestHelper.createContract(acc.Id,false);
        con.Payment_Term_Description__c = 'Payment Trem T/T';
        insert con;
        RemarkExchangeUtils reu = new RemarkExchangeUtils();
        reu.Australia_DDP(con);
        reu.Australia_EXW(con);
        reu.DDP_Linear_NoSino(con);
        reu.DDP_Linear_Sino(con);
        reu.DDP_Standard_NoSino(con);
        reu.DDP_Standard_Sino(con);
        reu.EXW_Linear_NoSino(con);
        reu.EXW_Linear_Sino(con);
        reu.EXW_Standard_NoSino(con);
        reu.EXW_Standard_Sino(con);
        reu.GTAC_DDP_Linear_NoSino(con);
        reu.GTAC_DDP_Linear_Sino(con);
        reu.GTAC_DDP_Standard_NoSino(con);
        reu.GTAC_DDP_Standard_Sino(con);
        reu.GTAC_EXW_Linear_NoSino(con);
        reu.GTAC_EXW_Linear_Sino(con);
        reu.GTAC_EXW_Standard_NoSino(con);
        reu.GTAC_EXW_Standard_Sino(con);
    }
}