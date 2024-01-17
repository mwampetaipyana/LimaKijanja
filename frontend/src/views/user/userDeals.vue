<script setup>
    import { ethers } from "ethers";
    import { ref } from "vue";
    import { useRoute, useRouter } from "vue-router";
    import { getSignerContract,setState,resetState, getViewerContract } from '../../utils';
    const newProductModelOpen = ref(false);
    const editDetailsModelOpen = ref(false)

    const toggleNewProductModel = ()=>{
        newProductModelOpen.value = !newProductModelOpen.value; 
    }
    const openEditDetailsModel = ()=>{
        editDetailsModelOpen.value = !editDetailsModelOpen.value;
    }

    const selectedRoute = ref('/mydeals');
    const router = useRouter();

    const navigate = () => {
        router.push(selectedRoute.value);
    }

       const productType =ref('') 
       const region = ref('') 
       const country= ref('') 
       const amount= ref('') 
       const price = ref('') 

    const reset = ()=>{
        productType.value = ''
        region.value = ''
        country.value = ''
        amount.value = ''
        price.value = ''
    }
   
const addProduct = async ()=>{
    let location = region.value +", "+ country.value;
    const { contract  } = await getSignerContract()
    contract.postProduct(productType.value,location,Number(amount.value),ethers.utils.parseEther(price.value.toString()).toString(),"selling").then((res)=>{
        console.log(res);
        reset();
        toggleNewProductModel.value = false;
    })}

</script>

<template>
    <div class="w-full h-full">
        <div v-if="newProductModelOpen"
            @click="closeOverlay()"
            class="fixed top-0 left-0 w-full h-full bg-black bg-opacity-50 flex items-center justify-center z-10">

            <div @click.stop :style="dynamicStyles" class="bg-white rounded-md shadow-md overflow-hidden transition-all duration-900 ease-in-out p-4">
                <nav>
                    <button @click="toggleNewProductModel()" class="bg-red-600 hover:bg-red-500 hover:shadom-lg text-white px-2 py-1 mt-4 font-bold rounded">X</button>  
                </nav>

                <div class="flex flex-col mb-5"> 
                    <h1 class="border-b border-gray-400 text-xl text-gray-600 font-semibold mb-4">POST NEW PRODUCT DETAILS</h1>

                    <div class="flex flex-col space-y-4">
                            <div>
                                <label class="text-gray-600" for="productType">Product Type</label>
                                <!-- Styled Select -->
                                <select v-model="productType" id="productType" class="block w-1/2 px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:border-blue-300 focus:ring focus:ring-blue-200">
                                    <!-- Options -->
                                    <option value="Cashewnut">Cashewnut</option>
                                    <option value="Maize">Maize</option>
                                    <option value="Beans">Beans</option>
                                    <option value="Rice">Rice</option>
                                </select>
                            </div>
                            <div class="grid grid-cols-2 space-x-4">
                                <div class="col-span-1 flex flex-row space-x-4">
                                    <label class="text-10 text-gray-500 font-semibold flex items-center " for="region">Region</label>
                                    <input
                                    v-model="region"
                                    id="amount"
                                    type="text"
                                    class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                    placeholder="Eg. Kagera" required>
                                </div>

                                <div class="col-span-1 flex flex-row space-x-14">
                                    <label class="text-10 text-gray-500 font-semibold flex items-center " for="country">Country</label>
                                    <input
                                    v-model="country"
                                    id="price"
                                    type="text"
                                    class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                    placeholder="Eg. Tanzania" required>
                                </div>
                            </div>
                        
                        
                            <div class="grid grid-cols-2 space-x-4">
                                <div class="col-span-1 flex flex-row space-x-2">
                                    <label class="text-10 text-gray-500 font-semibold flex items-center " for="region">Amount</label>
                                    <input
                                    v-model="amount"
                                    id="amount"
                                    type="text"
                                    class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                    placeholder="in Kgs" required>
                                    
                                </div>

                                <div class="col-span-1 flex flex-row space-x-7">
                                    <label class="text-10 text-gray-500 font-semibold flex items-center " for="price">Price per Kg</label>
                                    <input
                                    v-model="price"
                                    id="price"
                                    type="text"
                                    class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                    placeholder="in Coins" required>
                                </div>
                            </div>
                            <div class="w-full flex items-center justify-center p-4">
                                    <button @click="addProduct()" class="border w-1/4 border-[#84b942] bg-[#84b942] text-white p-1 rounded-md hover:shadow-xl hover:p-2 transition-all duration-300">POST</button>
                            </div>
                        </div>                           
                </div>
            </div>
        </div>
    <div class="grid grid-cols-6 my-20">
        <div class="col-span-1"></div>

        <div class="col-span-4">
           <nav class="w-full">
                <div class="space-x-8 mx-1  font-mono grid grid-cols-4 text-gray-700">
                    <div class="col-span-1 flex flex-col">
                        <div class="h-full w-full bg-[#84b942] bg-opacity-10 min-h-2/3 space-y-4 p-4">
                            <div class="h-36 border-b-2 border-white text-lg font-bold flex flex-col justify-center items-center">
                                <span class="material-symbols-outlined text-6xl">
                                    account_circle
                                </span>
                                <h1>Pius Baraka</h1>
                
                            </div>    
                            <div
                            :class="{'text-[#84b942]':useRoute().name == 'myAccount'}"
                            class="h-16 border-b-2 border-white text-lg flex items-center justify-center">
                                <router-link to="/myAccount">ACCOUNT INFORMATION</router-link>
                            </div>
                            <div 
                            :class="{'text-[#84b942]':useRoute().name == 'bought' || useRoute().name == 'sold' ||useRoute().name == 'onSale' }"
                            class="h-16 border-b-2 border-white text-lg  flex items-center justify-center">
                                <router-link to="/mydeals">MY DEALS</router-link>
                            </div>
                         
                        </div>
                    </div>

                    <div class="col-span-3 flex flex-col">
                        <div class="space-y-4 bg-[#84b942] bg-opacity-5 p-3 text-md ">
                            <div class="w-full flex flex-row justify-between">
                                <div class="relative inline-block text-left">
                                    <label class="text-gray-600" for="productType">Transaction Type/Status</label>
                                    <!-- Styled Select -->
                                    <select v-model="selectedRoute" @change="navigate()" id="productType" class="block w-full px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:border-blue-300 focus:ring focus:ring-blue-200">
                                        <!-- Options -->
                                        <option value="/mydeals">Bought</option>
                                        <option value="/mydeals/sold">Sold</option>
                                        <option value="/mydeals/onSale">on Sale</option>
                                    </select>
                                </div>
                                <div class="flex items-end">
                                    <button @click="toggleNewProductModel()" class="border bg-gradient-to-tr from-[#84b942]  to-[#7c945e]  border-[#84b942] text-white p-1 rounded-md  hover:shadow-md hover:p-2 transition-all duration-300">Post New Product</button>
                                </div>
                            </div>
           
                            <router-view></router-view>

                            
                        </div>
                   
                    </div>
                </div>
           </nav>
        </div>
        <div class="col-span-1"></div>

</div>

    </div>
        
</template>