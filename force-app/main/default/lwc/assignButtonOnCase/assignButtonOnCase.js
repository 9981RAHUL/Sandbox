import { LightningElement,track ,wire, api} from 'lwc';
// import server side apex class method 
import getUserList from '@salesforce/apex/UserAssignmentController.getUserList';
import {updateRecord} from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import CASE_ID  from '@salesforce/schema/Case.Id';
import CASE_OWNER  from '@salesforce/schema/Case.OwnerId';
import CASE_OBJECT from "@salesforce/schema/Case";
import {ShowToastEvent} from 'lightning/platformShowToastEvent'

const columns = [
    { label: 'Owner Name', fieldName: 'Name' }];
  //  { label: 'Role', fieldName: 'UserRole.Name' }];

export default class customSearch extends LightningElement {
  objectApiName = CASE_OBJECT;
    @api recordId =''; 
    newUser ='';
    caseOwnerId ;
columns = columns;

updateOwner ='';
searchValue = '';
searchKey = '';
@track showModal = false;

openModal() {
  this.showModal = true;
  }
  

@wire(getUserList, {searchKey: '$searchKey' })
usr;


searchKeyword(event) {
    this.searchKey = event.target.value;    
}
getSelectedName(event){
    const selectedRows = event.detail.selectedRows;
    console.log('==selectedRows==='+selectedRows)

    for (let i = 0; i < selectedRows.length; i++) {
        this.newUser = selectedRows[i].Id;
        if(this.newUser){
          this.searchKey = selectedRows[i].Name;
        }
        console.log('====searchkey===='+this.searchKey)
     
    }
}

AssignUser() {
  const fields = {};
  fields[CASE_ID.fieldApiName] = this.recordId;
  fields[CASE_OWNER.fieldApiName] = this.newUser;
  
  console.log('get newUser='+this.newUser);
  console.log('get recordId='+this.recordId);

  const recordInput = { fields };

  updateRecord(recordInput)
      .then(() => {
          this.dispatchEvent(
              new ShowToastEvent({
                  title: 'Success',
                  message: 'case updated',
                  variant: 'success'
              })
          );
          
      })
      .catch(error => {
          this.dispatchEvent(
              new ShowToastEvent({
                  title: 'Error creating record',
                  message: error.body.message,
                  variant: 'error'
              })
          );
      })
      this.showModal = false;

      return refreshApex(this.usr);
      

}
 
closeModal2(){
    this.showModal = false;
}

}