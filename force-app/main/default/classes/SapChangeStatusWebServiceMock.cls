@isTest
global class  SapChangeStatusWebServiceMock implements WebServiceMock {
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
            
            SapNewEccStatusChange.StatusChangeReturn_element s_SCR = new SapNewEccStatusChange.StatusChangeReturn_element();
            s_SCR.BISMT='JKM260P-60';
            //s_SCR.BISMT_type_info= new string[]{'BISMT', 'urn:jinkosolar.com:ecc:status_change', null, '0', '1', 'false'};
            s_SCR.BLNO='EGLV1425501';
            //s_SCR.BLNO_type_info=new string[]{'BLNO', 'urn:jinkosolar.com:ecc:status_change', null, '0', '1', 'false'};
            s_SCR.LGORT='F016';
           // s_SCR.LGORT_type_info=new string[]{'LGORT', 'urn:jinkosolar.com:ecc:status_change', null, '0', '1', 'false'}; 
            s_SCR.MATNR='24000014';
            //s_SCR.MATNR_type_info=new string[]{'MATNR','urn:jinkosolar.com:ecc:status_change' , null,'0', '1', 'false'}; 
            s_SCR.MSG='该数据不存在，请检查';
            //s_SCR.MSG_type_info=new string[]{'MSG', 'urn:jinkosolar.com:ecc:status_change', null, '0', '1', 'false'}; 
            s_SCR.POSNR_VL=null;
            //s_SCR.POSNR_VL_type_info=new string[]{'POSNR_VL', 'urn:jinkosolar.com:ecc:status_change', null, '0', '1', 'false'};
            s_SCR.STATUS_OLD='UNBOOK';
            //s_SCR.STATUS_OLD_type_info=new string[]{'STATUS_OLD', 'urn:jinkosolar.com:ecc:status_change', null, '0', '1', 'false'};
            s_SCR.TYPE_x='E';
            //s_SCR.TYPE_x_type_info=new string[]{'TYPE', 'urn:jinkosolar.com:ecc:status_change', null, '0', '1', 'false'};
            s_SCR.VBELN=null;
            s_SCR.VBELN_VL=null;
           // s_SCR.VBELN_VL_type_info=new string[]{'VBELN_VL', 'urn:jinkosolar.com:ecc:status_change', null, '0', '1', 'false'}; 
            //    s_SCR.VBELN_type_info=new string[]{'VBELN', 'urn:jinkosolar.com:ecc:status_change', null, '0', '1', false};
            s_SCR.WERKS='1250';
           // s_SCR.WERKS_type_info=new string[]{'WERKS', 'urn:jinkosolar.com:ecc:status_change', null, '0', '1', false};
            s_SCR.ZCRMNO='a0C0l000001hu11EAA'; 
           // s_SCR.ZCRMNO_type_info=new string[]{'ZCRMNO', 'urn:jinkosolar.com:ecc:status_change', null, '0', '1', 'false'}; 
            //    s_SCR.apex_schema_type_info=new string[]{'urn:jinkosolar.com:ecc:status_change', 'false', 'false'};
           //         s_SCR.field_order_type_info=new string[]{'WERKS', 'LGORT', 'STATUS_OLD', 'BLNO', 'MATNR', 'BISMT', 'VBELN', 'ZCRMNO', 'VBELN_VL', 'POSNR_VL','TYPE_x','MSG'};
           
            list<SapNewEccStatusChange.StatusChangeReturn_element> s_SCRLst = new list<SapNewEccStatusChange.StatusChangeReturn_element>();
            s_SCRLst.add(s_SCR);
            
            
            SapNewEccStatusChange.DT_StatusChangeReturn response_x = new SapNewEccStatusChange.DT_StatusChangeReturn();
            
            Map<String, SapNewEccStatusChange.DT_StatusChangeReturn> response_map_x = new Map<String, SapNewEccStatusChange.DT_StatusChangeReturn>();
           
            response_map_x.put('response_x', response_x);
            response_x.StatusChangeReturn = s_SCRLst;
          
        }
}