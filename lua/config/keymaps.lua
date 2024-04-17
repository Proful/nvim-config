---@diagnostic disable: missing-fields, unused-function, unused-local, redundant-parameter, param-type-mismatch, lowercase-global
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- better up/down
local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- q = Move down
-- Q = Move up
--
-- go below and make that line as first line of screen
vim.api.nvim_set_keymap(
  "n",
  "<leader>j",
  ':<C-u>execute "normal! " .. v:count1 .. "jzt"<CR>',
  { desc = "scroll down & bring line to top", noremap = true, silent = true }
)

-- vim.api.nvim_set_keymap(
--   "n",
--   "q",
--   'v:count == 0 ? ":<C-u>execute \'normal! gj\'<CR>" : ":<C-u>execute \'normal! " .. v:count1 .. "jzt\'<CR>"',
--   { desc = "scroll down & bring line to top", noremap = true, silent = true, expr = true }
-- )

map({ "n", "x" }, "q", "v:count == 0 ? 'gj' : 'jzt'", { desc = "Move down", expr = true, silent = true })
-- map({ "n", "x" }, "qq", "<C-d>", { desc = "Move down", expr = true, silent = true })
-- map({ "n", "x" }, "11", "<C-d>", { desc = "Scroll down", silent = true })
-- map({ "n", "x" }, "22", "<C-u>", { desc = "Scroll up", silent = true })
map({ "n", "x" }, "Q", "v:count == 0 ? 'gk' : 'k'", { desc = "Move up", expr = true, silent = true })
-- vim.api.nvim_set_keymap("n", "qq", "5j", { noremap = true, silent = true })

-- Move between jumplist
-- vim.api.nvim_set_keymap("n", "<A-1>", "<C-o>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<A-2>", "<C-i>", { noremap = true, silent = true })

-- X -- xi
-- map("n", "X", '"_xi', { desc = "Delete and insert", remap = true })

-- Rest client format json
map("n", "<leader>rf", ":.!jq .<cr>", { desc = "Format json", remap = true })
-- Replace word
map("n", "<leader>rw", '"_deP', { desc = "Replace word", remap = true })
map("n", "<leader>ri'", "\"_di'P", { desc = "Replace word inside single quote", remap = true })
map("n", '<leader>ri"', '"_di"P', { desc = "Replace word inside double quote", remap = true })
map("n", "<leader>ri(", '"_di(P', { desc = "Replace word inside bracket", remap = true })
map("n", "<leader>ri{", '"_di{P', { desc = "Replace word inside curly bracket", remap = true })
map("n", "<leader>rit", '"_ditP', { desc = "Replace word inside tag", remap = true })
map("n", "<leader>r$", '"_d$P', { desc = "Replace word till end of line", remap = true })

-- Close all buffers/Delete all buffer
map("n", "<leader>bc", ":bufdo bwipeout<cr>", { desc = "Close all buffers", remap = true })

-- replace string, don't copy the replaced string in buffer, keep the old one only
map("x", "<leader>p", '"_dP', { desc = "Paste without yanking", remap = true })
map("n", "<leader>p", "<esc>o<esc>p", { desc = "Paste without yanking", remap = true })

function move_cursor_to_top(x)
  local top_line = vim.fn.line(x) -- Get the top line of the window
  vim.fn.cursor(top_line, 1) -- Move cursor to the top line
end

function move_cursor_to_middle()
  local first_line = vim.fn.line("w0")
  local last_line = vim.fn.line("w$")
  local middle_line = math.floor((first_line + last_line) / 2)

  vim.fn.cursor(middle_line, 1) -- Move cursor to the top line
end

vim.api.nvim_set_keymap("n", "gt", ":lua move_cursor_to_top('w0')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gb", ":lua move_cursor_to_top('w$')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gm", ":lua move_cursor_to_middle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "zm", "zz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "zz", ":lua move_cursor_to_top('w$')<CR>zt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[ ", "O<esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "] ", "o<esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<tab><tab>", "<C-w>w", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-`>", "<C-o>", { noremap = true, silent = true })

-- map("n", "<C-a>", "<C-u>", { desc = "Move up", remap = true })
-- map("n", "<C-x>", "<C-o>", { desc = "Backward to jumplist", remap = true })

-- buffers
if Util.has("bufferline.nvim") then
  map("n", "<C-S-q>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "<C-q>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  map("n", "<C-S-q>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "<C-q>", "<cmd>bnext<cr>", { desc = "Next buffer" })
end

if Util.has("bufferline.nvim") then
  map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
end

vim.keymap.set("n", "<C-c>", function()
  vim.cmd([[bdelete]])
end, { desc = "Super <C-c>" })

local cmp_enabled = true
vim.api.nvim_create_user_command("ToggleAutoComplete", function()
  if cmp_enabled then
    require("cmp").setup.buffer({ enabled = false })
    cmp_enabled = false
  else
    require("cmp").setup.buffer({ enabled = true })
    cmp_enabled = true
  end
end, {})

map("n", "<C-t>", "<cmd>ToggleAutoComplete<cr>", { desc = "Toggle Autocomplete" })

-- Search UP for a markdown header
-- Make sure to follow proper markdown convention, and you have a single H1
-- heading at the very top of the file
-- This will only search for H2 headings and above
vim.keymap.set("n", "gQ", function()
  -- `?` - Start a search backwards from the current cursor position.
  -- `^` - Match the beginning of a line.
  -- `##` - Match 2 ## symbols
  -- `\\+` - Match one or more occurrences of prev element (#)
  -- `\\s` - Match exactly one whitespace character following the hashes
  -- `.*` - Match any characters (except newline) following the space
  -- `$` - Match extends to end of line
  vim.cmd("silent! ?^##\\+\\s.*$")
  -- Clear the search highlight
  vim.cmd("nohlsearch")
end, { desc = "Go to previous markdown header" })

-- Search DOWN for a markdown header
-- Make sure to follow proper markdown convention, and you have a single H1
-- heading at the very top of the file
-- This will only search for H2 headings and above
vim.keymap.set("n", "gq", function()
  -- `/` - Start a search forwards from the current cursor position.
  -- `^` - Match the beginning of a line.
  -- `##` - Match 2 ## symbols
  -- `\\+` - Match one or more occurrences of prev element (#)
  -- `\\s` - Match exactly one whitespace character following the hashes
  -- `.*` - Match any characters (except newline) following the space
  -- `$` - Match extends to end of line
  vim.cmd("silent! /^##\\+\\s.*$")
  -- Clear the search highlight
  vim.cmd("nohlsearch")
end, { desc = "Go to next markdown header" })

vim.keymap.set("n", "<leader>i", function()
  -- If we find a floating window, close it.
  local found_float = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      vim.api.nvim_win_close(win, true)
      found_float = true
    end
  end

  if found_float then
    return
  end

  vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
end, { desc = "Toggle Diagnostics" })
