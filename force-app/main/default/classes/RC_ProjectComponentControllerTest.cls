@IsTest
public without sharing class RC_ProjectComponentControllerTest {
    @testSetup
    static void setup(){
        Account accounts = QW_TestDataFactory.createAccount();
        insert accounts;
        leanx__pm_Project__c project = QW_TestDataFactory.createIProject();
        insert project;
        Product2 product2 = QW_TestDataFactory.createProduct2();
        insert product2;
        delete [SELECT Id FROM leanx__hr_Resource__c];
        leanx__hr_Resource__c product = QW_TestDataFactory.createProduct2(true);
        product.Product__c = product2.Id;
        insert product;
        leanx__pm_ProjectMember__c item = QW_TestDataFactory.createIProjectItemById(project.Id);
        item.Product__c = product.Id;
        insert item;
        User admin = QW_TestDataFactory.createUser();
        insert admin;
    }

    @isTest 
    static void test_init() {
        RC_ProjectComponentController.getComponentsByProjectId(JSON.serialize(new Map<String, Object>{
            'projectId' => [SELECT Id FROM leanx__pm_Project__c][0].Id
        }));
        RC_ProjectComponentController.getProducts(JSON.serialize(new Map<String, Object>{
            'query' => 'JKM'
        }));
    }

    @isTest 
    static void test_save() {
        RC_ProjectComponentController.setComponentsByProjectId(JSON.serialize(new Map<String, Object>{
            'items' => new List<RC_ProjectComponentController.ItemWrapper>{
                new RC_ProjectComponentController.ItemWrapper(
                    (leanx__pm_ProjectMember__c)Database.query(
                        QW_Utils.getQueryBySObjectType(leanx__pm_ProjectMember__c.getSObjectType(), new List<String>{
                            'Product__r.Name'
                        })
                    )[0]
                )
            }
        }));
    }

    @isTest 
    static void test_checkProduct() {
        RC_ProjectComponentController.checkProducts(JSON.serialize(new Map<String, Object>{
            'project' => [SELECT Id FROM leanx__pm_Project__c][0],
            'products' => new List<RC_ProjectComponentController.ItemWrapper>{
                new RC_ProjectComponentController.ItemWrapper(
                    (leanx__pm_ProjectMember__c)Database.query(
                        QW_Utils.getQueryBySObjectType(leanx__pm_ProjectMember__c.getSObjectType(), new List<String>{
                            'Product__r.Name'
                        })
                    )[0]
                )
            }
        }));
    }
}