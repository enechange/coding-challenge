import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()],
  base: '/frontend/',
  server: {
    host: true,
  },
  preview: {
    host: '0.0.0.0',
    port: 5173,
    allowedHosts: [
      'localhost',
      'enecha-publi-yakvtpzir2fc-1409577172.us-east-2.elb.amazonaws.com'
    ]
  }
})
