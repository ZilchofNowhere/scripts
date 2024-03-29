local wezterm = require "wezterm"
local def_prog = { "C:\\Users\\aekma\\scoop\\apps\\pwsh\\current\\pwsh.exe", "-NoLogo", "-NoExit", "-c", "please" }

-- local def_prog = { "C:\\Users\\aekma\\scoop\\apps\\git\\current\\bin\\bash.exe" }

wezterm.on(
    'format-window-title',
    function(tab, pane, tabs, panes, config)
        local zoomed = ''
        if tab.active_pane.is_zoomed then
            zoomed = '[Z] '
        end
        return zoomed .. 'Wezterm'
    end
    )

local function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return 'Breeze'
    else
        return 'Windows 10 Light (base16)'
    end
end

return {
    launch_menu = {
        {
            label = "cmd",
            args = { "cmd" },
        },
        {
            label = "PowerShell",
            args = {"C:\\Users\\aekma\\scoop\\apps\\pwsh\\current\\pwsh.exe", "-nol", "-noe", "-c", "please"}
        },
        {
            label = "zsh",
            args = {"C:\\Users\\aekma\\scoop\\apps\\git\\current\\bin\\bash.exe"}
        },
        {
            label = "Developer PowerShell",
            args = {'powershell.exe', '-noe', '-c', '&{Import-Module "C:/Program Files/Microsoft Visual Studio/2022/Community/Common7/Tools/Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell b556515b -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"}',}
        }
    },
    use_fancy_tab_bar = false,
    font = wezterm.font "Mononoki Nerd Font Mono",
    font_size = 12,
    color_scheme_dirs = { './colors' },
    color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
    window_frame = {
        font = wezterm.font { family = "Gotham", weight = "Bold"}
    },
    enable_scroll_bar = true,
    default_prog = def_prog,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    default_cursor_style = "BlinkingBar",
    animation_fps = 1,
    cursor_blink_ease_in = 'Constant',
    cursor_blink_ease_out = 'Constant',
    initial_rows = 27,
    initial_cols = 110,
    hide_tab_bar_if_only_one_tab = true,
    adjust_window_size_when_changing_font_size = false,
    window_background_opacity = 0.95,
    keys = {
        { key = 's', mods = 'CTRL|SHIFT', action = wezterm.action.ShowLauncher },
    },
}
