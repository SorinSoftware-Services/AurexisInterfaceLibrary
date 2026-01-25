-- src/components/home-tab.lua

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")


return function(Window, Aurexis, Elements, Navigation, GetIcon, Kwargify, tween, Release, isStudio)
    function Window:CreateHomeTab(HomeTabSettings)


	HomeTabSettings = Kwargify({
		Icon = 1,
		GoodExecutors = {"Bunni", "Delta", "Codex", "Cryptic", "ChocoSploit", "Hydrogen", "JJSploit", "MacSploit", "Seliware", "SirHurt", "VegaX", "Velocity", "Volcano", "Volt"},
		BadExecutors = {"Solara", "Xeno"},
		DetectedExecutors = {"Swift", "Valex", "Potassium"},
		DiscordInvite = "XC5hpQQvMX", -- Only the invite code, not the full URL.
		Supabase = {
			url = "https://udnvaneupscmrgwutamv.supabase.co",
			anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVkbnZhbmV1cHNjbXJnd3V0YW12Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ1NjEyMzAsImV4cCI6MjA3MDEzNzIzMH0.7duKofEtgRarIYDAoMfN7OEkOI_zgkG2WzAXZlxl5J0",
			feedbackFunction = "submit_feedback",
			hubInfoTable = "hub_metadata",
			hubInfoOrderColumn = "updated_at",
			supportedGamesTable = "games",
			supportedGamesFilter = "is_active=eq.true",
			supportedGamesLimit = 500,
		},
	}, HomeTabSettings or {})

	local HomeTab = {}

	local HomeTabButton = Navigation.Tabs.Home
	HomeTabButton.Visible = true
	if HomeTabSettings.Icon == 2 then
		HomeTabButton.ImageLabel.Image = GetIcon("dashboard", "Material")
	end

	local HomeTabPage = Elements.Home
	HomeTabPage.Visible = true
	if HomeTabPage:GetAttribute("SorinHomeTabReady") then
		return
	end
	HomeTabPage:SetAttribute("SorinHomeTabReady", true)

	function HomeTab:Activate()
		tween(HomeTabButton.ImageLabel, {ImageColor3 = Color3.fromRGB(255,255,255)})
		tween(HomeTabButton, {BackgroundTransparency = 0})
		tween(HomeTabButton.UIStroke, {Transparency = 0.41})

		Elements.UIPageLayout:JumpTo(HomeTabPage)

		task.wait(0.05)

		for _, OtherTabButton in ipairs(Navigation.Tabs:GetChildren()) do
			if OtherTabButton.Name ~= "InActive Template" and OtherTabButton.ClassName == "Frame" and OtherTabButton ~= HomeTabButton then
				tween(OtherTabButton.ImageLabel, {ImageColor3 = Color3.fromRGB(221,221,221)})
				tween(OtherTabButton, {BackgroundTransparency = 1})
				tween(OtherTabButton.UIStroke, {Transparency = 1})
			end
		end

		Window.CurrentTab = "Home"
	end

	HomeTab:Activate()
	FirstTab = false
	HomeTabButton.Interact.MouseButton1Click:Connect(function()
		HomeTab:Activate()
	end)

	-- === UI SETUP ===
	task.spawn(function()
		local ok, thumb = pcall(function()
			return Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		end)
		if ok and HomeTabPage and HomeTabPage:FindFirstChild("icon") and HomeTabPage.icon:FindFirstChild("ImageLabel") then
			HomeTabPage.icon.ImageLabel.Image = thumb
		end
	end)
	HomeTabPage.player.user.RichText = true
	HomeTabPage.player.user.Text = "You are using <b>" .. Release .. "</b>"

	local function getGreeting()
		local ok, now = pcall(os.date, "*t")
		local hour = (ok and now and now.hour) or 12

		if hour >= 5 and hour < 12 then
			return "Good morning"
		elseif hour >= 12 and hour < 18 then
			return "Good afternoon"
		elseif hour >= 18 then
			return "Good evening"
		else
			return "Hello night owl"
		end
	end

	HomeTabPage.player.Text.Text = string.format("%s, %s", getGreeting(), Players.LocalPlayer.DisplayName)


	local detailsHolder = HomeTabPage:FindFirstChild("detailsholder")
	local dashboard = detailsHolder and detailsHolder:FindFirstChild("dashboard")

	local function resolveExecutorName()
		if isStudio then
			return "Studio (Debug)"
		end
		if typeof(identifyexecutor) == "function" then
			local ok, name = pcall(identifyexecutor)
			if ok and name then
				return name
			end
		end
		return "Unknown"
	end

	local exec = resolveExecutorName()
	local clientCard = dashboard and dashboard:FindFirstChild("Client")
	if clientCard and clientCard:FindFirstChild("Title") then
		clientCard.Title.Text = "You are using " .. exec
	end

	if clientCard and clientCard:FindFirstChild("Subtitle") then
		if isStudio then
			clientCard.Subtitle.Text = "Aurexis Interface Library - Debugging Mode"
			clientCard.Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
		else
			local color, message
			if table.find(HomeTabSettings.GoodExecutors, exec) then
				color = Color3.fromRGB(80, 255, 80)
				message = "Good executor. Scripts should work here."
			elseif table.find(HomeTabSettings.BadExecutors, exec) then
				color = Color3.fromRGB(255, 180, 50)
				message = "Weak executor. Some scripts may not work."
			elseif table.find(HomeTabSettings.DetectedExecutors, exec) then
				color = Color3.fromRGB(255, 60, 60)
				message = "Executor could be detected. Find undetected Exec on our Website"
			else
				color = Color3.fromRGB(200, 200, 200)
				message = "Executor not in my list. Unknown compatibility."
			end

			clientCard.Subtitle.Text = message
			clientCard.Subtitle.TextColor3 = color
		end
	end

	-- === DISCORD BUTTON ===
	local discordCard = dashboard and dashboard:FindFirstChild("Discord")
	if discordCard and discordCard:FindFirstChild("Interact") then
		discordCard.Interact.MouseButton1Click:Connect(function()
			local inviteUrl = "https://discord.gg/" .. HomeTabSettings.DiscordInvite
			local copied = false
			if typeof(setclipboard) == "function" then
				copied = pcall(setclipboard, inviteUrl)
			end
			if Aurexis and typeof(Aurexis.Notification) == "function" then
				if copied then
					Aurexis:Notification({
						Title = "Discord",
						Icon = "check_circle",
						ImageSource = "Material",
						Content = "Link copied to clipboard.",
					})
				else
					Aurexis:Notification({
						Title = "Discord",
						Icon = "info",
						ImageSource = "Material",
						Content = "Invite: " .. inviteUrl,
					})
				end
			end
			if request then
				request({
					Url = "http://127.0.0.1:6463/rpc?v=1",
					Method = "POST",
					Headers = {
						["Content-Type"] = "application/json",
						Origin = "https://discord.com"
					},
					Body = HttpService:JSONEncode({
						cmd = "INVITE_BROWSER",
						nonce = HttpService:GenerateGUID(false),
						args = {code = HomeTabSettings.DiscordInvite}
					})
				})
			end
		end)
	end

	local NotificationIcons = {
		info = "info",
		success = "check_circle",
		check = "check",
		warning = "priority_high",
		warn = "priority_high",
		error = "_error",
		failure = "_error",
		danger = "_error",
		alert = "priority_high",
	}

	local function notify(title, content, icon)
		if Aurexis and typeof(Aurexis.Notification) == "function" then
			local iconName = icon
			if iconName and NotificationIcons[string.lower(iconName)] then
				iconName = NotificationIcons[string.lower(iconName)]
			elseif not iconName or iconName == "" then
				iconName = "info"
			end

			pcall(function()
				Aurexis:Notification({
					Title = title or "Home",
					Content = content or "",
					Icon = iconName,
					ImageSource = "Material",
				})
			end)
		end
	end

	local function sanitizeBaseUrl(url)
		if type(url) ~= "string" then
			return ""
		end
		if url:sub(-1) == "/" then
			return url:sub(1, -2)
		end
		return url
	end

	local function appendApiKey(url, key)
		if type(url) ~= "string" then
			return ""
		end
		if type(key) ~= "string" or key == "" then
			return url
		end
		if url:find("apikey=") then
			return url
		end
		local encoded = key
		local ok, result = pcall(function()
			return HttpService:UrlEncode(key)
		end)
		if ok and type(result) == "string" then
			encoded = result
		end
		local sep = url:find("?", 1, true) and "&" or "?"
		return url .. sep .. "apikey=" .. encoded
	end

	local SupabaseConfig = {
		url = "",
		anonKey = "",
		feedbackFunction = "submit_feedback",
		hubInfoTable = "hub_metadata",
		hubInfoOrderColumn = "updated_at",
		supportedGamesTable = "games",
		supportedGamesFilter = "is_active=eq.true",
		supportedGamesLimit = 1000,
	}

	if type(HomeTabSettings.Supabase) == "table" then
		for key, value in pairs(HomeTabSettings.Supabase) do
			SupabaseConfig[key] = value
		end
	end

	SupabaseConfig.url = sanitizeBaseUrl(SupabaseConfig.url)

	local function resolveRequestFunction()
		local envCandidates = {}

		local function pushEnv(env)
			if typeof(env) == "table" then
				table.insert(envCandidates, env)
			end
		end

		local okGenv, genv = pcall(function()
			return getgenv and getgenv()
		end)
		if okGenv then
			pushEnv(genv)
		end

		pushEnv(_G)
		pushEnv(shared)
		pushEnv(_ENV)

		local okFenv, fenv = pcall(function()
			return getfenv and getfenv()
		end)
		if okFenv then
			pushEnv(fenv)
		end

		local aliasList = {
			"http_request",
			"httprequest",
			"http.request",
			"syn.request",
			"syn.request_async",
			"fluxus.request",
			"krnl.request",
			"request",
			"http.post",
			"http_request_async",
		}

		local function tryResolve(scope, path)
			local current = scope
			for segment in string.gmatch(path, "[^%.]+") do
				if typeof(current) ~= "table" then
					return nil
				end
				current = rawget(current, segment) or current[segment]
			end
			if typeof(current) == "function" then
				return current
			end
			return nil
		end

		for _, env in ipairs(envCandidates) do
			for _, alias in ipairs(aliasList) do
				local fn = tryResolve(env, alias)
				if typeof(fn) == "function" then
					return fn, alias
				end
			end
		end

		for _, alias in ipairs(aliasList) do
			local ok, direct = pcall(function()
				return rawget(_G, alias)
			end)
			if ok and typeof(direct) == "function" then
				return direct, alias
			end
		end

		return nil
	end

	local requestFn, requestSource = resolveRequestFunction()
	local hasExecutorRequest = typeof(requestFn) == "function"

	local function httpRequest(options)
		options = options or {}
		options.Method = options.Method or "GET"
		options.Headers = options.Headers or {}
		options.Timeout = options.Timeout or 15

		if not requestFn then
			requestFn, requestSource = resolveRequestFunction()
			hasExecutorRequest = typeof(requestFn) == "function"
		end

		if requestFn then
			if options.Headers and options.headers == nil then
				options.headers = options.Headers
			elseif options.headers and options.Headers == nil then
				options.Headers = options.headers
			end
			local okRequest, response = pcall(requestFn, options)
			if not okRequest then
				return nil, "Executor request failed (" .. tostring(requestSource or "unknown") .. "): " .. tostring(response)
			end
			if not response then
				return nil, "Request returned nil"
			end
			if response.StatusCode then
				response.Success = response.StatusCode >= 200 and response.StatusCode < 300
			end
			return response
		end

		local ok, response = pcall(function()
			return HttpService:RequestAsync(options)
		end)

		if not ok then
			local message = tostring(response)
			if message:lower():find("http") or message:lower():find("blocked") then
				message = "Executor blocked HttpService:RequestAsync (" .. message .. ")"
			end
			return nil, message
		end

		if response.StatusCode then
			response.Success = response.Success == nil and response.StatusCode >= 200 and response.StatusCode < 300 or response.Success
		end

		return response
	end

	local function isSupabaseConfigured()
		return type(SupabaseConfig.url) == "string"
			and SupabaseConfig.url ~= ""
			and type(SupabaseConfig.anonKey) == "string"
			and SupabaseConfig.anonKey ~= ""
	end

	local function supabaseRequest(path, method, body, extraHeaders)
		if not isSupabaseConfigured() then
			return nil, "Backend config missing"
		end

		if type(path) ~= "string" or path == "" then
			return nil, "Invalid path"
		end

		local url = SupabaseConfig.url .. (path:sub(1, 1) == "/" and path or ("/" .. path))
		url = appendApiKey(url, SupabaseConfig.anonKey)

		local headers = {
			["Content-Type"] = "application/json",
			["Accept"] = "application/json",
			["apikey"] = SupabaseConfig.anonKey,
			["Authorization"] = "Bearer " .. SupabaseConfig.anonKey,
		}

		if type(extraHeaders) == "table" then
			for key, value in pairs(extraHeaders) do
				headers[key] = value
			end
		end

		local payload = body
		if body and type(body) ~= "string" then
			local ok, encoded = pcall(function()
				return HttpService:JSONEncode(body)
			end)
			if not ok then
				return nil, "JSON encode failed: " .. tostring(encoded)
			end
			payload = encoded
		end

		local response, err = httpRequest({
			Url = url,
			Method = method or "GET",
			Headers = headers,
			Body = payload,
		})

		if not response then
			return nil, err or "Request failed"
		end

		if not response.Success then
			local message = ("Backend request failed (%s %s): %s"):format(
				tostring(method or "GET"),
				url,
				tostring(response.Body or "no body")
			)
			return nil, message, response
		end

		return response, nil
	end

	local function decodeJson(body)
		if type(body) ~= "string" or body == "" then
			return nil
		end
		local ok, decoded = pcall(function()
			return HttpService:JSONDecode(body)
		end)
		if ok then
			return decoded
		end
		return nil
	end

	local networkStatsContainer = nil
	local performanceStatsContainer = nil
	local fpsAccumulator = {
		frames = 0,
		delta = 0,
		sum = 0,
		current = 0,
		conn = nil,
	}

	local NETWORK_STAT_ALIASES = {
		upload = {
			"Data Send Kbps",
			"Data Send Rate",
			"Data Send",
			"Network Sent",
			"Network Sent KBps",
			"Total Upload",
		},
		download = {
			"Data Receive Kbps",
			"Data Receive Rate",
			"Data Receive",
			"Network Received",
			"Network Received KBps",
			"Total Download",
		},
	}

	local function ensureFpsSampler()
		if fpsAccumulator.conn then
			return
		end
		fpsAccumulator.conn = RunService.RenderStepped:Connect(function(dt)
			fpsAccumulator.frames = fpsAccumulator.frames + 1
			fpsAccumulator.delta = fpsAccumulator.delta + dt
			if dt > 0 then
				fpsAccumulator.sum = fpsAccumulator.sum + (1 / dt)
			end
		end)
	end

	local function resolveNetworkStats()
		if networkStatsContainer and networkStatsContainer.Parent then
			return
		end
		if networkStatsContainer ~= nil then
			return
		end
		local ok, net = pcall(function()
			if not Stats then
				return nil
			end
			local network = Stats.Network
			if not network then
				return nil
			end
			if network.ServerStatsItem ~= nil then
				return network.ServerStatsItem
			end
			if typeof(network.FindFirstChild) == "function" then
				return network:FindFirstChild("ServerStatsItem")
			end
			return nil
		end)
		if ok and net then
			networkStatsContainer = net
		end
	end

	local function resolvePerformanceStats()
		if performanceStatsContainer ~= nil then
			return
		end
		local ok, perf = pcall(function()
			return Stats and Stats.PerformanceStats
		end)
		if ok and perf then
			performanceStatsContainer = perf
		end
	end

	local function extractNumeric(value)
		if typeof(value) == "string" and value ~= "" then
			local number = tonumber((value:gsub("[^%d%.%-]", "")))
			return number or value
		end
		return value
	end

	local function getServerStatValue(statName)
		resolveNetworkStats()
		if not networkStatsContainer then
			return nil
		end

		local item = nil
		local okIndex, indexResult = pcall(function()
			return networkStatsContainer[statName]
		end)
		if okIndex and indexResult then
			item = indexResult
		end

		if not item and typeof(networkStatsContainer.FindFirstChild) == "function" then
			local okFind, findResult = pcall(function()
				return networkStatsContainer:FindFirstChild(statName)
			end)
			if okFind and findResult then
				item = findResult
			end
		end

		if not item and typeof(networkStatsContainer.GetChildren) == "function" then
			local normalizedTarget = string.lower((statName or ""):gsub("[%s_/]+", ""))
			for _, child in ipairs(networkStatsContainer:GetChildren()) do
				local normalizedName = string.lower(child.Name:gsub("[%s_/]+", ""))
				if normalizedName == normalizedTarget then
					item = child
					break
				end
			end
		end

		if not item then
			return nil
		end

		if typeof(item.GetValue) == "function" then
			local okValue, value = pcall(item.GetValue, item)
			if okValue and typeof(value) == "number" then
				return value
			end
		end

		if typeof(item.GetValueString) == "function" then
			local okString, str = pcall(item.GetValueString, item)
			if okString and typeof(str) == "string" then
				return extractNumeric(str)
			end
		end

		return nil
	end

	local function getPerformanceStatValue(statName)
		resolvePerformanceStats()
		if not performanceStatsContainer then
			return nil
		end
		local item = nil

		if typeof(performanceStatsContainer.FindFirstChild) == "function" then
			item = performanceStatsContainer:FindFirstChild(statName)
		end

		if not item and typeof(performanceStatsContainer.GetChildren) == "function" then
			local normalizedTarget = string.lower((statName or ""):gsub("[%s_/]+", ""))
			for _, child in ipairs(performanceStatsContainer:GetChildren()) do
				local normalizedName = string.lower(child.Name:gsub("[%s_/]+", ""))
				if normalizedName == normalizedTarget then
					item = child
					break
				end
			end
		end

		if not item then
			return nil
		end

		if typeof(item.GetValue) == "function" then
			local okValue, value = pcall(item.GetValue, item)
			if okValue then
				if typeof(value) == "number" then
					return value
				end
				return extractNumeric(value)
			end
		end

		if typeof(item.GetValueString) == "function" then
			local okString, str = pcall(item.GetValueString, item)
			if okString then
				return extractNumeric(str)
			end
		end

		if typeof(item.Value) == "number" then
			return item.Value
		end

		return nil
	end

	local function getPing()
		local value = getServerStatValue("Data Ping")
		if typeof(value) == "number" then
			return string.format("%d ms", math.floor(value + 0.5))
		end
		if typeof(value) == "string" and value ~= "" then
			return value
		end

		local ok, pingSeconds = pcall(function()
			return Players.LocalPlayer and Players.LocalPlayer:GetNetworkPing()
		end)
		if ok and typeof(pingSeconds) == "number" then
			local ms = math.max(0, math.floor((pingSeconds * 2) / 0.01))
			return string.format("%d ms", ms)
		end

		return "N/A"
	end

	local function getNetworkStat(aliasList, unit)
		local value = nil
		for _, name in ipairs(aliasList) do
			value = getServerStatValue(name)
			if value ~= nil then
				break
			end
		end

		if value == nil then
			for _, name in ipairs(aliasList) do
				value = getPerformanceStatValue(name)
				if value ~= nil then
					break
				end
			end
		end

		if typeof(value) == "number" then
			return string.format("%.0f %s", value, unit)
		end
		if typeof(value) == "string" and value ~= "" then
			return value
		end
		return "N/A"
	end

	local function getTotalMemoryTag()
		local ok, items = pcall(function()
			return Enum.DeveloperMemoryTag:GetEnumItems()
		end)
		if ok and items then
			for _, item in ipairs(items) do
				if item.Name == "Total" then
					return item
				end
			end
		end
		return nil
	end

	local function getMemory()
		if Stats and typeof(Stats.GetMemoryUsageMbForTag) == "function" then
			local totalTag = getTotalMemoryTag()
			if totalTag then
				local ok, total = pcall(function()
					return Stats:GetMemoryUsageMbForTag(totalTag)
				end)
				if ok and typeof(total) == "number" then
					return string.format("%.1f MB", total)
				end
			end
		end

		local ok, kb = pcall(function()
			return collectgarbage("count")
		end)
		if ok and kb then
			return string.format("%.1f MB", kb / 1024)
		end

		return "N/A"
	end

	local function getFps()
		local statFps = getPerformanceStatValue("FrameRate")
		if typeof(statFps) == "number" and statFps > 0 then
			fpsAccumulator.current = math.floor(statFps + 0.5)
		elseif fpsAccumulator.frames > 0 and fpsAccumulator.sum > 0 then
			fpsAccumulator.current = math.floor((fpsAccumulator.sum / fpsAccumulator.frames) + 0.5)
		elseif fpsAccumulator.delta > 0 then
			fpsAccumulator.current = math.floor((fpsAccumulator.frames / fpsAccumulator.delta) + 0.5)
		else
			fpsAccumulator.current = 0
		end
		fpsAccumulator.frames = 0
		fpsAccumulator.delta = 0
		fpsAccumulator.sum = 0
		return fpsAccumulator.current
	end

	local function clearCard(card, allowed)
		if not card then
			return
		end
		allowed = allowed or {}
		for _, child in ipairs(card:GetChildren()) do
			if child.Name == "Interact" and child:IsA("GuiButton") then
				child.Visible = false
				child.Active = false
				child.AutoButtonColor = false
			elseif allowed[child.Name] then
				child.Visible = true
			elseif child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") or child:IsA("ImageLabel") or child:IsA("ImageButton") then
				if child.Name ~= "Title" and child.Name ~= "Interact" then
					child.Visible = false
				end
			end
		end
	end

	local function createContentFrame(card, name, allowScroll)
		local desiredClass = allowScroll and "ScrollingFrame" or "Frame"
		local content
		for _, child in ipairs(card:GetChildren()) do
			if child.Name == name and (child:IsA("Frame") or child:IsA("ScrollingFrame")) then
				if child.ClassName ~= desiredClass then
					child:Destroy()
				elseif not content then
					content = child
				else
					child:Destroy()
				end
			end
		end
		if not content then
			content = Instance.new(desiredClass)
		end

		content.Name = name
		content.BackgroundTransparency = 1
		content.BorderSizePixel = 0
		content.ClipsDescendants = true
		content.Position = UDim2.new(0, 12, 0, 32)
		content.Size = UDim2.new(1, -24, 1, -44)
		content.Parent = card

		for _, child in ipairs(content:GetChildren()) do
			child:Destroy()
		end

		if content:IsA("ScrollingFrame") then
			content.Active = allowScroll == true
			content.ScrollingEnabled = allowScroll ~= false
			content.ScrollBarThickness = allowScroll and 1 or 0
			content.ScrollBarImageTransparency = allowScroll and 0.85 or 1
			content.ScrollingDirection = Enum.ScrollingDirection.Y
			content.CanvasSize = UDim2.new(0, 0, 0, 0)
		end

		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0, 6)
		padding.PaddingRight = allowScroll and UDim.new(0, 8) or UDim.new(0, 6)
		padding.PaddingTop = UDim.new(0, 6)
		padding.PaddingBottom = UDim.new(0, 6)
		padding.Parent = content

		local layout = Instance.new("UIListLayout")
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Padding = UDim.new(0, 6)
		layout.Parent = content

		local extraCanvas = allowScroll and 12 or 0
		if content:IsA("ScrollingFrame") then
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + extraCanvas)
			end)
		end

		return content
	end

	local function createBlock(parent, height, bgColor, strokeColor)
		local frame = Instance.new("Frame")
		frame.BackgroundColor3 = bgColor or Color3.fromRGB(26, 26, 32)
		frame.Size = UDim2.new(1, 0, 0, height or 30)
		frame.Parent = parent

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = frame

		local stroke = Instance.new("UIStroke")
		stroke.Color = strokeColor or Color3.fromRGB(64, 61, 76)
		stroke.Transparency = 0.55
		stroke.Parent = frame

		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0, 8)
		padding.PaddingRight = UDim.new(0, 8)
		padding.PaddingTop = UDim.new(0, 6)
		padding.PaddingBottom = UDim.new(0, 6)
		padding.Parent = frame

		return frame
	end

	local function createLabeledInput(parent, labelFont, inputFont, labelText, placeholder, maxChars)
		local wrapper = Instance.new("Frame")
		wrapper.BackgroundTransparency = 1
		wrapper.Size = UDim2.new(1, 0, 0, 42)
		wrapper.Parent = parent

		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Font = labelFont or Enum.Font.GothamSemibold
		label.TextSize = 12
		label.TextColor3 = Color3.fromRGB(200, 200, 210)
		label.Text = labelText or ""
		label.Size = UDim2.new(1, 0, 0, 14)
		label.Parent = wrapper

		local frame = Instance.new("Frame")
		frame.BackgroundColor3 = Color3.fromRGB(32, 30, 38)
		frame.Size = UDim2.new(1, 0, 0, 24)
		frame.Position = UDim2.new(0, 0, 0, 16)
		frame.Parent = wrapper

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = frame

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(64, 61, 76)
		stroke.Transparency = 0.5
		stroke.Parent = frame

		local box = Instance.new("TextBox")
		box.Name = "Input"
		box.BackgroundTransparency = 1
		box.ClearTextOnFocus = false
		box.Text = ""
		box.PlaceholderText = placeholder or ""
		box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
		box.TextColor3 = Color3.fromRGB(235, 235, 235)
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.Font = inputFont or Enum.Font.Gotham
		box.TextSize = 14
		box.Size = UDim2.new(1, -12, 1, 0)
		box.Position = UDim2.new(0, 6, 0, 0)
		box.Parent = frame

		if type(maxChars) == "number" then
			box:GetPropertyChangedSignal("Text"):Connect(function()
				if #box.Text > maxChars then
					box.Text = box.Text:sub(1, maxChars)
				end
			end)
		end

		return box, wrapper
	end

	local function createParagraph(parent, title, text)
		if not (Elements and Elements.Template and Elements.Template.Paragraph) then
			return nil
		end

		local paragraph = Elements.Template.Paragraph:Clone()
		paragraph.Visible = true
		paragraph.Parent = parent

		if paragraph:FindFirstChild("Title") then
			paragraph.Title.Text = title or ""
			paragraph.Title.TextTransparency = 0
		end
		if paragraph:FindFirstChild("Text") then
			paragraph.Text.Text = text or ""
			paragraph.Text.TextTransparency = 0
		end
		paragraph.BackgroundTransparency = 1
		if paragraph:FindFirstChild("UIStroke") then
			paragraph.UIStroke.Transparency = 0.5
		end

		local function update()
			if paragraph:FindFirstChild("Text") then
				paragraph.Text.Size = UDim2.new(paragraph.Text.Size.X.Scale, paragraph.Text.Size.X.Offset, 0, math.huge)
				paragraph.Text.Size = UDim2.new(paragraph.Text.Size.X.Scale, paragraph.Text.Size.X.Offset, 0, paragraph.Text.TextBounds.Y)
				paragraph.Size = UDim2.new(paragraph.Size.X.Scale, paragraph.Size.X.Offset, 0, paragraph.Text.TextBounds.Y + 40)
			end
		end

		update()

		local paragraphApi = {
			Instance = paragraph,
		}

		function paragraphApi:Set(settings)
			settings = settings or {}
			if settings.Title ~= nil and paragraph:FindFirstChild("Title") then
				paragraph.Title.Text = settings.Title
			end
			if settings.Text ~= nil and paragraph:FindFirstChild("Text") then
				paragraph.Text.Text = settings.Text
			end
			update()
		end

		return paragraphApi
	end

	local function ensureDetailsScroller(detailsHolderRef, dashboardRef)
		if not detailsHolderRef then
			return nil, nil
		end

		local container = detailsHolderRef
		if not detailsHolderRef:IsA("ScrollingFrame") then
			local scroller = detailsHolderRef:FindFirstChild("HomeDetailsScroller")
			if not (scroller and scroller:IsA("ScrollingFrame")) then
				scroller = Instance.new("ScrollingFrame")
				scroller.Name = "HomeDetailsScroller"
				scroller.BackgroundTransparency = 1
				scroller.BorderSizePixel = 0
				scroller.Size = UDim2.new(1, 0, 1, 0)
				scroller.Position = UDim2.new(0, 0, 0, 0)
				scroller.CanvasSize = UDim2.new(0, 0, 0, 0)
				scroller.ScrollBarThickness = 4
				scroller.ScrollBarImageTransparency = 0.65
				scroller.ScrollingDirection = Enum.ScrollingDirection.Y
				pcall(function()
					scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
				end)
				scroller.Parent = detailsHolderRef
			end
			container = scroller
		end

		local usesAutoCanvas = false
		if container:IsA("ScrollingFrame") then
			container.Active = true
			container.Selectable = true
			container.ScrollingEnabled = true
			container.ScrollingDirection = Enum.ScrollingDirection.Y
			container.ScrollBarThickness = 6
			pcall(function()
				container.ScrollBarInset = Enum.ScrollBarInset.None
			end)
			local okAuto = pcall(function()
				container.AutomaticCanvasSize = Enum.AutomaticSize.Y
			end)
			usesAutoCanvas = okAuto == true
		end

		if dashboardRef and dashboardRef.Parent == detailsHolderRef then
			dashboardRef.Parent = container
		end

		local padding = container:FindFirstChildOfClass("UIPadding")
		if not padding then
			padding = Instance.new("UIPadding")
			padding.PaddingLeft = UDim.new(0, 0)
			padding.PaddingRight = UDim.new(0, 0)
			padding.PaddingTop = UDim.new(0, 0)
			padding.PaddingBottom = UDim.new(0, 140)
			padding.Parent = container
		else
			padding.PaddingRight = UDim.new(0, math.max(padding.PaddingRight.Offset, 0))
			padding.PaddingBottom = UDim.new(0, math.max(padding.PaddingBottom.Offset, 140))
		end

		local layout = container:FindFirstChildWhichIsA("UIListLayout")
		if not layout then
			layout = Instance.new("UIListLayout")
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			layout.Padding = UDim.new(0, 12)
			layout.Parent = container
		else
			layout.SortOrder = Enum.SortOrder.LayoutOrder
		end
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Left

		if container:IsA("ScrollingFrame") and not usesAutoCanvas then
			local function updateCanvas()
				local extra = (padding and padding.PaddingBottom.Offset or 0) + 40
				local y = layout.AbsoluteContentSize.Y + extra
				if y < 0 then
					y = 0
				end
				container.CanvasSize = UDim2.new(0, 0, 0, math.min(y, 6000))
			end
			updateCanvas()
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
		end

		return container, layout
	end


	local function buildFeedbackCard(card)
		if not card then
			return nil
		end

		clearCard(card, {FeedbackContent = true})
		card.ClipsDescendants = true

		local titleLabel = card:FindFirstChild("Title")
		if titleLabel and titleLabel:IsA("TextLabel") then
			titleLabel.Text = "Feedback & Ideas"
		end

		local allowInnerScroll = UserInputService and UserInputService.TouchEnabled ~= true
		local content = createContentFrame(card, "FeedbackContent", allowInnerScroll)
		if content and content:IsA("ScrollingFrame") then
			content.ScrollBarThickness = 0
			content.ScrollBarImageTransparency = 1
		end

		local function resolveBaseHeight()
			local sizeY = card.Size.Y
			if sizeY.Scale == 0 and sizeY.Offset > 0 then
				return sizeY.Offset
			end
			if card.AbsoluteSize.Y > 0 then
				return card.AbsoluteSize.Y
			end
			return 180
		end

		if allowInnerScroll then
			card.Size = UDim2.new(1, 0, 0, resolveBaseHeight())
		else
			local contentLayout = content and content:FindFirstChildOfClass("UIListLayout")
			local contentPadding = content and content:FindFirstChildOfClass("UIPadding")
			local function updateCardHeight()
				if not contentLayout then
					return
				end
				local paddingTop = contentPadding and contentPadding.PaddingTop.Offset or 0
				local paddingBottom = contentPadding and contentPadding.PaddingBottom.Offset or 0
				local contentHeight = contentLayout.AbsoluteContentSize.Y + paddingTop + paddingBottom
				local target = math.max(180, contentHeight + 44)
				card.Size = UDim2.new(1, 0, 0, target)
			end
			if contentLayout then
				updateCardHeight()
				contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCardHeight)
			end
		end
		local fontStrong = Enum.Font.GothamSemibold
		local fontBody = Enum.Font.Gotham

		local statusBlock = createBlock(content, 28, Color3.fromRGB(24, 24, 30), Color3.fromRGB(64, 61, 76))
		statusBlock.Name = "StatusBlock"
		statusBlock.LayoutOrder = 1

		local statusDot = Instance.new("Frame")
		statusDot.Name = "Dot"
		statusDot.BackgroundColor3 = Color3.fromRGB(120, 255, 150)
		statusDot.Size = UDim2.new(0, 8, 0, 8)
		statusDot.AnchorPoint = Vector2.new(0, 0.5)
		statusDot.Position = UDim2.new(0, 0, 0.5, 0)
		statusDot.Parent = statusBlock

		local statusCorner = Instance.new("UICorner")
		statusCorner.CornerRadius = UDim.new(1, 0)
		statusCorner.Parent = statusDot

		local statusLabel = Instance.new("TextLabel")
		statusLabel.Name = "Status"
		statusLabel.BackgroundTransparency = 1
		statusLabel.TextXAlignment = Enum.TextXAlignment.Left
		statusLabel.Font = fontStrong
		statusLabel.TextSize = 13
		statusLabel.Position = UDim2.new(0, 14, 0, 0)
		statusLabel.Size = UDim2.new(1, -14, 1, 0)
		statusLabel.Parent = statusBlock

		local function updateStatus()
			if not isSupabaseConfigured() then
				statusLabel.Text = "Backend not configured."
				statusLabel.TextColor3 = Color3.fromRGB(255, 190, 90)
				statusDot.BackgroundColor3 = Color3.fromRGB(255, 190, 90)
			elseif not hasExecutorRequest then
				statusLabel.Text = "HTTP support missing. Feedback disabled."
				statusLabel.TextColor3 = Color3.fromRGB(255, 170, 100)
				statusDot.BackgroundColor3 = Color3.fromRGB(255, 170, 100)
			else
				statusLabel.Text = "Ready to send feedback."
				statusLabel.TextColor3 = Color3.fromRGB(120, 255, 150)
				statusDot.BackgroundColor3 = Color3.fromRGB(120, 255, 150)
			end
		end

		updateStatus()

		local feedbackBox, feedbackFrame = createLabeledInput(content, fontStrong, fontBody, "Feedback", "What should we improve?", 300)
		feedbackFrame.LayoutOrder = 2

		local ideaBox, ideaFrame = createLabeledInput(content, fontStrong, fontBody, "Ideas", "Game ideas or feature requests", 200)
		ideaFrame.LayoutOrder = 3

		local contactBox, contactFrame = createLabeledInput(content, fontStrong, fontBody, "Contact", "Contact (optional)", 80)
		contactFrame.LayoutOrder = 4

		local submitButton = Instance.new("TextButton")
		submitButton.Name = "SubmitFeedback"
		submitButton.AutoButtonColor = false
		submitButton.Text = "Submit feedback"
		submitButton.Font = fontStrong
		submitButton.TextSize = 14
		submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		submitButton.BackgroundColor3 = Color3.fromRGB(86, 110, 190)
		submitButton.Size = UDim2.new(1, 0, 0, 28)
		submitButton.LayoutOrder = 5
		submitButton.Parent = content

		local buttonCorner = Instance.new("UICorner")
		buttonCorner.CornerRadius = UDim.new(0, 6)
		buttonCorner.Parent = submitButton

		local buttonStroke = Instance.new("UIStroke")
		buttonStroke.Transparency = 0.4
		buttonStroke.Color = Color3.fromRGB(110, 140, 220)
		buttonStroke.Parent = submitButton

		local buttonGradient = Instance.new("UIGradient")
		buttonGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(86, 110, 190)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 90, 200)),
		})
		buttonGradient.Rotation = 12
		buttonGradient.Parent = submitButton

		local function trim(value)
			return (tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", ""))
		end

		submitButton.MouseButton1Click:Connect(function()
			local message = trim(feedbackBox.Text)
			local idea = trim(ideaBox.Text)
			local contact = trim(contactBox.Text)

			if message == "" and idea == "" then
				notify("Feedback", "Please provide feedback or a game idea.", "warning")
				return
			end

			if not isSupabaseConfigured() then
				notify("Feedback", "Backend is not configured. Update the Supabase values.", "error")
				return
			end

			if not hasExecutorRequest then
				notify("Feedback", "Executor blocks HTTP requests (http_request missing).", "error")
				return
			end

			local payload = {
				message = message,
				idea = idea,
				contact = contact,
				place_id = game.PlaceId,
				game_id = game.GameId,
				user_id = Players.LocalPlayer and Players.LocalPlayer.UserId or nil,
				username = Players.LocalPlayer and Players.LocalPlayer.Name or nil,
				executor = typeof(identifyexecutor) == "function" and identifyexecutor() or "Unknown",
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
			}

			local response, err = supabaseRequest(
				"/functions/v1/" .. SupabaseConfig.feedbackFunction,
				"POST",
				payload
			)

			if not response then
				warn("[HomeTab] Feedback submission failed:", err)
				notify("Feedback failed", "Response: " .. tostring(err), "error")
				return
			end

			local data = decodeJson(response.Body)
			if data and data.error then
				notify("Feedback failed", tostring(data.error), "error")
				return
			end

			notify("Feedback sent", "Thank you! Your feedback was saved.", "check")
			feedbackBox.Text = ""
			ideaBox.Text = ""
			contactBox.Text = ""
		end)

		return {
			updateStatus = updateStatus,
		}
	end

	local defaultCreditsText = "SorinSoftware Services - Hub development\nNebulaSoftworks - LunaInterface Suite"

	local function formatCredits(credits)
		if typeof(credits) == "string" then
			return credits
		end
		if typeof(credits) == "table" then
			local lines = {}
			for key, value in pairs(credits) do
				if typeof(value) == "table" then
					local name = value.name or value.label or value.title or value[1]
					local role = value.role or value.subtitle or value[2]
					if name and role then
						table.insert(lines, string.format("%s - %s", tostring(name), tostring(role)))
					elseif name then
						table.insert(lines, tostring(name))
					end
				elseif typeof(key) == "number" then
					table.insert(lines, tostring(value))
				else
					table.insert(lines, string.format("%s - %s", tostring(key), tostring(value)))
				end
			end
			return table.concat(lines, "\n")
		end
		return defaultCreditsText
	end

	local function fetchSupportedGamesCount()
		local tableName = SupabaseConfig.supportedGamesTable
		if type(tableName) ~= "string" or tableName == "" then
			return nil, "Supported games table not configured"
		end

		local queryParts = { "select=id", "limit=1" }
		if type(SupabaseConfig.supportedGamesFilter) == "string" and SupabaseConfig.supportedGamesFilter ~= "" then
			table.insert(queryParts, SupabaseConfig.supportedGamesFilter)
		end

		local path = ("/rest/v1/%s?%s"):format(tableName, table.concat(queryParts, "&"))
		local response, err = supabaseRequest(path, "GET", nil, {
			Prefer = "count=exact",
		})
		if not response then
			return nil, err
		end

		local function getHeader(headers, name)
			if type(headers) ~= "table" then
				return nil
			end
			local target = string.lower(name)
			for key, value in pairs(headers) do
				if type(key) == "string" and string.lower(key) == target then
					return value
				end
			end
			return nil
		end

		local headers = response.Headers or response.headers or {}
		local contentRange = getHeader(headers, "content-range")
		if type(contentRange) == "string" then
			local total = contentRange:match("/(%d+)$")
			if total then
				return tonumber(total)
			end
		end

		local records = decodeJson(response.Body)
		if typeof(records) ~= "table" then
			return nil, "Invalid response"
		end

		if #records > 0 then
			return #records
		end

		local count = 0
		for _ in pairs(records) do
			count += 1
		end
		return count
	end

	local function buildHubInfoCard(card)
		if not card then
			return nil
		end

		clearCard(card, {HubInfoContent = true})
		card.ClipsDescendants = true
		card.BackgroundColor3 = Color3.fromRGB(44, 32, 72)
		if card:FindFirstChildWhichIsA("UIStroke") then
			card:FindFirstChildWhichIsA("UIStroke").Color = Color3.fromRGB(124, 92, 186)
			card:FindFirstChildWhichIsA("UIStroke").Transparency = 0.35
		end

		local titleLabel = card:FindFirstChild("Title")
		if titleLabel and titleLabel:IsA("TextLabel") then
			titleLabel.Text = "Hub Information"
			titleLabel.TextColor3 = Color3.fromRGB(240, 230, 255)
		end

		local content = createContentFrame(card, "HubInfoContent", false)
		local contentLayout = content and content:FindFirstChildOfClass("UIListLayout")
		local contentPadding = content and content:FindFirstChildOfClass("UIPadding")

		local function updateCardHeight()
			if not contentLayout then
				return
			end
			local paddingTop = contentPadding and contentPadding.PaddingTop.Offset or 0
			local paddingBottom = contentPadding and contentPadding.PaddingBottom.Offset or 0
			local contentHeight = contentLayout.AbsoluteContentSize.Y + paddingTop + paddingBottom
			local target = math.max(220, contentHeight + 44)
			card.Size = UDim2.new(1, 0, 0, target)
		end

		if contentLayout then
			updateCardHeight()
			contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCardHeight)
		end

		local function backendStatusText()
			if not isSupabaseConfigured() then
				return "Supabase not configured."
			end
			if not hasExecutorRequest then
				return "Executor HTTP function missing (no http_request)."
			end
			return "Loading version & info ..."
		end

		local hubInfoParagraph = createParagraph(content, "Hub Version", backendStatusText())
		local creditsParagraph = createParagraph(content, "Credits", defaultCreditsText)
		if hubInfoParagraph and hubInfoParagraph.Instance then
			hubInfoParagraph.Instance.LayoutOrder = 1
		end
		if creditsParagraph and creditsParagraph.Instance then
			creditsParagraph.Instance.LayoutOrder = 2
		end

		local function loadHubInfo()
			if not isSupabaseConfigured() then
				return
			end

			if hubInfoParagraph then
				hubInfoParagraph:Set({
					Title = "Hub Version",
					Text = "Loading version & info ...",
				})
			end
			if creditsParagraph then
				creditsParagraph:Set({
					Title = "Credits",
					Text = defaultCreditsText,
				})
			end

			if not hasExecutorRequest then
				if hubInfoParagraph then
					hubInfoParagraph:Set({
						Title = "Hub Version",
						Text = "Backend data cannot be loaded (no http_request).",
					})
				end
				return
			end

			local tableName = SupabaseConfig.hubInfoTable
			if type(tableName) ~= "string" or tableName == "" then
				if hubInfoParagraph then
					hubInfoParagraph:Set({
						Title = "Hub Version",
						Text = "Invalid table name. Check SupabaseConfig.hubInfoTable.",
					})
				end
				return
			end

			local path = ("/rest/v1/%s?select=*&order=%s.desc&limit=1"):format(
				tableName,
				SupabaseConfig.hubInfoOrderColumn or "updated_at"
			)

			local response, err = supabaseRequest(path, "GET", nil, {
				Prefer = "return=representation",
			})

			if not response then
				if hubInfoParagraph then
					hubInfoParagraph:Set({
						Title = "Hub Version",
						Text = "Backend request failed:\n" .. tostring(err),
					})
				end
				return
			end

			local records = decodeJson(response.Body) or {}
			local payload = nil
			if typeof(records) == "table" then
				if #records > 0 then
					payload = records[1]
				else
					payload = records
				end
			end

			if type(payload) ~= "table" then
				if hubInfoParagraph then
					hubInfoParagraph:Set({
						Title = "Hub Version",
						Text = "No hub information found.",
					})
				end
				return
			end

			local version = payload.version or payload.hub_version or "unknown"
			local lastUpdate = payload.last_update or payload.updated_at or payload.release_date or "unknown"
			local extra = payload.notes or payload.details or ""

			local infoLines = {
				"Hub version: " .. tostring(version),
				"Last update: " .. tostring(lastUpdate),
			}

			if payload.build or payload.tag then
				table.insert(infoLines, "Build: " .. tostring(payload.build or payload.tag))
			end

			if payload.maintainer or payload.maintained_by then
				table.insert(infoLines, "Maintainer: " .. tostring(payload.maintainer or payload.maintained_by))
			end

			if extra ~= "" then
				table.insert(infoLines, "Notes: " .. tostring(extra))
			end

			local supportedCount, countErr = fetchSupportedGamesCount()
			if supportedCount then
				table.insert(infoLines, "Supported games: " .. tostring(supportedCount))
			elseif countErr then
				table.insert(infoLines, "Supported games: unavailable")
			end

			if hubInfoParagraph then
				hubInfoParagraph:Set({
					Title = "Hub Version",
					Text = table.concat(infoLines, "\n"),
				})
			end

			if payload.credits and creditsParagraph then
				creditsParagraph:Set({
					Title = "Credits",
					Text = formatCredits(payload.credits),
				})
			end

			updateCardHeight()
		end

		return {
			load = loadHubInfo,
		}
	end

	local function buildEnvironmentCard(card)
		if not card then
			return nil
		end

		clearCard(card, {EnvironmentContent = true})
		card.ClipsDescendants = true

		local titleLabel = card:FindFirstChild("Title")
		if titleLabel and titleLabel:IsA("TextLabel") then
			titleLabel.Text = "Environment Stats"
		end

		local content = createContentFrame(card, "EnvironmentContent", false)
		local contentPadding = content:FindFirstChildOfClass("UIPadding")
		if contentPadding then
			contentPadding.PaddingTop = UDim.new(0, 4)
			contentPadding.PaddingBottom = UDim.new(0, 4)
		end
		local fontStrong = Enum.Font.GothamSemibold
		local fontBody = Enum.Font.Gotham
		local titleColor = (titleLabel and titleLabel.TextColor3) or Color3.fromRGB(240, 240, 240)

		local statsBlock = createBlock(content, 114, Color3.fromRGB(24, 24, 30), Color3.fromRGB(70, 60, 90))
		statsBlock.Name = "EnvironmentStats"
		statsBlock.LayoutOrder = 1
		statsBlock.BackgroundTransparency = 0.80

		local statsTitle = Instance.new("TextLabel")
		statsTitle.Name = "StatsTitle"
		statsTitle.BackgroundTransparency = 1
		statsTitle.TextXAlignment = Enum.TextXAlignment.Left
		statsTitle.Font = fontStrong
		statsTitle.TextSize = 13
		statsTitle.TextColor3 = titleColor
		statsTitle.Text = "Environment Stats"
		statsTitle.Position = UDim2.new(0, 2, 0, 2)
		statsTitle.Size = UDim2.new(1, -4, 0, 14)
		statsTitle.Parent = statsBlock

		local statsText = Instance.new("TextLabel")
		statsText.Name = "StatsBody"
		statsText.BackgroundTransparency = 1
		statsText.TextXAlignment = Enum.TextXAlignment.Left
		statsText.TextYAlignment = Enum.TextYAlignment.Top
		statsText.TextWrapped = true
		statsText.Font = fontBody
		statsText.TextSize = 12
		statsText.TextColor3 = Color3.fromRGB(180, 180, 180)
		statsText.Position = UDim2.new(0, 2, 0, 18)
		statsText.Size = UDim2.new(1, -4, 1, -20)
		statsText.Text = "Collecting stats..."
		statsText.Parent = statsBlock

		task.delay(0.15, ensureFpsSampler)
		task.spawn(function()
			task.wait(0.25)
			while statsText and statsText.Parent do
				task.wait(1)
				local fpsValue = getFps()
				task.wait(0.2)
				local pingValue = getPing()
				task.wait(0.2)
				local uploadValue = getNetworkStat(NETWORK_STAT_ALIASES.upload, "KB/s")
				task.wait(0.2)
				local downloadValue = getNetworkStat(NETWORK_STAT_ALIASES.download, "KB/s")
				task.wait(0.2)
				local memoryValue = getMemory()
				task.wait(0.2)
				local execValue = typeof(identifyexecutor) == "function" and identifyexecutor() or "Unknown"
				local text = table.concat({
					string.format("FPS: %s", fpsValue > 0 and tostring(fpsValue) or "N/A"),
					string.format("Ping: %s", pingValue),
					string.format("Upload: %s", uploadValue),
					string.format("Download: %s", downloadValue),
					string.format("Memory: %s", memoryValue),
					string.format("Executor: %s", execValue),
				}, "\n")
				statsText.Text = text
			end
		end)
	end

	if dashboard then
		local layout = dashboard:FindFirstChildWhichIsA("UIGridLayout") or dashboard:FindFirstChildWhichIsA("UIListLayout")
		if layout then
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			local function getCardHeight(child)
				if not (child and child:IsA("GuiObject")) then
					return 0
				end
				if not child.Visible then
					return 0
				end
				if child:IsA("UIGridLayout") or child:IsA("UIListLayout") then
					return 0
				end
				local sizeY = child.Size.Y
				if sizeY.Scale == 0 and sizeY.Offset > 0 then
					return sizeY.Offset
				end
				return child.AbsoluteSize.Y
			end
			local function updateDashboardSize()
				if layout:IsA("UIGridLayout") then
					local maxHeight = 0
					for _, child in ipairs(dashboard:GetChildren()) do
						local h = getCardHeight(child)
						if h > maxHeight then
							maxHeight = h
						end
					end
					if maxHeight > 0 then
						local cellX = layout.CellSize.X
						if layout.CellSize.Y.Scale ~= 0 or layout.CellSize.Y.Offset ~= maxHeight then
							layout.CellSize = UDim2.new(cellX.Scale, cellX.Offset, 0, maxHeight)
						end
					end
				end
				local height = layout.AbsoluteContentSize.Y
				if height < 0 then
					height = 0
				end
				local x = dashboard.Size.X
				dashboard.Size = UDim2.new(x.Scale, x.Offset, 0, height + 6)
			end
			local function hookChild(child)
				if not (child and child:IsA("GuiObject")) then
					return
				end
				child:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateDashboardSize)
				child:GetPropertyChangedSignal("Size"):Connect(updateDashboardSize)
				child:GetPropertyChangedSignal("Visible"):Connect(updateDashboardSize)
			end
			for _, child in ipairs(dashboard:GetChildren()) do
				hookChild(child)
			end
			dashboard.ChildAdded:Connect(hookChild)
			dashboard.ChildRemoved:Connect(updateDashboardSize)
			updateDashboardSize()
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateDashboardSize)
		end
	end

	local environmentCard = dashboard and dashboard:FindFirstChild("Server")
	local feedbackCard = dashboard and dashboard:FindFirstChild("Friends")
	local detailsContainer, detailsLayout = ensureDetailsScroller(detailsHolder, dashboard)
	local hubInfoCard = nil
	if detailsContainer then
		hubInfoCard = detailsContainer:FindFirstChild("HubInfo") or (dashboard and dashboard:FindFirstChild("HubInfo"))
		if hubInfoCard and hubInfoCard.Parent ~= detailsContainer then
			hubInfoCard.Parent = detailsContainer
		end
		if not hubInfoCard then
			local templateCard = environmentCard or feedbackCard or discordCard or clientCard
			if templateCard then
				hubInfoCard = templateCard:Clone()
				hubInfoCard.Name = "HubInfo"
				hubInfoCard.Parent = detailsContainer
			end
		end
	end

	if dashboard then
		dashboard.Visible = true
	end
	if not environmentCard and dashboard then
		local templateCard = feedbackCard or discordCard or clientCard
		if templateCard then
			environmentCard = templateCard:Clone()
			environmentCard.Name = "Server"
			environmentCard.Parent = dashboard
		end
	end

	if environmentCard then
		environmentCard.Visible = true
		environmentCard.LayoutOrder = 1
	end
	if feedbackCard then
		feedbackCard.Visible = true
		feedbackCard.LayoutOrder = 2
	end
	if discordCard then
		discordCard.Visible = true
		discordCard.LayoutOrder = 3
	end
	if clientCard then
		clientCard.Visible = true
		clientCard.LayoutOrder = 4
	end

	if hubInfoCard then
		if detailsContainer and hubInfoCard.Parent ~= detailsContainer then
			hubInfoCard.Parent = detailsContainer
		end
		hubInfoCard.Size = UDim2.new(1, 0, hubInfoCard.Size.Y.Scale, hubInfoCard.Size.Y.Offset)
		hubInfoCard.Position = UDim2.new(0, 0, 0, 0)
		hubInfoCard.Visible = true
	end

	local feedbackUi = buildFeedbackCard(feedbackCard)
	local hubInfoUi = buildHubInfoCard(hubInfoCard)
	buildEnvironmentCard(environmentCard)

	if feedbackUi then
		feedbackUi.updateStatus()
	end
	if hubInfoUi and hubInfoUi.load then
		task.spawn(hubInfoUi.load)
	end

	if detailsLayout then
		if dashboard then
			dashboard.LayoutOrder = 1
		end
		if hubInfoCard then
			hubInfoCard.LayoutOrder = 2
		end
	end

end
end
