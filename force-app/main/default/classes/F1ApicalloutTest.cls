@isTest
public class F1ApicalloutTest {
    // Initialize CaseIds set at class level
    static Set<Id> CaseIds = new Set<Id>();

    @isTest
    public static void F1ApiTest(){
        Set<Id> CaseId =new Set<Id>();
        Product__c p = new Product__c();
        p.Box_Description__c = 'box';
        p.Quantity_Box__c = 2;
        p.Description__c = 'Product';
        p.Name ='box';
        insert p;

        Case cs = new Case();
        cs.Call_No__c = '125';
        cs.AWB_No__c ='143';
        cs.SuppliedEmail = 'abc@gmail.com';
        cs.SuppliedPhone = '9755996512';
        cs.Status = 'Open';
        cs.Courier_Partner_Name__c ='Blue Dart';
        cs.ORM_Recieving_Date__c =  system.today();
        cs.Outward_Ticket_receiving_Date__c = system.today();
        cs.Case_Closure_Reason_Open_as_Error_Open__c ='Battery Issue/Not working';
        cs.Product__c = p.Id;
        insert cs; 

        System.debug('---==='+cs.id);
        cs.Call_No__c = '126';
        cs.Origin = 'F1';
        update cs;

        // Adding cs.Id to CaseIds set
        CaseIds.add(cs.Id);

        test.startTest(); 
        F1Apicallout.F1caseupdation(CaseIds);
        test.stopTest();
    }
    
    @isTest
    public static void F1ApiTestException1(){
        Test.setMock(HttpCalloutMock.class, new F1ApicalloutMock());
        test.startTest(); 
        F1Apicallout.F1caseupdation(CaseIds);
        test.stopTest();
    }
    
    @isTest
    public static void F1ApiTestException(){
        test.startTest(); 
        F1Apicallout.F1caseupdation(null);
        test.stopTest();
    }
}