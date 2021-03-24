@isTest
public class AorderPrintingTimeTest {
    static testMethod void myTest(){
        Account acc         = TestHelper.createAccount();
        Contract ct =TestHelper.createContract(acc.id);
        order lm =TestHelper.createOrder();
        lm.Pricebook2Id =Test.getStandardPriceBookID();
        lm.AccountId=acc.id;
        lm.EffectiveDate=date.today();
        lm.Status='Draft';
        lm.MaxRowNo__c=10;
        update  lm;
        Amendment__c ad=new Amendment__c();
        ad.Order__c=lm.id;
        ad.lock__c=false;
        insert ad;
        AorderPrintingTime apt =new AorderPrintingTime();
        String str = ad.id;
        SubmitForReview__c sf =new SubmitForReview__c();
        sf.Amendment__c= ad.id;
        
        insert sf;
        AorderPrintingTime.addtime(str);
        AorderPrintingTime.Legaladdtime(str);
        AorderPrintingTime.apprel(str);
        AorderPrintingTime.contractTF(ct.id);
        AorderPrintingTime.HaveUnLockAmend(lm.id);
        AorderPrintingTime.HaveUnLockCon(ct.id);
        AorderPrintingTime.AustraliaEmail(lm.Id);
    
    }
}