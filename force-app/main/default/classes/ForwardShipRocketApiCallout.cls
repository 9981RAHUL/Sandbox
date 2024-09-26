public class ForwardShipRocketApiCallout {
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
    public String errorMsg;
    public map<string, string> attributeMap;
    public DateTime resRecvTime; 
    public DateTime reqSentTime;
    public ForwardShipRocketApiCallout(ApexPages.StandardController  controller)
    {
        Phase2Text = 'Phase2 is disabled Shiprocket api cannot be used.';   
        phase2 = [select IsActive__c from Phase2__c].IsActive__c;
        DateTime Phase2StartDate = [select Start_Date__c from Phase2Start__c].Start_Date__c;
        if( Phase2StartDate > DateTime.now() ){
            phase2 = false;
        }
        
        
        
        id=ApexPages.Currentpage().getParameters().get('id');   
        caserec = [SELECT CaseNumber, Id, SuppliedName, SuppliedEmail, SuppliedPhone, Address_street__c, City__c,
                   owner.type,
                   Pin_Code__c, State__c, Product__c,Product__r.Name,Product__r.Product_Code__c,Product__r.Product_Family__c,
                   Product__r.Carton_Height_H__c,Product__r.Carton_Length_L__c,Product__r.Carton_Weight__c, Product_SKU_Color__c,
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
        authentication = [select User_name__c,password__c from Authentication_Shiprocket__c];
        warehouse = [select Address__c,City__c,State__c,Zipcode__c,Pickup_Location_Id__c,Channel_Id__c,pickup_location__c from Boult_Warehouse__c];
        isCreate = false;
        isServicebility = false;
        isAWB = false;
        isTracking = false;
        isLable = false;
        isPickup = false;
        List<sr_awb__c> O_SR_AWB = [select id from SR_AWB__c where Order_No__c =: caserec.SR_Order__c];
        if(caserec.SR_Order__r.Status__c == 'Return')
        {
            isCreate = true;
        }
        if(caserec.SR_Order__c == null || caserec.SR_Order__r.Status__c == 'New')
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
        // token=  ReturnAccessToken();
    }
    public object FwdAccessToken ()
    {
        ShipRocketApiCallout objFwd = new ShipRocketApiCallout(); 
        objFwd.authentication = [select User_name__c,password__c from Authentication_Shiprocket__c]; 
        return objFwd.ReturnAccessToken();
    }
    public PageReference CreateForwardOrder ()
    {    
        integer CaseOrderCount = 0;
        for(SR_order__c tempOrder : caserec.SR_Orders__r)
        {
            if(tempOrder.Status__c == 'New')
            {
                CaseOrderCount++;
            }
        }
        token= FwdAccessToken();
        system.debug('token'+'******' + token);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://apiv2.shiprocket.in/v1/external/orders/create/adhoc');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer '+ token +'');
        request.setBody('{ ' +
                        ' "order_id": "BAFD-'+(CaseOrderCount+1)+'-'+caserec.CaseNumber+'",' +
                        ' "order_date": "'+system.today()+'", ' + 
                        ' "pickup_location": "'+warehouse.pickup_location__c+'", ' + 
                        ' "channel_id": "'+warehouse.Channel_Id__c+'", ' + 
                        //  ' "channel_id": "1600757", ' +
                        ' "comment": "Reseller: M/s Goku", ' + 
                        ' "billing_customer_name": "'+caserec.Contact_Name__r.FirstName+'", ' + 
                        ' "billing_last_name": "'+caserec.Contact_Name__r.LastName+'", ' + 
                        ' "billing_address": "'+caserec.Contact_Name__r.ShippingStreet+'", ' + 
                        // '"billing_address_2": "Near Hokage House", ' + 
                        ' "billing_city": "'+caserec.Contact_Name__r.ShippingCity+'", ' + 
                        ' "billing_pincode": "'+caserec.Contact_Name__r.ShippingPostalCode+'", ' + 
                        ' "billing_state": "'+caserec.Contact_Name__r.ShippingState+'", ' + 
                        ' "billing_country": "India", ' + 
                        ' "billing_email": "'+caserec.Contact_Name__r.PersonEmail+'", ' + 
                        ' "billing_phone": "'+caserec.Contact_Name__r.PersonMobilePhone+'", ' + 
                        ' "shipping_is_billing": true, ' + 
                        ' "shipping_customer_name": "", ' + 
                        //' "shipping_last_name": "", ' + 
                        ' "shipping_address": "", ' + 
                        //' "shipping_address_2": "", ' + 
                        ' "shipping_city": "", ' + 
                        ' "shipping_pincode": "", ' + 
                        ' "shipping_country": "", ' + 
                        ' "shipping_state": "", ' + 
                        ' "shipping_email": "", ' + 
                        ' "shipping_phone": "", ' + 
                        ' "order_items": [ ' + 
                        '   { ' + 
                        '   "name": "'+caserec.Product__r.Name+'", ' + 
                        '   "sku": "'+caserec.Product_SKU_Color__c+'", ' + 
                        '  "units": 1, ' + 
                        '  "selling_price": '+caserec.Product__r.Unit_Price__c+', ' + 
                        '  "discount": "0", ' + 
                        '  "tax": "", ' + 
                        '  "hsn": 441122 ' + 
                        ' } ' + 
                        ' ], ' + 
                        ' "payment_method": "Prepaid", ' + 
                        ' "shipping_charges": 0, ' + 
                        ' "giftwrap_charges": 0, ' + 
                        ' "transaction_charges": 0, ' + 
                        ' "total_discount": 0, ' + 
                        '  "sub_total": '+caserec.Product__r.Unit_Price__c+', ' + 
                        '"length": '+caserec.Product__r.Carton_Length_L__c+', ' + 
                        ' "breadth": '+caserec.Product__r.Carton_Width_W__c+', ' + 
                        '  "height": '+caserec.Product__r.Carton_Height_H__c+', ' + 
                        ' "weight": '+caserec.Product__r.Carton_Weight__c+' ' + 
                        '}');
        
        attributeMap = new map<string, string>{'className'=>'ForwardShipRocketApiCallout', 'methodName'=>'CreateForwardOrder','objectType'=>'Case','recordId'=>caserec.Id};
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
                    Status__c = 'New',
                    Order_Name__c = 'BAFD-'+(CaseOrderCount+1)+'-'+caserec.CaseNumber,
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
                
                myMsg1 = new ApexPages.Message(ApexPages.severity.CONFIRM,'Order Created Sucessfully');
            }
            
            ApexPages.addMessage(myMsg1);
            //  PageReference savepage = Page.Shiprocket_courier;
            //savepage.getParameters().put('id',ID);
            PageReference savepage = new PageReference('/apex/Shiprocket_Fwd_courier?id='+Id);
            
            savepage.setRedirect(false);
            isCreate = false;
            isServicebility = true;
            isAWB = true;
            isPickup = false;
            return savepage;
        } 
        else {
            System.debug(response.getBody());
            map<string,object> jsonContent = (map<string,object>)JSON.deserializeUntyped(response.getBody());
            errorMsg = (String)jsonContent.get('message');
            System.debug('====Json Data is====' + jsonContent.get('message'));
            system.debug('JSON:--'+(String)jsonContent.get('data'));
            
            if(jsonContent.get('status_code')+'' == '422'){
                myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,'Order Already created');
            	System.debug(response.getBody());
                errorMsg = 'Order Already created';
            }
            
        }  
        System.debug('CourierId' + CourierId);
        //return CourierId;
        if(myMsg1 == null){                        
            myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,'Order Not Created');
            errorMsg = 'Order Not Created';
        }
        
        if(!Test.isRunningTest()){
            if(response.getStatusCode() != 200){
                attributeMap.put('error', errorMsg);
        		GenerateExceptionLogs.insertIntegrationLog(request, response, attributeMap, reqSentTime, resRecvTime);
            }
        }
        
        ApexPages.addMessage(myMsg1);
        PageReference savepage = Page.Shiprocket_Fwd_courier;
        savepage.getParameters().put('id',ID);
        savepage.setRedirect(false);
        isCreate = true;
        isServicebility = false;
        isAWB = false;
        return savepage;  
    }
    
    public  PageReference CheckForwardServicebility () {
        ShipRocketApiCallout objFwd = new ShipRocketApiCallout();
        objFwd.authentication = authentication; 
        objFwd.caserec = caserec;
        objFwd.warehouse = warehouse; 
        objFwd.page1 = 'ShipRocket_Fwd_Courier'; 
        return objFwd.CheckServicebility();
    }
    
    public PageReference FwdOrderTracking(){
        ShipRocketApiCallout objFwd = new ShipRocketApiCallout();
        objFwd.authentication = authentication; 
        objFwd.page1 = 'ShipRocket_Fwd_Courier';
        objFwd.caserec = caserec;
        return objFwd.ReturnOrderTracking();
    }
    public PageReference Label(){
        GenrateLabel objFwd = new GenrateLabel();
        objFwd.authentication = authentication; 
        objFwd.page1 = 'ShipRocket_Fwd_Courier';
        objFwd.caserec = caserec;
        return objFwd.GetLabel();
    }
    public PageReference FwdCreateAWB(){
        ShipRocketApiCallout objFwd = new ShipRocketApiCallout();
        objFwd.authentication = authentication; 
        objFwd.page1 = 'ShipRocket_Fwd_Courier';
        objFwd.caserec = caserec;
        objFwd.id = id;
        return objFwd.CreateAWB();
    }
    public PageReference FwdPickup(){
        ShipRocketApiCallout objFwd = new ShipRocketApiCallout();
        objFwd.authentication = authentication; 
        objFwd.page1 = 'ShipRocket_Fwd_Courier';
        objFwd.caserec = caserec;
        objFwd.id = id;
        return objFwd.pickup();
    }
}