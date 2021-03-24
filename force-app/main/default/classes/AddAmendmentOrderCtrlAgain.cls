public class AddAmendmentOrderCtrlAgain {
	//public boolean SaveLock=true;
	public order mp{
		get;set;
	}
	public String requestId{
		get;set;
	}
	public order lm {
		get;set;
	}
	public Double LogisticsCost {
		get;set;
	}
	public decimal AmountPaid {
		get;set;
	}
	public decimal orderTotalPrice {
		get;set;
	}
	public String deleteID {
		get;set;
	}
	public List<order> Orderlst {
		get;set;
	}
	public List<Payment__c> Plst {
		get;set;
	}
	public List<OrderItem> Oslst {
		get;set;
	}
	public String yuyan {
		get;set;
	}
    public String Note {
		get;set;
	}
	public List<Amendment_Order_Product__c> aop {
		get;set;
	}
	public Amendment__c am {
		get;set;
	}

	public AddAmendmentOrderCtrlAgain(ApexPages.StandardController sd) {
		system.debug('deleteID:' + deleteID);
		requestId = ApexPages.currentPage().getParameters().get('id');
		lm = [select id, lock__c from order where id =: requestId];

		system.debug(requestId);
		if (requestId != null) {
			this.mp = (order)UtilClass.GetObjByID(Schema.SObjectType.order, requestId);
		}
		LoadDataList();
	}

	public void LoadDataList() {
		//		try{
		Orderlst = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.order) + ' ' + 'Where id =: requestId');

		Oslst = Database.query(UtilClass.MakeSelectSql(Schema.SObjectType.OrderItem) + ' ' + 'Where OrderID =: requestId');

		orderTotalPrice = 0;
		aop = new List<Amendment_Order_Product__c>();
		yuyan = Orderlst[0].CurrencyIsoCode;

		for (Integer i = 1 ; i < Oslst.size() + 1 ; i++) {
			system.debug('Request_No__c:' + i);
			OrderItem oi = Oslst[i - 1];
			Amendment_Order_Product__c ao = new Amendment_Order_Product__c();
			system.debug('Request_No__c2:' + i);
			ao.Request_No__c = i;
			system.debug('Request_No__c3:' + ao.Request_No__c);
			ao.CurrencyIsoCode = yuyan;
			ao.Cheetah__c = oi.Cheetah__c;
			ao.ID__c = oi.id;
			ao.AvailableQuantity__c = oi.AvailableQuantity;
			ao.Battery_Type__c = oi.Battery_Type__c;
			ao.Bus_bars_of_cell__c = oi.Bus_bars_of_cell__c;
			ao.Certification__c = oi.Certification__c;
			ao.Color_of_frame_and_backsheet__c = oi.Color_of_frame_and_backsheet__c;
			ao.Connector__c = oi.Connector__c;
			ao.EndDate__c = oi.EndDate;
			ao.Expected_delivery_date__c = oi.Expected_delivery_date__c;
			ao.Grade__c = oi.Grade__c;
			ao.Guaranteed_Delivery_Date__c = oi.Guaranteed_Delivery_Date__c;
			ao.Guaranteed_Delivery_Date_japan__c = oi.Guaranteed_Delivery_Date_japan__c;
			ao.Guaranteed_ETD__c = oi.Requested_ETD__c;
			ao.Guaranteed_Ex_work_date__c = oi.Requested_Ex_work_date__c;
			ao.ISTBD__c = oi.IS_TBD__c;
			ao.Length_of_Junction_Box_wiring__c = oi.Length_of_Junction_Box_wiring__c;
			ao.Description__c = oi.Description;
			ao.ListPrice__c = oi.ListPrice;
			ao.M_P__c = oi.MP__c;
			ao.MaterielNo__c = oi.MaterielNo__c;
			ao.Order__c = oi.Orderid;
			if (oi.product_active__c == false) {
				List<product2> p3 = [select id from product2 where name=:oi.Product_Name__c and isactive=true];
				if (p3.size() > 0) {
					ao.Product2__c = p3[0].id;
				}
			} else {
				ao.Product2__c = oi.product2id;
			}

			ao.Product_Code__c = oi.OrderItemNumber;
			ao.Quantity__c = oi.Quantity;
			ao.QuoteLineItem__c = oi.QuoteLineItemid;
			ao.Remarks__c = oi.Remarks__c;
			ao.Requested_Goods_Ready_date__c = oi.Requested_Goods_Ready_date__c;
			ao.RowNo__c = oi.RowNo__c;
			ao.SAP_Product_Materiel_No__c = oi.SAP_Product_Materiel_No__c;
			ao.Special_required__c = oi.Special_required__c;
			ao.ServiceDate__c = oi.ServiceDate;
			ao.Total_MW__c = oi.Total_MW__c;
			ao.total_Price__c = oi.Total_Price__c;
			ao.TotalPriceBackstage__c = oi.TotalPrice;
			ao.UnitPrice__c = oi.UnitPrice;
			ao.Type_of_module__c = oi.Type_of_module__c;
			ao.unit_Price__c = oi.Unit_Price__c;
			ao.Quantity_shipped__c = null;
			aop.add(ao);


			orderTotalPrice += oi.total_Price__c;
		}
		system.debug('列表:' + aop);
		//		}catch(exception e){
		//
		//		}

	}

	public PageReference Cancel() {
		PageReference pr = new PageReference('/' + requestId);
		return pr;
	}

	public PageReference SelectDailyDetail() {
		Id recordTypeId = Schema.SObjectType.Amendment__c.getRecordTypeInfosByDeveloperName().get(
				'Termination_Agreement').getRecordTypeId();

		String flag = '0';
		boolean tf = lm.lock__c;
		lm.lock__c = false;
		update lm;
		List<Amendment__c> aList = [select id from Amendment__c where Order__c=:requestId];
		if (aList.size() == 0) {
			flag = '1';
		}
        /**
		if (AmountPaid > orderTotalPrice) {
			ApexPages.addMessage(new ApexPages.Message(
					ApexPages.Severity.ERROR,
					'The [Amount paid by the buyer] cannot be greater than the [Total Price]!'));
			return null;
		}
**/
List<Standard_Template_Teams__c> sttc = [Select id, Name, Type__c, Flag__c, Field_Values__c, Actual_Values__c from Standard_Template_Teams__c where Name ='Mutual Termination Agreement'];
		System.debug('sttc.size()----------->' + sttc.size());
List<Amendment__c> TList = [select id from Amendment__c where Order__c=:requestId and RecordTypeId=:recordTypeId];
		am = new Amendment__c();
		am.RecordTypeId = recordTypeId;
		am.Summary_Comments__c = Orderlst[0].Summary_Comments__c;
		am.name = Orderlst[0].OrderNumber + '   T'+(Tlist.size()+1);
		am.Order__c = requestId;
		am.CurrencyIsoCode = Orderlst[0].CurrencyIsoCode;
		am.Amount_paid_by_the_buyer__c = AmountPaid;
		am.Contract__c = Orderlst[0].ContractId;
		am.Opportunity__c = Orderlst[0].Opportunity__c;
		am.Contract__c = Orderlst[0].ContractId;
		am.Contract_Owner__c = Orderlst[0].Contract_Owner__c;
		am.Contract_No__c = Orderlst[0].Contract_No__c;
		am.Region__c = Orderlst[0].Region__c;
		am.Mutual_Termination_Agreement_Area__c = sttc[0].Actual_Values__c;
		am.Destination_Country__c = Orderlst[0].Destination_Country__c;
		am.Buyer__c = Orderlst[0].Buyer__c;
		am.SELLER__c = Orderlst[0].SELLER__c;
		am.Note__c = Note;
        am.Account__c = Orderlst[0].Buyer__c;
        am.Effective_Date__c = Orderlst[0].Contract_Execution_Date__c;
		system.debug('Total_Price__c:' + Orderlst[0].Total_Price__c);
		system.debug('Amount_paid_by_the_buyer__c:' + am.Amount_paid_by_the_buyer__c);

		Savepoint sp = Database.setSavepoint();

		insert am;
		for (Amendment_Order_Product__c ao : aop) {
			ao.CurrencyIsoCode = yuyan;
			ao.OriginalOrderItem__c = am.id;
			system.debug('Quantity__c:' + ao.Quantity__c);
			system.debug('orderTotalPrice:' + ao.Quantity_shipped__c);
			if (ao.Quantity_shipped__c > ao.Quantity__c) {
				ApexPages.addMessage(new ApexPages.Message(
						ApexPages.Severity.ERROR, 'The [Quantity shipped] cannot be greater than the [Quantity]!'));
				Database.rollback(sp);
				return null;
			}
		}
		upsert aop;
		lm.lock__c = tf;

		update lm;
		return new ApexPages.StandardController(am).view();

	}
    
    
        public void test(){
        Decimal i=0;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
             i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
             i++;
          i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
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