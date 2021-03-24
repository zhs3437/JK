trigger ContractAttachmentTrigger on Attachment (after insert) {
  if(Trigger.isAfter){
        if(Trigger.isInsert){
            try{
                String parentID = null;
                String parentNAME = null;
                String rfxID = null;
                String FileType=null;
                List <Attachment> attachments = new List <Attachment>();
                for( Attachment att: Trigger.new ){ 
                    rfxID = att.parentid;
                    parentNAME = att.Name;
                    parentID = att.id;
                    FileType =att.ContentType;                    
                    Attachment attachment = new Attachment();
                	attachment.id=att.id;
                    attachment.Name=att.name;
					attachments.add(attachment);                    
                }
            
                if(rfxID.startsWith(Schema.SObjectType.Contract.getKeyPrefix())){ 
                    Contract rfx =new Contract();
                    rfx = [select id,upFile__c,Destination_Country__c from Contract where id =: rfxID];
                    system.debug('内容-------'+rfx);
                    if(parentNAME!=null && rfx.Destination_Country__c=='Ukraine' && (parentNAME.contains('Technology')||parentNAME.contains('technology'))){
                        system.debug('开始-------');
                        rfx.upFile__c=true;
                        update attachments;
                    }
                    if(rfx != null){
                        update rfx;
                        
                    }
                }
            }
            catch(Exception ex){
                
            }
        }
    }

}