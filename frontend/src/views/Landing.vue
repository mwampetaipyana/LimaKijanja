<script setup>
    import {useRoute, useRouter} from "vue-router";
    import { getSignerContract,setState,resetState, getViewerContract } from '../utils';
    import { ref } from "vue";

    const router = useRouter();
    const LoggedIn = ref(false);

    const  Login = async ()=> {
    const { signer } = await getSignerContract()
    const {contract} = await getViewerContract()
        
        const signerAddress = await signer.getAddress();
        const userType = await contract.Login(signerAddress)
        console.log("usertype : "+ userType);
       if(userType === null)
        return

       if(userType === "admin"){
        setState({signer:signerAddress, status:true});
        router.push("/admin")
       }

       else if(userType === "user"){
        setState({signer:signerAddress, status:true});
        LoggedIn.value = true;
       }

       else {
        alert("UNAUTHORIZED USER");
        return 
       }
      }
      const logout = ()=> {
            LoggedIn.value = false;
            resetState();
            router.push('/')
            alert("Please disconnect from the wallet manually.");
         }
</script>

<template>
    <div class="w-full h-full p-0 ">
        <nav v-show="!LoggedIn" class="bg-gray-600 grid grid-cols-6">
            <div class="col-span-1"></div>

            <div class="col-span-4 p-1 flex justify-end">
                <div class="flex flex-row space-x-4 items-center text-sm">
                    <router-link to="/" @click="Login()" class="text-white border rounded-md bg-[#84b942]   px-4 hover:bg-[#74af46]"><p >Connect</p></router-link>
                </div>
            </div>

            <div class="col-span-1"></div>
        </nav>

        <nav v-show="LoggedIn" class="bg-gray-600 grid grid-cols-6 sticky top-0">
            <div class="col-span-1"></div>

            <div class="col-span-4 p-1 flex justify-end">
                <div class="flex flex-row space-x-4 items-center text-sm">
                    <p
                        :class="{'text-purple-500':useRoute().name == 'myAccount'}"
                        class="hover:text-purple-400 hover:underline text-white p-0">
                        <router-link class="flex items-center" to="/myAccount">
                            <span class="mx-1 material-symbols-outlined">
                                    account_circle
                                </span>
                            My Account</router-link>
                    </p>
                    <p class="text-white">|</p>
                    <p
                      :class="{'text-purple-500':useRoute().name == 'myDeals'}"
                        class="hover:text-purple-400 hover:underline text-white p-0">
                        <router-link class="flex items-center" to="myDeals">
                            <span class="mx-1 material-symbols-outlined">
                             payments
                            </span>My Deals
                        </router-link>
                    </p> 
                    <p class="text-white">|</p>
                    <router-link @click="logout()" to="/"   
                        class="hover:text-purple-400 hover:underline flex flex-row items-center text-white p-0">
                        <span class="material-symbols-outlined">
                            logout
                         </span> 
                        <p>Logout</p>
                      
                    </router-link>

                </div>
            </div>

            <div class="col-span-1"></div>
        </nav>

        <div class="pt-2 bg-white font-sans grid grid-cols-6 border-b-4 border-[#6a9441]">
            <div class="col-span-1"></div>

            <div class="flex col-span-4 justify-between ">
                <h1 class="font-mono text-[#84b942] text-3xl font-bold">
                    <a href="#">LimaKijanja</a>
                </h1>

                <div class="space-x-16 mx-1 text-xl text-bold font-mono flex items-center text-[#6a9441]">
                    <router-link 
                        :class="{'border-[#6a9441]':useRoute().name == 'home', 'border-white': useRoute().name != 'home' }" 
                        class="p-1 border-b-4  hover:border-[#90bc6f]" to="/">HOME
                    </router-link>
                    <router-link 
                        :class="{'border-[#6a9441]':useRoute().name == 'market','border-white': useRoute().name != 'market'}" 
                        class="border-b-4 p-1 hover:border-[#90bc6f] hover:text-[#90bc6f]" to="/market">MARKET
                    </router-link>
                    <router-link 
                        :class="{'border-[#6a9441]':useRoute().name == 'explorer','border-white': useRoute().name != 'explorer'}" 
                        class="border-b-4 p-1 hover:border-[#90bc6f] hover:text-[#90bc6f]" to="/explorer">EXPLORER
                    </router-link>
                </div>
            </div>

            <div class="col-span-1 "></div>
        </div>
      
        <router-view></router-view>

        <footer

         class="fixed bottom-0 w-full mx-auto flex justify-center"><p class="font-mono ">MADE BY CSDFE-GROUP ## MEMBERS.</p></footer>
    </div>
  
</template>
