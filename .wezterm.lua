local wezterm = require 'wezterm'


local font_with_fallback = wezterm.font_with_fallback { 'PragmataPro Mono Liga', 'JetBrains Mono' }
local light_theme = {
  -- Theme [Modified Zenbones]
  colors = {
    foreground = '#2C363C',
    background = '#F0EDEC',
    cursor_bg = '#2C363C',
    cursor_border = '#F0EDEC',
    cursor_fg = '#F0EDEC',
    selection_bg = '#CBD9E3',
    selection_fg = '#2C363C',
    ansi = { '#F0EDEC', '#A8334C', '#4F6C31', '#944927', '#286486', '#88507D', '#3B8992', '#2C363C' },
    brights = { '#CFC1BA', '#94253E', '#3F5A22', '#803D1C', '#1D5573', '#7B3B70', '#2B747C', '#4F5E68' },
    visual_bell = '#DDD6D3',

    tab_bar = {
      inactive_tab_edge = '#DDD6D3',
      background = '#DDD6D3',

      active_tab = {
        bg_color = '#F0EDEC',
        fg_color = '#2C363C',
      },

      inactive_tab = {
        bg_color = '#DDD6D3',
        fg_color = '#2C363C',
      },

      inactive_tab_hover = {
        bg_color = '#F0EDEC',
        fg_color = '#2C363C',
      },

      new_tab = {
        bg_color = '#DDD6D3',
        fg_color = '#2C363C',
      },

      new_tab_hover = {
        bg_color = '#DDD6D3',
        fg_color = '#2C363C',
      }
    },
  },
  window_frame = {
    font = font_with_fallback,
    active_titlebar_bg = '#DDD6D3',
    inactive_titlebar_bg = '#DDD6D3',
  },
  color_scheme = nil,
}

local dark_theme = {
  colors = { visual_bell = '#282523' },
  window_frame = { font = font_with_fallback },
  color_scheme = "zenbones_dark",
}

local function theme_for_appearance(overrides, appearance)
  local theme = dark_theme
  if appearance:find 'Light' then
    overrides["color_scheme"] = nil
    theme = light_theme
  end
  for k, v in pairs(theme) do overrides[k] = v end
end

wezterm.on('window-config-reloaded', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local appearance = window:get_appearance()

  theme_for_appearance(overrides, appearance)
  window:set_config_overrides(overrides)

  if wezterm.GLOBAL.last_appearance ~= appearance then
    if appearance:find 'Dark' then
      window:toast_notification('wezterm', 'what a horrible night to have a curse.', nil, 1750)
    end
    wezterm.GLOBAL.last_appearance = appearance
  end
end)

return {
  -- Remove top bar
  window_decorations = 'RESIZE',
  scrollback_lines = 10000,

  -- Style
  font = font_with_fallback,
  font_size = 15.0,
  hide_tab_bar_if_only_one_tab = true,
  window_padding = {
    left = '0.7cell',
    right = '0.7cell',
    top = '0.5cell',
    bottom = 0,
  },
  --  use_fancy_tab_bar = false,
  initial_rows = 32,
  initial_cols = 110,

  -- Bell
  audible_bell = 'SystemBeep',
  visual_bell = {
    fade_in_function = 'EaseIn',
    fade_in_duration_ms = 15,
    fade_out_function = 'EaseOut',
    fade_out_duration_ms = 20,
  },

  window_background_opacity = 0.94,

  -- System
  animation_fps = 60, -- TODO: Can this depend on battery charge/screen performance?
  unicode_version = 14,
  keys = {
    { key = 'N', mods = 'CMD|SHIFT', action = wezterm.action.ToggleFullScreen },
    -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
    { key = 'LeftArrow', mods = 'OPT', action = wezterm.action { SendString = '\x1bb' } },
    -- Make Option-Right equivalent to Alt-f; forward-word
    { key = 'RightArrow', mods = 'OPT', action = wezterm.action { SendString = '\x1bf' } },
    -- Make Cmd+K clear the viewport and scrollback
    {
      key = 'k',
      mods = 'CMD',
      action = wezterm.action.Multiple {
        wezterm.action.ClearScrollback 'ScrollbackAndViewport',
        wezterm.action.SendKey { key = 'L', mods = 'CTRL' },
      },
    },
    {
      key = 'w',
      mods = 'CMD',
      action = wezterm.action.CloseCurrentPane { confirm = true },
    },
    -- Split pane bindings
    {
      key = 'LeftArrow',
      mods = 'CTRL|ALT|SHIFT',
      action = wezterm.action.SplitPane {
        direction = 'Left',
        size = { Percent = 50 },
      },
    },
    {
      key = 'UpArrow',
      mods = 'CTRL|ALT|SHIFT',
      action = wezterm.action.SplitPane {
        direction = 'Up',
        size = { Percent = 50 },
      },
    },
    {
      key = 'RightArrow',
      mods = 'CTRL|ALT|SHIFT',
      action = wezterm.action.SplitPane {
        direction = 'Right',
        size = { Percent = 50 },
      },
    },
    {
      key = 'DownArrow',
      mods = 'CTRL|ALT|SHIFT',
      action = wezterm.action.SplitPane {
        direction = 'Down',
        size = { Percent = 50 },
      },
    },
    {
      key = 'LeftArrow',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.ActivatePaneDirection 'Left',
    },
    {
      key = 'RightArrow',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.ActivatePaneDirection 'Right',
    },
    {
      key = 'UpArrow',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.ActivatePaneDirection 'Up',
    },
    {
      key = 'DownArrow',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.ActivatePaneDirection 'Down',
    },
  }
}
