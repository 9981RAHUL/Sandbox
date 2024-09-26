import { LightningElement, track, wire } from 'lwc';
import { reduceErrors } from 'c/ldsUtils';
import getProducts from '@salesforce/apex/WebToCaseFormDataService.getProducts';
import submitCaseRec from '@salesforce/apex/WebToCaseFormDataService.submitCaseRec';
import fetchCaseNumber from '@salesforce/apex/WebToCaseFormDataService.fetchCaseNumber';
import getPinCodeData from '@salesforce/apex/WebToCaseFormDataService.getPinCodeData';
import sendWhatsApp from '@salesforce/apex/MessageClass.sendWhatsApp';
import attachFile from '@salesforce/apex/WebToCaseFormDataService.attachFile';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchCustomerName from '@salesforce/apex/WebToCaseFormDataService.fetchCustomerName';
export default class WebToCaseForm extends LightningElement {
@track isOrderIdDisabled = false;
requiredBool = false;
@track selectedMarketplace;
@track ProductFamilyValue;
@track outofWarrantyBoolean = false;
@track saveDisabled = true; //showBool = true; 
@track productList = [];
@track addPurchasedDate;
allData;
@track error;
@track addStreet;
@track addCity;
@track addPincode;
@track addState;
@track showModal2= false;
@track showModal = false;
CurvefamilyOutOfWarranty =false;
CloseOutOfWarranty =false;
pinNumber;  //copyData = '';
isCurveProduct = false;
@track addCountry;
@track isModalOpen = false;
@track isCancelModalOpen = false;
@track caseNumber;
@track customerName;
//ListofpinData = [];
City;
State;
Pin;
@track prodName = [];
@track OutOfWarranty = false;
PhysicalDamage=false;
totalDays;
selectDocument =false;
//productColorList = [{ label: 'Select a product first!', value: '' }];
productPurchasedFromList = [{ label: 'Select a product first!', value: '' }];
productDetMap = new Map();
fileList;
maxDateAllowed =  new Date().toISOString().split('T')[0];
isLoading = false;
typeOfComplaintList = [
{ label: 'Battery Issue', value: 'Battery Issue' },
{ label: 'Buttons Not Working', value: 'Buttons Not Working' },
{ label: 'Charging Issue', value: 'Charging Issue' },
{ label: 'Connectivity Issue', value: 'Connectivity Issue' },
{ label: 'Damaged Product Received', value: 'Damaged Product Received' },
{ label: 'Mic Not Working', value: 'Mic Not Working' },
{ label: 'Noise Disturbance', value: 'Noise Disturbance' },
{ label: 'Not Listed (Specify in Description)', value: 'Not Listed (Specify in Description)' },
{ label: 'Not Turning On', value: 'Not Turning On' },
{ label: 'One side Not Working', value: 'One side Not Working' },
];
get isSaveDisabled() {
        return this.outofWarrantyBoolean || !this.City || !this.State;
    }


     @track productFamilyOptions  = [
        { label: 'True wireless Earbuds', value: 'TWS' },
        { label: 'Smartwatch', value: 'Smartwatch' },
        { label: 'Neckband', value: 'Neckband' },
        { label: 'Wired', value: 'Wired' },
        { label: 'Home Audio', value: 'Home Audio' },
        { label: 'Over Ear Headphones', value: 'Over Ear Headphones' },
         { label: 'Speaker', value: 'Speaker' },
         { label: 'Dashcam', value: 'Dashcam' },
         
    ];

 
    @track filteredProductList = [];
    @track productFamily;
    @track productList = [];
    @track productDetMap = new Map();
    @track productfamilyValue;
    @track isOrderIdDisabled = true;
    @track isOrderIdRequired = false;
    @track isInvoiceDisabled = false;
    @track isInvoiceRequired = true;
    // Properties to control visibility and requirement of Upload Invoice
    @track isUploadInvoiceVisible = true;
    @track isUploadInvoiceRequired = true;
    @track selectDocument = false;
    @track fileList = [];

// canges   
 
//SubComplaintList = [{ label: 'Select a product first!', value: '' }];
case = {
Product__c: null,
SuppliedEmail: null,
SuppliedName: null,
Purchase_Date__c: null,
SuppliedPhone: null,
Product_Color__c: null,
Origin: 'Web',
Product_Purchased_From__c: null,
Order_ID__c: null,
Type: 'Web Ticket',
Issue_Category__c: null,
Type_Of_Sub_Complain__c: null,
Subject: null,
Description: null,
Landmark__c: null,
City__c: null,
State__c: null,
Pin_Code__c: null,
Invoice_Number__c: null,
};

@wire(getProducts,{ productFamily: '$productFamily'}) // Fetching all active products from the org
transformProducts({ error, data }) {
if (error) {
let message = reduceErrors(error);
alert('Something went wrong line number 126!' + message[0] + '. Please contact System Administrator!');
}
else if (data) {
    console.log('this.data'+this.data);
    this.productList = [];
            this.productDetMap.clear();
for (let i of data) {
    this.productDetMap.set(i.Id, i);
    this.productList.push({
        label: i.Name,
        value: i.Id,
       
    });
    this.prodName.push({
        label: i.Product__c,
        value: i.Id,
    });
    
}
this.productList = JSON.parse(JSON.stringify(this.productList));
console.log('===product List====' + JSON.stringify(this.productList));
//console.log('===productFamily====' + JSON.stringify(this.productFamily));
}
}

 handleProductFamilyChange(event) {
        this.productFamily = event.detail.value;
        console.log('this.productFamily'+this.productFamily);
        this.productfamilyValue = this.productFamily;
    }

handleAddressChange(event) { // Handled when Address is changed
this.case['Address_street__c'] = event.detail.street;
this.case['City__c'] = event.detail.city;
this.case['State__c'] = event.detail.province;
this.case['Pin_Code__c'] = event.detail.postalCode;
}
/**
 * @description : Restrict user to enter any alphabet or special character on Support Form's input field.
 * @author Avinash | 17-11-2021 
 **/
handleisNumber(event) {
var a = [8, 9];
var k = event.which;
console.log(event.which);
for (var i = 48; i < 58; i++) { //Allowing only numbers
a.push(i);
}
if (!(a.indexOf(k) >= 0)) {
event.preventDefault();
}

}
handleAddressInput(event) {
//Restricting first character as any Special charater except Hash
if (event.srcElement.value.length == 0 &&
(event.which == 32 || event.which == 44 ||
    event.which == 45 || event.which == 47)) {
event.preventDefault();
return false;
}
var a = [32, 35, 45, 44, 47]; //Allowing comma, space, forward slash and Dash.
var k = event.which;
console.log(event.which);
for (var i = 48; i < 58; i++) { //allowing Numbers
a.push(i);
}
for (var i = 65; i <= 90; i++) { //Allowing Capital Letters
a.push(i);
}
for (var i = 97; i <= 122; i++) { // Allowing Small Letters
a.push(i)
}
if (!(a.indexOf(k) >= 0)) {
event.preventDefault();
}
}

handleChangePincode(event){
// Adding all Case changed value from form to case object
this.pinNumber = event.target.value;
let inputText = event.target;
if(inputText.value >6 || inputText.value.trim().length ==0){
inputText.setCustomValidity("Please enter valid Pincode");
inputText.reportValidity(); 
this.requiredBool = true;
}
console.log('===pinNumber===' +this.pinNumber)
//getting pin data
this.City = '';
this.State = '';
getPinCodeData({ pinNumber: this.pinNumber })
    .then(result => {
        this.allData = result;
        event.preventDefault();
        console.log('this.allData : ' + JSON.stringify(this.allData));
        this.allData.forEach(result => {
            if (result){
            this.City = result.City__c;
            this.State = result.State__c;
            this.Pin = result.Pin_Code__c;
            this.addCity = result.City__c;
            this.addState =  result.State__c;
            this.addPincode = result.PinCode__c;
            inputText.setCustomValidity("");
            inputText.reportValidity();
            this.requiredBool = false;
        }
        if(!result){
            this.City = '';
            this.State = '';
        }

        });

        console.log('this.City : ' + this.City);
        console.log('this.state : ' + this.State);
        console.log('this.pincode : ' + this.addPincode);

        if (this.City && this.State && this.outofWarrantyBoolean == false) {
            console.log('outofWarrantyBoolean'+this.outofWarrantyBoolean);
            this.saveDisabled = false;
            
        }
    }).catch(error => {
        this.error = error;

        console.log('===Error====' + error)
    });
}

handleChange(event) {
   
this.case[event.target.name] = event.target.value;
console.log('event.target.value'+event.target.value);
console.log('this.case[event.target.name]'+this.case[event.target.name]);
if (event.target.name === 'Product__c') { // Populate product color and purchased from list once product is selected  
    var productName = this.template.querySelector(".selectProduct").value;
    console.log('case product selected'+productName);
    if(productName ){
         console.log('product Name=='+productName);
        for(let i of this.productList){
        if(i.value==productName){
        this.prodName = i.label;
         console.log('label is', this.prodName);

         
     }
    }    
    }
    this.PhysicalDamage = true;
this.productPurchasedFromList = [];
//this.productColorList = [];
let productData = this.productDetMap.get(event.target.value);
/*if (productData.Product_Color__c) {
    for (let i of productData.Product_Color__c.split(';')) {
        this.productColorList.push({
            label: i,
            value: i,
        });
    }
} */


/* if (productData.Market_Place_Platform__c) {
    for (let i of productData.Market_Place_Platform__c.split(';')) {
        this.productPurchasedFromList.push({
            label: i,
            value: i,
        });
    }
    
} */


if (productData.Market_Place_Platform__c) {
    // Define the custom order of Market Place Platform
    const customOrder = ['Amazon','Flipkart','Boult Audio Website','Blinkit','Zepto','Myntra','Nykaa','Paytm',
'Tata Cliq','Snapdeal','Croma',
    'CRED','Snapmint','Instamart','Others','Corporate Customer'];

    // Populate the productPurchasedFromList
    let unorderedList = [];
    for (let i of productData.Market_Place_Platform__c.split(';')) {
        unorderedList.push({
            label: i,
            value: i,
        });
    }

    // Sort the unordered list according to the custom order
    this.productPurchasedFromList = unorderedList.sort((a, b) => {
        return customOrder.indexOf(a.value) - customOrder.indexOf(b.value);
    });
}

console.log('hello'+productData.Market_Place_Platform__c);  
console.log(' this.productPurchasedFromList'+ this.productPurchasedFromList);

}
//----------------
const field = event.target.name;


 if (field === 'Market_Place_Platform__c') {
            const selectedValue = event.detail.value;

            if (selectedValue === 'Boult Audio Website') {
                this.isOrderIdDisabled = false;
                this.isOrderIdRequired = true;
                this.isInvoiceDisabled = true;
                this.isInvoiceRequired = true;
                this.isUploadInvoiceVisible = true;
                this.isUploadInvoiceRequired = true;
                this.selectDocument=true;
               
            } else if (selectedValue === 'Corporate Customer') {
                this.isOrderIdDisabled = true;
                this.isOrderIdRequired = false;
                this.isInvoiceDisabled = true;
                this.isInvoiceRequired = false; 
                this.isUploadInvoiceVisible = false;
                this.isUploadInvoiceRequired = false;
                this.selectDocument = true; // Upload not required for Corporate Customer
            } else {
                this.isOrderIdDisabled = true;
                this.isOrderIdRequired = false;
                this.isInvoiceDisabled = false;
                this.isInvoiceRequired = true;
                this.isUploadInvoiceVisible = true;
                this.isUploadInvoiceRequired = true;
                this.selectDocument=true
            }
        }
     

//----------------------------
if(event.target.name === 'Purchase_Date__c') {
    let selectedDateStr = event.target.value;
    console.log('selectedDateStr ----> ' + selectedDateStr);

    // Parse the date string into a Date object
    let selectedDate = new Date(selectedDateStr);
    
    if (isNaN(selectedDate.getTime())) {
        console.error('Invalid date selected!');
        this.errorMessage = 'Please select a valid date!';
        this.OutOfWarranty = true;
        this.totalDays = null;
        return;
    }

    let todaysdate = new Date();
    console.log('Today\'s date ----> ' + todaysdate);

    // Calculate the difference in milliseconds
    let diffDate = todaysdate.getTime() - selectedDate.getTime();
    console.log('Difference in milliseconds ----> ' + diffDate);

    let day = 1000 * 60 * 60 * 24; // Milliseconds in a day
    let daysDiff = Math.trunc(diffDate / day);
    console.log('Days Difference ----> ' + daysDiff);

    // Check if the purchase date is over 455 days
    if (daysDiff > 366) {
        console.log('error message');
        console.log('outofwarranty condition before'+this.outofWarrantyBoolean);
        this.OutOfWarranty = true;
        this.outofWarrantyBoolean = true;
        console.log('outofwarranty condition after'+this.outofWarrantyBoolean);
        this.totalDays = daysDiff;
        this.errorMessage = `Dear Customer, as per the invoice date, your product is out of warranty the no of days is (${daysDiff} days since purchase. and is not eligible for repair/replacement. Please connect with our customer care on +91-9555602502 for any query.
`;
        console.log('Out of Warranty: daysDiff --> ' + this.totalDays);
    } else {
        this.OutOfWarranty = false;
        this.outofWarrantyBoolean = false;
        this.totalDays = daysDiff;
        this.errorMessage = null; // No error message
        console.log('In Warranty: daysDiff --> ' + this.totalDays);
        console.log('WarrantyBoolean value' + this.outofWarrantyBoolean);
        console.log(' this.OutOfWarranty' +  this.OutOfWarranty);
    }
}
if (event.target.name === 'Street') {
this.addStreet = event.target.value;

}
if (event.target.name === 'City') {
this.addCity = event.target.value;

}
if (event.target.name === 'Pincode') {
this.addPincode = event.target.value;
}
if (event.target.name === 'State') {
this.addState = event.target.value;
}

if (event.target.name === 'Country') {
this.addCountry = event.target.value;
}
if(event.target.name=='Purchase_Date__c'){
    this.addPurchasedDate = event.target.value;
}
}

hideModalBox(){  
    this.OutOfWarranty = false;
    this.PhysicalDamage = false;
}

handleUploadFinished(event) { // Store reference of file uploaded and print toast message
this.fileList = event.detail.files;
//condition false for document upload required
        if (this.fileList && this.fileList.length > 0) {
            this.selectDocument = true; // Document is now considered uploaded
            // Alert user about the uploaded file
            alert('File attached! ' + event.detail.files[0].name + ' is tagged!');
            console.log('file uploaded successfully');
            this.selectDocument = false;
        } else if(!this.fileList && this.fileList.length < 0) {
            this.selectDocument = false; // Document not uploaded or removed
            alert('Please File attached! ');
            console.log('file not uploaded');
        }

}

handleContinue() {
this.isCancelModalOpen = false;
}

handleCloseModal() {
window.location.replace("https://www.boultaudio.com");
}
handleSaveForm(caseID) {

this.isLoading = false;
}

handleCancelForm() {// Cancel form 
this.isCancelModalOpen = true;
}

handleSubmit() { // Submit the case form
    /*document upload manadatary on select of particular product
     Name(Curve,Curve pro,Curve X)*/

     if (!this.case.Invoice_Number__c || this.case.Invoice_Number__c.trim() === '') {
        // Set dummy invoice number if not provided
        this.case.Invoice_Number__c = 'DUMMY-INVOICE-ID';
    }
         if (!this.case.Purchase_Date__c) {

            if (this.addPurchasedDate) {
            this.case.Purchase_Date__c = this.addPurchasedDate;
        } else {
            console.error('Purchase Date is not available or set.');
        }
    }

    var productName = this.template.querySelector(".selectProduct").value;
    //console.log('product Name=='+productName);
    if(productName){
        console.log('product Name=='+productName);
        for(let i of this.productList){
        if(i.value==productName){
        //         if((i.label=='Curve X Blue'||i.label=='Curve blue'||i.label=='Curve Pro Green'||i.label=='Curve Black'||i.label=='Curve Black'||i.label=='Curve pro Grey'||i.label=='curve pro red'||i.label=='Curve Red'||i.label=='Curve X Black'||i.label=='BA-CURVEX-Grey') && this.fileList==null){
                
                 console.log('product label is :'+i.label);
               
             // this.selectDocument=true;
                    this.isCurveProduct = true;
                //alert('Please Upload Your Invoice First');
                console.log('var true or not==='+this.selectDocument);
               // }
        if(this.selectDocument === true){
          alert('please upload the invoice first !');
          console.log('line number 465');
          
        }
        //        else if((i.label=='Curve X Blue'||i.label=='Curve blue'||i.label=='Curve Pro Green'||i.label=='Curve Black'||i.label=='Curve Black'||i.label=='Curve pro Grey'||i.label=='curve pro red'||i.label=='Curve Red'||i.label=='Curve X Black'||i.label=='BA-CURVEX-Grey') && (this.fileList!=null)&& ((this.totalDays > 365)||(this.totalDays <=365))){
                    
                   // this.CurvefamilyOutOfWarranty =true;
                    this.isModalOpen = false;
                     console.log('upload document');
                              
              }
         if(this.daysDiff >455){
             //this.CurvefamilyOutOfWarranty =true;
             console.log('CurvefamilyOutOfWarranty label is true:'+daysDiff);
             this.isModalOpen =false;
         }
                  
         }
        
     }
 
if (this.handleValidation()) {
    this.handleCaseCreation();
    this.isModalOpen = true;
}
else {
    this.isLoading = false;
    this.isModalOpen = false;
    alert('Mandatory field missing!Please find all the mandatory fields');
   
}

 if(this.CloseOutOfWarranty ==true){
     console.log('curved family condition')
     this.isModalOpen = false;
 }
 else{
     console.log('main condition modal family condition')
 }
 }

async handleCaseCreation() {// Create case using wire adapter
try {
this.isLoading = true;
console.log('product id==='+this.case.Product__c);

let resp = await submitCaseRec({
    //let resp = submitCaseRec({    
    caseRecStr: JSON.stringify(this.case),
    Streetadd: this.addStreet,
    Cityadd: this.addCity,
    Pincodeadd: this.addPincode,
    Stateadd: this.addState,
    Countryadd: this.addCountry,
    
});
console.log('resp', resp);

let caseRecStr = JSON.stringify(this.case);
console.log('caseRecStr:', caseRecStr);

if (resp === 'duplicate') {
    alert('Case has already been registered with us!');
    this.isLoading = false;
}
//document mandatary
else if (resp === 'MaxCaseReg') {
    alert('You have registered max case as per your invoice product please contact customer care ');
    this.isLoading = false;
} else if (resp === 'MaxWiredCaseReg') {
    alert('You have registered max case for wired product as per your invoice product please contact customer care ');
    this.isLoading = false;
}
else if (resp === 'MaxNwiredCaseReg') {
    alert('You have registered max case for non-wired product as per your invoice product please contact customer care ');
    this.isLoading = false;
}
else {
    if (this.fileList) {
        this.fetchCaseNumberApex(resp);
        this.fetchCustomerNameApex(resp);
        this.handleFileUpload(resp);
    }
    else {
        //this.handleSaveForm(resp);
        this.fetchCaseNumberApex(resp);
        this.fetchCustomerNameApex(resp);
        this.handleSaveForm();
    }
}
}
catch (error) {
this.isLoading = false;
let message = reduceErrors(error);
alert('Something went wrong line number 554!' + message[0] + '. Please contact System Administrator!');
}

}
handleFileUpload(caseId) { // Attaching File to created case rec
  
[...this.fileList].forEach(file => {
let fileReader = new FileReader();
file.sObjectId = caseId;

fileReader.onload = function () {
    let fileContents = fileReader.result;
    let base64Mark = 'base64,';
    let dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
    fileContents = fileContents.substring(dataStart);

    attachFile({
        parentId: file.sObjectId,
        fileName: file.name,
        base64Data: encodeURIComponent(fileContents)

    })
        .then(result => {
            this.isLoading = false;
        })
        .catch(error => {
            this.isLoading = false;
            console.log(error);
            alert('Error');
        });
};
fileReader.readAsDataURL(file);
});
this.handleSaveForm();
}
handleValidation() { // Validating madatory fields
const allValidInput = [...this.template.querySelectorAll('lightning-input')]
.reduce((validSoFar, inputCmp) => {
    inputCmp.reportValidity();
    return validSoFar && inputCmp.checkValidity();
}, true);
const allValidComboBox = [...this.template.querySelectorAll('lightning-combobox')]
.reduce((validSoFar, inputCmp) => {
    inputCmp.reportValidity();
    return validSoFar && inputCmp.checkValidity();
}, true);
const allValidAddress = [...this.template.querySelectorAll('lightning-input-address')]
.reduce((validSoFar, inputCmp) => {
    inputCmp.reportValidity();
    return validSoFar && inputCmp.checkValidity();
}, true);
const allValidTextArea = [...this.template.querySelectorAll('lightning-textarea')]
.reduce((validSoFar, inputCmp) => {
    inputCmp.reportValidity();
    return validSoFar && inputCmp.checkValidity();
}, true);
const hasFile = this.fileList==null ? false : true;
if(!hasFile){
    alert('Please Upload Your Invoice First is has file');
}
console.log('this.isCurveProduct',this.isCurveProduct)
return this.isCurveProduct ? allValidInput && allValidTextArea && allValidAddress && allValidComboBox && hasFile : allValidInput && allValidTextArea && allValidAddress && allValidComboBox;
}

formatDate(date) {
var d = new Date(date),
month = '' + (d.getMonth() + 1),
day = '' + d.getDate(),
year = d.getFullYear();

if (month.length < 2)
month = '0' + month;
if (day.length < 2)
day = '0' + day;

return [year, month, day].join('-');
}

fetchCaseNumberApex(caseIDs) {
fetchCaseNumber({ caseID: caseIDs })
.then(result => {
    console.log('case number', result);
    this.caseNumber = result;
}).catch(error => {
    console.error('errorId', error)
})
}

fetchCustomerNameApex(casesIDS){
    fetchCustomerName({ casesID: casesIDS})
    .then (result =>{
        console.log('Customer Name is===', result);
        this.customerName = result;
    }).catch(error =>{
        console.log('CustomerName errorId', error);
    })
}


sendWhatsAppApex(caseIDs) {
sendWhatsApp({ caseId: caseIDs })
.then(result => {

}).catch(error => {
    console.error('errorId', error)
})
}
showToast() {
    const event = new ShowToastEvent({
        title: 'Upload Invoice',
        message:
            'please upload invoice first',
            variant:'error'
    });
    this.dispatchEvent(event);
}
handleDateChange(event) {
        console.log('this.productfamilyValue'+this.productfamilyValue);
        const newDate = event.target.value;
        console.log('selected date'+newDate);
        const todaysDate = new Date();
        console.log('today date'+todaysDate);
        const dateInputField = event.target;
        const todayFormatted = todaysDate.toISOString().split('T')[0];
        console.log('today date'+todayFormatted);
        const daysDiff = this.calculateDaysDiff(newDate);
        const selectedDateYear = new Date(newDate).getFullYear();
        const currentYear = new Date().getFullYear();
       // Check if the difference is more than 366 days or if the selected year is less than the current year
         


        if (daysDiff > 366 && selectedDateYear < currentYear && this.productfamilyValue !== 'Wired') {
        dateInputField.setCustomValidity("Product is out of warranty.");
        this.outofWarrantyBoolean= true;
         this.showModal = true;
         console.log('tws testing not tws');
    }
           else if (newDate > todayFormatted) {
        dateInputField.setCustomValidity("Purchased Date should be Today or earlier.");
        this.outofWarrantyBoolean= true;
         this.showModal2 = true;
    }
            else if (daysDiff > 90 && selectedDateYear <= currentYear && this.productfamilyValue === 'Wired') {
        dateInputField.setCustomValidity("Product is out of warranty.");
        this.outofWarrantyBoolean= true;
         this.showModal = true;
         console.log('tws testing for tws');
    }          
     else {
        dateInputField.setCustomValidity(""); // Clear the error message
        this.outofWarrantyBoolean=false;      
        this.addPurchasedDate = newDate;
    }
    dateInputField.reportValidity();

        // Re-evaluate save button state dynamically
        if (this.City && this.State && !this.outofWarrantyBoolean) {
            this.saveDisabled = false;
        } else {
            this.saveDisabled = true;
        }
    }

    closeModal() {
        this.showModal = false;
        this.showModal2= false;
    }

    calculateDaysDiff(newDate) {
        const today = new Date();
        const selectedDate = new Date(newDate);
        const diffTime = Math.abs(today - selectedDate);
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        return diffDays;
        
    }


}