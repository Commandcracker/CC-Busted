-- © Commandcracker
-- lua-term for CC
-- https://github.com/hoelzro/lua-term

-- lua version of https://github.com/hoelzro/lua-term/blob/master/core.c

local term = {}

function term.isatty(handle)
	return handle == io.stdin or handle == io.stdout or handle == io.stderr
end

return term
