/**
 * Add by Javen, 20130115, for work piece(20130115-00004) 
 */
public with sharing class ContractInlineSection {

    public Contract con{get;set;}
    
    
    // change to follow text for New Line
    public String replaceText = '---------------------- Please Double-Click to Edit the New Line! ----------------------';
    
    public ContractInlineSection(ApexPages.StandardController ctrl ) {
        String theId = ctrl.getId();
        if( String.IsNotBlank( theId ) )
            con = (Contract )CommonUtils.GetObjById( 'Contract' , theId );
           
    }
    
    public void doSave(){
    	Contract con1 = new Contract();
    	
    	if( con != null ){
    		update con;
    	}
    
    }
    
    public void doNewLine(){
        String[] Remarks = new String[]{ con.PO_Remarks_8__c, con.PO_Remarks_9__c,con.PO_Remarks_10__c,
        				con.PO_Remarks_11__c, con.PO_Remarks_12__c,con.PO_Remarks_13__c,con.PO_Remarks_14__c,
        				con.PO_Remarks_15__c,con.PO_Remarks_16__c,con.PO_Remarks_17__c,con.PO_Remarks_18__c,
        				con.PO_Remarks_19__c,con.PO_Remarks_20__c };
        				
        // create new line, and initialize the value of textarea
        if( con != null ){
            Integer i=0;
            for(  i=0 ; i<Remarks.size() ; i++ ){
                if( String.isBlank( Remarks[i] ) ){
                    if( i==0 )   con.PO_Remarks_8__c = replaceText ;
                    else if( i==1 )    con.PO_Remarks_9__c = replaceText;
                    else if( i==2 )    con.PO_Remarks_10__c = replaceText ;
                    else if( i==3 )    con.PO_Remarks_11__c = replaceText ;
                    else if( i==4 )    con.PO_Remarks_12__c = replaceText ;
                    else if( i==5 )    con.PO_Remarks_13__c = replaceText ;
                    else if( i==6 )    con.PO_Remarks_14__c = replaceText ;
                    else if( i==7 )    con.PO_Remarks_15__c = replaceText ;
                    else if( i==8 )    con.PO_Remarks_16__c = replaceText ;
                    else if( i==9 )    con.PO_Remarks_17__c = replaceText ;
                    else if( i==10 )    con.PO_Remarks_18__c = replaceText ;
                    else if( i==11 )    con.PO_Remarks_19__c = replaceText ;
                    else if( i==12 )    con.PO_Remarks_20__c = replaceText ;
                    break;
                }
            }// end for
        }// end if
    }
    
    public void doDelLine(){
        
        String[] Remarks = new String[]{ con.PO_Remarks_20__c,con.PO_Remarks_19__c,con.PO_Remarks_18__c,
        								con.PO_Remarks_17__c,con.PO_Remarks_16__c,con.PO_Remarks_15__c,
        								con.PO_Remarks_14__c,con.PO_Remarks_13__c,con.PO_Remarks_12__c,con.PO_Remarks_11__c,
                        				con.PO_Remarks_10__c, con.PO_Remarks_9__c,con.PO_Remarks_8__c };
                        
        // set PO Remark to null
        if( con != null ){
            Integer i=0;
            for(  i=0 ; i<Remarks.size(); i++ ){
                if( String.isNotBlank( Remarks[i] ) ){  
                    if( i==0 )   con.PO_Remarks_20__c = null;
                    else if( i==1 )   con.PO_Remarks_19__c = null;
                    else if( i==2 )   con.PO_Remarks_18__c = null;
                    else if( i==3 )    con.PO_Remarks_17__c = null;
                    else if( i==4 )    con.PO_Remarks_16__c = null;
                    else if( i==5 )    con.PO_Remarks_15__c = null;
                    else if( i==6 )    con.PO_Remarks_14__c = null;
                    else if( i==7 )    con.PO_Remarks_13__c = null;
                    else if( i==8 )    con.PO_Remarks_12__c = null;
                    else if( i==9 )    con.PO_Remarks_11__c = null;
                    else if( i==10 )    con.PO_Remarks_10__c = null;
                    else if( i==11 )    con.PO_Remarks_9__c = null;
                    else if( i==12 )    con.PO_Remarks_8__c = null;
                    
                    break;
                }
            }// end for
        }// end if
    
    }

}