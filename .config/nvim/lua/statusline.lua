local gl = require('galaxyline')
local condition = require('galaxyline.condition')
local gls = gl.section

local colors = {
  bg = '#3d2c5a',  -- Dark deep purple
  fg = '#bbc2cf',  -- Light gray for good contrast
  blue = '#51afef',
  green = '#98be65',
  red = '#ff6c6b',
  yellow = '#ecbe7b',
  orange = '#da8548',
  purple = '#c678dd',
  cyan = '#46d9ff'
}

gls.left[1] = {
  ViMode = {
    provider = function()
      local mode = vim.fn.mode()
      if mode == 'n' then return 'NORMAL'
      elseif mode == 'i' then return 'INSERT'
      elseif mode == 'v' or mode == 'V' then return 'VISUAL'
      else return mode:upper()
      end
    end,
    highlight = {colors.bg, colors.blue, 'bold'},
  }
}

gls.left[2] = {
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color, colors.bg},
  }
}

gls.left[3] = {
  FileName = {
    provider = 'FileName',
    condition = condition.buffer_not_empty,
    highlight = {colors.fg, colors.bg}
  }
}

gls.left[4] = {
  FileType = {
    provider = 'FileTypeName',
    condition = condition.buffer_not_empty,
    highlight = {colors.blue, colors.bg}
  }
}

gls.left[5] = {
  LineColumn = {
    provider = 'LineColumn',
    highlight = {colors.fg, colors.bg}
  }
}

gls.right[1] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = ' +',
    highlight = {colors.green, colors.bg}
  }
}

gls.right[2] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = ' ~',
    highlight = {colors.yellow, colors.bg}
  }
}

gls.right[3] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = ' -',
    highlight = {colors.red, colors.bg}
  }
}

gls.right[4] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = condition.check_git_workspace,
    icon = ' ',
    highlight = {colors.green, colors.bg}
  }
}
