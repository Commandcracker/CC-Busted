-- © Commandcracker
-- LuaSystem for ComputerCraft
-- https://github.com/o-lim/luasystem

local system = {
	-- To have 1:1 compatibility with LuaSystem
	_VERSION = "LuaSystem 0.2.1",
}

function system.sleep(seconds)
	-- Use sleep instead of os.sleep because os.sleep is an alias of sleep
	sleep(seconds)
end

-- One decimal place less accurate than the original version
function system.gettime()
	return os.epoch("utc") / 1000
end

-- 6 decimal places less accurate than the original version
function system.monotime()
	return os.clock()
end

return system
