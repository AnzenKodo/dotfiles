local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Gruvbox dark, soft (base16)'
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.automatically_reload_config = true
config.keys = {
    { key = 'F11', mods = 'NONE', action = wezterm.action.ToggleFullScreen },
}

local function is_windows()
    return wezterm.target_triple:find('windows') ~= nil
end
if is_windows() then
    config.font_size = 10.0
    config.keys = {
        { key = '`', mods = 'CTRL', action = wezterm.action.SendString '†' }
    }
    config.default_prog = { 'bash.exe' }
end

config.ssh_domains = {
    {
        name = 'server',
        remote_address = '34.71.170.37',
        username = 'Gangnam',
        multiplexing = 'WezTerm',  -- or "None" for plain SSH
    },
}

return config

