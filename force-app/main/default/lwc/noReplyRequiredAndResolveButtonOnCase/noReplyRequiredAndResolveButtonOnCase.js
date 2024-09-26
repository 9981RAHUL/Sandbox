import { LightningElement, track , wire ,api } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import CASERESOLUTION_REASON from '@salesforce/schema/Case.Case_Closure_Reason_Open_as_Error_Open__c';
import CASEID_FIELD from '@salesforce/schema/Case.Id';
import CASESTATUS_FIELD from '@salesforce/schema/Case.Status';
import CaseDispoSition_Input from '@salesforce/schema/Case.Disposition_Input__c';


import CaseOrigin_Field from '@salesforce/schema/Case.Origin';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';


export default class OpenModelforUpdaterecord extends LightningElement {
    @track isShowModal = false;
    @track isEmailOpen = false;
   // originEmail = CaseOrigin_Field;
     emailOrigin ='';
    @api recordId = '';

    @wire(getRecord, { recordId: '$recordId', fields: [CaseOrigin_Field]})
    record;
    /*  @wire(getRecord, {fields: [CaseOrigin_Field]})
    record;

    get originData() {
       // var originEmail = this.CaseOrigin.data, CaseOrigin_Field;
       // var originEmail = getFieldValue(this.CaseOrigin.data, CaseOrigin_Field);
       if(this.CaseOrigin.data.fields.Origin.value ==='Email'){
        //return CaseOrigin.data.fields.Origin.value;
        console.log('==='+this.CaseOrigin)
        return getFieldValue(this.CaseOrigin.data, CaseOrigin_Field);
        
    }
    }*/


    showModalBox() {  
        this.isShowModal = true;
        this.emailOrigin= this.record.data ? getFieldValue(this.record.data, CaseOrigin_Field) : '';
        this.isEmailOpen= this.emailOrigin==='Email'  ? true : false;



    }

    hideModalBox() {  
        this.isShowModal = false;
    }

    closeModal2(){
        this.isShowModal = false;
    }
    CaseResolutionReason='';
    caseDispositionInput='';
    
            handleCaseResolution(event)
            {
                
            this.CaseResolutionReason =  event.target.value;
            }
            handleCaseDisposition(event){
            this.caseDispositionInput = event.target.value;
                        }

            //    picklistfield of object
            @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
            casefiledinfo;

                //   picklistfield of countryd
                @wire(getPicklistValues,{
                    recordTypeId: '$casefiledinfo.data.defaultRecordTypeId', 
            fieldApiName: CASERESOLUTION_REASON,
            })
             ResolutionReason_Picklist;


             @wire(getPicklistValues,{
                recordTypeId: '$casefiledinfo.data.defaultRecordTypeId', 
        fieldApiName: CaseDispoSition_Input
        })
         CaseDisposition_Picklist;


       // save the data 
            @api objectApiName= CASE_OBJECT;
             //@api recordId = '';
            
           updateCase(){
                const fields = {};
                console.log('ObjectApiName'+this.objectApiName);
                console.log('strCaseID '+this.recordId);
                fields[CASEID_FIELD.fieldApiName] = this.recordId;
                fields[CASESTATUS_FIELD.fieldApiName] = 'Resolved';
                fields[CASERESOLUTION_REASON.fieldApiName] = this.CaseResolutionReason;
                fields[CaseDispoSition_Input.fieldApiName] =this.caseDispositionInput;
                const recordInput = { fields };
                updateRecord(recordInput)
                .then(() => {
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

                
                this.hideModalBox();
             }

}