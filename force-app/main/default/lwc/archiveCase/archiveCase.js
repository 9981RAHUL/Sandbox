import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import callArchiveCase from '@salesforce/apex/archiveController.archiveCase';

export default class ArchiveCase extends NavigationMixin(LightningElement) {
    @api recordId;
    showArchive = true;
    showSuccess = false;

    @wire(getRecord, { recordId: '$recordId', fields: ['Case.AccountId', 'Case.ContactId'] })
    record;
    

    archiveClick() {
        console.log('archiveClick click:' + this.recordId);

        callArchiveCase({
            'recordId': this.recordId
        })
        .then(result => {
            this.showArchive = false;
            this.showSuccess = true;
            console.log('result'+JSON.stringify(result));
            console.log('Null');
            console.log('this.showSuccess'+this.showSuccess);
        
        })
        .catch(error => {
            console.log('ERROR: ' + JSON.stringify(error));
        });        
    }

    testMethod(){
        console.log('testing');
    }
    navigateToAccount() {
        console.log('navigate to account function');
        console.log(JSON.stringify(this.record));
        console.log('this.recordId'+this.recordId);
        console.log('navigateToAccount: ' + this.record.data.fields.AccountId.value);
        console.log('navigateToAccount: ' + this.record.data.fields.AccountId);

       this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: '001HE000009qHqnYAE',
                actionName: 'view'
            }
        });
    }

    navigateToContact() {
        console.log(JSON.stringify(this.record));
        console.log('navigateToContact: ' + this.record.data.fields.ContactId.value)

      /*  this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.record.data.fields.ContactId.value,
                actionName: 'view'
                
            }
        });*/
    }
}