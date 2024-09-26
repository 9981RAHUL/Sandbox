/**
* @description       : Updating the ownership time by different teams
* @author            : Ajitesh Singh
* @group             : 
* @last modified on  : 16-12-2021
* @last modified by  : Avinash
* Modifications Log 
* Ver   Date         Author          Modification
* 1.0   12-02-2020   Ajitesh Singh   Initial Version
**/
trigger CaseTrigger on Case (before update,after insert,before insert, after update) {
    
    if(trigger.isInsert && trigger.isbefore)
    { 
        System.debug('Before insert Trigger ');
        if(trigger.new[0].Origin == 'Email')
        {
            System.debug('Customer_Response_Status__c '+trigger.new[0].Customer_Response_Status__c);
            list<case> listcase=[select id from case where Email__c =: trigger.new[0].SuppliedEmail and status = 'Open' and Origin = 'Email' Order by CreatedDate desc limit 1 ];
            System.debug('cases>> '+listcase);
            
            //need to change to index field email__c where order by createdate desc limit 1
            
            if(listcase.size()>0)
                
            {
                set<id> idlist =new set<id>();
                for(case tempcase:listcase)
                {
                    idlist.add(tempcase.id);
                }
                list<EmailMessage> emailMessageList = [SELECT Id, ParentId, Subject, Headers, FromAddress, ToAddress, 
                                                       Status FROM EmailMessage where ParentId in: idlist ];
                if(emailMessageList.size() >0 )
                {
                    try{
                        String subject = emailMessageList[0].Subject;
                        EmailMessage insetEmailObj=new EmailMessage();
                        insetEmailObj.parentId=emailMessageList[0].parentId;
                        insetEmailObj.Subject=emailMessageList[0].Subject;
                        insetEmailObj.TextBody=trigger.new[0].Description;
                        insetEmailObj.FromAddress=trigger.new[0].SuppliedEmail;
                        insetEmailObj.ToAddress=emailMessageList[0].ToAddress;
                    }catch(dmlException e){
                        System.debug('getCause '+e.getCause());
                        System.debug('getLineNumber '+e.getLineNumber());
                        System.debug('getMessage '+e.getMessage());
                    }
                    
                }
            }
        }
    }
    
    if(trigger.isInsert && trigger.isafter)
    {
        System.debug('after insert Trigger ');
        
    }
    
    if(trigger.isupdate)
    {
        String CLOSED_CASE = 'Closed';
        String RESOLVED_CASE = 'Resolved';
        if(Trigger.isBefore && Trigger.isUpdate){
            // Updating timestamp for each department when ownership is taken
            List<Case> timeStampUpdateCases = new List<Case>();
            for(Case tempCase : Trigger.new){
                tempCase.Email__c = tempCase.SuppliedEmail;
                system.debug('trigger is update 70>>'+tempCase.AWB_No__c);

                if(Trigger.oldMap.get(tempCase.Id).OwnerId.getSobjectType() != User.sobjectType && tempCase.OwnerId.getSobjectType() == User.sobjectType ){
                    timeStampUpdateCases.add(tempCase);
                   system.debug('trigger is update 74>>'+tempCase.AWB_No__c);

                }
                
            }
            
            if(timeStampUpdateCases.size()>0)
                CaseTriggerHandler.updateTimeStamp(timeStampUpdateCases, Trigger.oldMap);
            
            // Calculating Resolved cases
            List<Case> resolvedCases = new List<Case>();
            for(Case tempCase : Trigger.new){
             system.debug('trigger is update 86>>'+tempCase.AWB_No__c);

                if((Trigger.oldMap.get(tempCase.Id).OwnerId.getSobjectType() == User.sobjectType && tempCase.OwnerId.getSobjectType() != User.sobjectType) || (Trigger.oldMap.get(tempCase.Id).OwnerId.getSobjectType() == User.sobjectType && Trigger.oldMap.get(tempCase.Id).Status != tempCase.Status && (tempCase.Status == CLOSED_CASE || tempCase.Status == RESOLVED_CASE ) )){
                    resolvedCases.add(tempCase);
                    system.debug('trigger is update 90>>'+tempCase.AWB_No__c);
                }
            }
            
            if(resolvedCases.size()>0)
                CaseTriggerHandler.createResolvedCase(resolvedCases, Trigger.oldMap);
            
            
            //Set counter days on partcular cases with specified bucket values
            List<Case> counterCases = new List<Case>();
            Map<String, Double> counterMap = new Map<String, Double>();
            Double maxCounter = 0;
            for(Bucket_Wise_Counter__mdt tempBucketCounter : [SELECT MasterLabel, No_Of_Days__c FROM Bucket_Wise_Counter__mdt]){
                if(maxCounter < tempBucketCounter.No_Of_Days__c){
                    maxCounter = tempBucketCounter.No_Of_Days__c;
                }
                counterMap.put(tempBucketCounter.MasterLabel, tempBucketCounter.No_Of_Days__c);
            }
            for(Case tempCase : Trigger.new){
                if(Trigger.oldMap.get(tempCase.Id).Bucket__c != tempCase.Bucket__c && counterMap.containsKey(tempCase.Bucket__c)){
                    counterCases.add(tempCase);
                          system.debug('trigger is update 111>>'+tempCase.AWB_No__c);

                }
                     system.debug('trigger is update 114>>'+tempCase.AWB_No__c);

            }
            
            if(counterCases.size()>0)
                CaseTriggerHandler.setCounterOnCase(counterCases, counterMap, maxCounter);
            
            for(Case tempCase : Trigger.new){
                if(tempCase.Bucket__c == 'Re Open' && (trigger.oldMap.get(tempCase.Id).Bucket__c <> tempCase.Bucket__c))
                {
                    tempCase.Incoming_AWB_Number__c =null;
                    tempcase.Incoming_Courier_Agency__c = null;
                    tempCase.Inward_Courier_Name__c = null;
                    tempCase.Inward_Receiving_Date__c = null;
                    tempCase.Outward_Courier_Name__c = null;
                    tempCase.Outward_Ticket_receiving_Date__c =null;
                    tempcase.India_Post_AWB_No__c = null;
                    tempCase.AWB__c = null;
                    tempCase.AWB_No__c = null;
                    tempCase.Courier_Partner_Name__c = null;
                    tempCase.SR_Order__C = null;
                    
                }
            }
            
            system.debug('trigger is update 128>>'+trigger.new[0].AWB_No__c);
            
        }
        
        // F1 api callout and controller for Sending Case data from Boult to F1 Smart        
        if(Trigger.isafter && Trigger.isUpdate){
            System.debug('isafter '+Trigger.isafter + ' Trigger.isUpdate '+Trigger.isUpdate);
            system.debug('triggerNew>>'+trigger.new[0]);
            
            Set<Id> caseIds =new Set<Id>();
            //List<id> caseIds = new List<id>();
            for (Case cs : trigger.new){
                if(cs.Origin == 'F1' && (cs.Bucket__c =='Serviceable/Shipped' || cs.Bucket__c =='Delivered')){
                    // caseIds.add(cs.Id); 
                    caseIds.add(cs.Id);
                   // F1Apicallout.F1caseupdation(cs.Id);
                }
            }
            
            if(!caseIds.isEmpty()){
                F1Apicallout.F1caseupdation(caseIds);
            }
            
            
            
        }
        system.debug('trigger is update 146 >>'+trigger.new[0].AWB_No__c);
    }
    
    if(Trigger.isAfter && Trigger.isInsert  ){//&& CaseTriggerHandler.firstRun
        //CaseTriggerHandler.firstRun = false;
        Boolean webRun = true;
        CaseTriggerHandler.sendWhatsAppOnF1CaseInsert(trigger.New);
       // CaseTriggerHandler.sendWhatsAppOnWebCaseInsert(trigger.New, webRun);
        CaseTriggerHandler.updateBucketStatus(Trigger.newMap.keySet());
        CaseTriggerHandler.SendEmailonCase(Trigger.newMap.keySet());
        CaseTriggerhandler.customerAutoTagging(Trigger.newMap.keySet());
        
    }
    
    
    
    List<whatsAppData__mdt> Wamdt = [Select DeveloperName, MasterLabel, Value__c, Enable__c from whatsAppData__mdt where DeveloperName= 'WASwitch' limit 1];
    List<SMSData__mdt> SMSdata = [Select DeveloperName, MasterLabel, Value__c, Enable__c from SMSData__mdt where DeveloperName= 'SMSSwitch' limit 1];
    System.debug('firstRun '+CaseTriggerHandler.firstRun);
    System.debug('isAfter '+Trigger.isAfter);
    System.debug('isUpdate '+Trigger.isUpdate);
    
    
    if(Trigger.isAfter && Trigger.isUpdate && CaseTriggerHandler.firstRun  ){
        system.debug('line no 178>>'+trigger.new[0].AWB_No__c);
        System.debug('isUpdate firstRun '+CaseTriggerHandler.firstRun);
        CaseTriggerHandler.firstRun = false;
        for( Case c : Trigger.New ){
            if( c.Origin == 'F1' ){
                CaseTriggerHandler.sendEmailForF1BucketUpdate( trigger.New, trigger.OldMap );
            }
        }
        
        if( Wamdt.size() > 0 && Wamdt[0].Enable__c ){
            system.debug('line no 188>>'+trigger.new[0].AWB_No__c);
            CaseTriggerHandler.sendWhatsAppOnCaseUpdate(trigger.New, trigger.OldMap);
        }
        if(SMSdata.size()>0 && SMSdata[0].Enable__c){
            CaseTriggerHandler.sendSMSOnCaseUpdate(trigger.New, trigger.OldMap);
        }
		List<Case> caseList = [SELECT Id, Product__c, Product__r.Name, Bucket__c, Email__c, Origin, Courier_Partner_Name__c 
                               FROM Case 
                               WHERE Id IN :Trigger.newMap.keySet()];         
        CaseTriggerHandler.sendEmailForBucketUpdate(caseList, trigger.OldMap);
    } 
    
    
    
    if(Trigger.isAfter && Trigger.isInsert){
        System.debug('isInsert firstRun '+CaseTriggerHandler.firstRun);
        list<case> caseList = new list<case> ();
        for( Case c : Trigger.New ){
            system.debug('TrigeeerNew'+ c.Email__c);
            if( c.Origin == 'F1' ){
                caseList.add(c);
                
            }
        }
        if(caseList.size()>0){
            CaseTriggerHandler.sendEmailForF1BucketUpdate( caseList, trigger.OldMap );
        }
    }
    
    if(Trigger.isbefore && Trigger.isUpdate){
        
        System.debug('isbefore '+Trigger.isbefore + ' Trigger.isUpdate '+Trigger.isUpdate);
        //  CaseTriggerHandler.firstRun = false;
        CaseTriggerHandler.ReopenCountMethod(trigger.New, trigger.OldMap);
        
        
    } 
    // disposition input date field update 
    if(Trigger.isbefore && Trigger.isUpdate){
        for(case cs :trigger.new){
            System.debug('Check Vslue---'+cs.AWB_No__c);
            if(cs.Disposition_Input__c != trigger.OldMap.get(cs.Id).Disposition_Input__c){
                cs.Disposition_Input_Date__c = Date.today();
                
            }
            
            /* else if(cs.Bucket__c =='Re Open'){
// caseIds.add(cs.Id); 
//F1Apicallout.F1caseupdation(cs.Id);
ReOpenData.NewReOpenDataMethod(cs.Id);
}*/
        }
    } 
    
    if(Trigger.isafter  && Trigger.isUpdate){        
        for (Case cs1 : trigger.new){
            if(trigger.oldMap.get(cs1.Id).Bucket__c != 'Re Open' && trigger.newMap.get(cs1.Id).Bucket__c == 'Re Open' ){
                ReOpenData.NewReOpenDataMethod(cs1.Id);                   
            }
            // CPCaseTriggerHandler.sendEmailToAdmin(Trigger.New, Trigger.OldMap); 
            break;
        }
    }
    
    /*if( Trigger.isBefore && ( Trigger.isInsert || Trigger.isUpdate ) ){
        CaseTriggerHandler.warehouseUpdate( Trigger.New, trigger.OldMap );
    }*/
   
    if(Trigger.isBefore &&  Trigger.isInsert){
        system.debug('new map'+trigger.newMap);
        CaseTriggerHandler.subBucketFieldUpdate(Trigger.New,Null);
    }else If(Trigger.isBefore &&  Trigger.isUpdate){
         CaseTriggerHandler.subBucketFieldUpdate(Trigger.New, trigger.OldMap );
    }  

    if(Trigger.isBefore && Trigger.isUpdate){
    	CaseTriggerHandler.sendEmailFieldUpdate(Trigger.New, Trigger.OldMap); 
       
    }
}