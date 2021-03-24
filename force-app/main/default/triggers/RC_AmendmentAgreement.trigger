trigger RC_AmendmentAgreement on Amendment_Agreement__c (before update) {
      new RC_AmendmentAgreementBasicHandler().run();
}