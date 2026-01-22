-- src/components/home-tab.lua

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
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
		GameManagerUrl = "https://scripts.sorinservice.online/sorin/game-manager",
		AutoExecScript = 'loadstring(game:HttpGet("https://scripts.sorinservice.online/sorin/script_hub.lua"))()',
		Supabase = {
			url = "https://udnvaneupscmrgwutamv.supabase.co",
			anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVkbnZhbmV1cHNjbXJnd3V0YW12Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ1NjEyMzAsImV4cCI6MjA3MDEzNzIzMH0.7duKofEtgRarIYDAoMfN7OEkOI_zgkG2WzAXZlxl5J0",
			feedbackFunction = "submit_feedback",
			gamesEndpoint = "/rest/v1/games",
			gamesQuery = "?select=name,place_id,universe_id,is_active&is_active=eq.true&order=name.asc",
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
		gamesEndpoint = "/rest/v1/games",
		gamesQuery = "?select=name,place_id,universe_id,is_active&is_active=eq.true&order=name.asc",
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

	local rootPlaceCache = {}
	local pendingTeleport = nil
	local teleportFailConn = nil

	local TeleportErrorMessages = {
		[Enum.TeleportResult.GameNotFound] = "Game not found or not public.",
		[Enum.TeleportResult.GameEnded] = "This game session ended.",
		[Enum.TeleportResult.GameFull] = "Server full. Try again.",
		[Enum.TeleportResult.Unauthorized] = "Teleport restricted (773).",
		[Enum.TeleportResult.NotAllowed] = "Teleport not allowed for this place.",
		[Enum.TeleportResult.TeleportDisabled] = "Teleport disabled for this place.",
		[Enum.TeleportResult.Failure] = "Teleport failed. Try again later.",
	}

	local function fetchRootPlaceId(universeId)
		if not universeId then
			return nil, "Missing universeId"
		end

		local response, err = httpRequest({
			Url = "https://games.roblox.com/v1/games?universeIds=" .. tostring(universeId),
			Method = "GET",
			Headers = {Accept = "application/json"},
		})

		if not response then
			return nil, err or "Request failed"
		end

		local data = decodeJson(response.Body)
		local record = type(data) == "table" and type(data.data) == "table" and data.data[1] or nil
		local rootPlaceId = record and record.rootPlaceId or nil

		if not rootPlaceId then
			return nil, "rootPlaceId missing"
		end

		return tonumber(rootPlaceId)
	end

	local function getRootPlaceId(universeId)
		if not universeId then
			return nil, "Missing universeId"
		end
		if rootPlaceCache[universeId] then
			return rootPlaceCache[universeId]
		end
		local rootId, err = fetchRootPlaceId(universeId)
		if rootId then
			rootPlaceCache[universeId] = rootId
			return rootId
		end
		return nil, err
	end

	local function formatTeleportFailure(result, message)
		local text = TeleportErrorMessages[result]
		if not text or text == "" then
			text = "Teleport failed."
		end
		if message and message ~= "" then
			text = text .. " (" .. tostring(message) .. ")"
		end
		return text
	end

	local function isUnauthorizedTeleport(result, message)
		if result == Enum.TeleportResult.Unauthorized then
			return true
		end
		if type(message) ~= "string" then
			return false
		end
		local lower = string.lower(message)
		return lower:find("unauthorized", 1, true) ~= nil
			or lower:find("different creator", 1, true) ~= nil
			or lower:find("teleport from this universe", 1, true) ~= nil
	end

	local function offerManualJoin(entry, fallbackPlaceId)
		local placeId = fallbackPlaceId
		if entry and entry.universeId then
			local rootId = getRootPlaceId(entry.universeId)
			if rootId then
				placeId = rootId
			end
		end
		if not placeId then
			return
		end
		local link = "roblox://placeId=" .. tostring(placeId)
		if typeof(setclipboard) == "function" then
			pcall(setclipboard, link)
			notify("Game Teleport", "Teleport blocked. Join link copied to clipboard.", "warning")
		else
			notify("Game Teleport", "Teleport blocked. Join via: " .. link, "warning")
		end
	end

	local function ensureTeleportFailHandler(teleportFunc)
		if teleportFailConn then
			return
		end
		teleportFailConn = TeleportService.TeleportInitFailed:Connect(function(player, result, message, placeId, gameId)
			if player ~= Players.LocalPlayer then
				return
			end
			if not pendingTeleport then
				return
			end

			local entry = pendingTeleport.entry
			local lastPlaceId = pendingTeleport.placeId

			if isUnauthorizedTeleport(result, message) then
				offerManualJoin(entry, lastPlaceId)
				pendingTeleport = nil
				return
			end

			if pendingTeleport.attemptedRoot then
				notify("Game Teleport", formatTeleportFailure(result, message), "error")
				pendingTeleport = nil
				return
			end

			if entry and entry.universeId then
				local rootId = getRootPlaceId(entry.universeId)
				if rootId and rootId ~= lastPlaceId then
					pendingTeleport.attemptedRoot = true
					pendingTeleport.placeId = rootId
					notify("Game Teleport", "Place restricted. Trying public entry...", "warning")
					teleportFunc(rootId)
					return
				end
			end

			notify("Game Teleport", formatTeleportFailure(result, message), "error")
			pendingTeleport = nil
		end)
	end

	local function resolveQueueOnTeleport()
		return (syn and syn.queue_on_teleport)
			or queue_on_teleport
			or (fluxus and fluxus.queue_on_teleport)
	end

	local function resolveAutoExecScript()
		if type(HomeTabSettings.AutoExecScript) == "string" and HomeTabSettings.AutoExecScript ~= "" then
			return HomeTabSettings.AutoExecScript
		end
		return 'loadstring(game:HttpGet("https://scripts.sorinservice.online/sorin/script_hub.lua"))()'
	end

	local function queueHubAutoExecute()
		local q = resolveQueueOnTeleport()
		if typeof(q) ~= "function" then
			return false, "queue_on_teleport is not available in this executor"
		end
		local scriptSource = resolveAutoExecScript()
		local ok, err = pcall(q, scriptSource)
		if not ok then
			return false, tostring(err)
		end
		return true
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
		local content
		for _, child in ipairs(card:GetChildren()) do
			if child.Name == name and (child:IsA("Frame") or child:IsA("ScrollingFrame")) then
				if not content then
					content = child
				else
					child:Destroy()
				end
			end
		end
		if not content then
			if allowScroll then
				content = Instance.new("ScrollingFrame")
			else
				content = Instance.new("Frame")
			end
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
			content.ScrollBarThickness = allowScroll and 4 or 0
			content.ScrollingDirection = Enum.ScrollingDirection.Y
			content.CanvasSize = UDim2.new(0, 0, 0, 0)
		end

		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0, 6)
		padding.PaddingRight = UDim.new(0, 6)
		padding.PaddingTop = UDim.new(0, 6)
		padding.PaddingBottom = UDim.new(0, 6)
		padding.Parent = content

		local layout = Instance.new("UIListLayout")
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Padding = UDim.new(0, 6)
		layout.Parent = content

		if content:IsA("ScrollingFrame") then
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 2)
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

	local function buildTeleportCard(card)
		if not card then
			return nil
		end

		clearCard(card, {TeleportContent = true})
		card.ClipsDescendants = true

		local titleLabel = card:FindFirstChild("Title")
		if titleLabel and titleLabel:IsA("TextLabel") then
			titleLabel.Text = "Game Teleport (Auto-Exec)"
		end

		local content = createContentFrame(card, "TeleportContent", true)
		local fontStrong = Enum.Font.GothamSemibold
		local fontBody = Enum.Font.Gotham
		local titleColor = (titleLabel and titleLabel.TextColor3) or Color3.fromRGB(240, 240, 240)

		local statsBlock = createBlock(content, 110, Color3.fromRGB(24, 24, 30), Color3.fromRGB(70, 60, 90))
		statsBlock.Name = "EnvironmentStats"
		statsBlock.LayoutOrder = 1

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

		local teleportButton = Instance.new("TextButton")
		teleportButton.Name = "TeleportButton"
		teleportButton.AutoButtonColor = false
		teleportButton.Text = "Teleport & Auto-Execute"
		teleportButton.Font = fontStrong
		teleportButton.TextSize = 14
		teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		teleportButton.BackgroundColor3 = Color3.fromRGB(165, 55, 120)
		teleportButton.Size = UDim2.new(1, 0, 0, 28)
		teleportButton.LayoutOrder = 2
		teleportButton.Parent = content

		local teleCorner = Instance.new("UICorner")
		teleCorner.CornerRadius = UDim.new(0, 6)
		teleCorner.Parent = teleportButton

		local teleStroke = Instance.new("UIStroke")
		teleStroke.Transparency = 0.35
		teleStroke.Color = Color3.fromRGB(190, 85, 150)
		teleStroke.Parent = teleportButton

		local teleGradient = Instance.new("UIGradient")
		teleGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 70, 135)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 40, 110)),
		})
		teleGradient.Rotation = 10
		teleGradient.Parent = teleportButton

		local selectLabel = Instance.new("TextLabel")
		selectLabel.Name = "SelectLabel"
		selectLabel.BackgroundTransparency = 1
		selectLabel.TextXAlignment = Enum.TextXAlignment.Left
		selectLabel.Font = fontStrong
		selectLabel.TextSize = 12
		selectLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		selectLabel.Text = "Select Game"
		selectLabel.Size = UDim2.new(1, 0, 0, 12)
		selectLabel.LayoutOrder = 3
		selectLabel.Parent = content

		local dropdownButton = Instance.new("TextButton")
		dropdownButton.Name = "GameSelect"
		dropdownButton.AutoButtonColor = false
		dropdownButton.Text = "Select a game"
		dropdownButton.Font = fontBody
		dropdownButton.TextSize = 13
		dropdownButton.TextColor3 = Color3.fromRGB(230, 230, 230)
		dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
		dropdownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
		dropdownButton.Size = UDim2.new(1, 0, 0, 28)
		dropdownButton.LayoutOrder = 4
		dropdownButton.Parent = content

		local dropdownCorner = Instance.new("UICorner")
		dropdownCorner.CornerRadius = UDim.new(0, 6)
		dropdownCorner.Parent = dropdownButton

		local dropdownStroke = Instance.new("UIStroke")
		dropdownStroke.Transparency = 0.5
		dropdownStroke.Color = Color3.fromRGB(64, 61, 76)
		dropdownStroke.Parent = dropdownButton

		local dropdownPadding = Instance.new("UIPadding")
		dropdownPadding.PaddingLeft = UDim.new(0, 8)
		dropdownPadding.PaddingRight = UDim.new(0, 20)
		dropdownPadding.Parent = dropdownButton

		local dropdownArrow = Instance.new("TextLabel")
		dropdownArrow.Name = "Arrow"
		dropdownArrow.BackgroundTransparency = 1
		dropdownArrow.Text = "v"
		dropdownArrow.Font = fontStrong
		dropdownArrow.TextSize = 13
		dropdownArrow.TextColor3 = Color3.fromRGB(200, 200, 200)
		dropdownArrow.Size = UDim2.new(0, 12, 1, 0)
		dropdownArrow.Position = UDim2.new(1, -16, 0, 0)
		dropdownArrow.Parent = dropdownButton

		local dropdownList = Instance.new("ScrollingFrame")
		dropdownList.Name = "GameList"
		dropdownList.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
		dropdownList.BorderSizePixel = 0
		dropdownList.Active = true
		dropdownList.ScrollingEnabled = true
		dropdownList.ScrollBarThickness = 4
		dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
		dropdownList.Size = UDim2.new(1, 0, 0, 0)
		dropdownList.Visible = false
		dropdownList.LayoutOrder = 5
		dropdownList.ClipsDescendants = true
		dropdownList.Parent = content

		local listCorner = Instance.new("UICorner")
		listCorner.CornerRadius = UDim.new(0, 6)
		listCorner.Parent = dropdownList

		local listStroke = Instance.new("UIStroke")
		listStroke.Transparency = 0.5
		listStroke.Color = Color3.fromRGB(64, 61, 76)
		listStroke.Parent = dropdownList

		local listLayout = Instance.new("UIListLayout")
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Padding = UDim.new(0, 4)
		listLayout.Parent = dropdownList

		local maxListHeight = 130

		local function getListHeight()
			local target = listLayout.AbsoluteContentSize.Y + 8
			if target < 28 then
				target = 28
			end
			if target > maxListHeight then
				target = maxListHeight
			end
			return target
		end

		listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			dropdownList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 4)
			if dropdownOpen then
				dropdownList.Size = UDim2.new(1, 0, 0, getListHeight())
			end
		end)

		local ui = {
			selected = nil,
			entries = {},
		}

		local dropdownOpen = false

		local function setDropdownOpen(state)
			dropdownOpen = state
			dropdownList.Visible = state
			dropdownList.Size = state and UDim2.new(1, 0, 0, getListHeight()) or UDim2.new(1, 0, 0, 0)
			dropdownArrow.Rotation = state and 180 or 0
		end

		local function setSelected(entry)
			ui.selected = entry
			if entry and entry.name then
				dropdownButton.Text = tostring(entry.name)
			else
				dropdownButton.Text = "Select a game"
			end
			setDropdownOpen(false)
		end

		local function setEntries(entries)
			ui.entries = entries or {}
			for _, child in ipairs(dropdownList:GetChildren()) do
				if child:IsA("TextButton") then
					child:Destroy()
				end
			end

			for index, entry in ipairs(ui.entries) do
				local option = Instance.new("TextButton")
				option.Name = tostring(entry.name or ("Game " .. index))
				option.AutoButtonColor = false
				if entry.placeId then
					option.Text = tostring(entry.name or ("Game " .. index))
				else
					option.Text = tostring(entry.name or ("Game " .. index)) .. " (info)"
				end
				option.Font = fontBody
				option.TextSize = 13
				option.TextColor3 = entry.placeId and Color3.fromRGB(220, 220, 220) or Color3.fromRGB(160, 160, 170)
				option.TextXAlignment = Enum.TextXAlignment.Left
				option.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
				option.Size = UDim2.new(1, -6, 0, 22)
				option.LayoutOrder = index
				option.Parent = dropdownList

				local optionCorner = Instance.new("UICorner")
				optionCorner.CornerRadius = UDim.new(0, 4)
				optionCorner.Parent = option

				option.MouseButton1Click:Connect(function()
					setSelected(entry)
					setDropdownOpen(false)
				end)
			end
		end

		dropdownButton.MouseButton1Click:Connect(function()
			setDropdownOpen(not dropdownOpen)
		end)

		local function teleportToPlace(placeId)
			local okTeleport, teleportErr = pcall(function()
				TeleportService:Teleport(placeId, Players.LocalPlayer)
			end)
			if not okTeleport then
				notify("Game Teleport", "Teleport failed: " .. tostring(teleportErr), "error")
				pendingTeleport = nil
				return false
			end
			return true
		end

		teleportButton.MouseButton1Click:Connect(function()
			local entry = ui.selected
			if not entry then
				notify("Game Teleport", "Select a game first.", "warning")
				return
			end
			if not entry.placeId then
				notify("Game Teleport", "No placeId available for this game.", "warning")
				return
			end

			local ok, err = queueHubAutoExecute()
			if not ok then
				notify("Game Teleport", "Auto-exec failed: " .. tostring(err), "warning")
				return
			end

			pendingTeleport = {
				entry = entry,
				placeId = entry.placeId,
				attemptedRoot = false,
			}
			ensureTeleportFailHandler(teleportToPlace)
			teleportToPlace(entry.placeId)
		end)

		return {
			setEntries = setEntries,
			setSelected = setSelected,
			getSelected = function()
				return ui.selected
			end,
		}
	end

	if dashboard then
		local layout = dashboard:FindFirstChildWhichIsA("UIGridLayout") or dashboard:FindFirstChildWhichIsA("UIListLayout")
		if layout then
			layout.SortOrder = Enum.SortOrder.LayoutOrder
		end
	end

	local teleportCard = dashboard and dashboard:FindFirstChild("Server")
	local feedbackCard = dashboard and dashboard:FindFirstChild("Friends")

	if teleportCard then
		teleportCard.LayoutOrder = 1
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
	local teleportUi = buildTeleportCard(teleportCard)

	local function buildEntriesFromManager(manager)
		local entries = {}
		local seen = {}

		local function addEntry(entry)
			if type(entry) ~= "table" then
				return
			end
			if not entry.placeId or not entry.name then
				return
			end
			local key = tostring(entry.placeId)
			if seen[key] then
				return
			end
			seen[key] = true
			table.insert(entries, {
				name = entry.name,
				placeId = entry.placeId,
				universeId = entry.universeId,
			})
		end

		if type(manager) == "table" then
			if type(manager.entries) == "table" then
				for _, entry in ipairs(manager.entries) do
					addEntry(entry)
				end
			elseif type(manager.byPlace) == "table" then
				for _, entry in pairs(manager.byPlace) do
					addEntry(entry)
				end
			end
		end

		table.sort(entries, function(a, b)
			return tostring(a.name) < tostring(b.name)
		end)

		return entries
	end

	local function normalizeBackendEntries(rawGames)
		local entries = {}
		if type(rawGames) ~= "table" then
			return entries
		end

		for index, entry in ipairs(rawGames) do
			if type(entry) == "table" then
				if entry.is_active == nil or entry.is_active == true then
					local name = entry.name or entry.Name or entry.title or entry.Title or ("Game " .. tostring(index))
					local placeId = tonumber(entry.place_id or entry.placeId or entry.placeid)
					local universeId = tonumber(entry.universe_id or entry.universeId or entry.universeid)
					table.insert(entries, {
						name = tostring(name),
						placeId = placeId,
						universeId = universeId,
					})
				end
			end
		end

		table.sort(entries, function(a, b)
			return tostring(a.name) < tostring(b.name)
		end)

		return entries
	end

	local function buildSupabaseGamesPath()
		local endpoint = SupabaseConfig.gamesEndpoint or "/rest/v1/games"
		local query = SupabaseConfig.gamesQuery or ""
		local path = endpoint
		if query ~= "" then
			if query:sub(1, 1) ~= "?" then
				path = path .. "?" .. query
			else
				path = path .. query
			end
		end
		return path
	end

	local function fetchSupabaseEntries()
		if not isSupabaseConfigured() then
			return nil, "Backend not configured"
		end

		local path = buildSupabaseGamesPath()
		local response, err = supabaseRequest(path, "GET", nil, {
			Prefer = "return=representation",
		})

		if not response then
			return nil, err or "Supabase request failed"
		end

		local data = decodeJson(response.Body)
		if type(data) ~= "table" then
			return nil, "Invalid backend response"
		end

		return normalizeBackendEntries(data)
	end

	local function loadGameEntries()
		if type(HomeTabSettings.GameEntries) == "table" then
			local entries = {}
			for _, entry in ipairs(HomeTabSettings.GameEntries) do
				if type(entry) == "table" and entry.name then
					table.insert(entries, {
						name = entry.name,
						placeId = entry.placeId,
						universeId = entry.universeId,
					})
				end
			end
			return entries
		end

		local backendEntries, backendErr = fetchSupabaseEntries()
		if type(backendEntries) ~= "table" then
			backendEntries = {}
			if backendErr then
				warn("[HomeTab] Supabase games fetch failed:", backendErr)
			end
		end

		local managerEntries = {}
		local missingTeleport = true
		for _, entry in ipairs(backendEntries) do
			if entry.placeId then
				missingTeleport = false
				break
			end
		end

		local url = HomeTabSettings.GameManagerUrl
		if (#backendEntries == 0 or missingTeleport) and type(url) == "string" and url ~= "" then
			local ok, body = pcall(function()
				return game:HttpGet(url)
			end)
			if ok and type(body) == "string" then
				local chunk, err = loadstring(body)
				if not chunk then
					warn("[HomeTab] Game manager load failed:", err)
				else
					local okRun, manager = pcall(chunk)
					if not okRun then
						warn("[HomeTab] Game manager exec failed:", manager)
					else
						managerEntries = buildEntriesFromManager(manager)
					end
				end
			end
		end

		if #backendEntries > 0 and #managerEntries > 0 then
			local managerByName = {}
			for _, entry in ipairs(managerEntries) do
				managerByName[string.lower(tostring(entry.name))] = entry
			end
			for _, entry in ipairs(backendEntries) do
				if not entry.placeId then
					local match = managerByName[string.lower(tostring(entry.name))]
					if match then
						entry.placeId = match.placeId
						entry.universeId = entry.universeId or match.universeId
					end
				end
			end
		end

		if #backendEntries == 0 then
			return managerEntries
		end

		return backendEntries
	end

	local function selectDefaultEntry(entries)
		for _, entry in ipairs(entries) do
			if entry.placeId == game.PlaceId then
				return entry
			end
		end
		for _, entry in ipairs(entries) do
			if entry.placeId then
				return entry
			end
		end
		return entries[1]
	end

	if teleportUi then
		task.spawn(function()
			local entries = loadGameEntries()
			if #entries == 0 then
				entries = {
					{name = "Current Game", placeId = game.PlaceId},
				}
			end
			teleportUi.setEntries(entries)
			teleportUi.setSelected(selectDefaultEntry(entries))
		end)
	end

	if feedbackUi then
		feedbackUi.updateStatus()
	end

end
end
