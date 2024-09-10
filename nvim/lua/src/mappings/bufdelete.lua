local bufdel = require('bufdelete')
vim.keymap.set('n', '<leader>x', function() bufdel.bufdelete(0, false) end, {silent=true})
vim.keymap.set('n', '<leader>xf', function() bufdel.bufdelete(0, true) end, {silent=true})
