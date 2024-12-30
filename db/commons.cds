namespace sachin.commons;
using { Currency } from '@sap/cds/common';

type Gender: String(1) enum{
    male = 'M';
    female = 'F';
    undisclosed = 'U';
}

type AmountT: Decimal(10, 2)@(
    Semantic.amount.currencyCode:'CURRENCY_CODE',
    sap.unit:'CURENCY_CODE'
);

aspect Amount:{
    CURRENCY: Currency;
    GROSS_AMOUNT:AmountT @(title: 'Gross Amount');
    NET_AMOUNT:AmountT @(title: 'Net Amount');
    TAX_AMOUNT:AmountT @(title: 'Tax Amount');
}

type Guid: String(32); 

type PhoneNumber  : String(30) @assert.format: '^(?:\+91|91)?[6-9]\d{9}$';
type EmailAddress : String(30) @assert.format: '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

aspect Address {
    HOUSENO : Int16;
    STREET  : String(32);
    CITY    : String(80);
    COUNTRY : String(3);
}
