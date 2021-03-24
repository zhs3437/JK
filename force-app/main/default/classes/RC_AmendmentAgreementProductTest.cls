@IsTest
public without sharing class RC_AmendmentAgreementProductTest {
    @testSetup
    static void setup(){
        Account accounts = QW_TestDataFactory.createAccount();
        insert accounts;
        Amendment_Agreement__c agreement = QW_TestDataFactory.createAmendmentAgreement();
        insert agreement;
        Amendment_Agreement_Product__c agreementItem = QW_TestDataFactory.createAmendmentAgreementItemById(agreement.Id);
        insert agreementItem;
        User admin = QW_TestDataFactory.createUser();
        insert admin;
    }

    @isTest 
    static void test_init() {
        RC_AmendmentAgreementProductController.getComponentsByProjectId(JSON.serialize(new Map<String, Object>{
            'orderId' => [SELECT Id FROM Amendment_Agreement__c][0].Id
        }));
        RC_AmendmentAgreementProductController.getProducts(JSON.serialize(new Map<String, Object>{
            'query' => 'JKM'
        }));
    }

    @isTest 
    static void test_save() {
        RC_AmendmentAgreementProductController.setComponentsByProjectId(JSON.serialize(new Map<String, Object>{
            'items' => new List<RC_AmendmentAgreementProductController.ItemWrapper>{
                new RC_AmendmentAgreementProductController.ItemWrapper(
                    (Amendment_Agreement_Product__c)Database.query(
                        QW_Utils.getQueryBySObjectType(Amendment_Agreement_Product__c.getSObjectType(), new List<String>{
                            'Product__r.Name'
                        })
                    )[0]
                )
            }
        }));
    }
}