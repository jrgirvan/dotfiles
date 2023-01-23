local home = os.getenv('HOME')
local dap = require('dap')

local dap_python = require('dap-python')

dap_python.setup('~/.virtualenvs/debugpy/bin/python')
dap_python.test_runner = 'pytest'
local configurations = dap.configurations.python
for _, configuration in pairs(configurations) do
  configuration.justMyCode = false
  configuration.subProcess = true
end
--dap.adapters.python = {
--  type = 'executable';
--  command = home .. '/.virtualenvs/debugpy/bin/python';
--  args = { '-m', 'debugpy.adapter' };
--}
--
--dap.configurations.python = {
--  {
--    -- The first three options are required by nvim-dap
--    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
--    request = 'launch';
--    name = "Launch file";
--    justMyCode = false;
--    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
--    args = {'run'};
--    program = "${file}"; -- This configuration will launch the current file if used.
--    pythonPath = function()
--      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
--      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
--      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
--      local cwd = vim.fn.getcwd()
--      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
--        return cwd .. '/venv/bin/python'
--      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
--        return cwd .. '/.venv/bin/python'
--      else
--        return 'python'
--      end
--    end;
--  },
--}