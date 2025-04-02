local M = {}

-- dropship.nvim reads a list of drop locations (aka Bookmarks) and drops you
-- into a new tab at that location.
-- I like having one tab per project when using vim (ex: If I were to quickly
-- edit my vim config while working on a Go project, I would open a separate
-- tab and `:tcd` into my neovim configuration to avoid leaving my project
-- directory.

--- @class drop_location
--- @field name string
--- @field loc string

--- @class options
--- @field drop_targets string|drop_location[]

--- @type options
local defaults = {
	drop_targets = {},
}

--- @type options
local config

-- Configure dropship.nvim
-- @param ops boolean|options: plugin options
M.setup = function(opts)
	-- config = opts or defaults
	-- if type(config.drop_targets) == "string" then
	-- 	local ok, result = pcall(dofile, config.drop_targets)
	-- 	if ok and type(result) == "table" then
	-- 		config.drop_targets = result
	-- 	else
	-- 		error("Invalid drop_targets file: must return a table of drop_location")
	-- 	end
	-- elseif type(config.drop_targets) ~= "table" then
	-- 	error("drop_targets must be a string (file path) or a table of drop_location")
	-- end
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- our picker function: colors
M.dropdir = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			actions.smart_send_to_qflist,
			prompt_title = "Drop Locations:",
			finder = finders.new_table({
				results = {
					{ "Home", "~/" },
					{ "School", "~/Dropbox/A/scholar/sherbrooke" },
					{ "Workspace", "~/Workspace" },
					{ "Dropbox", "~/Dropbox" },
				},
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry[1],
						ordinal = entry[1],
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
		})
		:find()
end

--- Drop into a new tab at the selected location in telescope
M.drop_to_tab = function() end

vim.print(config)

return M
