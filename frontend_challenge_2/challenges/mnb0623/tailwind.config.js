/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        'main-gray': '#d1d5db',
        'secondary-gray': '#f3f4f6',
        'black': '#000',
        'white': '#fff',
        'primary': '#3b82f6',
        'accent': '#ee9b39',
        'warning': '#e66059',
      },
    },
  },
  plugins: [],
};
