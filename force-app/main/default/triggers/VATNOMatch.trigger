trigger VATNOMatch on Account (before insert,before update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert||Trigger.isUpdate){
            
            for(Account acc : trigger.new){
                /*
                system.debug('CreatedDate>-----------------'+acc.CreatedDate);
                Datetime datetime1 = acc.CreatedDate;
                Date dateCread = datetime1.dateGmt();
                System.debug('dateCread>----------------------'+dateCread.format());
                Date dateMatch = Date.newInstance(2019,12,24);
                System.debug('dateMatch>----------------------'+dateMatch.format());
                if(dateCread.format()>dateMatch.format()){
*/                 Date dateCread;
                if(acc.CreatedDate!=null){
                dateCread = acc.CreatedDate.dateGmt();
                }else{
                     dateCread = datetime.now().dateGmt();
                }
                system.debug('1'+Date.newInstance(2019,4,24));
                if(dateCread>Date.newInstance(2019,12,24)){
                String accVat = acc.VAT_NO__c;
                if(accVat!=null){
                if(acc.Country__c == 'Austria'){
                    if(accVat.length()!=11){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        String mat = accVat.substring(3);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('ATU')||accVat.length()!=11||!vat){
                            system.debug('11111');
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Bulgaria'){
                    if(accVat.length()!=11&&accVat.length()!=12){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        String mat = accVat.substring(2);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('BG')||(accVat.length()<11||accVat.length()>12)||!vat){
                            system.debug('11111');
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Croatia'){
                    if(accVat.length()!=13){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        String mat = accVat.substring(2);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('HR')||accVat.length()!=13||!vat){
                            system.debug('11111');
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Cyprus'){
                    if(accVat.length()!=11){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        String mat = accVat.substring(2,10);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        String mats = accVat.substring(10);
                        Boolean vats = VATNOMatchNumber.isNumericzidais(mats);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('CY')||accVat.length()!=11||!vat||!vats){
                            system.debug('11111');
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Czech Republic'){
                    if(accVat.length()!=10&&accVat.length()!=11&&accVat.length()!=12){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('CZ')||(accVat.length()<10||accVat.length()>12)||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Denmark'){
                    if(accVat.length()!=10){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('DK')||accVat.length()!=10||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Estonia'){
                    if(accVat.length()!=11){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('EE')||accVat.length()!=11||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Finland'){
                    if(accVat.length()!=10){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('FI')||accVat.length()!=10||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                    /*
                if(acc.Country__c == 'Germany'){
                    if(accVat.length()!=11){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('DE')||accVat.length()!=11||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
*/
                if(acc.Country__c == 'Hungary'){
                    if(accVat.length()!=10){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('HU')||accVat.length()!=10||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Latvia'){
                    if(accVat.length()!=13){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('LV')||accVat.length()!=13||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Lithuania'){
                    if(accVat.length()!=11&&accVat.length()!=14){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('LT')||(accVat.length()!=11&&accVat.length()!=14)||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Luxembourg'){
                    if(accVat.length()!=10){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('LU')||accVat.length()!=10||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Malta'){
                    if(accVat.length()!=10){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('MT')||accVat.length()!=10||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Romania'){
                    if(accVat.length()!=10){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('RO')||accVat.length()!=10||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Slovakia'){
                    if(accVat.length()!=12){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('SK')||accVat.length()!=12||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Slovenia'){
                    if(accVat.length()!=10){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('SI')||accVat.length()!=10||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Poland'){
                    if(accVat.length()!=12){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('PL')||accVat.length()!=12||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Portugal'){
                    if(accVat.length()!=11){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('PT')||accVat.length()!=11||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Italy'){
                    if(accVat.length()!=13){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('IT')||accVat.length()!=13||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Belgium'){
                    if(accVat.length()!=12){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2,10);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('BE')||accVat.length()!=12||!vat){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Netherlands'){
                    if(accVat.length()!=14){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mab = accVat.substring(11,12);
                        String mat = accVat.substring(2,11);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('NL')||accVat.length()!=14||!vat||mab!='B'){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Ireland'){
                    if(accVat.length()!=11){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2,9);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        String mas = accVat.substring(9);
                        Boolean vas = VATNOMatchNumber.isNumericzidais(mas);
                        if(!accVat.startsWith('IE')||accVat.length()!=11||!vat||!vas){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Spain'){
                    if(accVat.length()!=11){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(3,10);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        String mas = accVat.substring(2,3);
                        Boolean vas = VATNOMatchNumber.isNumericzidais(mas);
                        if(!accVat.startsWith('ES')||accVat.length()!=11||!vat||!vas){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'Sweden'){
                    if(accVat.length()!=14){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                    }else{
                        
                        
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('SE')||accVat.length()!=14||!vat||accVat.substring(12,13)!='0'){
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        }
                    }
                }
                if(acc.Country__c == 'United Kingdom'){
                    if(accVat.length()!=7&&accVat.length()!=13&&accVat.length()!=17&&accVat.length()!=11&&accVat.length()!=14){
                        acc.addError('Message: Refer Tab:Check VAT NO rules.');
                        system.debug('1111');
                    }
                    if(accVat.length()==7){
                        if(accVat.startsWith('GBGD')){
                            String mat = accVat.substring(4);
                            Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                            if(!vat||(Integer.valueOf(mat)<-1||Integer.valueOf(mat)>500)){
                                acc.addError('Message: Refer Tab:Check VAT NO rules.');
                                system.debug('1111');
                            }
                        }
                        if(accVat.startsWith('GBHA')){
                            String mat = accVat.substring(4);
                            Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                            if(accVat.length()!=7||!vat||(Integer.valueOf(mat)<499||Integer.valueOf(mat)>1000)){
                                acc.addError('Message: Refer Tab:Check VAT NO rules.');
                                system.debug('1111');
                            }
                        }
                        if(!accVat.startsWith('GBHA')&&!accVat.startsWith('GBGD')){
                            acc.addError('Message: Refer Tab:Check VAT NO rules.');
                            system.debug('1111');
                        }
                    }
                    if(accVat.length()==11){
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        
                        if(!accVat.startsWith('GB')||!vat){
                            
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.'); 
                        }
                    }
                    if(accVat.length()==14){
                        String mat = accVat.substring(2);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        
                        if(!accVat.startsWith('GB')||!vat){
                            
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.'); 
                        }
                    }
                    
                    
                    if(accVat.length()==13){
                        String mat = accVat.substring(2,5);
                        system.debug('mat'+mat);
                        Boolean vat = VATNOMatchNumber.isNumericzidai(mat);
                        system.debug('vat'+vat);
                        
                        String matT = accVat.substring(5,6);
                        system.debug('mat'+mat);
                        Boolean vatT = VATNOMatchNumber.isNumericzidaisds(matT);
                        system.debug('vat'+vat);
                        
                        String matTh = accVat.substring(6,10);
                        system.debug('mat'+mat);
                        Boolean vatTh = VATNOMatchNumber.isNumericzidai(matTh);
                        system.debug('vat'+vat);
                        
                        String matTF = accVat.substring(10,11);
                        system.debug('mat'+mat);
                        Boolean vatTF = VATNOMatchNumber.isNumericzidaisds(matTF);
                        system.debug('vat'+vat);
                        
                        String matTFi = accVat.substring(11);
                        system.debug('mat'+mat);
                        Boolean vatTFi = VATNOMatchNumber.isNumericzidai(matTFi);
                        system.debug('vat'+vat);
                        if(!accVat.startsWith('GB')||!vat||!vatT||!vatTh||!vatTF||!vatTFi){
                            
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.'); 
                        }
                    }
                    if(accVat.length()==17){
                        String mats = accVat.substring(2,5);
                        system.debug('mat'+mats);
                        Boolean vats = VATNOMatchNumber.isNumericzidai(mats);
                        system.debug('vat'+vats);
                        
                        String matTs = accVat.substring(5,6);
                        system.debug('mat'+matTs);
                        Boolean vatTs = VATNOMatchNumber.isNumericzidaisds(matTs);
                        system.debug('vat'+vatTs);
                        
                        String matThs = accVat.substring(6,9);
                        system.debug('mat'+matThs);
                        Boolean vatThs = VATNOMatchNumber.isNumericzidai(matThs);
                        system.debug('vat'+vatThs);
                        
                        String matTFs = accVat.substring(9,10);
                        system.debug('mat'+matTFs);
                        Boolean vatTFs = VATNOMatchNumber.isNumericzidaisds(matTFs);
                        system.debug('vat'+vatTFs);
                        
                        String matTFis = accVat.substring(10,13);
                        system.debug('mat'+matTFis);
                        Boolean vatTFis = VATNOMatchNumber.isNumericzidai(matTFis);
                        system.debug('vat'+vatTFis);
                        
                        String matTss = accVat.substring(13,14);
                        system.debug('mat'+matTss);
                        Boolean vatTss = VATNOMatchNumber.isNumericzidaisds(matTss);
                        system.debug('vat'+vatTss);
                        
                        String matTses = accVat.substring(14,17);
                        system.debug('mat'+matTses);
                        Boolean vatTses = VATNOMatchNumber.isNumericzidai(matTses);
                        system.debug('vat'+vatTses);
                        if(!accVat.startsWith('GB')||!vats||!vatTs||!vatThs||!vatTFs||!vatTFis||!vatTss||!vatTses){
                            system.debug('vats'+vats);
                            system.debug('vats'+vatTs);
                            system.debug('vats'+vatThs);
                            system.debug('vats'+vatTFs);
                            system.debug('vats'+vatTFis);
                            system.debug('vats'+vatTss);
                            system.debug('vats'+vatTses);
                            system.debug(accVat.length());
                            acc.addError('Message: Refer Tab:Check VAT NO rules.'); 
                        }
                    }   
                }
            }
            }
            }
        }
    }
}