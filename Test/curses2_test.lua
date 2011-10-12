package.path = package.path .. ";Lua/?.lua;Lua/?/?.lua;lSerial/Lua/?.lua"

require "luarocks.require"
require "Curses"
require "switch"
require "Curses.Application"
require "Curses.FileSelector"
require "gDrill.Parameters"
require "gDrill.OptionsView"
require "gDrill.ProgramsView"
require "gDrill.InfoView"
require "gDrill.ConsoleView"
require "gDrill.Serial"

-- Local Variables {{{
local CONFDIR = "Lua"
local CONFFILE = CONFDIR .."/Configuration.lua"
local PROGSDIR = "Test"
local Height
local Width
local starty, startx
local LINES, COLS

local InitScr, TopWin, LeftWin, RigthWin, BottomWin

local LogColor, ErrorColor, WarningError = 1,2,3
local GreenColor, WhiteColor, BlueColor = 4, 5, 6

local device = "/dev/ttyS0" 
local serial
-- }}}
-- Views {{{
local function v_set_color (v, color)
	Curses.WAttrOn(v.Window, Curses.ColorPair(color))	
end

-- }}}
-- Local Functions {{{
local function b (s)
	return(s:byte())
end
local function show_error (str)
	Curses.WAttrOn(BottomWin, Curses.ColorPair(ErrorColor))
	Curses.MvPrint(BottomWin, 2, 2, str)
	Curses.WRefresh(BottomWin)
end

local function init_gdrill ()
	local status, err = pcall(dofile, CONFFILE)
	if not status then
		print("No se pudo encontrar el fichero de configuración.")
		os.exit()
	end
end

local function main (argv, argc)
	init_gdrill()
	local app, err = Application.New()
	if not app then 
		print("Error al crear Application", err)
		os.exit()
	end

	FileSelector.init(app)

	local top = app:addWindow(Window.New(3,app.Width,0,0), "TopWin")
	top.Bindings = {
		e = function (win)
		end,
		a = function (win)
		end,
	}
	local bottom = app:addWindow(Window.New(10, app.Width, app.Height - 10, 0),
		"BottomWin")
	local left = app:addWindow(Window.New(app.Height-13, app.Width/2, 3,0),
		"LeftWin")
	local rigth = app:addWindow(Window.New(app.Height-13, (app.Width/2)+1, 3,
		app.Width/2), "RigthWin") 

	left:addView(NewProgramView(Configuration.Program), "ProgramsView"):show()
	rigth:addView(NewInfoView(), "InfoView"):show()	
	rigth:addView(NewOptionsView(Parameters.Options), "OptionsView")
	print(Curses.GetMaxY(left()))
	os.exit()
	bottom:addView(NewConsoleView(), "ConsoleView")

	serial, err = openDevice(device)

	if not serial then
		bottom.CurrentView:show("ERROR")
	end
	bottom.CurrentView:show(" Device oppened ... OK")
	bottom.CurrentView:show(" Trying communication ... ")

	local n = -1
	local c = 0
	local exit = false
	while not exit do
		n, c = testComm(serial)
		if n < 0 then
			bottom.CurrentView:show("     -> Couldn't communicate with device: "..c)
			bottom.CurrentView:show(" Press 'q' to quit or 'd' to change device")
			local o = bottom:getCh()
			switch(o):caseof{
				q = function ()
					exit = true
				end,
				d = function ()
				end
			}
		end
	end
	
	if n < 0 then
		-- Couldnt start communication, go out!
		app:kill()
		os.exit()
	end
	
	app.Bindings = {
		KEY_F1 = function (app)
			app:setCurrentWindow("RigthWin"):setCurrentView("OptionsView"):show()
		end,
		KEY_F2 = function (app)
			app:setCurrentWindow("RigthWin"):setCurrentView("InfoView"):show()
		end,
		KEY_F3 = function (app)
		end,
		KEY_F4 = function (app)
			app:setCurrentWindow("BottomWin"):setCurrentView("ConsoleView"):show()
		end,
		KEY_F5 = function (app)
		end,
		F = function (app)
			app:fileSelector("/home/atuin/Projects/gDrill/Test")		
		end,
	}
	app:loop()
	app:kill()
end
-- }}}
main(#arg, arg)

--- vi: set foldmethod=marker foldlevel=0:
