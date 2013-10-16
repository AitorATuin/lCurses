local M = {}

M.switch = function (c)
    local swtbl = {
        casevar = c,
        caseof = function (self, code, ...)
            local f
            if (self.casevar) then
                f = code[self.casevar] or code.default
            else
                f = code.missing or code.default
            end
            if f then
                if type(f)=="function" then
                    return f(self.casevar,unpack(arg))
                else
                    -- f is value not a function
                    if (code[f]) and self.casevar ~= code[f] then
                        -- Allows reference existent casevars
                        self.casevar = f
                        return self.caseof(self, code, unpack(arg))
                    else
                        return f
                    end
                end
            end
        end
    }
    return swtbl
end

return M
