global class CreateModuleDesignProduct {
	webservice static String submit(List<Id> Ids){
		return SameNameOfProduct.sameNameError(Ids);
	}

    webservice static String submit2(List<Id> Ids){
		return SameNameOfProduct.sameNameError2(Ids);
	}
   
}