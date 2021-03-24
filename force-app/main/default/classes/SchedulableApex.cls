global class SchedulableApex {
	global SchedulableApex(){
                
    }
    public void startCheckAccountGrading(){
        /*每天凌晨 */ 
        String s = System.schedule('CheckGradingClass', '0 0 0 * * ?', new CheckGradingClass()); 
    }
}