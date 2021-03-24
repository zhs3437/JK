public with sharing class OpportunityHandle {    
    public static void handle(){
        set<id> oppIDlst = new set<id>();
        if(Trigger.isBefore){
            if(trigger.isDelete){
                oppIDlst = OpportunityHelper.oppIdLst(Trigger.old);
                Opportunity oppCh  = OpportunityHelper.oppCh(oppIDlst);
                if(oppCh.faOpportunity__c !=null){
                    Opportunity oppfa = OpportunityHelper.oppfa(oppCh);
                    List<Opportunity> oppChLst =  OpportunityHelper.oppChLst(oppfa);
                    OpportunityHelper.parentSub(oppfa,oppCh,oppChLst);
                }
            }
            /*   暂不开启未测试 （优化代码）
            //old Logic   赋值业务机会的BMO字段，日本法务字段的自动更新，若为澳大利亚的业务机会发送邮件
            if(Trigger.isInsert){
                OpportunityHelper.updateFiled(Trigger.new);
            }
            */
            if(trigger.isUpdate){
                if (OpportunityHelper.changedFaOpp(Trigger.new, Trigger.old)) {
                    oppIDlst = OpportunityHelper.oppIdLst(Trigger.new);
                    Opportunity oppCh  = OpportunityHelper.oppCh(oppIDlst);
                    Opportunity oppfa = OpportunityHelper.oppfa(oppCh);
                    List<Opportunity> oppChLst =  OpportunityHelper.oppChLst(oppfa);
                    //汇总做加法和减法的方法
                    OpportunityHelper.updateVolue(Trigger.new, Trigger.old,oppfa,oppCh,oppChLst);                              
                }               
                //抓取价格审批 提交时间  暂不开启未测试（优化代码）
                //OpportunityHelper.getDate(Trigger.new, Trigger.old);
				// 创建和更新业务机会的时候 
				// 若为澳大利亚快速流程更新字段 Australia_MW__c 为 true 暂不开启未测试（优化代码）
				//OpportunityHelper.updateAustralia(Trigger.new);
            }
        }
        if(trigger.isAfter){
            if(trigger.isInsert){
                oppIDlst = OpportunityHelper.oppIdLst(Trigger.new);
                Opportunity oppCh  = OpportunityHelper.oppCh(oppIDlst);
                Opportunity oppfa = OpportunityHelper.oppfa(oppCh);
                if(oppCh.faOpportunity__c !=null){
                    //获取主业务机会产品
                    List<OpportunityLineItem> oppLineItemLst = OpportunityHelper.oppLineItemLst(oppCh.faOpportunity__c);
                    //克隆主业务机会产品到子业务机会
                    OpportunityHelper.AddoppLineItem(oppLineItemLst,oppCh.id);
                    //克隆主业务机会付款方式到子业务机会
                    OpportunityHelper.clonePaymentItem(OpportunityHelper.paymentLst(oppfa.id), oppCh.id);
                }
                
                //满足条件发邮件给物流  暂不启用未测试（优化代码）
                /*
                if(OpportunityHelper.InsertSendOrNo(Trigger.new)){
                    SendEmailUtils.sendToLogistics(OpportunityHelper.getTriggerOpp(Trigger.new).Id);
                }
                */
            }
                   
            if(trigger.isUpdate){
                if (OpportunityHelper.changedProduct(Trigger.new,Trigger.old)) {
                    oppIDlst = OpportunityHelper.oppIdLst(Trigger.new);
                    Opportunity oppCh  = OpportunityHelper.oppCh(oppIDlst);                         
                    List<Opportunity> oppChLst =  OpportunityHelper.oppChLst(OpportunityHelper.updateVolue3(Trigger.new,oppCh));
                    OpportunityHelper.updateVolue2(trigger.new,trigger.old,OpportunityHelper.updateVolue3(Trigger.new,oppCh),oppCh,oppChLst);
                }                
                 
                //当Allow new process for japan = true 发送提醒邮件给业务机会Owner  old Logic  暂不开启未测试（优化代码
                //OpportunityHelper.japanAllowSendEmail(Trigger.new,Trigger.old);
            }
        }
        /**
        //create by:HanFan  20170726
        //当业务机会中的Finance Price Approval Status字段变为approved,或者GM approval为approved且Payment 1MW Approve为真触发
        if(Trigger.isAfter){
            system.debug('--------->:isAfter && update');
            OpportunityHelper.SendEmail(trigger.new,trigger.old);
             system.debug('sendEmail22222'); 
        }
*/
    }
}