--[[
    FELSKY 👅 - Violence District Script
    Advanced ESP & Automation System
    Created with love 💕
]]

-- Key System
local KeySystemEnabled = true
local CorrectKey = "zakypacarfelicia"
local KeyEntered = false

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Anti-Kick & Protection
local mt = getrawmetatable(game)
local namecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if method == "Kick" then
        return nil
    end
    return namecall(self, ...)
end)
setreadonly(mt, true)

-- Key System GUI
local function CreateKeySystem()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FelskyKeySystem"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 250)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    Title.Text = "FELSKY 👅 - Key System"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = Title

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(0.8, 0, 0, 40)
    KeyBox.Position = UDim2.new(0.1, 0, 0.35, 0)
    KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    KeyBox.PlaceholderText = "Enter Key Here..."
    KeyBox.Text = ""
    KeyBox.TextColor3 = Color3.new(1, 1, 1)
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.TextSize = 16
    KeyBox.Parent = MainFrame

    local KeyBoxCorner = Instance.new("UICorner")
    KeyBoxCorner.CornerRadius = UDim.new(0, 8)
    KeyBoxCorner.Parent = KeyBox

    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Size = UDim2.new(0.8, 0, 0, 40)
    SubmitButton.Position = UDim2.new(0.1, 0, 0.6, 0)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    SubmitButton.Text = "Submit Key"
    SubmitButton.TextColor3 = Color3.new(1, 1, 1)
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.TextSize = 18
    SubmitButton.Parent = MainFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = SubmitButton

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0, 0, 0.85, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 14
    StatusLabel.Parent = MainFrame

    SubmitButton.MouseButton1Click:Connect(function()
        if KeyBox.Text == CorrectKey then
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            StatusLabel.Text = "✓ Correct Key! Loading..."
            wait(1)
            KeyEntered = true
            ScreenGui:Destroy()
            LoadMainScript()
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            StatusLabel.Text = "✗ Wrong Key! Try Again"
            KeyBox.Text = ""
        end
    end)
end

-- Main Script Variables
local ESPEnabled = {
    Survivors = false,
    Killer = false,
    Generators = false
}

local Features = {
    AutoParry = false,
    AutoFarm = false,
    AutoEscape = false,
    SpeedHack = false,
    SpeedValue = 16,
    Noclip = false,
    Fly = false,
    KillerTP = false,
    KillerHitbox = false
}

local ColorTheme = Color3.fromRGB(255, 20, 147)
local ESPObjects = {}
local GeneratorList = {}
local KillerCharacter = nil

-- Utility Functions
local function GetRole()
    local success, role = pcall(function()
        return LocalPlayer.PlayerGui:FindFirstChild("RoleGui") and LocalPlayer.PlayerGui.RoleGui:FindFirstChild("Role")
    end)
    if success and role then
        return role.Text
    end
    return "Unknown"
end

local function FindKiller()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid:FindFirstChild("Killer") then
                return player.Character
            end
        end
    end
    return nil
end

local function FindGenerators()
    local gens = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Generator" or obj:FindFirstChild("GeneratorPrompt") then
            table.insert(gens, obj)
        end
    end
    return gens
end

local function GetDistanceFromKiller(position)
    if KillerCharacter and KillerCharacter:FindFirstChild("HumanoidRootPart") then
        return (position - KillerCharacter.HumanoidRootPart.Position).Magnitude
    end
    return math.huge
end

local function GetSafestGenerator()
    local generators = FindGenerators()
    local safest = nil
    local maxDistance = 0
    
    for _, gen in pairs(generators) do
        if gen:FindFirstChild("HumanoidRootPart") or gen:IsA("Model") then
            local pos = gen:IsA("Model") and gen.PrimaryPart.Position or gen.Position
            local distance = GetDistanceFromKiller(pos)
            if distance > maxDistance then
                maxDistance = distance
                safest = gen
            end
        end
    end
    return safest
end

-- ESP System
local function CreateESP(object, name, color)
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Adornee = object
    BillboardGui.Size = UDim2.new(0, 100, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Parent = CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    Frame.Parent = BillboardGui

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 0.5, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = name
    TextLabel.TextColor3 = color
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 14
    TextLabel.TextStrokeTransparency = 0
    TextLabel.Parent = Frame

    local Distance = Instance.new("TextLabel")
    Distance.Size = UDim2.new(1, 0, 0.5, 0)
    Distance.Position = UDim2.new(0, 0, 0.5, 0)
    Distance.BackgroundTransparency = 1
    Distance.TextColor3 = Color3.new(1, 1, 1)
    Distance.Font = Enum.Font.Gotham
    Distance.TextSize = 12
    Distance.TextStrokeTransparency = 0
    Distance.Parent = Frame

    RunService.RenderStepped:Connect(function()
        if object and object.Parent and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (object.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            Distance.Text = string.format("[%.1f studs]", dist)
        else
            BillboardGui:Destroy()
        end
    end)

    table.insert(ESPObjects, BillboardGui)
    return BillboardGui
end

local function UpdateESP()
    for _, esp in pairs(ESPObjects) do
        esp:Destroy()
    end
    ESPObjects = {}

    if ESPEnabled.Survivors then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                CreateESP(player.Character.HumanoidRootPart, player.Name, Color3.fromRGB(0, 255, 0))
            end
        end
    end

    if ESPEnabled.Killer then
        KillerCharacter = FindKiller()
        if KillerCharacter and KillerCharacter:FindFirstChild("HumanoidRootPart") then
            CreateESP(KillerCharacter.HumanoidRootPart, "KILLER ⚠️", Color3.fromRGB(255, 0, 0))
        end
    end

    if ESPEnabled.Generators then
        local gens = FindGenerators()
        for _, gen in pairs(gens) do
            if gen:IsA("Model") and gen.PrimaryPart then
                CreateESP(gen.PrimaryPart, "Generator 🔧", Color3.fromRGB(255, 255, 0))
            elseif gen:IsA("Part") then
                CreateESP(gen, "Generator 🔧", Color3.fromRGB(255, 255, 0))
            end
        end
    end
end

-- Speed Hack
local function SetSpeed(value)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end

-- Noclip
local NoclipConnection
local function ToggleNoclip(enabled)
    if enabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
        end
    end
end

-- Fly
local FlyConnection
local FlySpeed = 50
local function ToggleFly(enabled)
    if enabled then
        local Character = LocalPlayer.Character
        local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            local BV = Instance.new("BodyVelocity")
            BV.Velocity = Vector3.new(0, 0, 0)
            BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            BV.Parent = HRP

            FlyConnection = RunService.RenderStepped:Connect(function()
                local Humanoid = Character:FindFirstChild("Humanoid")
                if Humanoid then
                    Humanoid.PlatformStand = true
                end
                
                local direction = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + (Camera.CFrame.LookVector * FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - (Camera.CFrame.LookVector * FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - (Camera.CFrame.RightVector * FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + (Camera.CFrame.RightVector * FlySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + Vector3.new(0, FlySpeed, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    direction = direction - Vector3.new(0, FlySpeed, 0)
                end
                
                BV.Velocity = direction
            end)
        end
    else
        if FlyConnection then
            FlyConnection:Disconnect()
        end
        local Character = LocalPlayer.Character
        local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            for _, obj in pairs(HRP:GetChildren()) do
                if obj:IsA("BodyVelocity") then
                    obj:Destroy()
                end
            end
        end
        local Humanoid = Character and Character:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.PlatformStand = false
        end
    end
end

-- Auto Parry & Farm
local AutoFarmConnection
local function ToggleAutoFarm(enabled)
    if enabled then
        AutoFarmConnection = RunService.Heartbeat:Connect(function()
            local safestGen = GetSafestGenerator()
            if safestGen then
                local Character = LocalPlayer.Character
                if Character and Character:FindFirstChild("HumanoidRootPart") then
                    local genPos = safestGen:IsA("Model") and safestGen.PrimaryPart.Position or safestGen.Position
                    
                    -- Check killer distance
                    if Features.AutoEscape then
                        KillerCharacter = FindKiller()
                        if KillerCharacter and KillerCharacter:FindFirstChild("HumanoidRootPart") then
                            local killerDist = (Character.HumanoidRootPart.Position - KillerCharacter.HumanoidRootPart.Position).Magnitude
                            if killerDist < 30 then
                                -- Escape to safest generator
                                local newSafeGen = GetSafestGenerator()
                                if newSafeGen then
                                    genPos = newSafeGen:IsA("Model") and newSafeGen.PrimaryPart.Position or newSafeGen.Position
                                end
                            end
                        end
                    end
                    
                    Character.HumanoidRootPart.CFrame = CFrame.new(genPos + Vector3.new(0, 3, 0))
                    
                    -- Auto repair simulation
                    if Features.AutoParry then
                        wait(0.1)
                        -- Simulate repair actions
                    end
                end
            end
        end)
    else
        if AutoFarmConnection then
            AutoFarmConnection:Disconnect()
        end
    end
end

-- Killer Features
local function ExpandKillerHitbox()
    if KillerCharacter then
        for _, part in pairs(KillerCharacter:GetChildren()) do
            if part:IsA("BasePart") then
                part.Size = Vector3.new(20, 20, 20)
                part.Transparency = 0.7
                part.CanCollide = false
            end
        end
    end
end

local function TeleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end

-- Main GUI Creation
function LoadMainScript()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FelskyMain"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = ColorTheme
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar

    local TitleFix = Instance.new("Frame")
    TitleFix.Size = UDim2.new(1, 0, 0, 20)
    TitleFix.Position = UDim2.new(0, 0, 1, -20)
    TitleFix.BackgroundColor3 = ColorTheme
    TitleFix.BorderSizePixel = 0
    TitleFix.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "FELSKY 👅"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Parent = TitleBar

    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -35, 0, 5)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Parent = TitleBar

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinimizeBtn

    -- Open Button (Heart Icon)
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Name = "OpenButton"
    OpenBtn.Size = UDim2.new(0, 50, 0, 50)
    OpenBtn.Position = UDim2.new(0, 10, 0, 10)
    OpenBtn.BackgroundColor3 = ColorTheme
    OpenBtn.Text = "💕"
    OpenBtn.TextSize = 25
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.Visible = false
    OpenBtn.Parent = ScreenGui

    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(0, 10)
    OpenCorner.Parent = OpenBtn

    MinimizeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)

    OpenBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        OpenBtn.Visible = false
    end)

    -- Tab System
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0.25, 0, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(0.75, 0, 1, -40)
    ContentContainer.Position = UDim2.new(0.25, 0, 0, 40)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame

    local Tabs = {"Dashboard", "Killer", "Survivors", "Misc", "About"}
    local TabButtons = {}
    local ContentPages = {}

    -- Create Tabs
    for i, tabName in ipairs(Tabs) do
        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 50)
        TabBtn.Position = UDim2.new(0, 0, 0, (i-1) * 50)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.new(1, 1, 1)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 16
        TabBtn.BorderSizePixel = 0
        TabBtn.Parent = TabContainer
        table.insert(TabButtons, TabBtn)

        -- Content Page
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -10, 1, -10)
        Page.Position = UDim2.new(0, 5, 0, 5)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 4
        Page.Visible = (i == 1)
        Page.Parent = ContentContainer
        ContentPages[tabName] = Page

        TabBtn.MouseButton1Click:Connect(function()
            for _, page in pairs(ContentPages) do
                page.Visible = false
            end
            for _, btn in pairs(TabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
            Page.Visible = true
            TabBtn.BackgroundColor3 = ColorTheme
        end)
    end

    TabButtons[1].BackgroundColor3 = ColorTheme

    -- Helper function to create sections
    local function CreateSection(parent, text, yPos)
        local Section = Instance.new("TextLabel")
        Section.Size = UDim2.new(1, -20, 0, 30)
        Section.Position = UDim2.new(0, 10, 0, yPos)
        Section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Section.Text = text
        Section.TextColor3 = ColorTheme
        Section.Font = Enum.Font.GothamBold
        Section.TextSize = 16
        Section.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = Section

        return Section
    end

    local function CreateToggle(parent, text, yPos, callback)
        local Toggle = Instance.new("Frame")
        Toggle.Size = UDim2.new(1, -20, 0, 40)
        Toggle.Position = UDim2.new(0, 10, 0, yPos)
        Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Toggle.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = Toggle

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.7, 0, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Toggle

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 60, 0, 30)
        Button.Position = UDim2.new(1, -70, 0.5, -15)
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Button.Text = "OFF"
        Button.TextColor3 = Color3.new(1, 1, 1)
        Button.Font = Enum.Font.GothamBold
        Button.TextSize = 12
        Button.Parent = Toggle

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Button

        local enabled = false
        Button.MouseButton1Click:Connect(function()
            enabled = not enabled
            if enabled then
                Button.BackgroundColor3 = ColorTheme
                Button.Text = "ON"
            else
                Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                Button.Text = "OFF"
            end
            callback(enabled)
        end)

        return Toggle
    end

    local function CreateSlider(parent, text, yPos, min, max, default, callback)
        local Slider = Instance.new("Frame")
        Slider.Size = UDim2.new(1, -20, 0, 60)
        Slider.Position = UDim2.new(0, 10, 0, yPos)
        Slider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Slider.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = Slider

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -20, 0, 20)
        Label.Position = UDim2.new(0, 10, 0, 5)
        Label.BackgroundTransparency = 1
        Label.Text = text .. ": " .. default
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Slider

        local SliderBar = Instance.new("Frame")
        SliderBar.Size = UDim2.new(1, -20, 0, 6)
        SliderBar.Position = UDim2.new(0, 10, 0, 35)
        SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SliderBar.Parent = Slider

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = SliderBar

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = ColorTheme
        Fill.Parent = SliderBar

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = Fill

        local Dragging = false
        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = false
            end
        end)

        RunService.RenderStepped:Connect(function()
            if Dragging then
                local mouse = UserInputService:GetMouseLocation()
                local relativePos = math.clamp((mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(relativePos, 0, 1, 0)
                local value = math.floor(min + (max - min) * relativePos)
                Label.Text = text .. ": " .. value
                callback(value)
            end
        end)

        return Slider
    end

    local function CreateButton(parent, text, yPos, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -20, 0, 40)
        Button.Position = UDim2.new(0, 10, 0, yPos)
        Button.BackgroundColor3 = ColorTheme
        Button.Text = text
        Button.TextColor3 = Color3.new(1, 1, 1)
        Button.Font = Enum.Font.GothamBold
        Button.TextSize = 14
        Button.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = Button

        Button.MouseButton1Click:Connect(callback)

        return Button
    end

    -- Dashboard Content
    local DashPage = ContentPages["Dashboard"]
    DashPage.CanvasSize = UDim2.new(0, 0, 0, 300)

    CreateSection(DashPage, "📊 Dashboard", 10)

    local InfoFrame = Instance.new("Frame")
    InfoFrame.Size = UDim2.new(1, -20, 0, 200)
    InfoFrame.Position = UDim2.new(0, 10, 0, 50)
    InfoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    InfoFrame.Parent = DashPage

    local InfoCorner = Instance.new("UICorner")
    InfoCorner.CornerRadius = UDim.new(0, 8)
    InfoCorner.Parent = InfoFrame

    local UserLabel = Instance.new("TextLabel")
    UserLabel.Size = UDim2.new(1, -20, 0, 30)
    UserLabel.Position = UDim2.new(0, 10, 0, 10)
    UserLabel.BackgroundTransparency = 1
    UserLabel.Text = "👤 Username: " .. LocalPlayer.Name
    UserLabel.TextColor3 = Color3.new(1, 1, 1)
    UserLabel.Font = Enum.Font.Gotham
    UserLabel.TextSize = 14
    UserLabel.TextXAlignment = Enum.TextXAlignment.Left
    UserLabel.Parent = InfoFrame

    local DisplayLabel = Instance.new("TextLabel")
    DisplayLabel.Size = UDim2.new(1, -20, 0, 30)
    DisplayLabel.Position = UDim2.new(0, 10, 0, 45)
    DisplayLabel.BackgroundTransparency = 1
    DisplayLabel.Text = "📝 Display Name: " .. LocalPlayer.DisplayName
    DisplayLabel.TextColor3 = Color3.new(1, 1, 1)
    DisplayLabel.Font = Enum.Font.Gotham
    DisplayLabel.TextSize = 14
    DisplayLabel.TextXAlignment = Enum.TextXAlignment.Left
    DisplayLabel.Parent = InfoFrame

    local ServerLabel = Instance.new("TextLabel")
    ServerLabel.Size = UDim2.new(1, -20, 0, 30)
    ServerLabel.Position = UDim2.new(0, 10, 0, 80)
    ServerLabel.BackgroundTransparency = 1
    ServerLabel.Text = "🌐 Server ID: " .. game.JobId
    ServerLabel.TextColor3 = Color3.new(1, 1, 1)
    ServerLabel.Font = Enum.Font.Gotham
    ServerLabel.TextSize = 14
    ServerLabel.TextXAlignment = Enum.TextXAlignment.Left
    ServerLabel.Parent = InfoFrame

    local RoleLabel = Instance.new("TextLabel")
    RoleLabel.Size = UDim2.new(1, -20, 0, 30)
    RoleLabel.Position = UDim2.new(0, 10, 0, 115)
    RoleLabel.BackgroundTransparency = 1
    RoleLabel.Text = "🎭 Current Role: Loading..."
    RoleLabel.TextColor3 = Color3.new(1, 1, 1)
    RoleLabel.Font = Enum.Font.Gotham
    RoleLabel.TextSize = 14
    RoleLabel.TextXAlignment = Enum.TextXAlignment.Left
    RoleLabel.Parent = InfoFrame

    spawn(function()
        wait(2)
        RoleLabel.Text = "🎭 Current Role: " .. GetRole()
    end)

    local PlayersLabel = Instance.new("TextLabel")
    PlayersLabel.Size = UDim2.new(1, -20, 0, 30)
    PlayersLabel.Position = UDim2.new(0, 10, 0, 150)
    PlayersLabel.BackgroundTransparency = 1
    PlayersLabel.Text = "👥 Players: " .. #Players:GetPlayers()
    PlayersLabel.TextColor3 = Color3.new(1, 1, 1)
    PlayersLabel.Font = Enum.Font.Gotham
    PlayersLabel.TextSize = 14
    PlayersLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayersLabel.Parent = InfoFrame

    -- Killer Content
    local KillerPage = ContentPages["Killer"]
    KillerPage.CanvasSize = UDim2.new(0, 0, 0, 400)

    CreateSection(KillerPage, "🔪 Killer Features", 10)
    CreateToggle(KillerPage, "Killer ESP", 50, function(enabled)
        ESPEnabled.Killer = enabled
        UpdateESP()
    end)

    CreateToggle(KillerPage, "Expand Killer Hitbox", 100, function(enabled)
        Features.KillerHitbox = enabled
        if enabled then
            spawn(function()
                while Features.KillerHitbox do
                    ExpandKillerHitbox()
                    wait(1)
                end
            end)
        end
    end)

    CreateToggle(KillerPage, "Fly (Killer)", 150, function(enabled)
        if GetRole():lower():find("killer") then
            Features.Fly = enabled
            ToggleFly(enabled)
        end
    end)

    CreateSection(KillerPage, "🎯 Teleport to Players", 200)

    local playerListY = 240
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateButton(KillerPage, "TP to " .. player.Name, playerListY, function()
                TeleportToPlayer(player.Name)
            end)
            playerListY = playerListY + 50
        end
    end

    KillerPage.CanvasSize = UDim2.new(0, 0, 0, playerListY + 20)

    -- Survivors Content
    local SurvPage = ContentPages["Survivors"]
    SurvPage.CanvasSize = UDim2.new(0, 0, 0, 500)

    CreateSection(SurvPage, "👥 Survivor Features", 10)
    CreateToggle(SurvPage, "Survivors ESP", 50, function(enabled)
        ESPEnabled.Survivors = enabled
        UpdateESP()
    end)

    CreateToggle(SurvPage, "Generator ESP", 100, function(enabled)
        ESPEnabled.Generators = enabled
        UpdateESP()
    end)

    CreateToggle(SurvPage, "Auto Parry (Generator)", 150, function(enabled)
        Features.AutoParry = enabled
    end)

    CreateToggle(SurvPage, "Auto Farm + Repair", 200, function(enabled)
        Features.AutoFarm = enabled
        ToggleAutoFarm(enabled)
    end)

    CreateToggle(SurvPage, "Auto Escape from Killer", 250, function(enabled)
        Features.AutoEscape = enabled
    end)

    CreateButton(SurvPage, "Teleport to Safe Generator", 300, function()
        local safeGen = GetSafestGenerator()
        if safeGen and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local pos = safeGen:IsA("Model") and safeGen.PrimaryPart.Position or safeGen.Position
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
        end
    end)

    -- Misc Content
    local MiscPage = ContentPages["Misc"]
    MiscPage.CanvasSize = UDim2.new(0, 0, 0, 400)

    CreateSection(MiscPage, "⚙️ Miscellaneous", 10)
    
    CreateSlider(MiscPage, "Speed Hack", 50, 16, 250, 16, function(value)
        Features.SpeedValue = value
        if Features.SpeedHack then
            SetSpeed(value)
        end
    end)

    CreateToggle(MiscPage, "Enable Speed Hack", 120, function(enabled)
        Features.SpeedHack = enabled
        if enabled then
            spawn(function()
                while Features.SpeedHack do
                    SetSpeed(Features.SpeedValue)
                    wait(0.1)
                end
            end)
        else
            SetSpeed(16)
        end
    end)

    CreateToggle(MiscPage, "Noclip", 170, function(enabled)
        Features.Noclip = enabled
        ToggleNoclip(enabled)
    end)

    CreateToggle(MiscPage, "Fly Mode", 220, function(enabled)
        Features.Fly = enabled
        ToggleFly(enabled)
    end)

    CreateButton(MiscPage, "Refresh ESP", 270, function()
        UpdateESP()
    end)

    -- About Content
    local AboutPage = ContentPages["About"]
    AboutPage.CanvasSize = UDim2.new(0, 0, 0, 400)

    CreateSection(AboutPage, "ℹ️ About FELSKY 👅", 10)

    local AboutFrame = Instance.new("Frame")
    AboutFrame.Size = UDim2.new(1, -20, 0, 300)
    AboutFrame.Position = UDim2.new(0, 10, 0, 50)
    AboutFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    AboutFrame.Parent = AboutPage

    local AboutCorner = Instance.new("UICorner")
    AboutCorner.CornerRadius = UDim.new(0, 8)
    AboutCorner.Parent = AboutFrame

    local AboutText = Instance.new("TextLabel")
    AboutText.Size = UDim2.new(1, -20, 1, -20)
    AboutText.Position = UDim2.new(0, 10, 0, 10)
    AboutText.BackgroundTransparency = 1
    AboutText.Text = [[
💕 FELSKY Script - Violence District

📜 History & Purpose:
Script ini dibuat dengan penuh cinta dan dedikasi untuk membantu para pemain Violence District mendapatkan pengalaman bermain yang lebih baik dan menyenangkan.

✨ Features:
• Advanced ESP System
• Auto Farm & Repair
• Smart Escape System
• Speed Modifications
• Fly & Noclip
• Killer Utilities

👨‍💻 Created by: Felsky Team
❤️ Made with Love for Felicia

⚠️ Disclaimer:
Gunakan script ini dengan bijak dan bertanggung jawab. Kami tidak bertanggung jawab atas konsekuensi dari penggunaan script ini.

Version: 1.0.0
Last Updated: 2024
]]
    AboutText.TextColor3 = Color3.new(1, 1, 1)
    AboutText.Font = Enum.Font.Gotham
    AboutText.TextSize = 12
    AboutText.TextXAlignment = Enum.TextXAlignment.Left
    AboutText.TextYAlignment = Enum.TextYAlignment.Top
    AboutText.TextWrapped = true
    AboutText.Parent = AboutFrame

    -- Rainbow Effect for Title
    spawn(function()
        while wait() do
            for i = 0, 1, 0.01 do
                ColorTheme = Color3.fromHSV(i, 1, 1)
                TitleBar.BackgroundColor3 = ColorTheme
                TitleFix.BackgroundColor3 = ColorTheme
                OpenBtn.BackgroundColor3 = ColorTheme
                for _, btn in pairs(TabButtons) do
                    if btn.BackgroundColor3 ~= Color3.fromRGB(30, 30, 30) then
                        btn.BackgroundColor3 = ColorTheme
                    end
                end
                wait(0.05)
            end
        end
    end)

    -- Auto Update ESP
    spawn(function()
        while wait(2) do
            if ESPEnabled.Survivors or ESPEnabled.Killer or ESPEnabled.Generators then
                UpdateESP()
            end
        end
    end)

    -- Notification
    local function Notify(text)
        game.StarterGui:SetCore("SendNotification", {
            Title = "FELSKY 👅";
            Text = text;
            Duration = 3;
        })
    end

    Notify("Successfully loaded! Press 💕 to open menu")
end

-- Initialize
if KeySystemEnabled then
    CreateKeySystem()
else
    LoadMainScript()
end

-- Keybind to toggle GUI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Minus then
        local gui = CoreGui:FindFirstChild("FelskyMain")
        if gui and gui:FindFirstChild("MainFrame") then
            gui.MainFrame.Visible = not gui.MainFrame.Visible
            gui.OpenButton.Visible = not gui.MainFrame.Visible
        end
    end
end)
