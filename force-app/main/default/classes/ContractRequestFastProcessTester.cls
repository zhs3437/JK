/**
 *Create By jason 20160923
 */
@isTest
private class ContractRequestFastProcessTester {
    private static testMethod void webserviceSendEmail() {
        Account acc = TestHelper.createAccount();
        Contract con = TestHelper.createContract(acc.Id);
        ContractRequestFastProcessSendEmail.submit(con.Id);
    }
}