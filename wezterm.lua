local wezterm = require "wezterm"
local defprog = { "C:\\Program Files\\WindowsApps\\Microsoft.PowerShell_7.3.3.0_x64__8wekyb3d8bbwe\\pwsh.exe", "-NoLogo", "-NoExit", "-c", "please" }

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

function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return 'Breeze'
    else
        return 'One Light (Gogh)'
    end
end

return {
    default_prog = defprog,
    launch_menu = {
        { 
            label = "cmd",
            args = { "cmd" } 
        },
        {
            label = "PowerShell",
            args = {"C:\\Program Files\\WindowsApps\\Microsoft.PowerShell_7.3.2.0_x64__8wekyb3d8bbwe\\pwsh.exe", "-nol", "-noe", "-c", "please"}
        },
        {
            label = "Bash",
            args = {"C:\\Users\\aekma\\scoop\\apps\\git\\current\\bin\\bash.exe"}
        },
        {
            label = "Developer PowerShell",
            args = {'powershell.exe', '-noe', '-c', '&{Import-Module "C:/Program Files/Microsoft Visual Studio/2022/Community/Common7/Tools/Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell b556515b -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"}',}
        }
    },
    use_fancy_tab_bar = false,
    font = wezterm.font "Mononoki NFM",
    color_scheme_dirs = { './colors' },
    color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
    window_frame = {
        font = wezterm.font { family = "Gotham", weight = "Bold"}
    },
    enable_scroll_bar = true,
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
    keys = {
        { key = 's', mods = 'CTRL|SHIFT', action = wezterm.action.ShowLauncher },
    },
}
