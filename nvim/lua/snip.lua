local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
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

-- Config, directly from LuaSnip Repo
ls.setup({
    keep_roots = true,
    link_roots = true,
    link_children = true,
    -- Update more often, :h events for more info.
    update_events = "TextChanged,TextChangedI",
    -- Snippets aren't automatically removed if their text is deleted.
    -- `delete_check_events` determines on which events (:h events) a check for
    -- deleted snippets is performed.
    -- This can be especially useful when `history` is enabled.
    delete_check_events = "TextChanged",
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "choiceNode", "Comment" } },
            },
        },
    },
    -- treesitter-hl has 100, use something higher (default is 200).
    ext_base_prio = 300,
    -- minimal increase in priority.
    ext_prio_increase = 1,
    enable_autosnippets = true,
    -- mapping for cutting selected text so it's usable as SELECT_DEDENT,
    -- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
    store_selection_keys = "<Tab>",
    -- luasnip uses this function to get the currently active filetype. This
    -- is the (rather uninteresting) default, but it's possible to use
    -- eg. treesitter for getting the current filetype by setting ft_func to
    -- require("luasnip.extras.filetype_functions").from_cursor (requires
    -- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
    -- the current filetype in eg. a markdown-code block or `vim.cmd()`.
    ft_func = function()
        return vim.split(vim.bo.filetype, ".", true)
    end,
})

ls.config.set_config({
    history = true, -- keep around last snippet local to jump back
})

vim.keymap.set(
    {"i", "s"},
    "<C-K>",
    function()
        if ls.expand_or_jumpable() then
            ls.expand_or_jump()
        end
    end,
    {silent = true}
)
vim.keymap.set(
    {"i", "s"},
    "<C-J>",
    function()
        if ls.jumpable(-1) then
            ls.jump(-1)
        end
    end,
    {silent = true}
)
vim.keymap.set(
    {"i"},
    "<C-L>",
    function()
        if ls.choice_active() then
            ls.change_choice(1)
        end
    end,
    {silent = true}
)
vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/snip.lua<CR>")

-- require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/lua/snippets/"})

------------- Actual snippets -------------
-- All
ls.add_snippets("all", {
    s("today", {t(os.date("%d-%m-%Y"))}),
}, {
    key = "all",
})

-- Lua
ls.add_snippets("all", {
    s("req", fmt("local {} = require(\"{}\")", {i(1), rep(1)})),
}, {
    key = "lua",
})

-- Python

-- Latex
local tex = {}
function tex.in_math() -- math / not math zones
    return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
end

function tex.in_comment() -- comment detection
	return vim.fn["vimtex#syntax#in_comment"]() == 1
end

function tex.in_beamer() -- document class
	return vim.b.vimtex["documentclass"] == "beamer"
end

-- general env function
local function env(name)
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end

function tex.in_preamble()
	return not env("document")
end

function tex.in_text()
	return env("document") and not tex.in_math()
end

function tex.in_tikz()
	return env("tikzpicture")
end

function tex.in_bullets()
	return env("itemize") or env("enumerate")
end

function tex.in_align()
	return env("align") or env("align*") or env("aligned")
end

function tex.show_line_begin(line_to_cursor)
    return #line_to_cursor <= 3
end

local generate_fraction = function (_, snip)
    local stripped = snip.captures[1]
    local depth = 0
    local j = #stripped
    while true do
        local c = stripped:sub(j, j)
        if c == "(" then
            depth = depth + 1
        elseif c == ")" then
            depth = depth - 1
        end
        if depth == 0 then
            break
        end
        j = j - 1
    end
    return sn(nil,
        fmta([[
        <>\frac{<>}{<>}
        ]],
        { t(stripped:sub(1, j-1)), t(stripped:sub(j+1, -2)), i(1)}))
end

ls.add_snippets("tex", {
    s({ trig = "ii", name = "itemize", dscr = "bullet points (itemize)" },
	fmta([[ 
    \begin{itemize}
    \item <>
    \end{itemize}
    ]],
	{ c(1, { i(0), sn(nil, fmta(
		[[
        [<>] <>
        ]],
		{ i(1), i(0) })) })
    })),
    s({ trig="((\\d+)|(\\d*)(\\\\)?([A-Za-z]+)((\\^|_)(\\{\\d+\\}|\\d))*)\\/", name='fraction', dscr='auto fraction 1', trigEngine="ecma"},
    fmta([[
    \frac{<>}{<>}<>
    ]],
    { f(function (_, snip)
        return snip.captures[1]
    end), i(1), i(0) })),
    s({ trig='(^.*\\))/', name='fraction', dscr='auto fraction 2', trigEngine="ecma" },
    { d(1, generate_fraction) }),
    -- s("bar", fmt([[\overline{<>}]], { i(1) }, { delimiters = '<>' }),
}, {
    key = "tex",
})
