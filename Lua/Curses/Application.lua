module("Application", package.seeall)

require "Curses"
require "Curses.Window"

LogColor, ErrorColor, WarningColor = 1,2,3
GreenColor, WhiteColor, BlueColor = 4, 5, 6
YellowColor = WarningColor
RedColor = ErrorColor

local function init_colors ()
	if not Curses.HasColors() then
		Curses.EndCurses()
		print("Se necesita un terminal que soporte colores")
		os.exit()
	end
	Curses.StartColor()
	Curses.UseDefaultColors()
	Curses.InitPair(ErrorColor, Curses.COLOR_RED, -1)
	Curses.InitPair(LogColor, Curses.COLOR_WHITE, -1)
	Curses.InitPair(WarningColor, Curses.COLOR_YELLOW, -1)
	Curses.InitPair(GreenColor, Curses.COLOR_GREEN, -1)
	Curses.InitPair(WhiteColor, Curses.COLOR_WHITE, -1)
	Curses.InitPair(BlueColor, Curses.COLOR_BLUE, -1)
	Curses.InitPair(YellowColor, Curses.COLOR_YELLOW, -1)
end

local function get_binding (app, key)
	local b = app:currentViewBindings()
	if b and b[key] then
		return b[key](app.CurrentWindow.CurrentView)
	end
	b = app:currentWindowBindigs()
	if b and b[key] then
		return b[key](app.CurrentWindow)
	end
	b = app:bindings()
	if b and b[key] then
		return b[key](app)
	end
	if key == "Q" then
		return true, true
	end
	return nil, false
end

local function loop (app)
	local a, s, exit
	while (true) do
		a = Curses.WGetCh(app.CurrentWindow.Window)
		s, exit = get_binding(app, a)
		if exit then
			return true
		end
	end
end

local function bindings (app)
	return app.Bindings
end

local function current_window_bindings (app)
	local w = app.CurrentWindow
	if w then return w.Bindings end
	return nil
end

local function current_view_bindings (app)
	local v
	local w = app.CurrentWindow
	if w then
		v = w.CurrentView
		if v then return v.Bindings end
		return nil
	end
	return nil
end

local function refresh (app)
	Curses.WRefresh(app.InitScr)
	for _, w in pairs(app.Windows) do
		w:refresh()
	end
	Curses.WRefresh(app.CurrentWindow)
end

local function add_window (app, win, name)
	app.Windows[name] = win
	app.CurrentWindow = win
	return win
end

local function get_window_by_name (app, name)
	return app.Windows[name]
end

local function set_current_window (app, name)
	if app:getWindowByName(name) ~= nil then
		app.CurrentWindow = app:getWindowByName(name)
		return app.CurrentWindow
	end
	return nil
end

local function kill (app)
	Curses.EndCurses()
end

local app_methods = {
	loop = loop,
	refresh = refresh,
	kill = kill,
	addWindow = add_window,
	getWindowByName = get_window_by_name,
	bindings = bindings,
	setCurrentWindow = set_current_window,
	currentWindowBindigs = current_window_bindings,
	currentViewBindings = current_view_bindings,
}

New = function (argc, argc)
	local app = {
		Windows = {},
		Loop = true,
		CurrentWindow = nil,
	}
	app.InitScr = Curses.InitCurses()
	init_colors()
	app.Width = Curses.GetMaxX(InitScr)
	app.Height = Curses.GetMaxY(InitScr)
	Curses.WBorder(app.InitScr, 1, 1, 1, 1, 1, 1, 1, 1)
	Curses.WRefresh(app.InitScr)
	Curses.NoEcho()
	Curses.CursSet(Curses.CURSOR_INVISIBLE)
	Curses.KeyPad(InitScr, 1)
	Curses.CBreak()
	Curses.HalfDelay(3)
	return setmetatable(app, {__index=app_methods})
end

BlueColor = 4
