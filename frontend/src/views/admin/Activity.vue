<script setup>
    import { onMounted, ref } from 'vue';
    import { getViewerContract } from '@/utils';
    import { ethers } from 'ethers';
    import { VueTable  } from "@harv46/vue-table"
    import "@harv46/vue-table/dist/style.css"

    const header = ["Action", "Details","Date"]
    const keys=["action", "details","date"]

     onMounted( async () => {
         getRecords()
    })

    const records = ref([]) 
    const formattedRecords = ref([])

    const getRecords = async () => {
        const { contract  } = await getViewerContract()
        await contract.getTransactionRecords().then((res)=>{
            console.log(res)
            records.value = res;
        })
    
        formattedRecords.value = records.value.map(record => {
            
            return {
                action: record.action,
                details: record.details,
                date: getDate(record.timestamp)
            };
        });
        console.log(formattedRecords.value)
    }

    const getDate = (timestamp) => {
      const timestampValue = ethers.BigNumber.from(timestamp).toNumber() * 1000;
      const date = new Date(timestampValue);
      return date.toISOString().split('T')[0];
    }


</script>

<template>
    <div class="flex justify-center  py-8 bg-[#84b942] bg-opacity-10">

        <VueTable class=" w-2/3 border-0 bg-white" :headers="header"  :data="formattedRecords"  :keys="keys" /> 

    </div>
</template>