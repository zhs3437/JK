global class SendEmailUtils2 {
   webservice static String sendToSomeOne(String conid,String name, String emailTemplateName){
        List<User> recipient= [SELECT ID,Name,Email FROM User WHERE Name =: name];
         System.debug('----->recipient:'  + recipient);
        System.debug('----->recipient:'  + emailTemplateName);
        Utils.sendEmailWithTemplate(recipient, conid, emailTemplateName);
        System.debug('----->是否发送:'  + recipient);
        return '';
    }
      //发送邮件给指定的人员  create By Han 20180105
    webservice static String sendToSomeOneId(String conid,Id usId, String emailTemplateName){
        List<User> recipient= [SELECT ID,Name,Email FROM User WHERE ID =: usId];
         System.debug('----->recipient:'  + recipient);
        System.debug('----->recipient:'  + emailTemplateName);
        Utils.sendEmailWithTemplate(recipient, conid, emailTemplateName);
        System.debug('----->是否发送:'  + recipient);
        return '';
    }
}