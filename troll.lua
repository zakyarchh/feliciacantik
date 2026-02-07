-- Meteor Rain & Explosion Mod Menu + Server-Wide Fake Chat
-- Enhanced Version - Chat terlihat oleh SEMUA PLAYER di server

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Variabel Global
local MenuOpen = false
local MeteorActive = false
local SelectedPlayer = nil
local MeteorIntensity = 1

-- Membuat GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MeteorModMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 680)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -340)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "☄️ Meteor Chaos Menu PRO"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Tombol Minimize
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
MinimizeBtn.Text = "-"
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 5)
MinCorner.Parent = MinimizeBtn

-- Tombol Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

-- Container dengan ScrollingFrame
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 6
Container.CanvasSize = UDim2.new(0, 0, 0, 900)
Container.Parent = MainFrame

-- ===== SECTION: SERVER-WIDE FAKE CHAT =====
local ChatSection = Instance.new("TextLabel")
ChatSection.Size = UDim2.new(1, 0, 0, 25)
ChatSection.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ChatSection.Text = "📢 SERVER-WIDE FAKE CHAT"
ChatSection.TextColor3 = Color3.fromRGB(255, 200, 0)
ChatSection.TextSize = 14
ChatSection.Font = Enum.Font.GothamBold
ChatSection.Parent = Container

local ChatSectionCorner = Instance.new("UICorner")
ChatSectionCorner.CornerRadius = UDim.new(0, 5)
ChatSectionCorner.Parent = ChatSection

-- Warning Label
local WarningLabel = Instance.new("TextLabel")
WarningLabel.Size = UDim2.new(1, 0, 0, 35)
WarningLabel.Position = UDim2.new(0, 0, 0, 30)
WarningLabel.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
WarningLabel.Text = "⚠️ Chat will be sent as YOU talking!\nEveryone will see YOUR name!"
WarningLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WarningLabel.TextSize = 10
WarningLabel.Font = Enum.Font.GothamBold
WarningLabel.TextWrapped = true
WarningLabel.Parent = Container

local WarnCorner = Instance.new("UICorner")
WarnCorner.CornerRadius = UDim.new(0, 5)
WarnCorner.Parent = WarningLabel

-- Fake Name Input
local FakeNameLabel = Instance.new("TextLabel")
FakeNameLabel.Size = UDim2.new(1, 0, 0, 25)
FakeNameLabel.Position = UDim2.new(0, 0, 0, 70)
FakeNameLabel.BackgroundTransparency = 1
FakeNameLabel.Text = "Fake Name (Optional - experimental):"
FakeNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FakeNameLabel.TextSize = 11
FakeNameLabel.Font = Enum.Font.Gotham
FakeNameLabel.TextXAlignment = Enum.TextXAlignment.Left
FakeNameLabel.Parent = Container

local FakeNameInput = Instance.new("TextBox")
FakeNameInput.Size = UDim2.new(1, 0, 0, 30)
FakeNameInput.Position = UDim2.new(0, 0, 0, 95)
FakeNameInput.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
FakeNameInput.PlaceholderText = "Leave empty to use your name"
FakeNameInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
FakeNameInput.Text = ""
FakeNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
FakeNameInput.TextSize = 12
FakeNameInput.Font = Enum.Font.Gotham
FakeNameInput.ClearTextOnFocus = false
FakeNameInput.Parent = Container

local FakeNameCorner = Instance.new("UICorner")
FakeNameCorner.CornerRadius = UDim.new(0, 5)
FakeNameCorner.Parent = FakeNameInput

-- Message Input
local MessageLabel = Instance.new("TextLabel")
MessageLabel.Size = UDim2.new(1, 0, 0, 25)
MessageLabel.Position = UDim2.new(0, 0, 0, 130)
MessageLabel.BackgroundTransparency = 1
MessageLabel.Text = "Your Message:"
MessageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MessageLabel.TextSize = 11
MessageLabel.Font = Enum.Font.Gotham
MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
MessageLabel.Parent = Container

local MessageInput = Instance.new("TextBox")
MessageInput.Size = UDim2.new(1, 0, 0, 60)
MessageInput.Position = UDim2.new(0, 0, 0, 155)
MessageInput.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
MessageInput.PlaceholderText = "Type your message here..."
MessageInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
MessageInput.Text = ""
MessageInput.TextColor3 = Color3.fromRGB(255, 255, 255)
MessageInput.TextSize = 12
MessageInput.Font = Enum.Font.Gotham
MessageInput.TextWrapped = true
MessageInput.TextXAlignment = Enum.TextXAlignment.Left
MessageInput.TextYAlignment = Enum.TextYAlignment.Top
MessageInput.MultiLine = true
MessageInput.ClearTextOnFocus = false
MessageInput.Parent = Container

local MessageInputCorner = Instance.new("UICorner")
MessageInputCorner.CornerRadius = UDim.new(0, 5)
MessageInputCorner.Parent = MessageInput

-- Button Send to Server Chat
local SendServerChatBtn = Instance.new("TextButton")
SendServerChatBtn.Size = UDim2.new(1, 0, 0, 40)
SendServerChatBtn.Position = UDim2.new(0, 0, 0, 225)
SendServerChatBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
SendServerChatBtn.Text = "📤 Send to Server Chat (Everyone Sees)"
SendServerChatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SendServerChatBtn.TextSize = 13
SendServerChatBtn.Font = Enum.Font.GothamBold
SendServerChatBtn.Parent = Container

local SendServerCorner = Instance.new("UICorner")
SendServerCorner.CornerRadius = UDim.new(0, 5)
SendServerCorner.Parent = SendServerChatBtn

-- Spam Chat Toggle
local SpamChatBtn = Instance.new("TextButton")
SpamChatBtn.Size = UDim2.new(1, 0, 0, 35)
SpamChatBtn.Position = UDim2.new(0, 0, 0, 270)
SpamChatBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
SpamChatBtn.Text = "🔁 Spam Chat (OFF)"
SpamChatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpamChatBtn.TextSize = 12
SpamChatBtn.Font = Enum.Font.GothamBold
SpamChatBtn.Parent = Container

local SpamChatCorner = Instance.new("UICorner")
SpamChatCorner.CornerRadius = UDim.new(0, 5)
SpamChatCorner.Parent = SpamChatBtn

-- Quick Messages
local QuickMsg1 = Instance.new("TextButton")
QuickMsg1.Size = UDim2.new(1, 0, 0, 28)
QuickMsg1.Position = UDim2.new(0, 0, 0, 315)
QuickMsg1.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
QuickMsg1.Text = "⚡ I am hacking this server lol"
QuickMsg1.TextColor3 = Color3.fromRGB(255, 255, 255)
QuickMsg1.TextSize = 10
QuickMsg1.Font = Enum.Font.Gotham
QuickMsg1.Parent = Container

local Quick1Corner = Instance.new("UICorner")
Quick1Corner.CornerRadius = UDim.new(0, 5)
Quick1Corner.Parent = QuickMsg1

local QuickMsg2 = Instance.new("TextButton")
QuickMsg2.Size = UDim2.new(1, 0, 0, 28)
QuickMsg2.Position = UDim2.new(0, 0, 0, 348)
QuickMsg2.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
QuickMsg2.Text = "🎁 Free Robux: bit.ly/freerobux"
QuickMsg2.TextColor3 = Color3.fromRGB(255, 255, 255)
QuickMsg2.TextSize = 10
QuickMsg2.Font = Enum.Font.Gotham
QuickMsg2.Parent = Container

local Quick2Corner = Instance.new("UICorner")
Quick2Corner.CornerRadius = UDim.new(0, 5)
Quick2Corner.Parent = QuickMsg2

local QuickMsg3 = Instance.new("TextButton")
QuickMsg3.Size = UDim2.new(1, 0, 0, 28)
QuickMsg3.Position = UDim2.new(0, 0, 0, 381)
QuickMsg3.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
QuickMsg3.Text = "⚠️ Admin is AFK, do whatever you want"
QuickMsg3.TextColor3 = Color3.fromRGB(255, 255, 255)
QuickMsg3.TextSize = 10
QuickMsg3.Font = Enum.Font.Gotham
QuickMsg3.Parent = Container

local Quick3Corner = Instance.new("UICorner")
Quick3Corner.CornerRadius = UDim.new(0, 5)
Quick3Corner.Parent = QuickMsg3

local QuickMsg4 = Instance.new("TextButton")
QuickMsg4.Size = UDim2.new(1, 0, 0, 28)
QuickMsg4.Position = UDim2.new(0, 0, 0, 414)
QuickMsg4.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
QuickMsg4.Text = "💀 EZ NOOBS GET REKT"
QuickMsg4.TextColor3 = Color3.fromRGB(255, 255, 255)
QuickMsg4.TextSize = 10
QuickMsg4.Font = Enum.Font.Gotham
QuickMsg4.Parent = Container

local Quick4Corner = Instance.new("UICorner")
Quick4Corner.CornerRadius = UDim.new(0, 5)
Quick4Corner.Parent = QuickMsg4

-- ===== SECTION: PLAYER SELECTION =====
local PlayerSection = Instance.new("TextLabel")
PlayerSection.Size = UDim2.new(1, 0, 0, 25)
PlayerSection.Position = UDim2.new(0, 0, 0, 452)
PlayerSection.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
PlayerSection.Text = "👥 PLAYER SELECTION"
PlayerSection.TextColor3 = Color3.fromRGB(255, 200, 0)
PlayerSection.TextSize = 14
PlayerSection.Font = Enum.Font.GothamBold
PlayerSection.Parent = Container

local PlayerSectionCorner = Instance.new("UICorner")
PlayerSectionCorner.CornerRadius = UDim.new(0, 5)
PlayerSectionCorner.Parent = PlayerSection

local PlayerLabel = Instance.new("TextLabel")
PlayerLabel.Size = UDim2.new(1, 0, 0, 20)
PlayerLabel.Position = UDim2.new(0, 0, 0, 482)
PlayerLabel.BackgroundTransparency = 1
PlayerLabel.Text = "Select Target:"
PlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerLabel.TextSize = 11
PlayerLabel.Font = Enum.Font.Gotham
PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerLabel.Parent = Container

local PlayerDropdown = Instance.new("TextButton")
PlayerDropdown.Size = UDim2.new(1, 0, 0, 35)
PlayerDropdown.Position = UDim2.new(0, 0, 0, 502)
PlayerDropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
PlayerDropdown.Text = "Select a player..."
PlayerDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerDropdown.TextSize = 12
PlayerDropdown.Font = Enum.Font.Gotham
PlayerDropdown.Parent = Container

local DropCorner = Instance.new("UICorner")
DropCorner.CornerRadius = UDim.new(0, 5)
DropCorner.Parent = PlayerDropdown

-- Dropdown List
local DropdownList = Instance.new("Frame")
DropdownList.Size = UDim2.new(1, 0, 0, 120)
DropdownList.Position = UDim2.new(0, 0, 0, 542)
DropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
DropdownList.BorderSizePixel = 0
DropdownList.Visible = false
DropdownList.ZIndex = 10
DropdownList.Parent = Container

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 5)
ListCorner.Parent = DropdownList

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, -10, 1, -10)
PlayerList.Position = UDim2.new(0, 5, 0, 5)
PlayerList.BackgroundTransparency = 1
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 4
PlayerList.ZIndex = 11
PlayerList.Parent = DropdownList

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 3)
ListLayout.Parent = PlayerList

-- Fungsi Update Player List
local function UpdatePlayerList()
    for _, child in pairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        local PlayerBtn = Instance.new("TextButton")
        PlayerBtn.Size = UDim2.new(1, 0, 0, 28)
        PlayerBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        PlayerBtn.Text = player.Name
        PlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        PlayerBtn.TextSize = 11
        PlayerBtn.Font = Enum.Font.Gotham
        PlayerBtn.ZIndex = 12
        PlayerBtn.Parent = PlayerList
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 5)
        BtnCorner.Parent = PlayerBtn
        
        PlayerBtn.MouseButton1Click:Connect(function()
            SelectedPlayer = player
            PlayerDropdown.Text = player.Name
            DropdownList.Visible = false
        end)
    end
    
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end

PlayerDropdown.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
    UpdatePlayerList()
end)

-- ===== SECTION: EXPLOSION CONTROLS =====
local ExplosionSection = Instance.new("TextLabel")
ExplosionSection.Size = UDim2.new(1, 0, 0, 25)
ExplosionSection.Position = UDim2.new(0, 0, 0, 547)
ExplosionSection.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ExplosionSection.Text = "💥 EXPLOSION CONTROLS"
ExplosionSection.TextColor3 = Color3.fromRGB(255, 200, 0)
ExplosionSection.TextSize = 14
ExplosionSection.Font = Enum.Font.GothamBold
ExplosionSection.Parent = Container

local ExplosionSectionCorner = Instance.new("UICorner")
ExplosionSectionCorner.CornerRadius = UDim.new(0, 5)
ExplosionSectionCorner.Parent = ExplosionSection

local ExplodePlayerBtn = Instance.new("TextButton")
ExplodePlayerBtn.Size = UDim2.new(1, 0, 0, 35)
ExplodePlayerBtn.Position = UDim2.new(0, 0, 0, 577)
ExplodePlayerBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ExplodePlayerBtn.Text = "💥 Explode Selected"
ExplodePlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExplodePlayerBtn.TextSize = 12
ExplodePlayerBtn.Font = Enum.Font.GothamBold
ExplodePlayerBtn.Parent = Container

local ExpPlayerCorner = Instance.new("UICorner")
ExpPlayerCorner.CornerRadius = UDim.new(0, 5)
ExpPlayerCorner.Parent = ExplodePlayerBtn

local ExplodeAllBtn = Instance.new("TextButton")
ExplodeAllBtn.Size = UDim2.new(1, 0, 0, 35)
ExplodeAllBtn.Position = UDim2.new(0, 0, 0, 617)
ExplodeAllBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
ExplodeAllBtn.Text = "💣 Explode All Players"
ExplodeAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExplodeAllBtn.TextSize = 12
ExplodeAllBtn.Font = Enum.Font.GothamBold
ExplodeAllBtn.Parent = Container

local ExpAllCorner = Instance.new("UICorner")
ExpAllCorner.CornerRadius = UDim.new(0, 5)
ExpAllCorner.Parent = ExplodeAllBtn

-- ===== SECTION: METEOR CONTROLS =====
local MeteorSection = Instance.new("TextLabel")
MeteorSection.Size = UDim2.new(1, 0, 0, 25)
MeteorSection.Position = UDim2.new(0, 0, 0, 662)
MeteorSection.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
MeteorSection.Text = "☄️ METEOR CONTROLS"
MeteorSection.TextColor3 = Color3.fromRGB(255, 200, 0)
MeteorSection.TextSize = 14
MeteorSection.Font = Enum.Font.GothamBold
MeteorSection.Parent = Container

local MeteorSectionCorner = Instance.new("UICorner")
MeteorSectionCorner.CornerRadius = UDim.new(0, 5)
MeteorSectionCorner.Parent = MeteorSection

local IntensityLabel = Instance.new("TextLabel")
IntensityLabel.Size = UDim2.new(1, 0, 0, 20)
IntensityLabel.Position = UDim2.new(0, 0, 0, 692)
IntensityLabel.BackgroundTransparency = 1
IntensityLabel.Text = "Intensity: 1 per player"
IntensityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
IntensityLabel.TextSize = 11
IntensityLabel.Font = Enum.Font.Gotham
IntensityLabel.TextXAlignment = Enum.TextXAlignment.Left
IntensityLabel.Parent = Container

local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(1, 0, 0, 20)
SliderFrame.Position = UDim2.new(0, 0, 0, 712)
SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
SliderFrame.BorderSizePixel = 0
SliderFrame.Parent = Container

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 5)
SliderCorner.Parent = SliderFrame

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.1, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderFrame

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(0, 5)
SliderFillCorner.Parent = SliderFill

local SliderButton = Instance.new("TextButton")
SliderButton.Size = UDim2.new(1, 0, 1, 0)
SliderButton.BackgroundTransparency = 1
SliderButton.Text = ""
SliderButton.Parent = SliderFrame

local dragging = false

SliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

SliderButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mouse = LocalPlayer:GetMouse()
        local relativeX = math.clamp(mouse.X - SliderFrame.AbsolutePosition.X, 0, SliderFrame.AbsoluteSize.X)
        local percentage = relativeX / SliderFrame.AbsoluteSize.X
        
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        MeteorIntensity = math.floor(percentage * 10) + 1
        IntensityLabel.Text = "Intensity: " .. MeteorIntensity .. " per player"
    end
end)

local MeteorBtn = Instance.new("TextButton")
MeteorBtn.Size = UDim2.new(1, 0, 0, 35)
MeteorBtn.Position = UDim2.new(0, 0, 0, 742)
MeteorBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
MeteorBtn.Text = "☄️ Start Meteor Rain"
MeteorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MeteorBtn.TextSize = 12
MeteorBtn.Font = Enum.Font.GothamBold
MeteorBtn.Parent = Container

local MeteorCorner = Instance.new("UICorner")
MeteorCorner.CornerRadius = UDim.new(0, 5)
MeteorCorner.Parent = MeteorBtn

local MeteorHellBtn = Instance.new("TextButton")
MeteorHellBtn.Size = UDim2.new(1, 0, 0, 35)
MeteorHellBtn.Position = UDim2.new(0, 0, 0, 782)
MeteorHellBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
MeteorHellBtn.Text = "🔥 HELL MODE 🔥"
MeteorHellBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MeteorHellBtn.TextSize = 12
MeteorHellBtn.Font = Enum.Font.GothamBold
MeteorHellBtn.Parent = Container

local MeteorHellCorner = Instance.new("UICorner")
MeteorHellCorner.CornerRadius = UDim.new(0, 5)
MeteorHellCorner.Parent = MeteorHellBtn

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 827)
StatusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Parent = Container

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 5)
StatusCorner.Parent = StatusLabel

-- ===== FUNGSI SERVER-WIDE CHAT =====

-- Fungsi untuk mengirim chat ke server (SEMUA ORANG BISA LIHAT)
local function SendServerChat(message, fakeName)
    local success = false
    
    -- Method 1: TextChatService (New Chat System - Roblox 2023+)
    pcall(function()
        local textChatService = game:GetService("TextChatService")
        local textChannels = textChatService:FindFirstChild("TextChannels")
        
        if textChannels then
            local generalChannel = textChannels:FindFirstChild("RBXGeneral")
            
            if generalChannel and generalChannel:IsA("TextChannel") then
                -- Kirim pesan normal (akan terlihat dengan nama asli kita)
                generalChannel:SendAsync(message)
                success = true
            end
        end
    end)
    
    -- Method 2: Legacy Chat System (Old Roblox Chat)
    if not success then
        pcall(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local SayMessageRequest = ReplicatedStorage:FindFirstChild("SayMessageRequest", true)
            
            if SayMessageRequest then
                SayMessageRequest:FireServer(message, "All")
                success = true
            end
        end)
    end
    
    -- Method 3: Direct Chat API (Most games)
    if not success then
        pcall(function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
            success = true
        end)
    end
    
    -- Method 4: Player:Chat() (Paling universal tapi kadang tidak bekerja)
    if not success then
        pcall(function()
            -- Ini akan membuat karakter kita "berbicara" dengan bubble chat
            if LocalPlayer.Character then
                game:GetService("Chat"):Chat(LocalPlayer.Character.Head, message, Enum.ChatColor.White)
            end
            
            -- Coba juga kirim ke chat system
            LocalPlayer:Chat(message)
            success = true
        end)
    end
    
    return success
end

-- Spam Chat Variables
local SpamActive = false
local SpamConnection = nil

-- ===== EVENT HANDLERS FAKE CHAT =====
SendServerChatBtn.MouseButton1Click:Connect(function()
    local message = MessageInput.Text
    local fakeName = FakeNameInput.Text
    
    if message ~= "" then
        local success = SendServerChat(message, fakeName)
        
        if success then
            StatusLabel.Text = "Status: Message sent to server!"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            StatusLabel.Text = "Status: Failed! Game may block chat."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        
        wait(2)
        StatusLabel.Text = "Status: Idle"
    else
        StatusLabel.Text = "Status: Enter a message first!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        wait(2)
        StatusLabel.Text = "Status: Idle"
    end
end)

-- Spam Chat Toggle
SpamChatBtn.MouseButton1Click:Connect(function()
    SpamActive = not SpamActive
    
    if SpamActive then
        SpamChatBtn.Text = "🔁 Spam Chat (ON - SPAMMING!)"
        SpamChatBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        StatusLabel.Text = "Status: SPAMMING CHAT!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        spawn(function()
            while SpamActive do
                local message = MessageInput.Text
                if message ~= "" then
                    SendServerChat(message, FakeNameInput.Text)
                end
                wait(0.5) -- Spam setiap 0.5 detik
            end
        end)
    else
        SpamChatBtn.Text = "🔁 Spam Chat (OFF)"
        SpamChatBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
        StatusLabel.Text = "Status: Idle"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
end)

-- Quick Messages
QuickMsg1.MouseButton1Click:Connect(function()
    SendServerChat("I am hacking this server lol", FakeNameInput.Text)
end)

QuickMsg2.MouseButton1Click:Connect(function()
    SendServerChat("Free Robux: bit.ly/freerobux", FakeNameInput.Text)
end)

QuickMsg3.MouseButton1Click:Connect(function()
    SendServerChat("Admin is AFK, do whatever you want", FakeNameInput.Text)
end)

QuickMsg4.MouseButton1Click:Connect(function()
    SendServerChat("EZ NOOBS GET REKT", FakeNameInput.Text)
end)

-- ===== FUNGSI EXPLODE =====
local function ExplodePlayer(player)
    if player and player.Character then
        local character = player.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoidRootPart then
            local explosion = Instance.new("Explosion")
            explosion.Position = humanoidRootPart.Position
            explosion.BlastRadius = 20
            explosion.BlastPressure = 500000
            explosion.Parent = workspace
            
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://165969964"
            sound.Volume = 1
            sound.Parent = humanoidRootPart
            sound:Play()
            game:GetService("Debris"):AddItem(sound, 2)
        end
    end
end

-- ===== FUNGSI METEOR =====
local function SpawnMeteorAtPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    local character = targetPlayer.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local targetPos = humanoidRootPart.Position
        local spawnPos = targetPos + Vector3.new(
            math.random(-40, 40),
            math.random(80, 120),
            math.random(-40, 40)
        )
        
        local meteor = Instance.new("Part")
        meteor.Name = "Meteor"
        meteor.Size = Vector3.new(math.random(6, 12), math.random(6, 12), math.random(6, 12))
        meteor.Position = spawnPos
        meteor.BrickColor = BrickColor.new("Really black")
        meteor.Material = Enum.Material.Slate
        meteor.Shape = Enum.PartType.Ball
        meteor.TopSurface = Enum.SurfaceType.Smooth
        meteor.BottomSurface = Enum.SurfaceType.Smooth
        meteor.CanCollide = true
        meteor.Parent = workspace
        
        local fire = Instance.new("Fire")
        fire.Size = 20
        fire.Heat = 20
        fire.Color = Color3.fromRGB(255, math.random(50, 150), 0)
        fire.SecondaryColor = Color3.fromRGB(255, 0, 0)
        fire.Parent = meteor
        
        local smoke = Instance.new("Smoke")
        smoke.Size = 15
        smoke.Color = Color3.fromRGB(50, 50, 50)
        smoke.Opacity = 0.8
        smoke.RiseVelocity = 5
        smoke.Parent = meteor
        
        local attachment0 = Instance.new("Attachment")
        attachment0.Parent = meteor
        
        local attachment1 = Instance.new("Attachment")
        attachment1.Position = Vector3.new(0, 5, 0)
        attachment1.Parent = meteor
        
        local trail = Instance.new("Trail")
        trail.Attachment0 = attachment0
        trail.Attachment1 = attachment1
        trail.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }
        trail.Lifetime = 1.5
        trail.MinLength = 0
        trail.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        }
        trail.WidthScale = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0.5)
        }
        trail.Parent = meteor
        
        local light = Instance.new("PointLight")
        light.Brightness = 5
        light.Color = Color3.fromRGB(255, 100, 0)
        light.Range = 30
        light.Parent = meteor
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = meteor
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.P = 3000
        bodyGyro.CFrame = meteor.CFrame
        bodyGyro.Parent = meteor
        
        local whistleSound = Instance.new("Sound")
        whistleSound.SoundId = "rbxassetid://1369158"
        whistleSound.Volume = 0.8
        whistleSound.Parent = meteor
        whistleSound:Play()
        
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if meteor and meteor.Parent and targetPlayer.Character then
                local currentTarget = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if currentTarget then
                    local direction = (currentTarget.Position - meteor.Position).Unit
                    bodyVelocity.Velocity = direction * 120
                    bodyGyro.CFrame = CFrame.lookAt(meteor.Position, currentTarget.Position)
                end
            else
                if connection then
                    connection:Disconnect()
                end
            end
        end)
        
        meteor.Touched:Connect(function(hit)
            if not meteor:FindFirstChild("Exploded") then
                local tag = Instance.new("BoolValue")
                tag.Name = "Exploded"
                tag.Parent = meteor
                
                local explosion = Instance.new("Explosion")
                explosion.Position = meteor.Position
                explosion.BlastRadius = 30
                explosion.BlastPressure = 700000
                explosion.ExplosionType = Enum.ExplosionType.Craters
                explosion.Parent = workspace
                
                for _, player in pairs(Players:GetPlayers()) do
                    if player.Character then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local distance = (hrp.Position - meteor.Position).Magnitude
                            if distance < 50 then
                                spawn(function()
                                    local humanoid = player.Character:FindFirstChild("Humanoid")
                                    if humanoid then
                                        humanoid.CameraOffset = Vector3.new(
                                            math.random(-2, 2),
                                            math.random(-2, 2),
                                            math.random(-2, 2)
                                        )
                                        wait(0.1)
                                        humanoid.CameraOffset = Vector3.new(0, 0, 0)
                                    end
                                end)
                            end
                        end
                    end
                end
                
                local explosionSound = Instance.new("Sound")
                explosionSound.SoundId = "rbxassetid://165969964"
                explosionSound.Volume = 2
                explosionSound.Parent = meteor
                explosionSound:Play()
                
                local particleEmitter = Instance.new("ParticleEmitter")
                particleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
                particleEmitter.Rate = 500
                particleEmitter.Lifetime = NumberRange.new(1, 2)
                particleEmitter.Speed = NumberRange.new(30, 50)
                particleEmitter.SpreadAngle = Vector2.new(180, 180)
                particleEmitter.Parent = meteor
                particleEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 100, 0))
                particleEmitter.Size = NumberSequence.new(5, 10)
                
                spawn(function()
                    wait(0.1)
                    particleEmitter.Enabled = false
                end)
                
                if connection then
                    connection:Disconnect()
                end
                
                wait(2)
                meteor:Destroy()
            end
        end)
        
        game:GetService("Debris"):AddItem(meteor, 15)
    end
end

local function MeteorRainAllPlayers()
    local playerList = Players:GetPlayers()
    
    for _, player in pairs(playerList) do
        for i = 1, MeteorIntensity do
            spawn(function()
                wait(math.random(0, 10) / 10)
                SpawnMeteorAtPlayer(player)
            end)
        end
    end
    
    StatusLabel.Text = "Status: " .. (#playerList * MeteorIntensity) .. " meteors spawned!"
    wait(2)
    if not MeteorActive then
        StatusLabel.Text = "Status: Idle"
    end
end

-- ===== EVENT HANDLERS EXPLOSION & METEOR =====
ExplodePlayerBtn.MouseButton1Click:Connect(function()
    if SelectedPlayer then
        ExplodePlayer(SelectedPlayer)
        StatusLabel.Text = "Status: Exploded " .. SelectedPlayer.Name
        wait(2)
        if not MeteorActive then
            StatusLabel.Text = "Status: Idle"
        end
    else
        PlayerDropdown.Text = "❌ Select player first!"
        wait(2)
        PlayerDropdown.Text = "Select a player..."
    end
end)

ExplodeAllBtn.MouseButton1Click:Connect(function()
    local count = 0
    for _, player in pairs(Players:GetPlayers()) do
        ExplodePlayer(player)
        count = count + 1
        wait(0.1)
    end
    StatusLabel.Text = "Status: Exploded " .. count .. " players!"
    wait(2)
    StatusLabel.Text = "Status: Idle"
end)

MeteorBtn.MouseButton1Click:Connect(function()
    MeteorActive = not MeteorActive
    
    if MeteorActive then
        MeteorBtn.Text = "⏸️ Stop Meteor"
        MeteorBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StatusLabel.Text = "Status: Meteor Active"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        spawn(function()
            while MeteorActive do
                MeteorRainAllPlayers()
                wait(2)
            end
        end)
    else
        MeteorBtn.Text = "☄️ Start Meteor Rain"
        MeteorBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
        StatusLabel.Text = "Status: Idle"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
end)

local HellModeActive = false

MeteorHellBtn.MouseButton1Click:Connect(function()
    HellModeActive = not HellModeActive
    
    if HellModeActive then
        MeteorHellBtn.Text = "⏸️ STOP HELL"
        MeteorHellBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        StatusLabel.Text = "Status: 🔥 HELL MODE 🔥"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        
        spawn(function()
            while HellModeActive do
                local playerList = Players:GetPlayers()
                
                for _, player in pairs(playerList) do
                    for i = 1, MeteorIntensity * 5 do
                        spawn(function()
                            SpawnMeteorAtPlayer(player)
                        end)
                    end
                end
                
                wait(0.5)
            end
        end)
    else
        MeteorHellBtn.Text = "🔥 HELL MODE 🔥"
        MeteorHellBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        StatusLabel.Text = "Status: Idle"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    if MainFrame.Size == UDim2.new(0, 400, 0, 680) then
        MainFrame:TweenSize(UDim2.new(0, 400, 0, 40), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 400, 0, 680), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "-"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    MeteorActive = false
    HellModeActive = false
    SpamActive = false
    ScreenGui:Destroy()
end)

local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Welcome
StatusLabel.Text = "Status: Loaded! Press 'M'"
wait(3)
StatusLabel.Text = "Status: Idle"

print("🔥 Meteor Chaos Menu PRO Loaded! 🔥")
print("Press 'M' to toggle menu")
print("Chat will be sent with YOUR NAME")
