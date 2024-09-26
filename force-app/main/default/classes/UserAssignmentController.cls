public with sharing class UserAssignmentController {
    @AuraEnabled(cacheable=true)
    public static List<User> getUserList(String searchKey) {
        
        String searchKeyword = '%' + searchKey + '%';
        
        // create User list to store search result 
        list<User> userListRecord = new list<User>();
        
        // query User records
        for(User usrObj : [Select Id, Name,UserRole.Name,User.Profile.Name
                           From User 
                           WHERE Name LIKE: searchKeyword and IsActive = true limit 3]){
                               userListRecord.add(usrObj);
                           }
        System.debug('===userListRecord==='+userListRecord);
        
        if(userListRecord.size() == 0){
            System.debug('No Record Found') ;
        }
        
        // system.debug('debug>> '+[select id,name from user limit 5]);
        // return [select Id,Name from user limit 5];
        return userListRecord;
        
    }
    @AuraEnabled
    public static List<SObject> search(String searchString) {
        List<SObject> searchList = new List<SObject>();
        try { 
            String searchStr = '*' + searchString + '*';
            String searchquery =
                'FIND\'' +
                searchStr +
                '\'IN ALL FIELDS RETURNING Contact(id, name, email where email != null), User(id, name, email where email != null AND isActive = true) LIMIT 10';
            List<List<SObject>> searchResult = search.query(searchquery);
            for (List<SObject> curList : searchResult) {
                searchList.addAll(curList);
                System.debug('==searchList==='+searchList);
            }
            system.debug('searchList:::' + searchList.size());
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return searchList;
    }
    
    @AuraEnabled
    public static list<EmailTemplate> getEmailTemplate(){
        list<EmailTemplate> temp = [SELECT Id,Body,DeveloperName FROM EmailTemplate];
        //return [SELECT Id,Body,DeveloperName FROM EmailTemplate];
        System.debug('Template is' + temp);
        return temp;
        
    }
    
    @AuraEnabled
    public static list<EmailTemplate> getEmailTemplateBody(string mailId){
        list<EmailTemplate> mail = [SELECT Id,Body,DeveloperName,Subject FROM EmailTemplate where Id=:mailId];
        //return [SELECT Id,Body,DeveloperName,Subject FROM EmailTemplate where Id=:mailId];
        System.debug('Mail Id is :' + mailId);
        return mail;
    }   
    
    
    @AuraEnabled
    public static String getCaseEmail(Id caseId) {
        return [SELECT SuppliedEmail FROM Case WHERE Id = :caseId LIMIT 1].SuppliedEmail;
    }
    
    
    
    @AuraEnabled
    public static Case getCaseRecord(Id caseId){
        Case cases = [SELECT Id,CaseNumber,SourceId,SuppliedEmail FROM Case WHERE Id =: caseId];
        system.debug('cases recorde is' + cases);
        return cases;
    }
    
    
    @AuraEnabled
    public static void CaseEmailDetial (string body, string subject, string toAdd){
        try{ 
            OrgWideEmailAddress orgWideEA = new OrgWideEmailAddress();
            orgWideEA = [SELECT Id, Address, DisplayName 
                         FROM OrgWideEmailAddress 
                         WHERE DisplayName =: Label.OrgWideEmailDisplayName ];
            
            List<String> sendTo = new List<String>();
            sendTo.add(toAdd);
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setOrgWideEmailAddressId(orgWideEA.Id);
            message.setSubject(Subject);
            message.setHtmlBody(body);
            message.setToAddresses(sendTo);
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                system.debug('message'+messages);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);       
        }
        catch(Exception e){
            System.debug('getCause '+e.getCause());
            System.debug('getLineNumber '+e.getLineNumber());
            System.debug('getMessage '+e.getMessage());                       
        }                
    }
    
    @AuraEnabled
    public static void CaseEmails (Case cs , String TemplateId){
        
        system.debug('value of cs is'+ cs);
        system.debug('value of TemplateId is'+ TemplateId);
        system.debug('value of TemplateId is calling by AuraEnabled'+ TemplateId);
        try{ 
            OrgWideEmailAddress orgWideEA = new OrgWideEmailAddress();
            orgWideEA = [SELECT Id, Address, DisplayName 
                         FROM OrgWideEmailAddress 
                         WHERE DisplayName =: Label.OrgWideEmailDisplayName ];
            
            Contact con = new Contact ();
            con.FirstName = 'Email';    
            con.LastName = 'Target'+String.valueOf(system.now().getTime());
            con.Email = 'email@trgt'+string.valueof(system.now().gettime())+'.abc';
            insert con; 
            
            system.debug('con'+con.Id);
            system.debug('orgWideEA'+orgWideEA.Id);
            system.debug('TemplateId'+TemplateId);
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
            message.toAddresses = new String[] {cs.SuppliedEmail};
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                    system.debug('message'+messages);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            delete con;
            Database.emptyRecycleBin(con); 
            
        }
        catch(Exception e){
            System.debug('getCause '+e.getCause());
            System.debug('getLineNumber '+e.getLineNumber());
            System.debug('getMessage '+e.getMessage());                       
        }                
    }
    
    Class EmailWrapper {
        public string[] toAddress;
        public List<String> ccAddress;
        public String subject;
        public String body;
    }
}