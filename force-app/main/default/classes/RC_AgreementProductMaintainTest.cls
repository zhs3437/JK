@IsTest
public without sharing class RC_AgreementProductMaintainTest {
    @testSetup
    static void setup(){
        Account accounts = QW_TestDataFactory.createAccount();
        insert accounts;
        Agreement__c agreement = QW_TestDataFactory.createAgreement();
        insert agreement;
        Agreement_Component__c agreementItem = QW_TestDataFactory.createAgreementItemById(agreement.Id);
        insert agreementItem;
        User admin = QW_TestDataFactory.createUser();
        insert admin;
    }

    @isTest 
    static void test_init() {
        RC_AgreementProductMaintainController.getComponentsByAgreementId(JSON.serialize(new Map<String, Object>{
            'orderId' => [SELECT Id FROM Agreement__c][0].Id
        }));
        RC_AgreementProductMaintainController.getProducts(JSON.serialize(new Map<String, Object>{
            'query' => 'JKM'
        }));
    }

    @isTest 
    static void test_save() {
        RC_AgreementProductMaintainController.setComponentsByAgreementId(JSON.serialize(new Map<String, Object>{
            'items' => new List<RC_AgreementProductMaintainController.ItemWrapper>{
                new RC_AgreementProductMaintainController.ItemWrapper(
                    (Agreement_Component__c)Database.query(
                        QW_Utils.getQueryBySObjectType(Agreement_Component__c.getSObjectType(), new List<String>{
                            'Product__r.Name'
                        })
                    )[0]
                )
            }
        }));
    }
}