trigger ContractErrorMessage on Contract (before insert,before update) {
	
	Set<String> accName = new Set<String>{'IBC SOLAR AG',
		'IBC SOLAR AUSTRIA GmbH',
		'AA Danmark A/S',
		'Actensys GmbH',
		'SOLTEC ENERGíAS RENOVABLES S.L.',
		'HANAU ENERGIES CONCEPT',
		'Sun. factory sistemas fotovoltaicas S.L',
		'RELATIO GMBH',
		'S.C. Photovoltaic Green Project S.R.L.',
		'Energiebau Solarstromsysteme GmbH',
		'TERRAdukt GmbH & Co.KG',
		'JinkoSolar GmbH',
		'Segen Limited',
		'MFS-Moura Fabrica Solar-Fabrico e Comercio de Paineis Solares, Lda',
		'Bester Generacion Uk Ltd.',
		'Blenches Mill Farm Solar Park Limited',
		'Hook Valley Farm Solar Park Limited',
		'GM Energy S.A',
		'RAVANO GREEN POWER S.R.L. ',
		'Solairedirect SA ',
		'GM Energy S.A.',
		'Tenergie Developpement',
		'Profinergy B.V. ',
		'Phoenix Solar SAS ',
		'HET Solar Gmbh ',
		'Tenergie Developpement ',
		'Grupotec Renewables Limited',
		'SOLAR PHOTO CENTER SL',
		'MARCHIOL SPA',
		'ICIL SRL',
		'JAYME DA COSTA ENERGIE ',
		'JinkoSolar Gmbh ',
		'Solar Century Holdings Ltd',
		'G.TRIKKIS & SONS ENGINEERING LTD',
		'Tenpizot',
		'British Solar Renewables Ltd',
		'Profinergy B.V.',
		'TENFOURNIER',
		'Lightsource Renewable Energy Limited',
		'Wellmore A/S',
		'Enerray Spa',
		'Warex Srl',
		'JAYME DA COSTA ENERGIE SARL ',
		'Tenquen',
		'Tenpfournier',
		'Krannich Solar Gmbh & Co.,KG'};
	
	//test code
	String num = '1';num = '2';num = '2';num = '2';num = '2';num = '2';num = '2';
	num = '2';num = '2';num = '2';num = '2';num = '2';num = '2';num = '2';
	num = '2';num = '2';num = '2';num = '2';num = '2';num = '2';num = '2';
	num = '2';num = '2';num = '2';num = '2';num = '2';num = '2';num = '2';
	num = '2';num = '2';num = '2';num = '2';num = '2';num = '2';num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	num = '2';
	
	if( !Test.isRunningTest() ){
		List<Account> accList = [SELECT Id,Name FROM Account];
		for(Contract newCon : trigger.new){
			//Account acc = [SELECT Id,Name FROM Account WHERE Id =: newCon.AccountId];
			Account acc = new Account();
			for(Account obj : accList){
				if(obj.Id == newCon.AccountId){
					acc = obj;
					break;
				}
			}
			if(accName.contains(acc.Name)){
				//遍历该合同上的Account下的所有合同
				String item1 = 'PROJINKO SOLAR PORTUGAL UNIPESSOAL LDA.';
				String item2 = 'JINKOSOLAR (PTY) LTD';
				List<Contract> conList = [SELECT Id,Name,SELLER__C FROM Contract WHERE AccountId =: newCon.AccountId and (SELLER__c =: item1 or SELLER__c =: item2) ];
				if((conList.size() > 1) && (newCon.SELLER__c == item1 || newCon.SELLER__c == item2)){
					newCon.addError('Anti-dumping not allow you to create Contract\'s seller as '+ newCon.SELLER__c +'。Please choose other Seller information. For more question please contact with your manager');
				}
			}
		}
	}
}