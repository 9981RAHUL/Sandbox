/**
 * @description       : To Fetch the list of Courier Partner according to Pincode on Person Account shipping field and Pincode mentioned in Servicibility Matrix
 * @author            : Ajtesh
 * @group             : 
 * @last modified on  : 12-07-2020
 * @last modified by  : Ajitesh Singh
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   25 Nov 2020  Ajitesh                              Initial Version
**/
import { api, LightningElement, wire, track } from 'lwc';
import { reduceErrors } from 'c/ldsUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {  getRecordNotifyChange } from 'lightning/uiRecordApi';
import getCourierPartner from '@salesforce/apex/ServicibilityCourierSelectionDataService.getCourierPartner';
import saveCourierPartnerSelected from '@salesforce/apex/ServicibilityCourierSelectionDataService.saveCourierPartnerSelected'

const FIELDS = [
    'Case.Courier_Partner_Name__c'
];

export default class ServicibilityCourierSelection extends LightningElement {
    @api recordId; // Fetching the current case id
    @track courierList;
    @wire(getCourierPartner,{caseId : '$recordId'}) // Fetching Courier Partners applicable for this case from Apex
    courierPartners({error,data}){
        if(error){
            this.courierList = [];
            let message = reduceErrors(error);
            const event = new ShowToastEvent({
                title: 'Something went wrong!',
                message: message[0]+'. Please contact System Administrator!',
                variant : 'error',
            });
            this.dispatchEvent(event);
        }
        else{
            this.courierList = data
        }
    }

   


    get courierPartnersExist(){
        return this.courierList && this.courierList.length>0;
    }
    async handleCourierSelected(event){ // Saving Courier Partner selected to particular case in context
        try{
            let courierPartnerVal = JSON.parse(JSON.stringify(event.target.dataset)).courierpartner;
            let courierPartnerId = event.target.name;
            let resp = await saveCourierPartnerSelected({serviciabilityId : courierPartnerId, caseId : this.recordId, courierPartnerVal : courierPartnerVal});
            console.log(resp);
            if(resp === 'error'){
                const event = new ShowToastEvent({
                    title: 'Courier Partner already selected',
                    message: 'Please contact System Adminstrator for more information!',
                    variant : 'info',
                });
                this.dispatchEvent(event);
            }
            else{
                getRecordNotifyChange([{recordId: this.recordId}]);
            }
            this.closeQuickAction();
        }
        catch(error){
            let message = reduceErrors(error);
            const event = new ShowToastEvent({
                title: 'Something went wrong!',
                message: message[0]+'. Please contact System Administrator!',
                variant : 'error',
            });
            this.dispatchEvent(event);
        }
    }
    closeQuickAction(){ // Closing the opened quick Action
        this.dispatchEvent(new CustomEvent('quickactionclose'));
    }
}