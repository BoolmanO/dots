-- My Catppuccin palette that I use

local mocha = require("catppuccin.palettes").get_palette "mocha"
vim.g.mapleader = " " -- Leader
vim.g.maplocalleader = "\\" -- Honestly, I don't remember; I think it's something with buffers.

vim.g.have_nerd_font = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.wo.fillchars='eob: '
vim.api.nvim_command('set fillchars=fold:\\ ,vert:\\│,eob:\\ ,msgsep:‾')

-- Move cursor left and go to the top of the file if at the beginning of the first line
vim.api.nvim_set_keymap('n', 'h', [[v:count == 0 ? (line('.') == 1 && col('.') == 1 ? 'gg' : (col('.') == 1 ? 'gk$' : 'h')) : 'h']], { expr = true, noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Left>', [[v:count == 0 ? (line('.') == 1 && col('.') == 1 ? 'gg' : (col('.') == 1 ? 'gk$' : 'h')) : 'h']], { expr = true, noremap = true, silent = true })

-- Move cursor right and go to the bottom of the file if at the end of the last line
vim.api.nvim_set_keymap('n', 'l', [[v:count == 0 ? (line('.') == line('$') && col('.') == col('$') - 1 ? 'G' : (col('.') == col('$') - 1 ? 'gj0' : 'l')) : 'l']], { expr = true, noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Right>', [[v:count == 0 ? (line('.') == line('$') && col('.') == col('$') - 1 ? 'G' : (col('.') == col('$') - 1 ? 'gj0' : 'l')) : 'l']], { expr = true, noremap = true, silent = true })

local opts = { noremap = true, silent = true }

-- Keep visual selection after indenting
vim.api.nvim_set_keymap('v', '<', '<gv', opts)
vim.api.nvim_set_keymap('v', '>', '>gv', opts)

-- Keep visual selection after yanking
vim.api.nvim_set_keymap('v', 'y', 'ygv<Esc>', opts)

-- Keep visual selection after changing case
vim.api.nvim_set_keymap('v', '~', '~gv', opts)

-- Keep visual selection after substituting
-- vim.api.nvim_set_keymap('v', ':', ':<C-u>gv', opts)

vim.api.nvim_set_keymap('n', 'x', ':lua DeleteIfEmpty()<CR>', { noremap = true, silent = true })

function _G.DeleteIfEmpty()
  local line = vim.api.nvim_get_current_line()
  if line == '' then
    vim.api.nvim_command('normal! dd')
  else
    vim.api.nvim_command('normal! x')
  end
end

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- Synchronize clipboard between the system and the editor
-- If removed, Neovim will use a separate buffer.
-- `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true
vim.opt.signcolumn = 'no' -- Don't remember what this does / something with indentation
vim.opt.updatetime = 100 -- Vim update time??? (Rendering or something). In ms
vim.opt.timeoutlen = 300 -- This defines the time after which which-key will be opened. In ms
vim.opt.inccommand = 'split'
vim.opt.cursorline = false -- Highlights the line where the cursor is
--vim.opt.scrolloff = 13 -- Follow the cursor when reaching line N
vim.opt.hlsearch = true -- Highlight on search

-- Mode / Combination / Action performed
-- Windows
vim.keymap.set('n', '<S-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<S-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<S-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<S-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
--

-- Highlight on yank
vim.api.nvim_set_hl(0, 'YankHighlight', { bg = mocha.surface1 })
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = 'YankHighlight', timeout = 200 })
    end,
})

-- Deselect when going to normal mode
vim.api.nvim_set_keymap('n', '<Esc>', ':noh<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Tab>', ':bnext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-Tab>', ':bprev<CR>',  {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>l', ':bnext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>h', ':bprev<CR>',  {noremap = true, silent = true})

vim.api.nvim_set_keymap('c', '<C-p>', '<C-r>0<Right>', { noremap = true })
vim.api.nvim_set_keymap('n', 'X', '"_x', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'X', '"_x', { noremap = true, silent = true })

-- Global statusline
vim.opt.laststatus=3
