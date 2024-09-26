@isTest
public class CaseTriggerHandlerTest {
    @testSetup static void setupdata()
    {
        
        list<Profile> prof= [ SELECT id FROM Profile WHERE Name='ORM'];
        list<UserRole> role= [ SELECT id FROM UserRole WHERE Name='Associate L2'];
        
        User usrcreate = new User(
            ProfileId = prof[0].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser0003232@amamama.com',
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = role[0].Id
        );
        insert usrcreate;
        list<Profile> prof2= [ SELECT id FROM Profile WHERE Name='CRM'];
        list<UserRole> role2= [ SELECT id FROM UserRole WHERE Name='Associate L1'];
        
        User usrcreate2 = new User(
            ProfileId = prof2[0].Id,
            LastName = 'last2',
            Email = 'puser000123@amamama.com',
            Username = 'puser0012340@amamama.com',
            CompanyName = 'TEST1',
            Title = 'title2',
            Alias = 'alias2',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = role2[0].Id
        );
        insert usrcreate2;
        
        List<EmailTemplate> emList = new List<EmailTemplate>();
        EmailTemplate e1 = new EmailTemplate (developerName = 'test1', FolderId =UserInfo.getUserId(), TemplateType= 'Text', Name = Label.Product_Delivered_Notification);emList.add(e1);
        EmailTemplate e2 = new EmailTemplate (developerName = 'test2', FolderId =UserInfo.getUserId(), TemplateType= 'Text', Name = Label.Outward_Team_Shipped_Status_email);emList.add(e2);
        EmailTemplate e3 = new EmailTemplate (developerName = 'test3', FolderId =UserInfo.getUserId(), TemplateType= 'Text', Name = Label.Partial_Product_Received_TWS_Product);emList.add(e3);
        EmailTemplate e4 = new EmailTemplate (developerName = 'test4', FolderId =UserInfo.getUserId(), TemplateType= 'Text', Name = Label.Physically_Damaged_Product_Received);emList.add(e4);
        EmailTemplate e5 = new EmailTemplate (developerName = 'test5', FolderId =UserInfo.getUserId(), TemplateType= 'Text', Name = Label.Different_Product_Received);emList.add(e5);
       
    }
   /* static testmethod void test1() {
        Test.startTest();
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='Email',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'ORM',
            Bucket__c = 'Delivered',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        ); 
        insert cs;
        
        EmailMessage insetEmailObj=new EmailMessage();
        insetEmailObj.parentId=cs.Id;
        insetEmailObj.Subject='Test';
        insetEmailObj.TextBody=cs.Description;
        insetEmailObj.FromAddress=cs.SuppliedEmail;
        insetEmailObj.ToAddress='xyz@jd.c';
        insert insetEmailObj;
        
        Case csWeb=new Case(
            Contact_Name__c = acc.id,
            Origin='Web',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Serviceability__c = serv.id,
            Bucket_Department__c = 'CRM',
            Courier_Partner_Name__c = 'Blue Dart',
            Bucket__c = 'In Review',
            OwnerId = gr.id,
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234567390'
        ); 
        insert csWeb;
        
        csWeb.Bucket__c = 'Re Open';
        update csWeb;
        
        Case csReOpen=new Case(
            Contact_Name__c = acc.id,
            Origin='Email',
            Disposition_Input__c= 'Ticket Status',
            Description = 'Test', 
            Subject = 'Test',    
            AWB__c = aggr2.id,
            Status = 'Open',
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Serviceability__c = serv.id,
            Bucket_Department__c = 'ORM',
            Bucket__c = 'Re Open',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            SuppliedEmail='xyz0079@gmail.com'
        ); 
        insert csReOpen;
        
        user u=[Select id from user where username = 'puser0003232@amamama.com'];
        //cs.Bucket__c = 'Waiting on Customer';
        list<Group> g2= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='Resolved_Cases'];
        Group gr2=g2[0];
        user usr=[Select id from user where username = 'puser0012340@amamama.com'];
        System.runAs(u)//login as CRM
        {
            cs.OwnerId = u.id;
            update cs;
        }
        cs.OwnerId = gr2.id;
        update cs;
        cs.OwnerId = u.id;
        update cs;
        
        System.runAs(u)//login as inward
        {
            cs.Bucket_Department__c = 'ORM';
            cs.Bucket__c = 'RTO Cases/Shipped/ORM';
            // cs.OwnerId = usr.id;
            update cs;
        }
        Test.stopTest(); 
    }*/
    
    static testmethod void sendWhatsApptest() {
        Test.startTest();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Goa',
            ShippingCountry = 'India',
            FirstName = 'Ram1',
            LastName = 'SHyam1',
            Salutation = 'Mr.',
            ShippingCity = 'Noida',
            PersonMobilePhone = '8375077128',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
        );
        insert acc;
        
        AWB__c aggr2=new AWB__c(
            Courier_Partner__c = 'Blue Dart',
            Name = '12346'
        );
        insert aggr2;  
        
        Product__c prod = new Product__c(
            name = 'ABC',
            Product_Color__c = 'Black',
            Box_Description__c = 'Desc',
            Description__c = 'desc',
            Quantity_Box__c = 123.00
        );
        insert prod;
        
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        // EmailTemplate e = new EmailTemplate (developerName = Label.EmailTemplateName, TemplateType= 'Text', Name = 'test'); // plus any other fields that you want to set
        //
        //insert e;
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='Email',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product__c = prod.id,
            SuppliedPhone = '1234565890',
            Serviceability__c = serv.id,
            //Bucket__c = 'In Transit',
            Case_Closure_Reason_Open_as_Error_Open__c = 'In Transit',
            //OwnerId = gr.id,
            SuppliedEmail='xyz0078@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Ujjain',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            Product_Color__c = 'Black',
            Bucket_Department__c = 'CRM',
            Bucket__c = 'In Review'
        ); 
        insert cs;
        System.debug('test case '+cs);
        
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'CRM';
        cs.Bucket__c = 'Delivered';
        update cs;
        CaseTriggerHandler.firstRun = false;
        cs.Bucket_Department__c = 'CRM';
        cs.Bucket__c = 'Delivered';
        update cs;
        System.debug('test case '+cs);
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Service';
        cs.Bucket__c = 'Repair';
        update cs;
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Inward';
        cs.Bucket__c = 'Correct product received';
        update cs;
        System.debug('test case '+cs);
        
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';   
        cs.Courier_Partner_Name__c = 'India Post'; 
        update cs;
        System.debug('test case '+cs);
        
        CaseTriggerHandler.firstRun = true;
        //cs.Bucket__c = 'RTO Cases/Shipped';  
        cs.Courier_Partner_Name__c = 'Blue Dart'; 
        update cs;
        System.debug('test case '+cs);
        
        
        // MessageClass.sendWhatsApp(cs.id);
        SMSTextUtility.orderDeliveredText('Test', '12345');
        SMSTextUtility.orderDispatchText('Test', '12345');
        SMSTextUtility.orderReceivedAtWarehouseText('Test', '12345');
        SMSTextUtility.orderTrackingOnly_D2CText('Test', '12345');
        SMSTextUtility.productPurchaseText('Test', '12345');
        SMSTextUtility.shipmentInfoText('Test', '12345');
        SMSTextUtility.outwardTeamShippedStatusText('Test');
        SMSTextUtility.orderDispatchedViaIndiaPostText('Test', '12345', '123556');
        SMSTextUtility.orderDispatchedViaShipRocketText('Test', '12345', '123556');
        SMSTextUtility.orderDispatchedViaBlueDartText('Test', '12345', '123556');
        Test.stopTest();
    }
    
    static testmethod void sendWhatsApptest2() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Nazeem',
            LastName = 'Pathan',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='web',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'ORM',
            Bucket__c = 'Delivered',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'CRM';
        cs.Bucket__c = 'Delivered';
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Service';
        cs.Bucket__c = 'Replaceable in stock';
        update cs;
        
        Test.stopTest();
    }
    
    static testmethod void sendWhatsApptest3() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Nazeem',
            LastName = 'Pathan',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
        );
        insert acc;
        AWB__c aggr2=new AWB__c(
            Courier_Partner__c = 'ShipRocket',
            Name = '12345'
        );
        insert aggr2;  
        Product__c prod = new Product__c(
            name = 'ABC',
            Product_Color__c = 'Black',
            Box_Description__c = 'Desc',
            Description__c = 'desc',
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='web',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'ORM',
            Bucket__c = 'Delivered',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'CRM';
        cs.Bucket__c = 'Delivered';
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        Test.stopTest();
    }
    
    
    static testmethod void sendWhatsApptest4() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Nazeem',
            LastName = 'Pathan',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='web',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'ORM',
            Bucket__c = 'Delivered',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Inward';
        cs.Bucket__c = 'Correct product received';
        update cs;
        
        
        Test.stopTest();
    }
    
    
    
    
    static testmethod void customerAutoTaggingTest(){
        Product__c p = new Product__c();
        p.Box_Description__c = 'box';
        p.Quantity_Box__c = 222.00;
        p.Description__c = 'this is long text';
        p.Name ='box';
        insert p;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        
        Account personAcc = new Account(
            
            FirstName = 'test', LastName = 'person account',
            PersonEmail = 'personacc@demo.com', PersonMobilePhone = '9876543210',
            ShippingCity = 'Agra', ShippingPostalCode = string.valueOf(123456),
            ShippingState = 'UP', ShippingStreet = 'test street',
            ShippingCountry = 'India', RecordTypeId = strRecordTypeId
        );
        insert personAcc;
        
        Case csWeb=new Case(
            Origin='Web',
            SuppliedName = 'Test PersonAccount',
            SuppliedPhone = '1244567890',
            Address_street__c = 'Adress Street',
            City__c = 'Bhopal',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            Product__c = p.Id,
            Product_Color__c = 'Black',
            Bucket_Department__c = 'CRM',
            Bucket__c = 'In Transit',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            SuppliedEmail='personacc@demo.com'
            
        ); 
        insert csWeb;
        Product__c p1 = new Product__c();
        p1.Box_Description__c = 'box';
        p1.Quantity_Box__c = 222.00;
        p1.Description__c = 'this is long text';
        p1.Name ='Curve Black';
        insert p1;
        
          Case csWe=new Case(
            Origin='Web',
            SuppliedName = 'Test PersonAccount',
            SuppliedPhone = '1244567890',
            Address_street__c = 'Adress Street',
            City__c = 'Bhopal',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            Product__c = p1.Id,
            Product_Color__c = 'Black',
            Bucket_Department__c = 'CRM',
            Bucket__c = 'In Warranty',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            SuppliedEmail='personacc@demo.com'
            
        ); 
        insert csWe;
        
        
    }
    
    
    
    static testmethod void sendWhatsApptest5() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Nazeem',
            LastName = 'Pathan',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
        );
        insert acc;
        AWB__c aggr2=new AWB__c(
            Courier_Partner__c = 'ShipRocket',
            Name = '12345'
        );
        insert aggr2;  
        Product__c prod = new Product__c(
            name = 'ABC',
            Product_Color__c = 'Black',
            Box_Description__c = 'Desc',
            Description__c = 'desc',
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='web',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'ORM',
            Bucket__c = 'Delivered',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'CRM';
        cs.Bucket__c = 'Delivered';
        update cs;
        
        
        Test.stopTest();
    }
    
    
    static testmethod void sendWhatsApptest6() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Nazeem',
            LastName = 'Pathan',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
        );
        insert acc;
        AWB__c aggr2=new AWB__c(
            Courier_Partner__c = 'ShipRocket',
            Name = '12345'
        );
        insert aggr2;  
        Product__c prod = new Product__c(
            name = 'ABC',
            Product_Color__c = 'Black',
            Box_Description__c = 'Desc',
            Description__c = 'desc',
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='web',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Disposition_Input__c= 'Junk Email',
            Call_No__c = '1234867890',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'ORM',
            Bucket__c = 'Delivered',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        
        
        Test.stopTest();
    }
    
    
    
    static testmethod void customerAutoTaggingTest2(){
        Product__c p = new Product__c();
        p.Box_Description__c = 'box';
        p.Quantity_Box__c = 220.00;
        p.Description__c = 'Product';
        p.Name ='box';
        insert p;
        Case csWeb1=new Case(
            Origin='Web',
            SuppliedName = 'Test Person Account',
            SuppliedPhone = '1244078900',
            Address_street__c = 'Adress Street',
            City__c = 'Bhopal',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123457',
            Country__c = 'India',
            Call_No__c = '1234867890',
            Product_Color__c = 'Black',
            Bucket_Department__c = 'CRM',
            Product__c = p.Id,
            Description = 'Mic Issue',
            Bucket__c = 'In Transit',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            SuppliedEmail='personacc1937@demo.com'
        ); 
        insert csWeb1;
    }
    
    static testmethod void customerAutoTaggingTest3(){
        
        Product__c p = new Product__c();
        p.Box_Description__c = 'box';
        p.Quantity_Box__c = 220.00;
        p.Description__c = 'Product';
        p.Name ='box';
        insert p;
        
        Case csF1=new Case(
            Origin='F1',
            SuppliedName = 'TestAccount Account',
            SuppliedPhone = '1244078900',
            Address_street__c = 'Adress Street',
            Call_No__c = '1234867890',
            City__c = 'Bhopal',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123457',
            Country__c = 'India',
            Product__c = p.Id,
            Product_Color__c = 'Black',
            Bucket_Department__c = 'CRM',
            Bucket__c = 'In Transit',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            SuppliedEmail='personacc1942@demo.com'
        ); 
        insert csF1;
        
        CaseTriggerHandler.firstRun = true;
        csF1.Bucket_Department__c = 'ORM';
        csF1.SuppliedPhone = '1244078900';
        
        update csF1;
    }
    
    
    @istest
    public static void ReopenDataMethod(){
        Case cs = new Case();
        cs.Status ='Open';
        cs.SuppliedEmail ='arpit@gmail.com';
        cs.Bucket__c ='Delivered';
        cs.Case_Re_Open_Resolution_Reason__c ='Left/Right Side not working';
        cs.Origin ='Email';
        cs.Email__c ='arpit@gmail.com';
        insert cs;
        
        cs.Case_Re_Open_Resolution_Reason__c ='Left/Right Side not working';
        cs.Reopen_Count_New__c = 1;
        cs.Bucket__c ='Re Open';
        update cs;
        
        BucketData__c bucketData = new BucketData__c();
        bucketData.CaseId__c =cs.Id;
        bucketData.Re_Open_Resolution_Reason1__c =cs.Case_Re_Open_Resolution_Reason__c;
        bucketData.total_ReOpen__c =cs.Reopen_Count_New__c;
        insert bucketData;
        
        cs.Bucket__c ='Re Open';
        cs.Reopen_Count_New__c = 2;
        update cs;
        
        test.startTest();
        ReOpenData.NewReOpenDataMethod(cs.Id);   
        test.stopTest();
    }
    
    /*@isTest
    private static void updateWarehouse(){
        WareHouse__c wr = new WareHouse__c();
        wr.Phone__c = '8817115911';
        wr.City__c= 'New Delhi';
        wr.Name = 'Exotic Mile Private Limited';
        wr.Pin_Code__c= '110052';
        wr.Address__c= 'B-67, Wazirpur Industrial Area, New Delhi';
        wr.Country__c= 'India';
        wr.Email__c= 'admin@boultaudio.com';
        wr.Registered_Name__c= 'EXOTICB2C-B2C';
        wr.Return_Address__c= 'B-67, Wazirpur Industrial Area, New Delhi';
        wr.Return_Pin_Code__c= '110052';
        wr.Return_City__c= 'New Delhi';
        wr.Return_State__c= 'Delhi';
        wr.Return_Country__c= 'India';
        insert wr;
        
        Case cas = new Case();
        cas.SuppliedName = 'test';
        cas.SuppliedPhone = '9554848560';
        cas.SuppliedEmail = 'sup@gmail.com';
        cas.Courier_Partner_Name__c = 'Delhivery';
        
        insert cas;
    }*/
    
    static testmethod void sendWhatsApptest7() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='web',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'ORM',
            Bucket__c = 'Delivered',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'CRM';
        cs.Bucket__c = 'Delivered';
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Service';
        cs.Bucket__c = 'Repair';
        update cs;
        
        Test.stopTest();
    }
    
    static testmethod void sendWhatsApptest8() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='web',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'ORM',
            Bucket__c = 'Delivered',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'CRM';
        cs.Bucket__c = 'Delivered';
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Service';
        cs.Bucket__c = 'Replaceable in stock';
        update cs;
        
        Test.stopTest();
    }
    
    static testmethod void sendWhatsApptest9() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='web',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'ORM',
            Bucket__c = 'Delivered',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'CRM';
        cs.Bucket__c = 'Delivered';
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Service';
        cs.Bucket__c = 'Replaceable out of stock';
        update cs;
        
        Test.stopTest();
    }
    
    static testmethod void sendWhatsApptest10() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='web',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'ORM',
            Bucket__c = 'Delivered',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'CRM';
        cs.Bucket__c = 'Delivered';
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Service';
        cs.Bucket__c = 'Replaceable out of Stock/CRM/Service';
        update cs;
        
        Test.stopTest();
    } 
    
    static testmethod void sendWhatsApptest11() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='web',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'ORM',
            Bucket__c = 'Delivered',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'CRM';
        cs.Bucket__c = 'Delivered';
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Inward';
        cs.Bucket__c = 'Different Brand Product';
        update cs;
        
        Test.stopTest();
    }
    
    static testmethod void sendWhatsApptest12() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='web',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'ORM',
            Bucket__c = 'Delivered',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'CRM';
        cs.Bucket__c = 'Delivered';
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Inward';
        cs.Bucket__c = 'Partial product';
        update cs;
        
        Test.stopTest();
    } 
    
    static testmethod void sendWhatsApptest13() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='web',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'ORM',
            Bucket__c = 'Delivered',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'CRM';
        cs.Bucket__c = 'Delivered';
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Inward';
        cs.Bucket__c = 'Physically damaged';
        update cs;
        
        Test.stopTest();
    }
    
    static testmethod void sendWhatsApptest14() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='web',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'ORM',
            Bucket__c = 'Delivered',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'CRM';
        cs.Bucket__c = 'Delivered';
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Inward';
        cs.Bucket__c = 'DBAPR(Different BoultAudio Product Received)';
        update cs;
        
        Test.stopTest();
    }    

    static testmethod void sendWhatsApptest15() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='F1',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = null,
            Bucket__c = null,
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        Test.stopTest();
    }  
    
    static testmethod void sendWhatsApptest16() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='F1',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = null,
            Bucket__c = null,
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Status = 'Resolved';
        cs.Bucket_Department__c = 'CRM';
        cs.Bucket__c = 'Delivered';
        update cs;
    
        Test.stopTest();
    }    
    
    static testmethod void sendWhatsApptest17() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='F1',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = null,
            Bucket__c = null,
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Status = 'Resolved';
        cs.Bucket_Department__c = 'Service';
        cs.Bucket__c = 'Replaceable in stock';
        update cs;
		Test.stopTest();
    } 
    
    static testmethod void sendWhatsApptest18() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='F1',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = null,
            Bucket__c = null,
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Courier_Partner_Name__c = 'Blue Dart';
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        update cs;
		Test.stopTest();
    }
    
    static testmethod void sendWhatsApptest19() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='F1',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = null,
            Bucket__c = null,
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Courier_Partner_Name__c = 'India Post';
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        update cs;
		Test.stopTest();
    }
    
    static testmethod void sendWhatsApptest20() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='F1',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = null,
            Bucket__c = null,
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Courier_Partner_Name__c = 'ShipRocket';
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        update cs;
		Test.stopTest();
    }
    
    static testmethod void sendWhatsApptest21() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='F1',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = null,
            Bucket__c = null,
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'India Post'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'ShipRocket'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Bucket_Department__c = 'Outward';
        cs.Bucket__c = 'Serviceable/Shipped';
        cs.Courier_Partner_Name__c = 'Blue Dart'; 		
        update cs;
        
        CaseTriggerHandler.firstRun = true;
        cs.Status = 'Pending';
        cs.Bucket_Department__c = 'Service';
        cs.Bucket__c = 'Replaceable out of stock';
        update cs;
		Test.stopTest();
    }
    
    static testmethod void sendWhatsApptestInsertCase() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='web',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'CRM',
            Bucket__c = 'In Transit',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        Test.stopTest();
    }
    
    static testmethod void sendWhatsApptestInsertCase2() {
        Test.startTest();
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Origin='web',
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'Open',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'CRM',
            Bucket__c = 'In Review',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890'
        );
        insert cs;
        Test.stopTest();
    }
    
	@isTest
	 static void testCalculateWaitingDate() {
    // Test Data Setup: Define holiday dates
    Set<Date> holidayDays = new Set<Date>{
        Date.newInstance(2024, 8, 28),  // Holiday on 2024-08-28
        Date.newInstance(2024, 9, 1)    // Another holiday on 2024-09-01
    };

    Double noOfDay = 5.0;  // Test with 5 working days
    
    // Call the method being tested
    Date resultDate = CaseTriggerHandler.calculateWaitingDate(noOfDay, holidayDays);
    
    // The expected result after accounting for weekends and holidays
    Date expectedDate = Date.newInstance(2024, 9, 3);  // Monday, 2024-09-02

    // Assert the results
    System.assertEquals(expectedDate, resultDate, 'The calculated waiting date should match the expected date.');
}

@isTest
static void testSetCounterOnCase() {
    // Prepare test data
    List<Case> cases = new List<Case>();
    Map<String, Double> counterMap = new Map<String, Double>();
    Double maxCounter = 5.0;
    
    // Fetch an active user
    User activeUser = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 1];
    
    // Sample cases with valid picklist values and supplied email
	String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account acc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra',
            LastName = 'Mankar',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702471',
            RecordTypeId = strRecordTypeId,
            PersonEmail = 'orm1@boult-audio.com'
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
            Quantity_Box__c = 123.00
        );
        insert prod;
        Serviceability__c serv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert serv;
        list<Group> g= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group gr=g[0];
        Case cs=new Case(
            Contact_Name__c = acc.id,
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234867890',
            AWB__c = aggr2.id,
            Product_Color__c = 'Black',
            Product__c = prod.id,
            Status = 'New', 
			Origin = 'Web',
            Serviceability__c = serv.id,
            Bucket_Department__c = 'CRM',
			Bucket__c = 'In Transit',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = gr.id,
            SuppliedEmail='xyz0079@gmail.com',
            SuppliedName = 'Test PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867890',
			Waiting_Date__c= Date.valueOf('2024-08-30')
        );
	String strRecordTypeIds = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
        Account accc= new Account(
            ShippingPostalCode = '800001',
            ShippingStreet = 'A12',
            ShippingState = 'Manipur',
            ShippingCountry = 'India',
            FirstName = 'Devendra1',
            LastName = 'Mankar1',
            Salutation = 'Mr.',
            ShippingCity = 'Delhi',
            PersonMobilePhone = '9131702472',
            RecordTypeId = strRecordTypeIds,
            PersonEmail = 'orm111@boult-audio.com'
        );
        insert accc;
        AWB__c aggr22=new AWB__c(
            Courier_Partner__c = 'Blue Dart',
            Name = '123457'
        );
        insert aggr22;  
        Product__c prodd = new Product__c(
            name = 'ABC',
            Product_Color__c = 'Black',
            Box_Description__c = 'Desc',
            Description__c = 'desc',
            Quantity_Box__c = 120.00
        );
        insert prodd;
        Serviceability__c servv = new Serviceability__c(
            name = acc.ShippingPostalCode,
            Courier_Partner__c = 'India Post'
        );
        insert servv;
        list<Group> gg= [ SELECT id FROM Group WHERE Type = 'Queue' and developerName='ORM_Agents'];
        Group grr=gg[0];
        Case cs2=new Case(
            Contact_Name__c = accc.id,
            Disposition_Input__c= 'Invoice Received',
            Call_No__c = '1234888890',
            AWB__c = aggr22.id,
            Product_Color__c = 'Black',
            Product__c = prodd.id,
            Status = 'New', 
			Origin = 'Web',
            Serviceability__c = servv.id,
            Bucket_Department__c = 'CRM',
			Bucket__c = 'In Transit',
            Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
            OwnerId = grr.id,
            SuppliedEmail='xyz00799@gmail.com',
            SuppliedName = 'Test1 PersonAccount',
            Address_street__c = 'Adress Street',
            City__c = 'Indore',
            State__c = 'Madhya Pradesh',
            Pin_Code__c = '123456',
            Country__c = 'India',
            SuppliedPhone = '1234867899',
			Waiting_Date__c= Date.valueOf('2024-08-30')
        );
    cases.add(cs);
    cases.add(cs2);
    
    insert cases;
    
    // Sample counter map
    counterMap.put('In Transit', 3.0); // Use valid bucket values
    counterMap.put('Delivered', 2.0); // Use valid bucket values
    
    // Insert holiday records
    List<Holiday_Matrix__c> holidays = new List<Holiday_Matrix__c>{
        new Holiday_Matrix__c(Date__c = System.today().addDays(1)), // Ensure this date is not a weekend
        new Holiday_Matrix__c(Date__c = System.today().addDays(3))
    };
    insert holidays;
    
    // Call the method to test
    Test.startTest();
    CaseTriggerHandler.setCounterOnCase(cases, counterMap, maxCounter);
    Test.stopTest();
    
    // Verify the result
    for (Case tempCase : [SELECT Id, Waiting_Date__c, Bucket__c FROM Case WHERE Id IN :cases]) {
        System.debug('Case ID: ' + tempCase.Id + ', Bucket: ' + tempCase.Bucket__c + ', Waiting Date: ' + tempCase.Waiting_Date__c);
        
        // Calculate expected waiting date based on the test setup
        Double counterValue = counterMap.get(tempCase.Bucket__c);
        Date expectedDate = System.today().addDays(counterValue.intValue());
        system.debug('expected Date'+expectedDate);
        system.debug('counterValue'+counterValue);
        
        
        System.assertEquals(expectedDate, tempCase.Waiting_Date__c, 'The calculated waiting date should match the expected date.');
    }
}


@isTest
static void testCreateResolvedCase() {
    // Prepare test data
    List<Case> cases = new List<Case>();
    Map<Id, Case> oldCaseMap = new Map<Id, Case>();
    
    // Fetch an active user
    User activeUser = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 1];
    
    // Sample cases with valid picklist values and supplied email
    String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Person Account'].Id;
    Account acc = new Account(
        ShippingPostalCode = '800001',
        ShippingStreet = 'A12',
        ShippingState = 'Manipur',
        ShippingCountry = 'India',
        FirstName = 'Devendra',
        LastName = 'Mankar',
        Salutation = 'Mr.',
        ShippingCity = 'Delhi',
        PersonMobilePhone = '9131702471',
        RecordTypeId = strRecordTypeId,
        PersonEmail = 'orm1@boult-audio.com'
    );
    insert acc;

    AWB__c aggr2 = new AWB__c(
        Courier_Partner__c = 'Blue Dart',
        Name = '12345'
    );
    insert aggr2;  
    
    Product__c prod = new Product__c(
        name = 'ABC',
        Product_Color__c = 'Black',
        Box_Description__c = 'Desc',
        Description__c = 'desc',
        Quantity_Box__c = 123.00
    );
    insert prod;

    Serviceability__c serv = new Serviceability__c(
        name = acc.ShippingPostalCode,
        Courier_Partner__c = 'India Post'
    );
    insert serv;

    // Create first test case with User as Owner
    Case cs = new Case(
        Contact_Name__c = acc.id,
        Disposition_Input__c = 'Invoice Received',
        Call_No__c = '1234867890',
        AWB__c = aggr2.id,
        Product_Color__c = 'Black',
        Product__c = prod.id,
        Status = 'Resolved', 
        Origin = 'Web',
        Serviceability__c = serv.id,
        Bucket_Department__c = 'CRM',
        Bucket__c = 'In Transit',
        Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
        OwnerId = activeUser.Id,  // Assigning active user as Owner
        SuppliedEmail = 'xyz0079@gmail.com',
        SuppliedName = 'Test PersonAccount',
        Address_street__c = 'Adress Street',
        City__c = 'Indore',
        State__c = 'Madhya Pradesh',
        Pin_Code__c = '123456',
        Country__c = 'India',
        SuppliedPhone = '1234867890',
        Waiting_Date__c = Date.valueOf('2024-08-30')
    );
    cases.add(cs);

    // Create second test case with User as Owner
    Case cs2 = new Case(
        Contact_Name__c = acc.id,
        Disposition_Input__c = 'Invoice Received',
        Call_No__c = '1234888890',
        AWB__c = aggr2.id,
        Product_Color__c = 'Black',
        Product__c = prod.id,
        Status = 'Resolved', 
        Origin = 'Web',
        Serviceability__c = serv.id,
        Bucket_Department__c = 'CRM',
        Bucket__c = 'In Transit',
        Case_Closure_Reason_Open_as_Error_Open__c = 'Delivered',
        OwnerId = activeUser.Id,  // Assigning active user as Owner
        SuppliedEmail = 'xyz00799@gmail.com',
        SuppliedName = 'Test1 PersonAccount',
        Address_street__c = 'Adress Street',
        City__c = 'Indore',
        State__c = 'Madhya Pradesh',
        Pin_Code__c = '123456',
        Country__c = 'India',
        SuppliedPhone = '1234867899',
        Waiting_Date__c = Date.valueOf('2024-08-30')
    );
    cases.add(cs2);
    
    insert cases;
    
    // Map old cases
    oldCaseMap.put(cs.Id, cs);
    oldCaseMap.put(cs2.Id, cs2);
    
    // Call the method to test
    Test.startTest();
    CaseTriggerHandler.createResolvedCase(cases, oldCaseMap);
    Test.stopTest();
    
    // Verify the result
    List<Resolved_Case__c> resolvedCases = [SELECT Case__c, User__c FROM Resolved_Case__c WHERE Case__c IN :cases];
    
    System.assertEquals(2, resolvedCases.size(), 'The number of resolved cases should be 2.');
    
    for (Resolved_Case__c resolvedCase : resolvedCases) {
        System.assertEquals(activeUser.Id, resolvedCase.User__c, 'The User__c should match the case owner.');
    }
}

    private static Date calculateExpectedWaitingDate(String bucket, Map<String, Double> counterMap, List<Holiday_Matrix__c> holidays) {
        Set<Date> holidayDays = new Set<Date>();
        for (Holiday_Matrix__c holiday : holidays) {
            holidayDays.add(holiday.Date__c);
        }
        return CaseTriggerHandler.calculateWaitingDate(counterMap.get(bucket), holidayDays);
    }



    
}