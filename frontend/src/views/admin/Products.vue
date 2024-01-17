<script setup>
    import { ethers } from 'ethers';
    import { ref, watch,watchEffect, onMounted } from 'vue';
    import { getSignerContract,setState,resetState, getViewerContract } from '../../utils';
    
    const isOpen = ref((false))
    const productEdited = ref('')
    const prices= ref([]);

    const closeOverlay =async  ()=>{
        await  getPrices()
        productEdited.value = ref('')
        isOpen.value = false;
    }

    const openModel = (product)=> {
        productEdited.value = product;
        isOpen.value = true;
    }

    const priceRangeMin = ref('')
    const priceRangeMax = ref('')
   
    onMounted( async () => {
        getPrices()
    })
 
    const pricesRice = ref({min:'',max:'' })
    const pricesCashewnut = ref({min:'',max:'' })
    const pricesMaize = ref({min:'',max:'' })
    const pricesBeans = ref({min:'',max:'' })

    const getPrices = async () =>{
        const { contract  } = await getSignerContract()
        await contract.getPricePerProduct('Cashewnut').then((res)=>{
            prices.value = res;
            pricesCashewnut.value.min = ethers.utils.formatEther(prices.value.min_Price).toString()
            pricesCashewnut.value.max = ethers.utils.formatEther(prices.value.max_Price).toString()
        })
        await contract.getPricePerProduct('Rice').then((res)=>{
            prices.value = res;
            pricesRice.value.min = ethers.utils.formatEther(prices.value.min_Price).toString()
            pricesRice.value.max = ethers.utils.formatEther(prices.value.max_Price).toString()
        })

        await contract.getPricePerProduct('Maize').then((res)=>{
            prices.value = res;
            pricesMaize.value.min = ethers.utils.formatEther(prices.value.min_Price).toString()
            pricesMaize.value.max = ethers.utils.formatEther(prices.value.max_Price).toString()
        })
        await contract.getPricePerProduct('Beans').then((res)=>{
            prices.value = res;
            pricesBeans.value.min = ethers.utils.formatEther(prices.value.min_Price).toString()
            pricesBeans.value.max = ethers.utils.formatEther(prices.value.max_Price).toString()
        })
    }

        const setPrice =async () =>{
        const { contract  } = await getSignerContract()
        contract.setPrice(ethers.utils.parseEther(priceRangeMin.value.toString()).toString(), ethers.utils.parseEther(priceRangeMax.value.toString()).toString(),productEdited.value).then((res)=>{
            console.log(res);
            reset();
        })}

        const reset = () => {
            priceRangeMin.value=''
            priceRangeMax.value=''
            isOpen.value = false
        }
</script>
<template>
    <div class="w-full h-full">
        <div v-if="isOpen"
        @click="closeOverlay()"
        class="fixed top-0 left-0 w-full h-full bg-black bg-opacity-50 flex items-center justify-center z-10">

        <div @click.stop :style="dynamicStyles" class="bg-white rounded-md shadow-md overflow-hidden transition-all duration-900 ease-in-out p-8">
            <nav>
                <button @click="closeOverlay" class="bg-red-600 hover:bg-red-500 hover:shadom-lg text-white px-2 py-1 mt-4 font-bold rounded">X</button>  
            </nav>

            <div class="flex flex-col mb-5"> 
                <h1 class="border-b mb-3 border-gray-400 text-xl text-gray-600 font-semibold flex flex-row">Set <p class="text-black mx-2">{{productEdited}}</p> Price Range</h1>

                <div class="flex flex-col space-y-4">
                    <div class="flex flex-col  items-center ">
                        <label class="text-10 text-gray-500 font-semibold flex items-center " for="name">from</label>
                        <input
                        v-model="priceRangeMin"
                        id="name"
                        type="text"
                        class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                        placeholder="Minimum">
                    </div>
                    <div class="flex flex-col  items-center ">
                        <label class="text-10 text-gray-500 font-semibold flex items-center " for="address">to</label>
                        <input
                        v-model="priceRangeMax"
                        id="address"
                        type="text"
                        class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                        placeholder="Maximum">
                    </div>
                    <div class="w-full flex justify-center p-4">
                            <button @click="setPrice()" class="border w-40 border-[#84b942] bg-[#84b942] text-white p-1 rounded-md hover:shadow-xl hover:p-2 transition-all duration-300">SET PRICE</button>
                    </div>
                </div>
            </div>
        </div>
     </div>


    <div class="bg-white w-2/3 my-5 flex mx-auto p-5 rounded-md ">
        <div class="flex flex-col w-full space-y-4">
                <h1 class="border-b border-gray-400 text-gray-600 text-xl font-semibold " >Products List</h1>
                <div class="w-full flex justify-between p-3 border rounded-sm border-blue-500">
                    <div class="flex flex-col">
                        <p class="text-xl font-medium flex items-center" >Cashewnut</p> 
                        <div class="flex flex-row mr-2 items-center">Price range from <p class="mx-1 text-xl text-blue-700">{{ pricesCashewnut.min }}Coins/kg</p> to <p class="mx-1 text-xl text-blue-700">{{pricesCashewnut.max}}Coins/kg</p></div>
                    </div>
                   <div class="h-full flex items-end">
                        <button @click="openModel('Cashewnut')" class="flex flex-row space-x-2 border p-1 rounded-md border-[#84b942] justify-end hover:bg-[#f8fcf1]  hover:shadow-lg transition-all duration-300 ease-in-out">
                            <div>Update Price Range</div>
                            <span class="material-symbols-outlined">
                                edit
                            </span>
                        </button>
                   </div>
                     
                </div>
               
                <div class="w-full flex justify-between p-3 border rounded-sm border-blue-500">
                    <div class="flex flex-col">
                        <p class="text-xl font-medium flex items-center" >Rice</p> 
                        <div class="flex flex-row mr-2 items-center">Price range from <p class="mx-1 text-xl text-blue-700">{{ pricesRice.min }} Coins/kg</p> to <p class="mx-1 text-xl text-blue-700">{{ pricesRice.max }}Coins/kg</p></div>
                    </div>
                   <div class="h-full flex items-end">
                        <button @click="openModel('Rice')" class="flex flex-row space-x-2 border p-1 rounded-md border-[#84b942] justify-end hover:bg-[#f8fcf1]  hover:shadow-lg transition-all duration-300 ease-in-out">
                            <div>Update Price Range</div>
                            <span class="material-symbols-outlined">
                                edit
                            </span>
                        </button>
                   </div>
                     
                </div>
                <div class="w-full flex justify-between p-3 border rounded-sm border-blue-500">
                    <div class="flex flex-col">
                        <p class="text-xl font-medium flex items-center" >Beans</p> 
                        <div class="flex flex-row mr-2 items-center">Price range from <p class="mx-1 text-xl text-blue-700">{{pricesBeans.min}}/kg</p> to <p class="mx-1 text-xl text-blue-700">{{ pricesBeans.max }}Coins/kg</p></div>
                    </div>
                   <div class="h-full flex items-end">
                        <button @click="openModel('Beans')" class="flex flex-row space-x-2 border p-1 rounded-md border-[#84b942] justify-end hover:bg-[#f8fcf1]  hover:shadow-lg transition-all duration-300 ease-in-out">
                            <div>Update Price Range</div>
                            <span class="material-symbols-outlined">
                                edit
                            </span>
                        </button>
                   </div>
                     
                </div>
                <div class="w-full flex justify-between p-3 border rounded-sm border-blue-500">
                    <div class="flex flex-col">
                        <p class="text-xl font-medium flex items-center" >Maize</p> 
                        <div class="flex flex-row mr-2 items-center">Price range from <p class="mx-1 text-xl text-blue-700">{{ pricesMaize.min }}Coins/kg</p> to <p class="mx-1 text-xl text-blue-700">  {{pricesMaize.max}}Coins/kg</p></div>
                    </div>
                   <div class="h-full flex items-end">
                        <button @click="openModel('Maize')" class="flex flex-row space-x-2 border p-1 rounded-md border-[#84b942] justify-end hover:bg-[#f8fcf1]  hover:shadow-lg transition-all duration-300 ease-in-out">
                            <div>Update Price Range</div>
                            <span class="material-symbols-outlined">
                                edit
                            </span>
                        </button>
                   </div>
                     
                </div>
               
        </div>
    </div>
    </div>
     

</template>
