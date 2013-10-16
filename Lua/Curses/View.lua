module("View", package.seeall)

require "Curses"
require "Curses.Buffer"

local set_color = function (v, color)
	Curses.WAttrOn(v.Window(), Curses.ColorPair(color))
end

local init = function (v)
	return true
end

local show = function (v)
	v.Buffer:show(v.Window(), v:height(), v:width())
	v.Window:refresh()
end

local width = function (v)
	return Curses.GetMaxX(v())
end

local height = function (v)
	return Curses.GetMaxY(v())
end

local function kill (v)
	v.Buffer = nil
	v.Window = nil
	v = nil
end

local view_methods = {
	setColor = set_color,
	show = show,
	height = height,
	width = width,
	kill = kill
}

New = function ()
	local view = {
		Window = nil,
		Buffer = Buffer.New()
	}
	return setmetatable(view, {
		__index = view_methods,
		__call = function (view)
			return view.Window()
		end
		})
end
