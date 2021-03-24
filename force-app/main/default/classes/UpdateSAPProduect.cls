global class UpdateSAPProduect {
	webservice static String submit(String pid){
		SapIntegrationUtils.syncSapProduct();
		return 'success';
	}

}