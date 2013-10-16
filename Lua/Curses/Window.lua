module("Window", package.seeall)

require "Curses"
require "Curses.View"

local function add_view (win, view, name)
	win.Views[name] = view
	win.CurrentView = view
	view.Window = win
	return view
end

local function get_ch (win)
	return Curses.WGetCh(win())
end

local function get_view_by_name (win, name)
	return win.Views[name]
end

local function set_current_view (win, name)
	if win.Views[name] then
		win.CurrentView = win.Views[name]
		return win.CurrentView
	end
	return nil
end

local function refresh (win)
	Curses.Box(win(), 0, 0)
	Curses.WRefresh(win())
end

local function kill (win)
	Curses.WErase(win.Window)
	Curses.DelWin(win.Window)
	for _,v in pairs(win.Views) do
		v:kill()
	end
	win.CurrentView = nil
	win = nil
end

local win_methods = {
	addView = add_view,
	getViewByName = get_view_by_name,
	setCurrentView = set_current_view,
	refresh = refresh,
	getCh = get_ch,
	kill = kill
}

New = function (y, x, h, w, box)
	local win = {
		Views = {}
	}
	win.Window = Curses.NewWin(y, x, h, w)
	if box then
		Curses.Box(win.Window, 89, 88)
	end
	
	Curses.KeyPad(win.Window, 1)
	return setmetatable(win, {
		__index=win_methods,
		__call = function (win) return win.Window end
	})
end 
