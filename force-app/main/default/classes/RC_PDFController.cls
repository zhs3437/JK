public class RC_PDFController {
    public String printDate{get;set;}
    public Information_of_Seller__c seller{get;set;}   
    public String requestId{get;set;}
    public leanx__lg_Contract__c con{get;set;}
    public BackInfo__c bankInfo{get;set;}
    public String Address{get;set;}
    public String AuthorizedSignatory{get;set;}
    public String Title{get;set;}
    public String SellerVATNO{get;set;}
    public String phone{get;set;}
    public String postCode{get;set;}
    public String fax{get;set;}
    public String sales{get;set;}
    public Account buyer{get;set;}
    public String buyerAddress{get;set;}
    public String contactPeople{get;set;}
    public List<Contract_Component__c> pds {get;set;}
    public List<Payment__c> pms {get;set;}
    public String chineseTotalPrice {get;set;}
    public String paymentDescription {get;set;}
    public Date lastGDD {get;set;}
    public String specialPackingMethod {get;set;}
    //买方银行信息
    public String buyerName {get;set;}
	public String sellerBankName {get;set;} 
    public String sellerBankCode {get;set;}
    public String buyerPostCode {get;set;}
	public String buyerFax {get;set;} 
    public String buyerPhone {get;set;}
    public String VAT {get;set;}
    // 大写数字
    public static final String[] NUMBERS = new String[]{'零','壹','贰','叁','肆','伍','陆','柒','捌','玖'};
        // 整数部分的单位
    public static final String[] IUNIT = new String[]{'圆','拾','佰','仟','万','拾','佰','仟','亿','拾','佰','仟','万','拾','佰','仟'};
    // 小数部分的单位
    public static final String[] DUNIT = new String[]{'角','分','厘'};

    public RC_PDFController(ApexPages.StandardController controller) {
        Date todayDate = Date.today();
        DateFormula(todayDate);
        requestId = ApexPages.currentPage().getParameters().get('id');		
        // init - Contract
        if(requestId != null)con = Database.query(Utils.MakeSelectSql('leanx__lg_Contract__c') + ' WHERE Id =: requestId');
        //特殊包装方式
        if(con.Special_packing_method__c =='' || con.Special_packing_method__c ==null){
            specialPackingMethod = '无';
        }else{
            specialPackingMethod = con.Special_packing_method__c; 
        }
        bankInfo = [SELECT ID,
                            Name,
                            Address__c,
                            Bank_Name__c,
                            BENEFICIARY_s_A_C__c,
                            BENEFICIARY_s_Address__c,
                            BENEFICIARY_s_Name__c,
                            Short_Name__c,
                            CurrencyIsoCode,
                            SWIFT__c 
                    FROM   BackInfo__c 
                    WHERE  BENEFICIARY_s_Name__c =:con.SELLER__c 
                    AND CurrencyIsoCode =: con.CurrencyIsoCode 
                    LIMIT 1];
        List<Information_of_Seller__c>  sellers = [
            SELECT id,
            Address__c,
            Authorized_Signatory__c,
            Seller__c,
            Title__c,
            Seller_VAT_NO__c,
            Fax__c,
            Phone__c,
            Postcode__c
            FROM Information_of_Seller__c 
            WHERE  Seller__c =: con.SELLER__c
        ];
        //获取卖方地址                                           
        if(sellers.size() > 0){            
            Address = '';
            AuthorizedSignatory = '';
            Title = '';
            SellerVATNO ='';
            phone ='';
            postCode ='';
            fax ='';                                               
            Information_of_Seller__c infoSeller = sellers[0];            
            Address = infoSeller.Address__c;
            AuthorizedSignatory = infoSeller.Authorized_Signatory__c;
            Title = infoSeller.Title__c;
            SellerVATNO=infoSeller.Seller_VAT_NO__c;
            phone = String.valueOf(infoSeller.Phone__c);
            postCode = infoSeller.Postcode__c;
            fax = infoSeller.Fax__c;
            User s = [SELECT ID,Name FROM User WHERE ID =:con.OwnerId];
            sales = s.Name;
        }
        //获取买方地址
        buyer =[
            SELECT id,
            Name,
            BillingAddress,
            BillingCountry,
            BillingCity,
            BillingState,
            BillingStreet,
            BillingPostalCode,
            Taxpayer_Identification_No__c,
            Fax,
            Phone,
            Bank_Account__c,                        
            Bank_Code__c,
            Bank_Country__c,
            Bank_Name__c,
            Bank_Region__c,
            Bank_Street__c
            FROM   Account       
            WHERE  id = :con.leanx__Account__c Limit 1
        ];
        buyerAddress = (buyer.BillingCountry != null ? buyer.BillingCountry : '') + ' ' + 
                        (buyer.BillingState != null ? buyer.BillingState : '') + ' ' + 
                        (buyer.BillingCity != null ? buyer.BillingCity : '') + ' ' + 
                        (buyer.BillingStreet != null ? buyer.BillingStreet : ''); 
        sellerBankName = buyer.Bank_Name__c;
        sellerBankCode = buyer.Bank_Account__c;
        buyerPostCode = buyer.BillingPostalCode;
        buyerFax = buyer.Fax;
        buyerPhone = buyer.Phone;
        buyerName = buyer.Name;
        VAT = buyer.Taxpayer_Identification_No__c;
        //获取联系人
        List<Contact> contactLst = [
            SELECT id,
            Name,
            AccountId
            FROM   Contact
            WHERE  AccountId = : buyer.Id
        ];
        if (contactLst.size()>0) {
            contactPeople = contactLst[0].Name;
        }
        //获取产品行
        pds = new List<Contract_Component__c>();
        pds = Database.query(Utils.MakeSelectSql('Contract_Component__c') + ' WHERE Contract__c =: requestId ORDER BY Name');
        //获取付款方式
        pms = new List<Payment__c>();
        pms = Database.query(Utils.MakeSelectSql('Payment__c') + ' WHERE China_Contract__c = :requestId order by Down_Balance_Payment__c,createddate');
            //最晚的产品交期
        lastGDD = pds[pds.size()-1].Guaranteed_Delivery_Date__c;
        //Decimal rounded = System.Math.round(con.Total_Price__c);
        System.debug('rounded------>'+con.Total_Price__c.setScale(2));
        chineseTotalPrice = RC_PDFController.toChinese(String.valueOf(con.Total_Price__c.setScale(2)));
        System.debug('rounded2------>'+String.valueOf(con.Total_Price__c.setScale(2)));
        paymentDescription = String.isNotBlank(con.Payment_Term_Description__c) ? con.Payment_Term_Description__c.replace('][', '，').remove('[').replace(']', '。') : '';
    }
    
    //中文格式化日期
    public String DateFormula(Date Formula){
        String Year = String.valueOf(Formula.year());
        String Month = String.valueOf(Formula.month());
        String Day = String.valueOf(Formula.day());   
        printDate = Year+'年'+Month+'月'+Day+'日';
        return printDate;
    }
    //小写金额转换为大写金额代码方法
    /**
* 转换为大写的中文金额
* @param str 字符串类型的 金额数字
* @return
*/
    public static String toChinese(String str) {
        System.debug('str---->'+str);
        // 判断输入的金额字符串是否符合要求
        /* Pattern p = Pattern.compile('(-)?[\\d]*(.)?[\\d]*');//取得Pattern类对象  
Matcher m = p.matcher(str);//取得Matcher类对象 
if (String.isBlank(str) || !m.matches()) {
return '抱歉，请输入数字！';
}*/        
        if('0'==str || '0.00'==str || '0.0'==str || '0.00000'==str) {
            return '零元';
        }        
        // 判断金额数字中是否存在负号"-"
        boolean flag = false;
        if(str.startsWith('-')){
            // 标志位，标志此金额数字为负数
            flag = true;
            str = str.replaceAll('-', '');
        }        
        // 去掉金额数字中的逗号","
        str = str.replaceAll(',', '');
        String integerStr;//整数部分数字
        String decimalStr;//小数部分数字        
        // 初始化：分离整数部分和小数部分
        if(str.indexOf('.')>0) {
            integerStr = str.substring(0,str.indexOf('.'));
            decimalStr = str.substring(str.indexOf('.') + 1);
        }else if(str.indexOf('.')==0) {
            integerStr = '';
            decimalStr = str.substring(1);
        }else {
            integerStr = str;
            decimalStr = '';
        }        
        // beyond超出计算能力，直接返回
        if(integerStr.length()>IUNIT.size()) {
            return '超出计算能力！';
        }        
        // 整数部分数字
        Integer[] integers = toIntArray(integerStr);
        // 判断整数部分是否存在输入012的情况
        if (integers.size()>1 && integers[0] == 0) {
            return '抱歉，输入数字不符合要求！';
        }
        // 设置万单位
        boolean isWan = isWan5(integerStr);
        // 小数部分数字
        Integer[] decimals = toIntArray(decimalStr);
        // 返回最终的大写金额
        String result = getChineseInteger(integers, isWan) + getChineseDecimal(decimals);
        if(flag){
            // 如果是负数，加上"负"
            return '负' + result;
        }else{
            return result;
        }
    }       
    /**
* 将字符串转为int数组
* @param number 数字
* @return
*/
    private static Integer[] toIntArray(String numbers) {
        Integer[] arrays = new Integer[numbers.length()];
        for(Integer i = 0;i<numbers.length();i++) {
            //arrays[i] = Integer.parseInt(numbers.substring(i,i+1));
             arrays[i] = Integer.valueOf(numbers.substring(i,i+1));
        }
        return arrays;
    }
    /**
* 将整数部分转为大写的金额
* @param integers 整数部分数字
* @param isWan 整数部分是否已经是达到【万】
* @return
*/
    public static String getChineseInteger(Integer[] integers,boolean isWan) {
        System.debug('integers-->'+integers);
        String chineseInteger ='';
        Integer length = integers.size();
        if (length == 1 && integers[0] == 0) {
            return '';
        }
        for(Integer i=0; i<length; i++) {
            String key = '';
            if(integers[i] == 0) {
                if((length - i) == 13)//万（亿）
                    key = IUNIT[4];
                else if((length - i) == 9) {//亿
                    key = IUNIT[8];
                }else if((length - i) == 5 && isWan) {//万
                    key = IUNIT[4];
                }else if((length - i) == 1) {//元
                    key = IUNIT[0];
                }
                if((length - i)>1 && integers[i+1]!=0) {
                    key += NUMBERS[0];
                }
            }
            if(integers[i]==0){
                chineseInteger += key;
            }else{
                chineseInteger += NUMBERS[integers[i]]+IUNIT[length - i -1];
            }
            // chineseInteger=integers[i]==0?key:(NUMBERS[integers[i]]+IUNIT[length - i -1]);
        }
        return chineseInteger;
    }
    
    /**
* 将小数部分转为大写的金额
* @param decimals 小数部分的数字
* @return
*/
    private static String getChineseDecimal(Integer[] decimals) {
        System.debug('decimals-->'+decimals);
        String chineseDecimal='';
        for(Integer i = 0;i<decimals.size();i++) {
            if(i == 3) {
                break;
            }
            if(decimals[i]==0){
                chineseDecimal +='';
            }else{
                chineseDecimal +=NUMBERS[decimals[i]]+DUNIT[i];
            }
            //chineseDecimal = decimals[i]==0?'':(NUMBERS[decimals[i]]+DUNIT[i]);
        }
        return chineseDecimal;
    }
    
    /**
* 判断当前整数部分是否已经是达到【万】
* @param integerStr 整数部分数字
* @return
*/
    private static boolean isWan5(String integerStr) {
        Integer length = integerStr.length();
        if(length > 4) {
            String subInteger = '';
            if(length > 8) {
                subInteger = integerStr.substring(length- 8,length -4);
            }else {
                subInteger = integerStr.substring(0,length - 4);
            }
            return Integer.valueOf(subInteger) > 0;
        }else {
            return false;
        }
    }
}