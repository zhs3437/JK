public class SapAdminPageCtrl {
	public SapAdminPageCtrl(){
		String todo = '';
	}
	
	public void syncProduct(){
		SapIntegrationUtils.syncSapProduct();
	}
}