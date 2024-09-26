public without sharing class PDFAttachment {

	public static Void getattachPDF(Case cs) {	
	          
		PageReference pdfPage = Page.ShippingPDF;
		Serviceability__c srv= [select DSTARCD__c from Serviceability__c where id =:cs.Serviceability__c];
        string DSTARCD = srv.DSTARCD__c;
        string AWB;
       string Barcode;
        pdfPage.getParameters().put('DSTARCD',DSTARCD);
        pdfPage.getParameters().put('id',cs.id);
        if(cs.AWB__c !=null){
            AWB__C aw = [select Name,BarCode__c from AWB__C where id =:cs.AWB__c];            
            Awb= aw.name;
          
        }
        pdfPage.getParameters().put('Awb',Awb);
         Blob pdfBlob;
		if (!Test.isRunningTest()) {
			pdfBlob = pdfPage.getContent(); //generate the pdf blob
		} else { 
			pdfBlob = Blob.valueOf('Test');
        }
        //unique name for attached file
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
		cDe.LinkedEntityId = cs.Id; // case objectId
	    // Inferred permission, checkout description of ContentDocumentLink object for more details
		cDe.ShareType = 'I';
        insert cDe;
        
	}

}