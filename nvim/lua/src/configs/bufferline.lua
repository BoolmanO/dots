local mocha = require("catppuccin.palettes").get_palette "mocha"
require("bufferline").setup {
  highlights = require("catppuccin.groups.integrations.bufferline").get {
    styles = { "bold" },
    custom = {
      all = {
        fill = { bg = mocha.base },
      },
      mocha = {
        background = { fg = mocha.text },
      },
    },
  },
  options = {
     indicator = {
      icon = ' 󰐊 ', -- ▎▎this should be omitted if indicator style is not 'icon'
      style = 'icon', -- icon | underline | none
    },
    offsets = {
      {
        filetype = "neo-tree",
        text = "Ты думал здесь что-то будет?",
        text_align = "center",
        separator = false,
      }
    },
  }
}
