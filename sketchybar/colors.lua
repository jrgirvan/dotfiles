local colors = {}
local config_dir = os.getenv("CONFIG_DIR")
local theme_file = config_dir .. "/helpers/active_theme.txt"

-- Create the directory once when the script loads if not available yet
os.execute("mkdir -p " .. config_dir .. "/helpers")

-- 1. Define Common Colors
colors.white = 0xffffffff
colors.transparent = 0x00000000
colors.red = 0xffff4444
colors.orange = 0xffffa500
colors.charging = 0xfff9e2af

-- 2. Per-Icon Colors (Catppuccin Mocha palette)
colors.icon = {
  calendar = 0xffffffff, -- Blue
  volume = 0xffcba6f7, -- Mauve
  battery = 0xffa6e3a1, -- Green
  pomodoro = 0xfff38ba8, -- Red
  control_center = 0xff94e2d5, -- Teal
  cpu = 0xfffab387, -- Peach
  memory = 0xfff9e2af, -- Yellow
  network_rx = 0xfff38ba8, -- Red
  network_tx = 0xffa6e3a1, -- Green
  apple = 0xfff2cdcd, -- Flamingo
  spaces = 0xffffffff, -- White
  front_app = 0xffa6e3a1, -- Green
}

-- 3. Define Your Schemes
local schemes = {
	gruvbox = {
		bar_color = 0x70282828,
		accent_color = 0xffd79921,
		secondary_accent = 0xfffabd2f,
		disabled_color = 0xffd3d3d3,
		background = 0xfa1e1e2e,
		background_border = 0xff45475a,
		popup_background = 0xff282828,
		popup_border = 0xffd79921,
	},
	teal = {
		bar_color = 0x40001f30,
		accent_color = 0xfa001f30,
		secondary_accent = 0xff397d89,
		disabled_color = 0xff397d89,
		background = 0xff2cf9ed,
		background_border = 0xfa001f30,
		popup_background = 0xff2cf9ed,
		popup_border = 0xfa001f30,
	},
	blacknwhite = {
		bar_color = 0x40000000,
		accent_color = 0xffffffff,
		secondary_accent = 0xffa9cce3,
		disabled_color = 0xffb0b0b0,
		background = 0xfa101314,
		background_border = 0xffffffff,
		popup_background = 0xff101314,
		popup_border = 0xffffffff,
	},
	purple = {
		bar_color = 0x70140c42,
		accent_color = 0xffeb46f9,
		secondary_accent = 0xffa569bd,
		disabled_color = 0xffb8a1d9,
		background = 0xfa140c42,
		background_border = 0xff2e2a5a,
		popup_background = 0xff140c42,
		popup_border = 0xffeb46f9,
	},
	red = {
		bar_color = 0x7023090e,
		accent_color = 0xffff2453,
		secondary_accent = 0xffc0392b,
		disabled_color = 0xffe1a2a6,
		background = 0xfa23090e,
		background_border = 0xff3c1a22,
		popup_background = 0xff23090e,
		popup_border = 0xffff2453,
	},
	blue = {
		bar_color = 0x70021254,
		accent_color = 0xff15bdf9,
		secondary_accent = 0xff5dade2,
		disabled_color = 0xffaac5e0,
		background = 0xfa021254,
		background_border = 0xff223973,
		popup_background = 0xff021254,
		popup_border = 0xff15bdf9,
	},
	green = {
		bar_color = 0x70003315,
		accent_color = 0xff1dfca1,
		secondary_accent = 0xff52be80,
		disabled_color = 0xffa1e0c0,
		background = 0xfa003315,
		background_border = 0xff0f4d2b,
		popup_background = 0xff003315,
		popup_border = 0xff1dfca1,
	},
	orange = {
		bar_color = 0x70381c02,
		accent_color = 0xfff97716,
		secondary_accent = 0xffeb984e,
		disabled_color = 0xffe0bfa1,
		background = 0xfa381c02,
		background_border = 0xff4f2e11,
		popup_background = 0xff381c02,
		popup_border = 0xfff97716,
	},
	yellow = {
		bar_color = 0x702d2b02,
		accent_color = 0xfff7fc17,
		secondary_accent = 0xfff4d03f,
		disabled_color = 0xffe9dea1,
		background = 0xfa2d2b02,
		background_border = 0xff4e4b13,
		popup_background = 0xff2d2b02,
		popup_border = 0xfff7fc17,
	},
	liquid_glass = {
		bar_color = 0x00000000,
		accent_color = 0xffffffff,
		secondary_accent = 0xffd6eaf8,
		disabled_color = 0xff777777,
		background = 0x20ffffff,
		background_border = 0x40ffffff,
		popup_background = 0xee1a1d1e,
		popup_border = 0x80ffffff,
	},
	catppuccin_latte = {
		bar_color = 0x70eff1f5,
		accent_color = 0xff1e66f5,
		secondary_accent = 0xff7287fd,
		disabled_color = 0xff8c8fa1,
		background = 0xfae6e9ef,
		background_border = 0xffbcc0cc,
		popup_background = 0xffeff1f5,
		popup_border = 0xff1e66f5,
	},
	catppuccin_frappe = {
		bar_color = 0x70303446,
		accent_color = 0xff8caaee,
		secondary_accent = 0xffbabbf1,
		disabled_color = 0xff838ba7,
		background = 0xfa292c3c,
		background_border = 0xff51576d,
		popup_background = 0xff303446,
		popup_border = 0xff8caaee,
	},
	catppuccin_macchiato = {
		bar_color = 0x7024273a,
		accent_color = 0xff8aadf4,
		secondary_accent = 0xffb7bdf8,
		disabled_color = 0xff8087a2,
		background = 0xfa1e2030,
		background_border = 0xff494d64,
		popup_background = 0xff24273a,
		popup_border = 0xff8aadf4,
	},
	catppuccin_mocha = {
		bar_color = 0x701e1e2e,
		accent_color = 0xff89b4fa,
		secondary_accent = 0xffb4befe,
		disabled_color = 0xff7f849c,
		background = 0xfa181825,
		background_border = 0xff45475a,
		popup_background = 0xff1e1e2e,
		popup_border = 0xff89b4fa,
	},
}

-- 3. Select Active Scheme
local active_name
local first_available = next(schemes)

local f = io.open(theme_file, "r")
if f then
	local content = f:read("*all"):gsub("%s+", "")
	if schemes[content] then
		active_name = content
	end
	f:close()
end

active_name = active_name or first_available
local active_scheme_data = schemes[active_name]

-- 4. Merge (Now simple and direct)
for k, v in pairs(active_scheme_data) do
	colors[k] = v
end

-- 5. Export Metadata
colors.active_scheme_name = active_name
colors.all_schemes = schemes

local active_hex = string.format("0x%08x", colors.accent_color)
local inactive_hex = string.format("0x%08x", colors.disabled_color)
os.execute(
	"command -v borders >/dev/null 2>&1 && borders active_color="
		.. active_hex
		.. " inactive_color="
		.. inactive_hex
		.. " width=10.0 hidpi=on &"
)

return colors
