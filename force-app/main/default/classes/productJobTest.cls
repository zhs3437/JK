@isTest
public class productJobTest {
        static testMethod void deliveryBatch(){
                 Product2 prod1 = TestHelper.createProduct2();
              User user1 = new User();
        user1.Username = 'u1'+System.now().getTime()+'@qq.com';
        user1.Email = 'winhunter@qq.com';
        user1.FirstName = 'javen';
        user1.LastName = 'hao';
        user1.Alias = 'UHao';
        user1.ProfileId = UserInfo.getProfileId();
        user1.TimeZoneSidKey='Asia/Shanghai';
        user1.LocaleSidKey='en_US';
        user1.EmailEncodingKey='ISO-8859-1';
        user1.LanguageLocaleKey='en_US';
        user1.Contract_Approver__c = user1.Id;
        user1.Contract_Review__c = user1.Id;
        user1.BMO_specialist__c = user1.Id;
        insert user1;
                 SchedulableContext sc = null;
   productschedulejob dsj6 = new productschedulejob();        
        dsj6.execute(sc);
            }
}