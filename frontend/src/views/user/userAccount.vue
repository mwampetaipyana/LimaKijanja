<script setup>
    import { useRoute } from 'vue-router';
    import { getSignerContract,setState,resetState, getViewerContract, getState } from '../../utils';
    import { onMounted, ref } from 'vue';

    const loggedinUser = ref([])
    const location = ref({region:'',country:''}) 

    onMounted( async () => {
        getUserInfo()
    })

    const getUserInfo =async ()=>{
        const { signer } = await getSignerContract()
        const {contract} = await getViewerContract()

        const signerAddress = await signer.getAddress();
        loggedinUser.value = await contract.getUserInfo(signerAddress);   
        [location.value.region, location.value.country] = loggedinUser.value.location.split(", ");
    }
</script>
<template>
    <div class="grid grid-cols-6 my-20">
        <div class="col-span-1"></div>

        <div class="col-span-4">
           <div class="w-full">
                <div class="space-x-8 mx-1  font-mono grid grid-cols-4 text-gray-700">
                    <div class="col-span-1 flex flex-col">
                
                        <nav class="h-full w-full bg-[#84b942] bg-opacity-10 min-h-2/3 space-y-4 p-4">
                            <div class="h-36 border-b-2 border-white text-lg font-bold flex flex-col justify-center items-center">
                                <span class="material-symbols-outlined text-6xl">
                                    account_circle
                                </span>
                                <h1>{{loggedinUser.name}}</h1>
                            </div>    
                            <div
                            :class="{'text-[#84b942]':useRoute().name == 'myAccount'}"
                            class="h-16 border-b-2 border-white text-lg flex items-center justify-center">
                                <router-link to="/myAccount">ACCOUNT INFORMATION</router-link>
                            </div>
                            <div 
                                :class="{'text-[#84b942]':useRoute().name == 'myDeals'}"
                                class="h-16 border-b-2 border-white text-lg  flex items-center justify-center">
                                    <router-link to="/mydeals">MY DEALS</router-link>
                            </div>  
                        </nav>
                    </div>

                    <div class="col-span-3 flex flex-col">
                      

                        <div class="space-y-4 bg-[#84b942] bg-opacity-5 p-3 text-md ">
                          
                            <div class="flex flex-col mb-5"> 
                                <h1 class="border-b border-gray-400 text-xl text-gray-600 font-semibold flex flex-row mb-4">My Account Details <p class="text-red-500">(These can't be edited)</p></h1>

                                <div class="flex flex-col space-y-4">
                                    <div>
                                        <label class="text-10 text-gray-500 font-semibold flex items-center " for="name">Company / Person's Name</label>
                                        <input
                                        v-model="loggedinUser.name"
                                        id="name"
                                        type="text"
                                        class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                        placeholder="Eg.John Doe" readonly>                        
                                    </div>
                                    <div>
                                        <label class="text-10 text-gray-500 font-semibold flex items-center " for="address">Address</label>
                                        <input
                                        v-model="loggedinUser.walletAddress"
                                        id="address"
                                        type="text"
                                        class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                        placeholder="0xsdfg34534534534554" readonly>
                                    </div>
                                    <div class="grid grid-cols-2 space-x-4">
                                        <div class="col-span-1 flex flex-row space-x-2">
                                            <label class="text-10 text-gray-500 font-semibold flex items-center " for="region">Region</label>
                                            <input
                                            v-model="location.region"
                                            id="region"
                                            type="text"
                                            class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                            placeholder="Kilimanjaro" readonly>
                                        </div>

                                        <div class="col-span-1 flex flex-row space-x-14">
                                            <label class="text-10 text-gray-500 font-semibold flex items-center " for="country">Country</label>
                                            <input
                                            v-model="location.country"
                                            id="country"
                                            type="text"
                                            class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                            placeholder="Tanzania" readonly>
                                        </div>
                                    </div>

                                    <div class="grid grid-cols-2 space-x-4">
                                        
                                        <div class="col-span-1 flex flex-row space-x-4">
                                            <label class="text-10 text-gray-500 font-semibold flex items-center " for="region">Email</label>
                                            <input
                                            v-model="loggedinUser.email"
                                            id="email"
                                            type="email"
                                            class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                            placeholder="Eg. john@email.com">
                                        </div>
                                           
                                        <div class="col-span-1 flex flex-row space-x-2">
                                            <label class="text-10 text-gray-500 font-semibold flex items-center " for="country">Phone Number</label>
                                            <input
                                            v-model="loggedinUser.phoneNumber"
                                            id="phoneNo"
                                            type="text"
                                            class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                            placeholder="Eg. +25556546456">
                                        </div>
                                    
                                    
                                           
                                    </div>
                                </div>
                            </div>
                                
                        </div>
                   
                    </div>
                </div>
            </div>
        </div>
        <div class="col-span-1"></div>

</div>

</template>