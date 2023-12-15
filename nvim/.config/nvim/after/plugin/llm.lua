local llm = require("llm")

--[[
llm.setup({
  api_token = nil, -- cf Install paragraph
  --model = "bigcode/starcoder", -- can be a model ID or an http(s) endpoint
  --model_eos = "<|endoftext|>", -- needed to clean the model's output
  model = "codellama/CodeLlama-13b-hf",
  model_eos = "<EOT>",
  -- parameters that are added to the request body
  query_params = {
    max_new_tokens = 300,
    temperature = 0.2,
    top_p = 0.95,
    stop_tokens = nil,
  },
  -- set this if the model supports fill in the middle



  -- fim = {
  --   enabled = true,
  --   prefix = "<fim_prefix>",
  --   middle = "<fim_middle>",
  --   suffix = "<fim_suffix>",
  -- },
  fim = {
      enabled = true,
      prefix = "<PRE> ",
      middle = " <MID>",
      suffix = " <SUF>",
  },
  debounce_ms = 150,
  accept_keymap = "<C-Tab>",
  dismiss_keymap = "<S-Tab>",
  max_context_after = 5000,
  max_context_before = 5000,
  tls_skip_verify_insecure = false,
  -- llm-ls integration
  lsp = {
    enabled = false,
    bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/llm_nvim/bin/llm-ls",
  },
  tokenizer_path = nil, -- when setting model as a URL, set this var
  context_window = 8192, -- max number of tokens for the context window
  --context_window = 4096,
})
--]]
