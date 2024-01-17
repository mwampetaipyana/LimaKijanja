
<script setup>
    import { useRoute } from 'vue-router';

</script>
<template>
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
                            :class="{'text-[#84b942]':useRoute().name == 'myDeals'}"
                            class="h-16 border-b-2 border-white text-lg  flex items-center justify-center">
                                <router-link to="/mydeals">MY DEALS</router-link>
                            </div>
                         
                        </div>
                    </div>

                    <div class="col-span-3 flex flex-col">
                      

                        <div class="space-y-4 bg-[#84b942] bg-opacity-5 p-3 text-md ">
                          
                            <div class="flex flex-col mb-5"> 
                                <h1 class="border-b border-gray-400 text-xl text-gray-600 font-semibold mb-4">My Account Details</h1>

                                <div class="flex flex-col space-y-4">
                                    <div>
                                        <label class="text-10 text-gray-500 font-semibold flex items-center " for="name">Company / Person's Name</label>
                                        <input
                                        id="name"
                                        type="text"
                                        class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                        placeholder="Eg.John Doe" readonly>
                                         
                                    </div>
                                    <div>
                                        <label class="text-10 text-gray-500 font-semibold flex items-center " for="address">Address</label>
                                        <input
                                        id="address"
                                        type="text"
                                        class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                        placeholder="0xsdfg34534534534554" readonly>
                                    </div>
                                
                                
                                    <div class="grid grid-cols-2 space-x-4">
                                        <div class="col-span-1 flex flex-row space-x-2">
                                            <label class="text-10 text-gray-500 font-semibold flex items-center " for="region">Region</label>
                                            <input
                                            id="region"
                                            type="text"
                                            class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                            placeholder="Kilimanjaro" readonly>
                                        </div>

                                        <div class="col-span-1 flex flex-row space-x-14">
                                            <label class="text-10 text-gray-500 font-semibold flex items-center " for="country">Country</label>
                                            <input
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
                                            id="email"
                                            type="email"
                                            class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                            placeholder="Eg. john@email.com">
                                        </div>
                                           
                                        <div class="col-span-1 flex flex-row space-x-2">
                                            <label class="text-10 text-gray-500 font-semibold flex items-center " for="country">Phone Number</label>
                                            <input
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
           </nav>
        </div>
        <div class="col-span-1"></div>

</div>

</template>