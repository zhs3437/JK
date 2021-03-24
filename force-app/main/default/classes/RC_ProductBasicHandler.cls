public without sharing class RC_ProductBasicHandler extends TriggerHandler {
    
    public override void beforeInsert() {
        basic();
    }

    public override void beforeUpdate() {
        basic();
    }

    public void basic() {
        // calculate product type, power
        List<leanx__hr_Resource__c> products = (List<leanx__hr_Resource__c>) Trigger.new;
        for (leanx__hr_Resource__c product : products) {
            String name = product.Name;
            String[] names = name.split('-');
            Integer power = 0;
            try {
                power = names.size() > 0 && String.isNotBlank(names[0]) ? Integer.valueOf(names[0].replaceAll('([^0-9]+)', '')) : 0;
            } catch (Exception e) {
                power = 0;
                System.debug('Integer.valueOf error : ' + e.getMessage());
            }
            product.Maximum_Power_at_STC_Pmax__c = product.Maximum_Power_at_STC_Pmax__c != null ? product.Maximum_Power_at_STC_Pmax__c : power;
            product.leanx__EmployerNumber__c = product.Product__c;
            String result = this.getProductType(product);
            if (result != null) {
                String[] results = result.split(';');
                product.Series__c = results[0];
                product.Series_Type__c = results[1];
            }
        }
    }

    public String getProductType (leanx__hr_Resource__c product) {
        for (List<List<String>> type : new List<List<List<String>>>{connector, smart, newTiger, tigerPro, tiger, cheetah1, cheetah2, cheetah3, cheetah4}) {
            for (List<String> rule : type) {
                for (Integer c = 0; c < rule.size(); c ++) {
                    String ruleItem = rule[c];
                    if (c == rule.size() - 1) return ruleItem;
                    if (ruleItem == null) continue;
                    Boolean flag_ruleItem = false;
                    if (!ruleItem.contains('>') && !ruleItem.contains('<')) flag_ruleItem = product.Name.contains(ruleItem);
                    else if (ruleItem.contains('>')) flag_ruleItem = product.Maximum_Power_at_STC_Pmax__c > Integer.valueOf(ruleItem.replace('>', ''));
                    else if (ruleItem.contains('<')) flag_ruleItem = product.Maximum_Power_at_STC_Pmax__c < Integer.valueOf(ruleItem.replace('<', ''));
                    if (!flag_ruleItem) break;
                }
            }
        }

        return null;
    }

    static List<List<String>> connector = new List<List<String>>{
        new List<String>{'JK03M', 'Connector;Connector'},
        new List<String>{'JK06M', 'Connector;Connector'},
        new List<String>{'MC4', 'Connector;Connector'},
        new List<String>{'JKT', 'Connector;Connector'}
    };

    static List<List<String>> smart = new List<List<String>>{
        new List<String>{'JKMS', 'TI', 'Smart-TI;Smart'},
        new List<String>{'JKMS', 'TG', 'Smart-TG;Smart'},
        new List<String>{'JKMS', 'MX', 'Smart-MX;Smart'},
        new List<String>{'JKMS', null, 'Smart;Smart'},
        new List<String>{'SMM', 'TI', 'Smart-TI;Smart'},
        new List<String>{'SMM', 'TG', 'Smart-TG;Smart'},
        new List<String>{'SMM', 'MX', 'Smart-MX;Smart'},
        new List<String>{'SMM', null, 'Smart;Smart'}
    };

    static List<List<String>> newTiger = new List<List<String>>{
        new List<String>{'JKM', 'LM', 'BD', 'New Tiger-P-DG;New Tiger'},
        new List<String>{'JKM', 'LM', '-T', 'New Tiger-P-TB;New Tiger'},
        new List<String>{'JKM', 'LM', null, 'New Tiger-P;New Tiger'},
        new List<String>{'MM', 'LM', 'BG', 'New Tiger-P-DG;New Tiger'},
        new List<String>{'MM', 'LM', 'BB', 'New Tiger-P-TB;New Tiger'},
        new List<String>{'MM', 'LM', null, 'New Tiger-P;New Tiger'}
    };

    static List<List<String>> tigerPro = new List<List<String>>{
        new List<String>{'JKM', 'L4', 'N', 'BD', 'Tiger Pro-N-DG;Tiger Pro'},
        new List<String>{'JKM', 'L4', 'N', '-D', 'Tiger Pro-N-SG;Tiger Pro'},
        new List<String>{'JKM', 'L4', 'N', '-T', 'Tiger Pro-N-TB;Tiger Pro'},
        new List<String>{'JKM', 'L4', 'N', null, 'Tiger Pro-N;Tiger Pro'},
        new List<String>{'JKM', 'L4', null, 'BD', 'Tiger Pro-P-DG;Tiger Pro'},
        new List<String>{'JKM', 'L4', null, '-D', 'Tiger Pro-P-SG;Tiger Pro'},
        new List<String>{'JKM', 'L4', null, '-T', 'Tiger Pro-P-TB;Tiger Pro'},
        new List<String>{'JKM', 'L4', null, null, 'Tiger Pro-P;Tiger Pro'},
        new List<String>{'MM', 'LD', 'N', 'BG', 'Tiger Pro-N-DG;Tiger Pro'},
        new List<String>{'MM', 'LD', 'N', 'MG', 'Tiger Pro-N-SG;Tiger Pro'},
        new List<String>{'MM', 'LD', 'N', 'BB', 'Tiger Pro-N-TB;Tiger Pro'},
        new List<String>{'MM', 'LD', 'N', null, 'Tiger Pro-N;Tiger Pro'},
        new List<String>{'MM', 'LD', null, 'BG', 'Tiger Pro-P-DG;Tiger Pro'},
        new List<String>{'MM', 'LD', null, 'MG', 'Tiger Pro-P-SG;Tiger Pro'},
        new List<String>{'MM', 'LD', null, 'BB', 'Tiger Pro-P-TB;Tiger Pro'},
        new List<String>{'MM', 'LD', null, null, 'Tiger Pro-P;Tiger Pro'}
    };

    static List<List<String>> tiger = new List<List<String>>{
        new List<String>{'JKM', 'L3', 'N', 'BD', 'Tiger-N-DG;Tiger'},
        new List<String>{'JKM', 'L3', 'N', '-D', 'Tiger-N-SG;Tiger'},
        new List<String>{'JKM', 'L3', 'N', '-T', 'Tiger-N-TB;Tiger'},
        new List<String>{'JKM', 'L3', 'N', null, 'Tiger-N;Tiger'},
        new List<String>{'JKM', 'L3', null, 'BD', 'Tiger-P-DG;Tiger'},
        new List<String>{'JKM', 'L3', null, '-D', 'Tiger-P-SG;Tiger'},
        new List<String>{'JKM', 'L3', null, '-T', 'Tiger-P-TB;Tiger'},
        new List<String>{'JKM', 'L3', null, null, 'Tiger-P;Tiger'},
        new List<String>{'MM', 'LC', 'N', 'BG', 'Tiger-N-DG;Tiger'},
        new List<String>{'MM', 'LC', 'N', 'MG', 'Tiger-N-SG;Tiger'},
        new List<String>{'MM', 'LC', 'N', 'BB', 'Tiger-N-TB;Tiger'},
        new List<String>{'MM', 'LC', 'N', null, 'Tiger-N;Tiger'},
        new List<String>{'MM', 'LC', null, 'BG', 'Tiger-P-DG;Tiger'},
        new List<String>{'MM', 'LC', null, 'MG', 'Tiger-P-SG;Tiger'},
        new List<String>{'MM', 'LC', null, 'BB', 'Tiger-P-TB;Tiger'},
        new List<String>{'MM', 'LC', null, null, 'Tiger-P;Tiger'},
        new List<String>{'JKSM3', 'Tiger-P;Tiger'},
        new List<String>{'JKSN3', 'Tiger-N;Tiger'}
    };

    static List<List<String>> cheetah1 = new List<List<String>>{
        new List<String>{'JKM', '66', 'N', 'BD', 'Swan Plus-N-DG;Cheetah(Swan)'},
        new List<String>{'JKM', '66', 'N', '-D', 'Swan Plus-N-SG;Cheetah(Swan)'},
        new List<String>{'JKM', '66', 'N', '-T', 'Swan Plus-N-TB;Cheetah(Swan)'},
        new List<String>{'JKM', '66', 'N', null, 'Cheetah Plus-N;Cheetah(Swan)'},
        new List<String>{'JKM', '66', null, 'BD', 'Swan Plus-P-DG;Cheetah(Swan)'},
        new List<String>{'JKM', '66', null, '-D', 'Swan Plus-P-SG;Cheetah(Swan)'},
        new List<String>{'JKM', '66', null, '-T', 'Swan Plus-P-TB;Cheetah(Swan)'},
        new List<String>{'JKM', '66', null, null, 'Cheetah Plus-P;Cheetah(Swan)'},
        new List<String>{'JKM', '78', 'N', 'BD', 'Swan Plus-N-DG;Cheetah(Swan)'},
        new List<String>{'JKM', '78', 'N', '-D', 'Swan Plus-N-SG;Cheetah(Swan)'},
        new List<String>{'JKM', '78', 'N', '-T', 'Swan Plus-N-TB;Cheetah(Swan)'},
        new List<String>{'JKM', '78', 'N', null, 'Cheetah Plus-N;Cheetah(Swan)'},
        new List<String>{'JKM', '78', null, 'BD', 'Swan Plus-P-DG;Cheetah(Swan)'},
        new List<String>{'JKM', '78', null, '-D', 'Swan Plus-P-SG;Cheetah(Swan)'},
        new List<String>{'JKM', '78', null, '-T', 'Swan Plus-P-TB;Cheetah(Swan)'},
        new List<String>{'JKM', '78', null, null, 'Cheetah Plus-P;Cheetah(Swan)'},
        new List<String>{'MM', '66', 'N', 'BG', 'Swan Plus-N-DG;Cheetah(Swan)'},
        new List<String>{'MM', '66', 'N', 'MG', 'Swan Plus-N-SG;Cheetah(Swan)'},
        new List<String>{'MM', '66', 'N', 'BB', 'Swan Plus-N-TB;Cheetah(Swan)'},
        new List<String>{'MM', '66', 'N', null, 'Cheetah Plus-N;Cheetah(Swan)'},
        new List<String>{'MM', '66', null, 'BG', 'Swan Plus-P-DG;Cheetah(Swan)'},
        new List<String>{'MM', '66', null, 'MG', 'Swan Plus-P-SG;Cheetah(Swan)'},
        new List<String>{'MM', '66', null, 'BB', 'Swan Plus-P-TB;Cheetah(Swan)'},
        new List<String>{'MM', '66', null, null, 'Cheetah Plus-P;Cheetah(Swan)'},
        new List<String>{'MM', '78', 'N', 'BG', 'Swan Plus-N-DG;Cheetah(Swan)'},
        new List<String>{'MM', '78', 'N', 'MG', 'Swan Plus-N-SG;Cheetah(Swan)'},
        new List<String>{'MM', '78', 'N', 'BB', 'Swan Plus-N-TB;Cheetah(Swan)'},
        new List<String>{'MM', '78', 'N', null, 'Cheetah Plus-N;Cheetah(Swan)'},
        new List<String>{'MM', '78', null, 'BG', 'Swan Plus-P-DG;Cheetah(Swan)'},
        new List<String>{'MM', '78', null, 'MG', 'Swan Plus-N-SG;Cheetah(Swan)'}, // neo
        new List<String>{'MM', '78', null, 'BB', 'Swan Plus-P-TB;Cheetah(Swan)'},
        new List<String>{'MM', '78', null, null, 'Cheetah Plus-P;Cheetah(Swan)'}
    };

    static List<List<String>> cheetah2 = new List<List<String>>{
        new List<String>{'JKM', 'N', 'BD', 'Swan-N-DG;Cheetah(Swan)'},
        new List<String>{'JKM', 'N', '-D', 'Swan-N-SG;Cheetah(Swan)'},
        new List<String>{'JKM', 'N', '-T', 'Swan-N-TB;Cheetah(Swan)'},
        new List<String>{'JKM', null, 'BDVP', 'Swan-P-DG;Cheetah(Swan)'},
        new List<String>{'JKM', null, 'BD', 'Swan-N-DG;Cheetah(Swan)'},
        new List<String>{'JKM', null, '-D', 'Swan-P-SG;Cheetah(Swan)'},
        new List<String>{'JKM', null, '-T', 'Swan-P-TB;Cheetah(Swan)'},
        new List<String>{'MM', 'N', 'BG', 'Swan-N-DG;Cheetah(Swan)'},
        new List<String>{'MM', 'N', 'MG', 'Swan-N-SG;Cheetah(Swan)'},
        new List<String>{'MM', 'N', 'BB', 'Swan-N-TB;Cheetah(Swan)'},
        new List<String>{'MM', null, 'BG', 'Swan-P-DG;Cheetah(Swan)'},
        new List<String>{'MM', null, 'MG', 'Swan-N-SG;Cheetah(Swan)'}, // neo
        new List<String>{'MM', null, 'BB', 'Swan-P-TB;Cheetah(Swan)'}
    };

    static List<List<String>> cheetah3 = new List<List<String>>{
        new List<String>{'JKM', 'P-', 'H', 'Eagle Poly-HC;Cheetah(Swan)'},
        new List<String>{'JKM', 'P-', null, 'Eagle Poly-FC;Cheetah(Swan)'},
        new List<String>{'MM', 'P-', 'H', 'Eagle Poly-HC;Cheetah(Swan)'},
        new List<String>{'MM', 'P-', null, 'Eagle Poly-FC;Cheetah(Swan)'}
    };

    static List<List<String>> cheetah4 = new List<List<String>>{
        new List<String>{'JKM', 'H', 'N', '-60', '>325', 'Cheetah-N-HC;Cheetah(Swan)'},
        new List<String>{'JKM', 'H', 'N', '-72', '>325', 'Cheetah-N-HC;Cheetah(Swan)'},
        new List<String>{'JKM', 'H', null, '-60', '>325', 'Cheetah-P-HC;Cheetah(Swan)'},
        new List<String>{'JKM', 'H', null, '-72', '>325', 'Cheetah-P-HC;Cheetah(Swan)'},
        new List<String>{'JKM', 'H', 'N', '-60', '<330', 'Eagle Perc-FC;Cheetah(Swan)'},
        new List<String>{'JKM', 'H', 'N', '-72', '<330', 'Eagle Perc-FC;Cheetah(Swan)'},
        new List<String>{'JKM', 'H', null, '-60', '<330', 'Eagle Perc-FC;Cheetah(Swan)'},
        new List<String>{'JKM', 'H', null, '-72', '<330', 'Eagle Perc-FC;Cheetah(Swan)'},
        new List<String>{'JKM', null, 'N', '-60', '>320', 'Cheetah-N-HC;Cheetah(Swan)'},
        new List<String>{'JKM', null, 'N', '-72', '>320', 'Cheetah-N-HC;Cheetah(Swan)'},
        new List<String>{'JKM', null, null, '-60', '>320', 'Cheetah-P-HC;Cheetah(Swan)'},
        new List<String>{'JKM', null, null, '-72', '>320', 'Cheetah-P-HC;Cheetah(Swan)'},
        new List<String>{'JKM', null, 'N', '-60', '<325', 'Eagle Perc-FC;Cheetah(Swan)'},
        new List<String>{'JKM', null, 'N', '-72', '<325', 'Eagle Perc-FC;Cheetah(Swan)'},
        new List<String>{'JKM', null, null, '-60', '<325', 'Eagle Perc-FC;Cheetah(Swan)'},
        new List<String>{'JKM', null, null, '-72', '<325', 'Eagle Perc-FC;Cheetah(Swan)'},
        new List<String>{'MM', 'H', 'N', '-60', '>325', 'Cheetah-N-HC;Cheetah(Swan)'},
        new List<String>{'MM', 'H', 'N', '-72', '>325', 'Cheetah-N-HC;Cheetah(Swan)'},
        new List<String>{'MM', 'H', null, '-60', '>325', 'Cheetah-P-HC;Cheetah(Swan)'},
        new List<String>{'MM', 'H', null, '-72', '>325', 'Cheetah-P-HC;Cheetah(Swan)'},
        new List<String>{'MM', 'H', 'N', '-60', '<330', 'Eagle Perc-FC;Cheetah(Swan)'},
        new List<String>{'MM', 'H', 'N', '-72', '<330', 'Eagle Perc-FC;Cheetah(Swan)'},
        new List<String>{'MM', 'H', null, '-60', '<330', 'Eagle Perc-FC;Cheetah(Swan)'},
        new List<String>{'MM', 'H', null, '-72', '<330', 'Eagle Perc-FC;Cheetah(Swan)'},
        new List<String>{'MM', null, 'N', '-60', '>320', 'Cheetah-N-HC;Cheetah(Swan)'},
        new List<String>{'MM', null, 'N', '-72', '>320', 'Cheetah-N-HC;Cheetah(Swan)'},
        new List<String>{'MM', null, null, '-60', '>320', 'Cheetah-P-HC;Cheetah(Swan)'},
        new List<String>{'MM', null, null, '-72', '>320', 'Cheetah-P-HC;Cheetah(Swan)'},
        new List<String>{'MM', null, 'N', '-60', '<325', 'Eagle Perc-FC;Cheetah(Swan)'},
        new List<String>{'MM', null, 'N', '-72', '<325', 'Eagle Perc-FC;Cheetah(Swan)'},
        new List<String>{'MM', null, null, '-60', '<325', 'Eagle Perc-FC;Cheetah(Swan)'},
        new List<String>{'MM', null, null, '-72', '<325', 'Eagle Perc-FC;Cheetah(Swan)'}
    };
}