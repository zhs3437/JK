trigger capacitytrigger on CapacityReservation__c (after insert,before insert,after update,before update) {
     if (Trigger.isbefore) {
         if(Trigger.isinsert||trigger.isupdate){
                   for(CapacityReservation__c cr:trigger.new){
                       if(cr.ownerid=='0056F000009rUoA'){
                               if( cr.area__c  =='EU'|| cr.area__c=='Non EU'){
                cr.GM__c='005900000015hNj';
            }
            else if(cr.area__c =='EU(Union)'|| cr.area__c=='EU(Non-Eu)'){
               cr.GM__c='005900000015hNj';
            }
            else if(cr.area__c =='ROA'){
                cr.GM__c='0059000000126GB';
            }else if(cr.area__c =='North Asia'){
                cr.GM__c='0059000000126GD';
            }else if(cr.area__c =='South Asia'){
                cr.GM__c='00590000001VTWZ';
            }else if(cr.area__c =='North America'){
                cr.GM__c='00590000001VGKF';
            }else if(cr.area__c =='Middle East&Africa'){
                cr.GM__c='0059000000126GW';
            }else if(cr.area__c =='Latin America&Italy'){
                cr.GM__c='005900000012G4b';
            }
                           
                           
                           
                       }   
                   }
             
             
         }
         
     }
    /*
     if (Trigger.isafter) {
         
      List<CapacityReservation__Share> list_share = new List<CapacityReservation__Share>();
         id ownerid;
    String Userid;
       for(CapacityReservation__c cr:trigger.new){
           Userid=cr.ownerid;
           ownerid=cr.contract__r.ownerid;
           }
    system.debug('Userid'+Userid);
    User u=[select id,BMO_specialist__c,Contract_Approver__c from User where id=:Userid];
    for(CapacityReservation__c cr:trigger.new){
          CapacityReservation__Share share = new CapacityReservation__Share();
           share.UserOrGroupId =u.BMO_specialist__c;//需要共享给的用户 or 小组
           share.ParentId = cr.id;//记录id
           share.AccessLevel = 'read'; //edit:读写/read：只读
        list_share.add(share);
        CapacityReservation__Share share2 = new CapacityReservation__Share();
           share2.UserOrGroupId =u.Contract_Approver__c;//需要共享给的用户 or 小组
           share2.ParentId = cr.id;//记录id
           share2.AccessLevel = 'read'; //edit:读写/read：只读
           list_share.add(share2);
        CapacityReservation__Share share3 = new CapacityReservation__Share();
           share2.UserOrGroupId =u.id;//需要共享给的用户 or 小组
           share2.ParentId = cr.ownerid;//记录id
           share2.AccessLevel = 'read'; //edit:读写/read：只读
           list_share.add(share3);
            }
       if(list_share.size() > 0) insert list_share;
     }
    if (Trigger.isbefore) {

        for(CapacityReservation__c cr:trigger.new){
          system.debug('cr:'+cr);
           }
    }
*/
}