require"startup".setup({
  header = {
      type = "text",
      oldfiles_directory = false,
      align = "center",
      fold_section = false,
      title = "Header",
      margin = 5,
      content = {
"░░░░░██╗███████╗██████╗░██╗██████╗░██╗░░░██╗███╗░░██╗██╗░░██╗███████╗", 
"░░░░░██║██╔════╝██╔══██╗██║██╔══██╗██║░░░██║████╗░██║██║░██╔╝╚════██║", 
"░░░░░██║█████╗░░██║░░██║██║██████╔╝██║░░░██║██╔██╗██║█████═╝░░░███╔═╝", 
"██╗░░██║██╔══╝░░██║░░██║██║██╔═══╝░██║░░░██║██║╚████║██╔═██╗░██╔══╝░░", 
"╚█████╔╝███████╗██████╔╝██║██║░░░░░╚██████╔╝██║░╚███║██║░╚██╗███████╗", 
"░╚════╝░╚══════╝╚═════╝░╚═╝╚═╝░░░░░░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚══════╝", 
      },
      highlight = "Statement",
      default_color = "",
      oldfiles_amount = 0,
  },
  -- name which will be displayed and command
  body = {
      type = "mapping",
      oldfiles_directory = false,
      align = "center",
      fold_section = false,
      title = "Basic Commands",
      margin = 5,
      content = {
          { "Find File", "Telescope find_files", "sf" },
          { "Find Word", "Telescope live_grep", "sw" },
          { "Recent Files", "Telescope oldfiles", "sr" },
          { "File Browser", "Telescope file_browser", "<leader>fb" },
          { "Colorschemes", "Telescope colorscheme", "<leader>cs" },
          { "New File", "lua require'startup'.new_file()", "<leader>nf" },
      },
      highlight = "String",
      default_color = "",
      oldfiles_amount = 0,
  },
  footer = {
    type = "text",
    content = function()
      local clock = "⏰ " .. os.date("%H:%M")
      local date = "📅 " .. os.date("%d-%m-%y")
      return { clock .. " " .. date }
    end,
    oldfiles_directory = false,
    align = "center",
    fold_section = false,
    title = "",
    margin = 5,
    highlight = "TSString",
    default_color = "#FFFFFF",
    oldfiles_amount = 10,
  },

  options = {
      mapping_keys = true,
      cursor_column = 0.5,
      empty_lines_between_mappings = true,
      disable_statuslines = true,
      paddings = { 1, 3, 3, 0 },
  },
  mappings = {
      execute_command = "<CR>",
      open_file = "o",
      open_file_split = "<c-o>",
      open_section = "<TAB>",
      open_help = "?",
  },
  colors = {
      background = "#ffffff",
      folded_section = "#ffffff",
  },
  parts = { "header", "body", "footer" },
})
