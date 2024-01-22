<script setup>
    import { ref } from "vue";
    import {useRoute, useRouter} from "vue-router"
    import { resetState} from '../../utils';

    const isExpanded = ref(true)
    const router = useRouter()

    const  toggleSidebarWidth = ()=> {
        isExpanded.value = !isExpanded.value;
    }

    const logout = ()=> {
            resetState();
            router.push('/')
            alert("Please disconnect from the wallet manually.");
         }

</script>

<template>
      <div class="h-full min-w-[870px] transition-all duration-900 ">
        <!-- bg-[#84b942] bg-opacity-10 -->
        <div class="h-full w-full flex flex-row">
            <aside id="sidebar" :class="{'w-0':!isExpanded, 'w-[250px]':isExpanded}" class="sidebar h-[calc(100vh-2px)] border-r-2 border-[#6a9441] overflow-hidden bg-white pt-3 ">
                <ul class="">
                    <li class="my-auto w-full h-12 flex items-center border-b-2 border-gray-200">
                        <h1 class="font-mono text-[#71a72f] text-xl font-bold pb-2">
                             <p class="ml-7">LimaKijanja</p>
                        </h1>
                    </li>

                    <li class="w-full h-10">
                        <router-link to="/admin/products"
                        :class="{'border-[#6a9441] bg-opacity-10  bg-[#6a9441]':useRoute().name == 'products', 'border-white': useRoute().name != 'products' }" 
                        class="container  h-full  text-lg pl-5 flex items-center hover:bg-opacity-5 hover:bg-[#6a9441] hover:text-[#319b77] border-r-4  transition duration-100">
                            <p class="text-gray-700">PRODUCTS</p>
                         </router-link>
                    </li>

                    <li class="w-full h-10">
                        <router-link to="/admin/users" 
                        :class="{'border-[#6a9441] bg-opacity-10 bg-[#6a9441]':useRoute().name == 'users', 'border-white': useRoute().name != 'users' }" 
                        class="container  h-full  text-lg pl-5 flex items-center hover:bg-opacity-5 hover:bg-[#6a9441] hover:text-[#319b77] border-r-4   transition duration-100">
                            <p class="text-gray-700">USERS</p>
                        </router-link>
                    </li>

                    <li class="w-full h-10">
                        <router-link to="/admin" 
                        :class="{'border-[#6a9441] bg-opacity-10 bg-[#6a9441]':useRoute().name == 'activity', 'border-white': useRoute().name != 'activity' }" 
                        class="container  h-full  text-lg pl-5 flex items-center  hover:bg-opacity-5 hover:bg-[#6a9441] hover:text-[#319b77] border-r-4   transition duration-100">
                            <p  class="text-gray-700">ACTIVITY</p>
                        </router-link>
                    </li>
                </ul>

            </aside>
            <div class="flex flex-col w-full">
                <nav class="h-[56px] border-b border-gray-200 flex justify-between items-center">
                    <div class="flex flex-row items-center">
                        <h1 :class="{'w-0':isExpanded, 'w-[200px]':!isExpanded}" class="systemName font-mono text-gray-700 text-xl overflow-hidden font-bold">
                             <p class="ml-7">LimaKijanja</p>
                        </h1>

                        <button @click="toggleSidebarWidth()" class="hover:bg-[#84b942] rounded-full mx-1 p-1 flex items-center"> 
                            <span class="material-symbols-outlined ">
                                menu
                            </span>
                        </button>
                    </div>
                    <div class="mx-5">
                        <router-link @click="logout()" to="/"   
                            class="hover:text-[#84b942] hover:underline flex flex-row items-center text-black p-0">
                            <span class="material-symbols-outlined">
                                logout
                            </span> 
                            <p>Logout</p>
                        
                        </router-link>
                    </div>
                   
                </nav>
                <div class=" w-full flex  bg-dark-overlay bg-cover bg-center h-[calc(100vh-56px)]">
                   <div class="w-full h-full bg-slate-100 bg-opacity-80">
                    <router-view ></router-view>     
                   </div>
                     
                </div>
              
            </div>
          
        </div>

    </div>
</template>

<style scoped>
.sidebar ,.systemName {
transition: width 0.3s ease-in-out; /* Use transition for smoother animation */
} 
.container{
    color:white
}
.container:hover{
    color:#319b77
}
.bg-dark-overlay {
  background-image: url('../../images/rice3.jpg'); /* Replace with your image path */
}
</style>