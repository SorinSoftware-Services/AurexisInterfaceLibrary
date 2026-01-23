-- src/components/home-tab.lua

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")


return function(Window, Aurexis, Elements, Navigation, GetIcon, Kwargify, tween, Release, isStudio)
    function Window:CreateHomeTab(HomeTabSettings)


	HomeTabSettings = Kwargify({
		Icon = 1,
		GoodExecutors = {"Krnl", "Delta", "Wave", "Seliware", "Velocity", "Volcano", "MacSploit", "Macsploit", "Bunni", "Hydrogen", "Volt", "Sirhut", "Potassium"},
		BadExecutors = {"Solara", "Xeno"},
		DetectedExecutors = {"Swift", "Valex", "Nucleus", "Codex"},
		DiscordInvite = "XC5hpQQvMX", -- Only the invite code, not the full URL.
		Supabase = {
			url = "https://udnvaneupscmrgwutamv.supabase.co",
			anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVkbnZhbmV1cHNjbXJnd3V0YW12Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ1NjEyMzAsImV4cCI6MjA3MDEzNzIzMH0.7duKofEtgRarIYDAoMfN7OEkOI_zgkG2WzAXZlxl5J0",
			feedbackFunction = "submit_feedback",
			hubInfoTable = "hub_metadata",
			hubInfoOrderColumn = "updated_at",
			supportedGamesTable = "games",
			supportedGamesFilter = "is_active=eq.true",
			supportedGamesLimit = 1000,
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
	local alreadyReady = HomeTabPage:GetAttribute("SorinHomeTabReady")
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

	if not alreadyReady then
		HomeTab:Activate()
		FirstTab = false
		HomeTabButton.Interact.MouseButton1Click:Connect(function()
			HomeTab:Activate()
		end)
	end

	-- === UI SETUP ===
	HomeTabPage.icon.ImageLabel.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
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


	local function findDescendantByName(root, name)
		if not root or type(name) ~= "string" or name == "" then
			return nil
		end
		local direct = root:FindFirstChild(name)
		if direct then
			return direct
		end
		local recursive = root:FindFirstChild(name, true)
		if recursive then
			return recursive
		end
		local needle = string.lower(name)
		for _, child in ipairs(root:GetDescendants()) do
			if string.lower(child.Name) == needle then
				return child
			end
		end
		return nil
	end

	local function coerceGuiContainer(node)
		if not node then
			return nil
		end
		if node:IsA("Frame") or node:IsA("ScrollingFrame") then
			return node
		end
		return nil
	end

	local detailsHolder = coerceGuiContainer(findDescendantByName(HomeTabPage, "detailsholder"))
	local dashboard = nil
	if detailsHolder then
		dashboard = coerceGuiContainer(findDescendantByName(detailsHolder, "dashboard"))
	end
	if not dashboard then
		dashboard = coerceGuiContainer(findDescendantByName(HomeTabPage, "dashboard"))
	end

	-- Fallback: detect parent containers by common card names
	if not dashboard then
		local cardNames = {"Server", "Friends", "Discord", "Client"}
		for _, cardName in ipairs(cardNames) do
			local card = findDescendantByName(HomeTabPage, cardName)
			if card and card.Parent then
				dashboard = coerceGuiContainer(card.Parent)
				if dashboard then
					break
				end
			end
		end
	end

	if not detailsHolder and dashboard and dashboard.Parent then
		detailsHolder = coerceGuiContainer(dashboard.Parent)
	end

	if not detailsHolder then
		warn("[HomeTab] detailsholder not found in Home UI. Check Aurexis UI asset hierarchy.")
	end
	if not dashboard then
		warn("[HomeTab] dashboard not found in Home UI. Check Aurexis UI asset hierarchy.")
	end

	local function chooseHubInfoHost()
		if detailsHolder then
			if detailsHolder:IsA("ScrollingFrame") then
				return detailsHolder, "scroll"
			end
			local listLayout = detailsHolder:FindFirstChildWhichIsA("UIListLayout")
			if listLayout then
				return detailsHolder, "list"
			end
			local hasGrid = detailsHolder:FindFirstChildWhichIsA("UIGridLayout") ~= nil
			if not hasGrid and not detailsHolder.ClipsDescendants then
				return detailsHolder, "absolute"
			end
		end
		return coerceGuiContainer(HomeTabPage), "absolute"
	end

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
				message = "Weak executor. Some scripts may fail."
			elseif table.find(HomeTabSettings.DetectedExecutors, exec) then
				color = Color3.fromRGB(255, 60, 60)
				message = "Executor is detected. Do not use it here."
			else
				color = Color3.fromRGB(200, 200, 200)
				message = "Executor not in list. Unknown compatibility."
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
			if typeof(setclipboard) == "function" then
				pcall(setclipboard, inviteUrl)
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
		return "SorinSoftware Services - Hub development\nNebulaSoftworks - LunaInterface Suite"
	end

	local function fetchSupportedGamesCount()
		local tableName = SupabaseConfig.supportedGamesTable
		if type(tableName) ~= "string" or tableName == "" then
			return nil, "Supported games table not configured"
		end

		local queryParts = { "select=id" }

		if type(SupabaseConfig.supportedGamesFilter) == "string" and SupabaseConfig.supportedGamesFilter ~= "" then
			table.insert(queryParts, SupabaseConfig.supportedGamesFilter)
		end

		local limit = tonumber(SupabaseConfig.supportedGamesLimit)
		if limit and limit > 0 then
			table.insert(queryParts, "limit=" .. tostring(limit))
		end

		local path = ("/rest/v1/%s?%s"):format(tableName, table.concat(queryParts, "&"))
		local response, err = supabaseRequest(path, "GET")
		if not response then
			return nil, err
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

	local function getMemory()
		if Stats and typeof(Stats.GetMemoryUsageMbForTag) == "function" then
			local ok, total = pcall(function()
				return Stats:GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.Total)
			end)
			if ok and typeof(total) == "number" then
				return string.format("%.1f MB", total)
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

		local content = createContentFrame(card, "FeedbackContent", true)
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
		statsBlock.BackgroundTransparency = 0.65

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

		ensureFpsSampler()
		task.spawn(function()
			while statsText and statsText.Parent do
				task.wait(1)
				local fpsValue = getFps()
				local text = table.concat({
					string.format("FPS: %s", fpsValue > 0 and tostring(fpsValue) or "N/A"),
					string.format("Ping: %s", getPing()),
					string.format("Upload: %s", getNetworkStat(NETWORK_STAT_ALIASES.upload, "KB/s")),
					string.format("Download: %s", getNetworkStat(NETWORK_STAT_ALIASES.download, "KB/s")),
					string.format("Memory: %s", getMemory()),
					string.format("Executor: %s", typeof(identifyexecutor) == "function" and identifyexecutor() or "Unknown"),
				}, "\n")
				statsText.Text = text
			end
		end)
	end

	local function buildHubInfoCard(parent, templateCard)
		if not parent then
			return nil
		end

		local card = parent:FindFirstChild("HubInfo")
		if not card then
			card = Instance.new("Frame")
		end

		card.Name = "HubInfo"
		card.Parent = parent
		card.Visible = true
		card.BorderSizePixel = 0

		local baseColor = Color3.fromRGB(20, 20, 26)
		local baseTransparency = 0
		if templateCard and templateCard:IsA("Frame") then
			baseColor = templateCard.BackgroundColor3
			baseTransparency = templateCard.BackgroundTransparency
		end

		card.BackgroundColor3 = baseColor
		card.BackgroundTransparency = baseTransparency

		local corner = card:FindFirstChildOfClass("UICorner")
		if not corner then
			corner = Instance.new("UICorner")
			corner.Parent = card
		end
		corner.CornerRadius = UDim.new(0, 8)

		local stroke = card:FindFirstChildOfClass("UIStroke")
		if not stroke then
			stroke = Instance.new("UIStroke")
			stroke.Parent = card
		end
		stroke.Color = Color3.fromRGB(64, 61, 76)
		stroke.Transparency = 0.55

		clearCard(card, {HubInfoContent = true})

		local titleLabel = card:FindFirstChild("Title")
		if not (titleLabel and titleLabel:IsA("TextLabel")) then
			titleLabel = Instance.new("TextLabel")
			titleLabel.Name = "Title"
			titleLabel.BackgroundTransparency = 1
			titleLabel.TextXAlignment = Enum.TextXAlignment.Left
			titleLabel.Font = Enum.Font.GothamSemibold
			titleLabel.TextSize = 14
			titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
			titleLabel.Size = UDim2.new(1, -16, 0, 18)
			titleLabel.Position = UDim2.new(0, 12, 0, 8)
			titleLabel.Parent = card
		end
		titleLabel.Text = "Hub Information"

		local content = createContentFrame(card, "HubInfoContent", true)
		local contentPadding = content:FindFirstChildOfClass("UIPadding")
		if contentPadding then
			contentPadding.PaddingTop = UDim.new(0, 4)
			contentPadding.PaddingBottom = UDim.new(0, 6)
		end

		local fontStrong = Enum.Font.GothamSemibold
		local fontBody = Enum.Font.Gotham

		local infoBlock = createBlock(content, 56, Color3.fromRGB(24, 24, 30), Color3.fromRGB(64, 61, 76))
		infoBlock.Name = "HubInfoBlock"
		infoBlock.LayoutOrder = 1

		local infoTitle = Instance.new("TextLabel")
		infoTitle.BackgroundTransparency = 1
		infoTitle.TextXAlignment = Enum.TextXAlignment.Left
		infoTitle.Font = fontStrong
		infoTitle.TextSize = 12
		infoTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
		infoTitle.Text = "Hub Version"
		infoTitle.Size = UDim2.new(1, -4, 0, 12)
		infoTitle.Parent = infoBlock

		local infoBody = Instance.new("TextLabel")
		infoBody.BackgroundTransparency = 1
		infoBody.TextXAlignment = Enum.TextXAlignment.Left
		infoBody.TextYAlignment = Enum.TextYAlignment.Top
		infoBody.TextWrapped = true
		infoBody.Font = fontBody
		infoBody.TextSize = 12
		infoBody.TextColor3 = Color3.fromRGB(190, 190, 200)
		infoBody.Position = UDim2.new(0, 0, 0, 14)
		infoBody.Size = UDim2.new(1, -4, 1, -16)
		infoBody.Text = "Loading version & info ..."
		infoBody.Parent = infoBlock

		local creditsBlock = createBlock(content, 56, Color3.fromRGB(24, 24, 30), Color3.fromRGB(64, 61, 76))
		creditsBlock.Name = "CreditsBlock"
		creditsBlock.LayoutOrder = 2

		local creditsTitle = Instance.new("TextLabel")
		creditsTitle.BackgroundTransparency = 1
		creditsTitle.TextXAlignment = Enum.TextXAlignment.Left
		creditsTitle.Font = fontStrong
		creditsTitle.TextSize = 12
		creditsTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
		creditsTitle.Text = "Credits"
		creditsTitle.Size = UDim2.new(1, -4, 0, 12)
		creditsTitle.Parent = creditsBlock

		local creditsBody = Instance.new("TextLabel")
		creditsBody.BackgroundTransparency = 1
		creditsBody.TextXAlignment = Enum.TextXAlignment.Left
		creditsBody.TextYAlignment = Enum.TextYAlignment.Top
		creditsBody.TextWrapped = true
		creditsBody.Font = fontBody
		creditsBody.TextSize = 12
		creditsBody.TextColor3 = Color3.fromRGB(190, 190, 200)
		creditsBody.Position = UDim2.new(0, 0, 0, 14)
		creditsBody.Size = UDim2.new(1, -4, 1, -16)
		creditsBody.Text = "SorinSoftware Services - Hub development\nNebulaSoftworks - LunaInterface Suite"
		creditsBody.Parent = creditsBlock

		local discordButton = Instance.new("TextButton")
		discordButton.Name = "HubDiscord"
		discordButton.AutoButtonColor = false
		discordButton.Text = "SorinSoftware Discord"
		discordButton.Font = fontStrong
		discordButton.TextSize = 13
		discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		discordButton.BackgroundColor3 = Color3.fromRGB(88, 108, 190)
		discordButton.Size = UDim2.new(1, 0, 0, 28)
		discordButton.LayoutOrder = 3
		discordButton.Parent = content

		local discordCorner = Instance.new("UICorner")
		discordCorner.CornerRadius = UDim.new(0, 6)
		discordCorner.Parent = discordButton

		local discordStroke = Instance.new("UIStroke")
		discordStroke.Transparency = 0.45
		discordStroke.Color = Color3.fromRGB(110, 140, 220)
		discordStroke.Parent = discordButton

		discordButton.MouseButton1Click:Connect(function()
			local inviteUrl = "https://discord.gg/" .. HomeTabSettings.DiscordInvite
			local copied = false
			if typeof(setclipboard) == "function" then
				copied = pcall(setclipboard, inviteUrl)
			end
			if copied then
				notify("Discord", "Invite link copied to clipboard.", "success")
			else
				notify("Discord", "Invite link: " .. inviteUrl, "info")
			end
		end)

		local function loadHubInfo()
			local defaultCreditsText = "SorinSoftware Services - Hub development\nNebulaSoftworks - LunaInterface Suite"

			infoBody.Text = "Loading version & info ..."
			creditsBody.Text = defaultCreditsText

			if not isSupabaseConfigured() then
				infoBody.Text = "Supabase not configured."
				return
			end
			if not hasExecutorRequest then
				infoBody.Text = "HTTP support missing (http_request)."
				return
			end

			local tableName = SupabaseConfig.hubInfoTable
			if type(tableName) ~= "string" or tableName == "" then
				infoBody.Text = "Invalid hub info table."
				return
			end

			local orderColumn = SupabaseConfig.hubInfoOrderColumn or "updated_at"
			local path = ("/rest/v1/%s?select=*&order=%s.desc&limit=1"):format(tableName, orderColumn)
			local response, err = supabaseRequest(path, "GET", nil, {
				Prefer = "return=representation",
			})

			if not response then
				infoBody.Text = "Backend request failed:\n" .. tostring(err)
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
				infoBody.Text = "No hub information found."
				return
			end

			local version = payload.version or payload.hub_version or Release or "unknown"
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

			local supportedCount = fetchSupportedGamesCount()
			if supportedCount then
				table.insert(infoLines, "Supported games: " .. tostring(supportedCount))
			end

			infoBody.Text = table.concat(infoLines, "\n")

			if payload.credits then
				creditsBody.Text = formatCredits(payload.credits)
			else
				creditsBody.Text = defaultCreditsText
			end
		end

		return {
			card = card,
			refresh = loadHubInfo,
		}
	end

	if dashboard then
		local layout = dashboard:FindFirstChildWhichIsA("UIGridLayout") or dashboard:FindFirstChildWhichIsA("UIListLayout")
		if layout then
			layout.SortOrder = Enum.SortOrder.LayoutOrder
		end
	end

	local environmentCard = dashboard and dashboard:FindFirstChild("Server")
	local feedbackCard = dashboard and dashboard:FindFirstChild("Friends")

	if environmentCard then
		environmentCard.LayoutOrder = 1
	end
	if feedbackCard then
		feedbackCard.LayoutOrder = 2
	end
	if discordCard then
		discordCard.LayoutOrder = 3
	end
	if clientCard then
		clientCard.LayoutOrder = 4
	end

	local feedbackUi = buildFeedbackCard(feedbackCard)
	buildEnvironmentCard(environmentCard)

	local hubInfoHost, hubInfoMode = chooseHubInfoHost()
	local hubInfoUi = buildHubInfoCard(hubInfoHost, environmentCard or feedbackCard or discordCard or clientCard)

	local function ensureHubInfoVisible(container, bottom)
		if not container or not container:IsA("ScrollingFrame") then
			return
		end
		local safeBottom = math.max(bottom or 0, container.AbsoluteSize.Y)
		container.CanvasSize = UDim2.new(0, 0, 0, safeBottom)
	end

	local function positionHubInfoCard()
		if not hubInfoUi or not hubInfoUi.card or not hubInfoHost or not dashboard then
			return
		end

		local card = hubInfoUi.card
		local cardHeight = 160

		if hubInfoMode == "list" then
			local holderLayout = hubInfoHost:FindFirstChildWhichIsA("UIListLayout")
			card.LayoutOrder = (dashboard.LayoutOrder or 1) + 1
			card.Size = UDim2.new(1, 0, 0, cardHeight)
		else
			local spacing = 10
			local offset = dashboard.AbsolutePosition - hubInfoHost.AbsolutePosition
			if hubInfoHost:IsA("ScrollingFrame") then
				offset = offset + hubInfoHost.CanvasPosition
			end
			local x = offset.X
			local y = offset.Y + dashboard.AbsoluteSize.Y + spacing
			card.Position = UDim2.new(0, x, 0, y)
			card.Size = UDim2.new(0, dashboard.AbsoluteSize.X, 0, cardHeight)

			local bottom = y + cardHeight + spacing
			ensureHubInfoVisible(hubInfoHost, bottom)
		end
	end

	if hubInfoUi then
		positionHubInfoCard()
		task.defer(positionHubInfoCard)
		task.delay(0.1, positionHubInfoCard)
		if dashboard then
			dashboard:GetPropertyChangedSignal("AbsoluteSize"):Connect(positionHubInfoCard)
			dashboard:GetPropertyChangedSignal("AbsolutePosition"):Connect(positionHubInfoCard)
		end
		if hubInfoHost then
			hubInfoHost:GetPropertyChangedSignal("AbsoluteSize"):Connect(positionHubInfoCard)
			hubInfoHost:GetPropertyChangedSignal("AbsolutePosition"):Connect(positionHubInfoCard)
		end
		if hubInfoUi.refresh then
			task.spawn(hubInfoUi.refresh)
		end
	end

	if feedbackUi then
		feedbackUi.updateStatus()
	end

end
end
