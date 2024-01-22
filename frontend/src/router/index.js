import {createRouter, createWebHistory} from "vue-router"
import LandingView from "../views/Landing.vue"
import HomeVue from "@/views/Home.vue"
import ExplorerVue from "@/views/Explorer.vue"
import MarketVue from "@/views/Market.vue"
import AdminDashboard from "../views/admin/AdmDashboard.vue"
import ActivityVue from "@/views/admin/Activity.vue"
import UsersVue from "@/views/admin/Users.vue"
import ProductsVue from "@/views/admin/Products.vue"
import userDealsVue from "@/views/user/userDeals.vue"
import userAccountVue from "@/views/user/userAccount.vue"
import BoughtProductsVue from "@/components/BoughtProducts.vue"
import SoldProductsVue from "@/components/SoldProducts.vue"
import onSaleProductsVue from "@/components/onSaleProducts.vue"
import { getState } from "@/utils"

const routes = [
    {
        name:"landing",
        path:"/",
        component:LandingView,
        children:[
            {
                name:"home",
                path:"",
                component:HomeVue, 
            },
            {
                name:"market",
                path:"/market",
                component:MarketVue
            },
            {
                name:"explorer",
                path:"/explorer",
                component:ExplorerVue
            },
            {
                name:"myDeals",
                path:"/mydeals",
                component:userDealsVue,

                meta: { requiresMetaMask: true },
                children:[
                    {
                        name:"bought",
                        path:"",
                        component:BoughtProductsVue,
                        
                    },
                    {
                        name:"sold",
                        path:"sold",
                        component:SoldProductsVue,
                        
                    },
                    {
                        name:"onSale",
                        path:"onSale",
                        component:onSaleProductsVue,
                        
                    },
                ]
            },
            {
                name:"myAccount",
                path:"/myaccount",
                component:userAccountVue,
                meta: { requiresMetaMask: true },
            }
        ]
    },
    {
        name : "admin",
        path: "/admin",
        component: AdminDashboard,
        meta: { requiresMetaMask: true },

        children:[
            {
                name:"activity",
                path:"",
                component:ActivityVue,
                
            },
            {
                name:"users",
                path:"users",
                component:UsersVue
            },
            {
                name:"products",
                path:"products",
                component:ProductsVue
            }
        ]
    }
]

const router=createRouter({
    history:createWebHistory(), 
    routes
})

router.beforeEach((to,from, next) => {
    // to and from are both route objects. must call `next`.
    if(to.meta.requiresMetaMask && !getState()){
        //if it requires auth and theres no token
        next('/');
        alert("get Metamask & CONNECT!")
        return;
    }
  
    next()
})
export default router