public class MOUOpportunityCreate {
	public List<RecordType> recordTypeList{
		get;set;
	}
	Public String redirectUrl {
		get;set;
	}
	public Opportunity MOUOpportunity {
		get;set;
	}
	public Integer page{
		get;set;
	}
	public Boolean message{
		get;set;
	}
	public Integer delCount {
		get;set;
	}
	Public List<OpportunityLineItem> opportunityLineItemList{
		get;set;
	}
	Public List<Payment__c> paymentList{
		get;set;
	}

	public MOUOpportunityCreate(ApexPages.Standardcontroller sd) {
		Id recordTypeId = System.currentPageReference().getParameters().get('RecordType');
		Id id = System.currentPageReference().getParameters().get('Id');
		Id accId = System.currentPageReference().getParameters().get('accId');
		RecordType rt = [SELECT Id, Name FROM RecordType WHERE id =: recordTypeId];
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***recordTypeId:' + recordTypeId);
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***id:' + id);
		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***accId:' + accId);
		message = false;

		DescribeSObjectResult result = Schema.SObjectType.Opportunity;
		Set<String> recordTypeSet = new Set<String>();
		recordTypeSet.add('Letter of Award');
		recordTypeSet.add('General Terms and Conditions');
		recordTypeSet.add('Memorandum of Understanding');
		recordTypeSet.add('Letter of Intention');
		recordTypeSet.add('Head of Terms');
		recordTypeSet.add('Master Supply Agreement');
		recordTypeSet.add('Frame Agreement');
		recordTypeSet.add('Distribution Agreement');
		//获取所有业务机会的记录类型
		recordTypeList = [SELECT id, name, Description FROM recordtype WHERE sobjecttype =: 'Opportunity' AND Name IN :recordTypeSet];
		Set<Id> recordTypeIdList = new Set<Id>();
		for (RecordType record : recordTypeList) {
			recordTypeIdList.add(record.Id);
		}
		if(!recordTypeIdList.contains(recordTypeId)){
			if(accId == null){
				this.redirectUrl = '/' + result.getKeyPrefix() + '/e?RecordType=' + recordTypeId + '&nooverride=1';
			}else{
				this.redirectUrl = '/' + result.getKeyPrefix() + '/e?RecordType=' + recordTypeId +'&accid='+accId+ '&nooverride=1';
			}
		}else{
			if(accId != null){
				this.redirectUrl = '/apex/MOUOpportunityCreation' + '?id='+accId+'&recordTypeId=' + recordTypeId;
			}else{
//				message = true;
				this.redirectUrl = '/apex/MOUOpportunityCreation' + '?recordTypeId=' + recordTypeId;
			}
		}
		/*
		 * if (oc != null && oc.get('RedirectUrl') != null) {
		 * this.redirectUrl = oc.get('RedirectUrl') + '?recordTypeId=' + recordTypeId;
		 * } else {
		 */

		System.debug(LoggingLevel.DEBUG, '[MOUOpportunityCreate]***redirectUrl:' + redirectUrl);
	}

	public PageReference createOpp() {
		if (redirectUrl != null) {
			PageReference pr = new PageReference(redirectUrl);
			return pr;
		}
		return null;
	}
}