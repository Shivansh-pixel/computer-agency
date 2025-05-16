import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './'),
      'next/image': path.resolve(__dirname, './src/components/Image.js')
    }
  },
  optimizeDeps: {
    exclude: ['next/image']
  }
})