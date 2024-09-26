@isTest
public class UserAssignmentControllerTest {
    
    @isTest
    public static void userAssign(){  
        String searchKey ='test';
        string mailId ='body';
        string caseId ='c1';
        
        EmailMessage emailMsg = new EmailMessage();
        emailMsg.FromName = 'Devendar';
        emailMsg.Subject ='mankar';
        insert emailMsg;
        
        case c = new case();
        c.SuppliedEmail ='nazeem@gmail.com';
        c.Adjusted_Amount__c ='1000';
        insert c;
        
        case c2 = new case();
        c2.SuppliedEmail ='nazeem@gmail.com';
        c2.Adjusted_Amount__c ='1000';
        c2.SourceId = emailMsg.Id;
        insert c2;
        
        
        OrgWideEmailAddress orgWide = new OrgWideEmailAddress();
        orgWide.Address ='nazeem@gmail.com';
        orgWide.DisplayName ='nazeem';
        
        
        EmailMessage em = new EmailMessage();
        em.Subject = 'chetna';
        em.HtmlBody ='boultAudio Address';
        em.ToAddress = orgWide.Address;
        insert em;
        
        
        test.startTest();
        UserAssignmentController.getUserList(searchKey);
        UserAssignmentController.search(searchKey);
        UserAssignmentController.getEmailTemplate();
        UserAssignmentController.getEmailTemplateBody(mailId);
        UserAssignmentController.getCaseEmail(c.Id);
        UserAssignmentController.getCaseRecord(c2.Id);
        UserAssignmentController.CaseEmailDetial(em.HtmlBody, em.subject, em.ToAddress);
        UserAssignmentController.CaseEmails(c, em.Id);
        test.stopTest();
    }  
}