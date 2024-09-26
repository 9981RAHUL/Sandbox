public without sharing class attachPDFtoCase 
{
    
    private final Case cs; 
    Public String caseNo{get; set;}
    Public String DSTARCD{get; set;}
    Public String City{get; set;}
    Public String Awb{get; set;}
    Public String ProductName{get; set;}
    Public String ProductColor{get; set;}
    Public String ContactName{get; set;}
    Public String Street{get; set;}
    Public String State{get; set;}
    Public String Zip{get; set;}
    Public String Country{get; set;}
    Public String Barcode{get; set;}
    Public String Phone{get; set;}
    Public String cpartner{get; set;}
    //constructor
    public attachPDFtoCase() {
        Id caseId = System.currentPageReference().getParameters().get('id');
   // Id servicibilitId = System.currentPageReference().getParameters().get('serviceid');
           string DSTARCD1 = System.currentPageReference().getParameters().get('DSTARCD');
 
        this.cs = [select Courier_Partner_Name__c,CaseNumber,id,AWB__c,Product__r.name,Product__r.Product_Color__c,Product_Color__c,Contact_Name__c from case where id =: caseId];
        system.debug(this.cs);
        //Serviceability__c srv= [select DSTARCD__c from Serviceability__c where id =:this.cs.Serviceability__c];
        this.DSTARCD = DSTARCD1;
        this.caseNo = this.cs.CaseNumber;
        Account ac = [select PersonMobilePhone,Name,ShippingStreet,ShippingCity,ShippingState,ShippingCountry,ShippingPostalCode from Account where id =: this.cs.Contact_Name__c];
        System.debug(ac);
        system.debug('********************'+this.cs.AWB__c+'333');
         //    this.Barcode = 'https://www.cognex.com/api/Sitecore/Barcode/Get?data=37632128321&code=BCL_CODE39&width=400&height=20&imageType=PNG&foreColor=%23000000&backColor=%23FFFFFF&rotation=RotateNoneFlipNone' ;
       
        //if(this.cs.AWB__c !=null){
           // AWB__C aw = [select Name,BarCode__c from AWB__C where id =:this.cs.AWB__c];            
           // this.Awb= aw.name;
               this.AWB = System.currentPageReference().getParameters().get('AWB');
 
            this.Barcode = 'https://www.cognex.com/api/Sitecore/Barcode/Get?data='+AWB+'&code=BCL_CODE39&width=400&height=20&imageType=PNG&foreColor=%23000000&backColor=%23FFFFFF&rotation=RotateNoneFlipNone' ;
       // system.debug(this.Barcode);
        //}
        this.cpartner=this.cs.Courier_Partner_Name__c;
        this.City=ac.ShippingCity;
        this.ProductName=this.cs.Product__r.name;
        this.ProductColor=this.cs.Product__r.Product_Color__c;
        this.ContactName=ac.name;
        this.Street=ac.ShippingStreet;
        this.State= ac.ShippingState;
        this.Zip=ac.ShippingPostalCode;
        this.Country=ac.ShippingCountry;
        this.phone=ac.PersonMobilePhone;
      }
    
}