import React from 'react'
import { Routes, Route } from 'react-router-dom'
import Home from '@/app/page'
import AllProducts from '@/app/all-products/page'
import Product from '@/app/product/[id]/page'
import Cart from '@/app/cart/page'
import AddAddress from '@/app/add-address/page'
import MyOrders from '@/app/my-orders/page'
import OrderPlaced from '@/app/order-placed/page'
import Seller from '@/app/seller/page'
import SellerProductList from '@/app/seller/product-list/page'
import SellerOrders from '@/app/seller/orders/page'

const App = () => {
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/all-products" element={<AllProducts />} />
      <Route path="/product/:id" element={<Product />} />
      <Route path="/cart" element={<Cart />} />
      <Route path="/add-address" element={<AddAddress />} />
      <Route path="/my-orders" element={<MyOrders />} />
      <Route path="/order-placed" element={<OrderPlaced />} />
      <Route path="/seller" element={<Seller />} />
      <Route path="/seller/product-list" element={<SellerProductList />} />
      <Route path="/seller/orders" element={<SellerOrders />} />
    </Routes>
  )
}

export default App