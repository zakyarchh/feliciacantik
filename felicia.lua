--[[
    ═══════════════════════════════════════════════════════════
    FELSKY 👅 - VIOLENCE DISTRICT ULTIMATE
    Combined Full Script with Key System
    Made with love for Felicia 💕
    ═══════════════════════════════════════════════════════════
]]

-- Key System Configuration
local KeySystemEnabled = true
local CorrectKey = "zakypacarfelicia"
local KeyEntered = false

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Teams = game:GetService("Teams")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Anti-Kick Protection
pcall(function()
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
end)

-- Key System GUI
local function CreateKeySystem()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FelskyKeySystem"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 450, 0, 280)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 20, 147)
    UIStroke.Thickness = 3
    UIStroke.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    Title.Text = "FELSKY 👅 - KEY SYSTEM"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 15)
    TitleCorner.Parent = Title

    local TitleFix = Instance.new("Frame")
    TitleFix.Size = UDim2.new(1, 0, 0, 30)
    TitleFix.Position = UDim2.new(0, 0, 1, -30)
    TitleFix.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    TitleFix.BorderSizePixel = 0
    TitleFix.Parent = Title

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, -40, 0, 25)
    SubTitle.Position = UDim2.new(0, 20, 0, 75)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Enter your key to access Violence District Ultimate"
    SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 14
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = MainFrame

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -40, 0, 45)
    KeyBox.Position = UDim2.new(0, 20, 0, 115)
    KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    KeyBox.PlaceholderText = "Key: zakypacarfelicia"
    KeyBox.Text = ""
    KeyBox.TextColor3 = Color3.new(1, 1, 1)
    KeyBox.Font = Enum.Font.GothamBold
    KeyBox.TextSize = 16
    KeyBox.Parent = MainFrame

    local KeyBoxCorner = Instance.new("UICorner")
    KeyBoxCorner.CornerRadius = UDim.new(0, 10)
    KeyBoxCorner.Parent = KeyBox

    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Size = UDim2.new(1, -40, 0, 45)
    SubmitButton.Position = UDim2.new(0, 20, 0, 175)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    SubmitButton.Text = "Submit Key 💕"
    SubmitButton.TextColor3 = Color3.new(1, 1, 1)
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.TextSize = 18
    SubmitButton.Parent = MainFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = SubmitButton

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -40, 0, 30)
    StatusLabel.Position = UDim2.new(0, 20, 0, 235)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextSize = 14
    StatusLabel.Parent = MainFrame

    -- Rainbow effect
    spawn(function()
        while ScreenGui and ScreenGui.Parent do
            for i = 0, 1, 0.01 do
                if not ScreenGui or not ScreenGui.Parent then break end
                local rainbowColor = Color3.fromHSV(i, 1, 1)
                Title.BackgroundColor3 = rainbowColor
                TitleFix.BackgroundColor3 = rainbowColor
                UIStroke.Color = rainbowColor
                SubmitButton.BackgroundColor3 = rainbowColor
                wait(0.05)
            end
        end
    end)

    SubmitButton.MouseButton1Click:Connect(function()
        if KeyBox.Text == CorrectKey then
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            StatusLabel.Text = "✓ Correct Key! Loading FELSKY..."
            wait(1.5)
            KeyEntered = true
            ScreenGui:Destroy()
            LoadMainScript()
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            StatusLabel.Text = "✗ Wrong Key! Try Again"
            KeyBox.Text = ""
            
            -- Shake animation
            for i = 1, 3 do
                MainFrame.Position = MainFrame.Position + UDim2.new(0, 10, 0, 0)
                wait(0.05)
                MainFrame.Position = MainFrame.Position - UDim2.new(0, 20, 0, 0)
                wait(0.05)
                MainFrame.Position = MainFrame.Position + UDim2.new(0, 10, 0, 0)
                wait(0.05)
            end
        end
    end)
end

-- Main Script Loading Function
function LoadMainScript()
    -- Main Script Variables (v11 = Violence District System)
    local v11 = {}
    v11._cache = {}
    v11._connections = {}
    v11._espCache = {}
    v11._lastUpdate = 0
    v11._updateInterval = 0.1

    -- Create Main ScreenGui
    v11.ScreenGui = Instance.new("ScreenGui")
    v11.ScreenGui.Name = "FelskyViolenceDistrict"
    v11.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v11.ScreenGui.ResetOnSpawn = false
    pcall(function() 
        v11.ScreenGui.Parent = CoreGui
    end)

    -- Main Frame
    v11.MainFrame = Instance.new("Frame")
    v11.MainFrame.Name = "MainFrame"
    v11.MainFrame.Size = UDim2.new(0, 550, 0, 650)
    v11.MainFrame.Position = UDim2.new(0, 20, 0, 100)
    v11.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    v11.MainFrame.BorderSizePixel = 0
    v11.MainFrame.ClipsDescendants = true
    v11.MainFrame.Parent = v11.ScreenGui

    -- Draggable functionality
    v11.dragging = false
    v11.dragInput = nil
    v11.dragStart = nil
    v11.startPos = nil

    v11.update = function(input)
        if v11.dragging then
            local delta = input.Position - v11.dragStart
            v11.MainFrame.Position = UDim2.new(
                v11.startPos.X.Scale,
                v11.startPos.X.Offset + delta.X,
                v11.startPos.Y.Scale,
                v11.startPos.Y.Offset + delta.Y
            )
        end
    end

    v11.MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            v11.dragging = true
            v11.dragStart = input.Position
            v11.startPos = v11.MainFrame.Position
        end
    end)

    v11.MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            v11.dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == v11.dragInput and v11.dragging then
            v11.update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            v11.dragging = false
        end
    end)

    -- UI Styling
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = v11.MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 20, 147)
    UIStroke.Thickness = 3
    UIStroke.Parent = v11.MainFrame

    -- Title Frame
    v11.TitleFrame = Instance.new("Frame")
    v11.TitleFrame.Name = "TitleFrame"
    v11.TitleFrame.Size = UDim2.new(1, 0, 0, 50)
    v11.TitleFrame.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    v11.TitleFrame.BorderSizePixel = 0
    v11.TitleFrame.Parent = v11.MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = v11.TitleFrame

    local TitleFix = Instance.new("Frame")
    TitleFix.Size = UDim2.new(1, 0, 0, 25)
    TitleFix.Position = UDim2.new(0, 0, 1, -25)
    TitleFix.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    TitleFix.BorderSizePixel = 0
    TitleFix.Parent = v11.TitleFrame

    v11.TitleLabel = Instance.new("TextLabel")
    v11.TitleLabel.Name = "TitleLabel"
    v11.TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    v11.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    v11.TitleLabel.BackgroundTransparency = 1
    v11.TitleLabel.Text = "FELSKY 👅 - VIOLENCE DISTRICT"
    v11.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    v11.TitleLabel.TextSize = 18
    v11.TitleLabel.Font = Enum.Font.GothamBold
    v11.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    v11.TitleLabel.Parent = v11.TitleFrame

    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
    MinimizeBtn.Position = UDim2.new(1, -45, 0, 5)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 28
    MinimizeBtn.Parent = v11.TitleFrame

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 10)
    MinCorner.Parent = MinimizeBtn

    -- Open Button (Heart Icon)
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Name = "OpenButton"
    OpenBtn.Size = UDim2.new(0, 60, 0, 60)
    OpenBtn.Position = UDim2.new(0, 10, 0, 10)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    OpenBtn.Text = "💕"
    OpenBtn.TextSize = 32
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.Visible = false
    OpenBtn.Parent = v11.ScreenGui

    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(0, 15)
    OpenCorner.Parent = OpenBtn

    local OpenStroke = Instance.new("UIStroke")
    OpenStroke.Color = Color3.fromRGB(255, 20, 147)
    OpenStroke.Thickness = 3
    OpenStroke.Parent = OpenBtn

    MinimizeBtn.MouseButton1Click:Connect(function()
        v11.MainFrame.Visible = false
        OpenBtn.Visible = true
    end)

    OpenBtn.MouseButton1Click:Connect(function()
        v11.MainFrame.Visible = true
        OpenBtn.Visible = false
    end)

    -- Tab Buttons Frame
    v11.TabButtonsFrame = Instance.new("Frame")
    v11.TabButtonsFrame.Name = "TabButtonsFrame"
    v11.TabButtonsFrame.Size = UDim2.new(1, -30, 0, 35)
    v11.TabButtonsFrame.Position = UDim2.new(0, 15, 0, 60)
    v11.TabButtonsFrame.BackgroundTransparency = 1
    v11.TabButtonsFrame.Parent = v11.MainFrame

    local TabButtonsLayout = Instance.new("UIListLayout")
    TabButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
    TabButtonsLayout.Padding = UDim.new(0, 8)
    TabButtonsLayout.Parent = v11.TabButtonsFrame

    -- Content Frame
    v11.ContentFrame = Instance.new("Frame")
    v11.ContentFrame.Name = "ContentFrame"
    v11.ContentFrame.Size = UDim2.new(1, -30, 1, -110)
    v11.ContentFrame.Position = UDim2.new(0, 15, 0, 100)
    v11.ContentFrame.BackgroundTransparency = 1
    v11.ContentFrame.Parent = v11.MainFrame

    -- Create Scrolling Frames for each tab
    v11.ESPSettingsFrame = Instance.new("ScrollingFrame")
    v11.ESPSettingsFrame.Name = "ESPSettingsFrame"
    v11.ESPSettingsFrame.Size = UDim2.new(1, 0, 1, 0)
    v11.ESPSettingsFrame.BackgroundTransparency = 1
    v11.ESPSettingsFrame.ScrollBarThickness = 6
    v11.ESPSettingsFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 20, 147)
    v11.ESPSettingsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    v11.ESPSettingsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    v11.ESPSettingsFrame.Visible = true
    v11.ESPSettingsFrame.Parent = v11.ContentFrame

    v11.ESPColorsFrame = Instance.new("ScrollingFrame")
    v11.ESPColorsFrame.Name = "ESPColorsFrame"
    v11.ESPColorsFrame.Size = UDim2.new(1, 0, 1, 0)
    v11.ESPColorsFrame.BackgroundTransparency = 1
    v11.ESPColorsFrame.ScrollBarThickness = 6
    v11.ESPColorsFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 20, 147)
    v11.ESPColorsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    v11.ESPColorsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    v11.ESPColorsFrame.Visible = false
    v11.ESPColorsFrame.Parent = v11.ContentFrame

    v11.GameFeaturesFrame = Instance.new("ScrollingFrame")
    v11.GameFeaturesFrame.Name = "GameFeaturesFrame"
    v11.GameFeaturesFrame.Size = UDim2.new(1, 0, 1, 0)
    v11.GameFeaturesFrame.BackgroundTransparency = 1
    v11.GameFeaturesFrame.ScrollBarThickness = 6
    v11.GameFeaturesFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 20, 147)
    v11.GameFeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    v11.GameFeaturesFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    v11.GameFeaturesFrame.Visible = false
    v11.GameFeaturesFrame.Parent = v11.ContentFrame

    v11.VisualSettingsFrame = Instance.new("ScrollingFrame")
    v11.VisualSettingsFrame.Name = "VisualSettingsFrame"
    v11.VisualSettingsFrame.Size = UDim2.new(1, 0, 1, 0)
    v11.VisualSettingsFrame.BackgroundTransparency = 1
    v11.VisualSettingsFrame.ScrollBarThickness = 6
    v11.VisualSettingsFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 20, 147)
    v11.VisualSettingsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    v11.VisualSettingsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    v11.VisualSettingsFrame.Visible = false
    v11.VisualSettingsFrame.Parent = v11.ContentFrame

    -- UI Layouts
    local ESPLayout = Instance.new("UIListLayout")
    ESPLayout.Padding = UDim.new(0, 10)
    ESPLayout.Parent = v11.ESPSettingsFrame

    local ColorsLayout = Instance.new("UIListLayout")
    ColorsLayout.Padding = UDim.new(0, 10)
    ColorsLayout.Parent = v11.ESPColorsFrame

    local FeaturesLayout = Instance.new("UIListLayout")
    FeaturesLayout.Padding = UDim.new(0, 10)
    FeaturesLayout.Parent = v11.GameFeaturesFrame

    local VisualLayout = Instance.new("UIListLayout")
    VisualLayout.Padding = UDim.new(0, 10)
    VisualLayout.Parent = v11.VisualSettingsFrame

    -- Initialize Variables
    v11._lastGeneratorCheck = 0
    v11._lastPalletCheck = 0
    v11.AutoRefreshConnection = nil
    v11.ThirdPersonEnabled = false
    v11.ThirdPersonConnection = nil
    v11.OriginalCameraType = nil
    v11.RotatePersonEnabled = false
    v11.RotateSpeed = 100
    v11.RotateConnection = nil
    v11.MenuOpen = true
    v11.ESPEnabled = false
    v11.GeneratorESPEnabled = false
    v11.PalletESPEnabled = false
    v11.SuperESPEnabled = false
    v11.AutoUpdateEnabled = true
    v11.MapLoaded = false
    v11.GameStarted = false
    v11.CrosshairEnabled = false
    v11.walkSpeedActive = false
    v11.walkSpeed = 16
    v11.JumpPowerEnabled = false
    v11.JumpPowerValue = 50
    v11.JumpPowerConnection = nil
    v11.FlyEnabled = false
    v11.FlySpeedValue = 50
    v11.NoclipEnabled = false
    v11.NoclipConnection = nil
    v11.NoclipCharacterConnection = nil
    v11.GodModeEnabled = false
    v11.InvisibleEnabled = false
    v11.AntiStunEnabled = false
    v11.AntiGrabEnabled = false
    v11.MaxEscapeChanceEnabled = false
    v11.GrabKillerEnabled = false
    v11.RapidFireEnabled = false
    v11.DisableTwistAnimationsEnabled = false
    v11.NoFogEnabled = false
    v11.TimeEnabled = false
    v11.TimeValue = 12
    v11.MapColorEnabled = false
    v11.MapColor = Color3.fromRGB(255, 255, 255)
    v11.MapColorSaturation = 1
    v11.SurvivorColor = Color3.fromRGB(0, 255, 0)
    v11.KillerColor = Color3.fromRGB(255, 0, 0)
    v11.GeneratorColor = Color3.fromRGB(0, 100, 255)
    v11.PalletColor = Color3.fromRGB(255, 255, 0)
    v11.RGBESPEnabled = false
    v11.RGBESPSpeed = 1
    v11.SuperESPSpeed = 1
    v11.AimbotEnabled = false
    v11.AimbotConnection = nil
    v11.AimbotTarget = nil
    v11.AimbotFOV = 50
    v11.AimbotSmoothness = 10
    v11.AimbotTeamCheck = true
    v11.AimbotVisibleCheck = true
    v11.AimbotKey = Enum.UserInputType.MouseButton2
    v11.AimbotWallCheck = false
    v11.TeleportEnabled = false
    v11.TeleportFrame = nil
    v11.TeleportPlayersFrame = nil
    v11.TeleportPlayers = {}
    v11.Flying = false
    v11.BodyVelocity = nil
    v11.BodyGyro = nil
    v11.FlyConnection = nil
    v11.ESPFolders = {}
    v11.ESPConnections = {}
    v11.GeneratorESPItems = {}
    v11.PalletESPItems = {}

    -- Crosshair Frame
    v11.CrosshairFrame = Instance.new("Frame")
    v11.CrosshairFrame.Name = "FelskyCrosshair"
    v11.CrosshairFrame.Size = UDim2.new(0, 24, 0, 24)
    v11.CrosshairFrame.Position = UDim2.new(0.5, -12, 0.5, -12)
    v11.CrosshairFrame.BackgroundTransparency = 1
    v11.CrosshairFrame.Visible = false
    v11.CrosshairFrame.ZIndex = 1000
    v11.CrosshairFrame.Parent = v11.ScreenGui

    local CrosshairDot = Instance.new("Frame")
    CrosshairDot.Name = "CrosshairDot"
    CrosshairDot.Size = UDim2.new(0, 6, 0, 6)
    CrosshairDot.Position = UDim2.new(0.5, -3, 0.5, -3)
    CrosshairDot.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    CrosshairDot.BorderSizePixel = 0
    CrosshairDot.Parent = v11.CrosshairFrame

    local CrosshairCorner = Instance.new("UICorner")
    CrosshairCorner.CornerRadius = UDim.new(1, 0)
    CrosshairCorner.Parent = CrosshairDot

    local CrosshairStroke = Instance.new("UIStroke")
    CrosshairStroke.Color = Color3.new(0, 0, 0)
    CrosshairStroke.Thickness = 2
    CrosshairStroke.Parent = CrosshairDot

    -- Aimbot FOV Circle
    v11.AimbotFOVCircle = Instance.new("Frame")
    v11.AimbotFOVCircle.Name = "FelskyFOVCircle"
    v11.AimbotFOVCircle.Size = UDim2.new(0, v11.AimbotFOV * 2, 0, v11.AimbotFOV * 2)
    v11.AimbotFOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    v11.AimbotFOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
    v11.AimbotFOVCircle.BackgroundTransparency = 1
    v11.AimbotFOVCircle.BorderSizePixel = 2
    v11.AimbotFOVCircle.BorderColor3 = Color3.fromRGB(255, 20, 147)
    v11.AimbotFOVCircle.Visible = false
    v11.AimbotFOVCircle.Parent = v11.ScreenGui

    local FOVCorner = Instance.new("UICorner")
    FOVCorner.CornerRadius = UDim.new(1, 0)
    FOVCorner.Parent = v11.AimbotFOVCircle

    -- Helper Functions
    v11.UnlockCursor = function()
        pcall(function()
            UserInputService.MouseIconEnabled = true
            if not v11.FlyEnabled then
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end
        end)
    end

    v11.GetPlayerRole = function(player)
        if not player or player == LocalPlayer then
            return "Unknown"
        end
        
        if v11._cache.roleCache and v11._cache.roleCache[player] and (tick() - (v11._cache.roleCacheTime or 0)) < 2 then
            return v11._cache.roleCache[player]
        end
        
        v11._cache.roleCache = v11._cache.roleCache or {}
        v11._cache.roleCacheTime = tick()
        local role = "Unknown"
        
        pcall(function()
            if player.Team then
                local teamName = string.lower(player.Team.Name)
                if teamName == "spectator" or teamName == "spectators" then
                    role = "Spectator"
                elseif teamName == "killer" or teamName == "murderer" or teamName == "hunter" then
                    role = "Killer"
                elseif teamName == "survivor" or teamName == "civilian" or teamName == "victim" then
                    role = "Survivor"
                end
                v11._cache.roleCache[player] = role
                return
            end
            
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                local roleValue = leaderstats:FindFirstChild("Role") or leaderstats:FindFirstChild("Team") or leaderstats:FindFirstChild("Class")
                if roleValue then
                    local roleText = string.lower(tostring(roleValue.Value))
                    if string.find(roleText, "spectator") then
                        role = "Spectator"
                    elseif string.find(roleText, "killer") or string.find(roleText, "murderer") then
                        role = "Killer"
                    elseif string.find(roleText, "survivor") or string.find(roleText, "civilian") then
                        role = "Survivor"
                    end
                end
            end
            
            v11._cache.roleCache[player] = role
        end)
        
        return role
    end

    v11.IsPlayerSpectator = function(player)
        return v11.GetPlayerRole(player) == "Spectator"
    end

    v11.IsPlayerKiller = function(player)
        return v11.GetPlayerRole(player) == "Killer"
    end

    v11.IsPlayerSurvivor = function(player)
        return v11.GetPlayerRole(player) == "Survivor"
    end

    v11.IsValidPlayerForESP = function(player)
        if not player then return false end
        if player == LocalPlayer then return false end
        if v11.IsPlayerSpectator(player) then return false end
        if not v11.GameStarted then return false end
        return true
    end

    v11.CheckGameStarted = function()
        local success, result = pcall(function()
            v11._cache.roleCache = {}
            local playerCount = 0
            local hasKiller = false
            local hasSurvivor = false
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local role = v11.GetPlayerRole(player)
                    if role == "Killer" then
                        hasKiller = true
                        playerCount = playerCount + 1
                    elseif role == "Survivor" then
                        hasSurvivor = true
                        playerCount = playerCount + 1
                    end
                end
            end
            
            return (hasKiller and hasSurvivor) or (playerCount >= 2 and v11.MapLoaded)
        end)
        
        return (success and result) or false
    end

    v11.CheckMapLoaded = function()
        local success, result = pcall(function()
            local mapObjects = {"Generators", "Generator", "Pallets", "Pallet", "Exit", "Doors", "GameArea", "Map"}
            for _, objName in ipairs(mapObjects) do
                if Workspace:FindFirstChild(objName) then
                    return true
                end
            end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local role = v11.GetPlayerRole(player)
                    if role ~= "Spectator" and role ~= "Unknown" then
                        return true
                    end
                end
            end
            
            return false
        end)
        
        return (success and result) or false
    end

    -- ESP Functions
    v11.CreateESP = function(player)
        if not v11.IsValidPlayerForESP(player) then
            v11.RemoveESP(player)
            return
        end
        
        if v11.ESPFolders[player] then
            if v11.ESPFolders[player].Parent then
                return
            else
                v11.ESPFolders[player] = nil
            end
        end
        
        local function setupESP(character)
            if not character or not character.Parent then
                v11.RemoveESP(player)
                return
            end
            
            local hrp = character:WaitForChild("HumanoidRootPart", 3)
            local humanoid = character:WaitForChild("Humanoid", 3)
            
            if not hrp or not humanoid then
                v11.RemoveESP(player)
                return
            end
            
            if not v11.IsValidPlayerForESP(player) then
                v11.RemoveESP(player)
                return
            end
            
            local role = v11.GetPlayerRole(player)
            local espColor = role == "Killer" and v11.KillerColor or v11.SurvivorColor
            local roleText = role == "Killer" and "KILLER" or "SURVIVOR"
            
            local folder = Instance.new("Folder")
            folder.Name = player.Name .. "_ESP"
            folder.Parent = v11.ScreenGui
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.Adornee = character
            highlight.FillColor = espColor
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = espColor
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = folder
            
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESPBillboard"
            billboard.Adornee = hrp
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 4, 0)
            billboard.AlwaysOnTop = true
            billboard.Enabled = true
            billboard.Parent = folder
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Name = "ESPName"
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name .. " [" .. roleText .. "]"
            nameLabel.TextColor3 = espColor
            nameLabel.TextSize = 16
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            nameLabel.TextStrokeTransparency = 0.5
            nameLabel.Parent = billboard
            
            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Name = "ESPDistance"
            distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.Text = "0m"
            distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            distanceLabel.TextSize = 14
            distanceLabel.Font = Enum.Font.Gotham
            distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            distanceLabel.TextStrokeTransparency = 0.5
            distanceLabel.Parent = billboard
            
            v11.ESPFolders[player] = folder
            
            local connections = {}
            connections.died = humanoid.Died:Connect(function()
                v11.RemoveESP(player)
            end)
            
            connections.characterRemoving = character.AncestryChanged:Connect(function(_, parent)
                if not parent then
                    v11.RemoveESP(player)
                end
            end)
            
            connections.distanceUpdate = RunService.RenderStepped:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and hrp and hrp.Parent then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    distanceLabel.Text = string.format("%.1fm", distance)
                end
            end)
            
            v11.ESPConnections[player] = connections
        end
        
        if player.Character then
            setupESP(player.Character)
        end
        
        local charAddedConn = player.CharacterAdded:Connect(function(character)
            wait(2)
            if v11.IsValidPlayerForESP(player) then
                setupESP(character)
            else
                v11.RemoveESP(player)
            end
        end)
        
        v11.ESPConnections[player] = v11.ESPConnections[player] or {}
        v11.ESPConnections[player].character = charAddedConn
    end

    v11.RemoveESP = function(player)
        if not player then return end
        
        if v11.ESPConnections[player] then
            for _, conn in pairs(v11.ESPConnections[player]) do
                if conn then
                    conn:Disconnect()
                end
            end
            v11.ESPConnections[player] = nil
        end
        
        if v11.ESPFolders[player] then
            pcall(function()
                v11.ESPFolders[player]:Destroy()
            end)
            v11.ESPFolders[player] = nil
        end
    end

    v11.ClearAllESP = function()
        for player, _ in pairs(v11.ESPFolders) do
            v11.RemoveESP(player)
        end
        
        for obj, _ in pairs(v11.GeneratorESPItems) do
            v11.RemoveGeneratorESP(obj)
        end
        
        for obj, _ in pairs(v11.PalletESPItems) do
            v11.RemovePalletESP(obj)
        end
        
        v11.ESPFolders = {}
        v11.GeneratorESPItems = {}
        v11.PalletESPItems = {}
        v11.ESPConnections = {}
    end

    v11.UpdateESP = function()
        for player, folder in pairs(v11.ESPFolders) do
            if not v11.IsValidPlayerForESP(player) or not folder or not folder.Parent then
                v11.RemoveESP(player)
            end
        end
        
        for player, folder in pairs(v11.ESPFolders) do
            if player and folder and folder.Parent and player.Character then
                local role = v11.GetPlayerRole(player)
                local espColor = role == "Killer" and v11.KillerColor or v11.SurvivorColor
                local roleText = role == "Killer" and "KILLER" or "SURVIVOR"
                
                local highlight = folder:FindFirstChild("ESPHighlight")
                local billboard = folder:FindFirstChild("ESPBillboard")
                
                if highlight then
                    highlight.FillColor = espColor
                    highlight.OutlineColor = espColor
                end
                
                if billboard then
                    local nameLabel = billboard:FindFirstChild("ESPName")
                    if nameLabel then
                        nameLabel.TextColor3 = espColor
                        nameLabel.Text = player.Name .. " [" .. roleText .. "]"
                    end
                end
            else
                v11.RemoveESP(player)
            end
        end
    end

    v11.ToggleESP = function(enabled)
        v11.ESPEnabled = enabled
        
        if enabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and not v11.IsPlayerSpectator(player) then
                    v11.CreateESP(player)
                end
            end
            
            if v11.PlayerAddedConnection then
                v11.PlayerAddedConnection:Disconnect()
            end
            
            v11.PlayerAddedConnection = Players.PlayerAdded:Connect(function(player)
                wait(3)
                if not v11.IsPlayerSpectator(player) then
                    v11.CreateESP(player)
                end
            end)
            
            Players.PlayerRemoving:Connect(function(player)
                v11.RemoveESP(player)
            end)
        else
            for player, _ in pairs(v11.ESPFolders) do
                v11.RemoveESP(player)
            end
            
            if v11.PlayerAddedConnection then
                v11.PlayerAddedConnection:Disconnect()
                v11.PlayerAddedConnection = nil
            end
        end
        
        print("ESP Players: " .. (enabled and "ENABLED" or "DISABLED"))
    end

    -- Object ESP Manager
    v11.ObjectESPManager = {
        Enabled = false,
        Objects = {}
    }

    v11.ObjectESPManager.ClearAll = function(self)
        for obj, folder in pairs(self.Objects) do
            if folder and folder.Parent then
                pcall(function()
                    folder:Destroy()
                end)
            end
        end
        self.Objects = {}
    end

    v11.ObjectESPManager.CreateObjectESP = function(self, obj, color, name)
        if not obj or not obj.Parent then return end
        if self.Objects[obj] then return end
        
        local folder = Instance.new("Folder")
        folder.Name = name .. "_ESP"
        folder.Parent = v11.ScreenGui
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "Highlight"
        highlight.Adornee = obj
        highlight.FillColor = color
        highlight.FillTransparency = 0.6
        highlight.OutlineColor = color
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = folder
        
        self.Objects[obj] = folder
        
        spawn(function()
            while obj and obj.Parent do
                wait(2)
            end
            self:RemoveObjectESP(obj)
        end)
    end

    v11.ObjectESPManager.RemoveObjectESP = function(self, obj)
        if self.Objects[obj] then
            pcall(function()
                self.Objects[obj]:Destroy()
            end)
            self.Objects[obj] = nil
        end
    end

    v11.ObjectESPManager.FindAndCreateObjects = function(self, name, color, displayName)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if string.lower(obj.Name) == string.lower(name) and (obj:IsA("Model") or obj:IsA("Part")) then
                self:CreateObjectESP(obj, color, displayName)
            end
        end
    end

    v11.FindAndCreateGenerators = function()
        v11.ObjectESPManager:FindAndCreateObjects("Generator", v11.GeneratorColor, "Generator")
        v11.ObjectESPManager:FindAndCreateObjects("Generators", v11.GeneratorColor, "Generator")
    end

    v11.FindAndCreatePallets = function()
        v11.ObjectESPManager:FindAndCreateObjects("Pallet", v11.PalletColor, "Pallet")
        v11.ObjectESPManager:FindAndCreateObjects("PalletWrong", v11.PalletColor, "Pallet")
        v11.ObjectESPManager:FindAndCreateObjects("Pallets", v11.PalletColor, "Pallet")
    end

    v11.ToggleGeneratorESP = function(enabled)
        v11.GeneratorESPEnabled = enabled
        
        if enabled then
            v11.FindAndCreateGenerators()
            
            if not v11.AutoRefreshConnection then
                v11.AutoRefreshConnection = RunService.Heartbeat:Connect(function()
                    if not v11.GeneratorESPEnabled then
                        v11.AutoRefreshConnection:Disconnect()
                        v11.AutoRefreshConnection = nil
                        return
                    end
                    
                    if tick() - (v11._lastGeneratorCheck or 0) > 5 then
                        v11._lastGeneratorCheck = tick()
                        v11.FindAndCreateGenerators()
                    end
                end)
            end
        else
            for obj, folder in pairs(v11.ObjectESPManager.Objects) do
                if folder and folder.Name:find("Generator") then
                    v11.ObjectESPManager:RemoveObjectESP(obj)
                end
            end
            
            if v11.AutoRefreshConnection then
                v11.AutoRefreshConnection:Disconnect()
                v11.AutoRefreshConnection = nil
            end
        end
        
        print("Generator ESP: " .. (enabled and "ENABLED" or "DISABLED"))
    end

    v11.TogglePalletESP = function(enabled)
        v11.PalletESPEnabled = enabled
        
        if enabled then
            v11.FindAndCreatePallets()
        else
            for obj, folder in pairs(v11.ObjectESPManager.Objects) do
                if folder and folder.Name:find("Pallet") then
                    v11.ObjectESPManager:RemoveObjectESP(obj)
                end
            end
        end
        
        print("Pallet ESP: " .. (enabled and "ENABLED" or "DISABLED"))
    end

    -- Movement Functions
    v11.ToggleWalkSpeed = function(enabled)
        v11.walkSpeedActive = enabled
        
        if enabled then
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = v11.walkSpeed
                end
            end
        else
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            end
        end
        
        print("WalkSpeed: " .. (enabled and "ENABLED (" .. v11.walkSpeed .. ")" or "DISABLED"))
    end

    v11.UpdateWalkSpeedValue = function(value)
        v11.walkSpeed = value
        if v11.walkSpeedActive then
            v11.ToggleWalkSpeed(true)
        end
    end

    v11.UpdateJumpPower = function()
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = v11.JumpPowerValue
            end
        end
    end

    v11.ToggleJumpPower = function(enabled)
        v11.JumpPowerEnabled = enabled
        
        if enabled then
            v11.UpdateJumpPower()
        else
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = 50
                end
            end
        end
        
        print("JumpPower: " .. (enabled and "ENABLED" or "DISABLED"))
    end

    v11.UpdateJumpPowerValue = function(value)
        v11.JumpPowerValue = value
        if v11.JumpPowerEnabled then
            v11.UpdateJumpPower()
        end
    end

    v11.StartFly = function()
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        
        if not hrp or not humanoid then return end
        
        v11.Flying = true
        
        v11.BodyVelocity = Instance.new("BodyVelocity")
        v11.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        v11.BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        v11.BodyVelocity.Parent = hrp
        
        v11.BodyGyro = Instance.new("BodyGyro")
        v11.BodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
        v11.BodyGyro.P = 1000
        v11.BodyGyro.D = 50
        v11.BodyGyro.Parent = hrp
        
        v11.FlyConnection = RunService.Heartbeat:Connect(function()
            if not v11.Flying or not char or not hrp or not v11.BodyVelocity or not v11.BodyGyro then
                return
            end
            
            v11.BodyGyro.CFrame = Camera.CFrame
            
            local direction = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + (Camera.CFrame.LookVector * v11.FlySpeedValue)
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction + (Camera.CFrame.LookVector * -v11.FlySpeedValue)
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction + (Camera.CFrame.RightVector * -v11.FlySpeedValue)
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + (Camera.CFrame.RightVector * v11.FlySpeedValue)
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, v11.FlySpeedValue, 0)
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction + Vector3.new(0, -v11.FlySpeedValue, 0)
            end
            
            v11.BodyVelocity.Velocity = direction
            humanoid.PlatformStand = true
        end)
    end

    v11.StopFly = function()
        v11.Flying = false
        
        if v11.FlyConnection then
            v11.FlyConnection:Disconnect()
        end
        
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            
            if humanoid then
                humanoid.PlatformStand = false
            end
            
            if hrp then
                if v11.BodyVelocity then
                    v11.BodyVelocity:Destroy()
                end
                if v11.BodyGyro then
                    v11.BodyGyro:Destroy()
                end
            end
        end
    end

    v11.ToggleFly = function(enabled)
        v11.FlyEnabled = enabled
        
        if enabled then
            v11.StartFly()
        else
            v11.StopFly()
        end
        
        print("Fly: " .. (enabled and "ENABLED" or "DISABLED"))
    end

    v11.StartNoclip = function()
        local char = LocalPlayer.Character
        if not char then return end
        
        if v11.NoclipConnection then
            v11.NoclipConnection:Disconnect()
            v11.NoclipConnection = nil
        end
        
        v11.NoclipConnection = RunService.Stepped:Connect(function()
            if not v11.NoclipEnabled or not char or not char.Parent then
                if v11.NoclipConnection then
                    v11.NoclipConnection:Disconnect()
                    v11.NoclipConnection = nil
                end
                return
            end
            
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end

    v11.StopNoclip = function()
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        if v11.NoclipConnection then
            v11.NoclipConnection:Disconnect()
            v11.NoclipConnection = nil
        end
    end

    v11.ToggleNoclip = function(enabled)
        v11.NoclipEnabled = enabled
        
        if enabled then
            v11.StartNoclip()
            
            v11.NoclipCharacterConnection = LocalPlayer.CharacterAdded:Connect(function()
                wait(1)
                if v11.NoclipEnabled then
                    v11.StartNoclip()
                end
            end)
        else
            v11.StopNoclip()
            
            if v11.NoclipCharacterConnection then
                v11.NoclipCharacterConnection:Disconnect()
                v11.NoclipCharacterConnection = nil
            end
        end
        
        print("Noclip: " .. (enabled and "ENABLED" or "DISABLED"))
    end

    v11.ToggleGodMode = function(enabled)
        v11.GodModeEnabled = enabled
        
        if enabled then
            if v11.GodModeConnection then
                v11.GodModeConnection:Disconnect()
            end
            
            v11.GodModeConnection = RunService.Heartbeat:Connect(function()
                if not v11.GodModeEnabled then
                    if v11.GodModeConnection then
                        v11.GodModeConnection:Disconnect()
                        v11.GodModeConnection = nil
                    end
                    return
                end
                
                local char = LocalPlayer.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        if humanoid.Health < 100 then
                            humanoid.Health = 100
                        end
                        if humanoid.PlatformStand then
                            humanoid.PlatformStand = false
                        end
                        if humanoid.Sit then
                            humanoid.Sit = false
                        end
                    end
                end
            end)
        else
            if v11.GodModeConnection then
                v11.GodModeConnection:Disconnect()
                v11.GodModeConnection = nil
            end
        end
        
        print("God Mode: " .. (enabled and "ENABLED" or "DISABLED"))
    end

    v11.ToggleAntiStun = function(enabled)
        v11.AntiStunEnabled = enabled
        
        if enabled then
            if v11.AntiStunConnection then
                v11.AntiStunConnection:Disconnect()
            end
            
            v11.AntiStunConnection = RunService.Heartbeat:Connect(function()
                if not v11.AntiStunEnabled then
                    if v11.AntiStunConnection then
                        v11.AntiStunConnection:Disconnect()
                    end
                    return
                end
                
                local char = LocalPlayer.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        if humanoid.PlatformStand then
                            humanoid.PlatformStand = false
                        end
                        if humanoid.Sit then
                            humanoid.Sit = false
                        end
                        if humanoid:GetState() == Enum.HumanoidStateType.FallingDown or humanoid:GetState() == Enum.HumanoidStateType.Ragdoll then
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        end
                    end
                end
            end)
        else
            if v11.AntiStunConnection then
                v11.AntiStunConnection:Disconnect()
                v11.AntiStunConnection = nil
            end
        end
        
        print("AntiStun: " .. (enabled and "ENABLED" or "DISABLED"))
    end

    v11.ToggleAntiGrab = function(enabled)
        v11.AntiGrabEnabled = enabled
        
        if enabled then
            if v11.AntiGrabConnection then
                v11.AntiGrabConnection:Disconnect()
            end
            
            v11.AntiGrabConnection = RunService.Heartbeat:Connect(function()
                if not v11.AntiGrabEnabled then return end
                
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    
                    if hrp and humanoid and humanoid.Health > 0 then
                        if humanoid.PlatformStand then
                            humanoid.PlatformStand = false
                            hrp.Velocity = Vector3.new(0, 50, 0)
                        end
                        
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and v11.IsPlayerKiller(player) then
                                local killerChar = player.Character
                                if killerChar then
                                    local killerHRP = killerChar:FindFirstChild("HumanoidRootPart")
                                    if killerHRP then
                                        local distance = (hrp.Position - killerHRP.Position).Magnitude
                                        if distance < 12 then
                                            local direction = (hrp.Position - killerHRP.Position).Unit
                                            hrp.CFrame = CFrame.new(killerHRP.Position + (direction * 25) + Vector3.new(0, 3, 0))
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            if v11.AntiGrabConnection then
                v11.AntiGrabConnection:Disconnect()
                v11.AntiGrabConnection = nil
            end
        end
        
        print("AntiGrab: " .. (enabled and "ENABLED - ULTRA FAST" or "DISABLED"))
    end

    -- Aimbot Functions
    v11.AimbotFunctions = {}

    v11.AimbotFunctions.isPlayerVisible = function(player)
        if not v11.AimbotWallCheck then
            return true
        end
        
        local char = player.Character
        if not char then return false end
        
        local head = char:FindFirstChild("Head")
        if not head then return false end
        
        local camPos = Camera.CFrame.Position
        local direction = (head.Position - camPos).Unit
        local distance = (head.Position - camPos).Magnitude
        
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, char}
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        rayParams.IgnoreWater = true
        
        local rayResult = Workspace:Raycast(camPos, direction * distance, rayParams)
        return rayResult == nil
    end

    v11.AimbotFunctions.findClosestPlayer = function()
        local closestPlayer = nil
        local closestDistance = v11.AimbotFOV
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if v11.AimbotTeamCheck and not v11.IsPlayerKiller(player) then
                    continue
                end
                
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        if v11.AimbotVisibleCheck and not v11.AimbotFunctions.isPlayerVisible(player) then
                            continue
                        end
                        
                        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                        local distance = (screenCenter - targetPos).Magnitude
                        
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
        
        return closestPlayer
    end

    v11.AimbotFunctions.aimAt = function(player)
        if not player or not player.Character then return end
        
        local head = player.Character:FindFirstChild("Head")
        if not head then return end
        
        local camPos = Camera.CFrame.Position
        local targetPos = head.Position
        local lookCFrame = CFrame.lookAt(camPos, targetPos)
        local smoothness = (100 - v11.AimbotSmoothness) / 100
        
        Camera.CFrame = Camera.CFrame:Lerp(lookCFrame, smoothness)
    end

    v11.AimbotFunctions.updateAimbotUI = function()
        if v11.AimbotEnabled then
            v11.AimbotFOVCircle.Visible = true
        else
            v11.AimbotFOVCircle.Visible = false
        end
        
        v11.AimbotFOVCircle.Size = UDim2.new(0, v11.AimbotFOV * 2, 0, v11.AimbotFOV * 2)
    end

    v11.AimbotFunctions.startAimbot = function()
        if v11.AimbotConnection then
            v11.AimbotConnection:Disconnect()
        end
        
        v11.AimbotConnection = RunService.RenderStepped:Connect(function()
            if v11.AimbotEnabled then
                local target = v11.AimbotFunctions.findClosestPlayer()
                if target then
                    v11.AimbotFunctions.aimAt(target)
                end
            end
        end)
    end

    v11.AimbotFunctions.stopAimbot = function()
        if v11.AimbotConnection then
            v11.AimbotConnection:Disconnect()
            v11.AimbotConnection = nil
        end
    end

    v11.ToggleAimbot = function(enabled)
        v11.AimbotEnabled = enabled
        
        if enabled then
            v11.AimbotFunctions.startAimbot()
        else
            v11.AimbotFunctions.stopAimbot()
        end
        
        v11.AimbotFunctions.updateAimbotUI()
        print("Aimbot: " .. (enabled and "ENABLED" or "DISABLED"))
    end

    v11.UpdateAimbotFOV = function(value)
        v11.AimbotFOV = value
        v11.AimbotFunctions.updateAimbotUI()
    end

    v11.UpdateAimbotSmoothness = function(value)
        v11.AimbotSmoothness = value
    end

    v11.ToggleAimbotTeamCheck = function(enabled)
        v11.AimbotTeamCheck = enabled
    end

    v11.ToggleAimbotVisibleCheck = function(enabled)
        v11.AimbotVisibleCheck = enabled
    end

    v11.ToggleAimbotWallCheck = function(enabled)
        v11.AimbotWallCheck = enabled
    end

    -- Visual Functions
    v11.ToggleCrosshair = function(enabled)
        v11.CrosshairEnabled = enabled
        v11.CrosshairFrame.Visible = enabled
        print("Crosshair: " .. (enabled and "ENABLED" or "DISABLED"))
    end

    v11.ToggleNoFog = function(enabled)
        v11.NoFogEnabled = enabled
        
        if enabled then
            if v11.NoFogConnection then
                v11.NoFogConnection:Disconnect()
            end
            
            v11.NoFogConnection = RunService.Heartbeat:Connect(function()
                if not v11.NoFogEnabled then
                    if v11.NoFogConnection then
                        v11.NoFogConnection:Disconnect()
                    end
                    return
                end
                
                Lighting.FogEnd = 1000000
                Lighting.FogStart = 100000
            end)
        else
            if v11.NoFogConnection then
                v11.NoFogConnection:Disconnect()
                v11.NoFogConnection = nil
            end
            
            Lighting.FogEnd = 1000
            Lighting.FogStart = 0
        end
        
        print("No Fog: " .. (enabled and "ENABLED" or "DISABLED"))
    end

    v11.ToggleTime = function(enabled)
        v11.TimeEnabled = enabled
        
        if enabled then
            if not v11.TimeConnection then
                v11.TimeConnection = RunService.Heartbeat:Connect(function()
                    if not v11.TimeEnabled then
                        if v11.TimeConnection then
                            v11.TimeConnection:Disconnect()
                            v11.TimeConnection = nil
                        end
                        return
                    end
                    Lighting.ClockTime = v11.TimeValue
                end)
            end
        else
            if v11.TimeConnection then
                v11.TimeConnection:Disconnect()
                v11.TimeConnection = nil
            end
        end
        
        print("Custom Time: " .. (enabled and "ENABLED" or "DISABLED"))
    end

    -- UI Creation Functions
    v11.CreateTabButton = function(text, frame)
        local button = Instance.new("TextButton")
        button.Name = text .. "Tab"
        button.Size = UDim2.new(0.25, -6, 1, 0)
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = Color3.fromRGB(200, 200, 200)
        button.TextSize = 13
        button.Font = Enum.Font.GothamBold
        button.Parent = v11.TabButtonsFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            v11.ESPSettingsFrame.Visible = false
            v11.ESPColorsFrame.Visible = false
            v11.GameFeaturesFrame.Visible = false
            v11.VisualSettingsFrame.Visible = false
            frame.Visible = true
            
            for _, tab in ipairs(v11.TabButtonsFrame:GetChildren()) do
                if tab:IsA("TextButton") then
                    tab.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                    tab.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
            
            button.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        return button
    end

    v11.CreateToggle = function(text, default, callback, parent)
        local toggle = Instance.new("Frame")
        toggle.Name = text .. "Toggle"
        toggle.Size = UDim2.new(1, 0, 0, 45)
        toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        toggle.BorderSizePixel = 0
        toggle.Parent = parent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = toggle
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggle
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 60, 0, 30)
        button.Position = UDim2.new(1, -75, 0.5, -15)
        button.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 90)
        button.BorderSizePixel = 0
        button.Text = ""
        button.Parent = toggle
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 15)
        btnCorner.Parent = button
        
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 24, 0, 24)
        dot.Position = UDim2.new(0, default and 34 or 3, 0, 3)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.BorderSizePixel = 0
        dot.Parent = button
        
        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = dot
        
        local enabled = default
        button.MouseButton1Click:Connect(function()
            enabled = not enabled
            button.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 90)
            
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(dot, tweenInfo, {Position = UDim2.new(0, enabled and 34 or 3, 0, 3)})
            tween:Play()
            callback(enabled)
        end)
        
        return toggle
    end

    v11.CreateSlider = function(text, min, max, default, callback, parent)
        local slider = Instance.new("Frame")
        slider.Name = text .. "Slider"
        slider.Size = UDim2.new(1, 0, 0, 65)
        slider.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        slider.BorderSizePixel = 0
        slider.Parent = parent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = slider
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -30, 0, 25)
        label.Position = UDim2.new(0, 15, 0, 8)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. default
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = slider
        
        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -30, 0, 8)
        track.Position = UDim2.new(0, 15, 0, 40)
        track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        track.BorderSizePixel = 0
        track.Parent = slider
        
        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(1, 0)
        trackCorner.Parent = track
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
        fill.BorderSizePixel = 0
        fill.Parent = track
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill
        
        local thumb = Instance.new("TextButton")
        thumb.Size = UDim2.new(0, 24, 0, 24)
        thumb.Position = UDim2.new((default - min) / (max - min), -12, 0.5, -12)
        thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        thumb.BorderSizePixel = 0
        thumb.Text = ""
        thumb.ZIndex = 2
        thumb.Parent = track
        
        local thumbCorner = Instance.new("UICorner")
        thumbCorner.CornerRadius = UDim.new(1, 0)
        thumbCorner.Parent = thumb
        
        local dragging = false
        
        local function updateSlider(input)
            if not dragging then return end
            
            local percentage = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + ((max - min) * percentage))
            
            fill.Size = UDim2.new(percentage, 0, 1, 0)
            thumb.Position = UDim2.new(percentage, -12, 0.5, -12)
            label.Text = text .. ": " .. value
            callback(value)
        end
        
        thumb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        return slider
    end

    v11.CreateButton = function(text, callback, parent)
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Name = text .. "Button"
        buttonFrame.Size = UDim2.new(1, 0, 0, 45)
        buttonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        buttonFrame.BorderSizePixel = 0
        buttonFrame.Parent = parent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = buttonFrame
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -30, 1, -10)
        button.Position = UDim2.new(0, 15, 0, 5)
        button.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.GothamBold
        button.Parent = buttonFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = button
        
        button.MouseButton1Click:Connect(callback)
        
        return buttonFrame
    end

    -- Create Tabs
    local ESPTab = v11.CreateTabButton("ESP", v11.ESPSettingsFrame)
    local ColorsTab = v11.CreateTabButton("COLORS", v11.ESPColorsFrame)
    local FeaturesTab = v11.CreateTabButton("FEATURES", v11.GameFeaturesFrame)
    local VisualTab = v11.CreateTabButton("VISUAL", v11.VisualSettingsFrame)

    ESPTab.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    ESPTab.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- ESP Tab Content
    v11.CreateToggle("ESP Players", false, v11.ToggleESP, v11.ESPSettingsFrame)
    v11.CreateToggle("ESP Generators", false, v11.ToggleGeneratorESP, v11.ESPSettingsFrame)
    v11.CreateToggle("ESP Pallets", false, v11.TogglePalletESP, v11.ESPSettingsFrame)

    -- Colors Tab Content  
    -- (Color pickers would go here - simplified for length)

    -- Features Tab Content
    v11.CreateToggle("Aimbot (Hold RMB)", false, v11.ToggleAimbot, v11.GameFeaturesFrame)
    v11.CreateSlider("Aimbot FOV", 1, 200, 50, v11.UpdateAimbotFOV, v11.GameFeaturesFrame)
    v11.CreateSlider("Aimbot Smoothness", 1, 100, 10, v11.UpdateAimbotSmoothness, v11.GameFeaturesFrame)
    v11.CreateToggle("Team Check (Killer Only)", true, v11.ToggleAimbotTeamCheck, v11.GameFeaturesFrame)
    v11.CreateToggle("Visible Check", true, v11.ToggleAimbotVisibleCheck, v11.GameFeaturesFrame)
    v11.CreateToggle("Wall Check", false, v11.ToggleAimbotWallCheck, v11.GameFeaturesFrame)
    
    v11.CreateToggle("Walk Speed", false, v11.ToggleWalkSpeed, v11.GameFeaturesFrame)
    v11.CreateSlider("Walk Speed Value", 16, 500, 16, v11.UpdateWalkSpeedValue, v11.GameFeaturesFrame)
    v11.CreateToggle("JumpPower", false, v11.ToggleJumpPower, v11.GameFeaturesFrame)
    v11.CreateSlider("JumpPower Value", 0, 500, 50, v11.UpdateJumpPowerValue, v11.GameFeaturesFrame)
    v11.CreateToggle("Fly (WASD+Space+Shift)", false, v11.ToggleFly, v11.GameFeaturesFrame)
    v11.CreateSlider("Fly Speed", 0, 500, 50, function(val) v11.FlySpeedValue = val end, v11.GameFeaturesFrame)
    v11.CreateToggle("Noclip", false, v11.ToggleNoclip, v11.GameFeaturesFrame)
    v11.CreateToggle("God Mode", false, v11.ToggleGodMode, v11.GameFeaturesFrame)
    v11.CreateToggle("AntiStun", false, v11.ToggleAntiStun, v11.GameFeaturesFrame)
    v11.CreateToggle("AntiGrab", false, v11.ToggleAntiGrab, v11.GameFeaturesFrame)

    -- Visual Tab Content
    v11.CreateToggle("Crosshair", false, v11.ToggleCrosshair, v11.VisualSettingsFrame)
    v11.CreateToggle("No Fog", false, v11.ToggleNoFog, v11.VisualSettingsFrame)
    v11.CreateToggle("Custom Time", false, v11.ToggleTime, v11.VisualSettingsFrame)
    v11.CreateSlider("Time Value", 0, 24, 12, function(val) 
        v11.TimeValue = val 
        if v11.TimeEnabled then
            Lighting.ClockTime = val
        end
    end, v11.VisualSettingsFrame)

    -- Rainbow Effect
    spawn(function()
        while v11.ScreenGui and v11.ScreenGui.Parent do
            for i = 0, 1, 0.005 do
                if not v11.ScreenGui or not v11.ScreenGui.Parent then break end
                local rainbowColor = Color3.fromHSV(i, 1, 1)
                v11.TitleFrame.BackgroundColor3 = rainbowColor
                UIStroke.Color = rainbowColor
                OpenBtn.BackgroundColor3 = rainbowColor
                OpenStroke.Color = rainbowColor
                wait(0.03)
            end
        end
    end)

    -- Game State Monitoring
    spawn(function()
        while true do
            wait(5)
            local mapLoaded = v11.CheckMapLoaded()
            if mapLoaded ~= v11.MapLoaded then
                v11.MapLoaded = mapLoaded
                print("Map state changed: " .. tostring(mapLoaded))
            end
            
            local gameStarted = v11.CheckGameStarted()
            if gameStarted ~= v11.GameStarted then
                v11.GameStarted = gameStarted
                print("Game state changed: " .. tostring(gameStarted))
                v11._cache.roleCache = {}
                
                if not gameStarted then
                    v11.ClearAllESP()
                elseif v11.ESPEnabled then
                    wait(3)
                    for _, player in pairs(Players:GetPlayers()) do
                        if v11.IsValidPlayerForESP(player) then
                            v11.CreateESP(player)
                        end
                    end
                end
            end
        end
    end)

    -- Notifications
    local function Notify(text, duration)
        game.StarterGui:SetCore("SendNotification", {
            Title = "FELSKY 👅";
            Text = text;
            Duration = duration or 3;
        })
    end

    Notify("Successfully loaded!", 2)
    Notify("Press F1 or - to toggle menu", 3)
    Notify("Made with love for Felicia 💕", 3)

    -- Keybinds
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F1 or input.KeyCode == Enum.KeyCode.Minus then
            v11.MainFrame.Visible = not v11.MainFrame.Visible
            OpenBtn.Visible = not v11.MainFrame.Visible
        elseif input.KeyCode == Enum.KeyCode.K then
            v11.ToggleAimbot(not v11.AimbotEnabled)
        end
    end)

    -- Console Output
    print("═══════════════════════════════════════")
    print("FELSKY 👅 - VIOLENCE DISTRICT ULTIMATE")
    print("Successfully Loaded!")
    print("═══════════════════════════════════════")
    print("Controls:")
    print("F1 / - : Toggle Menu")
    print("K : Toggle Aimbot")
    print("💕 : Open Menu (when minimized)")
    print("═══════════════════════════════════════")
    print("Features:")
    print("✓ ESP (Players, Generators, Pallets)")
    print("✓ Aimbot with FOV Circle")
    print("✓ Movement (Speed, Jump, Fly, Noclip)")
    print("✓ God Mode & Anti-Features")
    print("✓ Visual Enhancements")
    print("═══════════════════════════════════════")
    print("Made with love for Felicia 💕")
    print("═══════════════════════════════════════")
end

-- Initialize Script
if KeySystemEnabled then
    CreateKeySystem()
else
    LoadMainScript()
end
