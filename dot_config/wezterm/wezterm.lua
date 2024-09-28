-- Minimal wezterm.lua configuration with enhancements

local wezterm = require("wezterm")

-- Determine if the system is in dark mode
local is_dark = wezterm.gui and wezterm.gui.get_appearance():find("Dark") ~= nil

-- Define the leader key for easier keybindings
local leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

return {
	--======================
	-- 1. Font Configuration
	--======================
	font = wezterm.font_with_fallback({
		{
			family = "Fira Code",
			weight = "Regular",
			style = "Normal",
			harfbuzz_features = { "calt=1", "clig=1", "liga=1" },
		},
		"Noto Color Emoji",
		"Apple Color Emoji",
		"JetBrains Mono",
		"Symbols Nerd Font",
	}),
	font_size = 22.0,
	line_height = 1.2,
	-- font_antialias = "Subpixel",
	-- font_hinting = "Full",

	--======================
	-- 2. Color Scheme
	--======================
	color_scheme = is_dark and "catppuccin-macchiato" or "Catppuccin-Latte",

	--======================
	-- 3. Window Appearance
	--======================
	window_background_opacity = 0.95,
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},
	hide_tab_bar_if_only_one_tab = true,
	window_decorations = "RESIZE|TITLE|INTEGRATED_BUTTONS",
	initial_rows = 30,
	initial_cols = 120,
	enable_scroll_bar = true,

	--======================
	-- 4. Scrollback Configuration
	--======================
	scrollback_lines = 5000,

	--======================
	-- 5. Key Bindings
	--======================
	leader = leader,
	keys = {
		-- Split panes
		{ key = "h", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "v", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

		-- Navigate between panes
		{ key = "LeftArrow", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Left") },
		{ key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Right") },
		{ key = "UpArrow", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Up") },
		{ key = "DownArrow", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Down") },

		-- Font size controls
		{ key = "+", mods = "CTRL|SHIFT", action = wezterm.action.IncreaseFontSize },
		{ key = "-", mods = "CTRL|SHIFT", action = wezterm.action.DecreaseFontSize },
		{ key = "0", mods = "CTRL|SHIFT", action = wezterm.action.ResetFontSize },

		-- Reload configuration
		{ key = "R", mods = "CTRL|SHIFT", action = wezterm.action.ReloadConfiguration },

		-- Toggle full screen
		{ key = "F", mods = "CTRL|SHIFT", action = wezterm.action.ToggleFullScreen },

		-- Copy and paste
		{ key = "C", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "V", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },

		-- Toggle opacity
		{
			key = "O",
			mods = "CTRL|SHIFT",
			action = wezterm.action_callback(function(win, pane)
				local current_opacity = win:get_config().window_background_opacity or 1.0
				local new_opacity = current_opacity == 0.95 and 1.0 or 0.95
				win:set_config_overrides({ window_background_opacity = new_opacity })
			end),
		},

		-- Toggle theme
		{
			key = "T",
			mods = "CTRL|SHIFT",
			action = wezterm.action_callback(function(win, pane)
				local current_scheme = win:get_config().color_scheme
				local new_scheme = current_scheme == "catppuccin-macchiato" and "Catppuccin-Latte"
					or "catppuccin-macchiato"
				win:set_config_overrides({ color_scheme = new_scheme })
			end),
		},
	},

	--======================
	-- 6. Mouse Bindings
	--======================
	mouse_bindings = {
		-- Paste clipboard on middle-click
		{
			event = { Up = { streak = 1, button = "Middle" } },
			mods = "NONE",
			action = wezterm.action.PasteFrom("Clipboard"),
		},
		-- Ctrl + Left-click to open links
		{
			event = { Down = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
		-- Copy selection to clipboard on left mouse drag
		{
			event = { Drag = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
		},
		-- Double-click to select word
		{
			event = { Up = { streak = 2, button = "Left" } },
			mods = "NONE",
			action = wezterm.action.SelectTextAtMouseCursor("Word"),
		},
		-- Triple-click to select line
		{
			event = { Up = { streak = 3, button = "Left" } },
			mods = "NONE",
			action = wezterm.action.SelectTextAtMouseCursor("Line"),
		},
		-- Right-click to show launcher
		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = wezterm.action.ShowLauncher,
		},
	},

	--======================
	-- 7. Default Shell
	--======================
	default_prog = { "/bin/zsh", "-l" }, -- Adjust based on OS if needed

	--======================
	-- 8. Advanced Settings
	--======================
	window_close_confirmation = "NeverPrompt",
	cursor_blink_rate = 800,
	cursor_thickness = 2.0,
	-- cursor_style = "BlinkingBlock",
	animation_fps = 30,

	--======================
	-- 9. Other Useful Settings
	--======================
	enable_kitty_graphics = false,
	enable_tab_bar = true,
	tab_max_width = 30,
	tab_bar_at_bottom = false,
	-- initial_cwd = "/home/username/projects",

	--======================
	-- 10. Event Handlers
	--======================
	wezterm.on("window-config-reloaded", function(window, pane)
		window:toast_notification("WezTerm", "Configuration reloaded!")
	end),
}
