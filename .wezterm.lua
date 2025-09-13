local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font({
	family = "CaskaydiaCove Nerd Font Mono",
	weight = "Regular",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})

config.font_size = 12.0

config.color_scheme = "Tokyo Night"

config.window_decorations = "RESIZE"

if wezterm.target_triple:find("windows") then
	config.default_prog = { "pwsh.exe" }
end

config.keys = {
	{
		key = "+",
		mods = "CTRL|ALT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "CTRL|ALT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
}

local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")

bar.apply_to_config(config, {
	position = "top",
	modules = {
		tabs = {
			active_tab_fg = 4,
			inactive_tab_fg = 6,
		},
		workspace = {
			enabled = true,
			icon = wezterm.nerdfonts.cod_window,
			color = 8,
		},
		leader = {
			enabled = false,
			icon = wezterm.nerdfonts.oct_rocket,
			color = 2,
		},
		zoom = {
			enabled = false,
			icon = wezterm.nerdfonts.md_fullscreen,
			color = 4,
		},
		pane = {
			enabled = false,
			icon = wezterm.nerdfonts.cod_multiple_windows,
			color = 7,
		},
		username = {
			enabled = true,
			icon = wezterm.nerdfonts.fa_user,
			color = 6,
		},
		hostname = {
			enabled = true,
			icon = wezterm.nerdfonts.cod_server,
			color = 8,
		},
		clock = {
			enabled = true,
			icon = wezterm.nerdfonts.md_calendar_clock,
			format = "%H:%M",
			color = 5,
		},
		cwd = {
			enabled = false,
			icon = wezterm.nerdfonts.oct_file_directory,
			color = 7,
		},
	},
})

config.colors = {
	tab_bar = {
		active_tab = {
			bg_color = "#24283b",
			fg_color = "#c0caf5",
		},
	},
}

return config
