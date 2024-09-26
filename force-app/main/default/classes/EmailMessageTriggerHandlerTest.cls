@isTest
public class EmailMessageTriggerHandlerTest {
    
    static testmethod void test1() {
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Goa',
            ShippingCountry = 'India',
            FirstName = 'Ram',
            LastName = 'SHyam',
            Salutation = 'Mr.',
            ShippingCity = 'Noida',
            PersonMobilePhone = '8375077127',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm@boult-audio.com'
        );
        insert acc;
        AWB__c aggr2=new AWB__c(
            Courier_Partner__c = 'Blue Dart',
            Name = '12345'
        );
        insert aggr2;  
        Product__c prod = new Product__c(
            name = 'ABC',
            Product_Color__c = 'Black',
            Box_Description__c = 'Desc',
            Description__c = 'desc',
            Quantity_Box__c = 123
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='CRM_Agents'];
        Group gr=g[0];
        Case cs2=new Case(
            Contact_Name__c = acc.id,
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Serviceability__c = serv.id,
            Bucket__c = 'Closed',
            Status = 'Resolved',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234567890',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Mic Issue'
            
        );
        insert cs2;
        cs2.Status = 'Resolved';
        cs2.Bucket__c = 'Re Open';
        cs2.Bucket_Department__c = 'CRM';
        
        cs2.Comments = 'jkjk';
        update cs2;
        EmailMessage em = new EmailMessage(
            ParentId = cs2.id,
            TextBody = 'mnmnmnm',
            FromName = 'Himanshu',
            FromAddress = 'hmny0079@gmail.com',
            ToAddress = 'himanshu@cloud-icon.com',
            subject ='Mic issue'        
        );
        Case cs3=new Case(
            Contact_Name__c = acc.id,
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Serviceability__c = serv.id,
            Bucket__c = 'Closed',
            Status = 'Resolved',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234567890',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Mic Issue'
        );
        insert cs3;
        EmailMessage em2 = new EmailMessage(
            ParentId = cs3.id,
            TextBody = 'please hel me for my issue Thankyou Thank you, this is troubling me',
            FromName = 'Himanshu',
            FromAddress = 'himanshu@cloud-icon.com',
            ToAddress = 'himanshu@cloud-icon.com',
            subject ='Mic issue'
        );
        Test.startTest();
        insert em;
        insert em2;
        Test.stopTest();
        
    }
    
    static testmethod void emailTrailE2CTest() {
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Goa',
            ShippingCountry = 'India',
            FirstName = 'Ram',
            LastName = 'SHyam',
            Salutation = 'Mr.',
            ShippingCity = 'Noida',
            PersonMobilePhone = '8375077127',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm@boult-audio.com'
        );
        insert acc;
        AWB__c aggr2=new AWB__c(
            Courier_Partner__c = 'Blue Dart',
            Name = '12345'
        );
        insert aggr2;  
        Product__c prod = new Product__c(
            name = 'ABC',
            Product_Color__c = 'Black',
            Box_Description__c = 'Desc',
            Description__c = 'desc',
            Quantity_Box__c = 123
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='CRM_Agents'];
        Group gr=g[0];
        Case cs2=new Case(
            Contact_Name__c = acc.id,
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Serviceability__c = serv.id,
            Origin = 'Email',
            Status = 'Open',
            Disposition_Input__c = 'Troubleshoot request',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234567890',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Mic Issue'
            
        );
        insert cs2;
        
        EmailMessage em = new EmailMessage(
            ParentId = cs2.id,
            TextBody = 'mnmnmnm',
            FromName = 'Himanshu',
            Incoming = true,
            FromAddress = 'xyz09@gmail.com',
            ToAddress = 'himanshu@cloud-icon.com',
            subject ='Mic issue'        
        );
        Case cs3=new Case(
            Contact_Name__c = acc.id,
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Serviceability__c = serv.id,
            Origin = 'Email',
            Disposition_Input__c = 'Troubleshoot request',
            Status = 'Open',
            OwnerId = gr.id,
            SuppliedEmail= em.FromAddress,
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234567890',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Mic Issue'
        );
        insert cs3;
        EmailMessage em2 = new EmailMessage(
            ParentId = cs3.id,
            TextBody = 'please hel me for my issue Thankyou Thank you, this is troubling me',
            FromName = 'Himanshu',
            Incoming = true,
            FromAddress = 'xyz09@gmail.com',
            ToAddress = 'himanshu@cloud-icon.com',
            subject ='Mic issue'
        );
        Test.startTest();
        insert em;
        insert em2;
        Test.stopTest();
        
    }
    
}