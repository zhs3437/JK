global without sharing  class CRMSendCpmd {
    webService static List<Product2> clickUpdate( ){
jinkosolarComEwmCrmSendCpmd sp =new jinkosolarComEwmCrmSendCpmd();
List<jinkosolarComEwmCrmSendCpmd.T_DATA_element> splst =new List<jinkosolarComEwmCrmSendCpmd.T_DATA_element>();

    
        List<Product2> prolist=[select id,name,tosap__c from product2  where isactive=:true and tosap__c=:false];
        if(prolist.size()>0){
        for(Product2 pro:prolist){
             jinkosolarComEwmCrmSendCpmd.T_DATA_element st =new jinkosolarComEwmCrmSendCpmd.T_DATA_element();
            st.ZCPMD=PRO.NAME;
            pro.tosap__c=true;
         if(pro.name.Startswith('JK03M')||pro.name.Startswith('JK06M')||pro.name.Startswith('MC4')||pro.name.Startswith('JKT')){
                    st.ZCPXL ='Connector';
                    st.ZCPDL = 'Connector';
                } 
                   //N Type
                else if(((pro.name.contains('BDV') && !pro.name.contains('BDVP'))||pro.name.contains('N-'))&& pro.name.contains('HLM')){
                    st.ZCPDL = 'Tiger';
                    if(pro.name.contains('6T')){
                        st.ZCPXL ='N-Tiger-60M';
                    }else if(pro.name.contains('6R')||pro.name.contains('66')){
                        st.ZCPXL ='N-Tiger-66M';
                    }
                }
                //P Type
                else if(pro.name.contains('HLM')){
                    st.ZCPDL = 'Tiger';
                    if(pro.name.contains('6T')||pro.name.contains('60H')){
                        st.ZCPXL ='P-Tiger-60MH';
                    }
                    else if(pro.name.contains('7T')||pro.name.contains('72')){
                        if(pro.name.contains('BD')){
                          st.ZCPXL ='P-Tiger-72BD';
                        }else if(pro.name.contains('TV')){
                          st.ZCPXL ='P-Tiger-72BT';
                        }else{
                          st.ZCPXL ='P-Tiger-72MH';
                        }
                    }
                }
                //P Type Pro
                else if(pro.name.contains('L4')){
                    st.ZCPDL = 'Tiger Pro';
                    if(pro.name.contains('6T')||pro.name.contains('60H')){
                        st.ZCPXL ='P-Tiger Pro-60MH';
                    }
                    else if(pro.name.contains('7T')||pro.name.contains('72H')){
                        if(pro.name.contains('BDVP')){
                          st.ZCPXL ='P-Tiger Pro-72BD';
                        }else if(pro.name.contains('TV')){
                          st.ZCPXL ='P-Tiger Pro-72BT';
                        }else{
                          st.ZCPXL ='P-Tiger Pro-72MH';
                        }
                    }
                    else if(pro.name.contains('7R')||pro.name.contains('78')){
                          st.ZCPXL ='P-Tiger Pro-78BT';
                    }
                }
                
                //Smart
                else if(pro.name.Startswith('JKMS')||pro.name.Startswith('SMM')){
                    st.ZCPDL = 'Smart';
                    if(pro.name.contains('TI')){
                        st.ZCPXL ='Smart-TI';
                    }else if(pro.name.contains('TG')){
                        st.ZCPXL ='Smart-TG';
                    }else if(pro.name.contains('MX')){
                        st.ZCPXL ='Smart-MX';
                    }else{
                        st.ZCPXL ='Smart';
                    }
                }
                
                //Tiger Pro
                else if(pro.name.Startswith('JKM')&& !pro.name.contains('JKMS')&&pro.name.contains('L4')){
                    st.ZCPDL = 'Tiger Pro';
                    if(pro.name.contains('N')){
                        if(pro.name.contains('BD')){
                            st.ZCPXL ='Tiger Pro-N-DG';
                        }else if(pro.name.contains('-D')){
                            st.ZCPXL ='Tiger Pro-N-SG';
                        }else if(pro.name.contains('-T')){
                            st.ZCPXL ='Tiger Pro-N-TB';
                        }else{
                            st.ZCPXL ='Tiger Pro-N';
                        }
                    }else if(!pro.name.contains('N')){
                        if(pro.name.contains('BD')){
                            st.ZCPXL ='Tiger Pro-P-DG';
                        }else if(pro.name.contains('-D')){
                            st.ZCPXL ='Tiger Pro-P-SG';
                        }else if(pro.name.contains('-T')){
                            st.ZCPXL ='Tiger Pro-P-TB';
                        }else{
                            st.ZCPXL ='Tiger Pro-P';
                        }
                    }
                }
                else if(pro.name.Startswith('MM')&&pro.name.contains('LD')){
                    st.ZCPDL = 'Tiger Pro';
                    if(pro.name.contains('N')){
                        if(pro.name.contains('BG')){
                            st.ZCPXL ='Tiger Pro-N-DG';
                        }else if(pro.name.contains('MG')){
                            st.ZCPXL ='Tiger Pro-N-SG';
                        }else if(pro.name.contains('BB')){
                            st.ZCPXL ='Tiger Pro-N-TB';
                        }else{
                            st.ZCPXL ='Tiger Pro-N';
                        }
                    }else if(!pro.name.contains('N')){
                        if(pro.name.contains('BG')){
                            st.ZCPXL ='Tiger Pro-P-DG';
                        }else if(pro.name.contains('MG')){
                            st.ZCPXL ='Tiger Pro-P-SG';
                        }else if(pro.name.contains('BB')){
                            st.ZCPXL ='Tiger Pro-P-TB';
                        }else{
                            st.ZCPXL ='Tiger Pro-P';
                        }
                    }
                }

                //Tiger
                else if(pro.name.Startswith('JKM')&& !pro.name.contains('JKMS')&&pro.name.contains('L3')){
                    st.ZCPDL = 'Tiger';
                    if(pro.name.contains('N')){
                        if(pro.name.contains('BD')){
                            st.ZCPXL ='Tiger-N-DG';
                        }else if(pro.name.contains('-D')){
                            st.ZCPXL ='Tiger-N-SG';
                        }else if(pro.name.contains('-T')){
                            st.ZCPXL ='Tiger-N-TB';
                        }else{
                            st.ZCPXL ='Tiger-N';
                        }
                    }else if(!pro.name.contains('N')){
                        if(pro.name.contains('BD')){
                            st.ZCPXL ='Tiger-P-DG';
                        }else if(pro.name.contains('-D')){
                            st.ZCPXL ='Tiger-P-SG';
                        }else if(pro.name.contains('-T')){
                            st.ZCPXL ='Tiger-P-TB';
                        }else{
                            st.ZCPXL ='Tiger-P';
                        }
                    }
                }
                else if(pro.name.Startswith('MM')&&pro.name.contains('LC')){
                    st.ZCPDL = 'Tiger';
                    if(pro.name.contains('N')){
                        if(pro.name.contains('BG')){
                            st.ZCPXL ='Tiger-N-DG';
                        }else if(pro.name.contains('MG')){
                            st.ZCPXL ='Tiger-N-SG';
                        }else if(pro.name.contains('BB')){
                            st.ZCPXL ='Tiger-N-TB';
                        }else{
                            st.ZCPXL ='Tiger-N';
                        }
                    }else if(!pro.name.contains('N')){
                        if(pro.name.contains('BG')){
                            st.ZCPXL ='Tiger-P-DG';
                        }else if(pro.name.contains('MG')){
                            st.ZCPXL ='Tiger-P-SG';
                        }else if(pro.name.contains('BB')){
                            st.ZCPXL ='Tiger-P-TB';
                        }else{
                            st.ZCPXL ='Tiger-P';
                        }
                    }
                }
                else if(pro.name.contains('JKSM3')){
                    st.ZCPDL = 'Tiger';
                    system.debug('是老虎型');
                    st.ZCPXL ='Tiger-P';
                }
                else if(pro.name.contains('JKSN3')){
                    st.ZCPDL = 'Tiger';
                    system.debug('是老虎型');
                    st.ZCPXL ='Tiger-N';
                }  
                
                /*plus*/
                else if(pro.name.startsWith('JKM') && !pro.name.contains('JKMS')&&(pro.name.contains('66')||pro.name.contains('78'))){
                    system.debug('pro.name'+pro.name);
                    system.debug('pro.name'+pro.name);
                    st.ZCPDL = 'Cheetah(Swan)';
                    if(pro.name.contains('N')){
                        system.debug('pro.name'+pro.name);
                        if(pro.name.contains('BD')){
                            st.ZCPXL ='Swan Plus-N-DG';
                        }else if(pro.name.contains('-D')){
                            st.ZCPXL ='Swan Plus-N-SG';
                        }else if(pro.name.contains('-T')){
                            st.ZCPXL ='Swan Plus-N-TB';
                        }else{
                            st.ZCPXL ='Cheetah Plus-N';
                        }
                    }else if(!pro.name.contains('N')){
                        if(pro.name.contains('BD')){
                            st.ZCPXL ='Swan Plus-P-DG';
                        }else if(pro.name.contains('-D')){
                            st.ZCPXL ='Swan Plus-P-SG';
                        }else if(pro.name.contains('-T')){
                            st.ZCPXL ='Swan Plus-P-TB';
                        }else{
                            st.ZCPXL ='Cheetah Plus-P';
                        }
                    }
                }
                else if(pro.name.startsWith('MM') &&(pro.name.contains('66')||pro.name.contains('78'))){
                    system.debug('pro.name'+pro.name);
                    system.debug('pro.name'+pro.name);
                    st.ZCPDL = 'Cheetah(Swan)';
                    if(pro.name.contains('N')){
                        system.debug('pro.name'+pro.name);
                        if(pro.name.contains('BG')){
                            st.ZCPXL ='Swan Plus-N-DG';
                        }else if(pro.name.contains('BB')){
                            st.ZCPXL ='Swan Plus-N-TB';
                        }else if(pro.name.contains('MG')){
                            st.ZCPXL ='Swan Plus-N-SG';
                        }else{
                            st.ZCPXL ='Cheetah Plus-N';
                        }
                    }else if(!pro.name.contains('N')){
                        if(pro.name.contains('BG')){
                            st.ZCPXL ='Swan Plus-P-DG';
                        }else if(pro.name.contains('BB')){
                            st.ZCPXL ='Swan Plus-P-TB';
                        }else if(pro.name.contains('MG')){
                            st.ZCPXL ='Swan Plus-P-SG';
                        }else{
                            st.ZCPXL ='Cheetah Plus-P';
                        }
                    }
                }
                
                /*Swan*/
                else if(pro.name.contains('JKM')&& (pro.name.contains('BDVP')||pro.name.contains('BD')||pro.name.contains('-T')||pro.name.contains('-D'))){
                    system.debug('pro.name'+pro.name);
                    st.ZCPDL = 'Cheetah(Swan)';
                    if(pro.name.contains('N')){
                        if(pro.name.contains('BD')){
                            st.ZCPXL ='Swan-N-DG';
                        }else if(pro.name.contains('-D')){
                            st.ZCPXL ='Swan-N-SG';
                        }else if(pro.name.contains('-T')){
                            st.ZCPXL ='Swan-N-TB';
                        }
                    }else if(!pro.name.contains('N')){
                        if(pro.name.contains('BDVP')){
                            st.ZCPXL ='Swan-P-DG';
                        }else if(pro.name.contains('BD')){
                            system.debug('junjun');
                            st.ZCPXL ='Swan-N-DG';
                        }else if(pro.name.contains('-D')){
                            st.ZCPXL ='Swan-P-SG';
                        }else if(pro.name.contains('-T')){
                            st.ZCPXL ='Swan-P-TB';
                        }
                    }
                }
                else if(pro.name.contains('MM')&& (pro.name.contains('BG')||pro.name.contains('BB')||pro.name.contains('MG'))){
                    system.debug('pro.name'+pro.name);
                    st.ZCPDL = 'Cheetah(Swan)';
                    if(pro.name.contains('N')){
                        if(pro.name.contains('BG')){
                            st.ZCPXL ='Swan-N-DG';
                        }else if(pro.name.contains('BB')){
                            st.ZCPXL ='Swan-N-TB';
                        }else if(pro.name.contains('MG')){
                            st.ZCPXL ='Swan-N-SG';
                        }
                    }else if(!pro.name.contains('N')){
                        if(pro.name.contains('BG')){
                            st.ZCPXL ='Swan-P-DG';
                        }else if(pro.name.contains('BB')){
                            system.debug('junjun');
                            st.ZCPXL ='Swan-P-TB';
                        }else if(pro.name.contains('MG')){
                            st.ZCPXL ='Swan-P-SG';
                        }
                    }
                }
                
                /*Eagle*/
                else if((pro.name.contains('JKM')||pro.name.Startswith('MM'))&& pro.name.contains('P-')){
                    st.ZCPDL = 'Cheetah(Swan)';
                    if(pro.name.contains('H')){
                        system.debug('111111');
                        st.ZCPXL ='Eagle Poly-HC';
                    }else if(!pro.name.contains('H')){
                        system.debug('22222');
                        st.ZCPXL ='Eagle Poly-FC';
                    }
                }
                
                /*Cheetah*/
                else if(pro.name.contains('JKM') && !pro.name.contains('JKMS')){
                    st.ZCPDL = 'Cheetah(Swan)';
                    integer MW =Integer.valueOf(pro.name.substring(3, 6));
                    if(pro.name.contains('H')){
                        if(pro.name.contains('N')){
                            if(pro.name.contains('-60')){
                                if(MW>=325){
                                    st.ZCPXL ='Cheetah-N-HC';
                                }else{
                                    st.ZCPXL ='Eagle Perc-HC';
                                }
                            }
                            if(pro.name.contains('-72')){
                                if(MW>=395){
                                    st.ZCPXL ='Cheetah-N-HC';
                                }else{
                                    st.ZCPXL ='Eagle Perc-HC';
                                }
                            }  
                        }else if(!pro.name.contains('N')){
                            if(pro.name.contains('-60')){
                                if(MW>=325){
                                    st.ZCPXL ='Cheetah-P-HC';
                                }else{
                                    st.ZCPXL ='Eagle Perc-HC';
                                }
                            }
                            if(pro.name.contains('-72')){
                                if(MW>=395){
                                    st.ZCPXL ='Cheetah-P-HC';
                                }else{
                                    st.ZCPXL ='Eagle Perc-HC';  
                                }
                            } 
                        }
                        
                    }else if(!pro.name.contains('H')){
                        if(pro.name.contains('N')){
                            if(pro.name.contains('-60')){
                                if(MW>=320){
                                    st.ZCPXL ='Cheetah-N-FC';
                                }else{
                                    st.ZCPXL ='Eagle Perc-FC';
                                }
                            }
                            if(pro.name.contains('-72')){
                                if(MW>=390){
                                    st.ZCPXL ='Cheetah-N-FC';
                                }else{
                                    st.ZCPXL ='Eagle Perc-FC';
                                }
                            }  
                        }else if(!pro.name.contains('N')){
                            system.debug('junjunV3');
                            if(pro.name.contains('-60')){
                                if(MW>=320){
                                    st.ZCPXL ='Cheetah-P-FC';
                                }else{
                                    st.ZCPXL ='Eagle Perc-FC';
                                }
                            }
                            if(pro.name.contains('-72')){
                                system.debug('junjunV4');
                                if(MW>=390){
                                    system.debug('junjunV5');
                                    st.ZCPXL ='Cheetah-P-FC';
                                }else{
                                    system.debug('junjunV2');
                                    st.ZCPXL ='Eagle Perc-FC';  
                                }
                            } 
                        }
                    }
                    
                }
                else if(pro.name.Startswith('MM')){
                    st.ZCPDL = 'Cheetah(Swan)';
                    integer MW =Integer.valueOf(pro.name.substring(2, 5));
                    if(pro.name.contains('H')){
                        if(pro.name.contains('N')){
                            if(pro.name.contains('-60')){
                                if(MW>=325){
                                    st.ZCPXL ='Cheetah-N-HC';
                                }else{
                                    st.ZCPXL ='Eagle Perc-HC';
                                }
                            }
                            if(pro.name.contains('-72')){
                                if(MW>=395){
                                    st.ZCPXL ='Cheetah-N-HC';
                                }else{
                                    st.ZCPXL ='Eagle Perc-HC';
                                }
                            }  
                        }else if(!pro.name.contains('N')){
                            if(pro.name.contains('-60')){
                                if(MW>=325){
                                    st.ZCPXL ='Cheetah-P-HC';
                                }else{
                                    st.ZCPXL ='Eagle Perc-HC';
                                }
                            }
                            if(pro.name.contains('-72')){
                                if(MW>=395){
                                    st.ZCPXL ='Cheetah-P-HC';
                                }else{
                                    st.ZCPXL ='Eagle Perc-HC';  
                                }
                            } 
                        }
                        
                    }else if(!pro.name.contains('H')){
                        if(pro.name.contains('N')){
                            if(pro.name.contains('-60')){
                                if(MW>=320){
                                    st.ZCPXL ='Cheetah-N-FC';
                                }else{
                                    st.ZCPXL ='Eagle Perc-FC';
                                }
                            }
                            if(pro.name.contains('-72')){
                                if(MW>=390){
                                    st.ZCPXL ='Cheetah-N-FC';
                                }else{
                                    st.ZCPXL ='Eagle Perc-FC';
                                }
                            }  
                        }else if(!pro.name.contains('N')){
                            system.debug('junjunV3');
                            if(pro.name.contains('-60')){
                                if(MW>=320){
                                    st.ZCPXL ='Cheetah-P-FC';
                                }else{
                                    st.ZCPXL ='Eagle Perc-FC';
                                }
                            }
                            if(pro.name.contains('-72')){
                                system.debug('junjunV4');
                                if(MW>=390){
                                    system.debug('junjunV5');
                                    st.ZCPXL ='Cheetah-P-FC';
                                }else{
                                    system.debug('junjunV2');
                                    st.ZCPXL ='Eagle Perc-FC';  
                                }
                            }
                        }
                    }
                }
                splst.add(st);
        }
        }
        

          jinkosolarComCrmCrmSendCpmd.HTTPS_Port send =new jinkosolarComCrmCrmSendCpmd.HTTPS_Port();
          jinkosolarComEwmCrmSendCpmd.DT_SendCPMD_Response response=send.SI_CRM2EWM_SendCPMD_Out(splst);
        return prolist;
        }
}