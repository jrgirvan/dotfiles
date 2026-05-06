-- keymap
--------------------------------------------------------------------------------

-- Navigate to file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Navigate visual lines
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Move Lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Ctrl-L redraws the screen by default. Now it will also toggle search highlighting.
vim.keymap.set("n", "<C-l>", ":set hlsearch!<cr><C-l>", { desc = "Toggle search highlighting" })

-- Toggle visible whitespace characters
vim.keymap.set("n", "<leader>l", ":listchars!<cr>", { desc = "Toggle [l]istchars" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("t", "<C-c>", "<C-\\><C-n>")

vim.keymap.set("n", "<leader>kd", function()
  local log_path = "/tmp/nvim-keylog.txt"
  vim.fn.writefile({}, log_path)

  if vim.g.ctrl_c_keylog_ns then
    vim.on_key(nil, vim.g.ctrl_c_keylog_ns)
    vim.g.ctrl_c_keylog_ns = nil
    print("Ctrl-C key logger stopped: " .. log_path)
    return
  end

  local ns = vim.api.nvim_create_namespace("ctrl_c_keylog")
  vim.g.ctrl_c_keylog_ns = ns

  vim.on_key(function(key)
    local line = string.format("mode=%s key=%q", vim.fn.mode(1), key)
    vim.fn.writefile({ line }, log_path, "a")
  end, ns)

  print("Ctrl-C key logger started: " .. log_path)
end, { desc = "Toggle Ctrl-C key logger" })

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
--vim.keymap.set("n", "ff", vim.lsp.buf.format)

vim.keymap.set("n", "<C-m>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-n>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>cx", "<cmd>cclose<CR>")
vim.keymap.set("n", "[l", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "]l", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<C-Left>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-Down>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-Up>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-Right>", ":wincmd l<CR>")
