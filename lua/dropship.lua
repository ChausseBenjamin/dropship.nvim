local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local drop_sites = {}

M.setup = function(opts)
  opts = opts or {}
  if type(opts.drop_sites) == "table" then
    drop_sites = opts.drop_sites
  elseif type(opts.drop_sites) == "string" then
    local success, loaded_sites = pcall(function()
      return dofile(vim.fn.expand(opts.drop_sites))
    end)
    if success and type(loaded_sites) == "table" then
      drop_sites = loaded_sites
    else
      vim.notify("Failed to load drop_sites from file: " .. opts.drop_sites, vim.log.levels.ERROR)
    end
  else
    vim.notify("Invalid drop_sites configuration", vim.log.levels.ERROR)
  end
end

local function get_target(opts, callback)
  opts = opts or {}
  pickers
    .new(opts, {
      finder = finders.new_table({
        results = drop_sites,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.name .. ": " .. entry.dir,
            ordinal = entry.name,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(bufnr)
        actions.select_default:replace(function()
          actions.close(bufnr)
          local selection = action_state.get_selected_entry()
          callback(selection.value.dir)
        end)
        return true
      end,
    })
    :find()
end

M.current_tab = function(opts)
  opts = opts or {}
  get_target(opts, function(target)
    vim.cmd("tcd " .. target)
  end)
end

M.new_tab = function(opts)
  opts = opts or {}
  get_target(opts, function(target)
    vim.cmd("tabnew " .. target)
    vim.cmd("tcd " .. target)
  end)
end

M.globally = function(opts)
  opts = opts or {}
  get_target(opts, function(target)
    vim.cmd("cd " .. target)
  end)
end

return M
