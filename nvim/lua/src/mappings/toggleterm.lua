local opts = { noremap = true, silent = true }


vim.keymap.set('n', '<leader>t', ':ToggleTerm<CR>', opts)

function _G.set_terminal_keymaps()
  local t_opts = {buffer = 0,noremap = true, silent = true }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], t_opts)
  -- vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], t_opts)
  -- vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], t_opts)
  -- vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], t_opts)
  -- vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], t_opts)
  -- vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], t_opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
