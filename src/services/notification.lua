-- src/services/notification.lua
return function(Aurexis, Kwargify, BlurModule, TweenService, Notifications)
	function Aurexis:Notification(data)
		task.spawn(function()
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

			newNotification.BackgroundTransparency = 1
			newNotification.Title.TextTransparency = 1
			newNotification.Description.TextTransparency = 1
			newNotification.UIStroke.Transparency = 1
			newNotification.Shadow.ImageTransparency = 1
			newNotification.Icon.ImageTransparency = 1
			newNotification.Icon.BackgroundTransparency = 1

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
			TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 0.95}):Play()
			TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.82}):Play()

			local waitDuration = math.min(math.max((#newNotification.Description.Text * 0.1) + 2.5, 3), 10)
			task.wait(data.Duration or waitDuration)

			TweenService:Create(newNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
			TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
			TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
			TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
			TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
			TweenService:Create(newNotification.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
			TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, 0)}):Play()
			
			task.wait(1)
			newNotification:Destroy()
		end)
	end
end
