public with sharing class AmendmentInlineSection {
    public List<Amendment__c> sas =  new List<Amendment__c>();
    public Amendment__c sa{get;set;}
    
    // change to follow text for New Line
    public String replaceText = '---------------------- Please Double-Click to Edit the New Line! ----------------------';
    
    public AmendmentInlineSection(ApexPages.StandardController ctrl ) {
        String theId = ctrl.getId();
        if( String.IsNotBlank( theId ) )
            sas = Database.query(Utils.MakeSelectSql('Amendment__c')  + ' WHERE Id =: theId');
        if( sas.size()>0 )
            sa = sas[0];
                        
    }
    
    
    public void doSave(){
        //Amendment__c sa1 = new Amendment__c();
        
        if( sa != null){
            update sa;
        }
    }
    
    public void doNewLine(){
        String[] Amendments = new String[]{ sa.Amendment3__c, sa.Amendment4__c,sa.Amendment5__c,
                                            sa.Amendment6__c, sa.Amendment7__c};
                        
        // create new line, and initialize the value of textarea
        if( sa != null ){
            Integer i=0;
            for(  i=0 ; i<Amendments.size() ; i++ ){
                if( String.isBlank( Amendments[i] ) ){
                    if( i==0 )   sa.Amendment3__c = replaceText ;
                    else if( i==1 )    sa.Amendment4__c = replaceText;
                    else if( i==2 )    sa.Amendment5__c = replaceText ;
                    else if( i==3 )    sa.Amendment6__c = replaceText ;
                    else if( i==4 )    sa.Amendment7__c = replaceText ;
                    break;
                }
            system.debug('~~~~~~~'+sa+'~~~~~~'+sa.Amendment3__c);
                
            }// end for
        }// end if
    }
    
    public void doDelLine(){
        
        String[] Amendments = new String[]{ sa.Amendment7__c,sa.Amendment6__c,sa.Amendment5__c,
                                        sa.Amendment4__c,sa.Amendment3__c};
                        
        // set PO Remark to null
        if( sa != null ){
            Integer i=0; 
            for(  i=0 ; i<Amendments.size(); i++ ){
                if( String.isNotBlank( Amendments[i] ) ){  
                    if( i==0 )   sa.Amendment7__c = null;
                    else if( i==1 )    sa.Amendment6__c = null;
                    else if( i==2 )    sa.Amendment5__c = null;
                    else if( i==3 )    sa.Amendment4__c = null;
                    else if( i==4 )    sa.Amendment3__c = null;
                    
                    break;
                }
            system.debug('~~~~~~~'+sa+'~~~~~~'+sa.Amendment3__c);
                
            }// end for
        }// end if
    
    }
    
    
}