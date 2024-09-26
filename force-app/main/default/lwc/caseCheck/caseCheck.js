import { LightningElement, api, track } from 'lwc';
import findCaseData from '@salesforce/apex/caseCheckData.findCaseData'
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import caseMail from '@salesforce/schema/Case.SuppliedEmail';
import { NavigationMixin } from 'lightning/navigation';
import myResource from '@salesforce/resourceUrl/EventIcon';

const FIELDS = [
    caseMail];

export default class CaseCheck extends NavigationMixin(LightningElement) {
    @api recordId;
    addImg = myResource;
    caseEmail = '';
    cases = [];
    casesData;
    title;
    countcase = [];
    @track error;
    allCases;
    @track boolVisible = false;
    @track firstVisible = true;
    firstCases = 3;
    countCases = 0;
    count = [];
    maximumSHowCases = 3;




    connectedCallback() {
        console.log("CONNECTED CALLBACK " + this.caseEmail)
        findCaseData({ recordid: this.recordId })
            .then(result => {

                this.casesData = result;
                for (let i = 1; i <=3; i++) {
                    console.log('this.cases -' + this.casesData[i]);
                    if(this.casesData[i]!=null){
                    this.cases.push(this.casesData[i]);
                }
            }
                console.log('this.cases -' + this.cases);
                this.countCases = this.casesData.length;

                console.log('==cases size===' + cases.size)
            })
            .catch(error => {
                console.error()
            })
    }


    navigateToRecordPage(event) {
        let recordIdVal = event.currentTarget.dataset.code;
        console.log("recordID>>", recordIdVal);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordIdVal,
                objectApiName: 'Case',
                actionName: 'view'
            }
        });
    }


    handleClick(event) {
        this.boolVisible = true
        this.firstVisible = false
        
    }

    closeModal() {
        this.boolVisible = false
        this.firstVisible = true
    }

}