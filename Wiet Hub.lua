local DexExplorer = {}
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local MainGui = Instance.new("ScreenGui")
MainGui.Name = HttpService:GenerateGUID(false)
MainGui.ResetOnSpawn = false
MainGui.DisplayOrder = 999999999

local function protect_gui(obj)
    if syn and syn.protect_gui then
        syn.protect_gui(obj)
        obj.Parent = CoreGui
    elseif gethui then
        obj.Parent = gethui()
    else
        obj.Parent = CoreGui
    end
end

protect_gui(MainGui)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.6, 0, 0.7, 0)
MainFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainGui

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0.05, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Dex Explorer"
Title.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0.05, 0, 1, 0)
CloseButton.Position = UDim2.new(0.95, 0, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14
CloseButton.Parent = TopBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0.05, 0, 1, 0)
MinimizeButton.Position = UDim2.new(0.9, 0, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 14
MinimizeButton.Parent = TopBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 0.95, 0)
ContentFrame.Position = UDim2.new(0, 0, 0.05, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local SplitFrame = Instance.new("Frame")
SplitFrame.Name = "SplitFrame"
SplitFrame.Size = UDim2.new(0.005, 0, 1, 0)
SplitFrame.Position = UDim2.new(0.3, 0, 0, 0)
SplitFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SplitFrame.BorderSizePixel = 0
SplitFrame.Parent = ContentFrame

local TreeFrame = Instance.new("ScrollingFrame")
TreeFrame.Name = "TreeFrame"
TreeFrame.Size = UDim2.new(0.3, 0, 1, 0)
TreeFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TreeFrame.BorderSizePixel = 0
TreeFrame.ScrollBarThickness = 6
TreeFrame.CanvasSize = UDim2.new(0, 0, 10, 0)
TreeFrame.Parent = ContentFrame

local PropertiesFrame = Instance.new("ScrollingFrame")
PropertiesFrame.Name = "PropertiesFrame"
PropertiesFrame.Size = UDim2.new(0.695, 0, 1, 0)
PropertiesFrame.Position = UDim2.new(0.305, 0, 0, 0)
PropertiesFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PropertiesFrame.BorderSizePixel = 0
PropertiesFrame.ScrollBarThickness = 6
PropertiesFrame.CanvasSize = UDim2.new(0, 0, 10, 0)
PropertiesFrame.Parent = ContentFrame

local SearchBar = Instance.new("TextBox")
SearchBar.Name = "SearchBar"
SearchBar.Size = UDim2.new(1, 0, 0.05, 0)
SearchBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SearchBar.BorderSizePixel = 0
SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBar.PlaceholderText = "Search..."
SearchBar.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
SearchBar.Text = ""
SearchBar.Font = Enum.Font.SourceSans
SearchBar.TextSize = 14
SearchBar.Parent = TreeFrame

local function createTreeNode(instance, parent, depth)
    local NodeButton = Instance.new("TextButton")
    NodeButton.Name = instance.Name .. "_Node"
    NodeButton.Size = UDim2.new(1, 0, 0, 20)
    NodeButton.Position = UDim2.new(0, depth * 15, 0, #parent:GetChildren() * 20)
    NodeButton.BackgroundTransparency = 1
    NodeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NodeButton.TextXAlignment = Enum.TextXAlignment.Left
    NodeButton.Font = Enum.Font.SourceSans
    NodeButton.TextSize = 14
    NodeButton.Text = "    " .. instance.Name
    NodeButton.Parent = parent
    
    local Icon = Instance.new("TextLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.new(0, 15, 0, 15)
    Icon.Position = UDim2.new(0, depth * 15, 0, 2.5)
    Icon.BackgroundTransparency = 1
    Icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    Icon.Text = "+"
    Icon.Font = Enum.Font.SourceSansBold
    Icon.TextSize = 14
    Icon.Parent = NodeButton
    
    local IsExpanded = false
    local ChildrenNodes = {}
    
    local function toggleExpand()
        IsExpanded = not IsExpanded
        Icon.Text = IsExpanded and "-" or "+"
        
        if IsExpanded then
            if #ChildrenNodes == 0 then
                local children = instance:GetChildren()
                for i, child in ipairs(children) do
                    ChildrenNodes[i] = createTreeNode(child, parent, depth + 1)
                    ChildrenNodes[i].Position = UDim2.new(0, (depth + 1) * 15, 0, NodeButton.Position.Y.Offset + i * 20)
                    ChildrenNodes[i].Visible = true
                end
            else
                for _, node in ipairs(ChildrenNodes) do
                    node.Visible = true
                end
            end
        else
            for _, node in ipairs(ChildrenNodes) do
                node.Visible = false
            end
        end
        
        local offset = IsExpanded and #instance:GetChildren() * 20 or 0
        local siblings = parent:GetChildren()
        for i = 1, #siblings do
            if siblings[i].Position.Y.Offset > NodeButton.Position.Y.Offset then
                siblings[i].Position = siblings[i].Position + UDim2.new(0, 0, 0, offset)
            end
        end
    end
    
    NodeButton.MouseButton1Click:Connect(function()
        toggleExpand()
        displayProperties(instance)
    end)
    
    return NodeButton
end

local function displayProperties(instance)
    PropertiesFrame:ClearAllChildren()
    
    local properties = {}
    for _, property in ipairs({"Name", "ClassName", "Parent"}) do
        table.insert(properties, {Name = property, Value = tostring(instance[property])})
    end
    
    if instance:IsA("Script") or instance:IsA("LocalScript") or instance:IsA("ModuleScript") then
        local success, source = pcall(function()
            return decompile(instance)
        end)
        
        if not success then
            source = "-- Failed to decompile script"
            pcall(function()
                source = instance.Source
            end)
        end
        
        table.insert(properties, {Name = "Source", Value = source})
    end
    
    for i, prop in ipairs(properties) do
        local PropertyFrame = Instance.new("Frame")
        PropertyFrame.Name = prop.Name .. "_Property"
        PropertyFrame.Size = UDim2.new(1, 0, 0, 25)
        PropertyFrame.Position = UDim2.new(0, 0, 0, (i-1) * 25)
        PropertyFrame.BackgroundColor3 = i % 2 == 0 and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(45, 45, 45)
        PropertyFrame.BorderSizePixel = 0
        PropertyFrame.Parent = PropertiesFrame
        
        local PropertyName = Instance.new("TextLabel")
        PropertyName.Name = "PropertyName"
        PropertyName.Size = UDim2.new(0.3, 0, 1, 0)
        PropertyName.BackgroundTransparency = 1
        PropertyName.TextColor3 = Color3.fromRGB(255, 255, 255)
        PropertyName.TextXAlignment = Enum.TextXAlignment.Left
        PropertyName.Font = Enum.Font.SourceSans
        PropertyName.TextSize = 14
        PropertyName.Text = "  " .. prop.Name
        PropertyName.Parent = PropertyFrame
        
        if prop.Name == "Source" then
            local SourceEditor = Instance.new("TextBox")
            SourceEditor.Name = "SourceEditor"
            SourceEditor.Size = UDim2.new(0.7, 0, 0, 200)
            SourceEditor.Position = UDim2.new(0.3, 0, 0, 0)
            SourceEditor.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SourceEditor.BorderSizePixel = 0
            SourceEditor.TextColor3 = Color3.fromRGB(255, 255, 255)
            SourceEditor.TextXAlignment = Enum.TextXAlignment.Left
            SourceEditor.TextYAlignment = Enum.TextYAlignment.Top
            SourceEditor.Font = Enum.Font.Code
            SourceEditor.TextSize = 14
            SourceEditor.Text = prop.Value
            SourceEditor.MultiLine = true
            SourceEditor.ClearTextOnFocus = false
            SourceEditor.Parent = PropertyFrame
            
            PropertyFrame.Size = UDim2.new(1, 0, 0, 200)
            PropertiesFrame.CanvasSize = UDim2.new(0, 0, 0, (i-1) * 25 + 200 + 25)
        else
            local PropertyValue = Instance.new("TextBox")
            PropertyValue.Name = "PropertyValue"
            PropertyValue.Size = UDim2.new(0.7, 0, 1, 0)
            PropertyValue.Position = UDim2.new(0.3, 0, 0, 0)
            PropertyValue.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            PropertyValue.BorderSizePixel = 0
            PropertyValue.TextColor3 = Color3.fromRGB(255, 255, 255)
            PropertyValue.Font = Enum.Font.SourceSans
            PropertyValue.TextSize = 14
            PropertyValue.Text = prop.Value
            PropertyValue.Parent = PropertyFrame
        end
    end
    
    PropertiesFrame.CanvasSize = UDim2.new(0, 0, 0, #properties * 25)
end

local function populateTree()
    TreeFrame:ClearAllChildren()
    
    local SearchBar = Instance.new("TextBox")
    SearchBar.Name = "SearchBar"
    SearchBar.Size = UDim2.new(1, 0, 0, 30)
    SearchBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SearchBar.BorderSizePixel = 0
    SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBar.PlaceholderText = "Search..."
    SearchBar.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    SearchBar.Text = ""
    SearchBar.Font = Enum.Font.SourceSans
    SearchBar.TextSize = 14
    SearchBar.Parent = TreeFrame
    
    local TreeContainer = Instance.new("Frame")
    TreeContainer.Name = "TreeContainer"
    TreeContainer.Size = UDim2.new(1, 0, 1, -30)
    TreeContainer.Position = UDim2.new(0, 0, 0, 30)
    TreeContainer.BackgroundTransparency = 1
    TreeContainer.Parent = TreeFrame
    
    createTreeNode(game, TreeContainer, 0)

	    SearchBar.Changed:Connect(function(prop)
        if prop == "Text" then
            local searchText = SearchBar.Text:lower()
            if searchText == "" then
                populateTree()
                return
            end
            
            TreeContainer:ClearAllChildren()
            
            local function searchInstance(instance, results)
                if instance.Name:lower():find(searchText) then
                    table.insert(results, instance)
                end
                
                for _, child in ipairs(instance:GetChildren()) do
                    searchInstance(child, results)
                end
            end
            
            local results = {}
            searchInstance(game, results)
            
            for i, instance in ipairs(results) do
                local ResultButton = Instance.new("TextButton")
                ResultButton.Name = instance.Name .. "_Result"
                ResultButton.Size = UDim2.new(1, 0, 0, 20)
                ResultButton.Position = UDim2.new(0, 0, 0, (i-1) * 20)
                ResultButton.BackgroundTransparency = 0.9
                ResultButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                ResultButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                ResultButton.TextXAlignment = Enum.TextXAlignment.Left
                ResultButton.Font = Enum.Font.SourceSans
                ResultButton.TextSize = 14
                ResultButton.Text = "  " .. instance:GetFullName()
                ResultButton.Parent = TreeContainer
                
                ResultButton.MouseButton1Click:Connect(function()
                    displayProperties(instance)
                end)
            end
        end
    end)
end

local function makeDraggable(frame)
    local dragging = false
    local dragInput, mousePos, framePos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            dragInput = input
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragInput and dragging then
            local delta = dragInput.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale, 
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

CloseButton.MouseButton1Click:Connect(function()
    MainGui:Destroy()
end)

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        ContentFrame.Visible = false
        MainFrame.Size = UDim2.new(0.6, 0, 0.05, 0)
    else
        ContentFrame.Visible = true
        MainFrame.Size = UDim2.new(0.6, 0, 0.7, 0)
    end
end)

makeDraggable(TopBar)
populateTree()

local function getAllScripts()
    local scripts = {}
    
    local function findScripts(instance)
        if instance:IsA("Script") or instance:IsA("LocalScript") or instance:IsA("ModuleScript") then
            table.insert(scripts, instance)
        end
        
        for _, child in ipairs(instance:GetChildren()) do
            findScripts(child)
        end
    end
    
    findScripts(game)
    return scripts
end

local function createScriptViewer()
    local ScriptViewerFrame = Instance.new("Frame")
    ScriptViewerFrame.Name = "ScriptViewerFrame"
    ScriptViewerFrame.Size = UDim2.new(0.6, 0, 0.7, 0)
    ScriptViewerFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
    ScriptViewerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ScriptViewerFrame.BorderSizePixel = 0
    ScriptViewerFrame.Visible = false
    ScriptViewerFrame.Parent = MainGui
    
    local ViewerTopBar = Instance.new("Frame")
    ViewerTopBar.Name = "ViewerTopBar"
    ViewerTopBar.Size = UDim2.new(1, 0, 0.05, 0)
    ViewerTopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ViewerTopBar.BorderSizePixel = 0
    ViewerTopBar.Parent = ScriptViewerFrame
    
    local ViewerTitle = Instance.new("TextLabel")
    ViewerTitle.Name = "ViewerTitle"
    ViewerTitle.Size = UDim2.new(0.5, 0, 1, 0)
    ViewerTitle.Position = UDim2.new(0, 10, 0, 0)
    ViewerTitle.BackgroundTransparency = 1
    ViewerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ViewerTitle.TextXAlignment = Enum.TextXAlignment.Left
    ViewerTitle.TextSize = 14
    ViewerTitle.Font = Enum.Font.SourceSansBold
    ViewerTitle.Text = "Script Viewer"
    ViewerTitle.Parent = ViewerTopBar
    
    local ViewerCloseButton = Instance.new("TextButton")
    ViewerCloseButton.Name = "ViewerCloseButton"
    ViewerCloseButton.Size = UDim2.new(0.05, 0, 1, 0)
    ViewerCloseButton.Position = UDim2.new(0.95, 0, 0, 0)
    ViewerCloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    ViewerCloseButton.BorderSizePixel = 0
    ViewerCloseButton.Text = "X"
    ViewerCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ViewerCloseButton.Font = Enum.Font.SourceSansBold
    ViewerCloseButton.TextSize = 14
    ViewerCloseButton.Parent = ViewerTopBar
    
    local ScriptList = Instance.new("ScrollingFrame")
    ScriptList.Name = "ScriptList"
    ScriptList.Size = UDim2.new(0.3, 0, 0.95, 0)
    ScriptList.Position = UDim2.new(0, 0, 0.05, 0)
    ScriptList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ScriptList.BorderSizePixel = 0
    ScriptList.ScrollBarThickness = 6
    ScriptList.CanvasSize = UDim2.new(0, 0, 10, 0)
    ScriptList.Parent = ScriptViewerFrame
    
    local ScriptContent = Instance.new("ScrollingFrame")
    ScriptContent.Name = "ScriptContent"
    ScriptContent.Size = UDim2.new(0.7, 0, 0.95, 0)
    ScriptContent.Position = UDim2.new(0.3, 0, 0.05, 0)
    ScriptContent.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ScriptContent.BorderSizePixel = 0
    ScriptContent.ScrollBarThickness = 6
    ScriptContent.CanvasSize = UDim2.new(0, 0, 10, 0)
    ScriptContent.Parent = ScriptViewerFrame
    
    local ScriptEditor = Instance.new("TextBox")
    ScriptEditor.Name = "ScriptEditor"
    ScriptEditor.Size = UDim2.new(1, -10, 1, -10)
    ScriptEditor.Position = UDim2.new(0, 5, 0, 5)
    ScriptEditor.BackgroundTransparency = 1
    ScriptEditor.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScriptEditor.TextXAlignment = Enum.TextXAlignment.Left
    ScriptEditor.TextYAlignment = Enum.TextYAlignment.Top
    ScriptEditor.Font = Enum.Font.Code
    ScriptEditor.TextSize = 14
    ScriptEditor.Text = "-- Select a script to view"
    ScriptEditor.MultiLine = true
    ScriptEditor.ClearTextOnFocus = false
    ScriptEditor.Parent = ScriptContent
    
    local ScriptSearch = Instance.new("TextBox")
    ScriptSearch.Name = "ScriptSearch"
    ScriptSearch.Size = UDim2.new(1, 0, 0, 30)
    ScriptSearch.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ScriptSearch.BorderSizePixel = 0
    ScriptSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScriptSearch.PlaceholderText = "Search scripts..."
    ScriptSearch.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    ScriptSearch.Text = ""
    ScriptSearch.Font = Enum.Font.SourceSans
    ScriptSearch.TextSize = 14
    ScriptSearch.Parent = ScriptList
    
    local function populateScriptList(filter)
        for i, child in ipairs(ScriptList:GetChildren()) do
            if child.Name ~= "ScriptSearch" then
                child:Destroy()
            end
        end
        
        local scripts = getAllScripts()
        local visibleCount = 0
        
        for i, script in ipairs(scripts) do
            if not filter or script.Name:lower():find(filter:lower()) or script:GetFullName():lower():find(filter:lower()) then
                visibleCount = visibleCount + 1
                
                local ScriptButton = Instance.new("TextButton")
                ScriptButton.Name = script.Name .. "_Button"
                ScriptButton.Size = UDim2.new(1, -10, 0, 25)
                ScriptButton.Position = UDim2.new(0, 5, 0, 30 + (visibleCount-1) * 30)
                ScriptButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                ScriptButton.BorderSizePixel = 0
                ScriptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                ScriptButton.TextXAlignment = Enum.TextXAlignment.Left
                ScriptButton.Font = Enum.Font.SourceSans
                ScriptButton.TextSize = 14
                ScriptButton.Text = "  " .. script.Name
                ScriptButton.Parent = ScriptList
                
                local ScriptType = Instance.new("TextLabel")
                ScriptType.Name = "ScriptType"
                ScriptType.Size = UDim2.new(0, 50, 1, 0)
                ScriptType.Position = UDim2.new(1, -50, 0, 0)
                ScriptType.BackgroundTransparency = 1
                ScriptType.TextColor3 = script:IsA("LocalScript") and Color3.fromRGB(255, 200, 100) or 
                                        (script:IsA("ModuleScript") and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(200, 100, 255))
                ScriptType.Text = script:IsA("LocalScript") and "Local" or 
                                 (script:IsA("ModuleScript") and "Module" or "Server")
                ScriptType.Font = Enum.Font.SourceSansBold
                ScriptType.TextSize = 12
                ScriptType.Parent = ScriptButton
                
                local ScriptPath = Instance.new("TextLabel")
                ScriptPath.Name = "ScriptPath"
                ScriptPath.Size = UDim2.new(1, 0, 0, 20)
                ScriptPath.Position = UDim2.new(0, 0, 0, 25)
                ScriptPath.BackgroundTransparency = 1
                ScriptPath.TextColor3 = Color3.fromRGB(180, 180, 180)
                ScriptPath.TextXAlignment = Enum.TextXAlignment.Left
                ScriptPath.Font = Enum.Font.SourceSansItalic
                ScriptPath.TextSize = 10
                ScriptPath.Text = "  " .. script:GetFullName()
                ScriptPath.TextTruncate = Enum.TextTruncate.AtEnd
                ScriptPath.Parent = ScriptButton
                
                ScriptButton.MouseButton1Click:Connect(function()
                    local success, source = pcall(function()
                        return decompile(script)
                    end)
                    
                    if not success then
                        source = "-- Failed to decompile script"
                        pcall(function()
                            source = script.Source
                        end)
                    end
                    
                    ScriptEditor.Text = source
                    ViewerTitle.Text = "Script Viewer - " .. script.Name
                end)
            end
        end
        
        ScriptList.CanvasSize = UDim2.new(0, 0, 0, 30 + visibleCount * 30 + 10)
    end
    
    ScriptSearch.Changed:Connect(function(prop)
        if prop == "Text" then
            populateScriptList(ScriptSearch.Text)
        end
    end)
    
    ViewerCloseButton.MouseButton1Click:Connect(function()
        ScriptViewerFrame.Visible = false
        MainFrame.Visible = true
    end)
    
    makeDraggable(ViewerTopBar)
    populateScriptList()
    
    return ScriptViewerFrame
end

local ScriptViewerFrame = createScriptViewer()

local ViewScriptsButton = Instance.new("TextButton")
ViewScriptsButton.Name = "ViewScriptsButton"
ViewScriptsButton.Size = UDim2.new(0.15, 0, 1, 0)
ViewScriptsButton.Position = UDim2.new(0.7, 0, 0, 0)
ViewScriptsButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ViewScriptsButton.BorderSizePixel = 0
ViewScriptsButton.Text = "Scripts"
ViewScriptsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ViewScriptsButton.Font = Enum.Font.SourceSansBold
ViewScriptsButton.TextSize = 14
ViewScriptsButton.Parent = TopBar

ViewScriptsButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
        ScriptViewerFrame.Visible = true
end)

local RefreshButton = Instance.new("TextButton")
RefreshButton.Name = "RefreshButton"
RefreshButton.Size = UDim2.new(0.15, 0, 1, 0)
RefreshButton.Position = UDim2.new(0.55, 0, 0, 0)
RefreshButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RefreshButton.BorderSizePixel = 0
RefreshButton.Text = "Refresh"
RefreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshButton.Font = Enum.Font.SourceSansBold
RefreshButton.TextSize = 14
RefreshButton.Parent = TopBar

RefreshButton.MouseButton1Click:Connect(function()
    populateTree()
end)

local function createContextMenu()
    local ContextMenu = Instance.new("Frame")
    ContextMenu.Name = "ContextMenu"
    ContextMenu.Size = UDim2.new(0, 150, 0, 0)
    ContextMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ContextMenu.BorderColor3 = Color3.fromRGB(60, 60, 60)
    ContextMenu.BorderSizePixel = 1
    ContextMenu.Visible = false
    ContextMenu.ZIndex = 10
    ContextMenu.Parent = MainGui
    
    local menuItems = {
        {Name = "Copy Path", Action = function(instance) setclipboard(instance:GetFullName()) end},
        {Name = "View Properties", Action = function(instance) displayProperties(instance) end},
        {Name = "Delete", Action = function(instance) pcall(function() instance:Destroy() end) populateTree() end},
        {Name = "Refresh", Action = function() populateTree() end}
    }
    
    for i, item in ipairs(menuItems) do
        local MenuItem = Instance.new("TextButton")
        MenuItem.Name = item.Name
        MenuItem.Size = UDim2.new(1, 0, 0, 25)
        MenuItem.Position = UDim2.new(0, 0, 0, (i-1) * 25)
        MenuItem.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        MenuItem.BorderSizePixel = 0
        MenuItem.TextColor3 = Color3.fromRGB(255, 255, 255)
        MenuItem.Font = Enum.Font.SourceSans
        MenuItem.TextSize = 14
        MenuItem.Text = item.Name
        MenuItem.ZIndex = 11
        MenuItem.Parent = ContextMenu
        
        MenuItem.MouseEnter:Connect(function()
            MenuItem.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end)
        
        MenuItem.MouseLeave:Connect(function()
            MenuItem.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end)
    end
    
    ContextMenu.Size = UDim2.new(0, 150, 0, #menuItems * 25)
    
    return ContextMenu, menuItems
end

local ContextMenu, menuItems = createContextMenu()
local contextInstance = nil

Mouse.Button2Down:Connect(function()
    local guiObjects = MainGui:GetGuiObjectsAtPosition(Mouse.X, Mouse.Y)
    for _, obj in ipairs(guiObjects) do
        if obj.Parent and obj.Parent.Name == "TreeContainer" then
            contextInstance = game
            local nodeName = obj.Name:gsub("_Node", "")
            
            local function findInstance(parent, name)
                for _, child in ipairs(parent:GetChildren()) do
                    if child.Name == name then
                        return child
                    end
                    local result = findInstance(child, name)
                    if result then return result end
                end
                return nil
            end
            
            local instance = findInstance(game, nodeName)
            if instance then
                contextInstance = instance
                ContextMenu.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)
                ContextMenu.Visible = true
                
                for _, menuItem in ipairs(ContextMenu:GetChildren()) do
                    menuItem.MouseButton1Click:Connect(function()
                        for _, item in ipairs(menuItems) do
                            if item.Name == menuItem.Name then
                                item.Action(contextInstance)
                                ContextMenu.Visible = false
                                break
                            end
                        end
                    end)
                end
            end
            break
        end
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and ContextMenu.Visible then
        local inMenu = false
        local position = Vector2.new(Mouse.X, Mouse.Y)
        local menuPos = ContextMenu.AbsolutePosition
        local menuSize = ContextMenu.AbsoluteSize
        
        if position.X >= menuPos.X and position.X <= menuPos.X + menuSize.X and
           position.Y >= menuPos.Y and position.Y <= menuPos.Y + menuSize.Y then
            inMenu = true
        end
        
        if not inMenu then
            ContextMenu.Visible = false
        end
    end
end)

local function createRemoteSpy()
    local RemoteSpyFrame = Instance.new("Frame")
    RemoteSpyFrame.Name = "RemoteSpyFrame"
    RemoteSpyFrame.Size = UDim2.new(0.6, 0, 0.7, 0)
    RemoteSpyFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
    RemoteSpyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    RemoteSpyFrame.BorderSizePixel = 0
    RemoteSpyFrame.Visible = false
    RemoteSpyFrame.Parent = MainGui
    
    local SpyTopBar = Instance.new("Frame")
    SpyTopBar.Name = "SpyTopBar"
    SpyTopBar.Size = UDim2.new(1, 0, 0.05, 0)
    SpyTopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SpyTopBar.BorderSizePixel = 0
    SpyTopBar.Parent = RemoteSpyFrame
    
    local SpyTitle = Instance.new("TextLabel")
    SpyTitle.Name = "SpyTitle"
    SpyTitle.Size = UDim2.new(0.5, 0, 1, 0)
    SpyTitle.Position = UDim2.new(0, 10, 0, 0)
    SpyTitle.BackgroundTransparency = 1
    SpyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpyTitle.TextXAlignment = Enum.TextXAlignment.Left
    SpyTitle.TextSize = 14
    SpyTitle.Font = Enum.Font.SourceSansBold
    SpyTitle.Text = "Remote Spy"
    SpyTitle.Parent = SpyTopBar
    
    local SpyCloseButton = Instance.new("TextButton")
    SpyCloseButton.Name = "SpyCloseButton"
    SpyCloseButton.Size = UDim2.new(0.05, 0, 1, 0)
    SpyCloseButton.Position = UDim2.new(0.95, 0, 0, 0)
    SpyCloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    SpyCloseButton.BorderSizePixel = 0
    SpyCloseButton.Text = "X"
    SpyCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpyCloseButton.Font = Enum.Font.SourceSansBold
    SpyCloseButton.TextSize = 14
    SpyCloseButton.Parent = SpyTopBar
    
    local RemoteList = Instance.new("ScrollingFrame")
    RemoteList.Name = "RemoteList"
    RemoteList.Size = UDim2.new(1, 0, 0.95, 0)
    RemoteList.Position = UDim2.new(0, 0, 0.05, 0)
    RemoteList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    RemoteList.BorderSizePixel = 0
    RemoteList.ScrollBarThickness = 6
    RemoteList.CanvasSize = UDim2.new(0, 0, 10, 0)
    RemoteList.Parent = RemoteSpyFrame
    
    local RemoteSearch = Instance.new("TextBox")
    RemoteSearch.Name = "RemoteSearch"
    RemoteSearch.Size = UDim2.new(1, 0, 0, 30)
    RemoteSearch.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    RemoteSearch.BorderSizePixel = 0
    RemoteSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
    RemoteSearch.PlaceholderText = "Search remotes..."
    RemoteSearch.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    RemoteSearch.Text = ""
    RemoteSearch.Font = Enum.Font.SourceSans
    RemoteSearch.TextSize = 14
    RemoteSearch.Parent = RemoteList
    
    local ClearButton = Instance.new("TextButton")
    ClearButton.Name = "ClearButton"
    ClearButton.Size = UDim2.new(0.15, 0, 1, 0)
    ClearButton.Position = UDim2.new(0.85, 0, 0, 0)
    ClearButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ClearButton.BorderSizePixel = 0
    ClearButton.Text = "Clear"
    ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ClearButton.Font = Enum.Font.SourceSansBold
    ClearButton.TextSize = 14
    ClearButton.Parent = SpyTopBar
    
    local remoteLog = {}
    local remoteCount = 0
    
    local function updateRemoteList(filter)
        for i, child in ipairs(RemoteList:GetChildren()) do
            if child.Name ~= "RemoteSearch" then
                child:Destroy()
            end
        end
        
        local visibleCount = 0
        
        for i = #remoteLog, 1, -1 do
            local remote = remoteLog[i]
            if not filter or remote.Name:lower():find(filter:lower()) or remote.Path:lower():find(filter:lower()) then
                visibleCount = visibleCount + 1
                
                local RemoteFrame = Instance.new("Frame")
                RemoteFrame.Name = "RemoteFrame_" .. i
                RemoteFrame.Size = UDim2.new(1, -10, 0, 60)
                RemoteFrame.Position = UDim2.new(0, 5, 0, 30 + (visibleCount-1) * 65)
                RemoteFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                RemoteFrame.BorderSizePixel = 0
                RemoteFrame.Parent = RemoteList
                
                local RemoteName = Instance.new("TextLabel")
                RemoteName.Name = "RemoteName"
                RemoteName.Size = UDim2.new(0.7, 0, 0, 20)
                RemoteName.Position = UDim2.new(0, 5, 0, 5)
                RemoteName.BackgroundTransparency = 1
                RemoteName.TextColor3 = Color3.fromRGB(255, 255, 255)
                RemoteName.TextXAlignment = Enum.TextXAlignment.Left
                RemoteName.Font = Enum.Font.SourceSansBold
                RemoteName.TextSize = 14
                RemoteName.Text = remote.Name
                RemoteName.Parent = RemoteFrame
                
                local RemoteType = Instance.new("TextLabel")
                RemoteType.Name = "RemoteType"
                RemoteType.Size = UDim2.new(0.3, 0, 0, 20)
                RemoteType.Position = UDim2.new(0.7, 0, 0, 5)
                RemoteType.BackgroundTransparency = 1
                RemoteType.TextColor3 = remote.Type == "RemoteEvent" and Color3.fromRGB(255, 150, 150) or Color3.fromRGB(150, 150, 255)
                RemoteType.TextXAlignment = Enum.TextXAlignment.Right
                RemoteType.Font = Enum.Font.SourceSansBold
                RemoteType.TextSize = 14
                RemoteType.Text = remote.Type
                RemoteType.Parent = RemoteFrame
                
                local RemotePath = Instance.new("TextLabel")
                RemotePath.Name = "RemotePath"
                RemotePath.Size = UDim2.new(1, -10, 0, 15)
                RemotePath.Position = UDim2.new(0, 5, 0, 25)
                RemotePath.BackgroundTransparency = 1
                RemotePath.TextColor3 = Color3.fromRGB(180, 180, 180)
                RemotePath.TextXAlignment = Enum.TextXAlignment.Left
                RemotePath.Font = Enum.Font.SourceSansItalic
                RemotePath.TextSize = 12
                RemotePath.Text = remote.Path
                RemotePath.TextTruncate = Enum.TextTruncate.AtEnd
                RemotePath.Parent = RemoteFrame
                
                local ArgsLabel = Instance.new("TextLabel")
                ArgsLabel.Name = "ArgsLabel"
                ArgsLabel.Size = UDim2.new(1, -10, 0, 15)
                ArgsLabel.Position = UDim2.new(0, 5, 0, 40)
                ArgsLabel.BackgroundTransparency = 1
                ArgsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ArgsLabel.TextXAlignment = Enum.TextXAlignment.Left
                ArgsLabel.Font = Enum.Font.SourceSans
                ArgsLabel.TextSize = 12
                
                local argsText = "Args: "
                for j, arg in ipairs(remote.Args) do
                    if type(arg) == "string" then
                        argsText = argsText .. '"' .. tostring(arg) .. '"'
                    else
                        argsText = argsText .. tostring(arg)
                    end
                    
                    if j < #remote.Args then
                        argsText = argsText .. ", "
                    end
                    
                    if #argsText > 50 then
                        argsText = argsText:sub(1, 47) .. "..."
						                        break
                    end
                end
                
                ArgsLabel.Text = argsText
                ArgsLabel.Parent = RemoteFrame
                
                local CopyButton = Instance.new("TextButton")
                CopyButton.Name = "CopyButton"
                CopyButton.Size = UDim2.new(0, 60, 0, 20)
                CopyButton.Position = UDim2.new(1, -65, 0, 35)
                CopyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                CopyButton.BorderSizePixel = 0
                CopyButton.Text = "Copy"
                CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                CopyButton.Font = Enum.Font.SourceSans
                CopyButton.TextSize = 12
                CopyButton.Parent = RemoteFrame
                
                CopyButton.MouseButton1Click:Connect(function()
                    local code
                    if remote.Type == "RemoteEvent" then
                        code = remote.Path .. ":FireServer("
                    else
                        code = remote.Path .. ":InvokeServer("
                    end
                    
                    for j, arg in ipairs(remote.Args) do
                        if type(arg) == "string" then
                            code = code .. '"' .. tostring(arg) .. '"'
                        else
                            code = code .. tostring(arg)
                        end
                        
                        if j < #remote.Args then
                            code = code .. ", "
                        end
                    end
                    
                    code = code .. ")"
                    setclipboard(code)
                end)
            end
        end
        
        RemoteList.CanvasSize = UDim2.new(0, 0, 0, 30 + visibleCount * 65 + 10)
    end
    
    RemoteSearch.Changed:Connect(function(prop)
        if prop == "Text" then
            updateRemoteList(RemoteSearch.Text)
        end
    end)
    
    SpyCloseButton.MouseButton1Click:Connect(function()
        RemoteSpyFrame.Visible = false
        MainFrame.Visible = true
    end)
    
    ClearButton.MouseButton1Click:Connect(function()
        remoteLog = {}
        remoteCount = 0
        updateRemoteList()
    end)
    
    makeDraggable(SpyTopBar)
    
    local function hookRemote(remote)
        if remote:IsA("RemoteEvent") then
            local oldFireServer = remote.FireServer
            remote.FireServer = function(self, ...)
                local args = {...}
                remoteCount = remoteCount + 1
                table.insert(remoteLog, {
                    Name = remote.Name,
                    Type = "RemoteEvent",
                    Path = remote:GetFullName(),
                    Args = args
                })
                updateRemoteList(RemoteSearch.Text)
                return oldFireServer(self, ...)
            end
        elseif remote:IsA("RemoteFunction") then
            local oldInvokeServer = remote.InvokeServer
            remote.InvokeServer = function(self, ...)
                local args = {...}
                remoteCount = remoteCount + 1
                table.insert(remoteLog, {
                    Name = remote.Name,
                    Type = "RemoteFunction",
                    Path = remote:GetFullName(),
                    Args = args
                })
                updateRemoteList(RemoteSearch.Text)
                return oldInvokeServer(self, ...)
            end
        end
    end
    
    local function hookAllRemotes()
        for _, remote in pairs(game:GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                hookRemote(remote)
            end
        end
        
        game.DescendantAdded:Connect(function(descendant)
            if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
                hookRemote(descendant)
            end
        end)
    end
    
    hookAllRemotes()
    updateRemoteList()
    
    return RemoteSpyFrame
end

local RemoteSpyFrame = createRemoteSpy()

local SpyRemotesButton = Instance.new("TextButton")
SpyRemotesButton.Name = "SpyRemotesButton"
SpyRemotesButton.Size = UDim2.new(0.15, 0, 1, 0)
SpyRemotesButton.Position = UDim2.new(0.4, 0, 0, 0)
SpyRemotesButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpyRemotesButton.BorderSizePixel = 0
SpyRemotesButton.Text = "Remotes"
SpyRemotesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpyRemotesButton.Font = Enum.Font.SourceSansBold
SpyRemotesButton.TextSize = 14
SpyRemotesButton.Parent = TopBar

SpyRemotesButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    RemoteSpyFrame.Visible = true
end)

local function createSettings()
    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Name = "SettingsFrame"
    SettingsFrame.Size = UDim2.new(0.3, 0, 0.4, 0)
    SettingsFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
    SettingsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SettingsFrame.BorderSizePixel = 0
    SettingsFrame.Visible = false
    SettingsFrame.Parent = MainGui
    
    local SettingsTopBar = Instance.new("Frame")
    SettingsTopBar.Name = "SettingsTopBar"
    SettingsTopBar.Size = UDim2.new(1, 0, 0.1, 0)
    SettingsTopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SettingsTopBar.BorderSizePixel = 0
    SettingsTopBar.Parent = SettingsFrame
    
    local SettingsTitle = Instance.new("TextLabel")
    SettingsTitle.Name = "SettingsTitle"
    SettingsTitle.Size = UDim2.new(0.5, 0, 1, 0)
    SettingsTitle.Position = UDim2.new(0, 10, 0, 0)
    SettingsTitle.BackgroundTransparency = 1
    SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
    SettingsTitle.TextSize = 14
    SettingsTitle.Font = Enum.Font.SourceSansBold
    SettingsTitle.Text = "Settings"
    SettingsTitle.Parent = SettingsTopBar
    
    local SettingsCloseButton = Instance.new("TextButton")
    SettingsCloseButton.Name = "SettingsCloseButton"
    SettingsCloseButton.Size = UDim2.new(0.1, 0, 1, 0)
    SettingsCloseButton.Position = UDim2.new(0.9, 0, 0, 0)
    SettingsCloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    SettingsCloseButton.BorderSizePixel = 0
    SettingsCloseButton.Text = "X"
    SettingsCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SettingsCloseButton.Font = Enum.Font.SourceSansBold
    SettingsCloseButton.TextSize = 14
    SettingsCloseButton.Parent = SettingsTopBar
    
    local SettingsContent = Instance.new("Frame")
    SettingsContent.Name = "SettingsContent"
    SettingsContent.Size = UDim2.new(1, 0, 0.9, 0)
    SettingsContent.Position = UDim2.new(0, 0, 0.1, 0)
    SettingsContent.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SettingsContent.BorderSizePixel = 0
    SettingsContent.Parent = SettingsFrame
    
    local ThemeLabel = Instance.new("TextLabel")
    ThemeLabel.Name = "ThemeLabel"
    ThemeLabel.Size = UDim2.new(0.5, 0, 0, 30)
    ThemeLabel.Position = UDim2.new(0, 10, 0, 10)
    ThemeLabel.BackgroundTransparency = 1
    ThemeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ThemeLabel.TextXAlignment = Enum.TextXAlignment.Left
    ThemeLabel.Font = Enum.Font.SourceSans
    ThemeLabel.TextSize = 14
    ThemeLabel.Text = "Theme:"
    ThemeLabel.Parent = SettingsContent
    
    local ThemeDropdown = Instance.new("TextButton")
    ThemeDropdown.Name = "ThemeDropdown"
    ThemeDropdown.Size = UDim2.new(0.5, -20, 0, 30)
    ThemeDropdown.Position = UDim2.new(0.5, 10, 0, 10)
    ThemeDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ThemeDropdown.BorderSizePixel = 0
    ThemeDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    ThemeDropdown.Font = Enum.Font.SourceSans
    ThemeDropdown.TextSize = 14
    ThemeDropdown.Text = "Dark"
    ThemeDropdown.Parent = SettingsContent
    
    local FontSizeLabel = Instance.new("TextLabel")
    FontSizeLabel.Name = "FontSizeLabel"
    FontSizeLabel.Size = UDim2.new(0.5, 0, 0, 30)
    FontSizeLabel.Position = UDim2.new(0, 10, 0, 50)
    FontSizeLabel.BackgroundTransparency = 1
    FontSizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    FontSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
    FontSizeLabel.Font = Enum.Font.SourceSans
    FontSizeLabel.TextSize = 14
    FontSizeLabel.Text = "Font Size:"
    FontSizeLabel.Parent = SettingsContent
    
    local FontSizeSlider = Instance.new("Frame")
    FontSizeSlider.Name = "FontSizeSlider"
    FontSizeSlider.Size = UDim2.new(0.5, -20, 0, 30)
    FontSizeSlider.Position = UDim2.new(0.5, 10, 0, 50)
    FontSizeSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    FontSizeSlider.BorderSizePixel = 0
    FontSizeSlider.Parent = SettingsContent
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Name = "SliderButton"
    SliderButton.Size = UDim2.new(0.2, 0, 1, 0)
    SliderButton.Position = UDim2.new(0.5, 0, 0, 0)
    SliderButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    SliderButton.BorderSizePixel = 0
    SliderButton.Text = ""
    SliderButton.Parent = FontSizeSlider
    
    local FontSizeValue = Instance.new("TextLabel")
    FontSizeValue.Name = "FontSizeValue"
    FontSizeValue.Size = UDim2.new(0, 30, 0, 30)
    FontSizeValue.Position = UDim2.new(1, 10, 0, 0)
    FontSizeValue.BackgroundTransparency = 1
    FontSizeValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    FontSizeValue.Font = Enum.Font.SourceSans
    FontSizeValue.TextSize = 14
    FontSizeValue.Text = "14"
    FontSizeValue.Parent = FontSizeSlider
    
    local AutoRefreshLabel = Instance.new("TextLabel")
    AutoRefreshLabel.Name = "AutoRefreshLabel"
    AutoRefreshLabel.Size = UDim2.new(0.5, 0, 0, 30)
    AutoRefreshLabel.Position = UDim2.new(0, 10, 0, 90)
    AutoRefreshLabel.BackgroundTransparency = 1
    AutoRefreshLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoRefreshLabel.TextXAlignment = Enum.TextXAlignment.Left
    AutoRefreshLabel.Font = Enum.Font.SourceSans
    AutoRefreshLabel.TextSize = 14
    AutoRefreshLabel.Text = "Auto Refresh:"
    AutoRefreshLabel.Parent = SettingsContent
    
    local AutoRefreshToggle = Instance.new("Frame")
    AutoRefreshToggle.Name = "AutoRefreshToggle"
    AutoRefreshToggle.Size = UDim2.new(0, 50, 0, 25)
    AutoRefreshToggle.Position = UDim2.new(0.5, 10, 0, 92.5)
    AutoRefreshToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    AutoRefreshToggle.BorderSizePixel = 0
    AutoRefreshToggle.Parent = SettingsContent
    
    local ToggleButton = Instance.new("Frame")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 20, 0, 20)
    ToggleButton.Position = UDim2.new(0, 2.5, 0, 2.5)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = AutoRefreshToggle
    
    local SaveButton = Instance.new("TextButton")
    SaveButton.Name = "SaveButton"
    SaveButton.Size = UDim2.new(0.5, 0, 0, 30)
    SaveButton.Position = UDim2.new(0.25, 0, 1, -40)
    SaveButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    SaveButton.BorderSizePixel = 0
        SaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SaveButton.Font = Enum.Font.SourceSansBold
    SaveButton.TextSize = 14
    SaveButton.Text = "Save Settings"
    SaveButton.Parent = SettingsContent
    
    local settings = {
        Theme = "Dark",
        FontSize = 14,
        AutoRefresh = false
    }
    
    local function applySettings()
        local theme = settings.Theme
        local fontSize = settings.FontSize
        local autoRefresh = settings.AutoRefresh
        
        if theme == "Dark" then
            MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            TreeFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            PropertiesFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        elseif theme == "Light" then
            MainFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            TopBar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            TreeFrame.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
            PropertiesFrame.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
            
            Title.TextColor3 = Color3.fromRGB(0, 0, 0)
            for _, button in ipairs(TopBar:GetChildren()) do
                if button:IsA("TextButton") and button.Name ~= "CloseButton" then
                    button.TextColor3 = Color3.fromRGB(0, 0, 0)
                end
            end
        end
        
        for _, obj in ipairs(MainGui:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                if obj.TextSize == 14 then
                    obj.TextSize = fontSize
                end
            end
        end
        
        ThemeDropdown.Text = theme
        FontSizeValue.Text = tostring(fontSize)
        SliderButton.Position = UDim2.new((fontSize - 10) / 10, 0, 0, 0)
        
        if autoRefresh then
            AutoRefreshToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            ToggleButton.Position = UDim2.new(0, 27.5, 0, 2.5)
        else
            AutoRefreshToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            ToggleButton.Position = UDim2.new(0, 2.5, 0, 2.5)
        end
    end
    
    local function saveSettings()
        local success, err = pcall(function()
            writefile("DexExplorerSettings.json", HttpService:JSONEncode(settings))
        end)
    end
    
    local function loadSettings()
        local success, content = pcall(function()
            return readfile("DexExplorerSettings.json")
        end)
        
        if success then
            local loadedSettings = HttpService:JSONDecode(content)
            for key, value in pairs(loadedSettings) do
                settings[key] = value
            end
        end
        
        applySettings()
    end
    
    pcall(loadSettings)
    
    local themes = {"Dark", "Light"}
    local themeDropdownOpen = false
    local themeDropdownFrame
    
    ThemeDropdown.MouseButton1Click:Connect(function()
        if themeDropdownOpen then
            if themeDropdownFrame then
                themeDropdownFrame:Destroy()
                themeDropdownFrame = nil
            end
            themeDropdownOpen = false
        else
            themeDropdownFrame = Instance.new("Frame")
            themeDropdownFrame.Name = "ThemeDropdownFrame"
            themeDropdownFrame.Size = UDim2.new(1, 0, 0, #themes * 30)
            themeDropdownFrame.Position = UDim2.new(0, 0, 1, 0)
            themeDropdownFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            themeDropdownFrame.BorderSizePixel = 0
            themeDropdownFrame.ZIndex = 10
            themeDropdownFrame.Parent = ThemeDropdown
            
            for i, theme in ipairs(themes) do
                local ThemeOption = Instance.new("TextButton")
                ThemeOption.Name = theme .. "Option"
                ThemeOption.Size = UDim2.new(1, 0, 0, 30)
                ThemeOption.Position = UDim2.new(0, 0, 0, (i-1) * 30)
                ThemeOption.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                ThemeOption.BorderSizePixel = 0
                ThemeOption.TextColor3 = Color3.fromRGB(255, 255, 255)
                ThemeOption.Font = Enum.Font.SourceSans
                ThemeOption.TextSize = 14
                ThemeOption.Text = theme
                ThemeOption.ZIndex = 11
                ThemeOption.Parent = themeDropdownFrame
                
                ThemeOption.MouseButton1Click:Connect(function()
                    settings.Theme = theme
                    ThemeDropdown.Text = theme
                    themeDropdownFrame:Destroy()
                    themeDropdownFrame = nil
                    themeDropdownOpen = false
                    applySettings()
                end)
            end
            
            themeDropdownOpen = true
        end
    end)
    
    local sliderDragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        sliderDragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliderDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and sliderDragging then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = FontSizeSlider.AbsolutePosition
            local sliderSize = FontSizeSlider.AbsoluteSize
            
            local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
            SliderButton.Position = UDim2.new(relativeX, 0, 0, 0)
            
            local fontSize = math.floor(10 + relativeX * 10)
            FontSizeValue.Text = tostring(fontSize)
            settings.FontSize = fontSize
        end
    end)
    
    AutoRefreshToggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            settings.AutoRefresh = not settings.AutoRefresh
            applySettings()
        end
    end)
    
    SaveButton.MouseButton1Click:Connect(function()
        saveSettings()
        applySettings()
        SettingsFrame.Visible = false
    end)
    
    SettingsCloseButton.MouseButton1Click:Connect(function()
        SettingsFrame.Visible = false
    end)
    
    makeDraggable(SettingsTopBar)
    
    return SettingsFrame
end

local SettingsFrame = createSettings()

local SettingsButton = Instance.new("TextButton")
SettingsButton.Name = "SettingsButton"
SettingsButton.Size = UDim2.new(0.15, 0, 1, 0)
SettingsButton.Position = UDim2.new(0.25, 0, 0, 0)
SettingsButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SettingsButton.BorderSizePixel = 0
SettingsButton.Text = "Settings"
SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsButton.Font = Enum.Font.SourceSansBold
SettingsButton.TextSize = 14
SettingsButton.Parent = TopBar

SettingsButton.MouseButton1Click:Connect(function()
    SettingsFrame.Visible = true
end)

local function createUploadWindow()
    local UploadFrame = Instance.new("Frame")
    UploadFrame.Name = "UploadFrame"
    UploadFrame.Size = UDim2.new(0.3, 0, 0.3, 0)
    UploadFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
    UploadFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    UploadFrame.BorderSizePixel = 0
    UploadFrame.Visible = false
    UploadFrame.Parent = MainGui
    
    local UploadTopBar = Instance.new("Frame")
    UploadTopBar.Name = "UploadTopBar"
    UploadTopBar.Size = UDim2.new(1, 0, 0.1, 0)
    UploadTopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    UploadTopBar.BorderSizePixel = 0
    UploadTopBar.Parent = UploadFrame
    
    local UploadTitle = Instance.new("TextLabel")
    UploadTitle.Name = "UploadTitle"
    UploadTitle.Size = UDim2.new(0.5, 0, 1, 0)
    UploadTitle.Position = UDim2.new(0, 10, 0, 0)
    UploadTitle.BackgroundTransparency = 1
    UploadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    UploadTitle.TextXAlignment = Enum.TextXAlignment.Left
    UploadTitle.TextSize = 14
    UploadTitle.Font = Enum.Font.SourceSansBold
    UploadTitle.Text = "Upload Script"
    UploadTitle.Parent = UploadTopBar
    
    local UploadCloseButton = Instance.new("TextButton")
    UploadCloseButton.Name = "UploadCloseButton"
    UploadCloseButton.Size = UDim2.new(0.1, 0, 1, 0)
    UploadCloseButton.Position = UDim2.new(0.9, 0, 0, 0)
    UploadCloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    UploadCloseButton.BorderSizePixel = 0
    UploadCloseButton.Text = "X"
    UploadCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    UploadCloseButton.Font = Enum.Font.SourceSansBold
    UploadCloseButton.TextSize = 14
    UploadCloseButton.Parent = UploadTopBar
    
    local UploadContent = Instance.new("Frame")
    UploadContent.Name = "UploadContent"
    UploadContent.Size = UDim2.new(1, 0, 0.9, 0)
    UploadContent.Position = UDim2.new(0, 0, 0.1, 0)
    UploadContent.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    UploadContent.BorderSizePixel = 0
    UploadContent.Parent = UploadFrame
    
    local ScriptNameLabel = Instance.new("TextLabel")
    ScriptNameLabel.Name = "ScriptNameLabel"
    ScriptNameLabel.Size = UDim2.new(1, 0, 0, 30)
    ScriptNameLabel.Position = UDim2.new(0, 10, 0, 10)
    ScriptNameLabel.BackgroundTransparency = 1
    ScriptNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScriptNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    ScriptNameLabel.Font = Enum.Font.SourceSans
    ScriptNameLabel.TextSize = 14
    ScriptNameLabel.Text = "Script Name:"
    ScriptNameLabel.Parent = UploadContent
    
    local ScriptNameInput = Instance.new("TextBox")
    ScriptNameInput.Name = "ScriptNameInput"
    ScriptNameInput.Size = UDim2.new(1, -20, 0, 30)
    ScriptNameInput.Position = UDim2.new(0, 10, 0, 40)
    ScriptNameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ScriptNameInput.BorderSizePixel = 0
    ScriptNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScriptNameInput.Font = Enum.Font.SourceSans
    ScriptNameInput.TextSize = 14
    ScriptNameInput.Text = ""
    ScriptNameInput.PlaceholderText = "Enter script name..."
    ScriptNameInput.Parent = UploadContent
    
    local ScriptTypeLabel = Instance.new("TextLabel")
    ScriptTypeLabel.Name = "ScriptTypeLabel"
    ScriptTypeLabel.Size = UDim2.new(1, 0, 0, 30)
    ScriptTypeLabel.Position = UDim2.new(0, 10, 0, 80)
    ScriptTypeLabel.BackgroundTransparency = 1
    ScriptTypeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScriptTypeLabel.TextXAlignment = Enum.TextXAlignment.Left
    ScriptTypeLabel.Font = Enum.Font.SourceSans
    ScriptTypeLabel.TextSize = 14
    ScriptTypeLabel.Text = "Script Type:"
    ScriptTypeLabel.Parent = UploadContent
    
    local ScriptTypeDropdown = Instance.new("TextButton")
    ScriptTypeDropdown.Name = "ScriptTypeDropdown"
    ScriptTypeDropdown.Size = UDim2.new(1, -20, 0, 30)
    ScriptTypeDropdown.Position = UDim2.new(0, 10, 0, 110)
    ScriptTypeDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ScriptTypeDropdown.BorderSizePixel = 0
    ScriptTypeDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScriptTypeDropdown.Font = Enum.Font.SourceSans
    ScriptTypeDropdown.TextSize = 14
    ScriptTypeDropdown.Text = "LocalScript"
    ScriptTypeDropdown.Parent = UploadContent
    
        local UploadButton = Instance.new("TextButton")
    UploadButton.Name = "UploadButton"
    UploadButton.Size = UDim2.new(0.5, 0, 0, 30)
    UploadButton.Position = UDim2.new(0.25, 0, 1, -40)
    UploadButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    UploadButton.BorderSizePixel = 0
    UploadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    UploadButton.Font = Enum.Font.SourceSansBold
    UploadButton.TextSize = 14
    UploadButton.Text = "Upload"
    UploadButton.Parent = UploadContent
    
    local scriptTypes = {"LocalScript", "Script", "ModuleScript"}
    local typeDropdownOpen = false
    local typeDropdownFrame
    
    ScriptTypeDropdown.MouseButton1Click:Connect(function()
        if typeDropdownOpen then
            if typeDropdownFrame then
                typeDropdownFrame:Destroy()
                typeDropdownFrame = nil
            end
            typeDropdownOpen = false
        else
            typeDropdownFrame = Instance.new("Frame")
            typeDropdownFrame.Name = "TypeDropdownFrame"
            typeDropdownFrame.Size = UDim2.new(1, 0, 0, #scriptTypes * 30)
            typeDropdownFrame.Position = UDim2.new(0, 0, 1, 0)
            typeDropdownFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            typeDropdownFrame.BorderSizePixel = 0
            typeDropdownFrame.ZIndex = 10
            typeDropdownFrame.Parent = ScriptTypeDropdown
            
            for i, scriptType in ipairs(scriptTypes) do
                local TypeOption = Instance.new("TextButton")
                TypeOption.Name = scriptType .. "Option"
                TypeOption.Size = UDim2.new(1, 0, 0, 30)
                TypeOption.Position = UDim2.new(0, 0, 0, (i-1) * 30)
                TypeOption.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                TypeOption.BorderSizePixel = 0
                TypeOption.TextColor3 = Color3.fromRGB(255, 255, 255)
                TypeOption.Font = Enum.Font.SourceSans
                TypeOption.TextSize = 14
                TypeOption.Text = scriptType
                TypeOption.ZIndex = 11
                TypeOption.Parent = typeDropdownFrame
                
                TypeOption.MouseButton1Click:Connect(function()
                    ScriptTypeDropdown.Text = scriptType
                    typeDropdownFrame:Destroy()
                    typeDropdownFrame = nil
                    typeDropdownOpen = false
                end)
            end
            
            typeDropdownOpen = true
        end
    end)
    
    UploadButton.MouseButton1Click:Connect(function()
        local scriptName = ScriptNameInput.Text
        local scriptType = ScriptTypeDropdown.Text
        
        if scriptName == "" then
            scriptName = "NewScript"
        end
        
        local newScript
        if scriptType == "LocalScript" then
            newScript = Instance.new("LocalScript")
        elseif scriptType == "Script" then
            newScript = Instance.new("Script")
        else
            newScript = Instance.new("ModuleScript")
        end
        
        newScript.Name = scriptName
        
        local success, err = pcall(function()
            newScript.Parent = Player.PlayerGui
        end)
        
        if not success then
            pcall(function()
                newScript.Parent = Player.Backpack
            end)
        end
        
        UploadFrame.Visible = false
        populateTree()
    end)
    
    UploadCloseButton.MouseButton1Click:Connect(function()
        UploadFrame.Visible = false
    end)
    
    makeDraggable(UploadTopBar)
    
    return UploadFrame
end

local UploadFrame = createUploadWindow()

local UploadButton = Instance.new("TextButton")
UploadButton.Name = "UploadButton"
UploadButton.Size = UDim2.new(0.15, 0, 1, 0)
UploadButton.Position = UDim2.new(0.1, 0, 0, 0)
UploadButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
UploadButton.BorderSizePixel = 0
UploadButton.Text = "Upload"
UploadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UploadButton.Font = Enum.Font.SourceSansBold
UploadButton.TextSize = 14
UploadButton.Parent = TopBar

UploadButton.MouseButton1Click:Connect(function()
    UploadFrame.Visible = true
end)

local function createInfoWindow()
    local InfoFrame = Instance.new("Frame")
    InfoFrame.Name = "InfoFrame"
    InfoFrame.Size = UDim2.new(0.3, 0, 0.3, 0)
    InfoFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
    InfoFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    InfoFrame.BorderSizePixel = 0
    InfoFrame.Visible = false
    InfoFrame.Parent = MainGui
    
    local InfoTopBar = Instance.new("Frame")
    InfoTopBar.Name = "InfoTopBar"
    InfoTopBar.Size = UDim2.new(1, 0, 0.1, 0)
    InfoTopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    InfoTopBar.BorderSizePixel = 0
    InfoTopBar.Parent = InfoFrame
    
    local InfoTitle = Instance.new("TextLabel")
    InfoTitle.Name = "InfoTitle"
    InfoTitle.Size = UDim2.new(0.5, 0, 1, 0)
    InfoTitle.Position = UDim2.new(0, 10, 0, 0)
    InfoTitle.BackgroundTransparency = 1
    InfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoTitle.TextXAlignment = Enum.TextXAlignment.Left
    InfoTitle.TextSize = 14
    InfoTitle.Font = Enum.Font.SourceSansBold
    InfoTitle.Text = "About Dex Explorer"
    InfoTitle.Parent = InfoTopBar
    
    local InfoCloseButton = Instance.new("TextButton")
    InfoCloseButton.Name = "InfoCloseButton"
    InfoCloseButton.Size = UDim2.new(0.1, 0, 1, 0)
    InfoCloseButton.Position = UDim2.new(0.9, 0, 0, 0)
    InfoCloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    InfoCloseButton.BorderSizePixel = 0
    InfoCloseButton.Text = "X"
    InfoCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoCloseButton.Font = Enum.Font.SourceSansBold
    InfoCloseButton.TextSize = 14
    InfoCloseButton.Parent = InfoTopBar
    
    local InfoContent = Instance.new("ScrollingFrame")
    InfoContent.Name = "InfoContent"
    InfoContent.Size = UDim2.new(1, 0, 0.9, 0)
    InfoContent.Position = UDim2.new(0, 0, 0.1, 0)
    InfoContent.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    InfoContent.BorderSizePixel = 0
    InfoContent.ScrollBarThickness = 6
    InfoContent.CanvasSize = UDim2.new(0, 0, 2, 0)
    InfoContent.Parent = InfoFrame
    
    local InfoText = Instance.new("TextLabel")
    InfoText.Name = "InfoText"
    InfoText.Size = UDim2.new(1, -20, 1, 0)
    InfoText.Position = UDim2.new(0, 10, 0, 10)
    InfoText.BackgroundTransparency = 1
    InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoText.TextXAlignment = Enum.TextXAlignment.Left
    InfoText.TextYAlignment = Enum.TextYAlignment.Top
    InfoText.TextWrapped = true
    InfoText.Font = Enum.Font.SourceSans
    InfoText.TextSize = 14
    InfoText.Text = [[
Dex Explorer

Features:
- Browse game hierarchy
- View and edit properties
- View script sources
- Remote spy functionality
- Script search
- Upload scripts
- Customizable settings

Controls:
- Left click to select objects
- Right click for context menu
- Use search bars to filter results

This explorer allows you to inspect all scripts in the game, not just local ones.

Credits:
- Original Dex by Moon
- Enhanced version with script inspection
    ]]
    InfoText.Parent = InfoContent
    
    InfoCloseButton.MouseButton1Click:Connect(function()
        InfoFrame.Visible = false
    end)
    
    makeDraggable(InfoTopBar)
    
    return InfoFrame
end

local InfoFrame = createInfoWindow()

local InfoButton = Instance.new("TextButton")
InfoButton.Name = "InfoButton"
InfoButton.Size = UDim2.new(0.05, 0, 1, 0)
InfoButton.Position = UDim2.new(0, 0, 0, 0)
InfoButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
InfoButton.BorderSizePixel = 0
InfoButton.Text = "?"
InfoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoButton.Font = Enum.Font.SourceSansBold
InfoButton.TextSize = 14
InfoButton.Parent = TopBar

InfoButton.MouseButton1Click:Connect(function()
    InfoFrame.Visible = true
end)

return DexExplorer
