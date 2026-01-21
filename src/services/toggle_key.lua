-- /src/services/toggle_key.lua
local keycodeLookup = {}
for _, code in ipairs(Enum.KeyCode:GetEnumItems()) do
	keycodeLookup[string.lower(code.Name)] = code
end

local function sanitizeKeyName(key)
	if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
		return key.Name
	end

	if type(key) == "string" then
		local trimmed = key:gsub("^%s+", ""):gsub("%s+$", "")
		trimmed = trimmed:gsub("Enum.KeyCode%.", "")
		trimmed = trimmed:gsub("%s+", "")
		if trimmed ~= "" then
			return trimmed
		end
	end

	return nil
end

local function resolveKeyCode(key)
	if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
		return key
	end

	local cleaned = sanitizeKeyName(key)
	if not cleaned then
		return nil
	end

	return keycodeLookup[string.lower(cleaned)]
end

local function getEnvTable()
	local ok, env = pcall(function()
		if type(getgenv) == "function" then
			return getgenv()
		end
	end)

	if ok and typeof(env) == "table" then
		return env
	end

	if type(_G) == "table" then
		return _G
	end

	return nil
end

local ToggleKeyStore = {}
ToggleKeyStore.__index = ToggleKeyStore

function ToggleKeyStore.new(options)
	options = options or {}

	local self = setmetatable({}, ToggleKeyStore)
	self.folder = options.folder or "AurexisServiceConfig"
	self.file = options.file or "interface-toggle.txt"
	self.envKey = options.envKey or "__AurexisToggleKey"
	self.cached = nil

	return self
end

function ToggleKeyStore:_ensureFolder()
	if typeof(isfolder) ~= "function" or typeof(makefolder) ~= "function" then
		return false
	end

	local okExists, exists = pcall(isfolder, self.folder)
	if okExists and exists then
		return true
	end

	local okCreate, created = pcall(makefolder, self.folder)
	return okCreate and created == true
end

function ToggleKeyStore:_readFile()
	if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then
		return nil
	end

	if not self:_ensureFolder() then
		return nil
	end

	local path = self.folder .. "/" .. self.file
	local okExists, exists = pcall(isfile, path)
	if not okExists or not exists then
		return nil
	end

	local ok, contents = pcall(readfile, path)
	if not ok or type(contents) ~= "string" then
		return nil
	end

	return sanitizeKeyName(contents)
end

function ToggleKeyStore:_writeFile(key)
	if typeof(writefile) ~= "function" then
		return false
	end

	if not self:_ensureFolder() then
		return false
	end

	local path = self.folder .. "/" .. self.file
	local ok = pcall(writefile, path, key)
	return ok == true
end

function ToggleKeyStore:_setEnvPreference(key)
	local env = getEnvTable()
	if env and self.envKey then
		env[self.envKey] = key
	end
end

function ToggleKeyStore:_getEnvPreference()
	local env = getEnvTable()
	if env and self.envKey then
		return sanitizeKeyName(env[self.envKey])
	end
	return nil
end

function ToggleKeyStore:load()
	if self.cached then
		return self.cached
	end

	local fromFile = self:_readFile()
	if fromFile then
		self.cached = fromFile
		self:_setEnvPreference(fromFile)
		return fromFile
	end

	local fromEnv = self:_getEnvPreference()
	if fromEnv then
		self.cached = fromEnv
		return fromEnv
	end

	return nil
end

function ToggleKeyStore:save(key)
	local cleaned = sanitizeKeyName(key)
	if not cleaned then
		return false
	end

	self.cached = cleaned
	self:_setEnvPreference(cleaned)
	self:_writeFile(cleaned)

	return true
end

function ToggleKeyStore:expose(globalName)
	local api = {
		load = function()
			return self:load()
		end,
		save = function(value)
			return self:save(value)
		end,
		sanitize = sanitizeKeyName,
		resolve = resolveKeyCode,
	}

	local okShared, sharedTable = pcall(function()
		return shared
	end)

	if okShared and typeof(sharedTable) == "table" then
		sharedTable[globalName or "ToggleKeyStore"] = api
	end

	local env = getEnvTable()
	if env then
		env[globalName or "ToggleKeyStore"] = api
	end

	return api
end

return {
	new = function(options)
		return ToggleKeyStore.new(options)
	end,
	sanitize = sanitizeKeyName,
	resolve = resolveKeyCode,
}

