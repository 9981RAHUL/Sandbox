/**
 * @description       : To provide OCR Functionality to re open the cases basis specfic keywords provided
 * @author            : Ajitesh Singh
 * @group             : 
 * @last modified on  : 12-18-2020
 * @last modified by  : Ajitesh Singh
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   12-18-2020   Ajitesh Singh   Initial Version
**/
public class EmailMessageTriggerHandler {
    /**
    * @description : Fetching the case ids and re opening the cases when required
    * @author Ajitesh Singh | 12-18-2020 
    * @param caseIds : Case Ids associated with the emails
    **/
    public static String RESOLVED_DISPATCHED = 'Delivered';
    public static String RESOLVED_STATUS = 'Resolved';
    public static String REOPEN_BUCKET = 'Re Open';
    public static String OPEN_STATUS = 'Open';
    public static String BUK_DEPT = 'CRM';
    public static  boolean firstRun = true;
    public static void ocrFunctionality(List<EmailMessage> emailMsgs){
        try{
            //Set<String> keywordsStr = new Set<String>([SElECT Keywords__c FROM OCR_Functionality__mdt LIMIT 1].Keywords__c.split(','));
            Set<Id> caseIds = new Set<Id>();
            List<Case> reopenCases = new List<Case>();
            //integer count;
            for(EmailMessage tempMsg : emailMsgs){
              /*  count = 0;
                for(String tempStr : keywordsStr){
                    if(tempMsg.TextBody.indexOf(tempStr) >= 0){
                        
                        count++;
                        break;
                    }
                }
                
                if(count == 0)
                {*/
                     caseIds.add(tempMsg.ParentId);
                       
               // }
            }
           
            //Bucket__c=: RESOLVED_DISPATCHED AND
            
            for(Case tempCase : [SELECT Bucket__c,Status,Bucket_Department__c FROM Case WHERE  Status =: RESOLVED_STATUS AND Id IN: caseIds AND Origin !='F1']){
                tempCase.Bucket__c = REOPEN_BUCKET;
                tempCase.Bucket_Department__c = BUK_DEPT;
                tempCase.Status = OPEN_STATUS;
                
                reopenCases.add(tempCase);
               
            }
            
            update reopenCases;
            
        }
        catch(Exception e){
            System.debug('Issue in OCR functionality due to '+e.getMessage());
        }
    }
    

     /*
* @description  : Check incoming emails and link current email with existing case(origin=email ) and remove duplicate. 
* @author       : Vishvambhar Singh | 10-01-2022 
**/
    public static void emailTrailE2C( List<EmailMessage> emailMsgs ){
        System.debug('EmailMessageTriggerHandler.emailTrailE2C');
        set<Id> caseIds = new set<Id>();
        set<Id> setIds = new set<Id>();
        set<String> emailSet = new set<String>();
        Map<String,String> emMap = new Map<String,String>();
        Map<String,List<Id>> caseMap = new Map<String,List<Id>>();
        List<EmailMessage> emailMsgList = new List<EmailMessage>();
        
        for( EmailMessage em : emailMsgs ){
            //System.debug('ThreadIdentifier '+em.ThreadIdentifier);
            //System.debug('Parent '+em.ParentId);
            System.debug('Incoming '+em.Incoming);
            System.debug('CaseOrigin '+em.CaseOrigin__c);
            if( em.FromAddress != Label.Boult_Support_Email ){
                emMap.put( em.Id, em.ParentId );
                caseIds.add( em.ParentId );
                emailSet.add( em.FromAddress );
            } 
            system.debug('List EmailMessage'+em);
        }
        System.debug('emailSet '+emailSet);
        for( Case c : [ select Id,Email__c from case where Origin = 'Email' and status != 'Closed' and Email__c IN: emailSet order by createdDate asc] ){
            if( caseMap.containsKey( c.Email__c ) )
            {
                list<Id> lstStr = caseMap.get( c.Email__c );
                lstStr.add( c.Id );
                caseMap.put( c.Email__c, lstStr );
            }
            else 
            {
                caseMap.put(c.Email__c, new list<Id>{c.Id});
            }
        }
        System.debug('caseMap '+caseMap);
        for( EmailMessage emailMsg : [SELECT Id, ParentId, ActivityId, CreatedById, SystemModstamp, TextBody, HtmlBody, Headers, Subject, FromName, FromAddress,  
                                      ToAddress, CcAddress, BccAddress, Incoming, HasAttachment, Status, ReplyToEmailMessageId, IsExternallyVisible, MessageIdentifier, 
                                      ThreadIdentifier, IsClientManaged, RelatedToId, IsTracked, IsOpened, FirstOpenedDate, LastOpenedDate, IsBounced, EmailTemplateId 
                                      FROM EmailMessage where Id IN:emMap.KeySet() ] )
        {
            List<Id> caseList = new List<Id>();
            caseList = caseMap.get( emailMsg.FromAddress );
            System.debug('caseList '+caseList);
            if( caseList!=null && caseList.size() > 0 ){
                /*
                EmailMessage em = new EmailMessage(
                    Id = emailMsg.Id,
                    ParentId = caseList[0]
                );
				*/
               
                EmailMessage em = new EmailMessage();
                em = emailMsg.clone( false, false, false, false );
                em.ParentId = caseList[0];
				 if( caseList[0] != emailMsg.ParentId ){
                    em = emailMsg.clone( false, false, false, false );
                    em.ParentId = caseList[0];
                    emailMsgList.add( em );
                    setIds.add( emailMsg.ParentId );
                }
                //caseList.remove(0);
                //System.debug('em '+em);
                System.debug('caseList '+caseList);
            }
        }
        System.debug('setIds '+setIds);
        Insert emailMsgList;
        System.debug('emailMsgList '+emailMsgList);
        Delete [select id from case where id IN : setIds];
    }
    
    public static void updateEmailDateOfCustomer(List<Case> newList, Map<Id, Case> OldMap){
        
    }
}