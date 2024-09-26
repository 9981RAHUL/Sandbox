/**
* @description       : Case Trigger Handler 
* @author            : Ajitesh Singh
* @group             : 
* @last modified on  : 18-11-2021
* @last modified by  : Avinash
* Modifications Log 
* Ver   Date         Author                 Modification
* 1.0   12-02-2020   Ajitesh Singh         Initial Version
* 1.1   21-12-2022   Avinash     Modified ()
**/
public class CaseTriggerHandler {
    /**
* @description : Update timestamp when a particular team chose ownership 
* @author Ajitesh Singh | 12-02-2020 
* @param timeStampUpdateCases : List of cases eligible for the functionality
**/
    public static String CRM_AGENTS = 'CRM_Agents';
    public static String INWARD_AGENTS = 'Inward_Agents';
    public static String ORM_AGENTS = 'ORM_Agents';
    public static String OUTWARD_AGENTS = 'Outward_Agents';
    public static String SERVICE_AGENTS = 'Services_Agents';
    public static boolean recursiveTrig = false;
    public static boolean firstRun = true;
    public static boolean webRun;
    /**
* @description 
* @author Ajitesh Singh | 12-09-2020 
* @param timeStampUpdateCases : Case for which time stamp needs to be updated
* @param oldCaseMap : Old Case map to fetch the Queue Name
**/
    public static void updateTimeStamp(List<Case> timeStampUpdateCases,Map<Id, Case> oldCaseMap){
        Map<Id,String> idQueueDevNameMap = new Map<Id,String>();
        for(Group tempGroup : [SELECT Id, DeveloperName  FROM GROUP WHERE DeveloperName =: CRM_AGENTS OR DeveloperName =: INWARD_AGENTS OR DeveloperName =: ORM_AGENTS OR DeveloperName =: OUTWARD_AGENTS OR DeveloperName =: SERVICE_AGENTS]){
            idQueueDevNameMap.put(tempGroup.Id ,tempGroup.DeveloperName);
        }
        for(Case caseRec : timeStampUpdateCases){	
            if(idQueueDevNameMap.containsKey(oldCaseMap.get(caseRec.Id).OwnerId)){
                if(idQueueDevNameMap.get(oldCaseMap.get(caseRec.Id).OwnerId) == CRM_AGENTS && caseRec.CRM_Desk_Receiving__c == null){
                    caseRec.CRM_Desk_Receiving__c = Datetime.now();
                }
                else if(idQueueDevNameMap.get(oldCaseMap.get(caseRec.Id).OwnerId) == INWARD_AGENTS && caseRec.Inward_Receiving_Date__c == null){
                    caseRec.Inward_Receiving_Date__c = Datetime.now();
                }
                else if(idQueueDevNameMap.get(oldCaseMap.get(caseRec.Id).OwnerId) == ORM_AGENTS && caseRec.ORM_Recieving_Date__c == null){
                    caseRec.ORM_Recieving_Date__c = Datetime.now();
                }
                else if(idQueueDevNameMap.get(oldCaseMap.get(caseRec.Id).OwnerId) == SERVICE_AGENTS && caseRec.Service_Desk_Receiving_Date__c == null){
                    caseRec.Service_Desk_Receiving_Date__c = Datetime.now();
                }
                else if(idQueueDevNameMap.get(oldCaseMap.get(caseRec.Id).OwnerId) == OUTWARD_AGENTS && caseRec.Outward_Ticket_receiving_Date__c == null){
                    caseRec.Outward_Ticket_receiving_Date__c = Datetime.now();
                }
            }
        }
    }
    /**
* @description : Create resolved case record for the user as soon as he completes his task
* @author Ajitesh Singh | 12-09-2020 
* @param resolvedCases : List of resolved cases
* @param oldCaseMap : Map of old cases
**/
    public static void createResolvedCase(List<Case> resolvedCases, Map<Id, Case> oldCaseMap) {
    List<Resolved_Case__c> resolvedCasesList = new List<Resolved_Case__c>();
    
    // Collect all OwnerId values to check whether they are Users
    Set<Id> ownerIds = new Set<Id>();
    for (Case tempCase : resolvedCases) {
        ownerIds.add(oldCaseMap.get(tempCase.Id).OwnerId);
    }
    
    // Query User records where Id is in the OwnerId set
    Map<Id, User> userMap = new Map<Id, User>([SELECT Id FROM User WHERE Id IN :ownerIds]);
    
    // Loop through the cases and create Resolved_Case__c records
    for (Case tempCase : resolvedCases) {
        Id ownerId = oldCaseMap.get(tempCase.Id).OwnerId;
        
        if (userMap.containsKey(ownerId)) {
            // Only add resolved case if the Owner is a User
            resolvedCasesList.add(new Resolved_Case__c(
                Case__c = tempCase.Id,
                User__c = ownerId
            ));
        }
    }
    
    // Insert the resolved cases
    if (!resolvedCasesList.isEmpty()) {
        insert resolvedCasesList;
    }
}

    /**
* @description : Set Counter period basis the holidays defined in the system
* @author Ajitesh Singh | 12-09-2020 
* @param counterCases : Cases for which counter needs to be set
* @param counterMap : Counter Map for bucket wise counter value
**/
    public static void setCounterOnCase(List<Case> counterCases, Map<String, Double> counterMap, Double maxCounter){
        Set<Date> holidayDays = new Set<Date>();
        Date startDate = System.today();
        Date endDate = startDate.addDays((Integer)maxCounter);
        for(Holiday_Matrix__c holidayMatrix : [SELECT Date__c FROM Holiday_Matrix__c WHERE Date__c >= :startDate AND  Date__c <= :endDate]){
            holidayDays.add(holidayMatrix.Date__c);
        }
        for(Case tempCase : counterCases){
            tempCase.Waiting_Date__c = calculateWaitingDate(counterMap.get(tempCase.Bucket__c), holidayDays);
        }
    }
    
    /**
* @description : Calculation waiting date excluding holiday and sundays
* @author Ajitesh Singh | 12-09-2020 
* @param noOfDay : No of days for current bucket
* @param holidayDays : Set of all holidays coming up
* @return Date 
**/
    public static Date calculateWaitingDate(Double noOfDay, Set<Date> holidayDays){
        Date currentDate = System.today();
        while(noOfDay>0){
            currentDate = currentDate.addDays((1));
            if(!(holidayDays.contains(currentDate) || ((DateTime) currentDate).format('E') == 'Sun')){
                noOfDay--;
            }
        }
        return currentDate;
    }
    /**
* @description  : Update Bucket status on basis of Product Family
* @author       : Avinash | 18-11-2021 
* @param(caseId): Id for current Case. 

**/
    public static void updateBucketStatus(Set<id> caseId){
        list<case> updatedCase = new list<case>();
        for(case cs :[select id, Origin, Product__r.Product_Family__c, Product__r.name, Bucket__c
                      FROM CASE
                      WHERE id IN:caseId])
        { 
            if(cs.Origin == 'Web'){
                
                    cs.Bucket__c = 'In Transit';
                } 
                updatedCase.add(cs);
            }
        update updatedCase;
    }
    /*
* @description  : Retrieving related e-mails in single email thread of related case, including registration e-mail 
* @author       : Avinash | 29-11-2021 
* @param(caseIds): Id for current Case.
**/
    public static void CaseEmails (Case cs , String TemplateId){
        try{ 
            OrgWideEmailAddress orgWideEA = new OrgWideEmailAddress();
            orgWideEA = [SELECT Id, Address, DisplayName 
                         FROM OrgWideEmailAddress 
                         WHERE DisplayName =: Label.No_Reply ];
            
            Contact con = new Contact ();
            con.FirstName = 'Email';    
            con.LastName = 'Target'+String.valueOf(system.now().getTime());
            con.Email = 'email@trgt'+String.valueOf(system.now().getTime())+'.abc';
            insert con; 
            
            system.debug('con'+con.Id);
            system.debug('orgWideEA'+orgWideEA.Id);
            system.debug('TemplateId Email Threading'+TemplateId);
            system.debug('caseid'+cs.id);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId(con.Id); 
            message.setTreatTargetObjectAsRecipient(false);
            message.setUseSignature(false); 
            message.setBccSender(false); 
            message.setSaveAsActivity(true);
            message.setOrgWideEmailAddressId(orgWideEA.Id);
            message.setTemplateID(TemplateId);
            message.setWhatId(cs.Id); //This is important for the merge fields in template to work
            message.toAddresses = new String[] {cs.email__c};
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                    system.debug('message caseEmails line 161'+messages);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            //system.debug('caseEmails results 161'+results);
           // system.debug('CaseEmails checking 161'+con);
            delete con;
            Database.emptyRecycleBin(con); 
            
        }
        catch(Exception e){
            System.debug('getCause '+e.getCause());
            System.debug('getLineNumber '+e.getLineNumber());
            System.debug('getMessage '+e.getMessage());                       
        }                
    }
    /**
* @description  : Sending Initial Emails for Case Creation
* @author       : Avinash | 08-07-2021 
* @param(caseId): Id for current Case. 

**/
    public static void SendEmailonCase(set<id> caseIds){
        //list<String>curveProductList = new list<String>{'Curve Black','Curve X Blue','Curve blue','Curve Pro Green','Curve pro Grey','curve pro red','Curve Red','Curve X Black','BA-CURVEX-Grey'};
            Map<String , String> TemplateMap = new Map<String , String>();
        for(emailTemplate et : [Select id, Name, Body from Emailtemplate 
                                where Name =: Label.EmailTemplateNameE2C 
                                Or Name =: Label.EmailTemplateNameW2C
                                Or Name =: Label.In_Transit_Shipping_Address
                                Or Name =: Label.EmailTemplateNameJ2C
                                Or Name =: Label.Reverse_pickup_Bassbox])
           
        { 
            if(et.Name == Label.EmailTemplateNameE2C){
                TemplateMap.put('Email', et.id);
            }
            else if (et.Name == Label.EmailTemplateNameJ2C){
                TemplateMap.put('F1' , et.id);
            }
            else if(et.Name == Label.EmailTemplateNameW2C){
                TemplateMap.put('Web', et.id);
            }
            else if (et.Name == Label.In_Transit_Shipping_Address){
                TemplateMap.put('InTransit' , et.id);
            }
            else if (et.Name == Label.Reverse_pickup_Bassbox){
                TemplateMap.put('Bassbox' , et.id);
            }
            
        } 
        system.debug('TemplateMap >> '+TemplateMap);
        for(case cs :[select id, Origin, Bucket__c, Status, Email__c, SuppliedEmail, contactId, Product__r.Name
                      FROM CASE
                      WHERE id IN:caseIds ])
        { 
            if(cs.Origin == 'F1' || cs.Origin == 'Email'){
                cs.Email__c = cs.SuppliedEmail;
            }
            
            system.debug('cs.Origin >> '+cs.Origin);
            system.debug('cs.email__c >> '+cs.email__c);
            system.debug('cs.SuppliedEmail >> '+cs.SuppliedEmail);
            system.debug('line 219 email on case creation'+TemplateMap);
            
            system.debug('Label.Boult_Support_Email >> '+Label.Boult_Support_Email);
            
            if ((cs.Product__r.Name == 'Bassbox X120 Black' || cs.Product__r.Name == 'Bassbox X180 Black') && (cs.Origin == 'Web') &&  cs.Email__c != null && cs.Email__c != Label.Boult_Support_Email) {
            CaseEmails(cs, templateMap.get('Bassbox'));
            CaseEmails(cs , TemplateMap.get(cs.origin));
            System.debug('===== Case Email Sent for Bassbox Product =====');
        }
            
           else if((cs.Product__r.Name != 'Bassbox X120 Black') && (cs.Product__r.Name != 'Bassbox X180 Black') && (cs.Origin == 'Web') && (cs.email__c != null) && (cs.email__c != Label.Boult_Support_Email)){
                CaseEmails(cs , TemplateMap.get(cs.origin));
                System.debug('===== Case Email Sent Where Origin is Web=====');
                    CaseEmails(cs , TemplateMap.get('InTransit'));
            }
            else if((cs.Origin == 'Email') && (cs.email__c != null) && (cs.email__c != Label.Boult_Support_Email)){
                CaseEmails(cs , TemplateMap.get(cs.origin));  
                System.debug('===== Case Email Sent Where Origin is Email=====');
            }
            else if((cs.Origin == 'F1') && (cs.Bucket__c == null) &&
                    (cs.Status == 'Open') && (cs.email__c != null) && (cs.email__c != Label.Boult_Support_Email)){
                        system.debug('cs.Origin >> '+cs.Origin);
                        CaseEmails(cs , TemplateMap.get(cs.origin));
                        System.debug('=====F1 Case Email Sent Where Origin is F1=====');
                    }
        }
    }
    
    /*
* @description  : Sending WhatsApp Message according to the Sub_Bucket Value on Case Updation. 
* @author       : Avinash | 16-12-2021 
//Last Modified : Avinash   | 17-05-2023   |  Modified ()
**/
    public static void sendWhatsAppOnCaseUpdate (List<Case> triggerNew, Map<Id, Case> OldMap){
        Map<Id,String> caseId=new Map<Id,String>();
        for(Case c : triggerNew){
            system.debug('Bucket__c'+c.Courier_Partner_Name__c);
            system.debug('Bucket__c at  249'+c.AWB_No__c);

           if(c.origin != 'F1'){
                if((c.Bucket__c == 'Correct product received' || c.Bucket__c == 'Different Brand Product' 
                    || c.Bucket__c == 'Partial product' || c.Bucket__c == 'Physically damaged'
                    || c.Bucket__c == 'Repair' || c.Bucket__c == 'DBAPR(Different BoultAudio Product Received)' 
                    || c.Bucket__c == 'Replaceable in stock' || c.Bucket__c == 'Delivered' || c.Bucket__c == 'Replaceable out of stock'
                    || c.Bucket__c == 'Replaceable out of Stock/CRM/Service') 
                    && c.Bucket__c != OldMap.get(c.Id).Bucket__c && c.Origin != 'F1')
                   
                  {system.debug('line no 258>>'+c.AWB_No__c);
                       caseId.put(c.Id,'F1');
                      //MessageClass.sendWhatsApp(c.Id, webRun);   
                  }
                else if(c.Bucket__c == 'In Transit' && c.Bucket__c != OldMap.get(c.Id).Bucket__c && (OldMap.get(c.Id).LastModifiedDate != System.today()) ){
                    system.debug('Bucket__c'+c.Bucket__c);
                    system.debug('oldmap'+OldMap.get(c.Id).LastModifiedDate);
                    system.debug('Today'+ System.today());
                    system.debug('line no 265>>'+c.AWB_No__c);
                     caseId.put(c.Id,'F1');
                    //MessageClass.sendWhatsApp(c.Id, webRun);
                    system.debug('Case Id is :' + c.Id);
                }
                                
                else if((c.Bucket__c == 'Serviceable/Shipped' &&
                         (c.Courier_Partner_Name__c == 'ShipRocket' 
                          || c.Courier_Partner_Name__c == 'India Post' 
                          || c.Courier_Partner_Name__c == 'Blue Dart') /*||c.Courier_Partner_Name__c == 'Delhivery'*/ 
                         && c.Origin != 'F1') && c.Courier_Partner_Name__c != OldMap.get(c.Id).Courier_Partner_Name__c
                       ){
                           system.debug('Bucket__c'+c.Bucket__c);
                           system.debug('Courier_Partner_Name__c'+c.Courier_Partner_Name__c);
                           system.debug('line no 275>>'+c.AWB_No__c);
                           caseId.put(c.Id,'F1'); 
                           // MessageClass.sendWhatsApp(c.Id, webRun);
                       }
            } 
             
            else {
                if((c.Bucket__c == 'Replaceable in stock' &&
                    (c.Status == 'Resolved'))&& c.Status != OldMap.get(c.Id).Status){
                        system.debug('Bucket__c'+c.Bucket__c);
                        system.debug('Status'+c.Status);
                        caseId.put(c.Id,'F1');
                        //MessageClass.sendWhatsApp(c.Id, webRun);
                    }
                
                else if((c.Bucket__c == 'Replaceable out of stock' && (c.Status == 'Pending' || c.Status == 'Open'))
                        && c.Status != OldMap.get(c.Id).Status){
                            system.debug('Bucket__c'+c.Bucket__c);
                            system.debug('Status'+c.Status);
                            caseId.put(c.Id,'F1');
                            //MessageClass.sendWhatsApp(c.Id, webRun);
                        }
                
                else if((c.Bucket__c == 'Serviceable/Shipped' 
                         && (c.Courier_Partner_Name__c == 'Blue Dart' 
                             || c.Courier_Partner_Name__c == 'India Post' 
                             || c.Courier_Partner_Name__c == 'ShipRocket'))
                        /*|| c.Courier_Partner_Name__c == 'Delhivery'*/
                        && c.Courier_Partner_Name__c != OldMap.get(c.Id).Courier_Partner_Name__c){
                            system.debug('Bucket__c'+c.Bucket__c);
                            system.debug('Courier_Partner_Name__c'+c.Courier_Partner_Name__c);
                            system.debug('line no 305..'+c.AWB_No__c);
                            caseId.put(c.Id,'F1');
                            //MessageClass.sendWhatsApp(c.Id, webRun);
                        }
                
                else if(c.Bucket__c == 'Delivered' && c.Bucket__c != OldMap.get(c.Id).Bucket__c){
                    system.debug('Bucket__c'+c.Bucket__c);
                     caseId.put(c.Id,'F1');
                    //MessageClass.sendWhatsApp(c.Id, webRun);
                }
            }
        }
        if(!caseId.isEmpty()){
           MessageClass.sendWhatsApp(null, caseId, webRun);
        }
        
    }
    /*
* @description  : Sending SMS Message according to the Sub_Bucket Value on Case Updation. 
* @author       : Avinash | 16-12-2021 
**/
    public static void sendSMSOnCaseUpdate (List<Case> triggerNew, Map<Id, Case> OldMap){
        
        for(Case c : triggerNew){
            system.debug('Bucket__c'+c.Bucket__c);
            
            if(((c.Bucket__c == 'Correct product received' || c.Bucket__c == 'Different Brand Product' 
                 || c.Bucket__c == 'Partial product' || c.Bucket__c == 'Physically damaged' 
                 ||c.Bucket__c == 'Delivered' || c.Bucket__c == 'Repair' || c.Bucket__c == 'Replaceable in stock') && (c.Bucket__c != OldMap.get(c.Id).Bucket__c)
                || (c.Bucket__c != OldMap.get(c.Id).Bucket__c && c.Bucket__c == 'Serviceable/Shipped') 
                || (c.Bucket__c == 'Serviceable/Shipped') && c.Origin != 'F1')
               && (c.Courier_Partner_Name__c == 'ShipRocket' || c.Courier_Partner_Name__c == 'India Post'
                   ||c.Courier_Partner_Name__c == 'Blue Dart') && c.Origin != 'F1' ) /*|| c.Courier_Partner_Name__c == 'Delhivery')*/  
                
            {
              //  MessageClass.sendSMS(c.Id);   
            }
            else if(c.Bucket__c == 'In Transit' && c.Bucket__c != OldMap.get(c.Id).Bucket__c && (OldMap.get(c.Id).LastModifiedDate != System.today()) ){
                //MessageClass.sendSMS(c.Id);
            }
        } 
    }
    
    /*
* @description  : Sending WhatsApp Message according to the F1 Sub_Bucket Value on Case Updation. 
* @author       : Avinash | 15-06-2022 
**/ //Last Modified : 24-06-2022   Avinash     Modified ()
    
    public static void sendWhatsAppOnF1CaseInsert (List<Case> triggerNew ){
          Map<Id,String> caseId=new Map<Id,String>();
        for(Case c : triggerNew){
            
            if(c.Bucket__c == 'Replaceable in stock' && c.Status == 'Resolved'){
                system.debug('Bucket__c'+c.Bucket__c);
                system.debug('Status'+c.Status);
                caseId.put(c.Id,'F1');
                //MessageClass.sendWhatsApp(c.Id, webRun);
            }
            
            else if(c.Bucket__c == 'Replaceable out of stock' && (c.Status == 'Pending' || c.Status == 'Open'))
            {
                system.debug('Bucket__c'+c.Bucket__c);
                system.debug('Status'+c.Status);
                caseId.put(c.Id,'F1');
                //MessageClass.sendWhatsApp(c.Id, webRun);
            }  
            else if(c.Bucket__c == null && c.Status == 'Open')
            {
                system.debug('Bucket__c'+c.Bucket__c);
                system.debug('Status'+c.Status);
                caseId.put(c.Id,'F1');
                //MessageClass.sendWhatsApp(c.Id, webRun);
            } 
        }   
         if(!caseId.isEmpty()){
           MessageClass.sendWhatsApp(null, caseId, webRun);
         }
    }
    
    // Sen whatsApp Message when case insert and origin is web
	public static void sendWhatsAppOnWebCaseInsert (List<Case> triggerNew, Boolean webRun ){
    	Map<Id,String> caseId=new Map<Id,String>();
        for(Case c : triggerNew){
        	if(c.Origin == 'Web' && webRun == true){
                caseId.put(c.Id,'F1');	
        	}   
    	}
        if(!caseId.isEmpty()){
        MessageClass.sendWhatsApp(null,caseId, webRun);
        }
	}
    
    
    /*
* @description  : Autotagging customers to case on case creation. 
* @author       : Avinash | 01-06-2022 
**/
    
   public static void customerAutoTagging(Set<Id> CaseIds) {
    // Fetch the RecordType for Person Accounts
    String strRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND Name = 'Person Account'].Id;
    
    // List of origins to filter cases
    List<String> originLst = new List<String>{'web','F1'};
    
    // Fetch the cases that match the criteria
    List<Case> NewCases = [SELECT Id, CaseNumber, Origin, Status, City__c, State__c, Customer_PinCode__c, 
                           Pin_Code__c, Address_street__c, SuppliedPhone, SuppliedName, SuppliedEmail, Email__c 
                           FROM Case WHERE Id IN :CaseIds AND Origin IN ('web','F1')];
    
    // Prepare collections to hold data
    List<String> emailAddresses = new List<String>();
    List<String> suppliedPhone = new List<String>();
    List<Case> updateCase = new List<Case>();
    List<Case> oldCase = new List<Case>();
    
    // Collect email and phone numbers from cases
    for (Case caseObj : NewCases) {
        if (String.isNotBlank(caseObj.SuppliedEmail) && String.isNotBlank(caseObj.SuppliedPhone)) {
            emailAddresses.add(caseObj.SuppliedEmail);
            suppliedPhone.add(caseObj.SuppliedPhone);
        }
    }
    
    System.debug('emailAddresses: ' + emailAddresses);
    System.debug('Supplied Phone: ' + suppliedPhone);
    
    // Initialize the maps
    Map<String, String> conMap = new Map<String, String>();
    Map<String, Account> newConMap = new Map<String, Account>();  // Correctly initialize newConMap
    Map<String, Account> AccMapUpdate = new Map<String, Account>();
    Map<String, String> suppliedPhoneConMap = new Map<String, String>();
    List<Account> AccToUpdateAddress = new List<Account>();
    
    // Fetch matching Person Accounts
    for (Account personAcc : [SELECT Id, PersonEmail, PersonContactId, ShippingCity, ShippingPostalCode, 
                              ShippingState, ShippingStreet, ShippingCountry, PersonMobilePhone 
                              FROM Account 
                              WHERE PersonEmail IN :emailAddresses 
                              AND PersonMobilePhone IN :suppliedPhone 
                              AND RecordTypeId = :strRecordTypeId]) {
        conMap.put(personAcc.PersonEmail, personAcc.Id);
        AccMapUpdate.put(personAcc.PersonEmail, personAcc);
        suppliedPhoneConMap.put(personAcc.PersonMobilePhone, personAcc.Id);
    }
    
    System.debug('ConMap: ' + conMap);
    System.debug('AccMapUpdate: ' + AccMapUpdate);
    
    // Iterate through cases to update or create new Person Accounts
    for (Case cs : NewCases) {
        if (conMap.containsKey(cs.SuppliedEmail) && suppliedPhoneConMap.containsKey(cs.SuppliedPhone)) {
            cs.Contact_Name__c = conMap.get(cs.SuppliedEmail);
            oldCase.add(cs);
            
            Account Acc1 = AccMapUpdate.get(cs.SuppliedEmail);
            if (Acc1 != null) {
                Account Acc = new Account();
                Acc.Id = Acc1.Id;
                Acc.ShippingCity = cs.City__c;
                Acc.ShippingPostalCode = cs.Pin_Code__c != null ? String.valueOf(cs.Pin_Code__c) : String.valueOf(cs.Customer_PinCode__c);
                Acc.ShippingState = cs.State__c;
                Acc.ShippingStreet = cs.Address_street__c;
                Acc.ShippingCountry = 'India';
                AccToUpdateAddress.add(Acc);
            }
        } else {
            String[] nameParts = cs.SuppliedName != null ? cs.SuppliedName.split(' ', 3) : new String[0];
            if (nameParts.size() == 3) {
                Account personContact = new Account(FirstName = nameParts[0], MiddleName = nameParts[1], LastName = nameParts[2],
                                                    PersonEmail = cs.SuppliedEmail, PersonMobilePhone = cs.SuppliedPhone, 
                                                    ShippingCity = cs.City__c, 
                                                    ShippingPostalCode = cs.Pin_Code__c != null ? String.valueOf(cs.Pin_Code__c) : String.valueOf(cs.Customer_PinCode__c),
                                                    ShippingState = cs.State__c, ShippingStreet = cs.Address_street__c, 
                                                    ShippingCountry = 'India', RecordTypeId = strRecordTypeId);
                newConMap.put(cs.Id, personContact);
            } else if (nameParts.size() == 2) {
                Account personContact = new Account(FirstName = nameParts[0], LastName = nameParts[1], 
                                                    PersonEmail = cs.SuppliedEmail, PersonMobilePhone = cs.SuppliedPhone, 
                                                    ShippingCity = cs.City__c, 
                                                    ShippingPostalCode = cs.Pin_Code__c != null ? String.valueOf(cs.Pin_Code__c) : String.valueOf(cs.Customer_PinCode__c),
                                                    ShippingState = cs.State__c, ShippingStreet = cs.Address_street__c, 
                                                    ShippingCountry = 'India', RecordTypeId = strRecordTypeId);
                newConMap.put(cs.Id, personContact);
            } else if (nameParts.size() == 1) {
                Account personContact = new Account(FirstName = cs.SuppliedName, LastName = nameParts[0], 
                                                    PersonEmail = cs.SuppliedEmail, PersonMobilePhone = cs.SuppliedPhone, 
                                                    ShippingCity = cs.City__c, 
                                                    ShippingPostalCode = cs.Pin_Code__c != null ? String.valueOf(cs.Pin_Code__c) : String.valueOf(cs.Customer_PinCode__c),
                                                    ShippingState = cs.State__c, ShippingStreet = cs.Address_street__c, 
                                                    ShippingCountry = 'India', RecordTypeId = strRecordTypeId);
                newConMap.put(cs.Id, personContact);
            }
            updateCase.add(cs);
        }
    }
    
    // Update existing accounts and cases
    if (!AccToUpdateAddress.isEmpty()) {
        update AccToUpdateAddress;
    }
    
    if (!oldCase.isEmpty()) {
        update oldCase;
    }
    
    // Insert new Person Accounts while bypassing duplicate rules
    List<Account> AccList = newConMap.values();
    if (!AccList.isEmpty()) {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        Database.SaveResult[] sr = Database.insert(AccList, dml);
    }
    
    // Update cases with newly created accounts
    for (Case c : updateCase) {
        Account acc = newConMap.get(c.Id);
        if (acc != null) {
            c.Contact_Name__c = acc.Id;
        }
    }
    
    if (!updateCase.isEmpty()) {
        update updateCase;
    }
    
    System.debug('Updated Cases: ' + updateCase);
}


    
    /*
* @description  : Holding case from Re-opening fourth time, and closing case on getting delivered after 3rd reopen.
* @author       : Avinash | 16-12-2021 
**/
    
    public static void ReopenCountMethod(List<case> triggerNew, Map<id, case> OldMap){
        try{
        for (case cs: triggerNew){
            system.debug('for loop');
            
            if((cs.Bucket__c != OldMap.get(cs.Id).Bucket__c) && (cs.Bucket__c == 'Re Open')  ){
                System.debug('ReopenCountMethod bucket change');
                if((OldMap.get(cs.Id).Reopen_Count_New__c == 3) && (cs.Origin != 'Email')){
                    
                    System.debug('ReopenCountMethod if');
                    cs.Bucket__c.addError('Please advise the customer to raise a fresh ticket.');
                    
                } 
                
                else{
                    System.debug('ReopenCountMethod else');
                    if(cs.Reopen_Count_New__c != null)
                    {
                        cs.Reopen_Count_New__c = OldMap.get(cs.Id).Reopen_Count_New__c+1;
                        if(cs.Reopen_Count_New__c==1){
                            cs.ReOpenDate1__c = system.now();
                        }else if(cs.Reopen_Count_New__c==2){
                            cs.ReOpenDate2__c = system.now();
                        }else if(cs.Reopen_Count_New__c==3){
                            cs.ReOpenDate3__c = system.now();
                        }
                        
                        system.debug('reopen count'+cs.Reopen_Count_New__c);
                        
                    }
                }
            } 
            
            
            if((OldMap.get(cs.Id).Reopen_Count_New__c == 3) && (OldMap.get(cs.Id).Bucket__c != 'Delivered' ) 
               && (cs.Bucket__c == 'Delivered') && (cs.Origin != 'Email')){
                   System.debug('Reopen_Count_New__c '+cs.Reopen_Count_New__c);
                   System.debug('Bucket__c '+cs.Bucket__c);
                   cs.Status = 'Closed'; 
               }
        }
    }
        catch(Exception ex){
            GenerateExceptionLogs.insertErrorLogs('CaseTriggerHandler', 'ReopenCountMethod',ex);
        }
    }
    
    
    /*
* @description  : Sending Email on sub bucket value update.
* @author       : Avinash | 28-01-2021 
**/             
    public static void sendEmailForBucketUpdate(List<Case> triggerNew, Map<Id, Case> OldMap){
                Map<String, String> TemplateMap = new Map<String, String>();
        Map<String, Case> ProdMap = new Map<String, Case>();

        // Populate TemplateMap with Email Template IDs based on their names
        for (EmailTemplate et : [SELECT Id, Name, Body FROM EmailTemplate WHERE 
                                Name IN (:Label.Product_Delivered_Notification, 
                                         :Label.Outward_Team_Shipped_Status_email,
                                         :Label.Partial_Product_Received_TWS_Product,
                                         :Label.Physically_Damaged_Product_Received,
                                         :Label.Different_Product_Received,
                                         :Label.Product_Received,
                                         :Label.Invoice_not_found_Valid,
                                         :Label.Third_Party_extended_warranty,
                                         :Label.Empty_parcel,
                                         :Label.DBAPR_Service_Required,
                                         :Label.Replaceable_out_of_stock,
                                         :Label.Out_of_Warranty_Product,
                                         :Label.In_Transit_Shipping_Address,
                                         :Label.Replaceable_out_of_Stock_CRM_Service,
                                         :Label.Order_Dispatched_via_Blue_Dart,
                                         :Label.Order_Dispatched_via_Indiapost,
                                         :Label.Order_Dispatched_via_Shiprocket,
                                         :Label.WithOut_invoice,
                                         :Label.Out_of_Warranty_Inward,
                                         :Label.Valid_Invoice)]) {
            if (et.Name == Label.Product_Delivered_Notification) {
                TemplateMap.put('Delivered', et.Id);
            } else if (et.Name == Label.Outward_Team_Shipped_Status_email) {
                TemplateMap.put('Repair', et.Id);
            } else if (et.Name == Label.Invoice_not_found_Valid) {
                TemplateMap.put('Invoice not found/Invalid', et.Id);
            } else if (et.Name == Label.Third_Party_extended_warranty) {
                TemplateMap.put('Third Party extended Warranty', et.Id);
            } else if (et.Name == Label.Replaceable_out_of_stock) {
                TemplateMap.put('Replaceable out of stock', et.Id);
            } else if (et.Name == Label.Product_Received) {
                TemplateMap.put('Correct product received', et.Id);
            } else if (et.Name == Label.Different_Product_Received) {
                TemplateMap.put('Different Brand Product', et.Id);
            } else if (et.Name == Label.Partial_Product_Received_TWS_Product) {
                TemplateMap.put('Partial product', et.Id);
            } else if (et.Name == Label.Physically_Damaged_Product_Received) {
                TemplateMap.put('Physically damaged', et.Id);
            } else if (et.Name == Label.Empty_parcel) {
                TemplateMap.put('Empty parcel', et.Id);
            } else if (et.Name == Label.DBAPR_Service_Required) {
                TemplateMap.put('DBAPR(Different BoultAudio Product Received)', et.Id);
            } else if (et.Name == Label.Out_of_Warranty_Product) {
                TemplateMap.put('Out_of_Warranty_Product', et.Id);
            } else if (et.Name == Label.In_Transit_Shipping_Address) {
                TemplateMap.put('In Transit', et.Id);
            } else if (et.Name == Label.Order_Dispatched_via_Indiapost) {
                TemplateMap.put('Serviceable/Shipped-India Post', et.Id);
            } else if (et.Name == Label.Order_Dispatched_via_Blue_Dart) {
                TemplateMap.put('Serviceable/Shipped-Blue Dart', et.Id);
            } else if (et.Name == Label.Order_Dispatched_via_Shiprocket) {
                TemplateMap.put('Serviceable/Shipped-ShipRocket', et.Id);
            } else if (et.Name == Label.WithOut_invoice) {
                TemplateMap.put('Without invoice', et.Id);
            } else if (et.Name == Label.Out_of_Warranty_Inward) {
                TemplateMap.put('Out Of Warranty', et.Id);
            } else if (et.Name == Label.Replaceable_out_of_Stock_CRM_Service) {
                TemplateMap.put('Replaceable out of Stock/CRM/Service', et.Id);
            } else if (et.Name == Label.Valid_Invoice) {
                TemplateMap.put('Valid Invoice', et.Id);
            }
        }

        system.debug('EmailforBucketUpdateTemplateMap' + TemplateMap);

        for (Case cs : triggerNew) {
            system.debug('Product Name: ' + cs.Product__r.Name);
            system.debug('Bucket: ' + cs.Bucket__c);

            // Check if OldMap is null (in case of insert) or if it contains the case ID
            Boolean isBucketChanged = Trigger.isInsert || 
                                      (OldMap != null && OldMap.containsKey(cs.Id) && 
                                       OldMap.get(cs.Id) != null && 
                                       cs.Bucket__c != OldMap.get(cs.Id).Bucket__c);
            system.debug('isBucketChanged'+isBucketChanged);

            if ((cs.Bucket__c == 'Delivered' || cs.Bucket__c == 'Correct product received' || 
                 cs.Bucket__c == 'Different Brand Product' || cs.Bucket__c == 'Partial product' || 
                 cs.Bucket__c == 'Out Of Warranty' || cs.Bucket__c == 'Without invoice' || 
                 cs.Bucket__c == 'Physically damaged' || cs.Bucket__c == 'Repair' || 
                 cs.Bucket__c == 'Replaceable in stock' || cs.Bucket__c == 'Empty parcel' || 
                 cs.Bucket__c == 'DBAPR(Different BoultAudio Product Received)' || 
                 cs.Bucket__c == 'Replaceable out of stock' || 
                 cs.Bucket__c == 'Replaceable out of Stock/CRM/Service' || 
                 cs.Bucket__c == 'In Transit' || cs.Bucket__c == 'Third Party extended Warranty' || 
                 cs.Bucket__c == 'Invoice not found/Invalid' || cs.Bucket__c == 'Valid Invoice') 
                && cs.Email__c != null 
                && cs.Email__c != Label.Boult_Support_Email 
                && isBucketChanged 
                && cs.Origin != 'F1' 
                && cs.Product__r.Name != 'Bassbox X120 Black' 
                && cs.Product__r.Name != 'Bassbox X180 Black') {
                
                CaseEmails(cs, TemplateMap.get(cs.Bucket__c));
                system.debug('TemplateMapV: ' + TemplateMap.get(cs.Bucket__c));
                system.debug('Product Name: ' + cs.Product__r.Name);
            }

            // Check conditions for sending email based on courier partner
            else if (cs.Bucket__c == 'Serviceable/Shipped' && 
                    (cs.Courier_Partner_Name__c == 'India Post' || cs.Courier_Partner_Name__c == 'Blue Dart' || cs.Courier_Partner_Name__c == 'ShipRocket')
                    && cs.Email__c != null && cs.Email__c != Label.Boult_Support_Email && cs.Origin != 'F1'
                    && cs.Origin == 'Web' && cs.Product__r.Name != 'Bassbox X120 Black' && cs.Product__r.Name != 'Bassbox X180 Black') {
                
                system.debug('TemplateMapV' + TemplateMap.get(cs.Bucket__c));
                CaseEmails(cs, TemplateMap.get(cs.Bucket__c + '-' + cs.Courier_Partner_Name__c));
            }

            ProdMap.put(cs.Product__c, cs);
        }

        // Handle product-specific email conditions
        for (Product__c pro : [SELECT Id, Name FROM Product__c WHERE Id IN :ProdMap.keySet()]) {
            if (ProdMap.get(pro.Id).Bucket__c == 'Out Of Warranty' && ProdMap.get(pro.Id).Email__c != null
                && ProdMap.get(pro.Id).Email__c != Label.Boult_Support_Email && ProdMap.get(pro.Id).Origin != 'F1') {
                
                CaseEmails(ProdMap.get(pro.Id), TemplateMap.get('Out_of_Warranty_Product'));
            }
        }
    }
        

    
    
    /* @description  : Sending Email on sub bucket value update for F1 system.
* @author       : Avinash | 28-03-2022 
**/             
    public static void sendEmailForF1BucketUpdate(List<Case> triggerNew, Map<Id, Case> OldMap){
        Map<String , String> TemplateMap = new Map<String , String>();
        for(emailTemplate et : [Select id, Name, Body from Emailtemplate 
                                where Name =: Label.Resolved_Replaceable_In_Stock_Jeeves
                                Or Name =: Label.Pending_Replaceable_Out_Of_Stock_Jeeves
                                /*Or Name =: Label.Resolved_Replacable_Out_of_stock_Jeeves*/
                                Or Name =: Label.Open_Replacable_Out_of_stock_Jeeves
                                Or Name =: Label.Dispatched_via_Indiapost_Jeeves
                                Or Name =: Label.Dispatched_via_Blue_Dart_Jeeves
                                Or Name =: Label.Dispatched_Via_ShipRocket_Jeeves
                                /* Or Name =: Label.Dispatched_via_Delhivery_Jeeves*/
                                Or Name =: Label.Delivered_Jeeves])
        {
            system.debug('et.Name : '+et.Name+ ' : '+Label.Resolved_Replaceable_In_Stock_Jeeves);
            if (et.Name == Label.Delivered_Jeeves){
                TemplateMap.put('Delivered' , et.id);
            }
            else if (et.Name == Label.Resolved_Replaceable_In_Stock_Jeeves){
                system.debug('Isnide template : '+et.id);
                TemplateMap.put('Replaceable in stock-Resolved' , et.id); 
            }
            else if (et.Name == Label.Pending_Replaceable_Out_Of_Stock_Jeeves){
                TemplateMap.put('Replaceable out of stock-Pending' , et.id); 
            }
            else if (et.Name == Label.Open_Replacable_Out_of_stock_Jeeves){
                TemplateMap.put('Replaceable out of stock-Open', et.Id);
            }
            else if (et.Name == Label.Dispatched_via_Indiapost_Jeeves){
                TemplateMap.put('Serviceable/Shipped-India Post', et.Id);
            }
            else if (et.Name == Label.Dispatched_via_Blue_Dart_Jeeves){
                TemplateMap.put('Serviceable/Shipped-Blue Dart', et.Id);
            }
            else if (et.Name == Label.Dispatched_Via_ShipRocket_Jeeves){
                TemplateMap.put('Serviceable/Shipped-ShipRocket', et.Id);
            }
            /*else if (et.Name == Label.Dispatched_via_Delhivery_Jeeves){
TemplateMap.put('Serviceable/Shipped-Delhivery', et.Id);
}*/
            
        }
        system.debug('F1 BucketUpdateTemplateMap'+TemplateMap);
        system.debug('F1 triggerNew '+triggerNew);
        
        for(Case cs : triggerNew){
            
            system.debug('F1 OldMap.get(cs.Id) '+OldMap);
            //system.debug('F1 OldMap.get(cs.Id).Status '+OldMap.get(cs.Id).Status);
            
            if((cs.Bucket_Department__c== 'ORM' && cs.Bucket_Department__c != OldMap.get(cs.Id).Bucket_Department__c) && (cs.Bucket__c == 'Delivered' && cs.Bucket__c != OldMap.get(cs.Id).Bucket__c) && (cs.Origin =='F1' && cs.email__c != Label.Boult_Support_Email)){
                CaseEmails(cs , TemplateMap.get(cs.Bucket__c));
                system.debug('F1 TemplateMapV'+TemplateMap.get(cs.Bucket__c));
                
                
            }
            
            else if((cs.Bucket__c == 'Replaceable in stock'  && cs.Status =='Resolved') ||
                    ((cs.Bucket__c == 'Replaceable in stock' && cs.Bucket__c != OldMap.get(cs.Id).Bucket__c) && (cs.Origin =='F1' && cs.Status =='Resolved' && cs.Status != OldMap.get(cs.Id).Status )))
                
            {
                system.debug('Inside '+TemplateMap);
                system.debug('TemplateMap : '+TemplateMap.keySet());
                system.debug('TemplateMap : '+TemplateMap.get(cs.Bucket__c+'-'+cs.Status));
                system.debug('F1 cs.Bucket__c '+cs.Bucket__c);
                system.debug('F1  cs.Status '+ cs.Status);
                CaseEmails(cs , TemplateMap.get(cs.Bucket__c+'-'+cs.Status));
            }
            else if((cs.Bucket__c == 'Replaceable out of stock'&& (cs.Status =='Pending'))||
                    (cs.Bucket__c == 'Replaceable out of stock'&& (cs.Status =='Open' &&  cs.Status != OldMap.get(cs.Id).Status )))
            {
                CaseEmails(cs , TemplateMap.get(cs.Bucket__c+'-'+cs.Status));
                system.debug('F1 TemplateMapV'+TemplateMap.get('TemplateMap>>>'+TemplateMap));
            }
            
            else if(cs.Bucket__c == 'Serviceable/Shipped'&& (cs.Courier_Partner_Name__c =='India Post'
                                                             || cs.Courier_Partner_Name__c =='Blue Dart' 
                                                             || cs.Courier_Partner_Name__c =='ShipRocket') && cs.Origin =='F1')
                    /*|| cs.Courier_Partner_Name__c == 'Delhivery'*/ 
                   // && ( cs.Origin =='F1' && cs.Courier_Partner_Name__c != OldMap.get(cs.Id).Courier_Partner_Name__c ))
            {
                CaseEmails(cs , TemplateMap.get(cs.Bucket__c+'-'+cs.Courier_Partner_Name__c));
            }
            
            
        } 
    }
    
    
    // Autopopulate WareHouse Field When Courier Partner is Delhivery Selected
    /*public static void warehouseUpdate(List<Case> newList, Map<Id, Case> OldMap)
{
List<WareHouse__c> wh = [Select Id,Name From WareHouse__c Where Name =:Label.WareHouseName limit 1];
if( OldMap <> null ){
for(case c:newList){
if ( c.Courier_Partner_Name__c != OldMap.get(c.Id).Courier_Partner_Name__c && c.Courier_Partner_Name__c == 'Delhivery')
{
c.WareHouse__c = wh.size() > 0 ? wh[0].Id : ''; 
}
}
}else {
for(case c:newList){
if (c.Courier_Partner_Name__c == 'Delhivery')
{
c.WareHouse__c = wh.size() > 0 ? wh[0].Id : ''; 
}
}
}
}*/
    
    public static void subBucketFieldUpdate(list <case> newLst, map<Id, Case> oldMap){
        for(case ids:newLst)
        {
            Id caseId = ids.Id;
            if(oldMap <> null ){
                if(ids.Bucket__c != oldMap.get(ids.Id).Bucket__c && ids.Bucket__c == 'Out Of Warranty'){
                    ids.Store_SubBucket_Modified_Date__c = system.now(); 
                }
            }else{
                if(ids.Bucket__c == 'Out Of Warranty'){
                    ids.Store_SubBucket_Modified_Date__c = system.now(); 
                }
            }
        } 
    }
    
    public static void sendEmailFieldUpdate(list<case> newLst, map<Id, Case> oldMap){
        for(case ids:newLst){
            Id caseId = ids.Id;
            if(oldMap <> null){
                if(ids.Bucket__c == 'Out Of Warranty' && ids.after_7days_send_email_out_of_warranty__c == true){
                    if(ids.Out_Of_Warranty_Send_Email_Date__c == null){
                        ids.Out_Of_Warranty_Send_Email_Date__c = System.now();
                    }
                } 
            } 
        }
    }
}