import React from 'react'
import ReactDOM from 'react-dom/client'
import { Toaster } from 'react-hot-toast'
import App from './App'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
    <Toaster
      position="top-right"
      toastOptions={{
        duration: 3000,
        style: {
          background: '#1a1a2e',
          color: '#e2e8f0',
          border: '1px solid #2a2a4a',
          borderRadius: '12px',
        },
        success: {
          iconTheme: { primary: '#22c55e', secondary: '#1a1a2e' },
        },
        error: {
          iconTheme: { primary: '#ef4444', secondary: '#1a1a2e' },
        },
      }}
    />
  </React.StrictMode>
)
