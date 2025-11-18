import { LightningElement, wire, track } from 'lwc';
import fetchTopAccounts from '@Salesforce/apex/AccountController.fetchTopAccounts';
export default class AccountList extends LightningElement {
    @track accounts;
    @track error;
    // Reactive parameters to pass into Apex
    minRevenue = 0;       // default: no revenue filter
    limitSize = 20;       // default now matches new Apex default
    industry = '';        // empty = no industry filter
    @wire(fetchTopAccounts, {
        minRevenue: '$minRevenue',
        limitSize: '$limitSize',
        industry: '$industry'
    })
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accounts = undefined;
        }
    }
    get hasAccounts() {
        return this.accounts && this.accounts.length > 0;
    }
}