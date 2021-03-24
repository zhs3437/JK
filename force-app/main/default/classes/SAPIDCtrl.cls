public class SAPIDCtrl{
    public void createObj(){
          Log__c log = new Log__c(
            Type__c='Account',
            StartTime__c = System.now()
        );
        try{
           
            //http://dev1mw-jk.cs31.force.com/?sapid=123456&sfid=001p000000J4JCZ
            string sapidCode = ApexPages.currentPage().getParameters().get('sapid');   //SAP ID号         
            string sfid = ApexPages.currentPage().getParameters().get('sfid');      //OA 单据号
            string sapdeCode = ApexPages.currentPage().getParameters().get('sapde'); // SAP描述
            string sapde =system.Encodingutil.urlDecode(sapdeCode, 'UTF-8');         
            string sapid = system.Encodingutil.urlDecode(sapidCode, 'UTF-8');
            //string sapde = Utils.getPageParam(sapdeCode);
			//string sapid = Utils.getPageParam(sapidCode);          
            system.debug('sapid--->'+sapid);
            system.debug('sapde--->'+sapde);

            if(!string.isEmpty(sfid)){   				
                SAPID__c obj = new SAPID__c();
                 obj.Name = sfid;						//OA 单据号
                if(!string.isEmpty(sapid)){				//SAP Id;
                	obj.SFID__c = sapid;
                }else{
					obj.SFID__c = '';                    
                }
                if(!string.isEmpty(sapde)){				//SAP 描述
                    obj.sapde__c = sapde;
                }else{
                    obj.sapde__c = '';
                }                
                insert obj;
                log.SuccessIDs__c        = obj.Id;
            }
           
            SAPIDCtrl.postToSandbox(
                'https://cs111.salesforce.com/services/data/v49.0/sobjects/SAPID__c/',
                JSON.serialize(new Map<String, Object>{
                    'Name' => sfid,
                    'SFID__c' => sapid,
                    'sapde__c' => sapde
                })
            );

            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Successful'));
        }
        catch(Exception ex){
              log.Error_Message__c     = ex.getMessage();
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,ex.getMessage()));
        }
        if(log !=null){
            log.EndTime__c           = System.now();
           insert log; 
        }
        
    }

    @future(callout=true)
    public static void postToSandbox (String url, String body) {
        Map<String, Object> params = SAPIDCtrl.getSandbox();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setHeader('Authorization', (String)params.get('token_type') + ' ' + (String)params.get('access_token'));
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setMethod('POST');
        request.setBody(body);
        Http http = new Http();
        HttpResponse response = http.send(request);
    }

    public static Map<String, Object> getSandbox () {
        String domain = 'https://test.salesforce.com/services/oauth2/token';
        String client_id = '3MVG9aWdXtdHRrI0L2RAlxEF0skcbr74XfFd_GqmVoKyS0ZQxcGrqWYGL5Gqybkmk5nd3Hb2uDk0AUTdE9MXe';
        String client_secret = '91C85459AEF55BC660FC4D9557093708AF09006FC58EA7B489014EB4A0424D9A';
        String username = 'neo.yang@jinkosolar.com.dev';
        String password = 'neo=1116';
        String grant_type = 'password';
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(domain + 
            '?client_id=' + client_id + 
            '&client_secret=' + client_secret +
            '&username=' + username +
            '&password=' + password + 
            '&grant_type=' + grant_type);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        return (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
    }
}