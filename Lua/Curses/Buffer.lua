module("Buffer", package.seeall)

local function add_line (buf, line)
	buf.Buffer[buf.N+1] = line
	buf.N = buf.N + 1
end

local function clear_buffer (buf)
	buf.N = 0
end

local function show (buf, win, y, x)
	local yp = 2
	Curses.Refresh()
	for i=1, buf.N do
		Curses.MvPrint(win, yp, 2, buf.Buffer[i])
		yp = yp + 1
		Curses.Refresh()
	end	
end

local buf_methods = {
	addLine = add_line,
	show = show,
	clear = clear_buffer
}

New = function ()
	local buf = {
		Buffer = {},
		N = 0
	}
	return setmetatable(buf, {
		__index=buf_methods,
		__call = function (v,i)
			return buf.Buffer[i]
		end
	})
end
