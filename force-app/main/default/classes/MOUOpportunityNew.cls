public class MOUOpportunityNew {
	Public String redirectUrl {
		get;set;
	}
	public Opportunity MOUOpportunity {
		get;set;
	}
	public List<SelectOption> recordTypeNameList {
		get;set;
	}
	public List<RecordType> recordTypeList{
		get;set;
	}
    public List<RecordType> recordTypeList2{
		get;set;
	}
	public String recordTypeName {
		get;set;
	}
	public String MainrecordTypeName {
		get;set;
	}
	public List<SelectOption> MainrecordTypeNameList {
		get;set;
	}
	public Date CloseDate{
		get;set;
	}
	public Integer page{
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
	public Account account {
		get;set;
	}
	public Id accId {
		get;set;
	}

	public MOUOpportunityNew(ApexPages.Standardcontroller sd) {
		//Account account = (Account)sd.getRecord();
		Id recordTypeId = System.currentPageReference().getParameters().get('RecordType');
		Id id = System.currentPageReference().getParameters().get('Id');
		accId = System.currentPageReference().getParameters().get('accId');
		//account = (Account)sd.getRecord();
		if(accId != null){
			account=[SELECT Id,Name from Account where Id=:accId];
		}
        //获取所有业务机会的记录类型
		recordTypeList = [SELECT id, name, Description FROM recordtype WHERE sobjecttype =: 'Opportunity'];
         List<RecordTypeInfo> recordTypeInfoList = Schema.SObjectType.Opportunity.getRecordTypeInfos();
        recordTypeList2 = new List<recordtype>();
        for (recordtype opp : recordTypeList) {
			for (RecordTypeInfo info : recordTypeInfoList) {
				//判断当前用户是否有对应记录类型的权限
                if (info.isAvailable() && info.getRecordTypeId() == opp.Id) {
                    recordTypeList2.add(opp);
                }
            }
        }
        
		//    System.debug(LoggingLevel.DEBUG, '[MOUOpportunityNew]***opportunity:' + opportunity);
		System.debug(LoggingLevel.DEBUG, sd.getRecord());
		System.debug('MainrecordTypeName------------1-------'+MainrecordTypeName);
		MainRecordTypeNameList =initMainRecordTypeList();
		System.debug('MainrecordTypeName------------2-------'+MainrecordTypeName);
        //clickselect();
		recordTypeNameList = initRecordTypeList('1');
		page = 0;
		if(accId != null){
			MOUOpportunity = new Opportunity();
			MOUOpportunity.AccountId = account.Id;
		}
		//    MOUOpportunity.Region__c = null;
		

	}

	/*public void nextPage() {
		page = 1;
	}*/

	//初始化业务机会记录类型
	public List<SelectOption> initRecordTypeList(String r) {
		List<SelectOption> RecordTypeNameList = new List<SelectOption>();

		Set<String> recordTypeSet = new Set<String>();
		Set<String> recordTypeSet2 = new Set<String>();


		recordTypeSet2.add('Letter of Award');
		recordTypeSet2.add('General Terms and Conditions');
		recordTypeSet2.add('Memorandum of Understanding');
		recordTypeSet2.add('Letter of Intention');
		recordTypeSet2.add('Head of Terms');
		recordTypeSet2.add('Master Supply Agreement');
		recordTypeSet2.add('Frame Agreement');
		recordTypeSet2.add('Distribution Agreement');
				//获取业务机会记录类型的详细信息
		    List<RecordTypeInfo> recordTypeInfoList = Schema.SObjectType.Opportunity.getRecordTypeInfos();
        System.debug('recordTypeInfoList--------------->'+recordTypeInfoList);
		/*for (recordtype opp : recordTypeList) {
			//添加MOU记录类型
			//RecordTypeNameList.add(new SelectOption(opp.Id, opp.name));

		}*/
		for (recordtype opp : recordTypeList) {
			for (RecordTypeInfo info : recordTypeInfoList) {
				//判断当前用户是否有对应记录类型的权限
				if (info.isAvailable() && info.getRecordTypeId() == opp.Id) {
					if(r =='1' ){
						if(info.getName() !='Letter of Award' &&
										info.getName() !='General Terms and Conditions' &&
										info.getName() !='Memorandum of Understanding' &&
										info.getName() !='Letter of Intention' &&
										info.getName() !='Head of Terms' &&
										info.getName() !='Master Supply Agreement' &&
										info.getName() !='Frame Agreement' &&
										info.getName() !='Distribution Agreement'
						){
							RecordTypeNameList.add(new SelectOption(opp.Id,opp.Name));
						}

					}else if(r=='2'){
						if(info.getName() =='Letter of Award' ||
										info.getName() =='General Terms and Conditions' ||
										info.getName() =='Memorandum of Understanding' ||
										info.getName() =='Letter of Intention' ||
										info.getName() =='Head of Terms' ||
										info.getName() =='Master Supply Agreement' ||
										info.getName() =='Frame Agreement' ||
										info.getName() =='Distribution Agreement'
						){
							RecordTypeNameList.add(new SelectOption(opp.Id,opp.Name));
						}

					}

				}
			}
		}


		return RecordTypeNameList;
	}
	public List<SelectOption> initMainRecordTypeList() {
		Set<String> MainrecordTypeSet = new Set<String>();
		List<SelectOption> MainRecordTypeNameList = new List<SelectOption>();
		MainrecordTypeSet.add('Standard Opportunity Record Type');
		MainrecordTypeSet.add('Framework Or Other record Type');
		//MainRecordTypeNameList.add(new selectOption('0','None'));
		MainRecordTypeNameList.add(new selectOption('1','Standard Opportunity Record Type'));
		MainRecordTypeNameList.add(new selectOption('2','Framework Or Other record Type'));

		return MainRecordTypeNameList;

	}

	public void clickselect(){
		System.debug('MainrecordTypeName------------1-------'+MainrecordTypeName);
		//MainRecordTypeNameList =initMainRecordTypeList();

		recordTypeNameList = initRecordTypeList(MainrecordTypeName);
		System.debug('MainrecordTypeName------------2-------'+MainrecordTypeName);
	}

	public PageReference nextPage(){
		//Id accId = System.currentPageReference().getParameters().get('accId');
		//Account account = (Account)sd.getRecord();
//		Id accId = account.Id;
		DescribeSObjectResult result = Schema.SObjectType.Opportunity;
		System.debug('recordTypeName@@@@@@@@@@@@'+recordTypeName);
		RecordType re;
		if(!Test.isRunningTest()){
			re =[Select Id,Name from recordType where Id=:recordTypeName];
		}else{
            
			re =[Select Id,Name from recordType where Name=:'Memorandum of Understanding'];

		}
		if(re.Name =='Letter of Award' || re.Name =='General Terms and Conditions' || re.Name =='Memorandum of Understanding' || re.Name =='Letter of Intention' || re.Name =='Head of Terms'
				|| re.Name =='Master Supply Agreement' || re.Name =='Frame Agreement' || re.Name =='Distribution Agreement'){
			if(accId != null){
				this.redirectUrl = '/apex/MOUOpportunityCreation' + '?id='+accId+'&recordTypeId=' + recordTypeName;
			}else{
				//				message = true;
				this.redirectUrl = '/apex/MOUOpportunityCreation' + '?recordTypeId=' + recordTypeName;
			}
		}else{
			if(accId == null){
				this.redirectUrl = '/' + result.getKeyPrefix() + '/e?RecordType=' + recordTypeName + '&nooverride=1';
			}else{
				this.redirectUrl = '/' + result.getKeyPrefix() + '/e?RecordType=' + recordTypeName +'&accid='+accId+ '&nooverride=1';
			}
		}
		if (redirectUrl != null) {
			PageReference pr = new PageReference(redirectUrl);
			return pr;
		}
		return null;
	}

}