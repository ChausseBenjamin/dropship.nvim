local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

M.setup = function(opts)
  opts = opts or {}
  if type(opts.drop_locations) == "table" then
    M.drop_locations = opts.drop_locations
  elseif type(opts.drop_locations) == "string" then
    local success, loaded_sites = pcall(function()
      return dofile(vim.fn.expand(opts.drop_locations))
    end)
    if success and type(loaded_sites) == "table" then
      M.drop_locations = loaded_sites
    else
      vim.notify("Failed to load drop_locations from file: " .. opts.drop_locations, vim.log.levels.ERROR)
    end
  else
    vim.notify("Invalid drop_locations configuration", vim.log.levels.ERROR)
  end
  M.use_exp = opts.new_tab_explorer or false
end

local function get_target(opts, callback)
  opts = opts or {}

  -- Calculate the maximum length from all entry names
  local max_name_length = 0
  for _, entry in ipairs(opts.drop_locations or M.drop_locations) do
    max_name_length = math.max(max_name_length, #(entry.name or "Unknown"))
  end

  pickers
    .new(opts, {
      prompt_title = opts.prompt_title or "Drop into which project?",
      prompt_prefix = opts.prompt_icon or " ", -- Added prompt_icon option
      finder = finders.new_table({
        results = opts.drop_locations or M.drop_locations,
        entry_maker = function(entry)
          local name = entry.name or "Unknown"
          local dir = entry.dir or "Unknown"
          local padded_name = name .. ":" .. string.rep(" ", max_name_length - #name + 1)
          local display = padded_name .. dir
          return {
            value = entry,
            display = display,
            ordinal = display,
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
    if M.use_exp then
      vim.cmd("tabnew " .. target)
    else
      vim.cmd("tabnew")
    end
    vim.cmd("tcd " .. target)
  end)
end

M.globally = function(opts)
  opts = opts or {}
  get_target(opts, function(target)
    vim.cmd("cd " .. target)
  end)
end

vim.api.nvim_create_user_command("DropshipCurrentTab", function(opts)
  M.current_tab(opts)
end, { nargs = "?" })

vim.api.nvim_create_user_command("DropshipNewTab", function(opts)
  M.new_tab(opts)
end, { nargs = "?" })

vim.api.nvim_create_user_command("DropshipGlobalDir", function(opts)
  M.globally(opts)
end, { nargs = "?" })

return M
