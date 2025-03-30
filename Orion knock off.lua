local OrionLib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local pfp
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = HttpService:GenerateGUID(false)
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		object.Position = pos
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

local function RippleEffect(object)
	spawn(function()
		local Ripple = Instance.new("ImageLabel")
		Ripple.Name = "Ripple"
		Ripple.Parent = object
		Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Ripple.BackgroundTransparency = 1.000
		Ripple.ZIndex = 8
		Ripple.Image = "rbxassetid://2708891598"
		Ripple.ImageTransparency = 0.800
		Ripple.ScaleType = Enum.ScaleType.Fit

		Ripple.Position = UDim2.new((Mouse.X - Ripple.AbsolutePosition.X) / object.AbsoluteSize.X, 0, (Mouse.Y - Ripple.AbsolutePosition.Y) / object.AbsoluteSize.Y, 0)
		TweenService:Create(Ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(-5.5, 0, -15, 0), Size = UDim2.new(12, 0, 30, 0)}):Play()

		wait(0.5)
		TweenService:Create(Ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()

		wait(0.5)
		Ripple:Destroy()
	end)
end

local function Create(name, properties, children)
	local instance = Instance.new(name)
	
	for i, v in pairs(properties or {}) do
		instance[i] = v
	end
	
	for i, child in ipairs(children or {}) do
		child.Parent = instance
	end
	
	return instance
end

local function GetXY(frame)
	local x, y = Mouse.X - frame.AbsolutePosition.X, Mouse.Y - frame.AbsolutePosition.Y
	local maxX, maxY = frame.AbsoluteSize.X, frame.AbsoluteSize.Y
	x = math.clamp(x, 0, maxX)
	y = math.clamp(y, 0, maxY)
	return x, y
end

local function CircleAnim(GuiObject, EndColour, StartColour)
	local PosX, PosY = GetXY(GuiObject)
	local Circle = Create("ImageLabel", {
		Name = "Circle",
		Parent = GuiObject,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		ZIndex = 10,
		Image = "rbxassetid://266543268",
		ImageColor3 = StartColour,
		ImageTransparency = 0.500,
	})
	
	local NewX, NewY = Mouse.X - Circle.AbsolutePosition.X, Mouse.Y - Circle.AbsolutePosition.Y
	Circle.Position = UDim2.new(0, NewX, 0, NewY)
	
	local Size = 0
	if GuiObject.AbsoluteSize.X > GuiObject.AbsoluteSize.Y then
		Size = GuiObject.AbsoluteSize.X * 1.5
	elseif GuiObject.AbsoluteSize.X < GuiObject.AbsoluteSize.Y then
		Size = GuiObject.AbsoluteSize.Y * 1.5
	elseif GuiObject.AbsoluteSize.X == GuiObject.AbsoluteSize.Y then
		Size = GuiObject.AbsoluteSize.X * 1.5
	end
	
	Circle:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size / 2, 0.5, -Size / 2), "Out", "Quad", 0.5, true)
	
	for i = 1, 20 do
		Circle.ImageTransparency = Circle.ImageTransparency + 0.05
		wait(0.5 / 10)
	end
	
	Circle:Destroy()
end

local TabHandler = {}

function TabHandler:CreateTab(name, icon)
	local Tab = {}
	
	local TabFrame = Create("Frame", {
		Name = name.."_Tab",
		Parent = self.TabContainer,
		BackgroundColor3 = Color3.fromRGB(35, 35, 35),
		BorderSizePixel = 0,
		Size = UDim2.new(0, 120, 0, 25),
		Visible = false,
	})
	
	local TabButton = Create("TextButton", {
		Name = name.."_TabButton",
		Parent = self.TabHolder,
		BackgroundColor3 = Color3.fromRGB(35, 35, 35),
		BackgroundTransparency = 0.000,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 120, 0, 25),
		Font = Enum.Font.GothamSemibold,
		Text = name,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 12.000,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	
	local TabIcon = Create("ImageLabel", {
		Name = "TabIcon",
		Parent = TabButton,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(0, 5, 0, 5),
		Size = UDim2.new(0, 15, 0, 15),
		Image = icon,
	})
	
	local UIPadding = Create("UIPadding", {
		Parent = TabButton,
		PaddingLeft = UDim.new(0, 25),
	})
	
	local ElementContainer = Create("ScrollingFrame", {
		Name = "ElementContainer",
		Parent = TabFrame,
		Active = true,
		BackgroundColor3 = Color3.fromRGB(35, 35, 35),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 440, 0, 265),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 5,
	})
	
	local UIListLayout = Create("UIListLayout", {
		Parent = ElementContainer,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
	})
	
	local UIPadding2 = Create("UIPadding", {
		Parent = ElementContainer,
		PaddingLeft = UDim.new(0, 5),
		PaddingTop = UDim.new(0, 5),
	})
	
	TabButton.MouseButton1Click:Connect(function()
		for _, tab in pairs(self.TabContainer:GetChildren()) do
			if tab:IsA("Frame") then
				tab.Visible = false
			end
		end
		
		for _, button in pairs(self.TabHolder:GetChildren()) do
			if button:IsA("TextButton") then
				button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			end
		end
		
		TabFrame.Visible = true
		TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	end)
	
	UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		ElementContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
	end)
	
	function Tab:AddButton(options)
		local ButtonFrame = Create("Frame", {
			Name = options.Name.."_Button",
			Parent = ElementContainer,
			BackgroundColor3 = Color3.fromRGB(45, 45, 45),
			BorderSizePixel = 0,
			Size = UDim2.new(0, 430, 0, 30),
		})
		
		local Button = Create("TextButton", {
			Name = "Button",
			Parent = ButtonFrame,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.GothamSemibold,
			Text = options.Name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 13.000,
		})
		
		Button.MouseButton1Click:Connect(function()
			RippleEffect(Button)
			options.Callback()
		end)
		
		return ButtonFrame
	end
	
	function Tab:AddToggle(options)
		local default = options.Default or false
		local toggled = default
		
		local ToggleFrame = Create("Frame", {
			Name = options.Name.."_Toggle",
			Parent = ElementContainer,
			BackgroundColor3 = Color3.fromRGB(45, 45, 45),
			BorderSizePixel = 0,
			Size = UDim2.new(0, 430, 0, 30),
		})
		
		local ToggleButton = Create("TextButton", {
			Name = "ToggleButton",
			Parent = ToggleFrame,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.GothamSemibold,
			Text = options.Name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 13.000,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		
		local UIPadding3 = Create("UIPadding", {
			Parent = ToggleButton,
			PaddingLeft = UDim.new(0, 5),
		})
		
		local ToggleIndicator = Create("Frame", {
			Name = "ToggleIndicator",
			Parent = ToggleFrame,
			BackgroundColor3 = Color3.fromRGB(35, 35, 35),
			BorderSizePixel = 0,
			Position = UDim2.new(0, 400, 0, 5),
			Size = UDim2.new(0, 20, 0, 20),
		})
		
		local UICorner = Create("UICorner", {
			CornerRadius = UDim.new(0, 4),
			Parent = ToggleIndicator,
		})
		
		local ToggleInner = Create("Frame", {
			Name = "ToggleInner",
			Parent = ToggleIndicator,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 0, 0, 0),
		})
		
		local UICorner2 = Create("UICorner", {
			CornerRadius = UDim.new(0, 4),
			Parent = ToggleInner,
		})
		
		local function UpdateToggle()
			if toggled then
				TweenService:Create(ToggleInner, TweenInfo.new(0.2), {Size = UDim2.new(0, 16, 0, 16)}):Play()
				ToggleInner.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
			else
				TweenService:Create(ToggleInner, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
			end
			options.Callback(toggled)
		end
		
		if default then
			UpdateToggle()
		end
		
		ToggleButton.MouseButton1Click:Connect(function()
			toggled = not toggled
			UpdateToggle()
		end)
		
		return ToggleFrame
	end
	
	function Tab:AddSlider(options)
		local min = options.Min or 0
		local max = options.Max or 100
		local default = options.Default or min
		local callback = options.Callback or function() end
		
		local SliderFrame = Create("Frame", {
			Name = options.Name.."_Slider",
			Parent = ElementContainer,
			BackgroundColor3 = Color3.fromRGB(45, 45, 45),
			BorderSizePixel = 0,
						Size = UDim2.new(0, 430, 0, 50),
		})
		
		local SliderLabel = Create("TextLabel", {
			Name = "SliderLabel",
			Parent = SliderFrame,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 5, 0, 0),
			Size = UDim2.new(0, 200, 0, 30),
			Font = Enum.Font.GothamSemibold,
			Text = options.Name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 13.000,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		
		local SliderValue = Create("TextLabel", {
			Name = "SliderValue",
			Parent = SliderFrame,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 380, 0, 0),
			Size = UDim2.new(0, 45, 0, 30),
			Font = Enum.Font.GothamSemibold,
			Text = tostring(default),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 13.000,
			TextXAlignment = Enum.TextXAlignment.Right,
		})
		
		local SliderBG = Create("Frame", {
			Name = "SliderBG",
			Parent = SliderFrame,
			BackgroundColor3 = Color3.fromRGB(35, 35, 35),
			BorderSizePixel = 0,
			Position = UDim2.new(0, 5, 0, 35),
			Size = UDim2.new(0, 420, 0, 5),
		})
		
		local UICorner = Create("UICorner", {
			CornerRadius = UDim.new(0, 2),
			Parent = SliderBG,
		})
		
		local SliderFill = Create("Frame", {
			Name = "SliderFill",
			Parent = SliderBG,
			BackgroundColor3 = options.Color or Color3.fromRGB(0, 170, 255),
			BorderSizePixel = 0,
			Size = UDim2.new(0, ((default - min) / (max - min)) * 420, 1, 0),
		})
		
		local UICorner2 = Create("UICorner", {
			CornerRadius = UDim.new(0, 2),
			Parent = SliderFill,
		})
		
		local SliderButton = Create("TextButton", {
			Name = "SliderButton",
			Parent = SliderBG,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Size = UDim2.new(1, 0, 1, 0),
			Text = "",
		})
		
		local function UpdateSlider(value)
			value = math.clamp(value, min, max)
			if options.Increment then
				value = math.floor(value / options.Increment) * options.Increment
			end
			
			SliderValue.Text = tostring(value)
			SliderFill:TweenSize(UDim2.new(0, ((value - min) / (max - min)) * 420, 1, 0), "Out", "Quad", 0.1, true)
			callback(value)
		end
		
		UpdateSlider(default)
		
		SliderButton.MouseButton1Down:Connect(function()
			local function Update()
				local mousePos = UserInputService:GetMouseLocation().X
				local relativePos = mousePos - SliderBG.AbsolutePosition.X
				local percent = math.clamp(relativePos / SliderBG.AbsoluteSize.X, 0, 1)
				local value = min + (max - min) * percent
				UpdateSlider(value)
			end
			
			local moveConnection
			local releaseConnection
			
			moveConnection = Mouse.Move:Connect(Update)
			releaseConnection = UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					moveConnection:Disconnect()
					releaseConnection:Disconnect()
				end
			end)
			
			Update()
		end)
		
		return SliderFrame
	end
	
	function Tab:AddDropdown(options)
		local callback = options.Callback or function() end
		local items = options.Options or {}
		local default = options.Default or ""
		
		local DropdownFrame = Create("Frame", {
			Name = options.Name.."_Dropdown",
			Parent = ElementContainer,
			BackgroundColor3 = Color3.fromRGB(45, 45, 45),
			BorderSizePixel = 0,
			Size = UDim2.new(0, 430, 0, 30),
			ClipsDescendants = true,
		})
		
		local DropdownButton = Create("TextButton", {
			Name = "DropdownButton",
			Parent = DropdownFrame,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Size = UDim2.new(1, 0, 0, 30),
			Font = Enum.Font.GothamSemibold,
			Text = options.Name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 13.000,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		
		local UIPadding = Create("UIPadding", {
			Parent = DropdownButton,
			PaddingLeft = UDim.new(0, 5),
		})
		
		local SelectedValue = Create("TextLabel", {
			Name = "SelectedValue",
			Parent = DropdownButton,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 200, 0, 0),
			Size = UDim2.new(0, 200, 1, 0),
			Font = Enum.Font.GothamSemibold,
			Text = default,
			TextColor3 = Color3.fromRGB(180, 180, 180),
			TextSize = 13.000,
			TextXAlignment = Enum.TextXAlignment.Right,
		})
		
		local UIPadding2 = Create("UIPadding", {
			Parent = SelectedValue,
			PaddingRight = UDim.new(0, 5),
		})
		
		local DropdownArrow = Create("ImageLabel", {
			Name = "DropdownArrow",
			Parent = DropdownButton,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 410, 0, 8),
			Size = UDim2.new(0, 15, 0, 15),
			Image = "rbxassetid://6031094670",
			Rotation = 0,
		})
		
		local DropdownContainer = Create("Frame", {
			Name = "DropdownContainer",
			Parent = DropdownFrame,
			BackgroundColor3 = Color3.fromRGB(35, 35, 35),
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, 30),
			Size = UDim2.new(1, 0, 0, 0),
		})
		
		local UIListLayout = Create("UIListLayout", {
			Parent = DropdownContainer,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
		
		local isOpen = false
		local containerSize = 0
		
		local function UpdateDropdown()
			containerSize = UIListLayout.AbsoluteContentSize.Y
			
			if isOpen then
				DropdownFrame:TweenSize(UDim2.new(0, 430, 0, 30 + containerSize), "Out", "Quad", 0.2, true)
				TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
			else
				DropdownFrame:TweenSize(UDim2.new(0, 430, 0, 30), "Out", "Quad", 0.2, true)
				TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
			end
		end
		
		for _, item in ipairs(items) do
			local DropdownItem = Create("TextButton", {
				Name = item.."_Item",
				Parent = DropdownContainer,
				BackgroundColor3 = Color3.fromRGB(35, 35, 35),
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 25),
				Font = Enum.Font.GothamSemibold,
				Text = item,
				TextColor3 = Color3.fromRGB(180, 180, 180),
				TextSize = 13.000,
			})
			
			DropdownItem.MouseButton1Click:Connect(function()
				SelectedValue.Text = item
				isOpen = false
				UpdateDropdown()
				callback(item)
			end)
		end
		
		DropdownButton.MouseButton1Click:Connect(function()
			isOpen = not isOpen
			UpdateDropdown()
		end)
		
		function DropdownFrame:UpdateDropdown(name, defaultVal, newList, newCallback)
			DropdownButton.Text = name or DropdownButton.Text
			SelectedValue.Text = defaultVal or SelectedValue.Text
			
			if newList then
				for _, item in pairs(DropdownContainer:GetChildren()) do
					if item:IsA("TextButton") then
						item:Destroy()
					end
				end
				
				for _, item in ipairs(newList) do
					local DropdownItem = Create("TextButton", {
						Name = item.."_Item",
						Parent = DropdownContainer,
						BackgroundColor3 = Color3.fromRGB(35, 35, 35),
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 25),
						Font = Enum.Font.GothamSemibold,
						Text = item,
						TextColor3 = Color3.fromRGB(180, 180, 180),
						TextSize = 13.000,
					})
					
					DropdownItem.MouseButton1Click:Connect(function()
						SelectedValue.Text = item
						isOpen = false
						UpdateDropdown()
						if newCallback then
							newCallback(item)
						else
							callback(item)
						end
					end)
				end
			end
			
			if newCallback then
				callback = newCallback
			end
		end
		
		return DropdownFrame
	end
	
	function Tab:AddLabel(text)
		local LabelFrame = Create("Frame", {
			Name = "Label",
			Parent = ElementContainer,
			BackgroundColor3 = Color3.fromRGB(45, 45, 45),
			BorderSizePixel = 0,
			Size = UDim2.new(0, 430, 0, 30),
		})
		
		local Label = Create("TextLabel", {
			Name = "Label",
			Parent = LabelFrame,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.GothamSemibold,
			Text = text,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 13.000,
		})
		
		function Label:Set(newText)
			Label.Text = newText
		end
		
		return Label
	end
	
	return Tab
end

function OrionLib:MakeWindow(config)
	config = config or {}
	local name = config.Name or "Orion Library"
	local hidePremium = config.HidePremium or false
	local saveConfig = config.SaveConfig or false
	local configFolder = config.ConfigFolder or "OrionTest"
	
	local MainFrame = Create("Frame", {
		Name = "MainFrame",
		Parent = ScreenGui,
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, -250, 0.5, -150),
		Size = UDim2.new(0, 500, 0, 300),
	})
	
	local TopBar = Create("Frame", {
		Name = "TopBar",
		Parent = MainFrame,
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 30),
	})
	
	local Title = Create("TextLabel", {
		Name = "Title",
		Parent = TopBar,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(0, 10, 0, 0),
		Size = UDim2.new(0, 200, 1, 0),
		Font = Enum.Font.GothamBold,
		Text = name,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14.000,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	
	local CloseButton = Create("TextButton", {
		Name = "CloseButton",
		Parent = TopBar,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(1, -25, 0, 0),
		Size = UDim2.new(0, 25, 0, 30),
		Font = Enum.Font.GothamBold,
		Text = "X",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14.000,
	})
	
	local MinimizeButton = Create("TextButton", {
		Name = "MinimizeButton",
		Parent = TopBar,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(1, -50, 0, 0),
		Size = UDim2.new(0, 25, 0, 30),
		local function loadOrionLib()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/OrionLib.lua"))()
    end)
    
    if success then
        return result
    else
        warn("Failed to load OrionLib: " .. result)
        return nil
    end
end

return loadOrionLib()

            
