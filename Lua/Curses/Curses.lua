module("Curses", package.seeall)

require "luarocks.require"
require "alien"
require "Curses.Constants"

local ncurses = alien.load("ncurses")
local panel = alien.load("panelw")
local ncurses_wrp = alien.load("C/libcurses_wrp.0.1.so")

local initscr = nil

COLOR_BLACK  = 0
COLOR_RED    = 1
COLOR_GREEN  = 2
COLOR_YELLOW = 3
COLOR_BLUE   = 4
COLOR_MAGENTA= 5
COLOR_CYAN   = 6
COLOR_WHITE  = 7

CURSOR_INVISIBLE   = 0
CURSOR_NORMAL      = 1
CURSOR_VERYVISIBLE = 2

-- Interface Definition {{{
-- panel interfaces {{{
panel.new_panel:types{
	ret = "pointer",
	"pointer"
}
panel.update_panels:types{
	ret = "void",
}
-- }}}
-- ncurses_wrp interfaces {{{
ncurses_wrp._box:types{
	ret = "int",
	"pointer", "int", "int"
}

ncurses_wrp._color_pair:types{
	ret = "int",
	"int"
}

ncurses_wrp.getmax_x:types{
	ret = "int",
	"pointer"
}
ncurses_wrp.getmax_y:types{
	ret = "int",
	"pointer"
}
ncurses_wrp._new_win:types{
	ret = "pointer",
	"int","int","int","int"
}
ncurses_wrp._wborder:types{
	ret = "int",
	"pointer", "int", "int", "int", "int", "int",
	"int", "int", "int"
}
-- }}}
-- ncurses interfaces {{{
ncurses.wmove:types{
	ret = "int",
	"pointer", "int", "int"
}
ncurses.wclrtoeol:types{
	ret = "int",
	"pointer"
}
ncurses.delwin:types{
	ret = "int",
	"pointer"
}
ncurses.werase:types{
	ret = "int",
	"pointer"
}
ncurses.halfdelay:types{
	ret = "int",
	"int"
}
ncurses.wclear:types{
	ret = "int",
	"pointer"
}
ncurses.keypad:types{
	ret = "int",
	"pointer", "int"
}
ncurses.timeout:types{
	ret = "void",
	"int"
}
ncurses.curs_set:types{
	ret = "int",
	"int"
}
ncurses.cbreak:types{
	ret = "int",
}

ncurses.use_default_colors:types{
	ret = "int"
}
ncurses.getch:types{
	ret = "int",
}
ncurses.wgetch:types{
	ret = "int",
	"pointer"
}
ncurses.refresh:types{
	ret = "int"
}
ncurses.initscr:types{
	ret = "pointer"
}
ncurses.endwin:types{
	ret = "int"
}
ncurses.wprintw:types{
	ret = "int",
	"pointer","string"
}
ncurses.mvwprintw:types{
	ret = "int",
	"pointer", "int", "int", "string"
}
ncurses.newwin:types{
	ret = "pointer",
	"int", "int", "int", "int"
}
ncurses.box:types{
	ret = "int",
	"pointer", "int", "int"
}
ncurses.wrefresh:types{
	ret = "int",
	"pointer"
}
ncurses.has_colors:types{
	ret = "int",
}
ncurses.start_color:types{
	ret = "int"
}
ncurses.init_pair:types{
	ret = "int",
	"short","short","short"
}
ncurses.attron:types{
	ret = "int",
	"int"
}
ncurses.wattron:types{
	ret = "int",
	"pointer","int"
}
ncurses.echo:types{
	ret = "int",
}
ncurses.noecho:types{
	ret = "int"
}
--}}}
-- Local Functions {{{
local getmaxyx = function (win, v)
	local w
	if not win then
		w = initscr
	else
		w = win
	end
	if (v == "x") then
		return ncurses_wrp.getmax_x(w)
	elseif (v == "y") then
		return ncurses_wrp.getmax_y(w)
	end
end
-- }}}
-- Exported Functions {{{
InitCurses = function ()
	initscr = ncurses.initscr()
	return initscr
end

EndCurses = function ()
	init = false
	return ncurses.endwin()
end

GetMaxX = function (win)
	return getmaxyx(w, "x")
end

GetMaxY = function (win)
	return getmaxyx(w, "y")
end

MvPrint = function (w, y, x, str)
	if w then
		return ncurses.mvwprintw(w, y, x, str)
	else
		return ncurses.mvwprintw(initscr, y, x, str)
	end
end

Print = function (w, str)
	if w then
		return ncurses.wprintw(w, str)
	else
		return ncurses.wprintw(initscr, str)
	end
end

Refresh = function ()
	return ncurses.refresh()
end

GetCh = function ()
	local c = ncurses.getch()
	if c <= 31 or c >= 256 and c <= 511 then
		return Curses.Keys[c] or "KEY_UNKNOW"
	end
	return string.char(c)
end
WGetCh = function (win)
	local c = ncurses.wgetch(win)
	
	if c < 0 then
		return "KEY_UNKNOW"
	end

	if c <= 31 or c >= 256 and c <= 511 then
		return Curses.Keys[c] or "KEY_UNKNOW"
	end

--	return string.char(ncurses.getch())
	return string.char(c)
end

--GetCh = ncurses.getch
NewWin = ncurses_wrp._new_win
DelWin = ncurses.delwin
Box = ncurses_wrp._box
ColorPair = ncurses_wrp._color_pair
WRefresh = ncurses.wrefresh
WBorder = ncurses_wrp._wborder
HasColors = ncurses.has_colors
StartColor = ncurses.start_color
InitPair = ncurses.init_pair
AttrOn = ncurses.attron
WAttrOn = ncurses.wattron
NoEcho = ncurses.noecho
Echo = ncurses.echo
CBreak = ncurses.cbreak
UseDefaultColors = ncurses.use_default_colors
CursSet = ncurses.curs_set
KeyPad = ncurses.keypad
WErase = ncurses.werase
WClear = ncurses.wclear
WClrToEol = ncurses.wclrtoeol
WMove = ncurses.wmove
HalfDelay = ncurses.halfdelay
Timeout = ncurses.timeout
NewPanel = panel.new_panel
UpdatePanels = panel.update_panels
-- }}}
---- vi: set foldmethod=marker foldlevel=0:
