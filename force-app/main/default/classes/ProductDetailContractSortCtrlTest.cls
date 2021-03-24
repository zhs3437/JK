@isTest
public class ProductDetailContractSortCtrlTest {
    static testmethod void test(){
         Account acc = TestHelper.createAccount();
        Contract con = TestHelper.createContract(acc.Id,false);
        con.Contract_NO__c = '2016101000';
        insert con;
        
        Product_Detail__c pd1	= TestHelper.createProductDetail(false);
        pd1.Contract_PO_PI__c	= con.Id;
        insert pd1;
        Product_Detail__c pd2	= TestHelper.createProductDetail(false);
        pd2.Contract_PO_PI__c	= con.Id;
        insert pd2;
        Product_Detail__c pd3	= TestHelper.createProductDetail(false);
        pd3.Contract_PO_PI__c	= con.Id;
        insert pd3;
        List<Contract> conLst = new List<Contract>();
        conLst.add(con);
        ApexPages.currentPage().getParameters().put('id',con.Id);
        ApexPages.StandardSetController ctrl = new ApexPages.StandardSetController(conLst);
        ProductDetailContractSortCtrl mdpc = new ProductDetailContractSortCtrl(ctrl);
        mdpc.ChangedId = '0';
        mdpc.UpDataList();
        mdpc.TopDataList();
        mdpc.DownDataList();
        mdpc.TailDataList();
        mdpc.doSave();     
        
       
        }
}