require("config.lazy")

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]

vim.filetype.add({
    extension = {
        templ = "templ",
    }
})

vim.api.nvim_exec([[
  autocmd BufRead,BufNewFile *.xdc set filetype=xdc
]], false)

