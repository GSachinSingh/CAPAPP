using { sachin.db.master as master, sachin.db.transaction as transaction } from '../db/data-model';

service AdminService @(path:'AdminService', requires: 'authenticated-user') {
    function getLargestOrder() returns POs;
    //definition
    function getOrderDefaults() returns POs;
    
    @Capabilities : { Updatable: false, Deletable: true }
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity AddressSet as projection on master.address;
    @readonly
    entity EmployeeSet @(restrict: [ 
                        { grant: ['READ'], to: 'Viewer', where: 'bankName = $user.BankName' },
                        { grant: ['WRITE'], to: 'Admin' }
                        ]) as projection on master.employees;
    entity PurchaseOrderItems as projection on transaction.poitems;
    entity POs @(odata.draft.enabled: true,
    Common.DefaultValuesFunction: 'getOrderDefaults') as projection on transaction.purchaseorder{
        *,
        case OVERALL_STATUS
            when 'P' then 'Pending'
            when 'N' then 'New'
            when 'A' then 'Approved'
            when 'X' then 'Rejected'
            end as OverallStatus: String(10),
        case OVERALL_STATUS
            when 'P' then 2
            when 'N' then 2
            when 'A' then 3
            when 'X' then 1
            end as Criticality: Integer
    }
    actions{
        //instance bound action - automatically you will get a param as KEY of Po
        @Common.SideEffects : {
            $Type : 'Common.SideEffectsType',
            TargetProperties : [
                'in/GROSS_AMOUNT',
            ],
        }
        action boost() returns POs;
        action setOrderProcessing();
    };

    entity ProductSet as projection on master.product;
}
