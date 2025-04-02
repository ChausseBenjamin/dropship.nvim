<div align="center">

<img alt="A parachute dropping a crate" src="assets/logo.png" width="250px" />

# dropship.nvim

Your neovim tabs, dropshipped into your projects

</div>


## How it works

1. Configure the plugin with either a table containing drop location
   or a path to a lua file that returns that.
2. Setup keybinds you might want to use dropship with
3. Profit!

Below you may find some example [Lazy][2] configurations for this
plugin.

**Using a pre-baked list of drop-locations**:

```lua
{
  "ChausseBenjamin/dropship.nvim",
  dependencies = "nvim-telescope/telescope.nvim",
  opts = {
    new_tab_explorer = false, -- Set to true to use `:Exp` on new tabs
    drop_locations = {
      { "Projects", "~/Workspace" },
      { "Neovim Config", "~/.config/nvim" },
      { "University", "~/Documents/school/university/current_semester" },
    },
  },
  keys = {
    {
      "<leader>dt",
      function() -- creates a new tab, then uses `:tcd`
        require("dropship").new_tab()
      end,
      mode = "n",
      desc = "[D]ropship in a new [T]ab",
    },
    {
      "<leader>dh",
      function() -- uses `:tcd` on current tab
        require("dropship").current_tab()
      end,
      mode = "n",
      desc = "[D]ropship right [H]ere",
    },
    {
      "<leader>dg",
      function() -- uses `:cd`
        require("dropship").globally()
      end,
      mode = "n",
      desc = "[D]ropship [G]lobally",
    },
  },
  cmd = {
    "DropshipCurrentTab",
    "DropshipNewTab",
    "DropshipGlobalDir",
  }
}
```


**Using a lua file for drop-locations**:

In order to have a single source of truth for my shortcuts, I have a script
that generates shortcuts for most of my apps [in my dotfiles][1]. This type of
solution makes sense for me to keep all my shortcuts in sync.

```lua
{
  "ChausseBenjamin/dropship.nvim",
  dependencies = "nvim-telescope/telescope.nvim",
  opts = {
  drop_locations = "~/.cache/droplist.lua"
  },
  -- Same as above for the rest...
}
```

And the `droplist.lua` would then look like the following:

```lua
return {
  { "Projects", "~/Workspace" },
  { "Neovim Config", "~/.config/nvim" },
  { "University", "~/Documents/school/university/current_semester" },
}
```

## Why did I make this

I've never written a neovim before. So I figured this would be a great learning experience.
Also, like mentionned above, I use a shortcuts generator script on my machines. Thus, being
able to import a lua file containing my shortcuts from outside my neovim directory is really
useful to me.


[1]: https://github.com/ChausseBenjamin/dotfiles/blob/master/.local/bin/shortcutgen
[2]: https://github.com/folke/lazy.nvim
