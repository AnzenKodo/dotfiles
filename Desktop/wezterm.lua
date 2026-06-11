local wezterm = require 'wezterm'
local config = {}
local action = wezterm.action

-- Options
--=============================================================================

config.color_scheme = 'Gruvbox dark, soft (base16)'
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.automatically_reload_config = true
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.font = wezterm.font {
  family = 'CommitMono',
}
config.line_height = 1.1

-- Keybindings
--=============================================================================

config.keys = {
    { key = 'F11', mods = 'NONE', action = wezterm.action.ToggleFullScreen },
    { key = 't',   mods = 'CTRL', action = action.SpawnTab 'CurrentPaneDomain' },
    { key = 'w',   mods = 'CTRL', action = action.CloseCurrentTab { confirm = true } },
}
for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'CTRL',
        action = wezterm.action.ActivateTab(i - 1),
    })
end

-- For Windows OS
--=============================================================================

local function is_windows()
    return wezterm.target_triple:find('windows') ~= nil
end
if is_windows() then
    config.font_size = 10.0
    table.insert(config.keys, {
        key = '`',
        mods = 'CTRL',
        action = action.SendString '†'
    })
    config.default_prog = { 'C:\\Program Files\\Git\\bin\\bash.exe' }
end

return config

