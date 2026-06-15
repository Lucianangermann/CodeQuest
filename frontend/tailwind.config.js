/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        quest: {
          bg: '#0f0f1a',
          card: '#1a1a2e',
          border: '#2a2a4a',
          purple: '#7c3aed',
          'purple-light': '#9d5cf6',
          'purple-dark': '#5b21b6',
          green: '#22c55e',
          'green-dark': '#16a34a',
          yellow: '#eab308',
          red: '#ef4444',
          text: '#e2e8f0',
          muted: '#94a3b8',
          indigo: '#6366f1',
          'card-2': '#16162a',
          surface: '#12121f',
        },
      },
      animation: {
        'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
        'bounce-slow': 'bounce 2s infinite',
      },
      boxShadow: {
        'glow-sm': '0 0 12px rgba(124, 58, 237, 0.25)',
        'glow': '0 0 24px rgba(124, 58, 237, 0.3)',
        'glow-lg': '0 0 40px rgba(124, 58, 237, 0.25), 0 0 80px rgba(124, 58, 237, 0.1)',
        'card': '0 4px 24px rgba(0, 0, 0, 0.35)',
        'card-hover': '0 8px 32px rgba(0, 0, 0, 0.5)',
      },
      backgroundImage: {
        'gradient-quest': 'linear-gradient(135deg, #7c3aed 0%, #1a1a2e 100%)',
        'gradient-purple': 'linear-gradient(135deg, #7c3aed 0%, #6366f1 100%)',
        'gradient-aurora': 'linear-gradient(135deg, #7c3aed 0%, #a855f7 50%, #6366f1 100%)',
        'gradient-card': 'linear-gradient(135deg, rgba(124,58,237,0.08) 0%, rgba(30,30,60,0) 100%)',
      },
    },
  },
  plugins: [require('@tailwindcss/typography')],
}
