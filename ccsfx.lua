-- based on: https://pastebin.com/rxnjypsW
local tArgs = { ... }

local function get_program_name()
    if arg then
        return arg[0]
    end
    return fs.getName(shell.getRunningProgram()):gsub("[\\.].*$", "")
end

local isColour = term.isColour()

if #tArgs ~= 2 then
    print("Usage: " .. get_program_name() .. " <directory> <archivename>")
    return
end

local sfxFiles = ""
local sfxDirs = ""

local root = tArgs[1]

if root:sub(-1) ~= "/" then
    root = root .. "/"
end

local function serFile(fpath)
    sleep() -- yield
    print("file " .. root .. fpath)
    if fs.getSize(root .. fpath) > 1000000 then
        printError(root .. fpath .. " is too long, skipping")
        return
    end
    local file = fs.open(root .. fpath, "r")
    local text = file.readAll()
    file.close()
    sfxFiles = sfxFiles .. '"' .. fpath .. '",\n[=====[' .. text .. "]=====]" .. ",\n"
end

local function serDir(path)
    if isColour then
        term.setTextColour(colors.blue)
    end
    print("dir  " .. root .. path)
    if isColour then
        term.setTextColour(colors.white)
    end
    local files = fs.list(root .. path)
    for _, file in ipairs(files) do
        local fpath = path .. file
        if fs.isDir(root .. fpath) then
            sfxDirs = sfxDirs .. '"' .. fpath .. '",\n'
            serDir(fpath .. "/")
        else
            serFile(fpath)
        end
    end
end

serDir("")

local sfx = [[
local tArgs = { ... }

local function get_program_name()
    if arg then
        return arg[0]
    end
    return fs.getName(shell.getRunningProgram()):gsub("[\\.].*$", "")
end

local isColour = term.isColour()

if #tArgs ~= 1 then
	print("Usage: " .. get_program_name() .. " <dir>")
	return
end

local root = tArgs[1]

if root:sub(-1) ~= "/" then
    root = root .. "/"
end

local files = {
]] .. sfxFiles .. [[
}

local dirs = {]] .. sfxDirs .. [[}

if not fs.isDir(tArgs[1]) then
    fs.makeDir(tArgs[1])
end

for _,dir in ipairs(dirs) do
    local fpath = root .. dir
    if isColour then
        term.setTextColour(colors.blue)
    end
    print("dir " .. fpath)
    if isColour then
        term.setTextColour(colors.white)
    end
    if not fs.isDir(fpath) then
        fs.makeDir(fpath)
    end
end

local i = 1
while i<#files do
    sleep() -- yield
    local fpath = root .. files[i]
    local data = files[i+1]
    print("file " .. fpath)
    local file = fs.open(fpath, "w")
    file.write(data)
    file.close()
    i = i+2
end]]

local file = fs.open(tArgs[2], "w")
file.write(sfx)
file.close()
