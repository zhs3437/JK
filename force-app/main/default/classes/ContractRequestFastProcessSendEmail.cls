/*
 *Create By Jason 21060831
 *申请特批发送邮件给财务和BMO
 */
global class ContractRequestFastProcessSendEmail {
	webservice static String submit(String conId){
		if(string.isEmpty(conId))return 'Contract Id is null';
		Contract con = [select id, OwnerId from Contract where id =:conId];
		SendEmailUtils.sendToFinanceAlex(con.Id);
		SendEmailUtils.sendToBMOCathy(con.Id);
		return 'success';
	}
}