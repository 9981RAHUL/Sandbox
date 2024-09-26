public class GenrateLabel {
    public case caserec{get;set;}
    public Authentication_Shiprocket__c authentication{get;set;}
    Public static Object Token{get;set;}
    public string page1{get;set;}
    public DateTime storeGetLabelTime;
    public object AccessToken ()
    {
        ShipRocketApiCallout objFwd = new ShipRocketApiCallout(); 
        objFwd.authentication = authentication;
        return objFwd.ReturnAccessToken();
    }
    public PageReference GetLabel(){
        token= AccessToken();
       system.debug('token'+'******' + token);
       Http http = new Http();
       HttpRequest request = new HttpRequest();
       request.setEndpoint('https://apiv2.shiprocket.in/v1/external/courier/generate/label');
       request.setMethod('POST');
       request.setHeader('Content-Type', 'application/json');
       request.setHeader('Authorization', 'Bearer '+ token +'');
        request.setBody('{ "shipment_id":["'+caserec.SR_Order__r.Shipment_ID__c+'"]}');
    // request.setBody('{ "shipment_id":["109100105"]}');
      ApexPages.Message myMsg1;
        HttpResponse response = http.send(request);
        storeGetLabelTime = System.now();
        System.debug('=== storeGetLabelTime Get Label Field Time is ===' + storeGetLabelTime);
      if (response.getStatusCode() == 200) {
          map<string,object> jsonContent = (map<string,object>)JSON.deserializeUntyped(response.getBody());
          system.debug('JSON:--'+jsonContent);
                
          String url = ''+(String)jsonContent.get('label_url');
         myMsg1 = new ApexPages.Message(ApexPages.severity.CONFIRM,'Label Sucessfully Attached & Saved');
                                        //+jsonContent.get('response')+'--url--'+url);
        system.debug('url---- ' + url);
      AttachLabel(url); 
      }
        else
        {
             System.debug(response.getBody());
        map<string,object> jsonContent = (map<string,object>)JSON.deserializeUntyped(response.getBody());
         myMsg1 = new ApexPages.Message(ApexPages.severity.ERROR,'Error in Attaching the label');
                                        //+jsonContent);
        system.debug('JSON:--'+(String)jsonContent.get('message'));
        }
         ApexPages.addMessage(myMsg1);
         PageReference savepage = new PageReference('/apex/'+page1+'?id='+caserec.Id);
           
        	//update caserec; 
           savepage.setRedirect(false);
        	upDateLabel();
        	return savepage;
    }
    
    
    public void AttachLabel(String url) {
        //PageReference pdf = new PageReference('https://kr-shipmultichannel.s3.ap-southeast-1.amazonaws.com/25149/labels/shipping-label-16104408-788830567028.pdf');
        PageReference pdf = new PageReference(url);
        Blob pdfBlob ;//= pdf.getContent();
        // As during test run we can't use get content method
        if (!Test.isRunningTest()) {
			pdfBlob = pdf.getContent(); //generate the pdf blob
		} else { 
			pdfBlob = Blob.valueOf('Test');
        }
        String name1= 'Attachment'+Datetime.now().format('yyyyMMdd\'T\'HHmmss.SSS')+'.pdf';
		
        ContentVersion conVer = new ContentVersion();
		conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
		conVer.PathOnClient = name1; // The files name, extension is very important here which will help the file in preview.
		conVer.Title =name1; // Display name of the files
		conVer.VersionData = pdfBlob; //  Blog for file
		insert conVer;
        // First get the content document Id from ContentVersion
		Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
 
		//Create ContentDocumentLink
		ContentDocumentLink cDe = new ContentDocumentLink();
		cDe.ContentDocumentId = conDoc;
		//cDe.LinkedEntityId = '5000w000003HiGgAAK'; // case objectId
        cDe.LinkedEntityId = caserec.id;
	    // Inferred permission, checkout description of ContentDocumentLink object for more details
		cDe.ShareType = 'I';
        insert cDe;
    }
    public void upDateLabel(){
    	caserec.GetLabelDateAndTimes__c = storeGetLabelTime;
    	System.debug('=== Final Get Label Field Time is ===' + caserec.GetLabelDateAndTimes__c);
    	update caserec;  
    }   
}