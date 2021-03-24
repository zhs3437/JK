/**
 *
 *create by Jason 20160602
 * 
 *补充协议审批测试类
 */
@isTest
private class AmendmentSubmitReviewCtrlTester {

    static testMethod void AmendmentSubmitReviewCtrlTest() {
        Amendment__c am = TestHelper.createAmendment(false);
        am.Amendment_Point__c = 'Specification of The Goods';
        insert am;
                
        SubmitForReview__c sfr = TestHelper.createSubmitForReview();
        list<SubmitForReview__c> sfrLst = new list<SubmitForReview__c>();
        sfrLst.add(sfr);
        ApexPages.currentPage().getParameters().put('id',am.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController( am );
        AmendmentSubmitReviewCtrl asrc  = new AmendmentSubmitReviewCtrl(new ApexPages.StandardController(am));
        asrc.existReviews = sfrLst;
        asrc.requestId = am.Id;
        asrc.revId = sfr.Id;
        
        asrc.SubmitApprove();
        asrc.SubmitReject();
   
    }
}