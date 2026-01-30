return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    -- Setup nvim-treesitter with default install directory
    require('nvim-treesitter').setup({
      install_dir = vim.fn.stdpath('data') .. '/site'
    })

    -- Install parsers
    require('nvim-treesitter').install({ 'vimdoc', 'javascript', 'typescript', 'go', 'lua', 'rust', 'python', 'java' })

    -- Configure custom xdc parser
    vim.api.nvim_create_autocmd('User', {
      pattern = 'TSUpdate',
      callback = function()
        require('nvim-treesitter.parsers').xdc = {
          install_info = {
            path = vim.fn.expand('~/work/odl/operational-data-layer/tree-sitter-xdc'),
            location = 'parser',
            generate = false,
          },
        }
      end
    })

    -- Register xdc filetype
    vim.treesitter.language.register('xdc', 'xdc')

    -- Enable treesitter highlighting for common languages
    local langs = { 'lua', 'vim', 'vimdoc', 'javascript', 'typescript', 'go', 'rust', 'python', 'java', 'markdown' }
    vim.api.nvim_create_autocmd('FileType', {
      pattern = langs,
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
