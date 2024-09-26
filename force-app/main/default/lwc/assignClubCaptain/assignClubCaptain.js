import { LightningElement,api, track } from 'lwc';
// import getPlayerList from '@salesforce/apex/assignClubCaptain.getPlayerList';
// import assignClubCaptain from '@salesforce/apex/assignClubCaptain.assignClubCaptain';
import {ShowToastEvent } from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';

const actions = [
    {label : 'Assign', name : 'assign'},
    {label : 'View', name : 'view'},
    {label : 'Delete', name : 'delete'},
];

const columns = [
    {label : 'Players', fieldName : 'Name'},
    {label : 'Goals', fieldName : 'Goals__c'},
    {
        type : 'action',
        typeAttributes : { rowActions : actions},
    },
];

export default class AssignClubCaptain extends NavigationMixin(LightningElement) {
    @track showPlayers = 'Show Players';
    @track isVisible = false;
    @api recordId;

    @track data = [];
    @track playerData = [];

    columns = columns;
    error;
    
    // connectedCallback(){
    //     console.log(this.recordId);

    //     //get player list from apex class
    //     getPlayerList({selectedFromLwc : this.recordId})
    //     .then( result =>{
    //         this.data = result;
    //     })
    //     .catch(error =>{
    //         this.error = error; 
    //     })
    
    // }

    //show hide functionality
    handleClick(event){
        const label = event.target.label;

        if(label === 'Show Players'){
            this.showPlayers = 'Hide Players';
            this.isVisible = true;
        }
        else if(label === 'Hide Players'){
            this.showPlayers = 'Show Players';
            this.isVisible = false;
        }
    }

    handleRowAction(event){
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        switch(actionName){
            case 'assign':
                this.assignCaptain(row);
                break;
            
            case 'view':
                this.navigateToPlayerRecordPage(row);
                break;

            default:
        }
    }

    // assignCaptain(currentRow){
    //     const selectedRow = currentRow;
        
    //     //sending selected row id to apex method assignClubCaptain in lwcRowId
    //     assignClubCaptain({ lwcRowId : selectedRow.Id})
    //     .then(result =>{
    //         this.playerData = result;
    //         console.log('PlayerData',this.playerData);
    //     }) 
    //     .catch(err =>{
    //         this.error = err;
    //     })
    //     console.log("Yqqq");
    //     this.showSuceesToast();
    //     console.log("Yqqq");
    //     window.location.reload; //for refersh page
    //     console.log("Yqqq");
    // }

    showSuceesToast(){
        const event = new ShowToastEvent({
            label : 'Record Updated',
            message : 'Captain Assigned Successfully',
            variant : 'success',
            mode : 'dismissable'
        });
        this.dispatchEvent(event);
        console.log("test");
    }

    //player record page navigation
    navigateToPlayerRecordPage(rowData){
        const palyer = rowData;
        console.log('bbb',palyer.Id);
        this[NavigationMixin.Navigate]({
            type : 'standard__recordPage',
            attributes : {
                recordId : palyer.Id,
                actionName : 'view'
            }
        });
    }
}