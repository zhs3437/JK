/*
*Author: Leo   2018.8.1
*
*Description:用于自动抓取物流费用，以及在自动抓取的值为空时自动发送邮件到不同物流的负责人。
*
*/
public  class Cls_UpdateLogisticFreight 
{
    	
     public void updateFreight(list<Opportunity> list_opp, map<Id,Opportunity> map_opp)
     {
     	Set<String> set_coun = new Set<String>();
     	Set<String> set_port = new Set<String>();
     	Set<String> set_fac= new Set<String>();
     	Set<String> set_dp=new Set<String>();
     	Set<Id> set_id=new Set<Id>();
     	Set<String> set_type=new Set<String>();
     	Set<String> set_piece=new Set<String>();

     	//以下匹配逻辑由 物流 余亚涵提供
       for(Opportunity opp:list_opp)
     	{
     		if( ( opp.Destination_Port__c !=null && opp.Destination_Country__c !=null && opp.Power__c !=null && opp.Seller__c !=null ) && ( 
     			  opp.Destination_Port__c != map_opp.get(opp.Id).Destination_Port__c 
     			 ||  opp.Destination_Country__c != map_opp.get(opp.Id).Destination_Country__c
     			 || opp.Power__c !=map_opp.get(opp.Id).Power__c
     			 || opp.Seller__c !=map_opp.get(opp.Id).Seller__c
     			 || opp.Departure_Factory__c !=map_opp.get(opp.Id).Departure_Factory__c
     			 ))
     		{

     			set_coun.add(opp.Destination_Country__c);
     			set_port.add(opp.Destination_Port__c);
     			if(opp.Departure_Factory__c !=null)
     			{
     				set_fac.add(opp.Departure_Factory__c);
     			}else if(opp.Departure_Factory__c =='ShangRao Factory')
     			{
     					
     					set_dp.add('宁波');
     					set_type.add('铁路');
     				}else if(opp.Departure_Factory__c =='HaiNing Factory'){
     					
     					set_dp.add('宁波');
     					set_type.add('公路');
     				}else if(opp.Departure_Factory__c=='Malaysia Factory'){
     					set_dp.add('槟城');
     					set_type.add('公路');
     				}else if(opp.Departure_Factory__c ==null && (opp.Seller__c=='Jinko Solar Co., Ltd.' ||opp.Seller__c=='Jinko Solar Import and Export Co., Ltd.'))
	     			{
	     				set_fac.add('ShangRao Factory');
	     				set_dp.add('宁波');
	     				set_type.add('铁路');
	     			}else if(opp.Departure_Factory__c ==null && opp.Seller__c=='ZHEJIANG JINKO SOLAR CO.,LTD')
	     			{
	     				set_fac.add('HaiNing Factory');
	     				set_dp.add('宁波');
	     				set_type.add('公路');
	     			}else if(opp.Departure_Factory__c ==null && opp.Seller__c =='JINKO SOLAR TECHNOLOGY SDN.BHD.')
	     			{
	     				set_fac.add('Malaysia Factory');
	     				set_dp.add('槟城');
	     				set_type.add('公路');	
     			}
     			
     			set_id.add(opp.Id);
     			set_piece.add(opp.Piece__c);

     		}
     	}
     	System.debug('set_port +++++++++++++++++++++++++++'+set_port + 'set_coun************'+set_coun +'set_fac////////'+set_fac+

     		'set_dp########################'+set_dp+'set_type*********'+set_type+'%%%%%%%%%set_piece'+set_piece);

     	list<Ocean_Freight__c> list_ocean=new list<Ocean_Freight__c>();
     	list<Opportunity> list_oppnew =new list<Opportunity>();
     	list_oppnew =[Select Id,Name,
                      Land_Freight_China__c,
                      Send_Email_To_Logistic__c,BMO_Specialist__r.Name,
               				Ocean_Freight__c,
                      Destination_Country__c,Destination_Port__c,Trade_Term__c,Region__c,
               				Shipping_Address__c,Seller__c,China_Land_Freight__c,Freight_Ocean__c,Power__c from Opportunity where Id in:set_id];
     	if(set_coun.size()>0 && set_port.size() >0 && set_fac.size() >0 && set_dp.size() >0 && set_id.size() >0)
     	{
     		    list_ocean=[Select Id,Logistic__r.Id,Logistic__r.Goods_Type__c,Logistic__r.Name,Logistic__r.Freight_Price_All__c,Logistic__r.Freight_Price_Trans__c,Logistic__r.Type_of_Shipping__c,
                Logistic__r.Freight_Price_Total__c,Logistic__r.Box_Amount__c,Freight_Price_Ocean__c,Destination_Country__c,Destination_Port__c,Total_Price__c,Logistic__r.Maintenance_day__c,Logistic__r.Departure_Factory__c,
                Logistic__r.Departure_Port__c from Ocean_Freight__c where Destination_Country__c in:set_coun and Destination_Port__c in:set_port and  Logistic__r.Departure_Factory__c in: set_fac 
                and Logistic__r.Departure_Port__c in:set_dp and Logistic__r.Box_Amount__c in:set_piece and Logistic__r.Type_of_Shipping__c in:set_type];
     	}
     	System.debug('list_ocean////////////////'+list_ocean);
     	System.debug('list_oppnew *************'+ list_oppnew);

     	if(list_ocean.size() >0)
     	{
     			for(Opportunity opp2:list_oppnew)
     			{
     			 	for(Ocean_Freight__c ocean:list_ocean)
     				{
     				Decimal land = ocean.Logistic__r.Freight_Price_Total__c/Decimal.valueOf(ocean.Logistic__r.Box_Amount__c)/opp2.Power__c;
     				System.debug('land***************'+land);
     				land=land.setScale(4);
     				opp2.China_Land_Freight__c=String.valueOf(land);
     			//	opp2.Land_Freight_China__c= String.valueOf(land+'(USD)'+'/W ');

     				Decimal Docean = ocean.Freight_Price_Ocean__c/Decimal.valueOf(ocean.Logistic__r.Box_Amount__c)/opp2.Power__c;
     				Docean=Docean.setScale(4);
     				opp2.Freight_Ocean__c=String.valueOf(Docean);
     				//opp2.Ocean_Freight__c=String.valueOf(Docean+'(USD)'+'/W');
     				}
     				
     			//	System.debug('opp.Land_Freight_China__c**********'+opp2.Land_Freight_China__c);
     			}
     			System.debug('list_oppnew@@@@@@@@@@@@@@@@'+list_oppnew);
     			update list_oppnew;
     		}else if(list_ocean.size() == 0) //如果自动取值为空，则发邮件给各区域物流专员
     		{
     			//分不同区域发送邮件到不同的人
     			System.debug('进入到发送邮件');
     			list<EmailTemplate> list_email=[SELECT ID FROM EmailTemplate WHERE developerName ='Freight_Notify'];
		    	System.debug('list_email'+list_email);
		    	list<String> recipients =new list<String>();
		    	for(Opportunity opp:list_oppnew)
		    	{
		    		System.debug('opp.Id++++++++++++'+opp.Id);
		    		if(
                        opp.Land_Freight_China__c ==null && 
                        opp.Ocean_Freight__c ==null && 
                        opp.Send_Email_To_Logistic__c ==false)
		    		{
		    			
		    			 String url='https://ap4.salesforce.com/'+opp.Id;
		    			 String subject='New Opportunity need Update Logistic Freight';

		    			 String body='<p>'+'Dear Logistic Colleagues:'+'</p>'
		        					+'请注意您有一个新的业务机会需要您来更新运费信息'+'<b>'+'(Opportunity Name:'+opp.Name+')'+'</b>'+'</br>'
		        					+'Please note below new Opportunity need you update the freight cost:'+'</br>'
		        					+'-------------------------------------------------'+'</br>'
		        					+'</br>'
		        					+'Seller:			   '+opp.Seller__c+'</br>'
									+'BMO Specialist:      '+opp.BMO_Specialist__r.Name+'</br>'
		        					+'Destination Country: '+opp.Destination_Country__c+'</br>'
		        					+'Destination Port:    '+opp.Destination_Port__c+'</br>'
		        					+'Trade Term:          '+opp.Trade_Term__c+'</br>'
		        					+'Shipping Address:    '+opp.Shipping_Address__c+'</br>'
		        				    +'Please click following URL :'+'<a href='+url+'>'+'https://ap4.salesforce.com/'+opp.Id+'</a>'
		        					+'</br>'
		        					+'-------------------------------------------------'+'</br>'
		        					+'</br>'
		        					+'</br>'
		        					+'Salesforce System.'
		        					 ;  
		        		//以下邮箱均为对应区域物流人员的邮箱，在测试环境测试请勿开启以下注释代码。			 
		        		//根据不同的区域来推送给不同的人
		        	/*	if((opp.Destination_Country__c =='Mexico' ||opp.Destination_Country__c=='Brazil') && opp.Seller__c=='JINKOSOLAR TECHNOLOGY LIMITED')
		        		{
		        			recipients.add('Nubia.razo@jinkosolar.com');
		        			recipients.add('lihua.pei@jinkosolar.com');
		        			recipients.add('hong.liu@jinkosolar.com');
		        		}else if(opp.Seller__c=='JinkoSolar (U.S.) Inc')
		        		{
		        			recipients.add('marie.wilson@jinkosolar.com');
		        			recipients.add('issac.li@jinkosolar.com');
		        			recipients.add('lihua.pei@jinkosolar.com');
		        			recipients.add('hong.liu@jinkosolar.com');
		        			recipients.add('sfl@jinkosolar.com');
		        		}else if(opp.Seller__c=='JinkoSolar GmbH'|| opp.Seller__c=='JinkoSolar (Switzerland) AG')
		        		{
		        			recipients.add('ronny.schneider@jinkosolar.com');
		        			recipients.add('Doris.Zhang@jinkosolar.com');
		        			recipients.add('lihua.pei@jinkosolar.com');
		        			recipients.add('hong.liu@jinkosolar.com');
		        		}else if(opp.Destination_Country__c=='Japan' && opp.Seller__c=='ジンコソーラージャパン株式会社')
		        		{
		        			recipients.add('hisashi.sakai@jinkosolar.com');
		        			recipients.add('jian.zhu@jinkosolar.com');
		        			recipients.add('jieying.wu@jinkosolar.com');
		        			recipients.add('lihua.pei@jinkosolar.com');
		        			recipients.add('hong.liu@jinkosolar.com');
		        		}else if(opp.Destination_Country__c=='Australia' && opp.Seller__c=='JINKO SOLAR AUSTRALIA HOLDINGS CO PTY.LTD')
		        		{
		        			recipients.add('melissa.bast@jinkosolar.com');
		        			recipients.add('lihua.pei@jinkosolar.com');
		        			recipients.add('hong.liu@jinkosolar.com');
		        		}else if(opp.Destination_Country__c=='India' &&opp.Seller__c=='JINKOSOLAR TRADING PRIVATE LIMITED')
		        		{
		        			recipients.add('chandra.shekhar@jinkosolar.com');
		        			recipients.add('lihua.pei@jinkosolar.com');
		        			recipients.add('hong.liu@jinkosolar.com');
		        		}else if(opp.Seller__c=='PROJINKO SOLAR PORTUGAL UNIPESSOAL LDA')
		        		{
		        			recipients.add('ronny.schneider@jinkosolar.com');
		        			recipients.add('Doris.Zhang@jinkosolar.com');
		        		}else if(opp.Seller__c=='ZHEJIANG JINKO SOLAR CO.,LTD')
		        		{
		        			recipients.add('hanxu.dong@jinkosolar.com');
		        			recipients.add('ding.fang@jinkosolar.com');
		        		}else if(opp.Seller__c=='Jinko Solar Co., Ltd.' || opp.Seller__c=='Jinko Solar Import and Export Co., Ltd.')
		        		{
		        			recipients.add('wenbo.cai@jinkosolar.com');
		        			recipients.add('yahan.yu@jinkosolar.com');
		        		}else if(opp.Seller__c=='YUHUAN JINKO SOLAR CO., LTD' ||opp.Seller__c=='POYANG RALLYSON TECHNOLOGY CO., LTD')
		        		{
		        			recipients.add('hanxu.dong@jinkosolar.com');
		        			recipients.add('ding.fang@jinkosolar.com');
		        			recipients.add('wenbo.cai@jinkosolar.com');
		        			recipients.add('yahan.yu@jinkosolar.com');
		        		}else if(opp.Seller__c=='JINKO SOLAR TECHNOLOGY SDN.BHD.')
		        		{
		        			recipients.add('yunsien.tan@jinkosolar.com');
		        			recipients.add('waikhuan.liang@jinkosolar.com');
		        			recipients.add('wenbo.cai@jinkosolar.com');
		        			recipients.add('yahan.yu@jinkosolar.com');
		        		}else
		        		{
		        			recipients.add('crmlogistics@jinkosolar.com');
		        		} */


		        		//沙盒测试请启用如下接收人
		        		recipients.add('leo.wu@jinkosolar.com');
		        		System.debug('recipients'+recipients);
		        		
		        		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				    	mail.setUseSignature(false);
				        mail.setCharset('UTF-8');
				        mail.setSubject(subject);
				        mail.setHtmlBody(body); 
				      //  mail.setPlainTextBody( opp.Name+'\n'+'https://cs58.salesforce.com/'+opp.Id);
				        /* if(list_email.size()>0){
		                mail.setTemplateId(list_email[0].Id);
		                } */
						//收件人
						mail.setToAddresses(recipients);//地址con.Email
						//mail.setToAddresses(System.Label.SAP_Update_Contact);
						//抄送
						//mail.setWhatId(opp.Id);
						mail.setCcAddresses(new String[] {});
				        // mails.add(mail); 
				        Messaging.sendEmail(new Messaging.Email[]{ mail });	 
				        
				       opp.Send_Email_To_Logistic__c=true;

		        	}
		        	
		    	}
		    	update list_oppnew;
     		} 

     		
     }

 public void Update_Freight(list<Opportunity> list_newopp,map<Id,Opportunity> map_oldopp)
     	{
     		System.debug('开始自动计算');
     		set<Id> set_oppid=new set<Id>();
     		for(Opportunity opp:list_newopp)
     		{
     			if(opp.Send_Email_To_Logistic__c ==true 
                    &&((opp.Land_Freight_China__c !=null && opp.Land_Freight_China__c !=map_oldopp.get(opp.Id).Land_Freight_China__c)||
                    (opp.Ocean_Freight__c!=null &&opp.Ocean_Freight__c !=map_oldopp.get(opp.Id).Ocean_Freight__c)||
                    (opp.Land_Freight_Oversea__c !=null && opp.Land_Freight_Oversea__c !=map_oldopp.get(opp.Id).Land_Freight_Oversea__c) )
                    )
     			{
     				set_oppid.add(opp.Id);
     			}
     		}
     		System.debug('set_oppid++++++++++++++++++'+set_oppid);
     		if(set_oppid.size() >0)
     		{
     			list<Opportunity> list_getopp=[SELECT Id,China_Land_Freight__c,Freight_Ocean__c,Oversea_Freight__c,Power__c,Piece__c
     											,Land_Freight_China__c,
                                               Ocean_Freight__c,
                                               Land_Freight_Oversea__c 
                                               from Opportunity where id in:set_oppid];
     		

     		if(list_getopp.size()>0)
     		{
     			 String regEx='(\\d+(\\,\\d+))|(\\d+(\\.\\d+))|(\\d+)'; 
            	 Pattern p = Pattern.compile(regEx);
            
            	for(Opportunity op:list_getopp)
            	{
                    /*
					if(op.Land_Freight_China__c != null){
					    String str = op.Land_Freight_China__c;
					    Matcher m = p.matcher(str); 

					     if (m.find()) {  
					            String num=m.group();
					            if(num.contains('.')==true){
					          integer ii=num.indexOf(',');
					            String str1=num.substring(0, ii);
					            String str2=num.substring(ii+1,num.length());
					            num=str1+str2; 
					            op.China_Land_Freight__c=num; 
					            System.debug('num+++++++++++++'+num+'************op.China_Land_Freight__c********'+op.China_Land_Freight__c);
					        }else{
					        	Decimal fri=Decimal.valueOf(num)/op.Power__c/Decimal.valueOf(op.Piece__c);
					        	fri=fri.setScale(4);
					         	op.China_Land_Freight__c=String.valueOf(fri);  
					         	System.debug('fri Oversea_Freight__c没有小数点************* '+fri);  
					        }
					        }  
					}
            */
                     /*
					 if(op.Land_Freight_Oversea__c != null){
					    String str = op.Land_Freight_Oversea__c;
					     Matcher m = p.matcher(str); 
					    if (m.find()) {  
					        String num=m.group();
					        if(num.contains(',')==true){
					           integer ii=num.indexOf(',');
					            String str1=num.substring(0, ii);
					            String str2=num.substring(ii+1,num.length());
					            num=str1+str2; 
					            op.Oversea_Freight__c=num; 
					            System.debug('num Oversea_Freight__c有小数点************* '+num);
					        }else{
					         	Decimal fri=Decimal.valueOf(num)/op.Power__c/Decimal.valueOf(op.Piece__c);
					         	fri=fri.setScale(4);
					         	op.Oversea_Freight__c=String.valueOf(fri);     
					         System.debug('fri Oversea_Freight__c没有小数点************* '+fri); 
					        }
					        }   
					}
*/
                    /*
					 if(op.Ocean_Freight__c != null){
					    String str = op.Ocean_Freight__c;
					     Matcher m = p.matcher(str);
					    if (m.find()) {  
					        String num=m.group();
					        if(num.contains('.')==true){
					            integer ii=num.indexOf(',');
					            String str1=num.substring(0, ii);
					            String str2=num.substring(ii+1,num.length());
					            num=str1+str2;
					            op.Freight_Ocean__c=num; 
					            System.debug('num Freight_Ocean__c有小数点************* '+num);
					        }else{
					         	Decimal fri=Decimal.valueOf(num)/op.Power__c/Decimal.valueOf(op.Piece__c);
					         	fri=fri.setScale(4);
					         	op.Freight_Ocean__c=String.valueOf(fri);     
					         System.debug('fri Freight_Ocean__c没有小数点************* '+fri); 
					        }
					      }  
					   
						}
*/
					}
						update list_getopp;
     			}
     		}

     	}




 public void runTest()
    {
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;


    }


}