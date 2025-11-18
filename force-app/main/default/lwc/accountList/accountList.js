import { LightningElement, wire, track } from 'lwc';
import getTopAccounts from '@salesforce/apex/AccountController.getTopAccounts';
export default class AccountList extends LightningElement {
    @track accounts;
    @wire(getTopAccounts) wiredAccounts({error, data}){
        if(data) this.accounts = data;
    }
}
