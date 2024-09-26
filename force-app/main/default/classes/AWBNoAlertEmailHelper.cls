/**
 * @description       : Email Alert when AWB No is less than 500 for a courier partner Schedulable apex
 * @author            : Ajitesh Singh
 * @group             : 
 * @last modified on  : 12-15-2020
 * @last modified by  : Ajitesh Singh
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   12-15-2020   Ajitesh Singh   Initial Version
**/
public class AWBNoAlertEmailHelper implements Schedulable {
    public void execute(SchedulableContext SC) {
        System.enqueueJob(new AWBNoAlertEmail());
    }  
}