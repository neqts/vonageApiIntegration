import { LightningElement, api } from 'lwc';

export default class VonageScheduleMeeting extends LightningElement {
    @api recordId;
    guestUrl;
    @api meetingName;
    @api expirationDate;

    connectedCallback() {
        // Get the current URL
        const currentUrl = window.location.origin;
        console.log('test', currentUrl + 'lightning/r/VonageCall__c/a007R000014VqBMQA0/view');
        // console.log('test  window.location.origin',  window.location.origin);

        // Set the guestUrl to the current URL
        this.guestUrl ='https://youriteams3-dev-ed.develop.lightning.force.com/lightning/r/VonageCall__c/a007R000014VqBMQA0/view';
    }
}