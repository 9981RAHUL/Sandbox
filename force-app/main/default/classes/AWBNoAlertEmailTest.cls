@isTest
public class AWBNoAlertEmailTest {
static testmethod void test1() {
        Test.startTest();     
    	AWB__c aggr=new AWB__c(
        Courier_Partner__c = 'India Post',
        Name = '12345'
        );
    insert aggr;
     //  System.enqueueJob(new AWBNoAlertEmail());
    AWBNoAlertEmailHelper awbhlp = new AWBNoAlertEmailHelper();
    SchedulableContext sc = null;
    awbhlp.execute(sc);
        Test.stopTest();
}
}