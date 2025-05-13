/*
  # Initial schema setup for e-commerce platform

  1. New Tables
    - users
      - id (uuid, primary key)
      - email (text)
      - full_name (text)
      - role (text)
      - created_at (timestamp)
      
    - products
      - id (uuid, primary key)
      - name (text)
      - description (text)
      - price (numeric)
      - offer_price (numeric)
      - category (text)
      - images (text[])
      - seller_id (uuid, foreign key)
      - created_at (timestamp)
      
    - addresses
      - id (uuid, primary key)
      - user_id (uuid, foreign key)
      - full_name (text)
      - phone_number (text)
      - pincode (text)
      - area (text)
      - city (text)
      - state (text)
      - created_at (timestamp)
      
    - orders
      - id (uuid, primary key)
      - user_id (uuid, foreign key)
      - address_id (uuid, foreign key)
      - total_amount (numeric)
      - status (text)
      - created_at (timestamp)
      
    - order_items
      - id (uuid, primary key)
      - order_id (uuid, foreign key)
      - product_id (uuid, foreign key)
      - quantity (integer)
      - price (numeric)
      - created_at (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
*/

-- Create users table
CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT auth.uid(),
  email text UNIQUE NOT NULL,
  full_name text,
  role text DEFAULT 'customer',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own data" 
  ON users 
  FOR SELECT 
  TO authenticated 
  USING (auth.uid() = id);

CREATE POLICY "Users can update own data" 
  ON users 
  FOR UPDATE 
  TO authenticated 
  USING (auth.uid() = id);

-- Create products table
CREATE TABLE products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  price numeric NOT NULL,
  offer_price numeric NOT NULL,
  category text NOT NULL,
  images text[] NOT NULL,
  seller_id uuid REFERENCES users(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read products" 
  ON products 
  FOR SELECT 
  TO public 
  USING (true);

CREATE POLICY "Sellers can create products" 
  ON products 
  FOR INSERT 
  TO authenticated 
  WITH CHECK (auth.uid() = seller_id AND EXISTS (
    SELECT 1 FROM users WHERE id = auth.uid() AND role = 'seller'
  ));

CREATE POLICY "Sellers can update own products" 
  ON products 
  FOR UPDATE 
  TO authenticated 
  USING (auth.uid() = seller_id);

-- Create addresses table
CREATE TABLE addresses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  full_name text NOT NULL,
  phone_number text NOT NULL,
  pincode text NOT NULL,
  area text NOT NULL,
  city text NOT NULL,
  state text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own addresses" 
  ON addresses 
  FOR SELECT 
  TO authenticated 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create addresses" 
  ON addresses 
  FOR INSERT 
  TO authenticated 
  WITH CHECK (auth.uid() = user_id);

-- Create orders table
CREATE TABLE orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  address_id uuid REFERENCES addresses(id),
  total_amount numeric NOT NULL,
  status text DEFAULT 'pending',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own orders" 
  ON orders 
  FOR SELECT 
  TO authenticated 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create orders" 
  ON orders 
  FOR INSERT 
  TO authenticated 
  WITH CHECK (auth.uid() = user_id);

-- Create order_items table
CREATE TABLE order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid REFERENCES orders(id) ON DELETE CASCADE,
  product_id uuid REFERENCES products(id) ON DELETE CASCADE,
  quantity integer NOT NULL,
  price numeric NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own order items" 
  ON order_items 
  FOR SELECT 
  TO authenticated 
  USING (EXISTS (
    SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid()
  ));

CREATE POLICY "Users can create order items" 
  ON order_items 
  FOR INSERT 
  TO authenticated 
  WITH CHECK (EXISTS (
    SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid()
  ));