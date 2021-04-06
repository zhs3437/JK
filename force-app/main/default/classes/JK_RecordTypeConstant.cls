/**
 * @author Miller Zhao
 * @date 2021-04-21
 * @description This class is used to store recordtype values.
 */
public class JK_RecordTypeConstant {
    //Oppportunity
    public static final String OPPORTUNITY_RECORDTYPE_NAME_ENERGY = Label.JK_Opportunity_Record_Type_Energy;
    public static final Id OPPORTUNITY_RECORDTYPE_ID_ENERGY = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(OPPORTUNITY_RECORDTYPE_NAME_ENERGY).getRecordTypeId();

    //Contract
    public static final String CONTRACT_RECORDTYPE_NAME_ENERGY = Label.JK_Opportunity_Record_Type_Energy;
    public static final Id CONTRACT_RECORDTYPE_ID_ENERGY = Schema.SObjectType.ConTract.getRecordTypeInfosByName().get(CONTRACT_RECORDTYPE_NAME_ENERGY).getRecordTypeId();
}
