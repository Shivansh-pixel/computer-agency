import React from 'react'
import { Routes, Route } from 'react-router-dom'
import Home from '@/pages/Home'
import AllProducts from '@/pages/AllProducts'
import Product from '@/pages/Product'
import Cart from '@/pages/Cart'
import AddAddress from '@/pages/AddAddress'
import MyOrders from '@/pages/MyOrders'
import OrderPlaced from '@/pages/OrderPlaced'
import Seller from '@/pages/seller'
import SellerProductList from '@/pages/seller/ProductList'
import SellerOrders from '@/pages/seller/Orders'

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