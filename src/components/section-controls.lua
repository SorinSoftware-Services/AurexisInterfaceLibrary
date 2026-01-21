local function attachSectionControls(ctx)
	local Section = ctx.Section
	local TabPage = ctx.TabPage
	local Elements = ctx.Elements
	local TweenService = ctx.TweenService
	local RunService = ctx.RunService
	local UserInputService = ctx.UserInputService
	local Kwargify = ctx.Kwargify
	local RemoveTable = ctx.RemoveTable
	local unpackt = ctx.unpackt
	local Aurexis = ctx.Aurexis
	local AurexisUI = ctx.AurexisUI
	local Window = ctx.Window
	local tween = ctx.tween
	local Players = ctx.Players

-- Divider
	function Section:CreateDivider()
		TabPage.Position = UDim2.new(0,0,0,28)
		local b = Elements.Template.Divider:Clone()
		b.Parent = TabPage
		b.Size = UDim2.new(1,0,0,18)
		b.Line.BackgroundTransparency = 1
		tween(b.Line, {BackgroundTransparency = 0})
	end

	-- Button
	function Section:CreateButton(ButtonSettings)
		TabPage.Position = UDim2.new(0,0,0,28)

		ButtonSettings = Kwargify({
			Name = "Button",
			Description = nil,
			Callback = function()

			end,
		}, ButtonSettings or {})

		local ButtonV = {
			Hover = false,
			Settings = ButtonSettings
		}


		local Button
		if ButtonSettings.Description == nil and ButtonSettings.Description ~= "" then
			Button = Elements.Template.Button:Clone()
		else
			Button = Elements.Template.ButtonDesc:Clone()
		end
		Button.Name = ButtonSettings.Name
		Button.Title.Text = ButtonSettings.Name
		if ButtonSettings.Description ~= nil and ButtonSettings.Description ~= "" then
			Button.Desc.Text = ButtonSettings.Description
		end
		Button.Visible = true
		Button.Parent = TabPage

		Button.UIStroke.Transparency = 1
		Button.Title.TextTransparency = 1
		if ButtonSettings.Description ~= nil and ButtonSettings.Description ~= "" then
			Button.Desc.TextTransparency = 1
		end

		TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
		TweenService:Create(Button.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
		TweenService:Create(Button.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	
		if ButtonSettings.Description ~= nil and ButtonSettings.Description ~= "" then
			TweenService:Create(Button.Desc, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	
		end

		Button.Interact["MouseButton1Click"]:Connect(function()
			local Success,Response = pcall(ButtonSettings.Callback)

			if not Success then
				TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
				TweenService:Create(Button.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				Button.Title.Text = "Callback Error"
				print("Aurexis Interface Library | "..ButtonSettings.Name.." Callback Error " ..tostring(Response))
				wait(0.5)
				Button.Title.Text = ButtonSettings.Name
				TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
				TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
				TweenService:Create(Button.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			else
				tween(Button.UIStroke, {Color = Color3.fromRGB(136, 131, 163)})
				wait(0.2)
				if ButtonV.Hover then
					tween(Button.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
				else
					tween(Button.UIStroke, {Color = Color3.fromRGB(64,61,76)})
				end
			end
		end)

		Button["MouseEnter"]:Connect(function()
			ButtonV.Hover = true
			tween(Button.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
		end)

		Button["MouseLeave"]:Connect(function()
			ButtonV.Hover = false
			tween(Button.UIStroke, {Color = Color3.fromRGB(64,61,76)})
		end)

		function ButtonV:Set(ButtonSettings2)
			ButtonSettings2 = Kwargify({
				Name = ButtonSettings.Name,
				Description = ButtonSettings.Description,
				Callback = ButtonSettings.Callback
			}, ButtonSettings2 or {})

			ButtonSettings = ButtonSettings2
			ButtonV.Settings = ButtonSettings2

			Button.Name = ButtonSettings.Name
			Button.Title.Text = ButtonSettings.Name
			if ButtonSettings.Description ~= nil and ButtonSettings.Description ~= "" and Button.Desc ~= nil then
				Button.Desc.Text = ButtonSettings.Description
			end
		end

		function ButtonV:Destroy()
			Button.Visible = false
			Button:Destroy()
		end

		return ButtonV
	end

	-- Label
	function Section:CreateLabel(LabelSettings)
		TabPage.Position = UDim2.new(0,0,0,28)

		local LabelV = {}

		LabelSettings = Kwargify({
			Text = "Label",
			Style = 1
		}, LabelSettings or {}) 

		LabelV.Settings = LabelSettings

		local Label
		if LabelSettings.Style == 1 then
			Label = Elements.Template.Label:Clone()
		elseif LabelSettings.Style == 2 then
			Label = Elements.Template.Info:Clone()
		elseif LabelSettings.Style == 3 then
			Label = Elements.Template.Warn:Clone()
		end

		Label.Text.Text = LabelSettings.Text
		Label.Visible = true
		Label.Parent = TabPage

		Label.BackgroundTransparency = 1
		Label.UIStroke.Transparency = 1
		Label.Text.TextTransparency = 1

		if LabelSettings.Style ~= 1 then
			TweenService:Create(Label, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.8}):Play()
		else
			TweenService:Create(Label, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
		end
		TweenService:Create(Label.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
		TweenService:Create(Label.Text, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

		function LabelV:Set(NewLabel)
			LabelSettings.Text = NewLabel
			LabelV.Settings = LabelSettings
			Label.Text.Text = NewLabel
		end

		function LabelV:Destroy()
			Label.Visible = false
			Label:Destroy()
		end

		return LabelV
	end

	-- Paragraph
	function Section:CreateParagraph(ParagraphSettings)
		TabPage.Position = UDim2.new(0,0,0,28)

		ParagraphSettings = Kwargify({
			Title = "Paragraph",
			Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
		}, ParagraphSettings or {})

		local ParagraphV = {
			Settings = ParagraphSettings
		}

		local Paragraph = Elements.Template.Paragraph:Clone()
		Paragraph.Title.Text = ParagraphSettings.Title
		Paragraph.Text.Text = ParagraphSettings.Text
		Paragraph.Visible = true
		Paragraph.Parent = TabPage

		Paragraph.BackgroundTransparency = 1
		Paragraph.UIStroke.Transparency = 1
		Paragraph.Title.TextTransparency = 1
		Paragraph.Text.TextTransparency = 1

		TweenService:Create(Paragraph, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
		TweenService:Create(Paragraph.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
		TweenService:Create(Paragraph.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	
		TweenService:Create(Paragraph.Text, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

		function ParagraphV:Update()
			Paragraph.Text.Size = UDim2.new(Paragraph.Text.Size.X.Scale, Paragraph.Text.Size.X.Offset, 0, math.huge)
			Paragraph.Text.Size = UDim2.new(Paragraph.Text.Size.X.Scale, Paragraph.Text.Size.X.Offset, 0, Paragraph.Text.TextBounds.Y)
			tween(Paragraph, {Size = UDim2.new(Paragraph.Size.X.Scale, Paragraph.Size.X.Offset, 0, Paragraph.Text.TextBounds.Y + 40)})
		end

		function ParagraphV:Set(NewParagraphSettings)

			NewParagraphSettings = Kwargify({
				Title = ParagraphSettings.Title,
				Text = ParagraphSettings.Text
			}, NewParagraphSettings or {})

			ParagraphV.Settings = NewParagraphSettings

			Paragraph.Title.Text = NewParagraphSettings.Title
			Paragraph.Text.Text = NewParagraphSettings.Text

			ParagraphV:Update()

		end

		function ParagraphV:Destroy()
			Paragraph.Visible = false
			Paragraph:Destroy()
		end

		ParagraphV:Update()

		ParagraphV.Instance = Paragraph

		function ParagraphV:SetVisible(isVisible)
			Paragraph.Visible = isVisible and true or false
		end

		return ParagraphV
	end

	-- Slider
	function Section:CreateSlider(SliderSettings, Flag)
		TabPage.Position = UDim2.new(0,0,0,28)
		local SliderV = { IgnoreConfig = false, Class = "Slider", Settings = SliderSettings }

		SliderSettings = Kwargify({
			Name = "Slider",
			Range = {0, 200},
			Increment = 1,
			CurrentValue = 100,
			Callback = function(Value)

			end,
		}, SliderSettings or {})

		local SLDragging = false
		local Slider = Elements.Template.Slider:Clone()
		Slider.Name = SliderSettings.Name .. " - Slider"
		Slider.Title.Text = SliderSettings.Name
		Slider.Visible = true
		Slider.Parent = TabPage

		Slider.BackgroundTransparency = 1
		Slider.UIStroke.Transparency = 1
		Slider.Title.TextTransparency = 1

		TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
		TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
		TweenService:Create(Slider.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

		Slider.Main.Progress.Size =	UDim2.new(0, Slider.Main.AbsoluteSize.X * ((SliderSettings.CurrentValue + SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])) > 5 and Slider.Main.AbsoluteSize.X * (SliderSettings.CurrentValue / (SliderSettings.Range[2] - SliderSettings.Range[1])) or 5, 1, 0)

		Slider.Value.Text = tostring(SliderSettings.CurrentValue)
		SliderV.CurrentValue = Slider.Value.Text

		SliderSettings.Callback(SliderSettings.CurrentValue)

		Slider["MouseEnter"]:Connect(function()
			tween(Slider.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
		end)

		Slider["MouseLeave"]:Connect(function()
			tween(Slider.UIStroke, {Color = Color3.fromRGB(64,61,76)})
		end)

		Slider.Interact.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
				SLDragging = true 
			end 
		end)

		Slider.Interact.InputEnded:Connect(function(Input) 
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
				SLDragging = false 
			end 
		end)

		Slider.Interact.MouseButton1Down:Connect(function()
			local Current = Slider.Main.Progress.AbsolutePosition.X + Slider.Main.Progress.AbsoluteSize.X
			local Start = Current
			local Location
			local Loop; Loop = RunService.Stepped:Connect(function()
				if SLDragging then
					Location = UserInputService:GetMouseLocation().X
					Current = Current + 0.025 * (Location - Start)

					if Location < Slider.Main.AbsolutePosition.X then
						Location = Slider.Main.AbsolutePosition.X
					elseif Location > Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X then
						Location = Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X
					end

					if Current < Slider.Main.AbsolutePosition.X + 5 then
						Current = Slider.Main.AbsolutePosition.X + 5
					elseif Current > Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X then
						Current = Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X
					end

					if Current <= Location and (Location - Start) < 0 then
						Start = Location
					elseif Current >= Location and (Location - Start) > 0 then
						Start = Location
					end
					Slider.Main.Progress.Size = UDim2.new(0, Location - Slider.Main.AbsolutePosition.X, 1, 0)
					local NewValue = SliderSettings.Range[1] + (Location - Slider.Main.AbsolutePosition.X) / Slider.Main.AbsoluteSize.X * (SliderSettings.Range[2] - SliderSettings.Range[1])

					NewValue = math.floor(NewValue / SliderSettings.Increment + 0.5) * (SliderSettings.Increment * 10000000) / 10000000

					Slider.Value.Text = tostring(NewValue)

					if SliderSettings.CurrentValue ~= NewValue then
						local Success, Response = pcall(function()
							SliderSettings.Callback(NewValue)
						end)
						if not Success then
							TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
							TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
							TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
							Slider.Title.Text = "Callback Error"
							print("Aurexis Interface Library | "..SliderSettings.Name.." Callback Error " ..tostring(Response))
							wait(0.5)
							Slider.Title.Text = SliderSettings.Name
							TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
							TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
							TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
						end

						SliderSettings.CurrentValue = NewValue
						SliderV.CurrentValue = SliderSettings.CurrentValue
						-- Aurexis.Flags[SliderSettings.Flag] = SliderSettings
					end
				else
					TweenService:Create(Slider.Main.Progress, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, false), {Size = UDim2.new(0, Location - Slider.Main.AbsolutePosition.X > 5 and Location - Slider.Main.AbsolutePosition.X or 5, 1, 0)}):Play()
					Loop:Disconnect()
				end
			end)
		end)

		local function Set(NewVal, bleh)

			NewVal = NewVal or SliderSettings.CurrentValue

			TweenService:Create(Slider.Main.Progress, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {Size = UDim2.new(0, Slider.Main.AbsoluteSize.X * ((NewVal + SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])) > 5 and Slider.Main.AbsoluteSize.X * (NewVal / (SliderSettings.Range[2] - SliderSettings.Range[1])) or 5, 1, 0)}):Play()
			if not bleh then Slider.Value.Text = tostring(NewVal) end
			local Success, Response = pcall(function()
				SliderSettings.Callback(NewVal)
			end)
			if not Success then
				TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
				TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				Slider.Title.Text = "Callback Error"
				print("Aurexis Interface Library | "..SliderSettings.Name.." Callback Error " ..tostring(Response))
				wait(0.5)
				Slider.Title.Text = SliderSettings.Name
				TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
				TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(30, 33, 40)}):Play()
				TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			end

			SliderSettings.CurrentValue = NewVal
			SliderV.CurrentValue = SliderSettings.CurrentValue
			-- Aurexis.Flags[SliderSettings.Flag] = SliderSettings

		end

		function SliderV:UpdateValue(Value)
			Set(tonumber(Value))
		end 

		Slider.Value:GetPropertyChangedSignal("Text"):Connect(function()
			local text = Slider.Value.Text
			if not tonumber(text) and text ~= "." then
				Slider.Value.Text = text:match("[0-9.]*") or ""
			end
			if SliderSettings.Range[2] < (tonumber(Slider.Value.Text) or 0) then Slider.Value.Text = SliderSettings.Range[2] end
			Slider.Value.Size = UDim2.fromOffset(Slider.Value.TextBounds.X, 23)
			Set(tonumber(Slider.Value.Text), true)
		end)

		function SliderV:Set(NewSliderSettings)
			NewSliderSettings = Kwargify({
				Name = SliderSettings.Name,
				Range = SliderSettings.Range,
				Increment = SliderSettings.Increment,
				CurrentValue = SliderSettings.CurrentValue,
				Callback = SliderSettings.Callback
			}, NewSliderSettings or {})

			SliderSettings = NewSliderSettings
			SliderV.Settings = NewSliderSettings

			Slider.Name = SliderSettings.Name .. " - Slider"
			Slider.Title.Text = SliderSettings.Name

			Set()

			-- Aurexis.Flags[SliderSettings.Flag] = SliderSettings
		end

		function SliderV:Destroy()
			Slider.Visible = false
			Slider:Destroy()
		end

		if Flag then
			Aurexis.Options[Flag] = SliderV
		end

		AurexisUI.ThemeRemote:GetPropertyChangedSignal("Value"):Connect(function()
			Slider.Main.color.Color = Aurexis.ThemeGradient
			Slider.Main.UIStroke.color.Color = Aurexis.ThemeGradient
		end)

		return SliderV

	end

	-- Toggle
	function Section:CreateToggle(ToggleSettings, Flag)    
		TabPage.Position = UDim2.new(0,0,0,28)
		local ToggleV = { IgnoreConfig = false, Class = "Toggle" }

		ToggleSettings = Kwargify({
			Name = "Toggle",
			Description = nil,
			CurrentValue = false,
			Callback = function(Value)
			end,
		}, ToggleSettings or {})


		local Toggle

		if ToggleSettings.Description ~= nil and ToggleSettings.Description ~= "" then
			Toggle = Elements.Template.ToggleDesc:Clone()
		else
			Toggle = Elements.Template.Toggle:Clone()
		end

		Toggle.Visible = true
		Toggle.Parent = TabPage

		Toggle.Name = ToggleSettings.Name .. " - Toggle"
		Toggle.Title.Text = ToggleSettings.Name
		if ToggleSettings.Description ~= nil and ToggleSettings.Description ~= "" then
			Toggle.Desc.Text = ToggleSettings.Description
		end

		Toggle.UIStroke.Transparency = 1
		Toggle.Title.TextTransparency = 1
		if ToggleSettings.Description ~= nil and ToggleSettings.Description ~= "" then
			Toggle.Desc.TextTransparency = 1
		end

		TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
		if ToggleSettings.Description ~= nil and ToggleSettings.Description ~= "" then
			TweenService:Create(Toggle.Desc, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		end
		TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
		TweenService:Create(Toggle.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

		local function Set(bool)
			if bool then
				Toggle.toggle.color.Enabled = true
				tween(Toggle.toggle, {BackgroundTransparency = 0})

				Toggle.toggle.UIStroke.color.Enabled = true
				tween(Toggle.toggle.UIStroke, {Color = Color3.new(255,255,255)})

				tween(Toggle.toggle.val, {BackgroundColor3 = Color3.fromRGB(255,255,255), Position = UDim2.new(1,-23,0.5,0), BackgroundTransparency = 0.45})
			else
				Toggle.toggle.color.Enabled = false
				Toggle.toggle.UIStroke.color.Enabled = false

				Toggle.toggle.UIStroke.Color = Color3.fromRGB(97,97,97)

				tween(Toggle.toggle, {BackgroundTransparency = 1})

				tween(Toggle.toggle.val, {BackgroundColor3 = Color3.fromRGB(97,97,97), Position = UDim2.new(0,5,0.5,0), BackgroundTransparency = 0})
			end

			ToggleV.CurrentValue = bool
		end

		Toggle.Interact.MouseButton1Click:Connect(function()
			ToggleSettings.CurrentValue = not ToggleSettings.CurrentValue
			Set(ToggleSettings.CurrentValue)

			local Success, Response = pcall(function()
				ToggleSettings.Callback(ToggleSettings.CurrentValue)
			end)
			if not Success then
				TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
				TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				Toggle.Title.Text = "Callback Error"
				print("Aurexis Interface Library | "..ToggleSettings.Name.." Callback Error " ..tostring(Response))
				wait(0.5)
				Toggle.Title.Text = ToggleSettings.Name
				TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
				TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
				TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			end
		end)

		Toggle["MouseEnter"]:Connect(function()
			tween(Toggle.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
		end)

		Toggle["MouseLeave"]:Connect(function()
			tween(Toggle.UIStroke, {Color = Color3.fromRGB(64,61,76)})
		end)

		if ToggleSettings.CurrentValue then
			Set(ToggleSettings.CurrentValue)
			local Success, Response = pcall(function()
				ToggleSettings.Callback(ToggleSettings.CurrentValue)
			end)
			if not Success then
				TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
				TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				Toggle.Title.Text = "Callback Error"
				print("Aurexis Interface Library | "..ToggleSettings.Name.." Callback Error " ..tostring(Response))
				wait(0.5)
				Toggle.Title.Text = ToggleSettings.Name
				TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
				TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
				TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			end
		end

		function ToggleV:UpdateState(State)
			ToggleSettings.CurrentValue = State
			Set(ToggleSettings.CurrentValue)
		end

		function ToggleV:Set(NewToggleSettings)

			NewToggleSettings = Kwargify({
				Name = ToggleSettings.Name,
				Description = ToggleSettings.Description,
				CurrentValue = ToggleSettings.CurrentValue,
				Callback = ToggleSettings.Callback
			}, NewToggleSettings or {})

			ToggleV.Settings = NewToggleSettings
			ToggleSettings = NewToggleSettings

			Toggle.Name = ToggleSettings.Name .. " - Toggle"
			Toggle.Title.Text = ToggleSettings.Name
			if ToggleSettings.Description ~= nil and ToggleSettings.Description ~= "" and Toggle.Desc ~= nil then
				Toggle.Desc.Text = ToggleSettings.Description
			end

			Set(ToggleSettings.CurrentValue)

			ToggleV.CurrentValue = ToggleSettings.CurrentValue

			local Success, Response = pcall(function()
				ToggleSettings.Callback(ToggleSettings.CurrentValue)
			end)
			if not Success then
				TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
				TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				Toggle.Title.Text = "Callback Error"
				print("Aurexis Interface Library | "..ToggleSettings.Name.." Callback Error " ..tostring(Response))
				wait(0.5)
				Toggle.Title.Text = ToggleSettings.Name
				TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
				TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
				TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			end
		end

		function ToggleV:Destroy()
			Toggle.Visible = false
			Toggle:Destroy()
		end

		AurexisUI.ThemeRemote:GetPropertyChangedSignal("Value"):Connect(function()
			Toggle.toggle.color.Color = Aurexis.ThemeGradient
			Toggle.toggle.UIStroke.color.Color = Aurexis.ThemeGradient
		end)

		if Flag then
			Aurexis.Options[Flag] = ToggleV
		end

		return ToggleV

	end

	-- Bind
	function Section:CreateBind(BindSettings, Flag)
		TabPage.Position = UDim2.new(0,0,0,28)
		local BindV = { Class = "Keybind", IgnoreConfig = false, Settings = BindSettings, Active = false }

		BindSettings = Kwargify({
			Name = "Bind",
			Description = nil,
			CurrentBind = "Q",
			HoldToInteract = false, -- setting this makes the Bind in toggle mode
			Callback = function(Bind)
				-- The function that takes place when the Bind is pressed
				-- The variable (Bind) is a boolean for whether the Bind is being held or not (HoldToInteract needs to be true) or whether the Bind is currently active
			end,

			OnChangedCallback = function(Bind)
				-- The function that takes place when the binded key changes
				-- The variable (Bind) is a Enum.KeyCode for the new Binded Key
			end,
		}, BindSettings or {})

		local CheckingForKey = false

		local Bind
		if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
			Bind = Elements.Template.BindDesc:Clone()
		else
			Bind = Elements.Template.Bind:Clone()
		end

		Bind.Visible = true
		Bind.Parent = TabPage

		Bind.Name = BindSettings.Name
		Bind.Title.Text = BindSettings.Name
		if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
			Bind.Desc.Text = BindSettings.Description
		end

		Bind.Title.TextTransparency = 1
		if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
			Bind.Desc.TextTransparency = 1
		end
		Bind.BindFrame.BackgroundTransparency = 1
		Bind.BindFrame.UIStroke.Transparency = 1
		Bind.BindFrame.BindBox.TextTransparency = 1

		TweenService:Create(Bind, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
		TweenService:Create(Bind.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		if BindSettings.Description ~= nil and BindSettings.Description ~= "" then
			TweenService:Create(Bind.Desc, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		end
		TweenService:Create(Bind.BindFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.9}):Play()
		TweenService:Create(Bind.BindFrame.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.3}):Play()
		TweenService:Create(Bind.BindFrame.BindBox, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()


		Bind.BindFrame.BindBox.Text = BindSettings.CurrentBind
		Bind.BindFrame.BindBox.Size = UDim2.new(0, Bind.BindFrame.BindBox.TextBounds.X + 20, 0, 42)

		Bind.BindFrame.BindBox.Focused:Connect(function()
			CheckingForKey = true
			Bind.BindFrame.BindBox.Text = ""
		end)

		Bind.BindFrame.BindBox.FocusLost:Connect(function()
			CheckingForKey = false
			if Bind.BindFrame.BindBox.Text == (nil or "") then
				Bind.BindFrame.BindBox.Text = BindSettings.CurrentBind
			end
		end)

		Bind["MouseEnter"]:Connect(function()
			tween(Bind.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
		end)

		Bind["MouseLeave"]:Connect(function()
			tween(Bind.UIStroke, {Color = Color3.fromRGB(64,61,76)})
		end)
		UserInputService.InputBegan:Connect(function(input, processed)

			if CheckingForKey then
				if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Window.Bind then
					local SplitMessage = string.split(tostring(input.KeyCode), ".")
					local NewKeyNoEnum = SplitMessage[3]
					Bind.BindFrame.BindBox.Text = tostring(NewKeyNoEnum)
					BindSettings.CurrentBind = tostring(NewKeyNoEnum)
					local Success, Response = pcall(function()
						BindSettings.Callback(BindSettings.CurrentBind)
					end)
					if not Success then
						TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
						TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
						TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
						Bind.Title.Text = "Callback Error"
						print("Aurexis Interface Library | "..BindSettings.Name.." Callback Error " ..tostring(Response))
						wait(0.5)
						Bind.Title.Text = BindSettings.Name
						TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
						TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
						TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
					end
					Bind.BindFrame.BindBox:ReleaseFocus()
				end
			elseif BindSettings.CurrentBind ~= nil and (input.KeyCode == Enum.KeyCode[BindSettings.CurrentBind] and not processed) then -- Test
				local Held = true
				local Connection
				Connection = input.Changed:Connect(function(prop)
					if prop == "UserInputState" then
						Connection:Disconnect()
						Held = false
					end
				end)

				if not BindSettings.HoldToInteract then
					BindV.Active = not BindV.Active
					local Success, Response = pcall(function()
						BindSettings.Callback(BindV.Active)
					end)
					if not Success then
						TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
						TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
						TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
						Bind.Title.Text = "Callback Error"
						print("Aurexis Interface Library | "..BindSettings.Name.." Callback Error " ..tostring(Response))
						wait(0.5)
						Bind.Title.Text = BindSettings.Name
						TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
						TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
						TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
					end
				else
					wait(0.1)
					if Held then
						local Loop; Loop = RunService.Stepped:Connect(function()
							if not Held then
								local Success, Response = pcall(function()
									BindSettings.Callback(false)
								end)
								if not Success then
									TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
									TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
									TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
									Bind.Title.Text = "Callback Error"
									print("Aurexis Interface Library | "..BindSettings.Name.." Callback Error " ..tostring(Response))
									wait(0.5)
									Bind.Title.Text = BindSettings.Name
									TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
									TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
									TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
								end 
								Loop:Disconnect()
							else
								local Success, Response = pcall(function()
									BindSettings.Callback(true)
								end)
								if not Success then
									TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
									TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
									TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
									Bind.Title.Text = "Callback Error"
									print("Aurexis Interface Library | "..BindSettings.Name.." Callback Error " ..tostring(Response))
									wait(0.5)
									Bind.Title.Text = BindSettings.Name
									TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
									TweenService:Create(Bind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
									TweenService:Create(Bind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
								end
							end
						end)	
					end
				end
			end
		end)

		Bind.BindFrame.BindBox:GetPropertyChangedSignal("Text"):Connect(function()
			TweenService:Create(Bind.BindFrame, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Bind.BindFrame.BindBox.TextBounds.X + 20, 0, 30)}):Play()
		end)

		function BindV:Set(NewBindSettings)

			NewBindSettings = Kwargify({
				Name = BindSettings.Name,
				Description = BindSettings.Description,
				CurrentBind =  BindSettings.CurrentBind,
				HoldToInteract = BindSettings.HoldToInteract,
				Callback = BindSettings.Callback
			}, NewBindSettings or {})

			BindV.Settings = NewBindSettings
			BindSettings = NewBindSettings

			Bind.Name = BindSettings.Name
			Bind.Title.Text = BindSettings.Name
			if BindSettings.Description ~= nil and BindSettings.Description ~= "" and Bind.Desc ~= nil then
				Bind.Desc.Text = BindSettings.Description
			end

			Bind.BindFrame.BindBox.Text = BindSettings.CurrentBind
			Bind.BindFrame.Size = UDim2.new(0, Bind.BindFrame.BindBox.TextBounds.X + 20, 0, 42)


			BindV.CurrentBind = BindSettings.CurrentBind
		end

		function BindV:Destroy()
			Bind.Visible = false
			Bind:Destroy()
		end

		if Flag then
			Aurexis.Options[Flag] = BindV
		end

		-- Aurexis.Flags[BindSettings.Flag] = BindSettings

		return BindV

	end

	-- Dynamic Input
	function Section:CreateInput(InputSettings, Flag)
		TabPage.Position = UDim2.new(0,0,0,28)
		local InputV = { IgnoreConfig = false, Class = "Input", Settings = InputSettings }

		InputSettings = Kwargify({
			Name = "Dynamic Input",
			Description = nil,
			CurrentValue = "",
			PlaceholderText = "Input Placeholder",
			RemoveTextAfterFocusLost = false,
			Numeric = false,
			Enter = false,
			MaxCharacters = nil,
			Callback = function(Text)

			end, -- 52
		}, InputSettings or {})

		InputV.CurrentValue = InputSettings.CurrentValue

		local descriptionbool
		if InputSettings.Description ~= nil and InputSettings.Description ~= "" then
			descriptionbool = true
		end

		local Input 
		if descriptionbool then
			Input = Elements.Template.InputDesc:Clone()
		else
			Input = Elements.Template.Input:Clone()
		end

		Input.Name = InputSettings.Name
		Input.Title.Text = InputSettings.Name
		if descriptionbool then Input.Desc.Text = InputSettings.Description end
		Input.Visible = true
		Input.Parent = TabPage

		Input.BackgroundTransparency = 1
		Input.UIStroke.Transparency = 1
		Input.Title.TextTransparency = 1
		if descriptionbool then Input.Desc.TextTransparency = 1 end
		Input.InputFrame.BackgroundTransparency = 1
		Input.InputFrame.UIStroke.Transparency = 1
		Input.InputFrame.InputBox.TextTransparency = 1

		TweenService:Create(Input, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
		TweenService:Create(Input.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
		TweenService:Create(Input.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	
		if descriptionbool then TweenService:Create(Input.Desc, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play() end
		TweenService:Create(Input.InputFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.9}):Play()
		TweenService:Create(Input.InputFrame.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.3}):Play()
		TweenService:Create(Input.InputFrame.InputBox, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

		Input.InputFrame.InputBox.PlaceholderText = InputSettings.PlaceholderText
		Input.InputFrame.Size = UDim2.new(0, Input.InputFrame.InputBox.TextBounds.X + 52, 0, 30)

		Input.InputFrame.InputBox.FocusLost:Connect(function(bleh)

			if InputSettings.Enter then
				if bleh then
					local Success, Response = pcall(function()
						InputSettings.Callback(Input.InputFrame.InputBox.Text)
						InputV.CurrentValue = Input.InputFrame.InputBox.Text
					end)
					if not Success then
						TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
						TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
						TweenService:Create(Input.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
						Input.Title.Text = "Callback Error"
						print("Aurexis Interface Library | "..InputSettings.Name.." Callback Error " ..tostring(Response))
						wait(0.5)
						Input.Title.Text = InputSettings.Name
						TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
						TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
						TweenService:Create(Input.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
					end
				end
			end

			if InputSettings.RemoveTextAfterFocusLost then
				Input.InputFrame.InputBox.Text = ""
			end

		end)

		if InputSettings.Numeric then
			Input.InputFrame.InputBox:GetPropertyChangedSignal("Text"):Connect(function()
				local text = Input.InputFrame.InputBox.Text
				if not tonumber(text) and text ~= "." then
					Input.InputFrame.InputBox.Text = text:match("[0-9.]*") or ""
				end
			end)
		end

		Input.InputFrame.InputBox:GetPropertyChangedSignal("Text"):Connect(function()
			if tonumber(InputSettings.MaxCharacters) then
				if (#Input.InputFrame.InputBox.Text - 1) == InputSettings.MaxCharacters then
					Input.InputFrame.InputBox.Text = Input.InputFrame.InputBox.Text:sub(1, InputSettings.MaxCharacters)
				end
			end
			TweenService:Create(Input.InputFrame, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Input.InputFrame.InputBox.TextBounds.X + 52, 0, 30)}):Play()
			if not InputSettings.Enter then
				local Success, Response = pcall(function()
					InputSettings.Callback(Input.InputFrame.InputBox.Text)
				end)
				if not Success then
					TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
					TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Input.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Input.Title.Text = "Callback Error"
					print("Aurexis Interface Library | "..InputSettings.Name.." Callback Error " ..tostring(Response))
					wait(0.5)
					Input.Title.Text = InputSettings.Name
					TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
					TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
					TweenService:Create(Input.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				end
			end
			InputV.CurrentValue = Input.InputFrame.InputBox.Text				
		end)

		Input["MouseEnter"]:Connect(function()
			tween(Input.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
		end)

		Input["MouseLeave"]:Connect(function()
			tween(Input.UIStroke, {Color = Color3.fromRGB(64,61,76)})
		end)

		InputV.Instance = Input

		function InputV:SetVisible(isVisible)
			Input.Visible = isVisible and true or false
		end


		function InputV:Set(NewInputSettings)

			NewInputSettings = Kwargify(InputSettings, NewInputSettings or {})

			InputV.Settings = NewInputSettings
			InputSettings = NewInputSettings

			Input.Name = InputSettings.Name
			Input.Title.Text = InputSettings.Name
			if InputSettings.Description ~= nil and InputSettings.Description ~= "" and Input.Desc ~= nil then
				Input.Desc.Text = InputSettings.Description
			end

			Input.InputFrame.InputBox:CaptureFocus()
			Input.InputFrame.InputBox.Text = tostring(InputSettings.CurrentValue)
			Input.InputFrame.InputBox:ReleaseFocus()
			Input.InputFrame.Size = UDim2.new(0, Input.InputFrame.InputBox.TextBounds.X + 52, 0, 42)

			InputV.CurrentValue = InputSettings.CurrentValue
		end

		function InputV:Destroy()
			Input.Visible = false
			Input:Destroy()
		end

		if Flag then
			Aurexis.Options[Flag] = InputV
		end


		return InputV

	end

	-- Dropdown
	function Section:CreateDropdown(DropdownSettings, Flag)
		TabPage.Position = UDim2.new(0,0,0,28)
		local DropdownV = { IgnoreConfig = false, Class = "Dropdown", Settings = DropdownSettings}

		DropdownSettings = Kwargify({
			Name = "Dropdown",
			Description = nil,
			Options = {"Option 1", "Option 2"},
			CurrentOption = {"Option 1"},
			MultipleOptions = false,
			SpecialType = nil, -- currently onl player, might add more soon
			Callback = function(Options)
				-- The function that takes place when the selected option is changed
				-- The variable (Options) is a table of strings for the current selected options or a string if multioptions is false
			end,
		}, DropdownSettings or {})

		DropdownV.CurrentOption = DropdownSettings.CurrentOption

		local descriptionbool = false
		if DropdownSettings.Description ~= nil and DropdownSettings.Description ~= "" then
			descriptionbool = true
		end
		local closedsize
		local openedsize
		if descriptionbool then
			closedsize = 48
			openedsize = 170
		elseif not descriptionbool then
			closedsize = 38
			openedsize = 160
		end
		local opened = false

		local Dropdown
		if descriptionbool then Dropdown = Elements.Template.DropdownDesc:Clone() else Dropdown = Elements.Template.Dropdown:Clone() end

		Dropdown.Name = DropdownSettings.Name
		Dropdown.Title.Text = DropdownSettings.Name
		if descriptionbool then Dropdown.Desc.Text = DropdownSettings.Description end

		Dropdown.Parent = TabPage
		Dropdown.Visible = true

		local function Toggle()
			opened = not opened
			if opened then
				tween(Dropdown.icon, {Rotation = 180})
				tween(Dropdown, {Size = UDim2.new(1, -25, 0, openedsize)})
			else
				tween(Dropdown.icon, {Rotation = 0})
				tween(Dropdown, {Size = UDim2.new(1, -25, 0, closedsize)})
			end
		end

		local function SafeCallback(param, c2)
			local Success, Response = pcall(function()
				DropdownSettings.Callback(param)
			end)
			if not Success then
				TweenService:Create(Dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(Dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
				TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				Dropdown.Title.Text = "Callback Error"
				print("Aurexis Interface Library | "..DropdownSettings.Name.." Callback Error " ..tostring(Response))
				wait(0.5)
				Dropdown.Title.Text = DropdownSettings.Name
				TweenService:Create(Dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
				TweenService:Create(Dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
				TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			end
			if Success and c2 then
				c2()
			end
		end

		-- fixed by justhey
		Dropdown.Selected:GetPropertyChangedSignal("Text"):Connect(function()
			local text = Dropdown.Selected.Text:lower()
			for _, Item in ipairs(Dropdown.List:GetChildren()) do
				if Item:IsA("TextLabel") and Item.Name ~= "Template" then
					Item.Visible = text == "" or string.find(Item.Name:lower(), text, 1, true) ~= nil
				end
			end
		end)


		local function Clear()
			for _, option in ipairs(Dropdown.List:GetChildren()) do
				if option.ClassName == "TextLabel" and option.Name ~= "Template" then
					option:Destroy()
				end
			end
		end

		local function ActivateColorSingle(name)
			for _, Option in pairs(Dropdown.List:GetChildren()) do
				if Option.ClassName == "TextLabel" and Option.Name ~= "Template" then
					tween(Option, {BackgroundTransparency = 0.98})
				end
			end

			Toggle()
			tween(Dropdown.List[name], {BackgroundTransparency = 0.95, TextColor3 = Color3.fromRGB(240,240,240)})
		end

		local function Refresh()
			Clear()
			for i,v in pairs(DropdownSettings.Options) do
				local Option = Dropdown.List.Template:Clone()
				local optionhover = false
				Option.Text = v
				if v == "Template" then v = "Template (Name)" end
				Option.Name = v
				Option.Interact.MouseButton1Click:Connect(function()
					local bleh
					if DropdownSettings.MultipleOptions then
						if table.find(DropdownSettings.CurrentOption, v) then
							RemoveTable(DropdownSettings.CurrentOption, v)
							DropdownV.CurrentOption = DropdownSettings.CurrentOption
							if not optionhover then
								tween(Option, {TextColor3 = Color3.fromRGB(200,200,200)})
							end
							tween(Option, {BackgroundTransparency = 0.98})
						else
							table.insert(DropdownSettings.CurrentOption, v)
							DropdownV.CurrentOption = DropdownSettings.CurrentOption
							tween(Option, {TextColor3 = Color3.fromRGB(240,240,240), BackgroundTransparency = 0.95})
						end
						bleh = DropdownSettings.CurrentOption
					else
						DropdownSettings.CurrentOption = {v}
						bleh = v
						DropdownV.CurrentOption = bleh
						ActivateColorSingle(v)
					end

					SafeCallback(bleh, function()
						if DropdownSettings.MultipleOptions then
							if DropdownSettings.CurrentOption and type(DropdownSettings.CurrentOption) == "table" then
								if #DropdownSettings.CurrentOption == 1 then
									Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1]
								elseif #DropdownSettings.CurrentOption == 0 then
									Dropdown.Selected.PlaceholderText = "None"
								else
									Dropdown.Selected.PlaceholderText = unpackt(DropdownSettings.CurrentOption)
								end
							else
								DropdownSettings.CurrentOption = {}
								Dropdown.Selected.PlaceholderText = "None"
							end
						end
						if not DropdownSettings.MultipleOptions then
							Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1] or "None"
						end
						Dropdown.Selected.Text = ""
					end)
				end)
				Option.Visible = true
				Option.Parent = Dropdown.List
				Option.MouseEnter:Connect(function()
					optionhover = true
					if Option.BackgroundTransparency == 0.95 then
						return
					else
						tween(Option, {TextColor3 = Color3.fromRGB(240,240,240)})
					end
				end)
				Option.MouseLeave:Connect(function()
					optionhover = false
					if Option.BackgroundTransparency == 0.95 then
						return
					else
						tween(Option, {TextColor3 = Color3.fromRGB(200,200,200)})
					end
				end)	
			end
		end

		local function PlayerTableRefresh()
			for i,v in pairs(DropdownSettings.Options) do
				table.remove(DropdownSettings.Options, i)
			end

			for i,v in pairs(Players:GetChildren()) do
				table.insert(DropdownSettings.Options, v.Name)
			end
		end

		Dropdown.Interact.MouseButton1Click:Connect(function()
			Toggle()
		end)

		Dropdown["MouseEnter"]:Connect(function()
			tween(Dropdown.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
		end)

		Dropdown["MouseLeave"]:Connect(function()
			tween(Dropdown.UIStroke, {Color = Color3.fromRGB(64,61,76)})
		end)

		if DropdownSettings.SpecialType == "Player" then

			for i,v in pairs(DropdownSettings.Options) do
				table.remove(DropdownSettings.Options, i)
			end
			PlayerTableRefresh()
			DropdownSettings.CurrentOption = DropdownSettings.Options[1]

			Players.PlayerAdded:Connect(function() PlayerTableRefresh() end)
			Players.PlayerRemoving:Connect(function() PlayerTableRefresh() end)

		end

		Refresh()

		if DropdownSettings.CurrentOption then
			if type(DropdownSettings.CurrentOption) == "string" then
				DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption}
			end
			if not DropdownSettings.MultipleOptions and type(DropdownSettings.CurrentOption) == "table" then
				DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption[1]}
			end
		else
			DropdownSettings.CurrentOption = {}
		end

		local bleh, ind = nil,0
		for i,v in pairs(DropdownSettings.CurrentOption) do
			ind = ind + 1
		end
		if ind == 1 then bleh = DropdownSettings.CurrentOption[1] else bleh = DropdownSettings.CurrentOption end
		SafeCallback(bleh)
		if type(bleh) == "string" then 
			tween(Dropdown.List[bleh], {TextColor3 = Color3.fromRGB(240,240,240), BackgroundTransparency = 0.95})
		else
			for i,v in pairs(bleh) do
				tween(Dropdown.List[v], {TextColor3 = Color3.fromRGB(240,240,240), BackgroundTransparency = 0.95})
			end
		end

		if DropdownSettings.MultipleOptions then
			if DropdownSettings.CurrentOption and type(DropdownSettings.CurrentOption) == "table" then
				if #DropdownSettings.CurrentOption == 1 then
					Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1]
				elseif #DropdownSettings.CurrentOption == 0 then
					Dropdown.Selected.PlaceholderText = "None"
				else
					Dropdown.Selected.PlaceholderText = unpackt(DropdownSettings.CurrentOption)
				end
			else
				DropdownSettings.CurrentOption = {}
				Dropdown.Selected.PlaceholderText = "None"
			end
			for _, name in pairs(DropdownSettings.CurrentOption) do
				tween(Dropdown.List[name], {TextColor3 = Color3.fromRGB(227,227,227), BackgroundTransparency = 0.95})
			end
		else
			Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1] or "None"
		end
		Dropdown.Selected.Text = ""

		function DropdownV:Set(NewDropdownSettings)
			NewDropdownSettings = Kwargify(DropdownSettings, NewDropdownSettings or {})

			DropdownV.Settings = NewDropdownSettings
			DropdownSettings = NewDropdownSettings

			Dropdown.Name = DropdownSettings.Name
			Dropdown.Title.Text = DropdownSettings.Name
			if DropdownSettings.Description ~= nil and DropdownSettings.Description ~= "" and Dropdown.Desc ~= nil then
				Dropdown.Desc.Text = DropdownSettings.Description
			end

			if DropdownSettings.SpecialType == "Player" then

				for i,v in pairs(DropdownSettings.Options) do
					table.remove(DropdownSettings.Options, i)
				end
				PlayerTableRefresh()
				DropdownSettings.CurrentOption = DropdownSettings.Options[1]                    
				Players.PlayerAdded:Connect(function() PlayerTableRefresh() end)
				Players.PlayerRemoving:Connect(function() PlayerTableRefresh() end)

			end

			Refresh()

			if DropdownSettings.CurrentOption then
				if type(DropdownSettings.CurrentOption) == "string" then
					DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption}
				end
				if not DropdownSettings.MultipleOptions and type(DropdownSettings.CurrentOption) == "table" then
					DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption[1]}
				end
			else
				DropdownSettings.CurrentOption = {}
			end

			local bleh, ind = nil,0
			for i,v in pairs(DropdownSettings.CurrentOption) do
				ind = ind + 1
			end
			if ind == 1 then bleh = DropdownSettings.CurrentOption[1] else bleh = DropdownSettings.CurrentOption end
			SafeCallback(bleh)
			for _, Option in pairs(Dropdown.List:GetChildren()) do
				if Option.ClassName == "TextLabel" then
					tween(Option, {TextColor3 = Color3.fromRGB(200,200,200), BackgroundTransparency = 0.98})
				end
			end
			tween(Dropdown.List[bleh], {TextColor3 = Color3.fromRGB(240,240,240), BackgroundTransparency = 0.95})

			if DropdownSettings.MultipleOptions then
				if DropdownSettings.CurrentOption and type(DropdownSettings.CurrentOption) == "table" then
					if #DropdownSettings.CurrentOption == 1 then
						Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1]
					elseif #DropdownSettings.CurrentOption == 0 then
						Dropdown.Selected.PlaceholderText = "None"
					else
						Dropdown.Selected.PlaceholderText = unpackt(DropdownSettings.CurrentOption)
					end
				else
					DropdownSettings.CurrentOption = {}
					Dropdown.Selected.PlaceholderText = "None"
				end
				for _, name in pairs(DropdownSettings.CurrentOption) do
					tween(Dropdown.List[name], {TextColor3 = Color3.fromRGB(227,227,227), BackgroundTransparency = 0.95})
				end
			else
				Dropdown.Selected.PlaceholderText = DropdownSettings.CurrentOption[1] or "None"
			end
			Dropdown.Selected.Text = ""

			-- Aurexis.Flags[DropdownSettings.Flag] = DropdownSettings

		end

		function DropdownV:Destroy()
			Dropdown.Visible = false
			Dropdown:Destroy()
		end

		if Flag then
			Aurexis.Options[Flag] = DropdownV
		end

		-- Aurexis.Flags[DropdownSettings.Flag] = DropdownSettings

		return DropdownV

	end

	-- Color Picker
	function Section:CreateColorPicker(ColorPickerSettings, Flag) -- by Rayfield/Throit
		TabPage.Position = UDim2.new(0,0,0,28)
		local ColorPickerV = {IgnoreClass = false, Class = "Colorpicker", Settings = ColorPickerSettings}

		ColorPickerSettings = Kwargify({
			Name = "Color Picker",
			Color = Color3.fromRGB(255,255,255),
			Callback = function(Value)
				-- The function that takes place every time the color picker is moved/changed
				-- The variable (Value) is a Color3fromRGB value based on which color is selected
			end
		}, ColorPickerSettings or {})

		local function Color3ToHex(color)
			return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
		end

		ColorPickerV.Color = Color3ToHex(ColorPickerSettings.Color)

		local closedsize = UDim2.new(0, 75, 0, 22)
		local openedsize = UDim2.new(0, 219, 0, 129)

		local ColorPicker = Elements.Template.ColorPicker:Clone()
		local Background = ColorPicker.CPBackground
		local Display = Background.Display
		local Main = Background.MainCP
		local Slider = ColorPicker.ColorSlider

		ColorPicker.Name = ColorPickerSettings.Name
		ColorPicker.Title.Text = ColorPickerSettings.Name
		ColorPicker.Visible = true
		ColorPicker.Parent = TabPage
		ColorPicker.Size = UDim2.new(1.042, -25,0, 38)
		Background.Size = closedsize
		Display.BackgroundTransparency = 0

		ColorPicker["MouseEnter"]:Connect(function()
			tween(ColorPicker.UIStroke, {Color = Color3.fromRGB(87, 84, 104)})
		end)
		ColorPicker["MouseLeave"]:Connect(function()
			tween(ColorPicker.UIStroke, {Color = Color3.fromRGB(64,61,76)})
		end)

		local function SafeCallback(param, c2)
			local Success, Response = pcall(function()
				ColorPickerSettings.Callback(param)
			end)
			if not Success then
				TweenService:Create(ColorPicker, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(ColorPicker, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
				TweenService:Create(ColorPicker.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				ColorPicker.Title.Text = "Callback Error"
				print("Aurexis Interface Library | "..ColorPickerSettings.Name.." Callback Error " ..tostring(Response))
				wait(0.5)
				ColorPicker.Title.Text = ColorPickerSettings.Name
				TweenService:Create(ColorPicker, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
				TweenService:Create(ColorPicker, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(32, 30, 38)}):Play()
				TweenService:Create(ColorPicker.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			end
			if Success and c2 then
				c2()
			end
		end

		local opened = false

		local mouse = game.Players.LocalPlayer:GetMouse()
		Main.Image = "http://www.roblox.com/asset/?id=11415645739"
		local mainDragging = false 
		local sliderDragging = false 
		ColorPicker.Interact.MouseButton1Down:Connect(function()
			if not opened then
				opened = true 
				tween(ColorPicker, {Size = UDim2.new( 1.042, -25,0, 165)}, nil, TweenInfo.new(0.6, Enum.EasingStyle.Exponential))
				tween(Background, {Size = openedsize})
				tween(Display, {BackgroundTransparency = 1})
			else
				opened = false
				tween(ColorPicker, {Size = UDim2.new(1.042, -25,0, 38)}, nil, TweenInfo.new(0.6, Enum.EasingStyle.Exponential))
				tween(Background, {Size = closedsize})
				tween(Display, {BackgroundTransparency = 0})
			end
		end)
		UserInputService.InputEnded:Connect(function(input, gameProcessed) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
				mainDragging = false
				sliderDragging = false
			end end)
		Main.MouseButton1Down:Connect(function()
			if opened then
				mainDragging = true 
			end
		end)
		Main.MainPoint.MouseButton1Down:Connect(function()
			if opened then
				mainDragging = true 
			end
		end)
		Slider.MouseButton1Down:Connect(function()
			sliderDragging = true 
		end)
		Slider.SliderPoint.MouseButton1Down:Connect(function()
			sliderDragging = true 
		end)
		local h,s,v = ColorPickerSettings.Color:ToHSV()
		local color = Color3.fromHSV(h,s,v) 
		local r,g,b = math.floor((h*255)+0.5),math.floor((s*255)+0.5),math.floor((v*255)+0.5)
		local hex = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
		ColorPicker.HexInput.InputBox.Text = hex
		local function setDisplay(hp,sp,vp)
			--Main
			Main.MainPoint.Position = UDim2.new(s,-Main.MainPoint.AbsoluteSize.X/2,1-v,-Main.MainPoint.AbsoluteSize.Y/2)
			Main.MainPoint.ImageColor3 = Color3.fromHSV(hp,sp,vp)
			Background.BackgroundColor3 = Color3.fromHSV(hp,1,1)
			Display.BackgroundColor3 = Color3.fromHSV(hp,sp,vp)
			--Slider 
			local x = hp * Slider.AbsoluteSize.X
			Slider.SliderPoint.Position = UDim2.new(0,x-Slider.SliderPoint.AbsoluteSize.X/2,0.5,0)
			Slider.SliderPoint.ImageColor3 = Color3.fromHSV(hp,1,1)
			local color = Color3.fromHSV(hp,sp,vp) 
			local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
			ColorPicker.RInput.InputBox.Text = tostring(r)
			ColorPicker.GInput.InputBox.Text = tostring(g)
			ColorPicker.BInput.InputBox.Text = tostring(b)
			hex = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
			ColorPicker.HexInput.InputBox.Text = hex
		end
		setDisplay(h,s,v)
		ColorPicker.HexInput.InputBox.FocusLost:Connect(function()
			if not pcall(function()
					local r, g, b = string.match(ColorPicker.HexInput.InputBox.Text, "^#?(%w%w)(%w%w)(%w%w)$")
					local rgbColor = Color3.fromRGB(tonumber(r, 16),tonumber(g, 16), tonumber(b, 16))
					h,s,v = rgbColor:ToHSV()
					hex = ColorPicker.HexInput.InputBox.Text
					setDisplay()
					ColorPickerSettings.Color = rgbColor
				end) 
			then 
				ColorPicker.HexInput.InputBox.Text = hex 
			end
			local r,g,b = math.floor((h*255)+0.5),math.floor((s*255)+0.5),math.floor((v*255)+0.5)
			ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
			SafeCallback( Color3.fromRGB(r,g,b))
		end)
		--RGB
		local function rgbBoxes(box,toChange)
			local value = tonumber(box.Text) 
			local color = Color3.fromHSV(h,s,v) 
			local oldR,oldG,oldB = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
			local save 
			if toChange == "R" then save = oldR;oldR = value elseif toChange == "G" then save = oldG;oldG = value else save = oldB;oldB = value end
			if value then 
				value = math.clamp(value,0,255)
				h,s,v = Color3.fromRGB(oldR,oldG,oldB):ToHSV()
				setDisplay()
			else 
				box.Text = tostring(save)
			end
			local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
			ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
		end
		ColorPicker.RInput.InputBox.FocusLost:connect(function()
			rgbBoxes(ColorPicker.RInput.InputBox,"R")
			SafeCallback(Color3.fromRGB(r,g,b))
		end)
		ColorPicker.GInput.InputBox.FocusLost:connect(function()
			rgbBoxes(ColorPicker.GInput.InputBox,"G")
			SafeCallback(Color3.fromRGB(r,g,b))
		end)
		ColorPicker.BInput.InputBox.FocusLost:connect(function()
			rgbBoxes(ColorPicker.BInput.InputBox,"B")
			SafeCallback(Color3.fromRGB(r,g,b))
		end)
		RunService.RenderStepped:connect(function()
			if mainDragging then 
				local localX = math.clamp(mouse.X-Main.AbsolutePosition.X,0,Main.AbsoluteSize.X)
				local localY = math.clamp(mouse.Y-Main.AbsolutePosition.Y,0,Main.AbsoluteSize.Y)
				Main.MainPoint.Position = UDim2.new(0,localX-Main.MainPoint.AbsoluteSize.X/2,0,localY-Main.MainPoint.AbsoluteSize.Y/2)
				s = localX / Main.AbsoluteSize.X
				v = 1 - (localY / Main.AbsoluteSize.Y)
				Display.BackgroundColor3 = Color3.fromHSV(h,s,v)
				Main.MainPoint.ImageColor3 = Color3.fromHSV(h,s,v)
				Background.BackgroundColor3 = Color3.fromHSV(h,1,1)
				local color = Color3.fromHSV(h,s,v) 
				local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
				ColorPicker.RInput.InputBox.Text = tostring(r)
				ColorPicker.GInput.InputBox.Text = tostring(g)
				ColorPicker.BInput.InputBox.Text = tostring(b)
				ColorPicker.HexInput.InputBox.Text = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
				SafeCallback(Color3.fromRGB(r,g,b))
				ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
				ColorPickerV.Color = ColorPickerSettings.Color
			end
			if sliderDragging then 
				local localX = math.clamp(mouse.X-Slider.AbsolutePosition.X,0,Slider.AbsoluteSize.X)
				h = localX / Slider.AbsoluteSize.X
				Display.BackgroundColor3 = Color3.fromHSV(h,s,v)
				Slider.SliderPoint.Position = UDim2.new(0,localX-Slider.SliderPoint.AbsoluteSize.X/2,0.5,0)
				Slider.SliderPoint.ImageColor3 = Color3.fromHSV(h,1,1)
				Background.BackgroundColor3 = Color3.fromHSV(h,1,1)
				Main.MainPoint.ImageColor3 = Color3.fromHSV(h,s,v)
				local color = Color3.fromHSV(h,s,v) 
				local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
				ColorPicker.RInput.InputBox.Text = tostring(r)
				ColorPicker.GInput.InputBox.Text = tostring(g)
				ColorPicker.BInput.InputBox.Text = tostring(b)
				ColorPicker.HexInput.InputBox.Text = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
				SafeCallback(Color3.fromRGB(r,g,b))
				ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
				ColorPickerV.Color = ColorPickerSettings.Color
			end
		end)

		function ColorPickerV:Set(NewColorPickerSettings)

			NewColorPickerSettings = Kwargify(ColorPickerSettings, NewColorPickerSettings or {})

			ColorPickerV.Settings = NewColorPickerSettings
			ColorPickerSettings = NewColorPickerSettings

			ColorPicker.Name = ColorPickerSettings.Name
			ColorPicker.Title.Text = ColorPickerSettings.Name
			ColorPicker.Visible = true

			local h,s,v = ColorPickerSettings.Color:ToHSV()
			local color = Color3.fromHSV(h,s,v) 
			local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
			local hex = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
			ColorPicker.HexInput.InputBox.Text = hex
			setDisplay(h,s,v)
			SafeCallback(Color3.fromRGB(r,g,b))

			ColorPickerV.Color = ColorPickerSettings.Color
		end

		function ColorPickerV:Destroy()
			ColorPicker:Destroy()
		end

		if Flag then
			Aurexis.Options[Flag] = ColorPickerV
		end

		SafeCallback(ColorPickerSettings.Color)

		return ColorPickerV
	end


end

return attachSectionControls
