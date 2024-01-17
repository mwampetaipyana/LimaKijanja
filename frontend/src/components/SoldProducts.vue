<script setup>
        import { VueTable  } from "@harv46/vue-table"
            import "@harv46/vue-table/dist/style.css"
    

                const header = ["Product type","Amount of Product(kgs)", "Total Payment(Tsh)","Buyer Address"]
                const keys=["product","amount", "payment","address"]

                const data=[
                    {
                        "product":"Cashewnut",
                        "amount" :"20" ,
                        "payment":"1000",
                        "address":"0x342523452452345"
                    },
                    {
                        "product":"Beans",
                        "amount" :"30" ,
                        "payment":"2000",
                        "address":"0x342523452452345"
                    },
                    {
                        "product":"Rice",
                        "amount" :"100" ,
                        "payment":"5000",
                        "address":"0x342523452452345"
                    }
                ]
</script>

<template>
    <div>
        <VueTable class="mx-auto w-full border-0 bg-white" :headers="header"  :data="data"  :keys="keys" /> 
    </div>
</template>