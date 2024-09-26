import { LightningElement, track,wire, api} from "lwc";
import getEmailTemplate from '@salesforce/apex/UserAssignmentController.getEmailTemplate';
import getEmailTemplateBody from '@salesforce/apex/UserAssignmentController.getEmailTemplateBody';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import CASEID_FIELD from '@salesforce/schema/Case.Id';
import CASE_REASON from '@salesforce/schema/Case.Case_Closure_Reason_Open_as_Error_Open__c';
import CASESTATUS_FIELD from '@salesforce/schema/Case.Status';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import getCaseEmail from '@salesforce/apex/UserAssignmentController.getCaseEmail';
import getCaseRecord from '@salesforce/apex/UserAssignmentController.getCaseRecord';
import CaseEmails from '@salesforce/apex/UserAssignmentController.CaseEmails';
import CASE_MAILID from '@salesforce/schema/Case.SuppliedEmail';
import CaseEmailDetial from '@salesforce/apex/UserAssignmentController.CaseEmailDetial';

export default class CustomModal extends LightningElement {

@api recordId;
caseRecords;
@track mailsId;
//@track subBody;
case
@track toname;

emailAddress='';

@track isShowModal = false;
    showModalBox() {  
        this.isShowModal = true;       
    }
    hideModalBox() {  
        this.isShowModal = false;
    }
    @api EmailTemplateid;
    toAddress = this.emailAddress ;
    ccAddress = [];
    subject = "";
    body = "";
    @track files = [];
    simpleBodyArray =[];
    
    @track l_All_Template;
    @track TemplateOptions;
    error;
    
    //reason variable
    reason='';
    casemail;
     
    wantToUploadFile = false;
    noEmailError = false;
    invalidEmails = false;
 
    //handle Resason
    handleReason(event)
    {
        this.reason =  event.target.value;
    }

    get Options(){
        return this.TemplateOptions;
    }

        //    picklistfield of object
        @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
        casefiledinfo;

        //   picklistfield of countryd
        @wire(getPicklistValues,{
            recordTypeId: '$casefiledinfo.data.defaultRecordTypeId', 
            fieldApiName: CASE_REASON
        })
        Reason_Picklist;

        @api objectApiName= CASE_OBJECT;
        // @api recordId = '';

     //update case
        
     updateCase(){
        const fields = {};
        console.log('ObjectApiName'+this.objectApiName);
        console.log('strCaseID '+this.recordId);
        fields[CASEID_FIELD.fieldApiName] = this.recordId;
        fields[CASESTATUS_FIELD.fieldApiName] = 'Resolved';
        fields[CASE_REASON.fieldApiName] = this.reason;
        fields[CASE_MAILID.fieldApiName] = this.emailAddress;
        console.log('mail id' +this.emailAddress)
        const recordInput = { fields };
        updateRecord(recordInput)
        .then(() => {
            console.log('I am in update records')
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Case Updated',
                    variant: 'success'
                })
            );
        })
        .catch(error => {
            console.log(error);
        });


if(this.mailsId){
    
    CaseEmails({cs:this.caseRecords, TemplateId: this.mailsId })
    .then(() => {
        this.handleReset();``
        this.hideModalBox();
   
        console.log("caseemail message through selected template");
        console.log("result"+TemplateId);
        })
    .catch((error) => {
        console.error("Error in sendEmailController:", error);
    });  
   
}
else{

    CaseEmailDetial({body:this.body, subject: this.subject, toAdd:this.emailAddress })
    .then(() => {
       this.handleReset();
       //this.handleTemplate();
        this.hideModalBox();
        console.log("caseemail send through custom template");
        //console.log("result"+TemplateId);
    })
    .catch((error) => {
        console.error("Error in sendEmailController:", error);
    });  


}
        let emailDetails = {
            toAddress: this.toAddress,
            ccAddress: this.ccAddress,
            subject: this.subject,
            body: this.body
        };
    }

    
    @wire(getCaseEmail) cases;
      
    
    //fetch Email template
    connectedCallback() {
        
            this.handleTemplate();
            this.handleCaseRecord();
    }

    // call get template
        handleTemplate(){
            getEmailTemplate()
            .then(result => {
                console.log("---data==="+result);
                let arr = [];
                for (var i = 0; i < result.length; i++) {
                    arr.push({label: result[i].DeveloperName, value: result[i].Id});
                    console.log("---Id==="+result[i].Id);
                    
                }
                this.TemplateOptions = arr;
                
            })
            .catch(error => {
                alert(JSON.stringify(error));
                console.log('EMAIL TEMPLATE'+error);
            });
        }

        //handleGetCaseRecord
        handleCaseRecord(){
            
            getCaseRecord({caseId:this.recordId})
            .then(result=>{
                console.log('result is ' + JSON.stringify(result));
                this.emailAddress = result.SuppliedEmail;
                this.caseRecords = result;
            })
            .catch(error=>{
                console.log('error is'  + error)
            })
        }
    

    toggleFileUpload() {
        this.wantToUploadFile = !this.wantToUploadFile;
    }

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        this.files = [...this.files, ...uploadedFiles];
        this.wantToUploadFile = false;
    }

    handleRemove(event) {
        const index = event.target.dataset.index;
        this.files.splice(index, 1);
    }

   
    handleToFieldChange(event){
        this.toname = event.detail.value;
   }


    handleSubjectChange(event) {
        this.subject = event.target.value;
        console.log('===Subject==='+this.subject)

    }

    handleBodyChange(event) {
        this.body = event.target.value;
        console.log('===Body==='+this.body)

    }

    validateEmails(emailAddressList) {
        let areEmailsValid;
        if(emailAddressList.length > 1) {
            areEmailsValid = emailAddressList.reduce((accumulator, next) => {
                const isValid = this.validateEmail(next);
                return accumulator && isValid;
            });
        }
        else if(emailAddressList.length > 0) {
            areEmailsValid = this.validateEmail(emailAddressList[0]);
        }
        return areEmailsValid;
    }

    validateEmail(email) {
        console.log("In VE");
        const res = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()s[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        console.log("res", res);
        return res.test(String(email).toLowerCase());
    } 

    handleReset() {
        this.toAddress = [];
        this.ccAddress = [];
        this.subject = "";
        this.body = "";
        this.files = [];
        this.mailsId ="";
        this.TemplateOptions = {};
        this.reason = "";
        this.handleTemplate();
        this.template.querySelectorAll("c-email-input").forEach((input) => input.reset());
    }

    
    handleTemplateChange(event){
        this.mailsId = event.detail.value;

        
        
        console.log( "Mail Id" + this.mailsId);
        getEmailTemplateBody({mailId : this.mailsId}).then(result => {
            console.log('result='+result);
            for (var i = 0; i < result.length; i++) {
                this.body = result[i].Body;
                this.simpleBodyArray = result[i].Body;
                this.subject = result[i].Subject;
                this.toname = result[i].SuppliedEmail;
                console.log('subject='+this.subject);
                console.log('body='+this.body);
                console.log('simple'+i+''+this.simpleBodyArray)
            }
        })
        .catch((error) => {
            console.error("Error in sendEmailController:", error.body.message);
        });
    }
}