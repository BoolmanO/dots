local palette = require("shared.palette")

return {
    -- highlights which map to a highlight group name and a table of it's values
    -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
    Normal = {
      guifg = palette.lavender,
      guibg = palette.mantle,
    },
    NormalFloat = {
      link = 'Normal'
    },
    FloatBorder = {
      guifg = palette.lavender,
      guibg = palette.surface0,
    },
  }
