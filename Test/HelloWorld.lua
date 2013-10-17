local HOME = os.getenv("HOME")
local LOCALLUAPATH = HOME .. "/.lua/share/?.lua;" .. HOME ..  "/.lua/share/?/?.lua"
package.path = package.path .. ";" .. LOCALLUAPATH

require "luarocks.require"
local curses = require "Curses".configure()

local main = function (argc, argv)
   local mainwin = curses.InitCurses()
   local y = curses.GetMaxY(mainwin)
   local x = curses.GetMaxX(mainwin)
   curses.MvPrint(mainwin, 12, 33, string.format("Hello World! [%s-%s]",x,y))
   curses.Refresh()
   os.execute("sleep 3")
   curses.DelWin(mainwin)
   curses.EndCurses()
   curses.Refresh()
end

main(#arg, arg)
