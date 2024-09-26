global class SendCustomNotificationBatch implements Database.Batchable<sObject>, Database.Stateful{
    /*global string title = 'Not Updated Cases By You';
    string targetId = '000000000000000AAA';
    
    CustomNotificationType notificationType = [SELECT id,customNotifTypeName FROM CustomNotificationType WHERE DeveloperName = 'sendNotificationForNotUpdatedCase'];
    
    global map<Id,User> activeUserMap = new map<Id,User>();
    global map<Id,String> userMessage = new map<Id,String>();
    global map<Id, list<case>> finalCaseList = new map<Id, list<case>>();*/
    
    global SendCustomNotificationBatch(){
        /*for(User us :  [Select id, Name, userName from User where Name !='Boult Audio Admin' AND IsActive=true]) {
            activeUserMap.put(us.id, us);
            System.debug('user is :' + activeUserMap);
        }*/
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = '';
        
        if(Test.isRunningTest()){
            query = 'SELECT Id,CaseNumber,Status,OwnerId,Owner.Name,Owner.Type FROM Case limit 1';
            
        }
        /*else{
            //query = 'SELECT Id,CaseNumber,Status,OwnerId,Owner.Name,Owner.Type FROM Case WHERE Status != \'Resolved\' AND Status != \'Closed\' and (Owner.Name != \'Boult Audio Admin\') and Owner.Type != \'Queue\' and LastModifiedDate != LAST_N_DAYS:2';
        	query = 'SELECT Id,CaseNumber,Status,OwnerId,Owner.Name,Owner.Type FROM Case WHERE Status != \'Resolved\' AND Status != \'Closed\' and (Owner.Name != \'Boult Audio Admin\') and Owner.Type != \'Queue\' and (LastModifiedDate != TODAY and LastModifiedDate != YESTERDAY)';
        }*/
        
        return Database.getQueryLocator(query);
        
        
    }
    global void execute(Database.BatchableContext BC, List<Case> CaseRecord){
       	/*System.debug('=== userMessage ==='+userMessage);
       	System.debug('=== userMessage ==='+userMessage.size());
        
        map<string,list<case>> ownerWithCasesMap = new map<string,list<case>>();
        System.debug('OwnerWithCaseMap is ::' + ownerWithCasesMap);
        
        list<case> caseLists = new list<case>();
        for(case ca: CaseRecord){ 
            if(ownerWithCasesMap.get(ca.OwnerId) == null){
                ownerWithCasesMap.put(ca.OwnerId, new list<case>());
                finalCaseList.put(ca.OwnerId, new list<case>());
            }
            ownerWithCasesMap.get(ca.OwnerId).add(ca);
            finalCaseList.get(ca.OwnerId).add(ca);
            System.debug('Case Owner map is :' + ownerWithCasesMap);
        }*/
    }
    
    global void finish(Database.BatchableContext BC) {
        /*System.debug('===final map ==='+finalCaseList);
        System.debug('=== final map size ==='+finalCaseList.size());
        
        for(string c:finalCaseList.keySet()){
            system.debug('case owner Id is:'+c);
            //if(activeUserMap.containsKey(c)){
                system.debug('no of cases are :'+finalCaseList.get(c).size()+'ownerId is :'+c);
                string caseNumbers = '';
                for(integer i=0; i<finalCaseList.get(c).size(); i++){
                    caseNumbers = caseNumbers +finalCaseList.get(c)[i].CaseNumber+',';
                }
                String messageBody ='Your Total Pending Cases is :'+ finalCaseList.get(c).size()+ ' Here the list of cases : '+caseNumbers ;
                system.debug('case numbers are :'+caseNumbers);
                Messaging.CustomNotification obj = new Messaging.CustomNotification();
                obj.setNotificationTypeId(notificationType.Id);            
                obj.setTargetId(targetId);            
                obj.setTitle(title);            
                obj.setBody(messageBody);            
                obj.send(new set<string>{c});
            //}
        }*/
    }
}