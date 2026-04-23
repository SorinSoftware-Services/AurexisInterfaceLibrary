-- src/services/notification.lua
return function(Aurexis, Kwargify, BlurModule, TweenService, Notifications)
	function Aurexis:Notification(data)
		if Aurexis._destroyed then return end
		task.spawn(function()
			if Aurexis._destroyed then return end
			data = Kwargify({
				Title = "Missing Title",
				Content = "Missing or Unknown Content",
				Icon = "view_in_ar",
				ImageSource = "Material"
			}, data or {})

			local newNotification = Notifications.Template:Clone()
			newNotification.Name = data.Title
			newNotification.Parent = Notifications
			newNotification.LayoutOrder = #Notifications:GetChildren()
			newNotification.Visible = false
			BlurModule(newNotification)

			newNotification.Title.Text = data.Title
			newNotification.Description.Text = data.Content
			newNotification.Icon.Image = Aurexis:GetIcon(data.Icon, data.ImageSource)
			newNotification.Description.TextWrapped = true

			local stroke = newNotification:FindFirstChild("UIStroke")
			local shadow = newNotification:FindFirstChild("Shadow")

			newNotification.BackgroundTransparency = 1
			newNotification.Title.TextTransparency = 1
			newNotification.Description.TextTransparency = 1
			if stroke then stroke.Transparency = 1 end
			if shadow then shadow.ImageTransparency = 1 end
			newNotification.Icon.ImageTransparency = 1
			newNotification.Icon.BackgroundTransparency = 1

			-- close icon button
			local closeBtn = Instance.new("ImageButton")
			closeBtn.Name = "CloseButton"
			closeBtn.Size = UDim2.new(0, 20, 0, 20)
			closeBtn.Position = UDim2.new(1, -26, 0, 6)
			closeBtn.AnchorPoint = Vector2.new(0, 0)
			closeBtn.BackgroundTransparency = 1
			closeBtn.ImageColor3 = Color3.fromRGB(200, 200, 200)
			closeBtn.ImageTransparency = 1
			closeBtn.ZIndex = newNotification.ZIndex + 2
			do
				local iconResult = Aurexis:GetIcon("close", "Material")
				if typeof(iconResult) == "table" and iconResult.id then
					closeBtn.Image = "rbxassetid://" .. iconResult.id
					closeBtn.ImageRectSize = iconResult.imageRectSize
					closeBtn.ImageRectOffset = iconResult.imageRectOffset
				else
					closeBtn.Image = iconResult or ""
				end
			end
			closeBtn.Parent = newNotification

			task.wait()

			newNotification.Size = UDim2.new(1, 0, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)
			newNotification.Icon.Size = UDim2.new(0, 28, 0, 28)
			newNotification.Icon.Position = UDim2.new(0, 16, 0.5, -1)
			newNotification.Visible = true

			newNotification.Description.Size = UDim2.new(1, -65, 0, math.huge)
			local bounds = newNotification.Description.TextBounds.Y + 55
			newNotification.Description.Size = UDim2.new(1, -65, 0, bounds - 35)
			newNotification.Size = UDim2.new(1, 0, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)

			TweenService:Create(newNotification, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, bounds)}):Play()

			task.wait(0.15)
			TweenService:Create(newNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.45}):Play()
			TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			task.wait(0.05)
			TweenService:Create(newNotification.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
			task.wait(0.05)
			TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.35}):Play()
			if stroke then TweenService:Create(stroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 0.95}):Play() end
			if shadow then TweenService:Create(shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.82}):Play() end
			TweenService:Create(closeBtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.4}):Play()

			local dismissed = false
			local function dismiss()
				if dismissed or Aurexis._destroyed then return end
				dismissed = true
				if not newNotification or not newNotification.Parent then return end
				TweenService:Create(newNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
				if stroke then TweenService:Create(stroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 1}):Play() end
				if shadow then TweenService:Create(shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play() end
				TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
				TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
				TweenService:Create(newNotification.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
				TweenService:Create(closeBtn, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
				TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, 0)}):Play()
				task.wait(1)
				if newNotification and newNotification.Parent then
					newNotification:Destroy()
				end
			end

			closeBtn.MouseButton1Click:Connect(dismiss)

			local touchStartX = nil
			local swipeDeltaX = 0
			newNotification.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch then
					touchStartX = input.Position.X
					swipeDeltaX = 0
				end
			end)
			newNotification.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch and touchStartX then
					swipeDeltaX = input.Position.X - touchStartX
				end
			end)
			newNotification.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch and touchStartX then
					if swipeDeltaX > 60 then
						dismiss()
					end
					touchStartX = nil
					swipeDeltaX = 0
				end
			end)

			local waitDuration = math.min(math.max((#newNotification.Description.Text * 0.1) + 2.5, 3), 10)
			task.wait(data.Duration or waitDuration)
			dismiss()
		end)
	end
end
