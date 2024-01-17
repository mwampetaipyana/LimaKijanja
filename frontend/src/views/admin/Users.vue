<script setup>
    import { VueTable  } from "@harv46/vue-table"
    import "@harv46/vue-table/dist/style.css"
    import { getSignerContract,setState,resetState, getViewerContract } from '../../utils';
    import {onMounted, ref} from 'vue'

    const header = ["Institution Name", "address","location"]
    const keys=["name", "walletAddress","location"]

    const data2 = ref([])

    onMounted( async () => {

     getUsers()

    })

    const getUsers = async ()=>{
        const { contract  } = await getSignerContract()
        const users=  await contract.getAllUsers()
        data2.value  = users;
    }
    const data=[
        {
            "orgName" :"John Doe" ,
            "orgAddress":"0x342523452452345",
            "location":"Dar es Salaam, Tanzania"
        },
        {
            "orgName" :"Jane Doe" ,
            "orgAddress":"0x342523452452345",
            "location":"Arusha, Tanzania"
        },
        {
            "orgName" :"Luka Doe" ,
            "orgAddress":"0x342523452452345",
            "location":"Kilimanjaro, Tanzania"
        }
    ]

    const isOpen = ref(false)
    const openOverlay = () =>{
        isOpen.value = true;
    }
    const closeOverlay = ()=>{
        isOpen.value = false;
    }

    const name = ref('')
    const email = ref('')
    const region = ref('')
    const country = ref('')
    const phoneNumber = ref('')
    const walletAddress = ref('')

    const reset = ()=>{
        name.value = ''
        email.value = ''
        region.value = ''
        country.value = ''
        phoneNumber.value = ''
        walletAddress.value = ''
    }



const addUser = async ()=>{
    let location = region.value +", "+ country.value;
    const { contract  } = await getSignerContract()
    contract.register(name.value, email.value, phoneNumber.value,location,walletAddress.value).then((res)=>{
        console.log(res);
        reset();
        getUsers();
        isOpen.value = false;
    })
    
}
</script>

<template>
    <div class="w-full h-full">
            <div v-if="isOpen"
            @click="closeOverlay()"
            class="fixed top-0 left-0 w-full h-full bg-black bg-opacity-50 flex items-center justify-center z-10">

            <div @click.stop :style="dynamicStyles" class="bg-white rounded-md shadow-md overflow-hidden transition-all duration-900 ease-in-out p-4">
                <nav>
                    <button @click="closeOverlay" class="bg-red-600 hover:bg-red-500 hover:shadom-lg text-white px-2 py-1 mt-4 font-bold rounded">X</button>  
                </nav>

                <div class="flex flex-col mb-5"> 
                    <h1 class="border-b border-gray-400 text-xl text-gray-600 font-semibold mb-4">New User Details</h1>

                    <div class="flex flex-col space-y-4">
                            <div>
                                <label class="text-10 text-gray-500 font-semibold flex items-center " for="name">Company / Person's Name</label>
                                <input
                                v-model="name"
                                id="name"
                                type="text"
                                class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                placeholder="Eg.John Doe">
                            </div>
                            <div>
                                <label class="text-10 text-gray-500 font-semibold flex items-center " for="address">Address</label>
                                <input
                                v-model="walletAddress"
                                id="address"
                                type="text"
                                class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                placeholder="0xsdfg34534534534554">
                            </div>
                        
                        
                            <div class="grid grid-cols-2 space-x-4">
                                <div class="col-span-1 flex flex-row space-x-2">
                                    <label class="text-10 text-gray-500 font-semibold flex items-center " for="region">Region</label>
                                    <input
                                    v-model="region"
                                    id="region"
                                    type="text"
                                    class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                    placeholder="Kilimanjaro">
                                </div>

                                <div class="col-span-1 flex flex-row space-x-14">
                                    <label class="text-10 text-gray-500 font-semibold flex items-center " for="country">Country</label>
                                    <input
                                    v-model="country"
                                    id="country"
                                    type="text"
                                    class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                    placeholder="Tanzania">
                                </div>
                            </div>

                            <div class="grid grid-cols-2 space-x-4">
                                
                                <div class="col-span-1 flex flex-row space-x-4">
                                    <label class="text-10 text-gray-500 font-semibold flex items-center " for="region">Email</label>
                                    <input
                                    v-model="email"
                                    id="email"
                                    type="email"
                                    class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                    placeholder="Eg. john@email.com">
                                </div>
                                    
                                <div class="col-span-1 flex flex-row space-x-2">
                                    <label class="text-10 text-gray-500 font-semibold flex items-center " for="country">Phone Number</label>
                                    <input
                                    v-model="phoneNumber"
                                    id="phoneNo"
                                    type="text"
                                    class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                    placeholder="Eg. +25556546456">
                                </div>
                            
                                
                            </div>
                            <div class="w-full flex items-center justify-center p-4">
                                    <button @click="addUser()" class="border w-1/4 border-[#84b942] bg-[#84b942] text-white p-1 rounded-md hover:shadow-xl hover:p-2 transition-all duration-300">ADD</button>
                            </div>
                    </div>
                </div>
            </div>
        </div>

        <div class=" w-full h-full flex flex-col mt-6">
            <div class="mx-auto w-2/3">
                <div class="mx-auto flex justify-end mb-2">
                    <button @click="openOverlay()" class="border border-[#84b942] bg-white text-[#84b942] p-1 rounded-md hover:border-2 hover:text-[#9cdb4e] hover:shadow-md hover:p-2 transition-all duration-300">ADD USER</button>
                </div>
            </div>
            <VueTable class="mx-auto w-2/3 border-0 bg-white" :headers="header"  :data="data2"  :keys="keys" /> 
        </div>
    </div>


</template>