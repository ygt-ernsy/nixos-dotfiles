local home = os.getenv("HOME") or ""
local configDir = (os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")) .. "/hypr"
local configFile = configDir .. "/hyprland.lua"

package.path = configDir .. "/?.lua;" .. configDir .. "/?/init.lua;" .. package.path

---------------------
---- MY PROGRAMS ----
---------------------
local terminal = "kitty"
local fileManager = "dolphin"
local menu = "rofi -show"

local mainMod = "SUPER"
local shiftMod = "SHIFT"

------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "Virtual-1",
	mode = "1920x1080@60.00",
	position = "0x0",
	scale = 1,
})

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "12")
hl.env("HYPRSHOT_DIR", home .. "/Pictures/Screenshots")
hl.env("XDG_MENU_PREFIX", "arch-")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
	hl.exec_cmd("lxqt-policykit-agent")
	-- hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("waybar")
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
	general = {
		gaps_in = 6,
		gaps_out = 6,
		border_size = 0,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
		resize_on_border = true,
		allow_tearing = true,
		layout = "dwindle",
	},

	cursor = {
		no_hardware_cursors = true,
	},

	decoration = {
		rounding_power = 2.4,
		rounding = 5,
		blur = {
			enabled = true,
			xray = false,
			special = false,
			new_optimizations = true,
			size = 10,
			passes = 3,
			brightness = 1,
			noise = 0.05,
			contrast = 0.89,
			vibrancy = 0.5,
			vibrancy_darkness = 0.5,
			popups = false,
			popups_ignorealpha = 0.6,
			input_methods = true,
			input_methods_ignorealpha = 0.8,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	misc = {
		vrr = 1,
		force_default_wallpaper = 0,
		disable_hyprland_logo = false,
	},

	xwayland = {
		force_zero_scaling = true,
	},
})

--------------------
---- ANIMATIONS ----
--------------------
hl.curve("fastBezier", {
	type = "bezier",
	points = {
		{ 0.05, 0.9 },
		{ 0.1, 1.0 },
	},
})

hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "fastBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "fastBezier", style = "popin 80%" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "default", style = "slide" })

---------------
---- INPUT ----
---------------
hl.config({
	input = {
		kb_layout = "us,tr",
		kb_variant = "",
		kb_model = "",
		kb_rules = "",
		kb_options = "grp:ctrl_space_toggle,caps:escape",

		repeat_rate = 50,
		repeat_delay = 300,

		follow_mouse = 1,
		accel_profile = "flat",
		sensitivity = 0.0,
		touchpad = {
			scroll_factor = 0.2,
			natural_scroll = true,
		},
	},
})

hl.device({
	name = "logitech-gaming-mouse-g402",
	sensitivity = 0.0,
	accel_profile = "flat",
})

hl.device({
	name = "syna32e3:00-06cb:cee7-touchpad",
	sensitivity = 0.5,
	accel_profile = "flat",
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

---------------------
---- KEYBINDINGS ----
---------------------
hl.bind(mainMod .. " + i", hl.dsp.exec_cmd([[kitty "pacseek"]]))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Backspace", hl.dsp.window.close())
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + n", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + w", hl.dsp.window.fullscreen())

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.swap({ direction = "d" }))
hl.bind(mainMod .. " + X", hl.dsp.window.move({ monitor = "+1" }))

hl.bind("SUPER + ALT + h", hl.dsp.focus({ monitor = 0 }))
hl.bind("SUPER + ALT + l", hl.dsp.focus({ monitor = 1 }))

hl.bind("SUPER + comma", hl.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "+1" }))
hl.bind("SUPER + period", hl.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- theme picker
hl.bind("SUPER + SHIFT + space", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.local/scripts/theme-rofi"))
------------------------
---- RESIZE SUBMAP ----
------------------------
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
	hl.bind("l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
	hl.bind("h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
	hl.bind("k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
	hl.bind("j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
	hl.bind("escape", hl.dsp.submap("reset"))
end)

----------------------
---- MEDIA BINDS ----
----------------------
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

------------------------
---- UTILITY BINDS ----
------------------------
hl.bind("ALT + F4", hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind(mainMod .. " + Tab", hl.dsp.window.cycle_next())

hl.bind("ALT + Print", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(shiftMod .. " + Print", hl.dsp.exec_cmd("hyprshot -m region"))

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"))

hl.bind(mainMod .. " + SHIFT + f", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + t", hl.dsp.exec_cmd("kitty -e bpytop"))
hl.bind(mainMod .. " + o", hl.dsp.exec_cmd("kitty -e nvim " .. configFile))

------------------------------
---- FLOATING WINDOW MOVE ----
------------------------------
hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.move({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.move({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.move({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.move({ x = 0, y = 50, relative = true }), { repeating = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "xdg-desktop-portal-gtk-floating",
	match = { class = "^(xdg-desktop-portal-gtk)$" },
	float = true,
})

hl.window_rule({
	name = "gamescope-fullscreen",
	match = { class = "^(gamescope)$" },
	fullscreen = true,
})

hl.window_rule({
	name = "matplotlib-floating",
	match = { class = "^(Matplotlib)$" },
	float = true,
})

hl.window_rule({
	name = "lxqt-policykit-agent-floating",
	match = { class = "^(lxqt-policykit-agent)$" },
	float = true,
})

hl.window_rule({
	name = "fullscreen-steam-games",
	match = { class = "^(steam_app_\\d+)$" },
	fullscreen = true,
})
