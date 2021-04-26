/**
 * @author Miller Zhao
 * @date 2021-04-21
 * @description This class is used to store recordtype values.
 */
public class JK_RecordTypeConstant {
    //Oppportunity Record Type Name
    public static final String OPPORTUNITY_RECORDTYPE_NAME_ENERGY = Label.JK_Opportunity_Record_Type_Energy;

    //Opportunity Record Type Id
    public static final Id OPPORTUNITY_RECORDTYPE_ID_ENERGY = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(OPPORTUNITY_RECORDTYPE_NAME_ENERGY).getRecordTypeId();

    //Contract Record Type Name
    public static final String CONTRACT_RECORDTYPE_NAME_ENERGY = Label.JK_Opportunity_Record_Type_Energy;
    public static final String CONTRACT_RECORDTYPE_NAME_1MW_AUSTRALIA_CONTRACT = Label.JK_Contract_Record_Type_1MW_Australia_Contract;
    public static final String CONTRACT_RECORDTYPE_NAME_1MW_GLOBAL_STANDARD_CONTRACT = Label.JK_Contract_Record_Type_1MW_Global_Standard_Contract;
    public static final String CONTRACT_RECORDTYPE_NAME_1MW_JAPAN_CONTRACT = Label.JK_Contract_Record_Type_1MW_Japan_Contract;
    public static final String CONTRACT_RECORDTYPE_NAME_SAMPLE_ORDER = Label.JK_Contract_Record_Type_Sample_Order;
    public static final String CONTRACT_RECORDTYPE_NAME_Service = Label.JK_Contract_Record_Type_Service;
    
    //Contract Record Type Id
    public static final Id CONTRACT_RECORDTYPE_ID_ENERGY = Schema.SObjectType.ConTract.getRecordTypeInfosByName().get(CONTRACT_RECORDTYPE_NAME_ENERGY).getRecordTypeId();
    public static final Id CONTRACT_RECORDTYPE_ID_1MW_AUSTRALIA_CONTRACT = Schema.SObjectType.ConTract.getRecordTypeInfosByName().get(CONTRACT_RECORDTYPE_NAME_1MW_AUSTRALIA_CONTRACT).getRecordTypeId();
    public static final Id CONTRACT_RECORDTYPE_ID_1MW_GLOBAL_STANDARD_CONTRACT = Schema.SObjectType.ConTract.getRecordTypeInfosByName().get(CONTRACT_RECORDTYPE_NAME_1MW_GLOBAL_STANDARD_CONTRACT).getRecordTypeId();
    public static final Id CONTRACT_RECORDTYPE_ID_1MW_JAPAN_CONTRACT = Schema.SObjectType.ConTract.getRecordTypeInfosByName().get(CONTRACT_RECORDTYPE_NAME_1MW_JAPAN_CONTRACT).getRecordTypeId();
    public static final Id CONTRACT_RECORDTYPE_ID_SAMPLE_ORDER = Schema.SObjectType.ConTract.getRecordTypeInfosByName().get(CONTRACT_RECORDTYPE_NAME_SAMPLE_ORDER).getRecordTypeId();
    public static final Id CONTRACT_RECORDTYPE_ID_Service = Schema.SObjectType.ConTract.getRecordTypeInfosByName().get(CONTRACT_RECORDTYPE_NAME_Service).getRecordTypeId();
}