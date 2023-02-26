local wezterm = require "wezterm"
local defprog = { "C:\\Program Files\\WindowsApps\\Microsoft.PowerShell_7.3.2.0_x64__8wekyb3d8bbwe\\pwsh.exe", "-NoLogo", "-NoExit", "-c", "please" }
-- BUG: Cant "convert it to SpawnCommand" for some reason
-- local launch_menu = {}

-- table.insert(launch_menu, {
--     {
--         args = { "C:\\Program Files\\WindowsApps\\Microsoft.PowerShell_7.3.2.0_x64__8wekyb3d8bbwe\\pwsh.exe" },
--     }
-- })

-- for _, vsvers in ipairs(wezterm.glob('Microsoft Visual Studio/20*', 'C:/Program Files (x86)'))
-- do
--     local year = vsvers:gsub('Microsoft Visual Studio/', '')
--     table.insert(launch_menu, {
--             label = 'x64 Native Tools VS ' .. year,
--             args = {
--                 'cmd.exe',
--                 '/k',
--                 'C:/Program Files (x86)/'
--                 .. vsvers
--                 .. '/BuildTools/VC/Auxiliary/Build/vcvars64.bat',
--             },
--         })
-- end

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

return {
    default_prog = defprog,
    -- launch_menu = launch_menu,
    font = wezterm.font "CodeNewRoman NFM",
    color_scheme = "Breeze",
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
}
