const colors = require('tailwindcss/colors');
const creditarioColors = {
  creditario: {
    '50': '#f5f7f8',
    '100': '#eaeff1',
    '200': '#cbd8db',
    '300': '#acc1c6',
    '400': '#6e929b',
    '500': '#306370',
    '600': '#2b5965',
    '700': '#244a54',
    '800': '#1d3b43',
    '900': '#183137'
  },
  'creditario-light': {
    '50': '#fcfdf7',
    '100': '#f9fbef',
    '200': '#f0f5d8',
    '300': '#e7eec1',
    '400': '#d4e292',
    '500': '#c2d563',
    '600': '#afc059',
    '700': '#92a04a',
    '800': '#74803b',
    '900': '#5f6831'
  }
};
module.exports = {
  purge: {
    enabled: 'jit',
    content: [
      './app/views/**/*.html.erb',
      './app/helpers/**/*.rb',
      './app/controllers/**/*.rb',
      './app/javascript/**/*.js',
    ]
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      black: colors.black,
      white: colors.white,
      gray: colors.coolGray,
      red: colors.red,
      yellow: colors.amber,
      indigo: colors.indigo,
      green: colors.emerald,
      creditario: creditarioColors.creditario,
      'creditario-light': creditarioColors['creditario-light'],
    }
  },
  variants: {
    extend: {
      textColor: ['responsive', 'dark', 'group-hover', 'focus-within', 'hover', 'focus', 'active'],
      backgroundColor: ['responsive', 'dark', 'group-hover', 'focus-within', 'hover', 'focus', 'active', 'disabled'],
    },
  },
  plugins: [
    require('@tailwindcss/forms')
  ],
}