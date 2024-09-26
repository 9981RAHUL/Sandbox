/**
 * @description       : Email Alert when AWB No is less than 500 for a courier partner
 * @author            : Ajitesh Singh
 * @group             : 
 * @last modified on  : 12-15-2020
 * @last modified by  : Ajitesh Singh
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   12-15-2020   Ajitesh Singh   Initial Version
**/
public class AWBNoAlertEmail implements Queueable {
    /**
    * @description : Computation on execute method when AWB No is less than 500
    * @author Ajitesh Singh | 12-15-2020 
    * @param context : standard variable required when you implement queable class
    **/
    public void execute(QueueableContext context){
        try{
            AWB_Alert_Email_Setup__mdt mailSetup = [SELECT Subject__c,Threshold_No__c, User_Emails__c FROM AWB_Alert_Email_Setup__mdt LIMIT 1];
            List<String> courierPartnerName = new List<String>();
            for (AggregateResult ar : [SELECT Courier_Partner__c , Count(Id) FROM AWB__c WHERE IsUsed__c=false GROUP BY Courier_Partner__c ])  {
                if(((Integer)ar.get('expr0'))<mailSetup.Threshold_No__c){
                    courierPartnerName.add(ar.get('Courier_Partner__c')+' ('+ar.get('expr0')+')');       
                }
            }
            if(courierPartnerName.size() > 0){
                SendEmail(mailSetup.User_Emails__c, courierPartnerName, ((Integer)mailSetup.Threshold_No__c),mailSetup.Subject__c);
            }
        }
        catch(Exception e){
            System.debug('Error in sending email for AWB alert due to '+e.getMessage());
        }
    }
    public void SendEmail(String address, List<String> cp, Integer thresholdVal,String subject) {
        
        List<String> emails = new List<String>();
        List<id> ids = new List<id>();
        for (String email : address.split(',')) 
        {
           String tr = email.trim();
           if (tr.length() > 0)
               emails.add(tr);
          
       }
      
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String htmlBody = '<html><body><p>Dear Admin,<br><br>Following are the courier partner whose AWB No is less than '+thresholdVal+' : <br><ul>';
       for (String c : cp) 
       {
           htmlBody = htmlBody + '<li>'+c+'</li>';
       }
       htmlBody = htmlBody + '</ul><br><br><b>Regards,<br><br>Boult Audio</b></p></body></html>';
          mail.setHtmlBody(htmlBody);
           mail.setToAddresses(emails);
           mail.setSubject(subject);
           mail.setSaveAsActivity(false);
           mail.setUseSignature(false);
       List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
       allmsg.add(mail);
       
       try {
           Messaging.sendEmail(allmsg,false);
           return;
       } catch (Exception e) {
           System.debug(e.getMessage());
       }
       
       }
}