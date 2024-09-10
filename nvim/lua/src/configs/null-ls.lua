local function dir_exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end


local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local null_ls = require("null-ls")

local opts = {
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.diagnostics.mypy.with({
      extra_args = function()
        local virtual = ""
        local cwd = os.getenv("PWD") or io.popen("cd"):read()
        if dir_exists(cwd .. "/venv") then
          virtual = cwd .. "/venv"
        elseif dir_exists(cwd .. "/.venv") then
          virtual = cwd .. "/.venv"
        else virtual = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
        end
        return { "--python-executable", virtual .. "/bin/python3" }
      end,
    }),
    null_ls.builtins.diagnostics.ruff,
    null_ls.builtins.diagnostics.flake8,
  },
  on_attach = function (client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({
        group=augroup,
        buffer=bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group=augroup,
        buffer=bufnr,
        callback = function ()
          vim.lsp.buf.format({bufnr=bufnr})
        end,
      })
    end
  end,
 }

return opts
