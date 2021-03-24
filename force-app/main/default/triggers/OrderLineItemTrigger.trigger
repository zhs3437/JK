trigger OrderLineItemTrigger on OrderItem (before insert, before update,after insert,after update) {
    
    // neo
    if (OpportunityLineItemGrossMarginHandler.skipTrigger) return;
    
    // Snake
    if (Trigger.isBefore) {
        // Snake
        OpportunityLineItemGrossMarginHandler handler;
        // for(Orderitem ol:trigger.new){
        //     system.debug('20200825:'+ol.Product_Name__c);
        //         //Connector
        //     if(ol.product_name__c.Startswith('JK03M')||ol.product_name__c.Startswith('JK06M')||ol.product_name__c.Startswith('MC4')||ol.product_name__c.Startswith('JKT')){
        //         ol.Product_Type__C ='Connector';
        //         ol.Main_Type__c = 'Connector';
        //     }
        //     //New Tiger
        //     else if((ol.product_name__c.Startswith('JKM')||ol.product_name__c.Startswith('MM'))&&ol.product_name__c.contains('LM')&&!ol.product_name__c.contains('N')){
        //         ol.Main_Type__c = 'Tiger';
        //         if(ol.product_name__c.contains('BD')||ol.product_name__c.contains('BG')){
        //             ol.Product_Type__C ='New Tiger-P-DG';
        //         }else if(ol.product_name__c.contains('T')||ol.product_name__c.contains('BB')){
        //             ol.Product_Type__C ='New Tiger-P-TB';
        //         }else{
        //             ol.Product_Type__C ='New Tiger-P';
        //         }
        //     }
        //     //Smart
        //     else if(ol.product_name__c.Startswith('JKMS')||ol.product_name__c.Startswith('SMM')){
        //         ol.Main_Type__c = 'Smart';
        //         if(ol.product_name__c.contains('TI')){
        //             ol.Product_Type__C ='Smart-TI';
        //         }else if(ol.product_name__c.contains('TG')){
        //             ol.Product_Type__C ='Smart-TG';
        //         }else if(ol.product_name__c.contains('MX')){
        //             ol.Product_Type__C ='Smart-MX';
        //         }else{
        //             ol.Product_Type__C ='Smart';
        //         }
        //     }
            
        //     //Tiger Pro
        //     else if(ol.product_name__c.Startswith('JKM')&& !ol.product_name__c.contains('JKMS')&&ol.product_name__c.contains('L4')){
        //         ol.Main_Type__c = 'Tiger Pro';
        //         if(ol.product_name__c.contains('N')){
        //             if(ol.product_name__c.contains('BD')){
        //                 ol.Product_Type__C ='Tiger Pro-N-DG';
        //             }else if(ol.product_name__c.contains('-D')){
        //                 ol.Product_Type__C ='Tiger Pro-N-SG';
        //             }else if(ol.product_name__c.contains('-T')){
        //                 ol.Product_Type__C ='Tiger Pro-N-TB';
        //             }else{
        //                 ol.Product_Type__C ='Tiger Pro-N';
        //             }
        //         }else if(!ol.product_name__c.contains('N')){
        //             if(ol.product_name__c.contains('BD')){
        //                 ol.Product_Type__C ='Tiger Pro-P-DG';
        //             }else if(ol.product_name__c.contains('-D')){
        //                 ol.Product_Type__C ='Tiger Pro-P-SG';
        //             }else if(ol.product_name__c.contains('-T')){
        //                 ol.Product_Type__C ='Tiger Pro-P-TB';
        //             }else{
        //                 ol.Product_Type__C ='Tiger Pro-P';
        //             }
        //         }
        //     }
        //     else if(ol.product_name__c.Startswith('MM')&&ol.product_name__c.contains('LD')){
        //         ol.Main_Type__c = 'Tiger Pro';
        //         if(ol.product_name__c.contains('N')){
        //             if(ol.product_name__c.contains('BG')){
        //                 ol.Product_Type__C ='Tiger Pro-N-DG';
        //             }else if(ol.product_name__c.contains('MG')){
        //                 ol.Product_Type__C ='Tiger Pro-N-SG';
        //             }else if(ol.product_name__c.contains('BB')){
        //                 ol.Product_Type__C ='Tiger Pro-N-TB';
        //             }else{
        //                 ol.Product_Type__C ='Tiger Pro-N';
        //             }
        //         }else if(!ol.product_name__c.contains('N')){
        //             if(ol.product_name__c.contains('BG')){
        //                 ol.Product_Type__C ='Tiger Pro-P-DG';
        //             }else if(ol.product_name__c.contains('MG')){
        //                 ol.Product_Type__C ='Tiger Pro-P-SG';
        //             }else if(ol.product_name__c.contains('BB')){
        //                 ol.Product_Type__C ='Tiger Pro-P-TB';
        //             }else{
        //                 ol.Product_Type__C ='Tiger Pro-P';
        //             }
        //         }
        //     }

        //     //Tiger
        //     else if(ol.product_name__c.Startswith('JKM')&& !ol.product_name__c.contains('JKMS')&&ol.product_name__c.contains('L3')){
        //         ol.Main_Type__c = 'Tiger';
        //         if(ol.product_name__c.contains('N')){
        //             if(ol.product_name__c.contains('BD')){
        //                 ol.Product_Type__C ='Tiger-N-DG';
        //             }else if(ol.product_name__c.contains('-D')){
        //                 ol.Product_Type__C ='Tiger-N-SG';
        //             }else if(ol.product_name__c.contains('-T')){
        //                 ol.Product_Type__C ='Tiger-N-TB';
        //             }else{
        //                 ol.Product_Type__C ='Tiger-N';
        //             }
        //         }else if(!ol.product_name__c.contains('N')){
        //             if(ol.product_name__c.contains('BD')){
        //                 ol.Product_Type__C ='Tiger-P-DG';
        //             }else if(ol.product_name__c.contains('-D')){
        //                 ol.Product_Type__C ='Tiger-P-SG';
        //             }else if(ol.product_name__c.contains('-T')){
        //                 ol.Product_Type__C ='Tiger-P-TB';
        //             }else{
        //                 ol.Product_Type__C ='Tiger-P';
        //             }
        //         }
        //     }
        //     else if(ol.product_name__c.Startswith('MM')&&ol.product_name__c.contains('LC')){
        //         ol.Main_Type__c = 'Tiger';
        //         if(ol.product_name__c.contains('N')){
        //             if(ol.product_name__c.contains('BG')){
        //                 ol.Product_Type__C ='Tiger-N-DG';
        //             }else if(ol.product_name__c.contains('MG')){
        //                 ol.Product_Type__C ='Tiger-N-SG';
        //             }else if(ol.product_name__c.contains('BB')){
        //                 ol.Product_Type__C ='Tiger-N-TB';
        //             }else{
        //                 ol.Product_Type__C ='Tiger-N';
        //             }
        //         }else if(!ol.product_name__c.contains('N')){
        //             if(ol.product_name__c.contains('BG')){
        //                 ol.Product_Type__C ='Tiger-P-DG';
        //             }else if(ol.product_name__c.contains('MG')){
        //                 ol.Product_Type__C ='Tiger-P-SG';
        //             }else if(ol.product_name__c.contains('BB')){
        //                 ol.Product_Type__C ='Tiger-P-TB';
        //             }else{
        //                 ol.Product_Type__C ='Tiger-P';
        //             }
        //         }
        //     }
        //     else if(ol.product_name__c.contains('JKSM3')){
        //         ol.Main_Type__c = 'Tiger';
        //         system.debug('是老虎型');
        //         ol.Product_Type__C ='Tiger-P';
        //     }
        //     else if(ol.product_name__c.contains('JKSN3')){
        //         ol.Main_Type__c = 'Tiger';
        //         system.debug('是老虎型');
        //         ol.Product_Type__C ='Tiger-N';
        //     }  
            
            
        //     else if(ol.product_name__c.startsWith('JKM') && !ol.product_name__c.contains('JKMS')&&(ol.product_name__c.contains('66')||ol.product_name__c.contains('78'))){
        //         system.debug('ol.product_name__c'+ol.product_name__c);
        //         system.debug('ol.product_name__c'+ol.product_name__c);
        //         ol.Main_Type__c = 'Cheetah(Swan)';
        //         if(ol.product_name__c.contains('N')){
        //             system.debug('ol.product_name__c'+ol.product_name__c);
        //             if(ol.product_name__c.contains('BD')){
        //                 ol.Product_Type__C ='Swan Plus-N-DG';
        //             }else if(ol.product_name__c.contains('-D')){
        //                 ol.Product_Type__C ='Swan Plus-N-SG';
        //             }else if(ol.product_name__c.contains('-T')){
        //                 ol.Product_Type__C ='Swan Plus-N-TB';
        //             }else{
        //                 ol.Product_Type__C ='Cheetah Plus-N';
        //             }
        //         }else if(!ol.product_name__c.contains('N')){
        //             if(ol.product_name__c.contains('BD')){
        //                 ol.Product_Type__C ='Swan Plus-P-DG';
        //             }else if(ol.product_name__c.contains('-D')){
        //                 ol.Product_Type__C ='Swan Plus-P-SG';
        //             }else if(ol.product_name__c.contains('-T')){
        //                 ol.Product_Type__C ='Swan Plus-P-TB';
        //             }else{
        //                 ol.Product_Type__C ='Cheetah Plus-P';
        //             }
        //         }
        //     }
        //     else if(ol.product_name__c.startsWith('MM') &&(ol.product_name__c.contains('66')||ol.product_name__c.contains('78'))){
        //         system.debug('ol.product_name__c'+ol.product_name__c);
        //         system.debug('ol.product_name__c'+ol.product_name__c);
        //         ol.Main_Type__c = 'Cheetah(Swan)';
        //         if(ol.product_name__c.contains('N')){
        //             system.debug('ol.product_name__c'+ol.product_name__c);
        //             if(ol.product_name__c.contains('BG')){
        //                 ol.Product_Type__C ='Swan Plus-N-DG';
        //             }else if(ol.product_name__c.contains('BB')){
        //                 ol.Product_Type__C ='Swan Plus-N-TB';
        //             }else if(ol.product_name__c.contains('MG')){
        //                 ol.Product_Type__C ='Swan Plus-N-SG';
        //             }else{
        //                 ol.Product_Type__C ='Cheetah Plus-N';
        //             }
        //         }else if(!ol.product_name__c.contains('N')){
        //             if(ol.product_name__c.contains('BG')){
        //                 ol.Product_Type__C ='Swan Plus-P-DG';
        //             }else if(ol.product_name__c.contains('BB')){
        //                 ol.Product_Type__C ='Swan Plus-P-TB';
        //             }else if(ol.product_name__c.contains('MG')){
        //                 ol.Product_Type__C ='Swan Plus-P-SG';
        //             }else{
        //                 ol.Product_Type__C ='Cheetah Plus-P';
        //             }
        //         }
        //     }
            
            
        //     else if(ol.product_name__c.contains('JKM')&& (ol.product_name__c.contains('BDVP')||ol.product_name__c.contains('BD')||ol.product_name__c.contains('-T')||ol.product_name__c.contains('-D'))){
        //         system.debug('ol.product_name__c'+ol.product_name__c);
        //         ol.Main_Type__c = 'Cheetah(Swan)';
        //         if(ol.product_name__c.contains('N')){
        //             if(ol.product_name__c.contains('BD')){
        //                 ol.Product_Type__C ='Swan-N-DG';
        //             }else if(ol.product_name__c.contains('-D')){
        //                 ol.Product_Type__C ='Swan-N-SG';
        //             }else if(ol.product_name__c.contains('-T')){
        //                 ol.Product_Type__C ='Swan-N-TB';
        //             }
        //         }else if(!ol.product_name__c.contains('N')){
        //             if(ol.product_name__c.contains('BDVP')){
        //                 ol.Product_Type__C ='Swan-P-DG';
        //             }else if(ol.product_name__c.contains('BD')){
        //                 system.debug('junjun');
        //                 ol.Product_Type__C ='Swan-N-DG';
        //             }else if(ol.product_name__c.contains('-D')){
        //                 ol.Product_Type__C ='Swan-P-SG';
        //             }else if(ol.product_name__c.contains('-T')){
        //                 ol.Product_Type__C ='Swan-P-TB';
        //             }
        //         }
        //     }
        //     else if(ol.product_name__c.contains('MM')&& (ol.product_name__c.contains('BG')||ol.product_name__c.contains('BB')||ol.product_name__c.contains('MG'))){
        //         system.debug('ol.product_name__c'+ol.product_name__c);
        //         ol.Main_Type__c = 'Cheetah(Swan)';
        //         if(ol.product_name__c.contains('N')){
        //             if(ol.product_name__c.contains('BG')){
        //                 ol.Product_Type__C ='Swan-N-DG';
        //             }else if(ol.product_name__c.contains('BB')){
        //                 ol.Product_Type__C ='Swan-N-TB';
        //             }else if(ol.product_name__c.contains('MG')){
        //                 ol.Product_Type__C ='Swan-N-SG';
        //             }
        //         }else if(!ol.product_name__c.contains('N')){
        //             if(ol.product_name__c.contains('BG')){
        //                 ol.Product_Type__C ='Swan-P-DG';
        //             }else if(ol.product_name__c.contains('BB')){
        //                 system.debug('junjun');
        //                 ol.Product_Type__C ='Swan-P-TB';
        //             }else if(ol.product_name__c.contains('MG')){
        //                 ol.Product_Type__C ='Swan-P-SG';
        //             }
        //         }
        //     }
            

        //     else if((ol.product_name__c.contains('JKM')||ol.product_name__c.Startswith('MM'))&& ol.product_name__c.contains('P-')){
        //         ol.Main_Type__c = 'Cheetah(Swan)';
        //         if(ol.product_name__c.contains('H')){
        //             system.debug('111111');
        //             ol.Product_Type__C ='Eagle Poly-HC';
        //         }else if(!ol.product_name__c.contains('H')){
        //             system.debug('22222');
        //             ol.Product_Type__C ='Eagle Poly-FC';
        //         }
        //     }
            
        
        //     else if(ol.product_name__c.contains('JKM') && !ol.product_name__c.contains('JKMS')){
        //         ol.Main_Type__c = 'Cheetah(Swan)';
        //         integer MW =Integer.valueOf(ol.product_name__c.substring(3, 6));
        //         if(ol.product_name__c.contains('H')){
        //             if(ol.product_name__c.contains('N')){
        //                 if(ol.product_name__c.contains('-60')){
        //                     if(MW>=325){
        //                         ol.Product_Type__C ='Cheetah-N-HC';
        //                     }else{
        //                         ol.Product_Type__C ='Eagle Perc-HC';
        //                     }
        //                 }
        //                 if(ol.product_name__c.contains('-72')){
        //                     if(MW>=395){
        //                         ol.Product_Type__C ='Cheetah-N-HC';
        //                     }else{
        //                         ol.Product_Type__C ='Eagle Perc-HC';
        //                     }
        //                 }  
        //             }else if(!ol.product_name__c.contains('N')){
        //                 if(ol.product_name__c.contains('-60')){
        //                     if(MW>=325){
        //                         ol.Product_Type__C ='Cheetah-P-HC';
        //                     }else{
        //                         ol.Product_Type__C ='Eagle Perc-HC';
        //                     }
        //                 }
        //                 if(ol.product_name__c.contains('-72')){
        //                     if(MW>=395){
        //                         ol.Product_Type__C ='Cheetah-P-HC';
        //                     }else{
        //                         ol.Product_Type__C ='Eagle Perc-HC';  
        //                     }
        //                 } 
        //             }
                    
        //         }else if(!ol.product_name__c.contains('H')){
        //             if(ol.product_name__c.contains('N')){
        //                 if(ol.product_name__c.contains('-60')){
        //                     if(MW>=320){
        //                         ol.Product_Type__C ='Cheetah-N-FC';
        //                     }else{
        //                         ol.Product_Type__C ='Eagle Perc-FC';
        //                     }
        //                 }
        //                 if(ol.product_name__c.contains('-72')){
        //                     if(MW>=390){
        //                         ol.Product_Type__C ='Cheetah-N-FC';
        //                     }else{
        //                         ol.Product_Type__C ='Eagle Perc-FC';
        //                     }
        //                 }  
        //             }else if(!ol.product_name__c.contains('N')){
        //                 system.debug('junjunV3');
        //                 if(ol.product_name__c.contains('-60')){
        //                     if(MW>=320){
        //                         ol.Product_Type__C ='Cheetah-P-FC';
        //                     }else{
        //                         ol.Product_Type__C ='Eagle Perc-FC';
        //                     }
        //                 }
        //                 if(ol.product_name__c.contains('-72')){
        //                     system.debug('junjunV4');
        //                     if(MW>=390){
        //                         system.debug('junjunV5');
        //                         ol.Product_Type__C ='Cheetah-P-FC';
        //                     }else{
        //                         system.debug('junjunV2');
        //                         ol.Product_Type__C ='Eagle Perc-FC';  
        //                     }
        //                 } 
        //             }
        //         }
                
        //     }
        //     else if(ol.product_name__c.Startswith('MM')){
        //         ol.Main_Type__c = 'Cheetah(Swan)';
        //         integer MW =Integer.valueOf(ol.product_name__c.substring(2, 5));
        //         if(ol.product_name__c.contains('H')){
        //             if(ol.product_name__c.contains('N')){
        //                 if(ol.product_name__c.contains('-60')){
        //                     if(MW>=325){
        //                         ol.Product_Type__C ='Cheetah-N-HC';
        //                     }else{
        //                         ol.Product_Type__C ='Eagle Perc-HC';
        //                     }
        //                 }
        //                 if(ol.product_name__c.contains('-72')){
        //                     if(MW>=395){
        //                         ol.Product_Type__C ='Cheetah-N-HC';
        //                     }else{
        //                         ol.Product_Type__C ='Eagle Perc-HC';
        //                     }
        //                 }  
        //             }else if(!ol.product_name__c.contains('N')){
        //                 if(ol.product_name__c.contains('-60')){
        //                     if(MW>=325){
        //                         ol.Product_Type__C ='Cheetah-P-HC';
        //                     }else{
        //                         ol.Product_Type__C ='Eagle Perc-HC';
        //                     }
        //                 }
        //                 if(ol.product_name__c.contains('-72')){
        //                     if(MW>=395){
        //                         ol.Product_Type__C ='Cheetah-P-HC';
        //                     }else{
        //                         ol.Product_Type__C ='Eagle Perc-HC';  
        //                     }
        //                 } 
        //             }
                    
        //         }else if(!ol.product_name__c.contains('H')){
        //             if(ol.product_name__c.contains('N')){
        //                 if(ol.product_name__c.contains('-60')){
        //                     if(MW>=320){
        //                         ol.Product_Type__C ='Cheetah-N-FC';
        //                     }else{
        //                         ol.Product_Type__C ='Eagle Perc-FC';
        //                     }
        //                 }
        //                 if(ol.product_name__c.contains('-72')){
        //                     if(MW>=390){
        //                         ol.Product_Type__C ='Cheetah-N-FC';
        //                     }else{
        //                         ol.Product_Type__C ='Eagle Perc-FC';
        //                     }
        //                 }  
        //             }else if(!ol.product_name__c.contains('N')){
        //                 system.debug('junjunV3');
        //                 if(ol.product_name__c.contains('-60')){
        //                     if(MW>=320){
        //                         ol.Product_Type__C ='Cheetah-P-FC';
        //                     }else{
        //                         ol.Product_Type__C ='Eagle Perc-FC';
        //                     }
        //                 }
        //                 if(ol.product_name__c.contains('-72')){
        //                     system.debug('junjunV4');
        //                     if(MW>=390){
        //                         system.debug('junjunV5');
        //                         ol.Product_Type__C ='Cheetah-P-FC';
        //                     }else{
        //                         system.debug('junjunV2');
        //                         ol.Product_Type__C ='Eagle Perc-FC';  
        //                     }
        //                 } 
        //             }
        //         }
                
        //     }
        //     else{
        //             ol.Main_Type__c = 'Cheetah(Swan)';
        //         ol.Product_Type__C ='Cheetah-HC';
        //     }
        // }
        handler = new OpportunityLineItemGrossMarginHandler(Trigger.new);
    }
}