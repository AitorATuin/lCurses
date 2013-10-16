M = {}
local function file_exists (file)
    local fd = io.open(file)
    if not fd then
        return false
    end
    fd:close()
    return true
end

M.alienize = function (libname, env)
    local paths = {
        os.getenv(env) or "./",
        os.getenv("HOME") .. "/.lua/lib/",
    }
    for p in package.cpath:gmatch("[^;]+") do
        paths[#paths+1] = p:match("(.+)/+[^/]+$")
    end
    local lib, success
    local str = ""
    for _, p in ipairs(paths) do
        local file = p .. "/" .. libname
        if file_exists(file) then
            success, lib, o = pcall(alien.load,
                p.."/"..libname)
            if success then
                return lib
            else
                return nil, string.format("Could not open file %s: %s",
                    file, lib)
            end
        end
    end
    return nil, string.format("Could not found file %s", libname)
end

return M
