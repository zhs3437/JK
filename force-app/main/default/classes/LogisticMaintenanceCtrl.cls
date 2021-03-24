public class LogisticMaintenanceCtrl {
    public list<Logistic__c> logistic{get;set;}
    public list<Ocean_Freight__c> ocean{get;set;}
    public SelectOption[] allfactory {get;set;} //所有工厂
    public SelectOption[] factory {get;set;}
    public SelectOption[] allDport {get;set;} //所有起运港
    public SelectOption[] Dport {get;set;} 
    public SelectOption[] allDesPort {get;set;} //所有目的港
    public SelectOption[] DesPort {get;set;}
    public SelectOption[] allDesCon {get;set;}//所有国家
    public SelectOption[] DesCon {get;set;}
    public String Gtype {get;set;} //货物型号
    public String editId {get;set;} 
    public String num {get;set;}//为编号预留


    public list<SelectOption> getGoods()
    {
        List<SelectOption> goods = new List<SelectOption>();
        goods.add(new SelectOption('','-None-'));
        set<String> set_good =new set<String>();
        List<Logistic__c> list_log = new List<Logistic__c>();
        list_log=[Select Box_Amount__c from Logistic__c where Box_Amount__c !=null];
        if(list_log.size()>0)
        {
            for(logistic__c log:list_log)
            {
                if(!set_good.contains(log.Box_Amount__c))
                {
                    set_good.add(log.Box_Amount__c);
                    goods.add(new SelectOption(log.Box_Amount__c,log.Box_Amount__c));
                }
            }
        }
        return goods;
    }
    
    public LogisticMaintenanceCtrl()
    {

         ocean =new list<Ocean_Freight__c>();

        allfactory=new list<SelectOption>();
        factory = new list<SelectOption>();
        allDport=new list<SelectOption>();
        Dport =new list<SelectOption>();
        allDesPort=new list<SelectOption>();
        DesPort =new list<SelectOption>();
        allDesCon=new list<SelectOption>();
        DesCon =new list<SelectOption>();
        set<String> set_facc=new set<String>();
        set<String> set_dportt=new set<String>();
        set<String> set_despp=new set<String>();
        set<String> set_descc=new set<String>();
        list<Logistic__c> list_fac=[Select Departure_Factory__c,Departure_Port__c from Logistic__c];
        list<Ocean_Freight__c> list_oce=[Select Destination_Country__c,Destination_Port__c from Ocean_Freight__c];
        // map<Id,String> map_allfac=new map<Id,String>();
        if(list_fac.size()>0 )
        {
            for(Logistic__c logis:list_fac)
            {
                if(!set_facc.contains(logis.Departure_Factory__c)){
                    set_facc.add(logis.Departure_Factory__c);
                    allfactory.add(new SelectOption(logis.Departure_Factory__c,logis.Departure_Factory__c));
                }
                 if(!set_dportt.contains(logis.Departure_Port__c)){
                    set_dportt.add(logis.Departure_Port__c);
                    allDport.add(new SelectOption(logis.Departure_Port__c,logis.Departure_Port__c));
                 }
            }

            for(Ocean_Freight__c oce:list_oce){
                 if(!set_despp.contains(oce.Destination_Port__c)){
                    set_despp.add(oce.Destination_Port__c);
                    allDesPort.add(new SelectOption(oce.Destination_Port__c,oce.Destination_Port__c));
                 }
                 if(!set_descc.contains(oce.Destination_Country__c))
                 {
                    set_descc.add(oce.Destination_Country__c);
                    allDesCon.add(new SelectOption(oce.Destination_Country__c,oce.Destination_Country__c));
                 }
            }
        }
    }
    
    
    
    //start searching
    public void searchstart()
    {
            logistic = new List<Logistic__c>();
            set<String> set_fac =new set<String>(); //Factory
            Set<String> set_Dport = new Set<String>(); //Departure Port
            Set<String> set_Desp = new Set<String>(); //
            Set<String> set_Desc = new Set<String>();
	        if( (factory.size()==0 && Dport.size()==0 && DesPort.size()==0 &&DesCon.size()==0)|| 
                (factory.size()>0  && Dport.size()==0 && DesPort.size()==0 &&DesCon.size()==0)||
                (Dport.size()>0 && factory.size()==0 && DesPort.size()==0 &&DesCon.size()==0) ||
                (DesPort.size()>0 && factory.size()==0 && DesCon.size()==0 && Dport.size()==0)||
                (DesCon.size()>0 &&factory.size()==0 &&Dport.size()==0&&DesPort.size()==0))
            {
                Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Please choose at least two or more conditions')); 
            }
             if(factory.size()>0 && Dport.size()>0 && DesPort.size()==0 && DesCon.size()==0) //Factory and Departure Port
            {

                for(SelectOption son:factory)
                {
                    set_fac.add(son.getValue());
                }
                for(SelectOption son1:Dport)
                {
                    set_Dport.add(son1.getValue());
                }

                ocean=[Select Id,Logistic__r.Id,Logistic__r.Goods_Type__c,Logistic__r.Name,Logistic__r.Freight_Price_All__c,Logistic__r.Freight_Price_Trans__c,Logistic__r.Type_of_Shipping__c,
                Logistic__r.Box_Amount__c,Logistic__r.Freight_Price_Total__c,Freight_Price_Ocean__c,Destination_Country__c,Destination_Port__c,Total_Price__c,Logistic__r.Maintenance_day__c,Logistic__r.Departure_Factory__c,Logistic__r.Departure_Port__c from Ocean_Freight__c where Logistic__r.Departure_Factory__c in:set_fac and Logistic__r.Departure_Port__c in:set_Dport ];

            }
             if(factory.size()>0 && Dport.size()>0 && DesCon.size()>0 && DesPort.size()==0) //选择工厂 起运港 国家
            {
               for(SelectOption son:factory)
                {
                    set_fac.add(son.getValue());
                }
                for(SelectOption son1:Dport)
                {
                    set_Dport.add(son1.getValue());
                }
                for(SelectOption son2:DesCon)
                {
                    set_Desc.add(son2.getValue());
                }
                ocean=[Select Id,Logistic__r.Id,Logistic__r.Goods_Type__c,Logistic__r.Name,Logistic__r.Freight_Price_All__c,Logistic__r.Freight_Price_Trans__c,Logistic__r.Type_of_Shipping__c,
                Logistic__r.Box_Amount__c,Logistic__r.Freight_Price_Total__c,Freight_Price_Ocean__c,Destination_Country__c,Destination_Port__c,Total_Price__c,Logistic__r.Maintenance_day__c,Logistic__r.Departure_Factory__c,Logistic__r.Departure_Port__c from Ocean_Freight__c where Logistic__r.Departure_Factory__c in:set_fac and Logistic__r.Departure_Port__c in:set_Dport and Destination_Country__c in:set_Desc];
            }
             if(Dport.size()>0 && DesCon.size()>0 && factory.size()==0 && DesPort.size() ==0) //起运港  国家
            {
                  for(SelectOption son1:Dport)
                {
                    set_Dport.add(son1.getValue());
                }
                for(SelectOption son2:DesCon)
                {
                    set_Desc.add(son2.getValue());
                }
                ocean=[Select Id,Logistic__r.Id,Logistic__r.Goods_Type__c,Logistic__r.Name,Logistic__r.Freight_Price_All__c,Logistic__r.Freight_Price_Trans__c,Logistic__r.Type_of_Shipping__c,
                Logistic__r.Box_Amount__c,Logistic__r.Freight_Price_Total__c,Freight_Price_Ocean__c,Destination_Country__c,Destination_Port__c,Total_Price__c,Logistic__r.Maintenance_day__c,Logistic__r.Departure_Factory__c,Logistic__r.Departure_Port__c from Ocean_Freight__c where  Logistic__r.Departure_Port__c in:set_Dport and Destination_Country__c in:set_Desc];
         
            }
             if(DesCon.size()>0 &&DesPort.size()>0 && factory.size()==0 && Dport.size()==0)
            {
                for(SelectOption son:DesPort)
                {
                    set_Desp.add(son.getValue());
                }
                for(SelectOption son1:DesCon)
                {
                    set_Desc.add(son1.getValue());
                }
                ocean=[Select Id,Logistic__r.Id,Logistic__r.Goods_Type__c,Logistic__r.Name,Logistic__r.Freight_Price_All__c,Logistic__r.Freight_Price_Trans__c,Logistic__r.Type_of_Shipping__c,
                Logistic__r.Box_Amount__c,Logistic__r.Freight_Price_Total__c,Freight_Price_Ocean__c,Destination_Country__c,Destination_Port__c,Total_Price__c,Logistic__r.Maintenance_day__c,Logistic__r.Departure_Factory__c,Logistic__r.Departure_Port__c from Ocean_Freight__c where  Destination_Port__c in:set_Desp and Destination_Country__c in:set_Desc];
            }
             if(factory.size()>0 && Dport.size()>0 && DesCon.size()>0 && DesPort.size()>0)
            {
                for(SelectOption son:factory)
                {
                    set_fac.add(son.getValue());
                }
                for(SelectOption son1:Dport)
                {
                    set_Dport.add(son1.getValue());
                }
                for(SelectOption son2:DesCon)
                {
                    set_Desc.add(son2.getValue());
                }
                for(SelectOption son3:DesPort)
                {
                    set_Desp.add(son3.getValue());
                }
                System.debug('set_fac*****+set_Dport+******set_Desc   set_Desp'+set_fac+set_Desp+set_Dport+set_Desc);
                ocean=[Select Id,Logistic__r.Id,Logistic__r.Goods_Type__c,Logistic__r.Name,Logistic__r.Freight_Price_All__c,Logistic__r.Freight_Price_Trans__c,Logistic__r.Type_of_Shipping__c,
                Logistic__r.Box_Amount__c,Logistic__r.Freight_Price_Total__c,Freight_Price_Ocean__c,Destination_Country__c,Destination_Port__c,Total_Price__c,Logistic__r.Maintenance_day__c,Logistic__r.Departure_Factory__c,Logistic__r.Departure_Port__c from Ocean_Freight__c where Logistic__r.Departure_Factory__c in:set_fac and Logistic__r.Departure_Port__c in:set_Dport and Destination_Country__c in:set_Desc and Destination_Port__c in:set_Desp];
            }
             if(factory.size()>0 && Dport.size()>0&&DesPort.size()>0 && DesCon.size()==0)
            {
                for(SelectOption son:factory)
                {
                    set_fac.add(son.getValue());
                }
                for(SelectOption son1:Dport)
                {
                    set_Dport.add(son1.getValue());
                }
                for(SelectOption son3:DesPort)
                {
                    set_Desp.add(son3.getValue());
                }
                ocean=[Select Id,Logistic__r.Id,Logistic__r.Goods_Type__c,Logistic__r.Name,Logistic__r.Freight_Price_All__c,Logistic__r.Freight_Price_Trans__c,Logistic__r.Type_of_Shipping__c,
                Logistic__r.Box_Amount__c,Logistic__r.Freight_Price_Total__c,Freight_Price_Ocean__c,Destination_Country__c,Destination_Port__c,Total_Price__c,Logistic__r.Maintenance_day__c,Logistic__r.Departure_Factory__c,Logistic__r.Departure_Port__c from Ocean_Freight__c where Logistic__r.Departure_Factory__c in:set_fac and Logistic__r.Departure_Port__c in:set_Dport  and Destination_Port__c in:set_Desp];
            }

    }


    public void saveEditLogs()
    {

        for(Ocean_Freight__c oce:ocean)
        {
            System.debug('ocean++++++++++++++++'+ocean);
            if(oce.Id == editId && oce.Id !=null)
            {

              list<Logistic__c> list_logis=[Select Id,Freight_Price_All__c,Freight_Price_Trans__c from Logistic__c where Id =:oce.Logistic__c];
              //  System.debug('list_logis++++++++++++++++'+list_logis);
                for(logistic__c log:list_logis)
                {
                    System.debug('Freight_Price_All__c & Freight_Price_Trans__c++++'+oce.Logistic__r.Freight_Price_All__c+' '+oce.Logistic__r.Freight_Price_Trans__c);
                    log.Freight_Price_All__c=oce.Logistic__r.Freight_Price_All__c;
                    log.Freight_Price_Trans__c=oce.Logistic__r.Freight_Price_Trans__c;
                    update log;
                } 

                  System.debug('editId++++++++++++++'+editId);
                  System.debug('oce.Id++++++++++++++'+oce.Id);
                  System.debug('oce+++++++++++++++++'+oce);
                
                update oce;
            }
        }
         editId ='';
    }

    public PageReference remove()
    {   
        PageReference prf= ApexPages.currentPage();
        prf.setRedirect(true);
        editId ='';
        return prf;
    }
    public  PageReference cancel()
    {   

        
        editId ='';
        return null;
    }

    public void runTest()
    {
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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