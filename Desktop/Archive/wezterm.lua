local wezterm = require 'wezterm'
local config = {}
local action = wezterm.action

-- Options
--=============================================================================

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

-- Theme
--=============================================================================

local function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return 'Gruvbox dark, soft (base16)'
    else
        return 'Gruvbox light, soft (base16)'
    end
end

-- Re-evaluate on every config reload
local function get_xfce_appearance()
    local success, stdout, stderr = wezterm.run_child_process {
        'xfconf-query', '-c', 'xsettings', '-p', '/Net/ThemeName'
    }
    if success then
        local theme = stdout:gsub('%s+', '')  -- trim whitespace
        if theme:lower():find('dark') then
            return 'Dark'
        else
            return 'Light'
        end
    end
    return 'Light'  -- fallback
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

wezterm.on('window-config-reloaded', function(window, pane)
    local appearance = get_xfce_appearance()
    local scheme = scheme_for_appearance(appearance)
    local overrides = window:get_config_overrides() or {}
    if overrides.color_scheme ~= scheme then
        overrides.color_scheme = scheme
        window:set_config_overrides(overrides)
    end
end)

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

