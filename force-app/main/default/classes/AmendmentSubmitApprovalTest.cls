@isTest
private class AmendmentSubmitApprovalTest {

    static testMethod void AmendmentSubmitReviewCtrlTest() {
        Amendment__c am = TestHelper.createAmendment(false);
        am.Amendment_Point__c = 'Specification of The Goods';
        insert am;
                
        SubmitForReview__c sfr = TestHelper.createSubmitForReview();
        list<SubmitForReview__c> sfrLst = new list<SubmitForReview__c>();
        sfrLst.add(sfr);
        ApexPages.currentPage().getParameters().put('id',am.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController( am );
        AmendmentSubmitApprovalCtrl asrc  = new AmendmentSubmitApprovalCtrl(new ApexPages.StandardController(am));
   
    }
}