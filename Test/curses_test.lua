package.path = package.path .. ";Lua/?.lua;Lua/?/?.lua"

require "luarocks.require"
require "Curses"
require "switch"
require "Parameters"

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
end

local function init_gdrill ()
	local status, err = pcall(dofile, CONFFILE)
	if not status then
		print("No se pudo encontrar el fichero de configuración.")
		os.exit()
	end
end

local function init_screen ()
	InitScr = Curses.InitCurses()
	Width = Curses.GetMaxX(InitScr)
	Height = Curses.GetMaxY(InitScr)
	TopWin = Curses.NewWin(3, Width, 0, 0)
	BottomWin = Curses.NewWin(10, Width, Height-10,0)
	LeftWin = Curses.NewWin(Height-13, Width/2, 3,0)
	--Curses.Box(initscr, 1,1)
	Curses.WBorder(InitScr, 1, 1, 1, 1, 1, 1, 1, 1)
	Curses.Box(TopWin, 0,0)
	Curses.Box(BottomWin, 0, 0)
	Curses.Box(LeftWin, 0, 0)
	ProgramView, err  = NewProgramView(LeftWin, Configuration.Program)
	if not ProgramView then
		Curses.EndCurses()
		print(err)
		os.exit()			
	end
	Curses.Refresh(InitScr)
	Curses.NoEcho()
	Curses.CursSet(Curses.CURSOR_INVISIBLE)
	Curses.KeyPad(InitScr, 1)
end

local function main (argv, argc)
	init_gdrill()
	init_screen()
	init_colors()
	if not ProgramView:init() then
		print("KKKK")
		os.exit()
	end
	ProgramView:show()
	local loop = true 
	while (loop) do
		a = Curses.GetCh()
		switch(a):caseof{
			Q = function ()
				loop = false
			end,

			default = function ()
				
			end
		}
		Curses.Refresh()
	end
	Curses.EndCurses()
end
-- }}}
main(#arg, arg)

--- vi: set foldmethod=marker foldlevel=0:
