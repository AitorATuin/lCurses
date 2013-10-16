local HOME = os.getenv("HOME")
local LOCALLUAPATH = HOME .. "/.lua/share/?.lua;" .. HOME ..  "/.lua/share/?/?.lua"
package.path = package.path .. ";" .. LOCALLUAPATH

require "luarocks.require"
local curses = require "Curses".configure()

local main = function (argc, argv)
   local mainwin = curses.InitCurses()
   curses.MvPrint(mainwin, 12, 33, "Hello World!")
   curses.Refresh()
   os.execute("sleep 3")
   curses.DelWin(mainwin)
   curses.EndCurses()
   curses.Refresh()
end

main(#arg, arg)
