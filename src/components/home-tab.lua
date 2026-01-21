-- src/components/home-tab.lua

local Players     = game:GetService("Players")
local HttpService = game:GetService("HttpService")


return function(Window, Aurexis, Elements, Navigation, GetIcon, Kwargify, tween, Release, isStudio)
    function Window:CreateHomeTab(HomeTabSettings)


	HomeTabSettings = Kwargify({
		Icon = 1,
		GoodExecutors = {"Krnl", "Delta", "Wave", "Seliware", "Velocity", "Volcano", "MacSploit", "Macsploit", "Bunni", "Hydrogen", "Volt", "Sirhut", "Potassium"},
		BadExecutors = {"Solara", "Xeno"},
		DetectedExecutors = {"Swift", "Valex", "Nucleus", "Codex"},
		DiscordInvite = "XC5hpQQvMX" -- Only the invite code, not the full URL.
	}, HomeTabSettings or {})

	local HomeTab = {}

	local HomeTabButton = Navigation.Tabs.Home
	HomeTabButton.Visible = true
	if HomeTabSettings.Icon == 2 then
		HomeTabButton.ImageLabel.Image = GetIcon("dashboard", "Material")
	end

	local HomeTabPage = Elements.Home
	HomeTabPage.Visible = true

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

	local function setCardTextSizes(root, titleSize, valueSize, subtitleSize)
		if not root then
			return
		end
		for _, desc in ipairs(root:GetDescendants()) do
			if desc:IsA("TextLabel") then
				if desc.Name == "Title" and titleSize then
					desc.TextSize = titleSize
				elseif desc.Name == "Value" and valueSize then
					desc.TextSize = valueSize
				elseif (desc.Name == "Subtitle" or desc.Name == "Description") and subtitleSize then
					desc.TextSize = subtitleSize
				end
			end
		end
	end

	local fontsAdjusted = false

	local function applyCardTextOverrides()
		if fontsAdjusted then
			return
		end
		local detailsHolder = HomeTabPage:FindFirstChild("detailsholder")
		local dashboard = detailsHolder and detailsHolder:FindFirstChild("dashboard")
		if not dashboard then
			return
		end
		local friendsCard = dashboard:FindFirstChild("Friends", true)
		if friendsCard then
			setCardTextSizes(friendsCard, 16, 19, 14)
		end
		local serverCard = dashboard:FindFirstChild("Server", true)
		if serverCard then
			setCardTextSizes(serverCard, 16, 18, 14)
		end
		if friendsCard or serverCard then
			fontsAdjusted = true
		end
	end

	local exec = (isStudio and "Studio (Debug)" or identifyexecutor()) or "Unknown"
	HomeTabPage.detailsholder.dashboard.Client.Title.Text =  "You are using " .. exec

	if isStudio then
		HomeTabPage.detailsholder.dashboard.Client.Subtitle.Text = "Aurexis Interface Library - Debugging Mode"
		HomeTabPage.detailsholder.dashboard.Client.Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	else
		local color, message
		if table.find(HomeTabSettings.GoodExecutors, exec) then
			color = Color3.fromRGB(80, 255, 80)
			message = "Good Executor. I think u can use all Scripts here."
		elseif table.find(HomeTabSettings.BadExecutors, exec) then
			color = Color3.fromRGB(255, 180, 50)
			message = "Weak executor. Some scripts will not work"
		elseif table.find(HomeTabSettings.DetectedExecutors, exec) then
			color = Color3.fromRGB(255, 60, 60)
			message = "This executor is detected. Please don´t use them!"
		else
			color = Color3.fromRGB(200, 200, 200)
			message = "This executor isn't in my list. No idea if it's good or bad."
		end

		HomeTabPage.detailsholder.dashboard.Client.Subtitle.Text = message
		HomeTabPage.detailsholder.dashboard.Client.Subtitle.TextColor3 = color
	end


	-- === DISCORD BUTTON ===
	HomeTabPage.detailsholder.dashboard.Discord.Interact.MouseButton1Click:Connect(function()
		setclipboard("https://discord.gg/" .. HomeTabSettings.DiscordInvite)
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


	-- === FRIENDS / STATS HANDLING ===
	local Player = Players.LocalPlayer
	local friendsCooldown = 0
	local Localization = game:GetService("LocalizationService")

	local function getPing()
		return math.clamp(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue(), 10, 700)
	end

	local function checkFriends()
		if friendsCooldown ~= 0 then
			friendsCooldown -= 1
			return
		end

		if not HomeTabPage or not HomeTabPage.Parent then
			return
		end

		local detailsHolder = HomeTabPage:FindFirstChild("detailsholder")
		local dashboard = detailsHolder and detailsHolder:FindFirstChild("dashboard")
		local friendsGui = dashboard and dashboard:FindFirstChild("Friends")
		if not friendsGui then
			return
		end

		applyCardTextOverrides()

		friendsCooldown = 25

		local playersFriends = {}
		local friendsInTotal, onlineFriends, friendsInGame = 0, 0, 0

		local list = Players:GetFriendsAsync(Player.UserId)
		while true do
			for _, data in list:GetCurrentPage() do
				friendsInTotal += 1
				table.insert(playersFriends, data)
			end
			if list.IsFinished then
				break
			else
				list:AdvanceToNextPageAsync()
			end
		end

		for _, v in pairs(Player:GetFriendsOnline()) do
			onlineFriends += 1
		end

		for _, v in pairs(playersFriends) do
			if Players:FindFirstChild(v.Username) then
				friendsInGame += 1
			end
		end

		friendsGui.All.Value.Text = tostring(friendsInTotal) .. " friends"
		friendsGui.Offline.Value.Text = tostring(friendsInTotal - onlineFriends) .. " friends"
		friendsGui.Online.Value.Text = tostring(onlineFriends) .. " friends"
		friendsGui.InGame.Value.Text = tostring(friendsInGame) .. " friends"
	end

	local function format(Int)
		return string.format("%02i", Int)
	end

	local function convertToHMS(Seconds)
		local Minutes = (Seconds - Seconds % 60) / 60
		Seconds -= Minutes * 60
		local Hours = (Minutes - Minutes % 60) / 60
		Minutes -= Hours * 60
		return format(Hours) .. ":" .. format(Minutes) .. ":" .. format(Seconds)
	end

	local diagnosticsCard
	local diagnosticsDefaults = {}
	local diagnosticsStatusSignature

	local diagnosticsStyles = {
		clear = {
			label = "All clear - no performance issues detected.",
			valueColor = Color3.fromRGB(120, 255, 150),
			strokeColor = Color3.fromRGB(120, 255, 150),
			strokeTransparency = 0.35,
		},
		pending = {
			label = "Sending diagnostics to backend ...",
			valueColor = Color3.fromRGB(255, 205, 90),
			strokeColor = Color3.fromRGB(255, 205, 90),
			strokeTransparency = 0.25,
		},
		issues = {
			label = "Diagnostics available - potential performance issues found.",
			valueColor = Color3.fromRGB(255, 170, 95),
			strokeColor = Color3.fromRGB(255, 170, 95),
			strokeTransparency = 0.2,
		},
		error = {
			label = "Diagnostics upload failed.",
			valueColor = Color3.fromRGB(255, 110, 110),
			strokeColor = Color3.fromRGB(255, 110, 110),
			strokeTransparency = 0.2,
		},
	}

	local function getBackendStatus()
		local status = Window and Window.PerformanceBackendStatus
		if typeof(status) == "table" then
			return status
		end
		return {
			state = "clear",
			summary = nil,
			lastUpdated = nil,
			error = nil,
		}
	end

	local function ensureDiagnosticsCard(serverInfo)
		if diagnosticsCard and diagnosticsCard.Parent == serverInfo then
			return true
		end

		diagnosticsCard = nil
		if not serverInfo then
			return false
		end

		local function normalize(value)
			if typeof(value) == "string" then
				return string.lower(value)
			end
			return ""
		end

		local function pickDiagnosticsCard()
			local fallback = nil
			for _, child in ipairs(serverInfo:GetChildren()) do
				if child:IsA("Frame") and child.Name ~= "Template" then
					local nameLower = normalize(child.Name)
					local titleLabel = child:FindFirstChild("Title")
					local titleText = nil
					if titleLabel and titleLabel:IsA("TextLabel") then
						titleText = titleLabel.Text
					end
					local titleLower = normalize(titleText)
					if string.find(titleLower, "diagnostic") or string.find(nameLower, "diagnostic") then
						return child
					end
					if not fallback and (string.find(titleLower, "join") or string.find(nameLower, "join")) then
						fallback = child
					end
				end
			end
			return fallback
		end

		diagnosticsCard = pickDiagnosticsCard()
		if not diagnosticsCard then
			return false
		end

		diagnosticsStatusSignature = nil

		diagnosticsDefaults = {
			background = diagnosticsCard.BackgroundColor3,
			titleColor = nil,
			valueColor = nil,
			strokeColor = nil,
			strokeTransparency = nil,
		}

		local titleLabel = diagnosticsCard:FindFirstChild("Title")
		if titleLabel and titleLabel:IsA("TextLabel") then
			diagnosticsDefaults.titleColor = titleLabel.TextColor3
			titleLabel.Text = "Diagnostics"
			titleLabel.RichText = false
		end

		local valueLabel = diagnosticsCard:FindFirstChild("Value")
		if not (valueLabel and valueLabel:IsA("TextLabel")) then
			for _, child in ipairs(diagnosticsCard:GetChildren()) do
				if child:IsA("TextLabel") and child.Name ~= "Title" then
					valueLabel = child
					break
				end
			end
		end
		if valueLabel and valueLabel:IsA("TextLabel") then
			diagnosticsDefaults.valueColor = valueLabel.TextColor3
			valueLabel.TextWrapped = true
			valueLabel.RichText = false
			valueLabel.Text = "Clear"
		end

		local uiStroke = diagnosticsCard:FindFirstChildWhichIsA("UIStroke")
		if uiStroke then
			diagnosticsDefaults.strokeColor = uiStroke.Color
			diagnosticsDefaults.strokeTransparency = uiStroke.Transparency
		end

		local interact = diagnosticsCard:FindFirstChild("Interact")
		if interact and interact:IsA("GuiButton") then
			interact.AutoButtonColor = false
			interact.Active = false
			interact.Visible = false
		end

		return true
	end

	local function buildDiagnosticsText(status, style)
		local state = status.state or "clear"
		local summaryText

		if state == "issues" then
			local summary = typeof(status.summary) == "string" and status.summary or nil
			if summary and summary ~= "" then
				summaryText = summary
			else
				summaryText = "Performance irregularities were captured."
			end
			summaryText = summaryText .. "\nOpen the Hub Info tab for detailed logs."
		elseif state == "error" then
			summaryText = "Diagnostics upload failed."
			if status.error and tostring(status.error) ~= "" then
				summaryText = summaryText .. "\n" .. tostring(status.error)
			end
			summaryText = summaryText .. "\nOpen the Hub Info tab to retry."
		else
			summaryText = style.label
			if state == "pending" and typeof(status.summary) == "string" and status.summary ~= "" then
				summaryText = string.format("%s\n(%s)", summaryText, status.summary)
			end
		end

		if status.lastUpdated then
			local okDate, timestamp = pcall(os.date, "%H:%M:%S", status.lastUpdated)
			if okDate and timestamp then
				summaryText = string.format("%s\nUpdated %s", summaryText, timestamp)
			end
		end

		return summaryText
	end

	local function applyDiagnosticsStatus(serverInfo)
		if not ensureDiagnosticsCard(serverInfo) then
			return
		end

		local status = getBackendStatus()
		local state = status.state or "clear"
		local style = diagnosticsStyles[state] or diagnosticsStyles.clear
		local signature = string.format(
			"%s|%s|%s|%s",
			tostring(state),
			tostring(status.summary or ""),
			tostring(status.error or ""),
			tostring(status.lastUpdated or "")
		)

		if diagnosticsStatusSignature == signature then
			return
		end
		diagnosticsStatusSignature = signature

		local titleLabel = diagnosticsCard:FindFirstChild("Title")
		local valueLabel = diagnosticsCard:FindFirstChild("Value")
		local uiStroke = diagnosticsCard:FindFirstChildWhichIsA("UIStroke")

		if diagnosticsDefaults.background then
			diagnosticsCard.BackgroundColor3 = diagnosticsDefaults.background
		end

		if titleLabel and titleLabel:IsA("TextLabel") then
			titleLabel.TextColor3 = style.titleColor or diagnosticsDefaults.titleColor or titleLabel.TextColor3
		end

		if valueLabel and valueLabel:IsA("TextLabel") then
			valueLabel.TextColor3 = style.valueColor or diagnosticsDefaults.valueColor or valueLabel.TextColor3
			valueLabel.Text = buildDiagnosticsText(status, style)
		end

		if uiStroke then
			uiStroke.Color = style.strokeColor or diagnosticsDefaults.strokeColor or uiStroke.Color
			uiStroke.Transparency = style.strokeTransparency or diagnosticsDefaults.strokeTransparency or uiStroke.Transparency
		end
	end

		coroutine.wrap(function()
	local refreshTimer = 0

	while task.wait(0.5) do
		if not HomeTabPage or not HomeTabPage.Parent then
			break
		end

		local detailsHolder = HomeTabPage:FindFirstChild("detailsholder")
		local dashboard = detailsHolder and detailsHolder:FindFirstChild("dashboard")
		if not dashboard then
			break
		end

		local serverInfo = dashboard:FindFirstChild("Server")
		if not serverInfo then
			break
		end

		local friendsGui = dashboard:FindFirstChild("Friends")
		if not friendsGui then
			break
		end

		applyCardTextOverrides()

		-- Serverinformationen aktualisieren
		serverInfo.Players.Value.Text = #Players:GetPlayers() .. " playing"
		serverInfo.MaxPlayers.Value.Text = Players.MaxPlayers .. " players can join this server"

		serverInfo.Latency.Value.Text =
			isStudio and tostring(math.round((Players.LocalPlayer:GetNetworkPing() * 2) / 0.01)) .. "ms"
			or tostring(math.floor(getPing())) .. "ms"

		serverInfo.Time.Value.Text = convertToHMS(time())
		local okRegion, regionResult = pcall(function()
			return Localization:GetCountryRegionForPlayerAsync(Players.LocalPlayer)
		end)
		serverInfo.Region.Value.Text = okRegion and tostring(regionResult) or "N/A"

		applyDiagnosticsStatus(serverInfo)

		-- Freunde-Check alle 30 Sekunden (bei Rate-Limit-Fehler auf 60s erhöhen)
		if refreshTimer <= 0 then
			task.spawn(function()
				local ok, err = pcall(checkFriends)
				if not ok then
					if string.find(tostring(err), "429") then
						warn("[HomeTab] Rate limit hit, pausing 60 s")
						refreshTimer = 60
					else
						warn("[HomeTab] Friend check failed:", err)
						refreshTimer = 30
					end
				else
					refreshTimer = 30
				end
			end)
		else
			refreshTimer -= 0.5
		end
	end
end)()

end
end 
