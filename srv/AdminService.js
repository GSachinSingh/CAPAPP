module.exports = cds.service.impl(async function(){

    const  {POs} = this.entities;
    this.on('increaseAmt', async(req)=>{
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