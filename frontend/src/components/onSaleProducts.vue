<script setup>
    import { getSignerContract,setState,resetState, getViewerContract } from '../utils';
    import { ref, onMounted } from 'vue';
    import { ethers } from 'ethers';

    const posts = ref([])
    const myPosts = ref([])

    const getProducts = async () =>{
            const { contract  } = await getViewerContract()
            const { signer } = await getSignerContract()
            const signerAddress = await signer.getAddress();

            posts.value =await contract.viewProducts().catch((err)=>{
                console.log('Error : ', err);
                invalid.value=true
            })

            myPosts.value = posts.value.filter(product => product.owner === signerAddress)
    
        }

    onMounted( async () => {
            getProducts()
        })


</script>
<template>
    <div class="max-h-[420px] overflow-y-auto">
        <div v-for="(post, index) in myPosts" :key="index"   class="space-y-4  bg-opacity-5 p-3 text-md ">
            <div class="w-full px-auto flex justify-between p-2 border border-blue-600 rounded-lg hover:shadow-md">
                <div class="">
                    <p class="underline">{{post.productName}}</p>
                    <p class="text-blue-600"> {{ ethers.utils.formatEther(post.price).toString() }} Coins/kg</p>
                    <p class="">{{ post.kilograms }}kgs Available </p>
                    <p class="font-bold">At {{post.productDescription}}</p>
                </div>  
            </div>
            
        </div>
    
        <div v-if="! myPosts.length > 0" class="col-span-3 flex flex-col min-h-64">
            <div class="bg-opacity-5 h-full flex items-center justify-center">
                <h1 class="text-2xl text-blue-700">NO POSTS...</h1>
            </div>
        </div>
    </div>
                    
                    
</template>