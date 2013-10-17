--module("Curses", package.seeall)
local Curses = {}
local M = {}
local M_mt = {}
local initscr = nil
local alien = require "alien"
local alienize = require "Curses.alienize"

-- Exported functions
Curses.configure = function ()
   local ncursesWrapper = alienize.alienize("liblcurses.so", "LCURSESSO")
   if not ncursesWrapper then
      error(string.format("Could not load liblcurses.so library: %s", err))
   end

   local panel = alien.load("panelw")
   local ncurses = alien.load("ncursesw")
   M.init(ncurses, panel, ncursesWrapper)
   M.init = nil

   return setmetatable(M, {
                          __index = M_mt
   })
end

-- Module table functions
M.init = function (ncurses, panel, ncursesWrapper)
   -- initialize panel interface
   panel.new_panel:types{
      ret = "pointer",
      "pointer"
   }
   panel.update_panels:types{
      ret = "void",
   }
   -- }}}
   -- initialize libncurses interfaces
   ncursesWrapper._box:types{
      ret = "int",
      "pointer", "int", "int"
   }

   ncursesWrapper._color_pair:types{
      ret = "int",
      "int"
   }

   ncursesWrapper.getmax_x:types{
      ret = "int",
      "pointer"
   }
   ncursesWrapper.getmax_y:types{
      ret = "int",
      "pointer"
   }
   ncursesWrapper._new_win:types{
      ret = "pointer",
      "int","int","int","int"
   }
   ncursesWrapper._wborder:types{
      ret = "int",
      "pointer", "int", "int", "int", "int", "int",
      "int", "int", "int"
   }

   -- Initialize ncurses interface
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

   local mt_methods = {
      "InitCurses", "EndCurses", "GetMaxX", "GetMaxY", "MvPrint", "Print", "Refresh",
      "GetCh", "WGetCh"
   }

   local mt_methods_ncursesWrapper = {
      NewWin = "_new_win",
      Box = "_box",
      ColorPair = "_color_pair",
      WBorder = "_wborder"
   }

   local mt_methods_panel = {
      NewPanel = "new_panel",
      UpdatePanels = "update_panels"
   }

   local mt_methods_ncurses = {
      DelWin = "delwin",
      WRefresh = "wrefresh",
      HasColors = "has_colors",
      StartColor = "start_color",
      InitPair = "init_pair",
      AttrOn = "attron",
      WAttrOn = "wattron",
      NoEcho = "noecho",
      Echo = "echo",
      CBreak = "cbreak",
      UseDefaultColors = "use_default_colors",
      CursSet = "curs_set",
      KeyPad = "keypad",
      WErase = "werase",
      WClear = "wclear",
      WClrToEol = "wclrtoeol",
      WMove = "wmove",
      HalfDelay = "halfdelay",
      Timeout = "timeout",
   }

   local constants = {
      COLOR_BLACK  = 0,
      COLOR_RED    = 1,
      COLOR_GREEN  = 2,
      COLOR_YELLOW = 3,
      COLOR_BLUE   = 4,
      COLOR_MAGENTA= 5,
      COLOR_CYAN   = 6,
      COLOR_WHITE  = 7,
      CURSOR_INVISIBLE   = 0,
      CURSOR_NORMAL      = 1,
      CURSOR_VERYVISIBLE = 2,
   }
   local keys = {}
   keys[27] = "KEY_ESC"
   keys[258] = "KEY_DOWN"
   keys[259] = "KEY_UP"
   keys[260] = "KEY_LEFT"
   keys[261] = "KEY_RIGHT"
   keys[264] = "KEY_F0"
   keys[265] = "KEY_F1"
   keys[266] = "KEY_F2"
   keys[267] = "KEY_F3"
   keys[268] = "KEY_F4"
   keys[269] = "KEY_F5"
   keys[270] = "KEY_F6"
   keys[271] = "KEY_F7"
   keys[272] = "KEY_F8"
   keys[273] = "KEY_F9"
   keys[274] = "KEY_F10"
   keys[275] = "KEY_F11"
   keys[276] = "KEY_F12"
   keys[10] = "KEY_ENTER"
   M_mt.Keys = keys

   for c, v in pairs(constants) do
      M_mt[c] = v
   end

   for c,v in pairs(keys) do
   end

   for mf, mo in pairs(mt_methods_ncursesWrapper) do
      M_mt[mf] = ncursesWrapper[mo]
   end
   for mf, mo in pairs(mt_methods_panel) do
      M_mt[mf] = panel[mo]
   end
   for mf, mo in pairs(mt_methods_ncurses) do
      M_mt[mf] = ncurses[mo]
   end
   for _, m in pairs(mt_methods) do
      M_mt[m] = M_mt[m](ncurses, panel, ncursesWrapper)
   end
end

local getmaxyx = function (ncursesWrapper, win, v)
   local w
   if not win then
      w = initscr
   else
      w = win
   end
   if (v == "x") then
      return ncursesWrapper.getmax_x(w)
   elseif (v == "y") then
      return ncursesWrapper.getmax_y(w)
   end
end

M_mt.InitCurses = function (ncurses, panel, ncursesWrapper)
   return function ()
      initscr = ncurses.initscr()
      return initscr
   end
end
M_mt.EndCurses = function (ncurses, panel, ncursesWrapper)
   return function ()
      init = false
      return ncurses.endwin()
   end
end
M_mt.GetMaxX = function (ncurses, panel, ncursesWrapper)
   return function (win)
      return getmaxyx(ncursesWrapper, w, "x")
   end
end
M_mt.GetMaxY = function (ncurses, panel, ncursesWrapper)
   return function (win)
      return getmaxyx(ncursesWrapper, w, "y")
   end
end
M_mt.MvPrint = function (ncurses, panel, ncursesWrapper)
   return function (w, y, x, str)
      if w then
         return ncurses.mvwprintw(w, y, x, str)
      else
         return ncurses.mvwprintw(initscr, y, x, str)
      end
   end
end
M_mt.Print = function (ncurses, panel, ncursesWrapper)
   return function (w, str)
      if w then
         return ncurses.wprintw(w, str)
      else
         return ncurses.wprintw(initscr, str)
      end
   end
end
M_mt.Refresh = function (ncurses, panel, ncursesWrapper)
   return function ()
      return ncurses.refresh()
   end
end
M_mt.GetCh = function (ncurses, panel, ncursesWrapper)
   return function ()
      local c = ncurses.getch()
      if c <= 31 or c >= 256 and c <= 511 then
         return M_mt.Keys[c] or "KEY_UNKNOW"
      end
      return string.char(c)
   end
end
M_mt.WGetCh = function (ncurses, panel, ncursesWrapper)
   return function (win)
      local c = ncurses.wgetch(win)

      if c < 0 then
         return "KEY_UNKNOW"
      end

      if c <= 31 or c >= 256 and c <= 511 then
         return M_mt.Keys[c] or "KEY_UNKNOW"
      end
      return string.char(c)
   end
end

return Curses
