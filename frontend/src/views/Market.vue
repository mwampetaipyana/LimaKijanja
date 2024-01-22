<script setup>
    import { onMounted, ref, watch } from "vue";
    import { getSignerContract,setState,resetState, getViewerContract } from '../utils';
    import { ethers } from "ethers";

    onMounted( async () => {
         getProducts()
    })
    


    const TranscationModelOpen = ref(false);

    const dynamicStyles = ref({
        height : '0px',
        width:'0px',
        transition: 'width 1.0s ease-in-out, height 0.5s ease-in-out'
    });
    const productToBuy = ref([])
    const sellerDetails = ref([])
    
    const getDetails = async (product)=>{
        TranscationModelOpen.value = true;
        dynamicStyles.value.height = '700px'
        dynamicStyles.value.width = '700px'

        productToBuy.value = product;
        const { contract  } = await getSignerContract()
        contract.getUserInfo(product.owner).then((res)=>{
        sellerDetails.value = res;
    })}
    const amountToBuy = ref('')
    const total = ref('')

    const buyProduct = async ()=> {
        const { contract  } = await getViewerContract()
        contract.buyProduct(sellerDetails.value.walletAddress,Number(amountToBuy.value)).catch((res)=>{
       })
    }

    watch(amountToBuy , async () => {

        if(amountToBuy.value != ''){
            const { contract  } = await getViewerContract()
            const totalCalculated =await contract.returnTotalPrice(sellerDetails.value.walletAddress ,Number(amountToBuy.value)).catch((err)=>{
                console.log('Error : ', err); return
            });
            total.value = ethers.utils.formatEther(totalCalculated).toString()
        }
            
    });

    const closeOverlay = ()=>{
        dynamicStyles.value.height = '0px'
        dynamicStyles.value.width = '0px'
        TranscationModelOpen.value = false;
    }

    const products = ref([]); 
    const postsDisplayed = ref([])
    const productTypeSearch = ref('')

    const filteringObject = ref({
        productName: '',
        location: '',
        price: ''
    })

   const PriceSet = (price)=>{
        if(filteringObject.value.price){
            return  Number(ethers.utils.formatEther(price).toString()) <= filteringObject.value.price
        }
        else return true
    } 
  
   const filterProducts = (event, _type) => {
      
        if(event.target.value.toLowerCase() == 'all'){
            filteringObject.value.productName=''
        }
        else{
            switch (_type) {
            case "productName":
                filteringObject.value.productName = event.target.value.toLowerCase()        
                break;

            case "productPrice":
                filteringObject.value.price = Number(event.target.value.toLowerCase())        
                break;

            case "productLocation":
                console.log(event.target.value);
                filteringObject.value.location = event.target.value.toLowerCase()
                break;
        
            default:
                break;
        }
        }

        postsDisplayed.value = products.value.filter(product =>
        product.productName.toLowerCase().includes(filteringObject.value.productName) &&
        product.productDescription.toLowerCase().includes(filteringObject.value.location) &&
        PriceSet(product.price)
        );

   }
   

    const getProducts = async () =>{
        const { contract  } = await getViewerContract()

        products.value =await contract.viewProducts().catch((err)=>{
            console.log('Error : ', err);
            invalid.value=true
        })
        postsDisplayed.value = products.value;

    }
    
</script>

<template>
    <div class="w-full h-full ">
        <div v-if="TranscationModelOpen"
        @click="closeOverlay()"
        class="fixed z-10 top-0 left-0 w-full h-full bg-black bg-opacity-50 flex items-center justify-center">
        
        <div @click.stop :style="dynamicStyles" class="bg-white rounded-md shadow-md overflow-hidden transition-all duration-900 ease-in-out p-4">
            <nav>
                <button @click="closeOverlay()" class="bg-red-600 hover:bg-red-500 hover:shadom-lg text-white px-2 py-1 mt-4 font-bold rounded">X</button>  
            </nav>
            <div class="flex flex-col mb-5">
                <h1 class="border-b border-gray-400 mb-2 text-gray-600 text-xl font-semibold">Product Details</h1>
              
                <div class="flex flex-col">
                    <p class="underline text-xl mb-1">{{productToBuy.productName}}</p>
                    <div class="flex flex-row space-x-4 text-lg">
                        <p class="text-blue-600">{{ ethers.utils.formatEther(productToBuy.price).toString() }}Coins/kg</p>
                        <p class="">{{productToBuy.kilograms}}kgs Available</p>
                        <p class="font-bold">At {{productToBuy.productDescription}}</p>
                    </div>
                </div>
            </div>

            <div class="flex flex-col mb-5">
                <h1 class="border-b border-gray-400 text-xl text-gray-600 font-semibold">Seller Info</h1>

                <div class="flex flex-col space-y-1  text-lg font-normal">
                    <div class="flex flex-row space-x-4">
                        <label >NAME:</label> <p class="text-blue-600"> {{sellerDetails.name}} </p> 
                    </div>
                    <div class="flex flex-row space-x-4">
                        <label for="email">EMAIL:</label> <p class="text-blue-600" id="email">{{sellerDetails.email}}</p> 
                    </div>
                    <div class="flex flex-row space-x-4">
                        <label >ADDRESS:</label> <p class="text-blue-600"> {{sellerDetails.walletAddress}} </p> 
                    </div>
                    <div class="flex flex-row space-x-4">
                        <label for="phoneNO">Phone Number:</label><p class="text-blue-600">{{sellerDetails.phoneNumber}}</p>
                    </div>
            
                </div>
            </div>
            <div class="flex flex-col space-y-2">
                <h1 class="border-b border-gray-400 text-xl text-gray-600 font-semibold">Transaction Details</h1>

                <div class="flex flex-row space-x-2">
                    <label class="text-10 text-gray-500 font-semibold flex items-center " for="amount">Amount of Product to be bought</label>
                    <input
                    v-model="amountToBuy"
                    id="amount"
                    type="text"
                    class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                    placeholder="(in Kgs) Eg : 300">
                 </div>
           </div>
            <div v-if="amountToBuy"  class="bg-blue-600 bg-opacity-5 border rounded-md border-blue-600 flex flex-col items-center p-4 justify-center mt-8">
                <div class="text-10 text-gray-500 font-semibold flex items-center mr-1" >Price for the <h1 class="m-1 text-xl text-bold text-blue-600"> {{ amountToBuy }} kgs </h1> of {{productToBuy.productName}}</div>
                <div class="text-2xl mb-4">{{total}}Coins Total</div>
            </div>

            <div v-if="amountToBuy"  class="w-full flex justify-end p-4">
                <button @click="buyProduct()" class="border w-1/4 border-[#84b942] bg-[#84b942] text-white p-1 rounded-md hover:shadow-xl hover:p-2 transition-all duration-300">BUY</button>
            </div>
    
        </div>
    </div>

    <div class="grid grid-cols-6 my-20 ">
        <div class="col-span-1"></div>

        <div class="col-span-4">
           <nav class="w-full">
                <div class="space-x-8 mx-1  font-mono grid grid-cols-4 text-gray-700">
                    <div class="col-span-1 flex flex-col ">
                        <div class="p-1 text-xl flex flex-row space-x-2 text-bold ">
                            <span class="material-symbols-outlined">
                               tune
                            </span>
                            <h1>FILTER</h1>
                        </div>

                        <div class="h-full w-full bg-[#84b942] bg-opacity-20 min-h-2/3 space-y-4 p-4 flex-shrink-0">
                               
                            <div class="relative inline-block text-left">
                                <label class="text-gray-600" for="productType">Product Type</label>
                                <!-- Styled Select -->
                                {{ productTypeSearch }}
                                <select  @input="filterProducts($event, 'productName')" id="productType" class="block w-full px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:border-blue-300 focus:ring focus:ring-blue-200">
                                    <!-- Options -->
                                    <option value="All">All</option>
                                    <option value="Cashewnut">Cashewnut</option>
                                    <option value="Maize">Maize</option>
                                    <option value="Beans">Beans</option>
                                    <option value="Rice">Rice</option>

                                </select>
                                
                            </div>
                            <div class="relative text-left flex flex-col">
                                <label class="text-gray-600" for="location">Location</label>
                                <!-- Styled Select -->
                                <input
                                    id="location"
                                    @input="filterProducts($event, 'productLocation')"
                                    type="text"
                                    class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                    placeholder="Eg..kagera">
                            </div>
                            <div class="relative flex flex-col text-left">
                                <label class="text-gray-600" for="price">Price less than </label>
                                <!-- Styled Select -->
                                <input
                                id="price"
                                @input="filterProducts($event, 'productPrice')"
                                type="text"
                                class="border-2 w-1/2 border-gray-300 focus:outline-none focus:border-blue-500 rounded-md p-2 "
                                placeholder="(In Coin)">
                            </div>
  

                        </div>
                    </div>

                    <div v-if="postsDisplayed.length > 0 " class="col-span-3 flex flex-col flex-grow ">
                        <div class="p-1 text-xl text-bold">
                            <h1>OFFERS BY SELLERS</h1>
                        </div>

                        <div class="h-[480px] overflow-y-auto">
                            <div v-for="(product, index) in postsDisplayed" :key="index"   class="space-y-4 bg-[#84b942] bg-opacity-10 p-3 text-md ">
                                <div class="w-full px-auto flex justify-between p-2 border border-blue-600 rounded-lg hover:shadow-md">
                                    <div class="">
                                        <p class="underline">{{product.productName}}</p>
                                        <p class="text-blue-600"> {{ ethers.utils.formatEther(product.price).toString() }} Coins/kg</p>
                                        <p class="">{{ product.kilograms }}kgs Available </p>
                                        <p class="font-bold">At {{product.productDescription}}</p>
                                        <p class="font-bold text-green-700">Posted By {{product.owner}}</p>
                                    </div>  

                                    <div class="flex items-end">
                                        <button @click="getDetails(product)" class="border border-[#84b942] text-[#84b942] p-1 rounded-md hover:text-[#9cdb4e] hover:shadow-md hover:p-2 transition-all duration-300">View Details</button>
                                    </div>
                                </div>
                             </div>
                        </div>
                      
                   
                    </div>
                    <div v-else class="col-span-3 flex flex-col min-h-30">
                        <div class="p-1 text-xl text-bold">
                            <h1>OFFERS BY SELLERS</h1>
                        </div>

                        <div class="bg-[#84b942] bg-opacity-10 h-full flex items-center justify-center">
                            <h1 class="text-2xl text-blue-700">NO POSTS...</h1>
                        </div>
                    </div>
                </div>
           </nav>
        </div>

        <div class="col-span-1"></div>

    </div>
    </div>
 
</template>

<style scoped>
.back-to-back {
  background-image: url('../images/rice3.jpg'); /* Replace with your image path */
}


</style>