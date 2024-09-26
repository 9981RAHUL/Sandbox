@isTest
public class SendCustomNotificationBatchTest {
    @isTest(SeeAllData=true) 
    
    static void test() {
        
        map<Id,String> userMessage = new map<Id,String>();
        map<string,list<case>> ownerWithCasesMap = new map<string,list<case>>();
        map<Id,User> activeUserMap = new map<Id,User>();
        String num ='';
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        Profile prof = [select id from profile where name LIKE '%marketing%'];
        
        user us = new user();
        us.LastName = 'last';
        us.Email = 'puser000@amamama.com';
        us.Username = 'puser000@amamama.com' + System.currentTimeMillis();
        us.CompanyName = 'TEST';
        us.Title = 'title';
        us.Alias = 'alias';
        us.ProfileId= prof.id;
        us.TimeZoneSidKey = 'America/Los_Angeles';
        us.EmailEncodingKey = 'UTF-8';
        us.LanguageLocaleKey = 'en_US';
        us.LocaleSidKey = 'en_US';
        us.UserRoleId = r.Id;
        insert us;  
        system.runAs(us){
            List<Case> cases = new List<Case>();
               List<Case> cases2 = new List<Case>();
          
               
                case cs = new case();
                
                cs.Status = 'Open';
                cs.Comments = 'Tests';
                cs.SuppliedEmail = 'test123@gmail.com';
                cs.OwnerId = '00G2w000000H0MtEAK';
                //cs.CaseNumber = i+1;
             
            insert cs; 
            //cases2 =[select id,CaseNumber from case where OwnerId ='00G2w000000H0MtEAK'];
        } 
        Test.startTest();
        
        SendCustomNotificationBatch uca = new SendCustomNotificationBatch();
        
        Id batchId = Database.executeBatch(uca,200);
        
        //Database.executeBatch(uca);
        system.debug('batchId'+batchId);
        system.assert(batchId!=null);
        Test.stopTest();
        
    }

}