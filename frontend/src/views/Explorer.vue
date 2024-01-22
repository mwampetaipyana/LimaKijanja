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
    <div class="flex  items-center h-[740px] justify-center bg-cover bg-center back-to-back">
        <div class="h-full w-full  py-20 bg-slate-100 bg-opacity-60">
            <VueTable class="mx-auto my-auto w-2/3 border-0 bg-white" :headers="header"  :data="formattedRecords"  :keys="keys" /> 
        </div>

       

    </div>
</template>

<style scoped>
.back-to-back {
  background-image: url('../images/rice3.jpg'); /* Replace with your image path */
}

</style>