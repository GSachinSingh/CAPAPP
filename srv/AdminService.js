module.exports = cds.service.impl(async function(){

    const  {POs, EmployeeSet} = this.entities;
    this.on('boost', async(req)=>{
        try {
            const ID = req.params[0];
            const tx = cds.tx(req);
            await tx.update(POs).with({
                GROSS_AMOUNT: { '+=' : 20000}
            }).where(ID);
        } catch (error) {   
            return 'Error' + error.toString();
        }
    });

        //adding pre-checks using generic handler
        this.before('CREATE', EmployeeSet, async(req,res) => {
            //check the data which has come for insert
            var payload = req.data;
    
            //if emp salary tying to save over 1000000 
            if(payload.salaryAmount > 1000000){
                //throw error
                req.error(500,"OMG! salary over 1mn not allowed!");
            }
            
        });
    
        this.on('getOrderDefaults', async(req, res) => {
            return {OVERALL_STATUS: 'N'};
        });
    
         //Implementation [service.js]
         this.on('setOrderProcessing', POs, async req => {
            const tx = cds.tx(req);
            await tx.update(POs, req.params[0].ID).set({OVERALL_STATUS: 'A'});
        });
    

    this.on('getLargestOrder', async( req, res )=> {
        try {
            const tx = cds.tx(req);
            
            //SELECT * UPTO 1 ROW FROM dbtab ORDER BY GROSS_AMOUNT desc
            const reply = await tx.read(POs).orderBy({
                GROSS_AMOUNT: 'desc'
            }).limit(1);

            return reply;
        } catch (error) {
            return "Error " + error.toString();
        }
    });
});