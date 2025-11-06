return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      theme = "wave",
    },
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      on_highlights = function(hl, c)
        -- Customize Visual selection colors
        hl.Visual = {
          bg = "#9d7cd8",  -- purple background
          fg = "#ffffff",  -- white text
        }
        -- Customize Comment colors (brighter than default)
        hl.Comment = {
          fg = "#797979",  -- slightly darker blue (more visible than default gray #565f89)
        }
      end,
    },
  },
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    lazy = false,
    opts = {},
  },
}
