return {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    config = function()
        local ls = require("luasnip")
        local types = require "luasnip.util.types"
        -- some shorthands...
        local s = ls.snippet
        local sn = ls.snippet_node
        local t = ls.text_node
        local i = ls.insert_node
        local f = ls.function_node
        local c = ls.choice_node
        local d = ls.dynamic_node
        local r = ls.restore_node
        local l = require("luasnip.extras").lambda
        local rep = require("luasnip.extras").rep
        local p = require("luasnip.extras").partial
        local m = require("luasnip.extras").match
        local n = require("luasnip.extras").nonempty
        local dl = require("luasnip.extras").dynamic_lambda
        local fmt = require("luasnip.extras.fmt").fmt
        local fmta = require("luasnip.extras.fmt").fmta
        local types = require("luasnip.util.types")
        local conds = require("luasnip.extras.conditions")
        local conds_expand = require("luasnip.extras.conditions.expand")

        ls.config.set_config {
            -- This tells LuaSnip to remember to keep around the last snippet.
            -- You can jump back into it even if you move outside of the selection
            history = false,

            -- This one is cool cause if you have dynamic snippets, it updates as you type!
            updateevents = "TextChanged,TextChangedI",

            -- Autosnippets:
            enable_autosnippets = true,

            -- Crazy highlights!!
            -- #vid3
            -- ext_opts = nil,
            ext_opts = {
                [types.choiceNode] = {
                    active = {
                        virt_text = { { " « ", "NonTest" } },
                    },
                },
            },
        }

        local events = require "luasnip.util.events"

        -- local str_snip = function(trig, expanded)
        --   return ls.parser.parse_snippet({ trig = trig }, expanded)
        -- end

        local same = function(index)
            return f(function(args)
                return args[1]
            end, { index })
        end

        local toexpand_count = 0

        -- `all` key means for all filetypes.
        -- Shared between all filetypes. Has lower priority than a particular ft tho
        -- snippets.all = {
        ls.add_snippets(nil, {
            -- basic, don't need to know anything else
            --    arg 1: string
            --    arg 2: a node
            s("simple", t "wow, you were right!"),

            -- callbacks table
            s("toexpand", c(1, { t "hello", t "world", t "last" }), {
                callbacks = {
                    [1] = {
                        [events.enter] = function( --[[ node ]])
                            toexpand_count = toexpand_count + 1
                            print("Number of times entered:", toexpand_count)
                        end,
                    },
                },
            }),

            -- regTrig
            --    snippet.captures
            -- snippet({ trig = "AbstractGenerator.*Factory", regTrig = true }, { t "yo" }),

            -- third arg,
            s("never_expands", t "this will never expand, condition is false", {
                condition = function()
                    return false
                end,
            }),
        })

        require("luasnip.loaders.from_vscode").load({ include = { "python", "go" } }) -- Load only python snippets

        for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/snips/*.lua", true)) do
            loadfile(ft_path)()
        end

        -- <c-k> is my expansion key
        -- this will expand the current item or jump to the next item within the snippet.
        vim.keymap.set({ "i", "s" }, "<c-k>", function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, { silent = true })

        -- <c-j> is my jump backwards key.
        -- this always moves to the previous item within the snippet
        vim.keymap.set({ "i", "s" }, "<c-j>", function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { silent = true })

        -- <c-l> is selecting within a list of options.
        -- This is useful for choice nodes (introduced in the forthcoming episode 2)
        vim.keymap.set("i", "<c-l>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end)

        vim.keymap.set("i", "<c-u>", require "luasnip.extras.select_choice")

        -- shorcut to source my luasnips file again, which will reload my snippets
        vim.keymap.set("n", "<leader>ls", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")
    end
}
