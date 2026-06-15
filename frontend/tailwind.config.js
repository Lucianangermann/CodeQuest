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
        },
      },
      animation: {
        'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
        'bounce-slow': 'bounce 2s infinite',
      },
      backgroundImage: {
        'gradient-quest': 'linear-gradient(135deg, #7c3aed 0%, #1a1a2e 100%)',
      },
    },
  },
  plugins: [require('@tailwindcss/typography')],
}
