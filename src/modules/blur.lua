local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local blurBindings = {}
local blurStepCounter = 0

local compatibilityPlaces = {
	[16389395869] = true, -- a dusty trip
}

local compatibilityUniverses = {
	[5650396773] = true, -- a dusty trip universe
}

local function shouldUseCompatibilityMode()
	return compatibilityPlaces[game.PlaceId] or compatibilityUniverses[game.GameId] or false
end

local function nextBlurStepId()
	blurStepCounter += 1
	return "aurexis-blur::" .. tostring(blurStepCounter)
end

local function cleanupBlurBinding(blurFrame)
	local binding = blurBindings[blurFrame]
	if not binding then
		return
	end

	blurBindings[blurFrame] = nil

	if binding.stepId then
		pcall(function()
			RunService:UnbindFromRenderStep(binding.stepId)
		end)
	end

	for _, conn in ipairs(binding.connections or {}) do
		conn:Disconnect()
	end

	for _, part in ipairs(binding.parts or {}) do
		if part then
			part:Destroy()
		end
	end

	if binding.folder then
		binding.folder:Destroy()
	end

	if binding.frame then
		binding.frame:Destroy()
	end
end

local function createBlur(Frame)
	if not Frame then
		return
	end

	local existing = Frame:FindFirstChild("AurexisBlurFrame")
	if existing then
		if blurBindings[existing] then
			return blurBindings[existing].parts
		end
		existing:Destroy()
	end

	local blurFrame = Instance.new("Frame")
	blurFrame.Name = "AurexisBlurFrame"
	blurFrame.BackgroundTransparency = 1
	blurFrame.Size = UDim2.new(0.95, 0, 0.95, 0)
	blurFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	blurFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	blurFrame.ZIndex = Frame.ZIndex + 1
	blurFrame.Parent = Frame

	local binding = {
		parent = Frame,
		frame = blurFrame,
		parts = {},
		connections = {}
	}
	blurBindings[blurFrame] = binding

	local function attachBaseCleanup()
		table.insert(binding.connections, blurFrame.AncestryChanged:Connect(function(_, parent)
			if not parent then
				cleanupBlurBinding(blurFrame)
			end
		end))

		if Frame.Destroying then
			table.insert(binding.connections, Frame.Destroying:Connect(function()
				cleanupBlurBinding(blurFrame)
			end))
		end

		if blurFrame.Destroying then
			table.insert(binding.connections, blurFrame.Destroying:Connect(function()
				cleanupBlurBinding(blurFrame)
			end))
		end
	end

	attachBaseCleanup()

	if shouldUseCompatibilityMode() then
		blurFrame:SetAttribute("AurexisBlurCompatibility", true)

		local fallback = Instance.new("ImageLabel")
		fallback.Name = "AurexisBlurFallback"
		fallback.AnchorPoint = Vector2.new(0.5, 0.5)
		fallback.Position = UDim2.new(0.5, 0, 0.5, 0)
		fallback.Size = UDim2.new(1.08, 0, 1.08, 0)
		fallback.BackgroundTransparency = 1
		fallback.Image = "rbxassetid://13160452170"
		fallback.ImageColor3 = Color3.fromRGB(25, 25, 32)
		fallback.ImageTransparency = 0.82
		fallback.ScaleType = Enum.ScaleType.Slice
		fallback.SliceCenter = Rect.new(60, 60, 60, 60)
		fallback.ZIndex = blurFrame.ZIndex - 1
		fallback.Parent = blurFrame

		table.insert(binding.connections, blurFrame:GetPropertyChangedSignal("ZIndex"):Connect(function()
			if fallback.Parent then
				fallback.ZIndex = blurFrame.ZIndex - 1
			end
		end))

		return binding.parts
	end

	local root = Instance.new("Folder")
	root.Name = "AurexisBlur_" .. HttpService:GenerateGUID(false)
	root.Parent = workspace.CurrentCamera or workspace
	binding.folder = root

	local currentCamera = workspace.CurrentCamera

	local function ensureRootParent()
		if not blurBindings[blurFrame] then
			return
		end

		local cam = workspace.CurrentCamera
		if cam then
			currentCamera = cam
			if root.Parent ~= cam then
				root.Parent = cam
			end
		end
	end

	ensureRootParent()

	local MTREL = "Glass"

	do
		local function IsNotNaN(x)
			return x == x
		end
		local valid = currentCamera and IsNotNaN(currentCamera:ScreenPointToRay(0, 0).Origin.x)
		while not valid do
			RunService.RenderStepped:Wait()
			ensureRootParent()
			if currentCamera then
				valid = IsNotNaN(currentCamera:ScreenPointToRay(0, 0).Origin.x)
			end
		end
	end

	local DrawQuad; do

		local acos, max, pi, sqrt = math.acos, math.max, math.pi, math.sqrt
		local sz = 0.22
		local function DrawTriangle(v1, v2, v3, p0, p1)

			local s1 = (v1 - v2).magnitude
			local s2 = (v2 - v3).magnitude
			local s3 = (v3 - v1).magnitude
			local smax = max(s1, s2, s3)
			local A, B, C
			if s1 == smax then
				A, B, C = v1, v2, v3
			elseif s2 == smax then
				A, B, C = v2, v3, v1
			elseif s3 == smax then
				A, B, C = v3, v1, v2
			end

			local para = ((B - A).x * (C - A).x + (B - A).y * (C - A).y + (B - A).z * (C - A).z) / (A - B).magnitude
			local perp = sqrt((C - A).magnitude ^ 2 - para * para)
			local dif_para = (A - B).magnitude - para

			local st = CFrame.new(B, A)
			local za = CFrame.Angles(pi / 2, 0, 0)

			local cf0 = st

			local Top_Look = (cf0 * za).lookVector
			local Mid_Point = A + CFrame.new(A, B).lookVector * para
			local Needed_Look = CFrame.new(Mid_Point, C).lookVector
			local dot = Top_Look.x * Needed_Look.x + Top_Look.y * Needed_Look.y + Top_Look.z * Needed_Look.z

			local ac = CFrame.Angles(0, 0, acos(dot))

			cf0 = cf0 * ac
			if ((cf0 * za).lookVector - Needed_Look).magnitude > 0.01 then
				cf0 = cf0 * CFrame.Angles(0, 0, -2 * acos(dot))
			end
			cf0 = cf0 * CFrame.new(0, perp / 2, -(dif_para + para / 2))

			local cf1 = st * ac * CFrame.Angles(0, pi, 0)
			if ((cf1 * za).lookVector - Needed_Look).magnitude > 0.01 then
				cf1 = cf1 * CFrame.Angles(0, 0, 2 * acos(dot))
			end
			cf1 = cf1 * CFrame.new(0, perp / 2, dif_para / 2)

			if not p0 then
				p0 = Instance.new("Part")
				p0.FormFactor = "Custom"
				p0.TopSurface = Enum.SurfaceType.Smooth
				p0.BottomSurface = Enum.SurfaceType.Smooth
				p0.Anchored = true
				p0.CanCollide = false
				p0.CastShadow = false
				p0.Material = MTREL
				p0.Size = Vector3.new(sz, sz, sz)
				local mesh = Instance.new("SpecialMesh")
				mesh.MeshType = Enum.MeshType.Wedge
				mesh.Name = "WedgeMesh"
				mesh.Parent = p0
			end
			p0.WedgeMesh.Scale = Vector3.new(0, perp / sz, para / sz)
			p0.CFrame = cf0

			if not p1 then
				p1 = p0:Clone()
			end
			p1.WedgeMesh.Scale = Vector3.new(0, perp / sz, dif_para / sz)
			p1.CFrame = cf1

			return p0, p1
		end

		function DrawQuad(v1, v2, v3, v4, parts)
			parts[1], parts[2] = DrawTriangle(v1, v2, v3, parts[1], parts[2])
			parts[3], parts[4] = DrawTriangle(v3, v2, v4, parts[3], parts[4])
		end
	end

	local frame = blurFrame

	local stepId = nextBlurStepId()
	local parts = {}
	local f = Instance.new("Folder")
	f.Name = frame.Name
	f.Parent = root

	local parents = {}
	do
		local function add(child)
			if child:IsA("GuiObject") then
				parents[#parents + 1] = child
				add(child.Parent)
			end
		end
		add(frame)
	end

	local function UpdateOrientation(fetchProps)
		ensureRootParent()
		local cam = currentCamera
		if not cam then
			return
		end

		local properties = {
			Transparency = 0.98,
			BrickColor = BrickColor.new("Institutional white"),
		}
		local zIndex = 1 - 0.05 * frame.ZIndex

		local tl, br = frame.AbsolutePosition, frame.AbsolutePosition + frame.AbsoluteSize
		local tr, bl = Vector2.new(br.x, tl.y), Vector2.new(tl.x, br.y)
		do
			local rot = 0
			for _, v in ipairs(parents) do
				rot += v.Rotation
			end
			if rot ~= 0 and rot % 180 ~= 0 then
				local mid = tl:lerp(br, 0.5)
				local s, c = math.sin(math.rad(rot)), math.cos(math.rad(rot))
				tl = Vector2.new(c * (tl.x - mid.x) - s * (tl.y - mid.y), s * (tl.x - mid.x) + c * (tl.y - mid.y)) + mid
				tr = Vector2.new(c * (tr.x - mid.x) - s * (tr.y - mid.y), s * (tr.x - mid.x) + c * (tr.y - mid.y)) + mid
				bl = Vector2.new(c * (bl.x - mid.x) - s * (bl.y - mid.y), s * (bl.x - mid.x) + c * (bl.y - mid.y)) + mid
				br = Vector2.new(c * (br.x - mid.x) - s * (br.y - mid.y), s * (br.x - mid.x) + c * (br.y - mid.y)) + mid
			end
		end
		DrawQuad(
			cam:ScreenPointToRay(tl.x, tl.y, zIndex).Origin,
			cam:ScreenPointToRay(tr.x, tr.y, zIndex).Origin,
			cam:ScreenPointToRay(bl.x, bl.y, zIndex).Origin,
			cam:ScreenPointToRay(br.x, br.y, zIndex).Origin,
			parts
		)
		if fetchProps then
			for _, pt in ipairs(parts) do
				pt.Parent = f
			end
			for propName, propValue in pairs(properties) do
				for _, pt in ipairs(parts) do
					pt[propName] = propValue
				end
			end
		end
	end

	UpdateOrientation(true)
	binding.parts = parts
	binding.stepId = stepId
	RunService:BindToRenderStep(stepId, 2000, UpdateOrientation)

	table.insert(binding.connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(ensureRootParent))

	return parts
end

return createBlur
