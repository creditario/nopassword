const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './test/dummy/app/**/*.{erb,rb,js}',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
  ]
}
