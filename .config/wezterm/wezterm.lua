local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 12
--config.window_background_opacity = 0.8
config.hide_tab_bar_if_only_one_tab = true
--config.window_decorations = "RESIZE"

-- Load the resurrect plugin
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

-- Periodically save the workspace state
resurrect.state_manager.periodic_save({
	interval_seconds = 300,
	save_tabs = true,
	save_windows = true,
	save_workspaces = true,
})
-- Keep track of which saved state is "current" so it can be restored on startup
wezterm.on("resurrect.state_manager.periodic_save.finished", function()
	resurrect.state_manager.write_current_state(wezterm.mux.get_active_workspace(), "workspace")
end)

--config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 } -- If you use a leader key
config.keys = {
	-- Save state
	{
		key = "s",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			local workspace_state = resurrect.workspace_state.get_workspace_state()
			resurrect.state_manager.save_state(workspace_state)
			resurrect.state_manager.write_current_state(workspace_state.workspace, "workspace")
		end),
	},
	-- Load state via fuzzy finder
	{
		key = "d",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
				-- id looks like "workspace/<name>.json" - strip the type prefix and extension
				id = string.match(id, "([^/]+)$")
				id = string.match(id, "(.+)%..+$")

				local state = resurrect.state_manager.load_state(id, "workspace")
				resurrect.workspace_state.restore_workspace(state, {
					window = win,
					relative = true,
					restore_text = true,
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
				})
			end, { title = "Load Session", is_fuzzy = true, ignore_windows = true, ignore_tabs = true })
		end),
	},
}

-- Automatically restore the last saved session on startup
wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)

return config
