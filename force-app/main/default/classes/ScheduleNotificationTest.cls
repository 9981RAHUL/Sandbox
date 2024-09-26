@isTest
public class ScheduleNotificationTest {
    @isTest
    public static void TestScheduled (){ 
        Test.startTest(); 
        ScheduleNotification sh1 = new ScheduleNotification();  
        String cronExp ='0 12 17 ? * * *'; 
        System.schedule('JobName', cronExp,  sh1);
        Test.stopTest();          
    } 
}