/**
* @description       : Shiprocket api callout and controller for page Shiprocket_courier 
* @author            : Himanshu
* @group             : 
* @last modified on  : 21-04-2022
* @last modified by  : Avinash
* Modifications Log 
* Ver   Date         Author          Modification
* 1.0   06-09-2021   Himanshu   Initial Version
* 1.2   21-04-2022   Avinash   Updated Version
**/
public class ShipRocketApiCallout {
    public string page1{get;set;}
    public string Phase2Text{get;set;}
    public boolean Phase2{get;set;}
    Public static Object Token{get;set;}
    public string id{get;set;}
    public case caserec{get;set;}
    public boolean isCreate{get;set;}
    public boolean isServicebility{get;set;}
    public boolean isAWB{get;set;}
    public boolean isTracking{get;set;}
    public boolean isLable{get;set;}
    public boolean isPickup{get;set;}
    public Authentication_Shiprocket__c authentication{get;set;}
    public Boult_Warehouse__c warehouse{get;set;}
    public ShipRocketApiCallout(){} 
    public string errorMsg;
    DateTime resRecvTime;
    DateTime reqSentTime;
    public Map<String, String> attributeMap;
    /**
* @description 
* @author Himanshu | 9-06-2021 
* @param controller : Current page controller
* @Constructor 
**/
    public ShipRocketApiCallout(ApexPages.StandardController  controller)
    {
        Phase2Text= 'Phase2 is disabled Shiprocket api cannot be used.';   
        phase2 = [select IsActive__c from Phase2__c].IsActive__c;
        DateTime Phase2StartDate = [select Start_Date__c from Phase2Start__c].Start_Date__c;
        if( Phase2StartDate > DateTime.now() ){
            phase2 = false;
        }
        
        page1 = 'Shiprocket_courier';
        id=ApexPages.Currentpage().getParameters().get('id');   
        caserec = [SELECT CaseNumber, Id, SuppliedName, SuppliedEmail, SuppliedPhone, Address_street__c, City__c,
                   Owner.type,
                   Pin_Code__c, State__c, Product__c,Product__r.Name,Product__r.Product_Code__c,Product__r.Product_Family__c,
                   Product__r.Carton_Height_H__c,Product__r.Carton_Length_L__c,Product__r.Carton_Weight__c,
                   Product__r.Carton_Width_W__c,Product__r.Product_SKU__c,Product__r.Unit_Price__c,
                   SR_Order__c,SR_Order__r.Name,
                   SR_Order__r.Cancel_Reason__c,SR_Order__r.Pickup_Generated__c,SR_Order__r.Delivery_Status__c,
                   SR_Order__r.Status__c,SR_AWB__c,
                   SR_Order__r.Shipment_ID__c,(select id,Status__c from SR_Orders__r), SR_AWB__r.Name,
                   Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.PersonEmail, 
                   Contact_Name__r.PersonMobilePhone, Courier_Partner_Name__c,Inward_Courier_Name__c,Outward_Courier_Name__c,
                   Contact_Name__r.ShippingStreet, Contact_Name__r.ShippingCity, 
                   Contact_Name__r.ShippingState,Return_Cancel_Reason__c, Forward_Cancel_Reason__c,
                   Contact_Name__r.ShippingPostalCode, Contact_Name__r.ShippingCountry, 
                   AWB_No__c, Incoming_Courier_Agency__c, Incoming_AWB_Number__c ,Rate__c
                   FROM Case where id =: id];
        authentication = [select User_name__c,password__c from Authentication_Shiprocket__c];
        warehouse = [select Address__c,City__c,State__c,Zipcode__c,Pickup_Location_Id__c,Channel_Id__c,Warehouse_Email__c,	Warehouse_Phone__c from Boult_Warehouse__c];
        isCreate = false;
        isServicebility = false;
        isAWB = false;
        isTracking = false;
        isLable = false;
        isPickup = false;
        List<sr_awb__c> O_SR_AWB = [select id from SR_AWB__c where Order_No__c =: caserec.SR_Order__c];
        if(caserec.SR_Order__r.Status__c == 'New')
        {
            isCreate = true;
        }
        if(caserec.SR_Order__c == null || caserec.SR_Order__r.Status__c == 'Return')
        {
            if(caserec.SR_Order__c == null || caserec.SR_Order__r.Cancel_Reason__c != null)
            {
                isCreate = true;
                
            }
            else if(caserec.SR_AWB__c == null || (O_SR_AWB.size() == 0))
            {
                isServicebility = true;
                isAWB = true;
                
            }
            else if((caserec.SR_Order__c != null && caserec.SR_Order__r.Cancel_Reason__c == null && (caserec.SR_Order__r.Pickup_Generated__c == false)) )
            {
                isPickup = true;
                
            }
            else if((caserec.SR_Order__c != null && caserec.SR_Order__r.Cancel_Reason__c == null && (caserec.SR_Order__r.Pickup_Generated__c == true)))
            {
                
                isTracking = true;
                isLable = true;
            }
        }
        
        if(phase2 && (caserec.Product__r.Product_Family__c == 'Wired'))
        {
            Phase2Text= 'Phase2 is Enabled but Shiprocket api cannot be used For wired Product.';   
            phase2 = false;
            isCreate = false;
            isServicebility = false;
            isAWB = false;
            isTracking = false;
            isLable = false;
            
        }
        else
        {
            Id profileId= userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            system.debug('ProfileName'+profileName);
            system.debug('caserec.owner.type     '+caserec.owner.type);
            if(profileName <> 'System Administrator' && caserec.owner.type <> 'User')
            {
                Phase2Text= 'Phase2 is Enabled but Shiprocket api cannot be used Unless case is accepted by user.';   
                phase2 = false;
                isCreate = false;
                isServicebility = false;
                isAWB = false;
                isTracking = false;
                isLable = false;
            }
            
        }
        // token=  ReturnAccessToken();
    }   
    public Object ReturnAccessToken ()
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://apiv2.shiprocket.in/v1/external/auth/login');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        //request.setBody('{    "email": "hmny0079@gmail.com",    "password": "LkjAsd@1"}');
        request.setBody('{    "email": "'+authentication.User_Name__c+''+
                        '",    "password": "'+authentication.Password__c+'"}');
        //request.setBody('{    "email": "reply2siddharthasingh@gmail.com",    "password": "IRT@1234"}');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200|| response.getStatusCode() == 202) {
            map<string,object> jsonContent = (map<string,object>)JSON.deserializeUntyped(response.getBody());
            // token = (String)jsonContent.get('token');
            token = jsonContent.get('token');
            system.debug('token'+'******' + token);
        } 
        else {
            System.debug(response.getBody());
        }
        return token;
    }
    
    
    public  PageReference CheckServicebility ()
    {
        token=  ReturnAccessToken();
        system.debug('**********pickup_postcode='+caserec.Contact_Name__r.ShippingPostalCode+'&delivery_postcode='+warehouse.zipcode__c+'***********');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://apiv2.shiprocket.in/v1/external/courier/serviceability?pickup_postcode='+caserec.Contact_Name__r.ShippingPostalCode+'&delivery_postcode='+warehouse.zipcode__c+'&weight=0.5&cod=0&order_id='+caserec.SR_Order__r.Name);
        // request.setEndpoint('https://apiv2.shiprocket.in/v1/external/courier/serviceability?pickup_postcode=201306&delivery_postcode=800001&weight=1&cod=0');
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer '+ token +'');
        
        String CourierId;
        ApexPages.Message MyMsg1;
        reqSentTime = System.now();
        HttpResponse response = http.send(request);
        if(response != null){
            resRecvTime = System.now();
        }
       attributeMap = new map<string, string>{'className'=>'ShipRocketApiCallout', 'methodName'=>'CheckServicebility','objectType'=>'Case','recordId'=>caserec.Id};

        
        if (response.getStatusCode() == 200) {
            map<string,object> jsonContent = (map<string,object>)JSON.deserializeUntyped(response.getBody());
            system.debug('available_courier_companies:--'+jsonContent.get('data'));
            system.debug('JSON:--'+jsonContent);
            map<string,object> jasondata = (map<string,object>)jsonContent.get('data');
            integer jasonRecommended = (integer)jasondata.get('recommended_courier_company_id');
            system.debug('---'+jasonRecommended);
            list<object> jasonAvailableCmp = (list<object>)jasondata.get('available_courier_companies');
            myMsg1 = new ApexPages.Message(ApexPages.severity.CONFIRM,'This Pincode is Serviceble and the Default Courier Partner Will be Selected');
            //'Serviceble to :-'+jasonListdata.get('rate'));
            decimal rate ;
            Maximum_SR_Rate__c maxRate = [select rate__c from Maximum_SR_Rate__c];
            for(object j : jasonAvailableCmp)
            {
                map<string,object> Loopvar = (map<string,object>)j;
                system.debug(''+(decimal)Loopvar.get('rate'));
                integer companyid = (integer)Loopvar.get('courier_company_id');
                if(companyid == jasonRecommended){
                    rate = (decimal)Loopvar.get('rate');
                    if(rate > maxrate.rate__c)
                    {
                        myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,'The courier company charge is greater than '+maxrate.rate__c);
                        
                    }
                    
                    break;
                }
                system.debug(Loopvar.get('courier_company_id'));
                
            }
            caserec.Rate__c = rate;
            update caserec;
            
        } 
        else {
            System.debug(response.getBody());
            map<string,object> jsonContent = (map<string,object>)JSON.deserializeUntyped(response.getBody());
            system.debug('JSON:--'+jsonContent);
            myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,'No Courier Serviceability Avialble');
            errorMsg = 'No Courier Serviceability Avialble';
            //'Error Message--'+jsonContent);
            
        }
        
        if(!Test.isRunningTest()){
            if(response.getStatusCode() != 200){
            	attributeMap.put('error', errorMsg);
            	GenerateExceptionLogs.insertIntegrationLog(request, response, attributeMap, reqSentTime, resRecvTime);
            }
        }
        //System.debug('CourierId' + CourierId);
        ApexPages.addMessage(myMsg1);
        PageReference savepage = new PageReference('/apex/'+page1+'?id='+Id);
        savepage.setRedirect(false);
        savepage.setRedirect(false);
        return savepage;
    }
    
    public PageReference CreateReturnOrder ()
    {
        integer CaseOrderCount = 0;
        for(SR_order__c tempOrder : caserec.SR_Orders__r)
        {
            if(tempOrder.Status__c == 'Return')
            {
                CaseOrderCount++;
            }
        }
        token=  ReturnAccessToken();
        system.debug('token'+'******' + token);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://apiv2.shiprocket.in/v1/external/orders/create/return');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer '+ token +'');
        system.debug(CaseOrderCount);
        request.setBody('{ "order_id": "BARV-'+(CaseOrderCount+1)+'-'+caserec.CaseNumber+'",' + 
                        '"order_date": "'+system.today()+'", ' + 
                        ' "channel_id": "'+warehouse.Channel_Id__c+'", '+                    
                        '"pickup_customer_name": "'+caserec.Contact_Name__r.FirstName+'", ' +
                        ' "pickup_last_name": "'+caserec.Contact_Name__r.LastName+'", ' +
                        '"pickup_address": "'+caserec.Contact_Name__r.ShippingStreet+'", ' +
                        '"pickup_city": "'+caserec.Contact_Name__r.ShippingCity+'", ' +
                        '"pickup_state": "'+caserec.Contact_Name__r.ShippingState+'", ' +
                        '"pickup_country": "India", ' +
                        '"pickup_pincode": "'+caserec.Contact_Name__r.ShippingPostalCode+'", ' +
                        '"pickup_email": "'+caserec.Contact_Name__r.PersonEmail+'", ' +
                        '"pickup_phone": "'+caserec.Contact_Name__r.PersonMobilePhone+'", ' +
                        '"pickup_isd_code": "91", ' +
                        '"pickup_location_id": '+warehouse.Pickup_Location_Id__c+', ' +
                        '"shipping_customer_name": "Boult Audio", ' +
                        '"shipping_last_name": "Warehouse", ' +
                        '"shipping_address": "'+warehouse.Address__c+'", ' +
                        '"shipping_city": "'+warehouse.city__c+'", ' +
                        '"shipping_country": "India", ' +
                        '"shipping_pincode": "'+warehouse.zipcode__c+'", ' +
                        '"shipping_state": "'+warehouse.state__c+'", ' +
                        '"shipping_email": "'+warehouse.Warehouse_Email__c+'", ' +
                        '"shipping_isd_code": "91", ' +
                        '"shipping_phone": "'+warehouse.Warehouse_Phone__c+'", ' +
                        '"order_items": [ ' +
                        ' { ' +
                        '  "sku": "'+caserec.Product__r.Product_SKU__c+'", ' +
                        '  "name": "'+caserec.Product__r.Name+'", ' +
                        '  "units": 1, ' +
                        '  "selling_price": '+caserec.Product__r.Unit_Price__c+', ' +
                        '  "discount": 0, ' +
                        '  "hsn": "4412" ' +
                        '  } ' +
                        '], ' +
                        ' "payment_method": "Prepaid", ' +
                        ' "total_discount": "0", ' +
                        ' "sub_total": '+caserec.Product__r.Unit_Price__c+', ' +
                        ' "length": '+caserec.Product__r.Carton_Length_L__c+', ' +
                        ' "breadth": '+caserec.Product__r.Carton_Width_W__c+', ' +
                        ' "height": '+caserec.Product__r.Carton_Height_H__c+', ' +
                        ' "weight":  '+caserec.Product__r.Carton_Weight__c+'' +
                        '}');  
        system.debug('{ "order_id": "BARV-'+(CaseOrderCount+1)+'-'+caserec.CaseNumber+'",' + 
                     '"order_date": "'+system.today()+'", ' + 
                     ' "channel_id": "'+warehouse.Channel_Id__c+'", '+                    
                     '"pickup_customer_name": "'+caserec.Contact_Name__r.FirstName+'", ' +
                     ' "pickup_last_name": "'+caserec.Contact_Name__r.LastName+'", ' +
                     '"pickup_address": "'+caserec.Contact_Name__r.ShippingStreet);
        system.debug('"pickup_state": "'+caserec.Contact_Name__r.ShippingState+'", ' +
                     '"pickup_country": "India", ' +
                     '"pickup_pincode": "'+caserec.Contact_Name__r.ShippingPostalCode+'", ' +
                     '"pickup_email": "'+caserec.Contact_Name__r.PersonEmail+'", ' +
                     '"pickup_phone": "'+caserec.Contact_Name__r.PersonMobilePhone+'", ' +
                     '"pickup_isd_code": "91", ' +
                     '"pickup_location_id": '+warehouse.Pickup_Location_Id__c);
        system.debug('"shipping_customer_name": "Boult Audio", ' +
                     '"shipping_last_name": "Warehouse", ' +
                     '"shipping_address": "'+warehouse.Address__c+'", ' +
                     '"shipping_city": "'+warehouse.city__c+'", ' +
                     '"shipping_country": "India", ' +
                     '"shipping_pincode": "'+warehouse.zipcode__c);
        system.debug('"shipping_pincode": "'+warehouse.zipcode__c+'", ' +
                     '"shipping_state": "'+warehouse.state__c+'", ' +
                     '"shipping_email": "'+warehouse.Warehouse_Email__c+'", ' +
                     '"shipping_isd_code": "91", ' +
                     '"shipping_phone": "'+warehouse.Warehouse_Phone__c);
        system.debug('  "name": "'+caserec.Product__r.Name);system.debug('  "sku": "'+caserec.Product__r.Product_SKU__c);
        system.debug(' "sub_total": '+caserec.Product__r.Unit_Price__c);system.debug('  "selling_price": '+caserec.Product__r.Unit_Price__c);
        system.debug(' "length": '+caserec.Product__r.Carton_Length_L__c);system.debug(' "breadth": '+caserec.Product__r.Carton_Width_W__c);
        system.debug(' "height": '+caserec.Product__r.Carton_Height_H__c);system.debug(' "weight":  '+caserec.Product__r.Carton_Weight__c);
        
       	attributeMap = new map<string, string>{'className'=>'ShipRocketApiCallout', 'methodName'=>'CreateReturnOrder','objectType'=>'Case','recordId'=>caserec.Id};
        String CourierId; 
        ApexPages.Message myMsg1;
        reqSentTime = system.now();
        HttpResponse response = http.send(request);
        if(response != null){
            resRecvTime = system.now();
        }
        
        if (response.getStatusCode() == 200) {
            map<string,object> jsonContent = (map<string,object>)JSON.deserializeUntyped(response.getBody());
            // CourierId = (String)jsonContent.get('order_id');
            
            system.debug('JSON:--'+jsonContent);
            
            if(jsonContent.get('message') != null)           
                myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,jsonContent.get('message')+'');
            else 
            {
                SR_Order__c orderrec1 = new SR_Order__c(
                    name = jsonContent.get('order_id')+'',
                    Shipment_ID__c = jsonContent.get('shipment_id')+'',
                    Case_Related__c = id,
                    Status__c = 'Return',
                    Order_Name__c = 'BARV-'+(CaseOrderCount+1)+'-'+caserec.CaseNumber,
                    Delivery_Status__c = 'New',
                    Status_Code__c =  Decimal.valueOf(jsonContent.get('status_code')+'')
                ); 
                insert orderrec1;
                caserec.SR_Order__c = orderrec1.id;
                caserec.Forward_Cancel_Reason__c = '';
                caserec.Return_Cancel_Reason__c =  ''; 
                update caserec;
                //fetching record for page null pointer exception error handling
                caserec = [SELECT CaseNumber, Id, SuppliedName, SuppliedEmail, SuppliedPhone, Address_street__c, City__c,
                           Pin_Code__c, State__c, Product__c,Product__r.Name,Product__r.Product_Code__c,Product__r.Product_Family__c,
                           Product__r.Carton_Height_H__c,Product__r.Carton_Length_L__c,Product__r.Carton_Weight__c,
                           Product__r.Carton_Width_W__c,Product__r.Product_SKU__c,Product__r.Unit_Price__c,
                           SR_Order__c,SR_Order__r.Name,SR_Order__r.Pickup_Generated__c,
                           SR_Order__r.Cancel_Reason__c,SR_Order__r.Delivery_Status__c,SR_Order__r.Status__c,SR_AWB__c,
                           SR_Order__r.Shipment_ID__c,(select id,Status__c from SR_Orders__r), SR_AWB__r.Name,
                           Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.PersonEmail, 
                           Contact_Name__r.PersonMobilePhone, Courier_Partner_Name__c,Inward_Courier_Name__c,Outward_Courier_Name__c,
                           Contact_Name__r.ShippingStreet, Contact_Name__r.ShippingCity, 
                           Contact_Name__r.ShippingState,Return_Cancel_Reason__c, Forward_Cancel_Reason__c,
                           Contact_Name__r.ShippingPostalCode, Contact_Name__r.ShippingCountry, 
                           AWB_No__c, Incoming_Courier_Agency__c, Incoming_AWB_Number__c ,Rate__c
                           FROM Case where id =: id];
                myMsg1 = new ApexPages.Message(ApexPages.severity.CONFIRM,'Order Craeted Sucessfully');
            }
            
            ApexPages.addMessage(myMsg1);
            //  PageReference savepage = Page.Shiprocket_courier;
            //savepage.getParameters().put('id',ID);
            PageReference savepage = new PageReference('/apex/Shiprocket_courier?id='+Id);
            
            savepage.setRedirect(false);
            isCreate = false;
            isServicebility = true;
            isAWB = true;
            isTracking = false;
            isPickup = false;
            return savepage;
        } 
        else {
            System.debug(response.getBody());
            map<string,object> jsonContent = (map<string,object>)JSON.deserializeUntyped(response.getBody());
            system.debug('JSON:--'+(String)jsonContent.get('data'));
            
            if(jsonContent.get('status_code')+'' == '422')
                myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,'Order Not created');
            	errorMsg = 'Oreder Not Created';
            //+jsonContent.get('errors'));
            
        }  
        System.debug('CourierId' + CourierId);
        //return CourierId;
        if(myMsg1 == null){ 
            myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,'Order Not Created');
        	errorMsg = 'Oreder Not Created';
        }
        
        if(!Test.isRunningTest()){
            if(response.getStatusCode() != 200){
                attributeMap.put('error', errorMsg);
        		GenerateExceptionLogs.insertIntegrationLog(request, response, attributeMap, reqSentTime, resRecvTime);
            }
        }
        
        ApexPages.addMessage(myMsg1);
        PageReference savepage = Page.Shiprocket_courier;
        savepage.getParameters().put('id',ID);
        savepage.setRedirect(false);
        
        return savepage;
    }
    
    // For Tracking
    public PageReference ReturnOrderTracking(){
        {
            token=  ReturnAccessToken();
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://apiv2.shiprocket.in/v1/external/courier/track/awb/'+caserec.SR_AWB__r.Name);
            //request.setEndpoint('https://apiv2.shiprocket.in/v1/external/courier/track/awb/24112320192589');
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization', 'Bearer '+ token +'');
            ApexPages.Message myMsg1;
            
            map<string, string> attributeMap = new map<string, string>{'className'=>'ForwardShipRocketApiCallout', 'methodName'=>'ReturnOrderTracking','objectType'=>'Case','recordId'=>caserec.Id};

            reqSentTime = System.now();
            HttpResponse response = http.send(request);
            if(response != null){
                resRecvTime = System.now();
            }
            
            if (response.getStatusCode() == 200) {
                map<string,object> jsonContent = (map<string,object>)JSON.deserializeUntyped(response.getBody());
                system.debug('JSON:--'+jsonContent); 
                
                map<string,object> jsonTrackingData = (map<string,object>)jsonContent.get('tracking_data');
                string jsonTrackingError = (string)jsonTrackingData.get('error');
                if(jsonTrackingError == null)
                {
                    list<object> jsonListShipmentTrack =(list<object>)jsonTrackingData.get('shipment_track');
                    system.debug('JSON list of track:--'+jsonListShipmentTrack); 
                    map<string,object> jsonShipmentTrack = (map<string,object>)jsonListShipmentTrack.get(0);
                    system.debug('JSON Map of track:--'+jsonShipmentTrack); 
                    string current_status = jsonShipmentTrack.get('current_status')+'';
                    string courier_company_id = jsonShipmentTrack.get('courier_company_id')+'';
                    System.debug('current_status -- '+current_status);
                    System.debug('courier_company_id -- '+courier_company_id);
                    list<object> jsonListShipmentTrackActivityt =(list<object>)jsonTrackingData.get('shipment_track');
                    system.debug('JSON list of track:--'+jsonListShipmentTrack); 
                    map<string,object> jsonShipmentTrackActivityt = (map<string,object>)jsonListShipmentTrackActivityt.get(0);
                    system.debug('JSON Map of track:--'+jsonShipmentTrack); 
                    Date tracklastdate = (date)jsonShipmentTrackActivityt.get('date');
                    string activity = jsonShipmentTrackActivityt.get('activity')+'';
                    String jsonShipmentTrackurl =(string)jsonTrackingData.get('track_url');
                    System.debug('current_status -- '+current_status);
                    System.debug('courier_company_id -- '+courier_company_id);
                    System.debug('tracklastdate -- '+tracklastdate);
                    System.debug('activity -- '+activity);
                    System.debug('jsonShipmentTrackurl -- '+jsonShipmentTrackurl);
                    system.debug('JSON:--'+jsonContent); 
                    myMsg1 = new ApexPages.Message(ApexPages.severity.CONFIRM,'Sucessfully Saved' +'    current_status -- '+current_status+' '
                                                   + '   courier_company_id -- '+courier_company_id+' '
                                                   +'   tracklastdate -- '+tracklastdate +' '
                                                   + '  activity -- '+activity+' '
                                                   +'   jsonShipmentTrackurl -- '+jsonShipmentTrackurl+' '
                                                  );
                    
                    SR_Track__c trackRec = new SR_Track__c(
                        activity__c = activity , Courier__c = decimal.valueOf(courier_company_id),
                        Current_Status__c = current_status , Date__c = (tracklastdate) ,
                        Tracking_URL__c = jsonShipmentTrackurl , SR_Order__c = caserec.SR_Order__c,
                        SR_AWB__c = caserec.SR_AWB__c
                    );
                    insert trackRec;
                }
                else{
                    myMsg1 = new ApexPages.Message(ApexPages.severity.CONFIRM,'No action performed'+jsonTrackingError+' '
                                                   
                                                  );
                    
                    SR_Track__c trackRec = new SR_Track__c(
                        activity__c = jsonTrackingError , Date__c = date.today() ,
                        SR_Order__c = caserec.SR_Order__c,
                        SR_AWB__c = caserec.SR_AWB__c
                    );
                    insert trackRec;
                }
                ApexPages.addMessage(myMsg1);
                PageReference savepage = new PageReference('/apex/'+page1+'?id='+Id);
                savepage.setRedirect(false);
                //       PageReference savepage = Page.Shiprocket_courier;
                //     savepage.getParameters().put('id',ID);
                savepage.setRedirect(false);
                
                return savepage;
            }
            
            else {
                System.debug(response.getBody());
                map<string,object> jsonContent = (map<string,object>)JSON.deserializeUntyped(response.getBody());
                system.debug('JSON:--'+(String)jsonContent.get('data'));
                myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,'Error while tracking');
                errorMsg = 'Error while tracking';
            }
            
            if(!Test.isRunningTest()){
            	if(response.getStatusCode() != 200){
                	attributeMap.put('error', errorMsg);
        			GenerateExceptionLogs.insertIntegrationLog(request, response, attributeMap, reqSentTime, resRecvTime);
            	}
        	}
            
            ApexPages.addMessage(myMsg1);
            PageReference savepage = new PageReference('/apex/'+page1+'?id='+Id);
            savepage.setRedirect(false);
            //       PageReference savepage = Page.Shiprocket_courier;
            //     savepage.getParameters().put('id',ID);
            savepage.setRedirect(false);
            
            return savepage; 
        }
    }
    public PageReference CreateAWB(){
        
        token=  ReturnAccessToken();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://apiv2.shiprocket.in/v1/external/courier/assign/awb');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer '+ token +'');
        request.setTimeout(120000);
        ApexPages.Message myMsg1;
        request.setBody('{ "shipment_id":"'+caserec.SR_Order__r.Shipment_ID__c+'"}');
        reqSentTime = system.now();
        HttpResponse response = http.send(request);
        if(response != null){
            resRecvTime = System.now();
        }
        map<string, string> attributeMap = new map<string, string>{'className'=>'ForwardShipRocketApiCallout', 'methodName'=>'CreateAWB','objectType'=>'Case','recordId'=>caserec.Id};

        if (response.getStatusCode() == 200) {
            map<string,object> jsonContent = (map<string,object>)JSON.deserializeUntyped(response.getBody());
            system.debug('JSON:--'+jsonContent);
            map<string,object> jsonResponse = (map<string,object>)jsonContent.get('response');
            system.debug('jsonResponse----'+jsonResponse);
            map<string,object> jsondata = (map<string,object>)jsonResponse.get('data');
            system.debug('jsondata----'+jsondata);
            
            /*String awbNo = jsondata.get('awb_code')+'';
String courierId = jsondata.get('courier_company_id')+'';
String courierName = jsondata.get('courier_name')+'';*/
            
            String awbNo = '';
            String courierId = '';
            String courierName = '';
            
            
            if (jsondata.get('awb_assign_error')!=null)
            {
                throw new AuraHandledException(string.valueOf(jsondata.get('awb_assign_error')));
                //throw new AuraHandledException(jsondata.get('awb_assign_error'))
            }
            
            else if (jsondata.get('awb_code')!=null && jsondata.get('courier_company_id') !=null && jsondata.get('courier_name')!=null)
            {
                awbNo = jsondata.get('awb_code')+'';
                courierId = jsondata.get('courier_company_id')+'';
                courierName = jsondata.get('courier_name')+'';
            }
            
            
            system.debug('JSON:--'+jsonContent);
            //create awb record
            SR_AWB__c nawb = new SR_AWB__c(
                name = awbNo,Order_No__c = caserec.SR_Order__c,
                courier_company_id__c = courierId,
                courier_name__c = courierName
            );
            insert nawb;
            caserec.SR_AWB__c = nawb.id;
            
            if(caserec.SR_Order__r.Status__c ==  'Return'){
                
                caserec.Incoming_Courier_Agency__c = 'ShipRocket';
                caserec.Incoming_AWB_Number__c = awbNo;
                caserec.Inward_Courier_Name__c = courierName;
                
            }
            else{
                caserec.Courier_Partner_Name__c = 'ShipRocket';
                caserec.AWB_No__c =  awbNo;
                caserec.Outward_Courier_Name__c = courierName;
            } 
            
            update caserec;
            //fetching record for page null pointer exception error handling
            caserec = [SELECT CaseNumber, Id, SuppliedName, SuppliedEmail, SuppliedPhone, Address_street__c, City__c,
                       Pin_Code__c, State__c, Product__c,Product__r.Name,Product__r.Product_Code__c,Product__r.Product_Family__c,
                       Product__r.Carton_Height_H__c,Product__r.Carton_Length_L__c,Product__r.Carton_Weight__c,
                       Product__r.Carton_Width_W__c,Product__r.Product_SKU__c,Product__r.Unit_Price__c,          
                       SR_Order__c,SR_Order__r.Name,SR_Order__r.Pickup_Generated__c,
                       SR_Order__r.Cancel_Reason__c,SR_Order__r.Delivery_Status__c,SR_Order__r.Status__c,SR_AWB__c,
                       SR_Order__r.Shipment_ID__c,(select id,Status__c from SR_Orders__r), SR_AWB__r.Name,
                       Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.PersonEmail, 
                       Contact_Name__r.PersonMobilePhone, Courier_Partner_Name__c,Inward_Courier_Name__c,Outward_Courier_Name__c,
                       Contact_Name__r.ShippingStreet, Contact_Name__r.ShippingCity, 
                       Contact_Name__r.ShippingState,Return_Cancel_Reason__c, Forward_Cancel_Reason__c,
                       Contact_Name__r.ShippingPostalCode, Contact_Name__r.ShippingCountry, 
                       AWB_No__c, Incoming_Courier_Agency__c, Incoming_AWB_Number__c ,Rate__c
                       FROM Case where id =: id];
            
            myMsg1 = new ApexPages.Message(ApexPages.severity.CONFIRM,'AWB Sucessfully Created');
            //+jsonContent);
            ApexPages.addMessage(myMsg1);
            PageReference savepage = new PageReference('/apex/'+page1+'?id='+Id);
            savepage.setRedirect(false);
            //       PageReference savepage = Page.Shiprocket_courier;
            //     savepage.getParameters().put('id',ID);
            savepage.setRedirect(false);
            isCreate = false;
            isServicebility = false;
            isAWB = false;
            isTracking = false;
            isPickup = true;
            return savepage;
            
        }
        
        else {
            System.debug(response.getBody());
            map<string,object> jsonContent = (map<string,object>)JSON.deserializeUntyped(response.getBody());
            if(jsonContent.get('message') != Null){
                myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,''+jsonContent.get('message'));
                errorMsg = (String)jsonContent.get('message');

            }
            else{
                myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,'AWB NOT Created' );
                errorMsg = 'AWB NOT Created';
            	//+jsonContent);
            }
            system.debug('JSON:--'+(String)jsonContent.get('data'));
        }
        
        if(!Test.isRunningTest()){
            if(response.getStatusCode() != 200){
                attributeMap.put('error', errorMsg);
        		GenerateExceptionLogs.insertIntegrationLog(request, response, attributeMap, reqSentTime, resRecvTime);
            }
        }
        
        ApexPages.addMessage(myMsg1);
        PageReference savepage = new PageReference('/apex/'+page1+'?id='+Id);
        // PageReference savepage = Page.Shiprocket_courier;
        //savepage.getParameters().put('id',ID);
        savepage.setRedirect(false);
        
        
        return savepage;
    }
    public PageReference Label(){
        GenrateLabel objFwd = new GenrateLabel();
        objFwd.authentication = authentication; 
        objFwd.page1 = 'Shiprocket_courier';
        objFwd.caserec = caserec;
        return objFwd.GetLabel();
    }
    //To initiate the shiprocket pickup
    
    public PageReference pickup()
    {
        token=  ReturnAccessToken();
        ApexPages.Message myMsg1;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://apiv2.shiprocket.in/v1/external/courier/generate/pickup');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer '+ token +'');
        request.setBody('{    "shipment_id": ["'+caserec.SR_Order__r.Shipment_ID__c+'"]}');
        reqSentTime = system.now();
        HttpResponse response = http.send(request);
        if(response != null){
            resRecvTime = System.now();
        }
        map<string, string> attributeMap = new map<string, string>{'className'=>'ForwardShipRocketApiCallout', 'methodName'=>'pickup','objectType'=>'Case','recordId'=>caserec.Id};
        
        if (response.getStatusCode() == 200) {
            System.debug(response.getBody());
            map<string,object> jsonContent = (map<string,object>)JSON.deserializeUntyped(response.getBody());
            System.debug(jsonContent);
            SR_Order__c pickupupdate = new SR_Order__c(id = caserec.SR_Order__c ,Pickup_Generated__c = true);
            update pickupupdate;
            //fetching record for page null pointer exception error handling
            caserec = [SELECT CaseNumber, Id, SuppliedName, SuppliedEmail, SuppliedPhone, Address_street__c, City__c,
                       Pin_Code__c, State__c, Product__c,Product__r.Name,Product__r.Product_Code__c,Product__r.Product_Family__c,
                       Product__r.Carton_Height_H__c,Product__r.Carton_Length_L__c,Product__r.Carton_Weight__c,
                       Product__r.Carton_Width_W__c,Product__r.Product_SKU__c,Product__r.Unit_Price__c,          
                       SR_Order__c,SR_Order__r.Name,SR_Order__r.Pickup_Generated__c,
                       SR_Order__r.Cancel_Reason__c,SR_Order__r.Delivery_Status__c,SR_Order__r.Status__c,SR_AWB__c,
                       SR_Order__r.Shipment_ID__c,(select id,Status__c from SR_Orders__r), SR_AWB__r.Name,
                       Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.PersonEmail, 
                       Contact_Name__r.PersonMobilePhone, Courier_Partner_Name__c,Inward_Courier_Name__c,Outward_Courier_Name__c,
                       Contact_Name__r.ShippingStreet, Contact_Name__r.ShippingCity, 
                       Contact_Name__r.ShippingState,Return_Cancel_Reason__c, Forward_Cancel_Reason__c,
                       Contact_Name__r.ShippingPostalCode, Contact_Name__r.ShippingCountry, 
                       AWB_No__c, Incoming_Courier_Agency__c, Incoming_AWB_Number__c ,Rate__c
                       FROM Case where id =: id];
            
            myMsg1 = new ApexPages.Message(ApexPages.severity.CONFIRM,'Order Pickup Generated');
            //+jsonContent);
            ApexPages.addMessage(myMsg1);
            PageReference savepage = new PageReference('/apex/'+page1+'?id='+Id);
            savepage.setRedirect(false);
            isCreate = false;
            isServicebility = false;
            isAWB = false;
            isTracking = true;
            isPickup = false;
            return savepage;
            
        }
        
        else {
            System.debug(response.getBody());
            map<string,object> jsonContent = (map<string,object>)JSON.deserializeUntyped(response.getBody());
            if(jsonContent.get('message') != Null){
                myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,''+jsonContent.get('message'));
                errorMsg = (String)jsonContent.get('message');
            }
            else{
                myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,'Pickup Not Created' );
                errorMsg = 'Pickup Not Created';
            }
            //+jsonContent);
            system.debug('JSON:--'+(String)jsonContent.get('data'));
        }
        
        if(!Test.isRunningTest()){
            if(response.getStatusCode() != 200){
                attributeMap.put('error', errorMsg);
        		GenerateExceptionLogs.insertIntegrationLog(request, response, attributeMap, reqSentTime, resRecvTime);
            }
        }
        
        ApexPages.addMessage(myMsg1);
        PageReference savepage = new PageReference('/apex/'+page1+'?id='+Id);
        savepage.setRedirect(false);
        return savepage;
    }
    
}