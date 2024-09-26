import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getResolvedCases from '@salesforce/apex/ResolveCasesController.getResolvedCases';

const columns = [
    { label: 'Name', fieldName: 'Name__c', type: 'text' },
    { label: 'User', fieldName: 'User__c', type: 'text' },
    { label: 'Case', fieldName: 'Case_Lookup__c', type: 'text' },
    { label: 'Case Number', fieldName: 'Case_Number__c', type: 'text' },
    {
        label: 'View Case',
        type: 'button',
        typeAttributes: { label: 'View', name: 'view_case', title: 'View Case', variant: 'brand' }
    },
    // Add more columns as needed
];

export default class ResolveCasesList extends NavigationMixin(LightningElement) {
    @track resolveCases;
    @track error;
    columns = columns;
    searchTerm = '';

    originalResolveCases; // Store the original list of resolved cases

    @wire(getResolvedCases)
    wiredCases({ error, data }) {
        if (data) {
            // Map over the resolved cases and add a computed field for Case Name
            this.resolveCases = data.map(resolveCase => ({
                ...resolveCase,
                CaseName: resolveCase.Case_Lookup__r ? resolveCase.Case_Lookup__r.Name : '' // Assuming the API name of the Case relationship is Case_Lookup__r
            }));
            this.originalResolveCases = this.resolveCases; // Store the original list of resolved cases
        } else if (error) {
            this.error = error;
        }
    }

    handleSearchTermChange(event) {
        this.searchTerm = event.target.value;
        this.filterCases();
    }

    filterCases() {
        if (this.searchTerm) {
            // Filter a separate copy of the original list
            this.resolveCases = this.originalResolveCases.filter(
                resolveCase => resolveCase.Case_Number__c.toLowerCase().includes(this.searchTerm)
            );
        } else {
            // If search term is empty, reset to display all records
            this.resolveCases = this.originalResolveCases;
        }
    }

    // Handle click on Case column to open Case record
   /* handleRowSelection(event) {
        console.log('hello world');
        const selectedRow = event.detail.selectedRows[0];
        if (selectedRow && selectedRow.Case_Lookup__c) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: selectedRow.Case_Lookup__c,
                    objectApiName: 'Case',
                    actionName: 'view'
                }
            });
        }
    }*/

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'view_case') {
            if (row && row.Case_Lookup__c) {
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Case_Lookup__c,
                        objectApiName: 'Case',
                        actionName: 'view'
                    }
                });
            }
        }
    }
    
}