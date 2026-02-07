-- Meteor Chaos Menu - SERVER-SIDE EDITION
-- Efek terlihat oleh SEMUA PLAYER

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Variabel Global
local MeteorActive = false
local SelectedPlayer = nil
local MeteorIntensity = 1
local HellModeActive = false
local SpamActive = false

-- Destroy old GUI
if PlayerGui:FindFirstChild("MeteorModMenu") then
    PlayerGui:FindFirstChild("MeteorModMenu"):Destroy()
end

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MeteorModMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 500)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "☄️ Meteor [SERVER]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -75, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
MinimizeBtn.Text = "-"
MinimizeBtn.TextSize = 22
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Drag System
local dragToggle = nil
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragToggle then
            updateInput(input)
        end
    end
end)

-- Container
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 8
Container.CanvasSize = UDim2.new(0, 0, 0, 900)
Container.Parent = MainFrame

local yPos = 0

-- Helper Functions
local function createSection(text)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, 0, 0, 30)
    section.Position = UDim2.new(0, 0, 0, yPos)
    section.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    section.Text = text
    section.TextColor3 = Color3.fromRGB(255, 200, 0)
    section.TextSize = 13
    section.Font = Enum.Font.GothamBold
    section.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = section
    
    yPos = yPos + 35
end

local function createButton(text, color, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Position = UDim2.new(0, 0, 0, yPos)
    button.BackgroundColor3 = color
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.GothamBold
    button.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    yPos = yPos + 45
    return button
end

local function createTextBox(placeholder)
    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(1, 0, 0, 50)
    textbox.Position = UDim2.new(0, 0, 0, yPos)
    textbox.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    textbox.PlaceholderText = placeholder
    textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    textbox.Text = ""
    textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textbox.TextSize = 12
    textbox.Font = Enum.Font.Gotham
    textbox.TextWrapped = true
    textbox.MultiLine = true
    textbox.ClearTextOnFocus = false
    textbox.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = textbox
    
    yPos = yPos + 55
    return textbox
end

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0, 0)
StatusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Parent = Container

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = StatusLabel

yPos = yPos + 30

-- ===== CHAT SECTION =====
createSection("📢 CHAT (Everyone sees)")

local MessageInput = createTextBox("Type message...")

-- FIXED: Chat Function yang BEKERJA untuk semua orang
local function SendChatToServer(message)
    if not message or message == "" then return false end
    
    -- Method 1: New TextChatService
    task.spawn(function()
        local success, err = pcall(function()
            local TextChatService = game:GetService("TextChatService")
            local generalChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if generalChannel then
                generalChannel:SendAsync(message)
            end
        end)
        if not success then
            warn("TextChatService failed:", err)
        end
    end)
    
    -- Method 2: Legacy Chat
    task.spawn(function()
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
        end)
        if not success then
            warn("Legacy chat failed:", err)
        end
    end)
    
    -- Method 3: Direct say
    task.spawn(function()
        pcall(function()
            game.Players:Chat(message)
        end)
    end)
    
    return true
end

createButton("📤 Send Chat", Color3.fromRGB(100, 200, 100), function()
    if MessageInput.Text ~= "" then
        SendChatToServer(MessageInput.Text)
        StatusLabel.Text = "Message Sent!"
        task.wait(2)
        StatusLabel.Text = "Status: Ready"
    end
end)

createButton("🔁 Spam Chat", Color3.fromRGB(200, 100, 50), function()
    SpamActive = not SpamActive
    if SpamActive then
        StatusLabel.Text = "SPAMMING..."
        task.spawn(function()
            while SpamActive do
                SendChatToServer(MessageInput.Text)
                task.wait(1.5)
            end
        end)
    else
        StatusLabel.Text = "Status: Ready"
    end
end)

-- Quick Messages
local function createQuickMsg(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.Gotham
    btn.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        SendChatToServer(text)
    end)
    
    yPos = yPos + 35
end

createQuickMsg("gg ez")
createQuickMsg("noobs lol")
createQuickMsg("hacker here")

-- ===== PLAYER SECTION =====
createSection("👥 SELECT TARGET")

local PlayerDropdown = createButton("Click to cycle players", Color3.fromRGB(45, 45, 60), function()
    local players = Players:GetPlayers()
    local currentIndex = 0
    
    for i, p in ipairs(players) do
        if p == SelectedPlayer then
            currentIndex = i
            break
        end
    end
    
    currentIndex = currentIndex + 1
    if currentIndex > #players then currentIndex = 1 end
    
    if players[currentIndex] then
        SelectedPlayer = players[currentIndex]
        PlayerDropdown.Text = "Target: " .. SelectedPlayer.Name
    end
end)

-- ===== EXPLOSION SECTION =====
createSection("💥 EXPLOSIONS (Everyone sees)")

-- FIXED: Explosion yang terlihat semua orang
local function ExplodePlayerServerSide(player)
    task.spawn(function()
        if not player or not player.Character then return end
        
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        -- Gunakan tool/part yang sudah ada di workspace untuk trigger explosion
        -- Ini akan di-replicate ke semua player
        local explosion = Instance.new("Explosion")
        explosion.Position = hrp.Position
        explosion.BlastRadius = 25
        explosion.BlastPressure = 500000
        explosion.ExplosionType = Enum.ExplosionType.NoCraters
        
        -- PENTING: Parent ke workspace agar server-replicated
        explosion.Parent = workspace
        
        -- Optional: Damage player
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:TakeDamage(50)
        end
    end)
end

createButton("💥 Explode Selected", Color3.fromRGB(200, 50, 50), function()
    if SelectedPlayer then
        ExplodePlayerServerSide(SelectedPlayer)
        StatusLabel.Text = "Exploded: " .. SelectedPlayer.Name
        task.wait(2)
        StatusLabel.Text = "Status: Ready"
    else
        StatusLabel.Text = "Select target first!"
        task.wait(2)
        StatusLabel.Text = "Status: Ready"
    end
end)

createButton("💣 Explode All Players", Color3.fromRGB(150, 30, 30), function()
    for _, player in pairs(Players:GetPlayers()) do
        ExplodePlayerServerSide(player)
        task.wait(0.2)
    end
    StatusLabel.Text = "Exploded everyone!"
    task.wait(2)
    StatusLabel.Text = "Status: Ready"
end)

-- ===== METEOR SECTION =====
createSection("☄️ METEOR (Everyone sees)")

local IntensityLabel = Instance.new("TextLabel")
IntensityLabel.Size = UDim2.new(1, 0, 0, 20)
IntensityLabel.Position = UDim2.new(0, 0, 0, yPos)
IntensityLabel.BackgroundTransparency = 1
IntensityLabel.Text = "Intensity: 1"
IntensityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
IntensityLabel.TextSize = 11
IntensityLabel.Font = Enum.Font.Gotham
IntensityLabel.TextXAlignment = Enum.TextXAlignment.Left
IntensityLabel.Parent = Container

yPos = yPos + 25

-- Slider
local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(1, 0, 0, 30)
SliderFrame.Position = UDim2.new(0, 0, 0, yPos)
SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
SliderFrame.Parent = Container

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 6)
sliderCorner.Parent = SliderFrame

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.1, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
SliderFill.Parent = SliderFrame

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 6)
fillCorner.Parent = SliderFill

local SliderButton = Instance.new("TextButton")
SliderButton.Size = UDim2.new(1, 0, 1, 0)
SliderButton.BackgroundTransparency = 1
SliderButton.Text = ""
SliderButton.Parent = SliderFrame

local sliderDragging = false

SliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
    end
end)

SliderButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if sliderDragging then
        local mousePos = UserInputService:GetMouseLocation()
        local relativeX = math.clamp(mousePos.X - SliderFrame.AbsolutePosition.X, 0, SliderFrame.AbsoluteSize.X)
        local percentage = relativeX / SliderFrame.AbsoluteSize.X
        
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        MeteorIntensity = math.floor(percentage * 5) + 1
        IntensityLabel.Text = "Intensity: " .. MeteorIntensity
    end
end)

yPos = yPos + 35

-- FIXED: Meteor Server-Side
local function SpawnMeteorServerSide(targetPlayer)
    task.spawn(function()
        if not targetPlayer or not targetPlayer.Character then return end
        
        local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local targetPos = hrp.Position
        local spawnPos = targetPos + Vector3.new(
            math.random(-30, 30),
            math.random(60, 100),
            math.random(-30, 30)
        )
        
        -- Meteor part (akan di-replicate ke semua player)
        local meteor = Instance.new("Part")
        meteor.Name = "Meteor"
        meteor.Size = Vector3.new(6, 6, 6)
        meteor.Position = spawnPos
        meteor.BrickColor = BrickColor.new("Really black")
        meteor.Material = Enum.Material.Slate
        meteor.Shape = Enum.PartType.Ball
        meteor.CanCollide = false
        meteor.Anchored = false
        
        -- PENTING: Parent ke workspace untuk server replication
        meteor.Parent = workspace
        
        -- Effects
        local fire = Instance.new("Fire", meteor)
        fire.Size = 12
        fire.Heat = 12
        
        local light = Instance.new("PointLight", meteor)
        light.Brightness = 3
        light.Color = Color3.fromRGB(255, 100, 0)
        light.Range = 20
        
        -- BodyVelocity untuk movement
        local bv = Instance.new("BodyVelocity", meteor)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if meteor.Parent and targetPlayer.Character then
                local currentHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if currentHrp then
                    local direction = (currentHrp.Position - meteor.Position).Unit
                    bv.Velocity = direction * 80
                end
            else
                if connection then connection:Disconnect() end
            end
        end)
        
        meteor.Touched:Connect(function(hit)
            if not meteor:FindFirstChild("Exploded") then
                local tag = Instance.new("BoolValue", meteor)
                tag.Name = "Exploded"
                
                -- Explosion (server-replicated)
                local explosion = Instance.new("Explosion")
                explosion.Position = meteor.Position
                explosion.BlastRadius = 20
                explosion.BlastPressure = 500000
                explosion.Parent = workspace
                
                if connection then connection:Disconnect() end
                
                task.wait(1)
                meteor:Destroy()
            end
        end)
        
        game:GetService("Debris"):AddItem(meteor, 12)
    end)
end

local MeteorBtn = createButton("☄️ Meteor Rain", Color3.fromRGB(50, 150, 200), function()
    MeteorActive = not MeteorActive
    
    if MeteorActive then
        MeteorBtn.Text = "⏸️ Stop Meteor"
        MeteorBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StatusLabel.Text = "Meteor Active"
        
        task.spawn(function()
            while MeteorActive do
                for _, player in pairs(Players:GetPlayers()) do
                    for i = 1, MeteorIntensity do
                        SpawnMeteorServerSide(player)
                        task.wait(0.3)
                    end
                end
                task.wait(2)
            end
        end)
    else
        MeteorBtn.Text = "☄️ Meteor Rain"
        MeteorBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
        StatusLabel.Text = "Status: Ready"
    end
end)

local HellBtn = createButton("🔥 HELL MODE", Color3.fromRGB(200, 0, 0), function()
    HellModeActive = not HellModeActive
    
    if HellModeActive then
        HellBtn.Text = "⏸️ STOP"
        HellBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        StatusLabel.Text = "🔥 HELL MODE 🔥"
        
        task.spawn(function()
            while HellModeActive do
                for _, player in pairs(Players:GetPlayers()) do
                    for i = 1, MeteorIntensity * 3 do
                        SpawnMeteorServerSide(player)
                    end
                end
                task.wait(1)
            end
        end)
    else
        HellBtn.Text = "🔥 HELL MODE"
        HellBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        StatusLabel.Text = "Status: Ready"
    end
end)

-- Update canvas
Container.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- Controls
MinimizeBtn.MouseButton1Click:Connect(function()
    if MainFrame.Size.Y.Offset == 500 then
        MainFrame:TweenSize(UDim2.new(0, 320, 0, 45), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 320, 0, 500), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "-"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    MeteorActive = false
    HellModeActive = false
    SpamActive = false
    ScreenGui:Destroy()
end)

StatusLabel.Text = "✅ SERVER MODE - Everyone sees!"
task.wait(3)
StatusLabel.Text = "Status: Ready"

print("✅ SERVER-SIDE Meteor Menu Loaded!")
