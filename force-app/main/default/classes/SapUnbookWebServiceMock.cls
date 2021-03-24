@isTest
global class SapUnbookWebServiceMock implements WebServiceMock{
    
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            sapEccUnbook.UnbookReturn_element s_ur = new sapEccUnbook.UnbookReturn_element();
            s_ur.BISMT='JKM260P-60';
            //s_SCR.BISMT_type_info= new string[]{'BISMT', 'urn:jinkosolar.com:ecc:status_change', null, '0', '1', 'false'};
            s_ur.BLNO='EGLV1425501';
            //s_SCR.BLNO_type_info=new string[]{'BLNO', 'urn:jinkosolar.com:ecc:status_change', null, '0', '1', 'false'};
            s_ur.LGORT='F016';
            // s_SCR.LGORT_type_info=new string[]{'LGORT', 'urn:jinkosolar.com:ecc:status_change', null, '0', '1', 'false'}; 
            s_ur.MATNR='24000014';
            s_ur.CHARG='';
            s_ur.QYP_PC='';
            s_ur.ETD='';
            s_ur.ETA='';
            s_ur.UDATE='';
            s_ur.INVBELN='';
            s_ur.ZTYPE='';
            s_ur.MAKTX='';
            s_ur.POWER='';
            s_ur.LGOBE='';
            s_ur.STATUS='UNBOOK';
            s_ur.WERKS='1250';
            
            list<sapEccUnbook.UnbookReturn_element> s_DTbrLst = new list<sapEccUnbook.UnbookReturn_element>();
            s_DTbrLst.add(s_ur);

            sapEccUnbook.DT_UnbookReturn response_x = new sapEccUnbook.DT_UnbookReturn();
            
            Map<String, sapEccUnbook.DT_UnbookReturn> response_map_x = new Map<String, sapEccUnbook.DT_UnbookReturn>();
            response_map_x.put('response_x', response_x);
            response_map_x.get('response_x').UnbookReturn = s_DTbrLst;
            
            
        }
    
}