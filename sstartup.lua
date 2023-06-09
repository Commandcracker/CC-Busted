-- Busted runner for ComputerCraft
-- Made for headless craftos-pc

-- https://tweaked.cc/library/cc.require.html
local r = require("cc.require")

-- Create a new environment
local env = setmetatable({}, {
    -- Override __index metamethod
    __index = function(self, key)
        if key == "_G" then
            -- Return a custom _G table
            return setmetatable({}, {
                __index = function(_, key)
                    if key == "require" then
                        --[[ Fix for pl.path
                            Code:
                                local res,lfs = _G.pcall(_G.require,'lfs')
                                if not res then
                                    error("pl.path requires LuaFileSystem")
                                end
                            Error: pl.path requires LuaFileSystem
                        ]]
                        return self.require
                    end
                    if key == "package" then
                        -- Return a custom package table
                        return setmetatable({}, {
                            __index = function(_, key)
                                if key == "config" then
                                    --[[ Fix for pl.compat.dir_separator
                                        Code: compat.dir_separator = _G.package.config:sub(1,1)
                                        Error: attempt to index field 'config' (a nil value)
                                    ]]
                                    return "/"
                                end
                                -- Return the value from the original _G.package table
                                return _ENV._G.package[key]
                            end,
                        })
                    end
                    -- Return the value from the original _G table
                    return _ENV._G[key]
                end,
            })
        end
        -- Return the value from the original environment
        return _ENV[key]
    end,
})

-- Set up the require function and package table for the environment
env.require, env.package = r.make(env, "/lib")

--[[ Fix for busted.runner
    Code: package.cpath = (cliArgs.cpath .. ';' .. package.cpath):gsub(';;',';')
    Eror: attempt to concatenate field 'cpath' (a nil value)
]]
env.package.cpath = ""

-- Handle exit calls in busted.runner (busted.compatibility)
function env.os.exit(code)
    os.shutdown(code)
end

-- Pass arguments
for key, value in pairs({ ... }) do
    env.arg[key] = value
end

local ok, error = pcall(function()
    env.require("busted.runner")({ standalone = false })
end)

if not ok then
    if error then
        local ESC = string.char(27)
        print(("%s[31m[busted.runner] %s%s[0m"):format(ESC, error, ESC))
    end
    os.shutdown(42) -- best error code ever
end

os.shutdown()
