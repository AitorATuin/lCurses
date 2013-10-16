module("FileSelector",package.seeall)

require "Curses"
require "Curses.Buffer"
require "switch"

local height = 30
local width = 50

local function show (buf, win, y, x)
	local yp = 2
	Curses.Refresh()
	for i=1, 3 do
		Curses.MvPrint(win(), yp, 2, buf.Buffer[i])
		yp = yp + 1
	end	
	for i=1, buf.N do
		if i == win.Pos then
			win.CurrentView:setColor(Application.RedColor)
		else
			win.CurrentView:setColor(Application.WhiteColor)
		end
		Curses.MvPrint(win(), yp, 2, buf.Buffer[i+3])
		yp = yp + 1
	end
	win:refresh()	
end

local function refresh_view (w)
	local yp = 5
	local buf = w.CurrentView.Buffer
	for i=w.N0, w.Nf do
		if i == w.Pos then
			w.CurrentView:setColor(Application.RedColor)	
			Curses.WMove(w(), yp+1, 4)
			Curses.WClrToEol(w())
		else
			w.CurrentView:setColor(Application.WhiteColor)
		end
		yp = yp +1
--		Curses.MvPrint(w(), yp, 2, buf.Buffer[i+3])
		Curses.MvPrint(w(), yp, 2, "OOOOOOOOOOOOOOOOOO")
		Curses.Refresh()
	end
	w:refresh()
end

local function move_up (w)
	w.Pos = w.Pos - 1
	if w.Pos < 1 then
		w.Pos = 1
	else
		if w.Pos < w.N0 then
			refresh_view(w)
		end
	end
	set_cursor(w)
end

local function move_down (w)
	w.Pos = w.Pos + 1
	if w.Pos > w.N then
		os.exit()
	else
		if w.Pos > w.Nf then
			w.N0 = w.N0 + 1
			w.Nf = w.Nf + 1
		end
	end
	refresh_view(w)
end

local bindings = {
	KEY_UP = function (w, buffer)
		move_up(w)
		return "M",true
	end,
	KEY_DOWN = function (w, buffer)
		move_down(w)
	end,
	KEY_ENTER = function ()
		return "N", true
	end,
	KEY_ESC = function (w, buffer)
		return nil,true
	end,
	KEY_F1 = function ()
		exit = true
	end,
}

local function loop (w, buffer)
	local a, s
	local exit = false
	local res
--	Curses.KeyPad(w(),1)
	while (not exit) do
		a = Curses.WGetCh(w())
		if bindings[a] then
			res, exit = bindings[a](w, buffer)
		end
	end
	return res
end

local function new (app, path)
	local w = Window.New(height, width, 
			(app.Height/2) - (height/2),
			(app.Width/2) - (width/2))

	w:addView(View.New(), "FileSelector")

	local buffer = w.CurrentView.Buffer
	buffer:addLine("Select a file")
	buffer:addLine("-------------")
	buffer:addLine("")
	local n = 0
	for i in io.popen("ls " .. path):lines() do
		n = n + 1
		buffer:addLine(i)
	end
 	w.N = n -- # of files
	w.N0 = 1
	w.Nf = height - 4
	w.Pos = 1
	
--	w.CurrentView:show()
	show(buffer, w, w.CurrentView:height(), w.CurrentView:width())
	loop(w, buffer)
	w:kill()
	app:refresh()
end

init = function (app)
	app.fileSelector = new
end
