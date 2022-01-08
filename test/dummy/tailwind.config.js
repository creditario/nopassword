function withOpacityValue(variableName) {
  return ({opacityValue}) => {
    opacityValue = opacityValue ?? 1;
    return `rgba(var(${variableName}), ${opacityValue})`
  }
};

module.exports = {
  content: [
    './app/**/*.{erb,rb,js}',
    '../../app/**/*.{erb,rb,js}',
  ],
  theme: {
    extend: {
      textColor: {
        skin: {
          inverted: withOpacityValue('--color-inverted'),
          accented: withOpacityValue('--color-accented'),
          'accented-hover': withOpacityValue('--color-accented-hover'),
          base: withOpacityValue('--color-base'),
          muted: withOpacityValue('--color-muted'),
          dimmed: withOpacityValue('--color-dimmed'),
          error: withOpacityValue('--color-error'),
        }
      },
      backgroundColor: {
        skin: {
          'button-accented': withOpacityValue('--color-accented'),
          'button-accented-hover': withOpacityValue('--color-accented-hover'),
          'button-inverted': withOpacityValue('--color-inverted'),
          'button-inverted-hover': withOpacityValue('--color-inverted-hover'),
          muted: withOpacityValue('--color-muted'),
          dimmed: withOpacityValue('--color-dimmed'),
          accent: withOpacityValue('--color-accent'),
        }
      },
      ringColor: {
        skin: {
          accented: withOpacityValue('--color-border-accented'),
        }
      },
      borderColor: {
        skin: {
          base: withOpacityValue('--color-border-base'),
          accented: withOpacityValue('--color-border-accented'),
        }
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms')
  ],
}
