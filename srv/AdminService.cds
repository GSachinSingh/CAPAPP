using { sachin.db.master as master, sachin.db.transaction as transaction } from '../db/data-model';

service AdminService @(path:'AdminService') {
    @Capabilities.Deletable
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity AddressSet as projection on master.address;
    @readonly
    entity EmployeeSet as projection on master.employees;
    entity ProductSet as projection on master.product;  
    entity POs as projection on transaction.purchaseorder  
    actions{
        action increaseAmt() returns POs;
    };
    entity POItems as projection on transaction.poitems;
}
