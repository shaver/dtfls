-- expand tabs as spaces
vim.opt.expandtab = true
-- tab stops and indentation are 4 spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- auto indent in a couple of ways
vim.opt.autoindent = true
vim.opt.smartindent = true

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
