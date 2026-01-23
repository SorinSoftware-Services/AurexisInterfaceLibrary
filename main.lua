--[[                                                                                                                                                   

                                                                                                                                                                      
                                                                                                                                                                      
               AAA                                                                                         iiii                        UUUUUUUU     UUUUUUUUIIIIIIIIII
              A:::A                                                                                       i::::i                       U::::::U     U::::::UI::::::::I
             A:::::A                                                                                       iiii                        U::::::U     U::::::UI::::::::I
            A:::::::A                                                                                                                  UU:::::U     U:::::UUII::::::II
           A:::::::::A        uuuuuu    uuuuuu rrrrr   rrrrrrrrr       eeeeeeeeeeee  xxxxxxx      xxxxxxxiiiiiii     ssssssssss         U:::::U     U:::::U   I::::I  
          A:::::A:::::A       u::::u    u::::u r::::rrr:::::::::r    ee::::::::::::ee x:::::x    x:::::x i:::::i   ss::::::::::s        U:::::D     D:::::U   I::::I  
         A:::::A A:::::A      u::::u    u::::u r:::::::::::::::::r  e::::::eeeee:::::eex:::::x  x:::::x   i::::i ss:::::::::::::s       U:::::D     D:::::U   I::::I  
        A:::::A   A:::::A     u::::u    u::::u rr::::::rrrrr::::::re::::::e     e:::::e x:::::xx:::::x    i::::i s::::::ssss:::::s      U:::::D     D:::::U   I::::I  
       A:::::A     A:::::A    u::::u    u::::u  r:::::r     r:::::re:::::::eeeee::::::e  x::::::::::x     i::::i  s:::::s  ssssss       U:::::D     D:::::U   I::::I  
      A:::::AAAAAAAAA:::::A   u::::u    u::::u  r:::::r     rrrrrrre:::::::::::::::::e    x::::::::x      i::::i    s::::::s            U:::::D     D:::::U   I::::I  
     A:::::::::::::::::::::A  u::::u    u::::u  r:::::r            e::::::eeeeeeeeeee     x::::::::x      i::::i       s::::::s         U:::::D     D:::::U   I::::I  
    A:::::AAAAAAAAAAAAA:::::A u:::::uuuu:::::u  r:::::r            e:::::::e             x::::::::::x     i::::i ssssss   s:::::s       U::::::U   U::::::U   I::::I  
   A:::::A             A:::::Au:::::::::::::::uur:::::r            e::::::::e           x:::::xx:::::x   i::::::is:::::ssss::::::s      U:::::::UUU:::::::U II::::::II
  A:::::A               A:::::Au:::::::::::::::ur:::::r             e::::::::eeeeeeee  x:::::x  x:::::x  i::::::is::::::::::::::s        UU:::::::::::::UU  I::::::::I
 A:::::A                 A:::::Auu::::::::uu:::ur:::::r              ee:::::::::::::e x:::::x    x:::::x i::::::i s:::::::::::ss           UU:::::::::UU    I::::::::I
AAAAAAA                   AAAAAAA uuuuuuuu  uuuurrrrrrr                eeeeeeeeeeeeeexxxxxxx      xxxxxxxiiiiiiii  sssssssssss               UUUUUUUUU      IIIIIIIIII

 ___              _                  _   _           ___          _      ___       __ _                         ___              _           
|   \ _____ _____| |___ _ __  ___ __| | | |__ _  _  / __| ___ _ _(_)_ _ / __| ___ / _| |___ __ ____ _ _ _ ___  / __| ___ _ ___ _(_)__ ___ ___
| |) / -_) V / -_) / _ \ '_ \/ -_) _` | | '_ \ || | \__ \/ _ \ '_| | ' \\__ \/ _ \  _|  _\ V  V / _` | '_/ -_) \__ \/ -_) '_\ V / / _/ -_|_-<
|___/\___|\_/\___|_\___/ .__/\___\__,_| |_.__/\_, | |___/\___/_| |_|_||_|___/\___/_|  \__|\_/\_/\__,_|_| \___| |___/\___|_|  \_/|_\__\___/__/
                        |_|                    |__/                                                                                            


Main Credits
Luna Interface Suite
by Nebula Softworks

]]



local BASE_URL = "https://raw.githubusercontent.com/SorinSoftware-Services/AurexisInterfaceLibrary/Developer/"

local Release = "Developerbuild for: Version 1.0.0"

local Aurexis = { 
	Folder = "AurexisLibrary UI", 
	Options = {}, 
	AllowEnvironmentBlur = true,
	ThemeGradient = ColorSequence.new{
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(173, 216, 255)), -- baby blue
		ColorSequenceKeypoint.new(0.50, Color3.fromRGB(100, 149, 237)), -- medium blue
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(195, 144, 255))  -- lila
	} 
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Localization = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local ContextActionService = game:GetService("ContextActionService")

local keycodeLookup = {}
do
	for _, code in ipairs(Enum.KeyCode:GetEnumItems()) do
		keycodeLookup[string.lower(code.Name)] = code
	end
end

local function normalizeKeyCode(key)
	if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
		return key
	end

	if type(key) == "number" then
		for _, code in ipairs(Enum.KeyCode:GetEnumItems()) do
			if code.Value == key then
				return code
			end
		end
	end

	if type(key) == "string" then
		local trimmed = key:gsub("^%s+", ""):gsub("%s+$", "")
		trimmed = trimmed:gsub("Enum.KeyCode%.", "")
		trimmed = trimmed:gsub("%s+", "")
		if trimmed == "" then
			return nil
		end

		local lookup = keycodeLookup[string.lower(trimmed)]
		if lookup then
			return lookup
		end
	end

	return nil
end

local function keyCodeLabel(key)
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
	return "Unknown"
end

local compatibilityPlaces = {
	[16389395869] = true, -- a dusty trip
}

local compatibilityUniverses = {
	[5650396773] = true, -- a dusty trip universe
	[3989869156] = true, -- ANTS WAR
	[111958650] = true,  -- Arsenal
	[7848646653] = true, -- Break your Bones
	[6401952734] = true, -- PETS GO!
	[6035872082] = true, --RIVALS
}

if compatibilityPlaces[game.PlaceId] or compatibilityUniverses[game.GameId] then
	Aurexis.AllowEnvironmentBlur = false
end

local isStudio
local website = "https://sorinsoftware.services"

if RunService:IsStudio() then
	isStudio = true
end

-- On touch devices, disable heavy environment blur by default
if UserInputService.TouchEnabled and not isStudio then
	Aurexis.AllowEnvironmentBlur = false
end


-- Universal remote require helper
local function requireRemote(path)
	local ok, result = pcall(function()
		local body = game:HttpGet(BASE_URL .. path)
		-- sanitize potential invisible Unicode characters from remote code
		local replacements = {
			{ string.char(0xC2, 0xA0), " " },      -- NBSP -> space
			{ string.char(0xE2, 0x80, 0x8B), "" }, -- ZWSP
			{ string.char(0xE2, 0x80, 0x8C), "" }, -- ZWNJ
			{ string.char(0xE2, 0x80, 0x8D), "" }, -- ZWJ
			{ string.char(0xEF, 0xBB, 0xBF), "" }, -- BOM
		}
		for i = 1, #replacements do
			local patt, repl = replacements[i][1], replacements[i][2]
			body = body:gsub(patt, repl)
		end
		return loadstring(body)()
	end)
	if ok then
		return result
	else
		warn("?? Failed to load module: " .. path .. " ? " .. tostring(result))
		return {}
	end
end

-- Load Icon Module
local IconModule = requireRemote("src/icons.lua")

-- Toggle key service (for loaders / consumers)
local ToggleKeyService = requireRemote("src/services/toggle_key.lua")
Aurexis.ToggleKeyService = ToggleKeyService

-- Other Variables
local request = (syn and syn.request) or (http and http.request) or http_request or nil
local tweeninfo = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local PresetGradients = {
	["Nightlight (Classic)"] = {Color3.fromRGB(147, 255, 239), Color3.fromRGB(201,211,233), Color3.fromRGB(255, 167, 227)},
	["Nightlight (Neo)"] = {Color3.fromRGB(173, 216, 255), Color3.fromRGB(100, 149, 237), Color3.fromRGB(195, 144, 255)},
	Starlight = {Color3.fromRGB(147, 255, 239), Color3.fromRGB(181, 206, 241), Color3.fromRGB(214, 158, 243)},
	Solar = {Color3.fromRGB(242, 157, 76), Color3.fromRGB(240, 179, 81), Color3.fromRGB(238, 201, 86)},
	Sparkle = {Color3.fromRGB(199, 130, 242), Color3.fromRGB(221, 130, 238), Color3.fromRGB(243, 129, 233)},
	Lime = {Color3.fromRGB(170, 255, 127), Color3.fromRGB(163, 220, 138), Color3.fromRGB(155, 185, 149)},
	Vine = {Color3.fromRGB(0, 191, 143), Color3.fromRGB(0, 126, 94), Color3.fromRGB(0, 61, 46)},
	Cherry = {Color3.fromRGB(148, 54, 54), Color3.fromRGB(168, 67, 70), Color3.fromRGB(188, 80, 86)},
	Daylight = {Color3.fromRGB(51, 156, 255), Color3.fromRGB(89, 171, 237), Color3.fromRGB(127, 186, 218)},
	Blossom = {Color3.fromRGB(255, 165, 243), Color3.fromRGB(213, 129, 231), Color3.fromRGB(170, 92, 218)},
}

function Aurexis:GetIcon(icon, source)
	if source == "Custom" then
		return "rbxassetid://" .. icon
	elseif source == "Lucide" then
		-- full credit to latte softworks :)
		local iconData = not isStudio and game:HttpGet("https://raw.githubusercontent.com/latte-soft/lucide-roblox/refs/heads/master/lib/Icons.luau")
		local icons = isStudio and IconModule.Lucide or loadstring(iconData)()
		if not isStudio then
			icon = string.match(string.lower(icon), "^%s*(.*)%s*$") :: string
			local sizedicons = icons['48px']

			local r = sizedicons[icon]
			if not r then
				error("Lucide Icons: Failed to find icon by the name of \"" .. icon .. "\.", 2)
			end

			local rirs = r[2]
			local riro = r[3]

			if type(r[1]) ~= "number" or type(rirs) ~= "table" or type(riro) ~= "table" then
				error("Lucide Icons: Internal error: Invalid auto-generated asset entry")
			end

			local irs = Vector2.new(rirs[1], rirs[2])
			local iro = Vector2.new(riro[1], riro[2])

			local asset = {
				id = r[1],
				imageRectSize = irs,
				imageRectOffset = iro,
			}

			return asset
		else
			return "rbxassetid://10723434557"
		end
	else	
		if icon ~= nil and IconModule[source] then
			local sourceicon = IconModule[source]
			return sourceicon[icon]
		else
			return nil
		end
	end
end

local function RemoveTable(tablre, value)
	for i,v in pairs(tablre) do
		if tostring(v) == tostring(value) then
			table.remove(tablre, i)
		end
	end
end

local function Kwargify(defaults, passed)
	for i, v in pairs(defaults) do
		if passed[i] == nil then
			passed[i] = v
		end
	end
	return passed
end

local function PackColor(Color)
	return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end    

local function UnpackColor(Color)
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end

function tween(object, goal, callback, tweenin)
	local tween = TweenService:Create(object,tweenin or tweeninfo, goal)
	tween.Completed:Connect(callback or function() end)
	tween:Play()
end

local topbarButtons = {}
local topbarDecorations = {}

local function registerTopbarButton(frame)
	if not (frame and frame:IsA("Frame")) then
		return
	end
	frame:SetAttribute("AurexisTopbarButton", true)
	if frame.BackgroundTransparency ~= nil then
		frame:SetAttribute("AurexisTopbarTargetBackground", frame.BackgroundTransparency)
	end
	local stroke = frame:FindFirstChildWhichIsA("UIStroke")
	if stroke then
		frame:SetAttribute("AurexisTopbarTargetStroke", stroke.Transparency)
	end
	local icon = frame:FindFirstChildWhichIsA("ImageButton") or frame:FindFirstChildWhichIsA("ImageLabel")
	if icon then
		frame:SetAttribute("AurexisTopbarTargetImage", icon.ImageTransparency)
	end
	for _, existing in ipairs(topbarButtons) do
		if existing == frame then
			return
		end
	end
	table.insert(topbarButtons, frame)
end

local function registerTopbarDecoration(frame, targetBackground, targetStroke)
	if not (frame and frame:IsA("Frame")) then
		return
	end
	frame:SetAttribute("AurexisTopbarDecoration", true)
	if targetBackground ~= nil then
		frame:SetAttribute("AurexisTopbarTargetBackground", targetBackground)
	elseif frame:GetAttribute("AurexisTopbarTargetBackground") == nil then
		frame:SetAttribute("AurexisTopbarTargetBackground", frame.BackgroundTransparency or 0.35)
	end
	local stroke = frame:FindFirstChildWhichIsA("UIStroke")
	if targetStroke ~= nil then
		frame:SetAttribute("AurexisTopbarTargetStroke", targetStroke)
	elseif stroke and frame:GetAttribute("AurexisTopbarTargetStroke") == nil then
		frame:SetAttribute("AurexisTopbarTargetStroke", stroke.Transparency)
	end
	for _, existing in ipairs(topbarDecorations) do
		if existing == frame then
			return
		end
	end
	table.insert(topbarDecorations, frame)
end

local function iterateTopbarButtons()
	local active = {}
	for _, button in ipairs(topbarButtons) do
		if button and button.Parent then
			table.insert(active, button)
		end
	end
	return active
end

local function iterateTopbarDecorations()
	local active = {}
	for _, frame in ipairs(topbarDecorations) do
		if frame and frame.Parent then
			table.insert(active, frame)
		end
	end
	return active
end

local function setTopbarVisible(visible)
	for _, button in ipairs(iterateTopbarButtons()) do
		local targetBackground = button:GetAttribute("AurexisTopbarTargetBackground") or 0.25
		local stroke = button:FindFirstChildWhichIsA("UIStroke")
		local icon = button:FindFirstChildWhichIsA("ImageButton") or button:FindFirstChildWhichIsA("ImageLabel")

		if visible then
			button.Visible = true
		end

		tween(button, {BackgroundTransparency = visible and targetBackground or 1})

		if stroke then
			local targetStroke = button:GetAttribute("AurexisTopbarTargetStroke") or 0.5
			tween(stroke, {Transparency = visible and targetStroke or 1})
		end

		if icon then
			local targetImage = button:GetAttribute("AurexisTopbarTargetImage") or 0.25
			tween(icon, {ImageTransparency = visible and targetImage or 1})
		end

		if not visible then
			button.Visible = false
		end
	end

	for _, decoration in ipairs(iterateTopbarDecorations()) do
		if visible then
			decoration.Visible = true
		end

		local backgroundTarget = decoration:GetAttribute("AurexisTopbarTargetBackground") or 0.35
		tween(decoration, {BackgroundTransparency = visible and backgroundTarget or 1})

		local stroke = decoration:FindFirstChildWhichIsA("UIStroke")
		if stroke then
			local strokeTarget = decoration:GetAttribute("AurexisTopbarTargetStroke") or 0.5
			tween(stroke, {Transparency = visible and strokeTarget or 1})
		end

		if not visible then
			decoration.Visible = false
		end
	end
end

local cleanedLegacyBlur = false
local blurBindings = {}
local blurTargets = setmetatable({}, { __mode = "k" })
local blurUid = 0
local sharedDepthOfField
local activeBlurCount = 0

local function ensureBlurRoot()
	local camera = workspace.CurrentCamera
	if not camera then
		return nil
	end
	local root = camera:FindFirstChild("AurexisBlur")
	if not root then
		root = Instance.new("Folder")
		root.Name = "AurexisBlur"
		root.Parent = camera
	end
	return root
end

local function ensureDepthOfField()
	if not Aurexis.AllowEnvironmentBlur then
		return nil
	end

	if isStudio then
		return nil
	end

	if not sharedDepthOfField or sharedDepthOfField.Parent ~= Lighting then
		sharedDepthOfField = Lighting:FindFirstChild("AurexisDepthOfField")
		if not sharedDepthOfField then
			sharedDepthOfField = Instance.new("DepthOfFieldEffect")
			sharedDepthOfField.Name = "AurexisDepthOfField"
			sharedDepthOfField.Parent = Lighting
		end
	end

	sharedDepthOfField.FarIntensity = 0
	sharedDepthOfField.FocusDistance = 51.6
	sharedDepthOfField.InFocusRadius = 50
	sharedDepthOfField.NearIntensity = 6
	sharedDepthOfField.Enabled = activeBlurCount > 0

	return sharedDepthOfField
end

local function cleanupBlur(guiObject)
	local data = blurBindings[guiObject]
	if not data then
		return
	end
	blurBindings[guiObject] = nil
	if data.step then
		data.step:Disconnect()
	end
	if data.uid then
		RunService:UnbindFromRenderStep(data.uid)
	end
	if data.folder then
		data.folder:Destroy()
	end
	if data.wrapper then
		data.wrapper:Destroy()
	end

	blurTargets[guiObject] = nil

	if activeBlurCount > 0 then
		activeBlurCount = activeBlurCount - 1
	end
	local effect = ensureDepthOfField()
	if effect then
		effect.Enabled = activeBlurCount > 0
	end
end

local function ensureGuiBlur(guiObject)
	if not Aurexis.AllowEnvironmentBlur then
		return nil
	end

	if blurBindings[guiObject] then
		return blurBindings[guiObject]
	end

	local root = ensureBlurRoot()
	local camera = workspace.CurrentCamera
	if not root or not camera then
		return nil
	end

	local wrapper = Instance.new("Frame")
	wrapper.Name = guiObject.Name .. "_BlurFrame"
	wrapper.Parent = guiObject
	wrapper.Size = UDim2.new(0.95, 0, 0.95, 0)
	wrapper.Position = UDim2.new(0.5, 0, 0.5, 0)
	wrapper.AnchorPoint = Vector2.new(0.5, 0.5)
	wrapper.BackgroundTransparency = 1

	blurUid += 1
	local uid = "neon::" .. tostring(blurUid)
	local parts = {}
	local folder = Instance.new("Folder")
	folder.Name = wrapper.Name
	folder.Parent = root

	local parents = {}
	local lastAbsPos
	local lastAbsSize
	local lastRotSum
	local lastCameraCFrame
	local lastCameraFov
	local function addAncestor(child)
		if child:IsA("GuiObject") then
			parents[#parents + 1] = child
			if child.Parent then
				addAncestor(child.Parent)
			end
		end
	end
	addAncestor(wrapper)

	local acos, max, pi, sqrt = math.acos, math.max, math.pi, math.sqrt
	local sz = 0.22

	local function drawTriangle(v1, v2, v3, p0, p1)
		local s1 = (v1 - v2).Magnitude
		local s2 = (v2 - v3).Magnitude
		local s3 = (v3 - v1).Magnitude
		local smax = max(s1, s2, s3)
		local A, B, C
		if smax == s1 then
			A, B, C = v1, v2, v3
		elseif smax == s2 then
			A, B, C = v2, v3, v1
		else
			A, B, C = v3, v1, v2
		end

		local para = ((B - A).X*(C - A).X + (B - A).Y*(C - A).Y + (B - A).Z*(C - A).Z) / (A - B).Magnitude
		local perp = sqrt((C - A).Magnitude^2 - para * para)
		local dif_para = (A - B).Magnitude - para

		local st = CFrame.new(B, A)
		local za = CFrame.Angles(pi/2, 0, 0)

		local cf0 = st
		local topLook = (cf0 * za).LookVector
		local midPoint = A + CFrame.new(A, B).LookVector * para
		local neededLook = CFrame.new(midPoint, C).LookVector
		local dot = topLook.X*neededLook.X + topLook.Y*neededLook.Y + topLook.Z*neededLook.Z

		local ac = CFrame.Angles(0, 0, acos(dot))

		cf0 = cf0 * ac
		if ((cf0 * za).LookVector - neededLook).Magnitude > 0.01 then
			cf0 = cf0 * CFrame.Angles(0, 0, -2 * acos(dot))
		end
		cf0 = cf0 * CFrame.new(0, perp/2, -(dif_para + para/2))

		local cf1 = st * ac * CFrame.Angles(0, pi, 0)
		if ((cf1 * za).LookVector - neededLook).Magnitude > 0.01 then
			cf1 = cf1 * CFrame.Angles(0, 0, 2 * acos(dot))
		end
		cf1 = cf1 * CFrame.new(0, perp/2, dif_para/2)

		if not p0 then
			p0 = Instance.new("Part")
			p0.FormFactor = Enum.FormFactor.Custom
			p0.TopSurface = Enum.SurfaceType.Smooth
			p0.BottomSurface = Enum.SurfaceType.Smooth
			p0.Anchored = true
			p0.CanCollide = false
			p0.CastShadow = false
			p0.Material = Enum.Material.Glass
			p0.Size = Vector3.new(sz, sz, sz)
		end

		local mesh0 = p0:FindFirstChild("WedgeMesh")
		if not mesh0 then
			mesh0 = Instance.new("SpecialMesh")
			mesh0.MeshType = Enum.MeshType.Wedge
			mesh0.Name = "WedgeMesh"
			mesh0.Parent = p0
		end

		p0.WedgeMesh.Scale = Vector3.new(0, perp/sz, para/sz)
		p0.CFrame = cf0

		if not p1 then
			p1 = p0:Clone()
		end

		local mesh1 = p1:FindFirstChild("WedgeMesh")
		if not mesh1 then
			mesh1 = Instance.new("SpecialMesh")
			mesh1.MeshType = Enum.MeshType.Wedge
			mesh1.Name = "WedgeMesh"
			mesh1.Parent = p1
		end

		p1.WedgeMesh.Scale = Vector3.new(0, perp/sz, dif_para/sz)
		p1.CFrame = cf1

		return p0, p1
	end

	local function drawQuad(v1, v2, v3, v4, partsTable)
		partsTable[1], partsTable[2] = drawTriangle(v1, v2, v3, partsTable[1], partsTable[2])
		partsTable[3], partsTable[4] = drawTriangle(v3, v2, v4, partsTable[3], partsTable[4])
	end

	local function updateOrientation(fetchProps)
		local absPos = wrapper.AbsolutePosition
		local absSize = wrapper.AbsoluteSize
		local cameraCFrame = camera.CFrame
		local cameraFov = camera.FieldOfView

		local rot = 0
		for _, ancestor in ipairs(parents) do
			rot = rot + ancestor.Rotation
		end
		if not fetchProps
			and lastAbsPos
			and lastAbsPos == absPos
			and lastAbsSize == absSize
			and rot == lastRotSum
			and cameraCFrame == lastCameraCFrame
			and cameraFov == lastCameraFov then
			return
		end

		lastAbsPos = absPos
		lastAbsSize = absSize
		lastRotSum = rot
		lastCameraCFrame = cameraCFrame
		lastCameraFov = cameraFov

		local zIndex = 1 - 0.05 * wrapper.ZIndex

		local tl = absPos
		local br = absPos + absSize
		local tr = Vector2.new(br.X, tl.Y)
		local bl = Vector2.new(tl.X, br.Y)

		if rot ~= 0 and rot % 180 ~= 0 then
			local mid = tl:Lerp(br, 0.5)
			local s = math.sin(math.rad(rot))
			local c = math.cos(math.rad(rot))
			tl = Vector2.new(c*(tl.X - mid.X) - s*(tl.Y - mid.Y), s*(tl.X - mid.X) + c*(tl.Y - mid.Y)) + mid
			tr = Vector2.new(c*(tr.X - mid.X) - s*(tr.Y - mid.Y), s*(tr.X - mid.X) + c*(tr.Y - mid.Y)) + mid
			bl = Vector2.new(c*(bl.X - mid.X) - s*(bl.Y - mid.Y), s*(bl.X - mid.X) + c*(bl.Y - mid.Y)) + mid
			br = Vector2.new(c*(br.X - mid.X) - s*(br.Y - mid.Y), s*(br.X - mid.X) + c*(br.Y - mid.Y)) + mid
		end

		drawQuad(
			camera:ScreenPointToRay(tl.X, tl.Y, zIndex).Origin,
			camera:ScreenPointToRay(tr.X, tr.Y, zIndex).Origin,
			camera:ScreenPointToRay(bl.X, bl.Y, zIndex).Origin,
			camera:ScreenPointToRay(br.X, br.Y, zIndex).Origin,
			parts
		)

		if fetchProps then
			for _, part in ipairs(parts) do
				part.Parent = folder
				part.Transparency = 0.98
				part.BrickColor = BrickColor.new("Institutional white")
			end
		end
	end

	updateOrientation(true)
	RunService:BindToRenderStep(uid, 2000, function()
		updateOrientation(false)
	end)

	blurBindings[guiObject] = {
		wrapper = wrapper,
		folder = folder,
		parts = parts,
		uid = uid,
	}
	blurTargets[guiObject] = true

	activeBlurCount = activeBlurCount + 1
	local effect = ensureDepthOfField()
	if effect then
		effect.Enabled = true
	end

	return blurBindings[guiObject]
end

local function BlurModule(Frame)
	local guiObject = Frame
	if not guiObject or not guiObject:IsA("GuiObject") then
		return nil
	end

	if not cleanedLegacyBlur then
		cleanedLegacyBlur = true
		local camera = workspace.CurrentCamera
		if camera then
			local legacy = camera:FindFirstChild("AurexisBlur")
			if legacy then
				legacy:Destroy()
			end
		end

		if not isStudio then
			for _, effect in ipairs(Lighting:GetChildren()) do
				if effect:IsA("DepthOfFieldEffect") and string.sub(effect.Name, 1, 4) == "DPT_" then
					effect:Destroy()
				end
			end
		end
	end

	local existing = guiObject:FindFirstChild("AutoDropShadow")
	if existing then
		return existing
	end

	if not guiObject:GetAttribute("AurexisBlurApplied") then
		guiObject:SetAttribute("AurexisBlurApplied", true)
		blurTargets[guiObject] = true
		if Aurexis.AllowEnvironmentBlur then
			ensureGuiBlur(guiObject)
		end
	end

	local shadow = Instance.new("ImageLabel")
	shadow.Name = "AutoDropShadow"
	shadow.BackgroundTransparency = 1
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = UDim2.new(0.5, 0, 0.5, 6)
	shadow.Size = UDim2.new(1, 40, 1, 40)
	shadow.Image = "rbxassetid://13160452170"
	shadow.ImageColor3 = Color3.new(0, 0, 0)
	shadow.ImageTransparency = 0.985
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(60, 60, 60, 60)
	shadow.ZIndex = math.max(0, guiObject.ZIndex - 1)
	shadow.Parent = guiObject

	local zConn = guiObject:GetPropertyChangedSignal("ZIndex"):Connect(function()
		if shadow.Parent then
			shadow.ZIndex = math.max(0, guiObject.ZIndex - 1)
		end
	end)

	local function releaseBlur()
		if guiObject:GetAttribute("AurexisBlurApplied") then
			guiObject:SetAttribute("AurexisBlurApplied", nil)
		end

		cleanupBlur(guiObject)
		blurTargets[guiObject] = nil

		zConn:Disconnect()
		if shadow.Parent then
			shadow:Destroy()
		end
	end

	guiObject.Destroying:Connect(releaseBlur)
	guiObject.AncestryChanged:Connect(function(_, parent)
		if not parent then
			releaseBlur()
		end
	end)

	return shadow
end

local function unpackt(array : table)

	local val = ""
	local i = 0
	for _,v in pairs(array) do
		if i < 3 then
			val = val .. v .. ", "
			i += 1
		else
			val = "Various"
			break
		end
	end

	return val
end

-- Interface Management
local AurexisUI = isStudio and script.Parent:WaitForChild("Aurexis UI") or game:GetObjects("rbxassetid://86467455075715")[1]

local SizeBleh = nil
local mainWindowFrame = nil

-- Helper to prevent camera movement on mobile while the main window is open
local MOBILE_BLOCK_ACTION = "Aurexis_BlockMobileTouch"
local function setMobileInputBlocked(block)
	if not UserInputService.TouchEnabled or isStudio then
		return
	end

	if block then
		ContextActionService:BindAction(
			MOBILE_BLOCK_ACTION,
			function()
				return Enum.ContextActionResult.Sink
			end,
			false,
			Enum.UserInputType.Touch
		)
	else
		ContextActionService:UnbindAction(MOBILE_BLOCK_ACTION)
	end
end

local function Hide(Window, bind, notif)
	SizeBleh = Window.Size
	bind = string.split(tostring(bind), "Enum.KeyCode.")
	bind = bind[2]
	if notif then
		Aurexis:Notification({Title = "Interface Hidden", Content = "The interface has been hidden, you can reopen the interface by Pressing ("..tostring(bind)..")", Icon = "visibility_off"})
	end
	tween(Window, {BackgroundTransparency = 1})
	tween(Window.Elements, {BackgroundTransparency = 1})
	tween(Window.Line, {BackgroundTransparency = 1})
	tween(Window.Title.Title, {TextTransparency = 1})
	tween(Window.Title.subtitle, {TextTransparency = 1})
	tween(Window.Logo, {ImageTransparency = 1})
	tween(Window.Navigation.Line, {BackgroundTransparency = 1})

	if Window == mainWindowFrame then
		setTopbarVisible(false)
		setMobileInputBlocked(false)
	else
		local controlsContainer = nil
		if typeof(Window) == "Instance" then
			controlsContainer = Window:FindFirstChild("Controls")
		end
		controlsContainer = controlsContainer or (Window and Window.Controls)

		if controlsContainer then
			for _, TopbarButton in ipairs(controlsContainer:GetChildren()) do
				if TopbarButton.ClassName == "Frame" then
					tween(TopbarButton, {BackgroundTransparency = 1})
					local stroke = TopbarButton:FindFirstChildWhichIsA("UIStroke")
					if stroke then
						tween(stroke, {Transparency = 1})
					end
					local icon = TopbarButton:FindFirstChildWhichIsA("ImageButton") or TopbarButton:FindFirstChildWhichIsA("ImageLabel")
					if icon then
						tween(icon, {ImageTransparency = 1})
					end
					TopbarButton.Visible = false
				end
			end
		end
	end
	for _, tabbtn in ipairs(Window.Navigation.Tabs:GetChildren()) do
		if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "InActive Template" then
			TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
			if tabbtn.ImageLabel then
				TweenService:Create(tabbtn.ImageLabel, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
			end
			local dropShadowHolder = tabbtn:FindFirstChild("DropShadowHolder")
			if dropShadowHolder and dropShadowHolder:FindFirstChild("DropShadow") then
				TweenService:Create(dropShadowHolder.DropShadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
			end
			local tabStroke = tabbtn:FindFirstChildWhichIsA("UIStroke")
			if tabStroke then
				TweenService:Create(tabStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
			end
		end
	end

	task.wait(0.28)
	Window.Size = UDim2.new(0,0,0,0)
	Window.Parent.ShadowHolder.Visible = false
	task.wait()
	Window.Elements.Parent.Visible = false
	Window.Visible = false
end


if gethui then
	AurexisUI.Parent = gethui()
elseif syn and syn.protect_gui then 
	syn.protect_gui(AurexisUI)
	AurexisUI.Parent = CoreGui
elseif not isStudio and CoreGui:FindFirstChild("RobloxGui") then
	AurexisUI.Parent = CoreGui:FindFirstChild("RobloxGui")
elseif not isStudio then
	AurexisUI.Parent = CoreGui
end

if gethui then
	for _, Interface in ipairs(gethui():GetChildren()) do
		if Interface.Name == AurexisUI.Name and Interface ~= AurexisUI then
			Hide(Interface.SmartWindow)
			Interface.Enabled = false
			Interface.Name = "Aurexis-Old"
		end
	end
elseif not isStudio then
	for _, Interface in ipairs(CoreGui:GetChildren()) do
		if Interface.Name == AurexisUI.Name and Interface ~= AurexisUI then
			Hide(Interface.SmartWindow)
			Interface.Enabled = false
			Interface.Name = "Aurexis-Old"
		end
	end
end

AurexisUI.Enabled = false
AurexisUI.SmartWindow.Visible = false
AurexisUI.Notifications.Template.Visible = false
AurexisUI.DisplayOrder = 1000000000

local Main : Frame = AurexisUI.SmartWindow
mainWindowFrame = Main
local Dragger = Main.Drag
local dragBar = AurexisUI.Drag
local dragInteract = dragBar and dragBar.Interact or nil
local dragBarCosmetic = dragBar and dragBar.Drag or nil
local Elements = Main.Elements.Interactions
local LoadingFrame = Main.LoadingFrame
local Navigation = Main.Navigation
local Controls = Main.Controls
local closeButton = Controls and Controls:FindFirstChild("Close", true) or nil
local toggleSizeButton = Controls and Controls:FindFirstChild("ToggleSize", true) or nil
local minimizeButton = Controls and Controls:FindFirstChild("Minimize", true) or nil
local closeDialogState = {host = nil, dialog = nil, targetSize = nil, scrollers = {}}

if not minimizeButton and closeButton then
	minimizeButton = closeButton:Clone()
	minimizeButton.Name = "Minimize"
	minimizeButton.Visible = closeButton.Visible
	local icon = minimizeButton:FindFirstChildWhichIsA("ImageButton") or minimizeButton:FindFirstChildWhichIsA("ImageLabel")
	local minimizeIcon = Aurexis:GetIcon("minimize", "Material")
	if icon and minimizeIcon then
		if typeof(minimizeIcon) == "table" and minimizeIcon.id then
			icon.Image = "rbxassetid://" .. minimizeIcon.id
			icon.ImageRectOffset = minimizeIcon.imageRectOffset
			icon.ImageRectSize = minimizeIcon.imageRectSize
		else
			icon.Image = minimizeIcon
			icon.ImageRectOffset = Vector2.new(0, 0)
			icon.ImageRectSize = Vector2.new(0, 0)
		end
	end
end

local allowToggleButton = UserInputService.KeyboardEnabled ~= false
if toggleSizeButton and not allowToggleButton then
	toggleSizeButton.Visible = false
	toggleSizeButton = nil
end

local orderedButtons = {}
if minimizeButton then
	table.insert(orderedButtons, minimizeButton)
end
if toggleSizeButton then
	table.insert(orderedButtons, toggleSizeButton)
end
if closeButton then
	table.insert(orderedButtons, closeButton)
end

for _, button in ipairs(orderedButtons) do
	registerTopbarButton(button)
end

local controlClusterParent = Controls
local referenceButton = closeButton or toggleSizeButton or minimizeButton
local clusterAnchor = referenceButton and referenceButton.AnchorPoint or Vector2.new(0.5, 0.5)
local clusterPosition = referenceButton and referenceButton.Position or UDim2.new(1, -10, 0, 0)
local buttonSize = referenceButton and referenceButton.Size or UDim2.fromOffset(32, 32)
local controlCluster = nil

if controlClusterParent then
	controlCluster = controlClusterParent:FindFirstChild("ControlCluster")
end

if controlCluster and controlCluster.Parent ~= controlClusterParent then
	controlCluster.Parent = controlClusterParent
end

if not controlCluster then
	controlCluster = Instance.new("Frame")
	controlCluster.Name = "ControlCluster"
	controlCluster.Parent = controlClusterParent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 7)
	corner.Parent = controlCluster

	local stroke = Instance.new("UIStroke")
	stroke.Name = "ControlClusterStroke"
	stroke.Thickness = 1
	stroke.Transparency = 0.6
	stroke.Color = Color3.fromRGB(94, 98, 120)
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.ZIndex = referenceButton and referenceButton.ZIndex or 1
	stroke.Parent = controlCluster

	registerTopbarDecoration(controlCluster, 0.55, stroke.Transparency)
else
	local stroke = controlCluster:FindFirstChildWhichIsA("UIStroke")
	if stroke then
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.ZIndex = referenceButton and referenceButton.ZIndex or stroke.ZIndex
		controlCluster:SetAttribute("AurexisTopbarTargetStroke", stroke.Transparency)
	end
	controlCluster:SetAttribute("AurexisTopbarTargetBackground", 0.55)
	registerTopbarDecoration(controlCluster, 0.55, stroke and stroke.Transparency or nil)
end

controlCluster.AnchorPoint = clusterAnchor
controlCluster.Position = clusterPosition
controlCluster.AutomaticSize = Enum.AutomaticSize.XY
controlCluster.BackgroundColor3 = Color3.fromRGB(32, 30, 38)
controlCluster.BackgroundTransparency = 0.55
controlCluster:SetAttribute("AurexisTopbarTargetBackground", 0.55)
controlCluster.BorderSizePixel = 0
controlCluster.Size = UDim2.new(0, 0, 0, 0)
controlCluster.Visible = false
controlCluster.ZIndex = referenceButton and math.max(referenceButton.ZIndex - 1, 0) or 0
controlCluster.LayoutOrder = referenceButton and (referenceButton.LayoutOrder or 0) or 0

local clusterLayout = controlCluster:FindFirstChild("ControlLayout")
if not clusterLayout then
	clusterLayout = Instance.new("UIListLayout")
	clusterLayout.Name = "ControlLayout"
	clusterLayout.FillDirection = Enum.FillDirection.Horizontal
	clusterLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	clusterLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	clusterLayout.SortOrder = Enum.SortOrder.LayoutOrder
	clusterLayout.Padding = UDim.new(0, 3)
	clusterLayout.Parent = controlCluster
end

local clusterPadding = controlCluster:FindFirstChild("ControlPadding")
if not clusterPadding then
	clusterPadding = Instance.new("UIPadding")
	clusterPadding.Name = "ControlPadding"
	clusterPadding.PaddingTop = UDim.new(0, 2)
	clusterPadding.PaddingBottom = UDim.new(0, 2)
	clusterPadding.PaddingLeft = UDim.new(0, 4)
	clusterPadding.PaddingRight = UDim.new(0, 4)
	clusterPadding.Parent = controlCluster
else
	clusterPadding.PaddingTop = UDim.new(0, 2)
	clusterPadding.PaddingBottom = UDim.new(0, 2)
	clusterPadding.PaddingLeft = UDim.new(0, 4)
	clusterPadding.PaddingRight = UDim.new(0, 4)
end

for _, child in ipairs(controlCluster:GetChildren()) do
	if child.Name:match("^ControlDivider") then
		child:Destroy()
	end
end

local dividerHeight = math.max(buttonSize.Y.Offset - 6, 10)
local layoutOrder = 1

local function addDivider(order)
	local divider = Instance.new("Frame")
	divider.Name = "ControlDivider" .. order
	divider.BackgroundColor3 = Color3.fromRGB(96, 100, 122)
	divider.BackgroundTransparency = 0.45
	divider.BorderSizePixel = 0
	divider.Size = UDim2.new(0, 1, 0, dividerHeight)
	divider.LayoutOrder = order
	divider.ZIndex = referenceButton and referenceButton.ZIndex or 1
	divider.Parent = controlCluster
	registerTopbarDecoration(divider, divider.BackgroundTransparency, nil)
end

for index, button in ipairs(orderedButtons) do
	if button then
		button.Parent = controlCluster
		button.LayoutOrder = layoutOrder
		layoutOrder += 1
		if index < #orderedButtons then
			addDivider(layoutOrder)
			layoutOrder += 1
		end
	end
end

local function scaleUDim2(size: UDim2, multiplier: number): UDim2
	return UDim2.new(
		size.X.Scale * multiplier,
		math.floor(size.X.Offset * multiplier),
		size.Y.Scale * multiplier,
		math.floor(size.Y.Offset * multiplier)
	)
end

local function createLayeredSpinner(baseImageLabel: ImageLabel?)
	if not baseImageLabel or not baseImageLabel.Parent then
		return nil
	end

	if not baseImageLabel:IsA("ImageLabel") then
		return nil
	end

	local spinner = {
		layers = {},
		coreTransparency = 0.25,
	}

	local sizeMultiplier = 0.65
	local spinnerBaseSize = scaleUDim2(baseImageLabel.Size, sizeMultiplier)

	local container = Instance.new("Frame")
	container.Name = "LayeredSpinner"
	container.AnchorPoint = baseImageLabel.AnchorPoint
	container.Position = baseImageLabel.Position
	container.Size = spinnerBaseSize
	container.BackgroundTransparency = 1
	container.ZIndex = baseImageLabel.ZIndex
	container.LayoutOrder = baseImageLabel.LayoutOrder
	container.Parent = baseImageLabel.Parent
	container.Visible = true

	baseImageLabel.Visible = false

	local function lighten(color: Color3, amount: number): Color3
		local alpha = math.clamp(amount or 0, 0, 1)
		return Color3.new(
			color.R + (1 - color.R) * alpha,
			color.G + (1 - color.G) * alpha,
			color.B + (1 - color.B) * alpha
		)
	end

	local ringPalette = {
		Color3.fromRGB(190, 225, 255),
		Color3.fromRGB(162, 205, 255),
		Color3.fromRGB(134, 185, 255)
	}

	local accentPalette = {
		Color3.fromRGB(195, 144, 255),
		Color3.fromRGB(182, 130, 255),
		Color3.fromRGB(205, 170, 255)
	}

	local ringConfigs = {
		{scale = 1, thickness = 5, speed = 120, direction = 1, color = ringPalette[1], accentColor = accentPalette[1], gradientRotation = 5, targetTransparency = 0.08},
		{scale = 0.78, thickness = 4, speed = 180, direction = -1, color = ringPalette[2], accentColor = accentPalette[2], gradientRotation = -15, targetTransparency = 0.05},
		{scale = 0.52, thickness = 3, speed = 240, direction = 1, color = ringPalette[3], accentColor = accentPalette[3], gradientRotation = 35, targetTransparency = 0}
	}

	for index, config in ipairs(ringConfigs) do
		local ring = Instance.new("Frame")
		ring.Name = "Ring_" .. index
		ring.AnchorPoint = Vector2.new(0.5, 0.5)
		ring.Position = UDim2.fromScale(0.5, 0.5)
		ring.Size = scaleUDim2(spinnerBaseSize, config.scale)
		ring.BackgroundTransparency = 1
		ring.ZIndex = container.ZIndex + index
		ring.Parent = container

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = ring

		local stroke = Instance.new("UIStroke")
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.LineJoinMode = Enum.LineJoinMode.Round
		stroke.Color = config.color
		stroke.Thickness = config.thickness
		stroke.Transparency = 1
		stroke.Parent = ring

		local gradient = Instance.new("UIGradient")
		local accentColor = config.accentColor or config.color
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, lighten(config.color, 0.25)),
			ColorSequenceKeypoint.new(0.45, config.color),
			ColorSequenceKeypoint.new(0.8, accentColor),
			ColorSequenceKeypoint.new(1, lighten(accentColor, 0.4))
		})
		gradient.Rotation = config.gradientRotation or 0
		gradient.Parent = stroke

		table.insert(spinner.layers, {
			gui = ring,
			stroke = stroke,
			speed = config.speed,
			direction = config.direction,
			targetTransparency = config.targetTransparency or 0
		})
	end

	local core = Instance.new("Frame")
	core.Name = "Core"
	core.AnchorPoint = Vector2.new(0.5, 0.5)
	core.Position = UDim2.fromScale(0.5, 0.5)
	core.Size = scaleUDim2(spinnerBaseSize, 0.25)
	core.BackgroundColor3 = Color3.fromRGB(236, 247, 255)
	core.BackgroundTransparency = 1
	core.ZIndex = container.ZIndex + 5
	core.Parent = container

	local coreCorner = Instance.new("UICorner")
	coreCorner.CornerRadius = UDim.new(1, 0)
	coreCorner.Parent = core

	local coreStroke = Instance.new("UIStroke")
	coreStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	coreStroke.Thickness = 1.5
	coreStroke.Color = Color3.fromRGB(186, 220, 255)
	coreStroke.Transparency = 1
	coreStroke.Parent = core

	spinner.container = container
	spinner.core = core
	spinner.coreStroke = coreStroke

	function spinner:SetVisible(isVisible, info)
		local tweenInfo = info or TweenInfo.new(0.35, Enum.EasingStyle.Exponential)
		for _, layer in ipairs(self.layers) do
			local target = isVisible and layer.targetTransparency or 1
			TweenService:Create(layer.stroke, tweenInfo, {Transparency = target}):Play()
		end
		if self.core then
			TweenService:Create(self.core, tweenInfo, {BackgroundTransparency = isVisible and self.coreTransparency or 1}):Play()
		end
		if self.coreStroke then
			TweenService:Create(self.coreStroke, tweenInfo, {Transparency = isVisible and 0.35 or 1}):Play()
		end
	end

	function spinner:Start()
		if self.renderConnection then
			return
		end
		self.renderConnection = RunService.RenderStepped:Connect(function(dt)
			for _, layer in ipairs(self.layers) do
				local delta = dt * layer.speed * layer.direction
				layer.gui.Rotation = (layer.gui.Rotation + delta) % 360
			end
		end)
	end

	function spinner:Stop()
		if self.renderConnection then
			self.renderConnection:Disconnect()
			self.renderConnection = nil
		end
	end

	return spinner
end

local LayeredLoadingSpinner = createLayeredSpinner(LoadingFrame and LoadingFrame.Frame and LoadingFrame.Frame:FindFirstChild("ImageLabel"))
local Tabs = Navigation.Tabs
local Notifications = AurexisUI.Notifications
local KeySystem : Frame = Main.KeySystem

-- local function LoadConfiguration(Configuration, autoload)
-- 	local Data = HttpService:JSONDecode(Configuration)
-- 	local changed
-- 	local notified = false

-- 	-- Iterate through current UI elements' flags
-- 	for FlagName, Flag in pairs(Aurexis.Flags) do
-- 		local FlagValue = Data[FlagName]

-- 		if FlagValue then
-- 			task.spawn(function()
-- 				if Flag.Type == "ColorPicker" then
-- 					changed = true
-- 					Flag:Set(UnpackColor(FlagValue))
-- 				else
-- 					if (Flag.CurrentValue or Flag.CurrentKeybind or Flag.CurrentOption or Flag.Color) ~= FlagValue then 
-- 						changed = true
-- 						Flag:Set(FlagValue) 	
-- 					end
-- 				end
-- 			end)
-- 		else
-- 			notified = true
-- 			Aurexis:Notification({Title = "Config Error", Content = "Aurexis was unable to load or find '"..FlagName.. "'' in the current script. Check ".. website .." for help.", Icon = "flag"})
-- 		end
-- 	end
-- 	if autoload and notified == false then
-- 		Aurexis:Notification({
-- 			Title = "Config Autoloaded",
-- 			Content = "The Configuration Has Been Automatically Loaded. Thank You For Using Aurexis Library",
-- 			Icon = "file-code-2",
-- 			ImageSource = "Lucide"
-- 		})
-- 	elseif notified == false then
-- 		Aurexis:Notification({
-- 			Title = "Config Loaded",
-- 			Content = "The Configuration Has Been Loaded. Thank You For Using Aurexis Library",
-- 			Icon = "file-code-2",
-- 			ImageSource = "Lucide"
-- 		})
-- 	end

-- 	return changed
-- end

-- local function SaveConfiguration(Configuration, ConfigFolder, hasRoot)
-- 	local Data = {}
-- 	for i,v in pairs(Aurexis.Flags) do
-- 		if v.Type == "ColorPicker" then
-- 			Data[i] = PackColor(v.Color)
-- 		else
-- 			Data[i] = v.CurrentValue or v.CurrentBind or v.CurrentOption or v.Color
-- 		end
-- 	end	
-- 	if hasRoot then
-- 		writefile(ConfigurationFolder .. "/" .. hasRoot .. "/" .. ConfigFolder .. "/" .. Configuration .. ConfigurationExtension, tostring(HttpService:JSONEncode(Data)))
-- 	else
-- 		writefile(ConfigurationFolder .. "/" .. "/" .. ConfigFolder .. Configuration .. ConfigurationExtension, tostring(HttpService:JSONEncode(Data)))
-- 	end
-- end

-- local function SetAutoload(ConfigName, ConfigFolder, hasRoot)
-- 	if hasRoot then
-- 		writefile(ConfigurationFolder .. "/" .. hasRoot .. "/" .. ConfigFolder .. "/" .. "autoload.txt", tostring(ConfigName) .. ConfigurationExtension)
-- 	else
-- 		writefile(ConfigurationFolder .. "/" .. "/" .. ConfigFolder .. "autoload.txt", tostring(ConfigName) .. ConfigurationExtension)
-- 	end
-- end

-- local function LoadAutoLoad(ConfigFolder, hasRoot)
-- 	local autoload = isfile(ConfigurationFolder .. "/" .. "/" .. ConfigFolder .. "autoload.txt")
-- 	if hasRoot then
-- 		autoload = isfile(ConfigurationFolder .. "/" .. hasRoot .. "/" .. ConfigFolder .. "/" .. "autoload.txt")
-- 	end

-- 	if autoload then
-- 		if hasRoot then
-- 			LoadConfiguration(readfile(ConfigurationFolder .. "/" .. hasRoot .. "/" .. ConfigFolder .. "/" .. readfile(ConfigurationFolder .. "/" .. hasRoot .. "/" .. ConfigFolder .. "/" .. "autoload.txt")), true)
-- 		else
-- 			LoadConfiguration(readfile(ConfigurationFolder .. "/" .. ConfigFolder .. "/" .. readfile(ConfigurationFolder .. "/" .. ConfigFolder .. "/" .. "autoload.txt")), true)
-- 		end
-- 	end
-- end

local function Draggable(Bar, Window, enableTaptic, tapticOffset)
	pcall(function()
		local Dragging, DragInput, MousePos, FramePos

		local function connectFunctions()
			if dragBar and enableTaptic then
				dragBar.MouseEnter:Connect(function()
					if not Dragging then
						TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5, Size = UDim2.new(0, 120, 0, 4)}):Play()
					end
				end)

				dragBar.MouseLeave:Connect(function()
					if not Dragging then
						TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7, Size = UDim2.new(0, 100, 0, 4)}):Play()
					end
				end)
			end
		end

		connectFunctions()

		Bar.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				MousePos = Input.Position
				FramePos = Window.Position

				if enableTaptic then
					TweenService:Create(dragBarCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 110, 0, 4), BackgroundTransparency = 0}):Play()
				end

				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
						connectFunctions()

						if enableTaptic then
							TweenService:Create(dragBarCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 100, 0, 4), BackgroundTransparency = 0.7}):Play()
						end
					end
				end)
			end
		end)

		Bar.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
				DragInput = Input
			end
		end)

		UserInputService.InputChanged:Connect(function(Input)
			if Input == DragInput and Dragging then
				local Delta = Input.Position - MousePos

				local newMainPosition = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
				TweenService:Create(Window, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = newMainPosition}):Play()

				if dragBar then
					local newDragBarPosition = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y + 240)
					dragBar.Position = newDragBarPosition
				end
			end
		end)

	end)
end

---------------------------------------------------------------- -- Notification START

local NotificationService = requireRemote("src/services/notification.lua")
NotificationService(Aurexis, Kwargify, BlurModule, TweenService, Notifications)


---------------------------------------------------------------- -- Notification END

local function Unhide(Window, currentTab)
	Window.Size = SizeBleh
	Window.Elements.Visible = true
	Window.Visible = true
	task.wait()
	tween(Window, {BackgroundTransparency = 0.2})
	tween(Window.Elements, {BackgroundTransparency = 0.08})
	tween(Window.Line, {BackgroundTransparency = 0})
	tween(Window.Title.Title, {TextTransparency = 0})
	tween(Window.Title.subtitle, {TextTransparency = 0})
	tween(Window.Logo, {ImageTransparency = 0})
	tween(Window.Navigation.Line, {BackgroundTransparency = 0})

	if Window == mainWindowFrame then
		setTopbarVisible(true)
		setMobileInputBlocked(true)
	else
		local controlsContainer = nil
		if typeof(Window) == "Instance" then
			controlsContainer = Window:FindFirstChild("Controls")
		end
		controlsContainer = controlsContainer or (Window and Window.Controls)

		if controlsContainer then
			for _, TopbarButton in ipairs(controlsContainer:GetChildren()) do
				if TopbarButton.ClassName == "Frame" and TopbarButton.Name ~= "Theme" then
					TopbarButton.Visible = true
					tween(TopbarButton, {BackgroundTransparency = 0.25})
					local stroke = TopbarButton:FindFirstChildWhichIsA("UIStroke")
					if stroke then
						tween(stroke, {Transparency = 0.5})
					end
					local icon = TopbarButton:FindFirstChildWhichIsA("ImageButton") or TopbarButton:FindFirstChildWhichIsA("ImageLabel")
					if icon then
						tween(icon, {ImageTransparency = 0.25})
					end
				end
			end
		end
	end
	for _, tabbtn in ipairs(Window.Navigation.Tabs:GetChildren()) do
		if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "InActive Template" then
			local tabStroke = tabbtn:FindFirstChildWhichIsA("UIStroke")
			if tabbtn.Name == currentTab then
				TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				if tabStroke then
					TweenService:Create(tabStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.41}):Play()
				end
			end
			if tabbtn.ImageLabel then
				TweenService:Create(tabbtn.ImageLabel, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
			end
			local dropShadowHolder = tabbtn:FindFirstChild("DropShadowHolder")
			if dropShadowHolder and dropShadowHolder:FindFirstChild("DropShadow") then
				TweenService:Create(dropShadowHolder.DropShadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
			end
		end
	end

end

local MainSize
local MinSize

local function computeWindowSizes()
	local viewportSize = Camera and Camera.ViewportSize or Vector2.new(1280, 720)

	if viewportSize.X > 774 and viewportSize.Y > 503 then
		-- Desktop / larger screens: keep original default window size
		MainSize = UDim2.fromOffset(675, 424)
		MinSize = UDim2.fromOffset(500, 42)
	else
		-- Smaller / mobile screens: use dynamic padding instead of fixed offsets
		local widthPadding = math.clamp(math.floor(viewportSize.X * 0.10), 40, 140)
		local heightPadding = math.clamp(math.floor(viewportSize.Y * 0.14), 40, 140)

		MainSize = UDim2.fromOffset(viewportSize.X - widthPadding, viewportSize.Y - heightPadding)
		MinSize = UDim2.fromOffset(viewportSize.X - math.max(widthPadding * 2.5, 275), 42)
	end
end

computeWindowSizes()

local function Maximise(Window)
	local toggleImageLabel = toggleSizeButton and (toggleSizeButton:FindFirstChildWhichIsA("ImageButton") or toggleSizeButton:FindFirstChildWhichIsA("ImageLabel"))
	if toggleImageLabel then
		toggleImageLabel.Image = "rbxassetid://10137941941"
	end
	tween(Window, {Size = MainSize})
	Window.Elements.Visible = true
	Window.Navigation.Visible = true
end

local function Minimize(Window)
	local toggleImageLabel = toggleSizeButton and (toggleSizeButton:FindFirstChildWhichIsA("ImageButton") or toggleSizeButton:FindFirstChildWhichIsA("ImageLabel"))
	if toggleImageLabel then
		toggleImageLabel.Image = "rbxassetid://11036884234"
	end
	Window.Elements.Visible = false
	Window.Navigation.Visible = false
	tween(Window, {Size = MinSize})
end


function Aurexis:CreateWindow(WindowSettings)

	WindowSettings = Kwargify({
		Name = "AurexisHub UI",
		Subtitle = "Credits: LunaInterfaceSuite",
		LogoID = "84637769762084",
		LoadingEnabled = true,
		LoadingTitle = "Aurexis Interface Library",
		LoadingSubtitle = "by SorinSoftware Services",

		ConfigSettings = {},

		KeySystem = false,
		KeySettings = {},
		ToggleKey = Enum.KeyCode.K
	}, WindowSettings or {})

	WindowSettings.ConfigSettings = Kwargify({
		RootFolder = nil,
		ConfigFolder = "AurexisServiceConfig"
	}, WindowSettings.ConfigSettings or {})

	WindowSettings.KeySettings = Kwargify({
		Title = WindowSettings.Name,
		Subtitle = "Key System",
		Note = "No Instructions",
		SaveInRoot = false, -- Enabling will save the key in your RootFolder (YOU MUST HAVE ONE BEFORE ENABLING THIS OPTION)
		SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
		Key = {""}, -- List of keys that will be accepted by the system, please use a system like Pelican or Luarmor that provide key strings based on your HWID since putting a simple string is very easy to bypass
		SecondAction = {}	
	}, WindowSettings.KeySettings or {})

	WindowSettings.KeySettings.SecondAction = Kwargify({
		Enabled = false,
		Type = "Discord", -- Link/Discord
		Parameter = "" -- for discord, add the invite link like home tab. for link, type the link of ur key sys
	}, WindowSettings.KeySettings.SecondAction)

	local Passthrough = false

	local defaultToggleKey = normalizeKeyCode(WindowSettings.ToggleKey) or Enum.KeyCode.K
	local Window = {
		Bind = defaultToggleKey,
		BindName = keyCodeLabel(defaultToggleKey),
		CurrentTab = nil,
		State = true,
		Size = false,
		Settings = nil
	}

	local function setWindowToggleBind(newBind)
		local resolved = normalizeKeyCode(newBind)
		if not resolved or resolved == Enum.KeyCode.Unknown then
			return false, "Invalid key"
		end
		if resolved == Window.Bind then
			return true, Window.BindName
		end

		Window.Bind = resolved
		Window.BindName = keyCodeLabel(resolved)
		return true, Window.BindName
	end

	function Window:SetToggleBind(newBind)
		return setWindowToggleBind(newBind)
	end

	function Window:GetToggleBind()
		return Window.Bind
	end

	function Window:GetToggleBindName()
		return Window.BindName or keyCodeLabel(Window.Bind)
	end

	Main.Title.Title.Text = WindowSettings.Name
	Main.Title.subtitle.Text = WindowSettings.Subtitle
	Main.Logo.Image = "rbxassetid://" .. WindowSettings.LogoID
	Main.Visible = true
	Main.BackgroundTransparency = 1
	Main.Size = MainSize
	Main.Size = UDim2.fromOffset(Main.Size.X.Offset - 70, Main.Size.Y.Offset - 55)
	Main.Parent.ShadowHolder.Size = Main.Size
	LoadingFrame.Frame.Frame.Title.TextTransparency = 1
	LoadingFrame.Frame.Frame.Subtitle.TextTransparency = 1
	LoadingFrame.Version.TextTransparency = 1
	LoadingFrame.Frame.ImageLabel.ImageTransparency = 1

	tween(Elements.Parent, {BackgroundTransparency = 1})
	Elements.Parent.Visible = false

	LoadingFrame.Frame.Frame.Title.Text = WindowSettings.LoadingTitle
	LoadingFrame.Frame.Frame.Subtitle.Text = WindowSettings.LoadingSubtitle
	LoadingFrame.Version.Text = LoadingFrame.Frame.Frame.Title.Text == "Aurexis Interface Library" and Release or "Aurexis Interface Libary"

	Navigation.Player.icon.ImageLabel.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	Navigation.Player.Namez.Text = Players.LocalPlayer.DisplayName
	Navigation.Player.TextLabel.Text = Players.LocalPlayer.Name

	for i,v in pairs(Main.Controls:GetChildren()) do
		v.Visible = false
	end

	Main:GetPropertyChangedSignal("Position"):Connect(function()
		Main.Parent.ShadowHolder.Position = Main.Position
	end)
	Main:GetPropertyChangedSignal("Size"):Connect(function()
		Main.Parent.ShadowHolder.Size = Main.Size
	end)

	LoadingFrame.Visible = true

	-- pcall(function()
	-- 	if not isfolder(ConfigurationFolder) then
	-- 		makefolder(ConfigurationFolder)
	-- 	end
	-- 	if WindowSettings.ConfigSettings.RootFolder then
	-- 		if not isfolder(ConfigurationFolder .. WindowSettings.ConfigSettings.RootFolder) then
	-- 			makefolder(ConfigurationFolder .. WindowSettings.ConfigSettings.RootFolder)
	-- 			if not isfolder(ConfigurationFolder .. WindowSettings.ConfigSettings.RootFolder .. WindowSettings.ConfigSettings.ConfigFolder) then
	-- 				makefolder(ConfigurationFolder .. WindowSettings.ConfigSettings.RootFolder .. WindowSettings.ConfigSettings.ConfigFolder)
	-- 			end
	-- 		end
	-- 	else
	-- 		if not isfolder(ConfigurationFolder .. WindowSettings.ConfigSettings.ConfigFolder) then
	-- 			makefolder(ConfigurationFolder .. WindowSettings.ConfigSettings.ConfigFolder)
	-- 		end
	-- 	end

	-- 	LoadAutoLoad(WindowSettings.ConfigSettings.ConfigFolder, WindowSettings.ConfigSettings.RootFolder)
	-- end)

	AurexisUI.Enabled = true

	BlurModule(Main)

	if WindowSettings.KeySystem then
		local KeySettings = WindowSettings.KeySettings
		
		Draggable(Dragger, Main)
		Draggable(AurexisUI.MobileSupport, AurexisUI.MobileSupport)
		if dragBar then Draggable(dragInteract, Main, true, 255) end

		if not WindowSettings.KeySettings then
			Passthrough = true
			return
		end
		
		WindowSettings.KeySettings.FileName = "key"

		if typeof(WindowSettings.KeySettings.Key) == "string" then WindowSettings.KeySettings.Key = {WindowSettings.KeySettings.Key} end

		local direc = WindowSettings.KeySettings.SaveInRoot and "Aurexis/Configurations/" .. WindowSettings.ConfigSettings.RootFolder .. "/" .. WindowSettings.ConfigSettings.ConfigFolder .. "/Key System/" or "Aurexis/Configurations/" ..  WindowSettings.ConfigSettings.ConfigFolder .. "/Key System/"

		if isfile and isfile(direc .. WindowSettings.KeySettings.FileName .. ".aurexis") then
			for i, Key in ipairs(WindowSettings.KeySettings.Key) do
				if string.find(readfile(direc .. WindowSettings.KeySettings.FileName .. ".Aurexis"), Key) then
					Passthrough = true
					break
				end
			end
		end

		if not Passthrough then

			local Btn = KeySystem.Action.Copy
			local typesys = KeySettings.SecondAction.Type
			
			if typesys == "Discord" then
				Btn = KeySystem.Action.Discord
			end

			local AttemptsRemaining = math.random(2, 5)

			KeySystem.Visible = true
			KeySystem.Title.Text = WindowSettings.KeySettings.Title
			KeySystem.Subtitle.Text = WindowSettings.KeySettings.Subtitle
			KeySystem.textshit.Text = WindowSettings.KeySettings.Note

			if KeySettings.SecondAction.Enabled == true then
				Btn.Visible = true
			end
			
			Btn.Interact.MouseButton1Click:Connect(function()
				if typesys == "Discord" then
					setclipboard(tostring("https://discord.gg/"..KeySettings.SecondAction.Parameter)) -- Hunter if you see this I added copy also was too lazy to send u msg
					if request then
						request({
							Url = 'http://127.0.0.1:6463/rpc?v=1',
							Method = 'POST',
							Headers = {
								['Content-Type'] = 'application/json',
								Origin = 'https://discord.com'
							},
							Body = HttpService:JSONEncode({
								cmd = 'INVITE_BROWSER',
								nonce = HttpService:GenerateGUID(false),
								args = {code = KeySettings.SecondAction.Parameter}
							})
						})
					end
				else
					setclipboard(tostring(KeySettings.SecondAction.Parameter))
				end
			end)

			KeySystem.Action.Submit.Interact.MouseButton1Click:Connect(function()
				if #KeySystem.Input.InputBox.Text == 0 then return end
				local KeyFound = false
				local FoundKey = ''
				for _, Key in ipairs(WindowSettings.KeySettings.Key) do
					if KeySystem.Input.InputBox.Text == Key then
						KeyFound = true
						FoundKey = Key
						break
					end
				end
				if KeyFound then 
					for _, instance in pairs(KeySystem:GetDescendants()) do
						if instance.ClassName ~= "UICorner" and instance.ClassName ~= "UIPadding" then
							if instance.ClassName ~= "UIStroke" and instance.ClassName ~= "UIListLayout" then
								tween(instance, {BackgroundTransparency = 1}, nil,TweenInfo.new(0.6, Enum.EasingStyle.Exponential))
							end
							if instance.ClassName == "ImageButton" then
								tween(instance, {ImageTransparency = 1}, nil,TweenInfo.new(0.5, Enum.EasingStyle.Exponential))
							end
							if instance.ClassName == "TextLabel" then
								tween(instance, {TextTransparency = 1}, nil,TweenInfo.new(0.4, Enum.EasingStyle.Exponential))
							end
							if instance.ClassName == "UIStroke" then
								tween(instance, {Transparency = 1}, nil,TweenInfo.new(0.5, Enum.EasingStyle.Exponential))
							end
						end
					end
					tween(KeySystem, {BackgroundTransparency = 1}, nil,TweenInfo.new(0.6, Enum.EasingStyle.Exponential))
					task.wait(0.51)
					Passthrough = true
					KeySystem.Visible = false
					if WindowSettings.KeySettings.SaveKey then
						if writefile then
							writefile(direc .. WindowSettings.KeySettings.FileName .. ".Aurexis", FoundKey)
						end
						Aurexis:Notification({Title = "Key System", Content = "The key for this script has been saved successfully.", Icon = "lock_open"})
					end
				else
					if AttemptsRemaining == 0 then

						game.Players.LocalPlayer:Kick("No Attempts Remaining")
						game:Shutdown()
					end
					KeySystem.Input.InputBox.Text = "Incorrect Key"
					AttemptsRemaining = AttemptsRemaining - 1
					task.wait(0.4)
					KeySystem.Input.InputBox.Text = ""
				end
			end)

			KeySystem.Close.MouseButton1Click:Connect(function()
				
				Aurexis:Destroy()
			end)
		end
	end

	if WindowSettings.KeySystem then
		repeat task.wait() until Passthrough
	end

	if WindowSettings.LoadingEnabled then
		task.wait(0.3)
		local fadeTween = TweenInfo.new(0.35, Enum.EasingStyle.Exponential)
		TweenService:Create(LoadingFrame.Frame.Frame.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		TweenService:Create(LoadingFrame.Version, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		if LayeredLoadingSpinner then
			LayeredLoadingSpinner:SetVisible(true, fadeTween)
			LayeredLoadingSpinner:Start()
		else
			TweenService:Create(LoadingFrame.Frame.ImageLabel, fadeTween, {ImageTransparency = 0}):Play()
			TweenService:Create(LoadingFrame.Frame.ImageLabel, TweenInfo.new(1.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 2, false, 0.2), {Rotation = 450}):Play()
		end
		task.wait(0.05)
		TweenService:Create(LoadingFrame.Frame.Frame.Subtitle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

		task.wait(3.32)

		TweenService:Create(LoadingFrame.Frame.Frame.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
		if LayeredLoadingSpinner then
			LayeredLoadingSpinner:SetVisible(false, fadeTween)
		else
			TweenService:Create(LoadingFrame.Frame.ImageLabel, fadeTween, {ImageTransparency = 1}):Play()
		end
		task.wait(0.05)
		TweenService:Create(LoadingFrame.Frame.Frame.Subtitle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
		TweenService:Create(LoadingFrame.Version, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
		if LayeredLoadingSpinner then
			LayeredLoadingSpinner:Stop()
		end
		wait(0.3)
		TweenService:Create(LoadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
	end

	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2, Size = MainSize}):Play()
	TweenService:Create(Main.Parent.ShadowHolder, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = MainSize}):Play()
	TweenService:Create(Main.Title.Title, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
	TweenService:Create(Main.Title.subtitle, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
	TweenService:Create(Main.Logo, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
	TweenService:Create(Navigation.Player.icon.ImageLabel, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
	local navIconStroke = Navigation.Player.icon:FindFirstChildWhichIsA("UIStroke")
	if navIconStroke then
		TweenService:Create(navIconStroke, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = 0}):Play()
	end
	TweenService:Create(Main.Line, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
	wait(0.4)
	LoadingFrame.Visible = false

	Draggable(Dragger, Main)
	Draggable(AurexisUI.MobileSupport, AurexisUI.MobileSupport)
	if dragBar then Draggable(dragInteract, Main, true, 255) end

	-- Recalculate window size when orientation / viewport changes
	local function updateWindowSizeForViewport()
		computeWindowSizes()
		if Window.Size then
			-- minimized
			Main.Size = MinSize
		else
			Main.Size = MainSize
		end
		Main.Parent.ShadowHolder.Size = Main.Size
	end

	if Camera then
		Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateWindowSizeForViewport)
	end

	-- Block camera movement on mobile while main window is open
	setMobileInputBlocked(true)

	Elements.Template.LayoutOrder = 1000000000
	Elements.Template.Visible = false
	Navigation.Tabs["InActive Template"].LayoutOrder = 1000000000
	Navigation.Tabs["InActive Template"].Visible = false

	local FirstTab = true

---------------------------------------------------------------- -- HomeTab START
	
-- HomeTab laden und registrieren
local HomeTabModule = requireRemote("src/components/home-tab.lua")
local attachSectionControls = requireRemote("src/components/section-controls.lua")
local attachTabControls = requireRemote("src/components/tab-controls.lua")

local function tryLoadHomeTabFromUrl(url)
	local ok, body = pcall(function()
		return game:HttpGet(url)
	end)
	if not ok then
		return nil, "HttpGet failed: " .. tostring(body)
	end
	local fn, lerr = loadstring(body)
	if not fn then
		return nil, "loadstring failed: " .. tostring(lerr)
	end
	local ok2, res = pcall(fn)
	if not ok2 then
		return nil, "module pcall failed: " .. tostring(res)
	end
	return res
end

local function attachHomeTab()
	local module = HomeTabModule
	if type(module) ~= "function" then
		local altUrl = "https://raw.githubusercontent.com/SorinSoftware-Services/AurexisInterfaceLibrary/Developer/src/components/home-tab.lua"
		local alt, err = tryLoadHomeTabFromUrl(altUrl)
		if type(alt) == "function" then
			module = alt
		else
			warn("[Aurexis] HomeTab fallback failed:", err)
		end
	end

	if type(module) == "function" then
		local ok, err = pcall(module, Window, Aurexis, Elements, Navigation, GetIcon, Kwargify, tween, Release, isStudio)
		if not ok then
			warn("[Aurexis] HomeTab module failed to load:", err)
		end
	end
end

attachHomeTab()

-- HomeTab jetzt ERSTELLEN (sonst bleibt alles leer)
local function createHomeTabStub(self, settings)
	attachHomeTab()
	if type(self.CreateHomeTab) == "function" and self.CreateHomeTab ~= createHomeTabStub then
		return self:CreateHomeTab(settings)
	end
	warn("[Aurexis] CreateHomeTab missing - Home tab skipped.")
end

if type(Window.CreateHomeTab) ~= "function" then
	Window.CreateHomeTab = createHomeTabStub
end

Window:CreateHomeTab()

FirstTab = false

---------------------------------------------------------------- -- HomeTab END
-- Stolen From Sirius Stuff ends here

	function Window:CreateTab(TabSettings)

		local Tab = {}

		TabSettings = Kwargify({
			Name = "Tab",
			ShowTitle = true,
			Icon = "view_in_ar",
			ImageSource = "Material" 
		}, TabSettings or {})

		local TabButton = Navigation.Tabs["InActive Template"]:Clone()

		TabButton.Name = TabSettings.Name
		TabButton.TextLabel.Text = TabSettings.Name
		TabButton.Parent = Navigation.Tabs
		TabButton.ImageLabel.Image = Aurexis:GetIcon(TabSettings.Icon, TabSettings.ImageSource)

		TabButton.Visible = true

		local TabPage = Elements.Template:Clone()
		TabPage.Name = TabSettings.Name
		TabPage.Title.Visible = TabSettings.ShowTitle
		TabPage.Title.Text = TabSettings.Name
		TabPage.Visible = true

		Tab.Page = TabPage

		if TabSettings.ShowTitle == false then
			TabPage.UIPadding.PaddingTop = UDim.new(0,10)
		end

		TabPage.LayoutOrder = #Elements:GetChildren() - 3

		for _, TemplateElement in ipairs(TabPage:GetChildren()) do
			if TemplateElement.ClassName == "Frame" or TemplateElement.ClassName == "TextLabel" and TemplateElement.Name ~= "Title" then
				TemplateElement:Destroy()
			end
		end
		TabPage.Parent = Elements

		function Tab:Activate()
			if TabButton.ImageLabel then
				tween(TabButton.ImageLabel, {ImageColor3 = Color3.fromRGB(255,255,255)})
			end
			tween(TabButton, {BackgroundTransparency = 0})
			local buttonStroke = TabButton:FindFirstChildWhichIsA("UIStroke")
			if buttonStroke then
				tween(buttonStroke, {Transparency = 0.41})
			end

			Elements.UIPageLayout:JumpTo(TabPage)

			task.wait(0.05)

			for _, OtherTabButton in ipairs(Navigation.Tabs:GetChildren()) do
				if OtherTabButton.Name ~= "InActive Template" and OtherTabButton.ClassName == "Frame" and OtherTabButton ~= TabButton then
					if OtherTabButton.ImageLabel then
						tween(OtherTabButton.ImageLabel, {ImageColor3 = Color3.fromRGB(221,221,221)})
					end
					tween(OtherTabButton, {BackgroundTransparency = 1})
					local otherStroke = OtherTabButton:FindFirstChildWhichIsA("UIStroke")
					if otherStroke then
						tween(otherStroke, {Transparency = 1})
					end
				end

			end

			Window.CurrentTab = TabSettings.Name
		end

		if FirstTab then
			Tab:Activate()
		end

		task.wait(0.01)

		TabButton.Interact.MouseButton1Click:Connect(function()
			if closeDialogState and closeDialogState.host then
				return
			end
			Tab:Activate()
		end)

		FirstTab = false

		-- Section
		function Tab:CreateSection(name : string)

			local Section = {}

			if name == nil then name = "Section" end

			Section.Name = name

			local Sectiont = Elements.Template.Section:Clone()
			Sectiont.Text = name
			Sectiont.Visible = true
			Sectiont.Parent = TabPage
			local TabPage = Sectiont.Frame

			Sectiont.TextTransparency = 1
			tween(Sectiont, {TextTransparency = 0})

			function Section:Set(NewSection)
				Sectiont.Text = NewSection
			end

			function Section:Destroy()
				Sectiont:Destroy()
			end

			attachSectionControls({
				Section = Section,
				TabPage = TabPage,
				Elements = Elements,
				TweenService = TweenService,
				RunService = RunService,
				UserInputService = UserInputService,
				Kwargify = Kwargify,
				RemoveTable = RemoveTable,
				unpackt = unpackt,
				Aurexis = Aurexis,
				AurexisUI = AurexisUI,
				Window = Window,
				tween = tween,
				Players = Players,
			})

			return Section

		end

		attachTabControls({
			Tab = Tab,
			TabPage = TabPage,
			Elements = Elements,
			TweenService = TweenService,
			RunService = RunService,
			UserInputService = UserInputService,
			Kwargify = Kwargify,
			RemoveTable = RemoveTable,
			unpackt = unpackt,
			Aurexis = Aurexis,
			AurexisUI = AurexisUI,
			Window = Window,
			tween = tween,
			Players = Players,
			WindowSettings = WindowSettings,
			PresetGradients = PresetGradients,
			HttpService = HttpService,
			isStudio = isStudio,
		})

		return Tab
	end


	Elements.Parent.Visible = true
	tween(Elements.Parent, {BackgroundTransparency = 0.1})
	Navigation.Visible = true
	tween(Navigation.Line, {BackgroundTransparency = 0})

	setTopbarVisible(true)

	local function getTopbarIcon(container)
		if not container then
			return nil
		end
		return container:FindFirstChildWhichIsA("ImageButton") or container:FindFirstChildWhichIsA("ImageLabel")
	end

	local function collapseWindow(showNotification)
		Hide(Main, Window.Bind, showNotification)
		if dragBar then
			dragBar.Visible = false
		end
		Window.State = false
		if UserInputService.KeyboardEnabled == false then
			AurexisUI.MobileSupport.Visible = true
		end
	end

	closeDialogState = {
		host = nil,
		dialog = nil,
		targetSize = nil,
		scrollers = {},
	}

	local function getMainCornerRadius()
		local defaultRadius = UDim.new(0, 12)
		if Main then
			local mainCorner = Main:FindFirstChildWhichIsA("UICorner")
			if mainCorner then
				return mainCorner.CornerRadius
			end
		end
		return defaultRadius
	end

	local function applyRoundedCorner(target)
		local corner = Instance.new("UICorner")
		corner.CornerRadius = getMainCornerRadius()
		corner.Parent = target
		return corner
	end

	local function teardownCloseDialog()
		if closeDialogState.scrollers then
			for scroller, state in pairs(closeDialogState.scrollers) do
				if scroller and scroller.Parent then
					if scroller:IsA("ScrollingFrame") then
						scroller.ScrollingEnabled = state
					elseif scroller:IsA("UIPageLayout") and type(state) == "table" then
						if state.ScrollWheelInputEnabled ~= nil then
							pcall(function() scroller.ScrollWheelInputEnabled = state.ScrollWheelInputEnabled end)
						end
						if state.SwipeEnabled ~= nil then
							pcall(function() scroller.SwipeEnabled = state.SwipeEnabled end)
						end
					end
				end
			end
		end
		if closeDialogState.host then
			closeDialogState.host:Destroy()
		end
		closeDialogState = {host = nil, dialog = nil, targetSize = nil, scrollers = {}}
	end

	local function buildCloseDialog()
		local container = Main or Elements
		if not container then
			return nil, nil
		end

		teardownCloseDialog()

		local scrollers = {}
		for _, descendant in ipairs(container:GetDescendants()) do
			if descendant:IsA("ScrollingFrame") then
				scrollers[descendant] = descendant.ScrollingEnabled
				descendant.ScrollingEnabled = false
			end
		end

		if Elements and Elements.UIPageLayout then
			local pageLayout = Elements.UIPageLayout
			local originalStates = {}

			local s_sw, r_sw = pcall(function() return pageLayout.ScrollWheelInputEnabled end)
			if s_sw then
				originalStates.ScrollWheelInputEnabled = r_sw
				pcall(function() pageLayout.ScrollWheelInputEnabled = false end)
			end

			local s_se, r_se = pcall(function() return pageLayout.SwipeEnabled end)
			if s_se then
				originalStates.SwipeEnabled = r_se
				pcall(function() pageLayout.SwipeEnabled = false end)
			end

			scrollers[pageLayout] = originalStates
		end

		local host = Instance.new("Frame")
		host.Name = "CloseDialogHost"
		host.BackgroundColor3 = Color3.fromRGB(6, 8, 14)
		host.BackgroundTransparency = 1
		host.BorderSizePixel = 0
		host.Size = UDim2.fromScale(1, 1)
		host.Position = UDim2.fromScale(0, 0)
		host.ZIndex = 250
		host.Active = true
		host.ClipsDescendants = true
		host.Parent = container
		applyRoundedCorner(host)

		local scrim = Instance.new("UIGradient")
		scrim.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 20, 30)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 8, 14)),
		}
		scrim.Transparency = NumberSequence.new{
			NumberSequenceKeypoint.new(0, 0.08),
			NumberSequenceKeypoint.new(1, 0.2),
		}
		scrim.Rotation = 90
		scrim.Parent = host

		local grain = Instance.new("ImageLabel")
		grain.Name = "OverlayNoise"
		grain.BackgroundTransparency = 1
		grain.AnchorPoint = Vector2.new(0.5, 0.5)
		grain.Position = UDim2.fromScale(0.5, 0.5)
		grain.Size = UDim2.new(1.04, 0, 1.04, 0)
		grain.Image = "rbxassetid://13160452170"
		grain.ImageColor3 = Color3.fromRGB(12, 16, 24)
		grain.ImageTransparency = 0.77
		grain.ScaleType = Enum.ScaleType.Slice
		grain.SliceCenter = Rect.new(60, 60, 60, 60)
		grain.ZIndex = host.ZIndex + 1
		grain.Parent = host

		local vignette = Instance.new("ImageLabel")
		vignette.Name = "Backdrop"
		vignette.BackgroundTransparency = 1
		vignette.AnchorPoint = Vector2.new(0.5, 0.5)
		vignette.Position = UDim2.fromScale(0.5, 0.5)
		vignette.Size = UDim2.new(1.08, 0, 1.08, 0)
		vignette.Image = "rbxassetid://13160452170"
		vignette.ImageColor3 = Color3.fromRGB(10, 14, 22)
		vignette.ImageTransparency = 0.94
		vignette.ScaleType = Enum.ScaleType.Slice
		vignette.SliceCenter = Rect.new(60, 60, 60, 60)
		vignette.ZIndex = host.ZIndex + 1
		vignette.Parent = host

		local dialogWidth = 420
		if Main then
			dialogWidth = math.clamp(Main.AbsoluteSize.X - 140, 320, 520)
		end

		local dialog = Instance.new("Frame")
		dialog.Name = "Dialog"
		dialog.AnchorPoint = Vector2.new(0.5, 0.5)
		dialog.Position = UDim2.fromScale(0.5, 0.5)
		dialog.Size = UDim2.fromOffset(dialogWidth - 20, 204)
		dialog.BackgroundColor3 = Main and Main.BackgroundColor3 or Color3.fromRGB(20, 24, 32)
		dialog.BackgroundTransparency = 0.22
		dialog.BorderSizePixel = 0
		dialog.ZIndex = host.ZIndex + 2
		dialog.ClipsDescendants = true
		dialog.Parent = host
		applyRoundedCorner(dialog)

		local dialogGradient = Instance.new("UIGradient")
		dialogGradient.Color = Aurexis.ThemeGradient
		dialogGradient.Rotation = 125
		dialogGradient.Transparency = NumberSequence.new{
			NumberSequenceKeypoint.new(0, 0.82),
			NumberSequenceKeypoint.new(0.5, 0.9),
			NumberSequenceKeypoint.new(1, 0.82),
		}
		dialogGradient.Parent = dialog

		local padding = Instance.new("UIPadding")
		padding.PaddingTop = UDim.new(0, 22)
		padding.PaddingBottom = UDim.new(0, 22)
		padding.PaddingLeft = UDim.new(0, 22)
		padding.PaddingRight = UDim.new(0, 22)
		padding.Parent = dialog

		local title = Instance.new("TextLabel")
		title.Name = "Title"
		title.BackgroundTransparency = 1
		title.Size = UDim2.new(1, 0, 0, 30)
		title.Font = Enum.Font.GothamBold
		title.Text = "Close window?"
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
		title.TextSize = 20
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.TextTransparency = 0
		title.ZIndex = dialog.ZIndex + 1
		title.Parent = dialog

		local message = Instance.new("TextLabel")
		message.Name = "Message"
		message.BackgroundTransparency = 1
		message.Position = UDim2.new(0, 0, 0, 34)
		message.Size = UDim2.new(1, 0, 0, 64)
		message.Font = Enum.Font.Gotham
		message.Text = "Are you sure you want to close this window?"
		message.TextColor3 = Color3.fromRGB(220, 224, 232)
		message.TextSize = 15
		message.TextWrapped = true
		message.TextXAlignment = Enum.TextXAlignment.Left
		message.TextYAlignment = Enum.TextYAlignment.Top
		message.TextTransparency = 0
		message.ZIndex = dialog.ZIndex + 1
		message.Parent = dialog

		local buttonRow = Instance.new("Frame")
		buttonRow.Name = "Buttons"
		buttonRow.AnchorPoint = Vector2.new(0.5, 1)
		buttonRow.BackgroundTransparency = 1
		buttonRow.Position = UDim2.new(0.5, 0, 1, -8)
		buttonRow.Size = UDim2.new(1, 0, 0, 52)
		buttonRow.ZIndex = dialog.ZIndex + 1
		buttonRow.Parent = dialog

		local buttonLayout = Instance.new("UIListLayout")
		buttonLayout.FillDirection = Enum.FillDirection.Horizontal
		buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
		buttonLayout.Padding = UDim.new(0, 10)
		buttonLayout.Parent = buttonRow

		local function makeButton(name, text, primary)
			local btn = Instance.new("TextButton")
			btn.Name = name
			btn.AutoButtonColor = false
			btn.BackgroundColor3 = primary and Color3.fromRGB(70, 98, 255) or Color3.fromRGB(32, 36, 46)
			btn.BackgroundTransparency = primary and 0 or 0.2
			btn.BorderSizePixel = 0
			btn.Size = UDim2.new(0.5, -5, 1, 0)
			btn.Font = Enum.Font.GothamMedium
			btn.Text = text
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.TextSize = 16
			btn.TextTransparency = 0
			btn.ZIndex = dialog.ZIndex + 1
			btn.Parent = buttonRow

			applyRoundedCorner(btn)

			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(90, 110, 150)
			stroke.Transparency = primary and 0.32 or 0.2
			stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			stroke.Parent = btn

			if primary then
				local grad = Instance.new("UIGradient")
				grad.Color = Aurexis.ThemeGradient
				grad.Rotation = 20
				grad.Transparency = NumberSequence.new{
					NumberSequenceKeypoint.new(0, 0.05),
					NumberSequenceKeypoint.new(1, 0.25),
				}
				grad.Parent = btn
			end

			return btn
		end

		local cancelButton = makeButton("Cancel", "Cancel", false)
		cancelButton.LayoutOrder = 1

		local confirmButton = makeButton("Confirm", "Close", true)
		confirmButton.LayoutOrder = 2

		cancelButton.MouseButton1Click:Connect(function()
			teardownCloseDialog()
		end)

		confirmButton.MouseButton1Click:Connect(function()
			teardownCloseDialog()
			Window.State = true
			if dragBar then
				dragBar.Visible = false
			end
			setMobileInputBlocked(false)
			Aurexis:Destroy()
		end)

		local targetSize = UDim2.fromOffset(dialogWidth, 220)

		closeDialogState = {
			host = host,
			dialog = dialog,
			targetSize = targetSize,
			scrollers = scrollers,
		}

		return host, dialog
	end

	local function showCloseConfirmation()
		local host, dialog = buildCloseDialog()
		if not (host and dialog) then
			return
		end

		local targetSize = closeDialogState.targetSize or dialog.Size

		tween(host, {BackgroundTransparency = 0.05})
		tween(dialog, {Size = targetSize, BackgroundTransparency = 0.05})
	end

	local minimizeIcon = getTopbarIcon(minimizeButton)
	if minimizeButton and minimizeIcon then
		minimizeIcon.MouseButton1Click:Connect(function()
			collapseWindow(true)
		end)
		minimizeButton.MouseEnter:Connect(function()
			tween(minimizeIcon, {ImageColor3 = Color3.new(1, 1, 1)})
		end)
		minimizeButton.MouseLeave:Connect(function()
			tween(minimizeIcon, {ImageColor3 = Color3.fromRGB(195, 195, 195)})
		end)
	end

	local closeIcon = getTopbarIcon(closeButton)
	if closeButton and closeIcon then
		closeIcon.MouseButton1Click:Connect(function()
			showCloseConfirmation()
		end)
		closeButton.MouseEnter:Connect(function()
			tween(closeIcon, {ImageColor3 = Color3.new(1, 1, 1)})
		end)
		closeButton.MouseLeave:Connect(function()
			tween(closeIcon, {ImageColor3 = Color3.fromRGB(195, 195, 195)})
		end)
	end

	UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if Window.State then return end
		if input.KeyCode == Window.Bind then
			Unhide(Main, Window.CurrentTab)
			AurexisUI.MobileSupport.Visible = false
			dragBar.Visible = true
			Window.State = true
		end
	end)

	Main.Logo.MouseButton1Click:Connect(function()
		if Navigation.Size.X.Offset == 205 then
			tween(Elements.Parent, {Size = UDim2.new(1, -55, Elements.Parent.Size.Y.Scale, Elements.Parent.Size.Y.Offset)})
			tween(Navigation, {Size = UDim2.new(Navigation.Size.X.Scale, 55, Navigation.Size.Y.Scale, Navigation.Size.Y.Offset)})
		else
			tween(Elements.Parent, {Size = UDim2.new(1, -205, Elements.Parent.Size.Y.Scale, Elements.Parent.Size.Y.Offset)})
			tween(Navigation, {Size = UDim2.new(Navigation.Size.X.Scale, 205, Navigation.Size.Y.Scale, Navigation.Size.Y.Offset)})
		end
	end)

	local toggleSizeIcon = toggleSizeButton and (toggleSizeButton:FindFirstChildWhichIsA("ImageButton") or toggleSizeButton:FindFirstChildWhichIsA("ImageLabel"))
	if toggleSizeIcon then
		toggleSizeIcon.MouseButton1Click:Connect(function()
			Window.Size = not Window.Size
			if Window.Size then
				Minimize(Main)
				if dragBar then
					dragBar.Visible = false
				end
			else
				Maximise(Main)
				if dragBar then
					dragBar.Visible = true
				end
			end
		end)
	end
	if toggleSizeButton and toggleSizeIcon then
		toggleSizeButton.MouseEnter:Connect(function()
			tween(toggleSizeIcon, {ImageColor3 = Color3.new(1,1,1)})
		end)
		toggleSizeButton.MouseLeave:Connect(function()
			tween(toggleSizeIcon, {ImageColor3 = Color3.fromRGB(195,195,195)})
		end)
	end

	Main.Controls.Theme.ImageLabel.MouseButton1Click:Connect(function()
		if Window.Settings then
			Window.Settings:Activate()
			Elements.Settings.CanvasPosition = Vector2.new(0,698)
		end
	end)
	Main.Controls.Theme["MouseEnter"]:Connect(function()
		tween(Main.Controls.Theme.ImageLabel, {ImageColor3 = Color3.new(1,1,1)})
	end)
	Main.Controls.Theme["MouseLeave"]:Connect(function()
		tween(Main.Controls.Theme.ImageLabel, {ImageColor3 = Color3.fromRGB(195,195,195)})
	end)	


	AurexisUI.MobileSupport.Interact.MouseButton1Click:Connect(function()
		Unhide(Main, Window.CurrentTab)
		dragBar.Visible = true
		Window.State = true
		AurexisUI.MobileSupport.Visible = false
	end)

	return Window
end

Aurexis.SetEnvironmentBlurEnabled = function(self, enabled)
	enabled = not not enabled
	if Aurexis.AllowEnvironmentBlur == enabled then
		return enabled
	end

	Aurexis.AllowEnvironmentBlur = enabled

	if not enabled then
		if sharedDepthOfField then
			sharedDepthOfField.Enabled = false
			if sharedDepthOfField.Parent == Lighting then
				sharedDepthOfField.Parent = nil
			end
			sharedDepthOfField = nil
		end
		local existing = Lighting:FindFirstChild("AurexisDepthOfField")
		if existing then
			existing.Enabled = false
			existing:Destroy()
		end
		local toCleanup = {}
		for guiObject in pairs(blurBindings) do
			table.insert(toCleanup, guiObject)
		end
		for _, guiObject in ipairs(toCleanup) do
			if guiObject then
				cleanupBlur(guiObject)
			end
		end
	else
		local effect = ensureDepthOfField()
		if effect then
			effect.Enabled = activeBlurCount > 0
		end
		for guiObject in pairs(blurTargets) do
			if guiObject and guiObject.Parent then
				ensureGuiBlur(guiObject)
			end
		end
	end

	return enabled
end

Aurexis.GetEnvironmentBlurEnabled = function()
	return Aurexis.AllowEnvironmentBlur
end

Aurexis:SetEnvironmentBlurEnabled(Aurexis.AllowEnvironmentBlur)

function Aurexis:Destroy()
    Main.Visible = false
    for _, Notification in ipairs(Notifications:GetChildren()) do
        if Notification.ClassName == "Frame" then
            Notification.Visible = false
            Notification:Destroy()
        end
    end
    topbarButtons = {}
    topbarDecorations = {}
    AurexisUI:Destroy()
end


return Aurexis
