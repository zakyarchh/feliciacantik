--[[
================================================================================
    ███████╗███████╗██╗     ███████╗██╗  ██╗██╗   ██╗
    ██╔════╝██╔════╝██║     ██╔════╝██║ ██╔╝╚██╗ ██╔╝
    █████╗  █████╗  ██║     ███████╗█████╔╝  ╚████╔╝ 
    ██╔══╝  ██╔══╝  ██║     ╚════██║██╔═██╗   ╚██╔╝  
    ██║     ███████╗███████╗███████║██║  ██╗   ██║   
    ╚═╝     ╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝   
    
    FELSKY - Admin & Developer Power System
    Version: 2.0
    Location: ServerScriptService/FELSKY.lua
    
    ⚠️ DISCLAIMER: Sistem ini HANYA untuk game milik sendiri!
    Digunakan untuk testing & administrasi game.
================================================================================
--]]

--============================================================================--
--                              KONFIGURASI UTAMA                              --
--============================================================================--

local CONFIG = {
	-- KEY SYSTEM (di-encode untuk keamanan)
	-- Key asli: "👅sky" - di-encode agar tidak mudah dibaca
	ENCODED_KEY = "\240\159\145\133sky", -- UTF-8 encoding dari "👅sky"
	
	-- ADMIN WHITELIST (Ganti dengan UserId admin kamu)
	-- Tambahkan UserId admin di sini
	ADMIN_USERIDS = {
		123456789, -- Ganti dengan UserId kamu
		987654321, -- Admin tambahan (contoh)
		-- Tambahkan UserId lain di sini
	},
	
	-- PENGATURAN UMUM
	SYSTEM_NAME = "FELSKY",
	VERSION = "2.0",
	
	-- PENGATURAN AURA HIT DEFAULT
	AURA_DEFAULT_RADIUS = 50,
	AURA_DEFAULT_DAMAGE = 25,
	AURA_DEFAULT_INTERVAL = 0.5,
	
	-- PENGATURAN MOVEMENT DEFAULT
	DEFAULT_SPEED = 16,
	DEFAULT_JUMP = 50,
	FLY_SPEED = 100,
	
	-- WARNA UI
	COLORS = {
		BACKGROUND = Color3.fromRGB(18, 18, 24),
		SIDEBAR = Color3.fromRGB(25, 25, 35),
		PANEL = Color3.fromRGB(30, 30, 42),
		ACCENT = Color3.fromRGB(88, 101, 242),
		ACCENT_HOVER = Color3.fromRGB(108, 121, 255),
		SUCCESS = Color3.fromRGB(87, 242, 135),
		ERROR = Color3.fromRGB(237, 66, 69),
		WARNING = Color3.fromRGB(254, 231, 92),
		TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),
		TEXT_SECONDARY = Color3.fromRGB(185, 187, 190),
		TOGGLE_ON = Color3.fromRGB(87, 242, 135),
		TOGGLE_OFF = Color3.fromRGB(85, 85, 95),
	}
}

--============================================================================--
--                              SERVICES                                        --
--============================================================================--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")

--============================================================================--
--                          REMOTE EVENTS SETUP                                --
--============================================================================--

-- Buat folder untuk RemoteEvents
local RemotesFolder = Instance.new("Folder")
RemotesFolder.Name = "FELSKY_Remotes"
RemotesFolder.Parent = ReplicatedStorage

-- RemoteFunction untuk verifikasi key
local KeyVerifyRemote = Instance.new("RemoteFunction")
KeyVerifyRemote.Name = "VerifyKey"
KeyVerifyRemote.Parent = RemotesFolder

-- RemoteEvent untuk aksi admin
local ActionRemote = Instance.new("RemoteEvent")
ActionRemote.Name = "AdminAction"
ActionRemote.Parent = RemotesFolder

-- RemoteEvent untuk notifikasi ke client
local NotifyRemote = Instance.new("RemoteEvent")
NotifyRemote.Name = "Notify"
NotifyRemote.Parent = RemotesFolder

-- RemoteFunction untuk mendapatkan data
local GetDataRemote = Instance.new("RemoteFunction")
GetDataRemote.Name = "GetData"
GetDataRemote.Parent = RemotesFolder

-- RemoteEvent untuk update UI
local UpdateUIRemote = Instance.new("RemoteEvent")
UpdateUIRemote.Name = "UpdateUI"
UpdateUIRemote.Parent = RemotesFolder

--============================================================================--
--                          DATA STORAGE                                        --
--============================================================================--

-- Menyimpan status unlock per player
local UnlockedPlayers = {}

-- Menyimpan status fitur per player
local PlayerFeatures = {}

-- Menyimpan koneksi per player
local PlayerConnections = {}

--============================================================================--
--                          UTILITY FUNCTIONS                                   --
--============================================================================--

-- Fungsi untuk mengecek apakah player adalah admin
local function IsAdmin(player)
	if not player then return false end
	for _, userId in ipairs(CONFIG.ADMIN_USERIDS) do
		if player.UserId == userId then
			return true
		end
	end
	return false
end

-- Fungsi untuk mengecek apakah player sudah unlock
local function IsUnlocked(player)
	return UnlockedPlayers[player.UserId] == true
end

-- Fungsi untuk validasi akses penuh
local function HasFullAccess(player)
	return IsAdmin(player) and IsUnlocked(player)
end

-- Fungsi untuk decode key (simple obfuscation)
local function DecodeKey(inputKey)
	-- Key asli sudah dalam format string, bandingkan langsung
	return inputKey == CONFIG.ENCODED_KEY
end

-- Fungsi untuk mengirim notifikasi ke player
local function SendNotification(player, title, message, notifType)
	NotifyRemote:FireClient(player, {
		Title = title,
		Message = message,
		Type = notifType or "Info" -- Info, Success, Error, Warning
	})
end

-- Fungsi untuk mendapatkan karakter player dengan aman
local function GetCharacter(player)
	local character = player.Character
	if character and character:FindFirstChild("Humanoid") then
		return character
	end
	return nil
end

-- Fungsi untuk mendapatkan humanoid dengan aman
local function GetHumanoid(player)
	local character = GetCharacter(player)
	if character then
		return character:FindFirstChild("Humanoid")
	end
	return nil
end

-- Fungsi untuk mendapatkan HumanoidRootPart dengan aman
local function GetRootPart(player)
	local character = GetCharacter(player)
	if character then
		return character:FindFirstChild("HumanoidRootPart")
	end
	return nil
end

-- Inisialisasi fitur untuk player
local function InitializePlayerFeatures(player)
	PlayerFeatures[player.UserId] = {
		-- Movement
		Fly = false,
		Noclip = false,
		SuperJump = false,
		InfiniteJump = false,
		SpeedBoost = false,
		SpeedValue = CONFIG.DEFAULT_SPEED,
		SlowMotion = false,
		Dash = false,
		WallClimb = false,
		
		-- God/Survival
		GodMode = false,
		InfiniteHealth = false,
		AutoHeal = false,
		AntiFallDamage = false,
		DamageReducer = false,
		DamageReducePercent = 50,
		AutoRevive = false,
		ImmortalTimer = false,
		ImmortalDuration = 10,
		ShieldPermanent = false,
		
		-- Combat
		OneHitKill = false,
		InfiniteDamage = false,
		NoCooldown = false,
		InfiniteAmmo = false,
		NoReload = false,
		AutoAimNPC = false,
		BigHitbox = false,
		HitboxSize = 10,
		StunImmunity = false,
		KnockbackImmunity = false,
		
		-- Aura Hit
		AuraHit = false,
		AuraRadius = CONFIG.AURA_DEFAULT_RADIUS,
		AuraDamage = CONFIG.AURA_DEFAULT_DAMAGE,
		AuraInterval = CONFIG.AURA_DEFAULT_INTERVAL,
		
		-- Visual
		ESPPlayer = false,
		ESPNPC = false,
		ShowHitbox = false,
		ShowPathfinding = false,
		Invisible = false,
		XRay = false,
		NightVision = false,
		FreeCamera = false,
		
		-- Misc
		FPSUnlock = false,
	}
	
	PlayerConnections[player.UserId] = {}
end

-- Cleanup saat player leave
local function CleanupPlayer(player)
	UnlockedPlayers[player.UserId] = nil
	PlayerFeatures[player.UserId] = nil
	
	-- Disconnect semua koneksi
	if PlayerConnections[player.UserId] then
		for _, connection in pairs(PlayerConnections[player.UserId]) do
			if typeof(connection) == "RBXScriptConnection" then
				connection:Disconnect()
			end
		end
		PlayerConnections[player.UserId] = nil
	end
end

--============================================================================--
--                          FEATURE IMPLEMENTATIONS                            --
--============================================================================--

-- ===== GOD MODE =====
local function ToggleGodMode(player, enabled)
	local features = PlayerFeatures[player.UserId]
	if not features then return end
	
	features.GodMode = enabled
	
	local humanoid = GetHumanoid(player)
	if humanoid then
		if enabled then
			humanoid.MaxHealth = math.huge
			humanoid.Health = math.huge
		else
			humanoid.MaxHealth = 100
			humanoid.Health = 100
		end
	end
	
	SendNotification(player, "God Mode", enabled and "ENABLED" or "DISABLED", enabled and "Success" or "Info")
end

-- ===== INFINITE HEALTH =====
local function ToggleInfiniteHealth(player, enabled)
	local features = PlayerFeatures[player.UserId]
	if not features then return end
	
	features.InfiniteHealth = enabled
	
	-- Disconnect existing connection
	if PlayerConnections[player.UserId] and PlayerConnections[player.UserId].InfiniteHealth then
		PlayerConnections[player.UserId].InfiniteHealth:Disconnect()
		PlayerConnections[player.UserId].InfiniteHealth = nil
	end
	
	if enabled then
		local connection
		connection = RunService.Heartbeat:Connect(function()
			if not PlayerFeatures[player.UserId] or not PlayerFeatures[player.UserId].InfiniteHealth then
				connection:Disconnect()
				return
			end
			
			local humanoid = GetHumanoid(player)
			if humanoid then
				humanoid.Health = humanoid.MaxHealth
			end
		end)
		
		PlayerConnections[player.UserId].InfiniteHealth = connection
	end
	
	SendNotification(player, "Infinite Health", enabled and "ENABLED" or "DISABLED", enabled and "Success" or "Info")
end

-- ===== AUTO HEAL =====
local function ToggleAutoHeal(player, enabled)
	local features = PlayerFeatures[player.UserId]
	if not features then return end
	
	features.AutoHeal = enabled
	
	if PlayerConnections[player.UserId] and PlayerConnections[player.UserId].AutoHeal then
		PlayerConnections[player.UserId].AutoHeal:Disconnect()
		PlayerConnections[player.UserId].AutoHeal = nil
	end
	
	if enabled then
		local connection
		connection = RunService.Heartbeat:Connect(function()
			if not PlayerFeatures[player.UserId] or not PlayerFeatures[player.UserId].AutoHeal then
				connection:Disconnect()
				return
			end
			
			local humanoid = GetHumanoid(player)
			if humanoid and humanoid.Health < humanoid.MaxHealth then
				humanoid.Health = math.min(humanoid.Health + 1, humanoid.MaxHealth)
			end
		end)
		
		PlayerConnections[player.UserId].AutoHeal = connection
	end
	
	SendNotification(player, "Auto Heal", enabled and "ENABLED" or "DISABLED", enabled and "Success" or "Info")
end

-- ===== AURA HIT SYSTEM =====
local function ToggleAuraHit(player, enabled)
	local features = PlayerFeatures[player.UserId]
	if not features then return end
	
	features.AuraHit = enabled
	
	if PlayerConnections[player.UserId] and PlayerConnections[player.UserId].AuraHit then
		PlayerConnections[player.UserId].AuraHit:Disconnect()
		PlayerConnections[player.UserId].AuraHit = nil
	end
	
	if enabled then
		local lastHit = 0
		local connection
		connection = RunService.Heartbeat:Connect(function()
			if not PlayerFeatures[player.UserId] or not PlayerFeatures[player.UserId].AuraHit then
				connection:Disconnect()
				return
			end
			
			local now = tick()
			local interval = PlayerFeatures[player.UserId].AuraInterval or CONFIG.AURA_DEFAULT_INTERVAL
			
			if now - lastHit < interval then return end
			lastHit = now
			
			local rootPart = GetRootPart(player)
			if not rootPart then return end
			
			local radius = PlayerFeatures[player.UserId].AuraRadius or CONFIG.AURA_DEFAULT_RADIUS
			local damage = PlayerFeatures[player.UserId].AuraDamage or CONFIG.AURA_DEFAULT_DAMAGE
			
			-- Damage ke semua player lain dalam radius
			for _, otherPlayer in ipairs(Players:GetPlayers()) do
				if otherPlayer ~= player then
					local otherRoot = GetRootPart(otherPlayer)
					local otherHumanoid = GetHumanoid(otherPlayer)
					
					if otherRoot and otherHumanoid then
						local distance = (rootPart.Position - otherRoot.Position).Magnitude
						if distance <= radius then
							otherHumanoid:TakeDamage(damage)
						end
					end
				end
			end
			
			-- Damage ke NPC juga
			for _, descendant in ipairs(workspace:GetDescendants()) do
				if descendant:IsA("Humanoid") and descendant.Parent ~= player.Character then
					local npcRoot = descendant.Parent:FindFirstChild("HumanoidRootPart") or descendant.Parent:FindFirstChild("Torso")
					if npcRoot then
						local distance = (rootPart.Position - npcRoot.Position).Magnitude
						if distance <= radius then
							descendant:TakeDamage(damage)
						end
					end
				end
			end
		end)
		
		PlayerConnections[player.UserId].AuraHit = connection
	end
	
	SendNotification(player, "Aura Hit", enabled and "ENABLED - Radius: "..features.AuraRadius or "DISABLED", enabled and "Success" or "Info")
end

-- ===== SPEED BOOST =====
local function SetSpeed(player, speed)
	local features = PlayerFeatures[player.UserId]
	if not features then return end
	
	features.SpeedValue = speed
	
	local humanoid = GetHumanoid(player)
	if humanoid then
		humanoid.WalkSpeed = speed
	end
	
	SendNotification(player, "Speed", "Set to "..speed, "Info")
end

-- ===== SUPER JUMP =====
local function SetJumpPower(player, power)
	local humanoid = GetHumanoid(player)
	if humanoid then
		humanoid.JumpPower = power
		humanoid.JumpHeight = power * 0.5 -- Approximate conversion
	end
	
	SendNotification(player, "Jump Power", "Set to "..power, "Info")
end

-- ===== TELEPORT KE PLAYER =====
local function TeleportToPlayer(player, targetName)
	local targetPlayer = Players:FindFirstChild(targetName)
	if not targetPlayer then
		SendNotification(player, "Teleport", "Player tidak ditemukan!", "Error")
		return
	end
	
	local targetRoot = GetRootPart(targetPlayer)
	local playerRoot = GetRootPart(player)
	
	if targetRoot and playerRoot then
		playerRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
		SendNotification(player, "Teleport", "Teleported ke "..targetName, "Success")
	else
		SendNotification(player, "Teleport", "Gagal teleport!", "Error")
	end
end

-- ===== TELEPORT ALL =====
local function TeleportAllToPlayer(adminPlayer)
	local adminRoot = GetRootPart(adminPlayer)
	if not adminRoot then
		SendNotification(adminPlayer, "Teleport All", "Karakter tidak ditemukan!", "Error")
		return
	end
	
	local count = 0
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= adminPlayer then
			local playerRoot = GetRootPart(player)
			if playerRoot then
				local offset = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
				playerRoot.CFrame = adminRoot.CFrame + offset
				count = count + 1
			end
		end
	end
	
	SendNotification(adminPlayer, "Teleport All", count.." players teleported!", "Success")
end

-- ===== FREEZE PLAYER =====
local function FreezePlayer(adminPlayer, targetName, freeze)
	local targetPlayer = Players:FindFirstChild(targetName)
	if not targetPlayer then
		SendNotification(adminPlayer, "Freeze", "Player tidak ditemukan!", "Error")
		return
	end
	
	local targetRoot = GetRootPart(targetPlayer)
	local targetHumanoid = GetHumanoid(targetPlayer)
	
	if targetRoot and targetHumanoid then
		targetRoot.Anchored = freeze
		targetHumanoid.WalkSpeed = freeze and 0 or 16
		targetHumanoid.JumpPower = freeze and 0 or 50
		
		SendNotification(adminPlayer, "Freeze", targetName.." "..(freeze and "FROZEN" or "UNFROZEN"), "Success")
		SendNotification(targetPlayer, "Freeze", freeze and "You have been frozen!" or "You have been unfrozen!", freeze and "Warning" or "Info")
	end
end

-- ===== KICK PLAYER =====
local function KickPlayer(adminPlayer, targetName, reason)
	local targetPlayer = Players:FindFirstChild(targetName)
	if not targetPlayer then
		SendNotification(adminPlayer, "Kick", "Player tidak ditemukan!", "Error")
		return
	end
	
	if IsAdmin(targetPlayer) then
		SendNotification(adminPlayer, "Kick", "Tidak bisa kick admin lain!", "Error")
		return
	end
	
	local kickReason = reason or "Kicked by admin"
	targetPlayer:Kick("[FELSKY] "..kickReason)
	SendNotification(adminPlayer, "Kick", targetName.." has been kicked!", "Success")
end

-- ===== KILL ALL NPC =====
local function KillAllNPC(adminPlayer)
	local count = 0
	for _, descendant in ipairs(workspace:GetDescendants()) do
		if descendant:IsA("Humanoid") then
			-- Pastikan bukan player
			local isPlayer = false
			for _, player in ipairs(Players:GetPlayers()) do
				if player.Character and descendant:IsDescendantOf(player.Character) then
					isPlayer = true
					break
				end
			end
			
			if not isPlayer then
				descendant.Health = 0
				count = count + 1
			end
		end
	end
	
	SendNotification(adminPlayer, "Kill All NPC", count.." NPCs killed!", "Success")
end

-- ===== SPAWN TOOL =====
local function SpawnTool(player, toolName)
	-- Cari tool di ReplicatedStorage atau ServerStorage
	local tool = ReplicatedStorage:FindFirstChild(toolName) or game:GetService("ServerStorage"):FindFirstChild(toolName)
	
	if tool and tool:IsA("Tool") then
		local clonedTool = tool:Clone()
		clonedTool.Parent = player.Backpack
		SendNotification(player, "Spawn Tool", toolName.." added to backpack!", "Success")
	else
		-- Buat tool sederhana jika tidak ditemukan
		local newTool = Instance.new("Tool")
		newTool.Name = toolName
		newTool.RequiresHandle = false
		newTool.Parent = player.Backpack
		SendNotification(player, "Spawn Tool", "Created basic tool: "..toolName, "Info")
	end
end

-- ===== AUTO REVIVE =====
local function ToggleAutoRevive(player, enabled)
	local features = PlayerFeatures[player.UserId]
	if not features then return end
	
	features.AutoRevive = enabled
	
	if PlayerConnections[player.UserId] and PlayerConnections[player.UserId].AutoRevive then
		PlayerConnections[player.UserId].AutoRevive:Disconnect()
		PlayerConnections[player.UserId].AutoRevive = nil
	end
	
	if enabled then
		local function onCharacterAdded(character)
			if not PlayerFeatures[player.UserId] or not PlayerFeatures[player.UserId].AutoRevive then
				return
			end
			
			local humanoid = character:WaitForChild("Humanoid", 5)
			if humanoid then
				humanoid.Died:Connect(function()
					if PlayerFeatures[player.UserId] and PlayerFeatures[player.UserId].AutoRevive then
						wait(1)
						player:LoadCharacter()
					end
				end)
			end
		end
		
		if player.Character then
			onCharacterAdded(player.Character)
		end
		
		PlayerConnections[player.UserId].AutoRevive = player.CharacterAdded:Connect(onCharacterAdded)
	end
	
	SendNotification(player, "Auto Revive", enabled and "ENABLED" or "DISABLED", enabled and "Success" or "Info")
end

--============================================================================--
--                          REMOTE EVENT HANDLERS                              --
--============================================================================--

-- Handler untuk verifikasi key
KeyVerifyRemote.OnServerInvoke = function(player, inputKey)
	-- Cek apakah player adalah admin
	if not IsAdmin(player) then
		return {Success = false, Message = "Access Denied - Not an admin"}
	end
	
	-- Cek key
	if DecodeKey(inputKey) then
		UnlockedPlayers[player.UserId] = true
		InitializePlayerFeatures(player)
		return {Success = true, Message = "Welcome to FELSKY, "..player.Name.."!"}
	else
		return {Success = false, Message = "Invalid Key"}
	end
end

-- Handler untuk mendapatkan data
GetDataRemote.OnServerInvoke = function(player, dataType)
	if not HasFullAccess(player) then
		return nil
	end
	
	if dataType == "PlayerList" then
		local playerList = {}
		for _, p in ipairs(Players:GetPlayers()) do
			table.insert(playerList, {
				Name = p.Name,
				UserId = p.UserId,
				IsAdmin = IsAdmin(p)
			})
		end
		return playerList
		
	elseif dataType == "Features" then
		return PlayerFeatures[player.UserId]
		
	elseif dataType == "ServerStats" then
		return {
			PlayerCount = #Players:GetPlayers(),
			ServerTime = workspace.DistributedGameTime,
			Ping = player:GetNetworkPing() * 1000
		}
	end
	
	return nil
end

-- Handler untuk aksi admin
ActionRemote.OnServerEvent:Connect(function(player, action, ...)
	-- Validasi akses
	if not HasFullAccess(player) then
		SendNotification(player, "Access Denied", "You don't have permission!", "Error")
		return
	end
	
	local args = {...}
	local features = PlayerFeatures[player.UserId]
	
	-- Proses aksi
	if action == "GodMode" then
		ToggleGodMode(player, args[1])
		
	elseif action == "InfiniteHealth" then
		ToggleInfiniteHealth(player, args[1])
		
	elseif action == "AutoHeal" then
		ToggleAutoHeal(player, args[1])
		
	elseif action == "AuraHit" then
		ToggleAuraHit(player, args[1])
		
	elseif action == "SetAuraRadius" then
		if features then
			features.AuraRadius = math.clamp(args[1], 1, 100)
		end
		
	elseif action == "SetAuraDamage" then
		if features then
			features.AuraDamage = math.clamp(args[1], 1, 1000)
		end
		
	elseif action == "SetAuraInterval" then
		if features then
			features.AuraInterval = math.clamp(args[1], 0.1, 5)
		end
		
	elseif action == "SetSpeed" then
		SetSpeed(player, math.clamp(args[1], 0, 500))
		
	elseif action == "SetJump" then
		SetJumpPower(player, math.clamp(args[1], 0, 500))
		
	elseif action == "TeleportTo" then
		TeleportToPlayer(player, args[1])
		
	elseif action == "TeleportAll" then
		TeleportAllToPlayer(player)
		
	elseif action == "Freeze" then
		FreezePlayer(player, args[1], args[2])
		
	elseif action == "Kick" then
		KickPlayer(player, args[1], args[2])
		
	elseif action == "KillAllNPC" then
		KillAllNPC(player)
		
	elseif action == "SpawnTool" then
		SpawnTool(player, args[1])
		
	elseif action == "AutoRevive" then
		ToggleAutoRevive(player, args[1])
		
	elseif action == "Respawn" then
		player:LoadCharacter()
		SendNotification(player, "Respawn", "Character respawned!", "Info")
		
	elseif action == "SetFeature" then
		-- Generic feature setter
		local featureName = args[1]
		local value = args[2]
		if features and features[featureName] ~= nil then
			features[featureName] = value
			SendNotification(player, featureName, "Set to "..tostring(value), "Info")
		end
		
	-- Client-side features (hanya update state)
	elseif action == "Fly" or action == "Noclip" or action == "InfiniteJump" or
	       action == "ESPPlayer" or action == "ESPNPC" or action == "Invisible" or
	       action == "FreeCamera" or action == "NightVision" or action == "XRay" then
		if features then
			features[action] = args[1]
			SendNotification(player, action, args[1] and "ENABLED" or "DISABLED", args[1] and "Success" or "Info")
		end
	end
end)

--============================================================================--
--                          CLIENT UI SCRIPT                                    --
--============================================================================--

-- Script UI yang akan di-inject ke client
local ClientUIScript = [[
--============================================================================--
--                     FELSKY CLIENT UI - Auto Generated                       --
--============================================================================--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remotes
local RemotesFolder = ReplicatedStorage:WaitForChild("FELSKY_Remotes")
local KeyVerifyRemote = RemotesFolder:WaitForChild("VerifyKey")
local ActionRemote = RemotesFolder:WaitForChild("AdminAction")
local NotifyRemote = RemotesFolder:WaitForChild("Notify")
local GetDataRemote = RemotesFolder:WaitForChild("GetData")
local UpdateUIRemote = RemotesFolder:WaitForChild("UpdateUI")

-- State
local isUnlocked = false
local isMenuOpen = false
local currentCategory = "Movement"

-- Warna
local Colors = {
	BACKGROUND = Color3.fromRGB(18, 18, 24),
	SIDEBAR = Color3.fromRGB(25, 25, 35),
	PANEL = Color3.fromRGB(30, 30, 42),
	ACCENT = Color3.fromRGB(88, 101, 242),
	ACCENT_HOVER = Color3.fromRGB(108, 121, 255),
	SUCCESS = Color3.fromRGB(87, 242, 135),
	ERROR = Color3.fromRGB(237, 66, 69),
	WARNING = Color3.fromRGB(254, 231, 92),
	TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),
	TEXT_SECONDARY = Color3.fromRGB(185, 187, 190),
	TOGGLE_ON = Color3.fromRGB(87, 242, 135),
	TOGGLE_OFF = Color3.fromRGB(85, 85, 95),
}

-- Client-side feature states
local ClientFeatures = {
	Fly = false,
	Noclip = false,
	InfiniteJump = false,
	ESPPlayer = false,
	ESPNPC = false,
	FreeCamera = false,
}

-- Client-side connections
local ClientConnections = {}

--============================================================================--
--                          UI CREATION FUNCTIONS                              --
--============================================================================--

local function CreateCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = parent
	return corner
end

local function CreatePadding(parent, padding)
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingTop = UDim.new(0, padding)
	uiPadding.PaddingBottom = UDim.new(0, padding)
	uiPadding.PaddingLeft = UDim.new(0, padding)
	uiPadding.PaddingRight = UDim.new(0, padding)
	uiPadding.Parent = parent
	return uiPadding
end

local function CreateStroke(parent, color, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Color3.fromRGB(60, 60, 80)
	stroke.Thickness = thickness or 1
	stroke.Parent = parent
	return stroke
end

local function Tween(object, properties, duration, style, direction)
	local tweenInfo = TweenInfo.new(
		duration or 0.3,
		style or Enum.EasingStyle.Quart,
		direction or Enum.EasingDirection.Out
	)
	local tween = TweenService:Create(object, tweenInfo, properties)
	tween:Play()
	return tween
end

--============================================================================--
--                          KEY SYSTEM UI                                      --
--============================================================================--

local function CreateKeySystemUI()
	-- Screen GUI
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FELSKY_KeySystem"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui
	
	-- Background blur
	local blur = Instance.new("Frame")
	blur.Name = "Blur"
	blur.Size = UDim2.new(1, 0, 1, 0)
	blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	blur.BackgroundTransparency = 0.5
	blur.BorderSizePixel = 0
	blur.Parent = screenGui
	
	-- Main container
	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(0, 400, 0, 280)
	container.Position = UDim2.new(0.5, -200, 0.5, -140)
	container.BackgroundColor3 = Colors.BACKGROUND
	container.BorderSizePixel = 0
	container.Parent = screenGui
	CreateCorner(container, 12)
	CreateStroke(container, Colors.ACCENT, 2)
	
	-- Header
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 60)
	header.BackgroundColor3 = Colors.SIDEBAR
	header.BorderSizePixel = 0
	header.Parent = container
	CreateCorner(header, 12)
	
	-- Fix corner di bagian bawah header
	local headerFix = Instance.new("Frame")
	headerFix.Size = UDim2.new(1, 0, 0, 15)
	headerFix.Position = UDim2.new(0, 0, 1, -15)
	headerFix.BackgroundColor3 = Colors.SIDEBAR
	headerFix.BorderSizePixel = 0
	headerFix.Parent = header
	
	-- Title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 1, 0)
	title.BackgroundTransparency = 1
	title.Text = "🔐 FELSKY KEY SYSTEM"
	title.TextColor3 = Colors.TEXT_PRIMARY
	title.TextSize = 22
	title.Font = Enum.Font.GothamBold
	title.Parent = header
	
	-- Content
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, -40, 1, -80)
	content.Position = UDim2.new(0, 20, 0, 70)
	content.BackgroundTransparency = 1
	content.Parent = container
	
	-- Subtitle
	local subtitle = Instance.new("TextLabel")
	subtitle.Size = UDim2.new(1, 0, 0, 30)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = "Enter your access key to continue"
	subtitle.TextColor3 = Colors.TEXT_SECONDARY
	subtitle.TextSize = 14
	subtitle.Font = Enum.Font.Gotham
	subtitle.Parent = content
	
	-- Key input box
	local inputBox = Instance.new("Frame")
	inputBox.Size = UDim2.new(1, 0, 0, 50)
	inputBox.Position = UDim2.new(0, 0, 0, 45)
	inputBox.BackgroundColor3 = Colors.PANEL
	inputBox.Parent = content
	CreateCorner(inputBox, 8)
	CreateStroke(inputBox, Color3.fromRGB(60, 60, 80), 1)
	
	local keyInput = Instance.new("TextBox")
	keyInput.Name = "KeyInput"
	keyInput.Size = UDim2.new(1, -20, 1, 0)
	keyInput.Position = UDim2.new(0, 10, 0, 0)
	keyInput.BackgroundTransparency = 1
	keyInput.Text = ""
	keyInput.PlaceholderText = "Enter key here..."
	keyInput.PlaceholderColor3 = Colors.TEXT_SECONDARY
	keyInput.TextColor3 = Colors.TEXT_PRIMARY
	keyInput.TextSize = 16
	keyInput.Font = Enum.Font.GothamMedium
	keyInput.ClearTextOnFocus = false
	keyInput.Parent = inputBox
	
	-- Submit button
	local submitBtn = Instance.new("TextButton")
	submitBtn.Name = "SubmitBtn"
	submitBtn.Size = UDim2.new(1, 0, 0, 45)
	submitBtn.Position = UDim2.new(0, 0, 0, 110)
	submitBtn.BackgroundColor3 = Colors.ACCENT
	submitBtn.Text = "🔓 UNLOCK FELSKY"
	submitBtn.TextColor3 = Colors.TEXT_PRIMARY
	submitBtn.TextSize = 16
	submitBtn.Font = Enum.Font.GothamBold
	submitBtn.AutoButtonColor = false
	submitBtn.Parent = content
	CreateCorner(submitBtn, 8)
	
	-- Status label
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Size = UDim2.new(1, 0, 0, 25)
	statusLabel.Position = UDim2.new(0, 0, 0, 165)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Text = ""
	statusLabel.TextColor3 = Colors.TEXT_SECONDARY
	statusLabel.TextSize = 12
	statusLabel.Font = Enum.Font.Gotham
	statusLabel.Parent = content
	
	-- Button hover effect
	submitBtn.MouseEnter:Connect(function()
		Tween(submitBtn, {BackgroundColor3 = Colors.ACCENT_HOVER}, 0.2)
	end)
	
	submitBtn.MouseLeave:Connect(function()
		Tween(submitBtn, {BackgroundColor3 = Colors.ACCENT}, 0.2)
	end)
	
	-- Submit logic
	local function submitKey()
		local key = keyInput.Text
		if key == "" then
			statusLabel.Text = "⚠️ Please enter a key!"
			statusLabel.TextColor3 = Colors.WARNING
			return
		end
		
		statusLabel.Text = "⏳ Verifying..."
		statusLabel.TextColor3 = Colors.TEXT_SECONDARY
		submitBtn.Text = "Verifying..."
		
		local result = KeyVerifyRemote:InvokeServer(key)
		
		if result and result.Success then
			statusLabel.Text = "✅ "..result.Message
			statusLabel.TextColor3 = Colors.SUCCESS
			isUnlocked = true
			
			-- Animate out
			wait(1)
			Tween(container, {Position = UDim2.new(0.5, -200, -0.5, 0)}, 0.5)
			Tween(blur, {BackgroundTransparency = 1}, 0.5)
			wait(0.5)
			screenGui:Destroy()
			
			-- Create main UI
			CreateMainUI()
		else
			statusLabel.Text = "❌ "..(result and result.Message or "Invalid Key")
			statusLabel.TextColor3 = Colors.ERROR
			submitBtn.Text = "🔓 UNLOCK FELSKY"
			
			-- Shake animation
			local originalPos = container.Position
			for i = 1, 5 do
				container.Position = originalPos + UDim2.new(0, math.random(-5, 5), 0, 0)
				wait(0.05)
			end
			container.Position = originalPos
		end
	end
	
	submitBtn.MouseButton1Click:Connect(submitKey)
	keyInput.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			submitKey()
		end
	end)
	
	-- Animate in
	container.Position = UDim2.new(0.5, -200, 1.5, 0)
	blur.BackgroundTransparency = 1
	wait(0.1)
	Tween(container, {Position = UDim2.new(0.5, -200, 0.5, -140)}, 0.5, Enum.EasingStyle.Back)
	Tween(blur, {BackgroundTransparency = 0.5}, 0.3)
	
	return screenGui
end

--============================================================================--
--                          MAIN UI                                            --
--============================================================================--

local MainGui = nil
local ContentPanels = {}
local ToggleStates = {}

local function CreateToggle(parent, name, description, callback)
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Name = name
	toggleFrame.Size = UDim2.new(1, 0, 0, 50)
	toggleFrame.BackgroundColor3 = Colors.PANEL
	toggleFrame.BorderSizePixel = 0
	toggleFrame.Parent = parent
	CreateCorner(toggleFrame, 6)
	
	-- Label
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.7, -60, 0, 20)
	label.Position = UDim2.new(0, 15, 0, 8)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Colors.TEXT_PRIMARY
	label.TextSize = 14
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = toggleFrame
	
	-- Description
	local desc = Instance.new("TextLabel")
	desc.Size = UDim2.new(0.7, -60, 0, 15)
	desc.Position = UDim2.new(0, 15, 0, 28)
	desc.BackgroundTransparency = 1
	desc.Text = description or ""
	desc.TextColor3 = Colors.TEXT_SECONDARY
	desc.TextSize = 11
	desc.Font = Enum.Font.Gotham
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.Parent = toggleFrame
	
	-- Toggle button
	local toggleBg = Instance.new("Frame")
	toggleBg.Name = "ToggleBg"
	toggleBg.Size = UDim2.new(0, 50, 0, 26)
	toggleBg.Position = UDim2.new(1, -65, 0.5, -13)
	toggleBg.BackgroundColor3 = Colors.TOGGLE_OFF
	toggleBg.Parent = toggleFrame
	CreateCorner(toggleBg, 13)
	
	local toggleCircle = Instance.new("Frame")
	toggleCircle.Name = "Circle"
	toggleCircle.Size = UDim2.new(0, 22, 0, 22)
	toggleCircle.Position = UDim2.new(0, 2, 0.5, -11)
	toggleCircle.BackgroundColor3 = Colors.TEXT_PRIMARY
	toggleCircle.Parent = toggleBg
	CreateCorner(toggleCircle, 11)
	
	local isOn = false
	ToggleStates[name] = false
	
	local function setToggle(state)
		isOn = state
		ToggleStates[name] = state
		
		if state then
			Tween(toggleBg, {BackgroundColor3 = Colors.TOGGLE_ON}, 0.2)
			Tween(toggleCircle, {Position = UDim2.new(1, -24, 0.5, -11)}, 0.2)
		else
			Tween(toggleBg, {BackgroundColor3 = Colors.TOGGLE_OFF}, 0.2)
			Tween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -11)}, 0.2)
		end
		
		if callback then
			callback(state)
		end
	end
	
	toggleBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			setToggle(not isOn)
		end
	end)
	
	return toggleFrame, setToggle
end

local function CreateSlider(parent, name, min, max, default, callback)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Name = name
	sliderFrame.Size = UDim2.new(1, 0, 0, 60)
	sliderFrame.BackgroundColor3 = Colors.PANEL
	sliderFrame.BorderSizePixel = 0
	sliderFrame.Parent = parent
	CreateCorner(sliderFrame, 6)
	
	-- Label
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.5, 0, 0, 25)
	label.Position = UDim2.new(0, 15, 0, 5)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Colors.TEXT_PRIMARY
	label.TextSize = 14
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = sliderFrame
	
	-- Value label
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Name = "Value"
	valueLabel.Size = UDim2.new(0.5, -15, 0, 25)
	valueLabel.Position = UDim2.new(0.5, 0, 0, 5)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(default)
	valueLabel.TextColor3 = Colors.ACCENT
	valueLabel.TextSize = 14
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = sliderFrame
	
	-- Slider track
	local track = Instance.new("Frame")
	track.Name = "Track"
	track.Size = UDim2.new(1, -30, 0, 8)
	track.Position = UDim2.new(0, 15, 0, 38)
	track.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
	track.Parent = sliderFrame
	CreateCorner(track, 4)
	
	-- Slider fill
	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = Colors.ACCENT
	fill.Parent = track
	CreateCorner(fill, 4)
	
	-- Slider knob
	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
	knob.BackgroundColor3 = Colors.TEXT_PRIMARY
	knob.Parent = track
	CreateCorner(knob, 8)
	
	local dragging = false
	local currentValue = default
	
	local function updateSlider(input)
		local trackPos = track.AbsolutePosition.X
		local trackSize = track.AbsoluteSize.X
		local mouseX = input.Position.X
		
		local percent = math.clamp((mouseX - trackPos) / trackSize, 0, 1)
		local value = math.floor(min + (max - min) * percent)
		
		currentValue = value
		valueLabel.Text = tostring(value)
		fill.Size = UDim2.new(percent, 0, 1, 0)
		knob.Position = UDim2.new(percent, -8, 0.5, -8)
		
		if callback then
			callback(value)
		end
	end
	
	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateSlider(input)
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	
	return sliderFrame
end

local function CreateButton(parent, name, description, callback)
	local btnFrame = Instance.new("Frame")
	btnFrame.Name = name
	btnFrame.Size = UDim2.new(1, 0, 0, 45)
	btnFrame.BackgroundColor3 = Colors.PANEL
	btnFrame.BorderSizePixel = 0
	btnFrame.Parent = parent
	CreateCorner(btnFrame, 6)
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.Parent = btnFrame
	
	-- Label
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -30, 0, 20)
	label.Position = UDim2.new(0, 15, 0, 5)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Colors.TEXT_PRIMARY
	label.TextSize = 14
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = btnFrame
	
	-- Description
	if description then
		local desc = Instance.new("TextLabel")
		desc.Size = UDim2.new(1, -30, 0, 15)
		desc.Position = UDim2.new(0, 15, 0, 25)
		desc.BackgroundTransparency = 1
		desc.Text = description
		desc.TextColor3 = Colors.TEXT_SECONDARY
		desc.TextSize = 11
		desc.Font = Enum.Font.Gotham
		desc.TextXAlignment = Enum.TextXAlignment.Left
		desc.Parent = btnFrame
	end
	
	-- Icon
	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(0, 20, 1, 0)
	icon.Position = UDim2.new(1, -30, 0, 0)
	icon.BackgroundTransparency = 1
	icon.Text = "▶"
	icon.TextColor3 = Colors.ACCENT
	icon.TextSize = 12
	icon.Font = Enum.Font.GothamBold
	icon.Parent = btnFrame
	
	btn.MouseEnter:Connect(function()
		Tween(btnFrame, {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}, 0.2)
	end)
	
	btn.MouseLeave:Connect(function()
		Tween(btnFrame, {BackgroundColor3 = Colors.PANEL}, 0.2)
	end)
	
	btn.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)
	
	return btnFrame
end

local function CreateDropdown(parent, name, options, callback)
	local dropFrame = Instance.new("Frame")
	dropFrame.Name = name
	dropFrame.Size = UDim2.new(1, 0, 0, 45)
	dropFrame.BackgroundColor3 = Colors.PANEL
	dropFrame.ClipsDescendants = true
	dropFrame.Parent = parent
	CreateCorner(dropFrame, 6)
	
	-- Header
	local header = Instance.new("TextButton")
	header.Size = UDim2.new(1, 0, 0, 45)
	header.BackgroundTransparency = 1
	header.Text = ""
	header.Parent = dropFrame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.Position = UDim2.new(0, 15, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Colors.TEXT_PRIMARY
	label.TextSize = 14
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = header
	
	local arrow = Instance.new("TextLabel")
	arrow.Size = UDim2.new(0, 20, 1, 0)
	arrow.Position = UDim2.new(1, -35, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = "▼"
	arrow.TextColor3 = Colors.TEXT_SECONDARY
	arrow.TextSize = 12
	arrow.Font = Enum.Font.GothamBold
	arrow.Parent = header
	
	-- Options container
	local optionsFrame = Instance.new("Frame")
	optionsFrame.Size = UDim2.new(1, -20, 0, #options * 35)
	optionsFrame.Position = UDim2.new(0, 10, 0, 50)
	optionsFrame.BackgroundTransparency = 1
	optionsFrame.Parent = dropFrame
	
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 5)
	layout.Parent = optionsFrame
	
	local isOpen = false
	
	for i, option in ipairs(options) do
		local optBtn = Instance.new("TextButton")
		optBtn.Size = UDim2.new(1, 0, 0, 30)
		optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
		optBtn.Text = option
		optBtn.TextColor3 = Colors.TEXT_SECONDARY
		optBtn.TextSize = 12
		optBtn.Font = Enum.Font.Gotham
		optBtn.Parent = optionsFrame
		CreateCorner(optBtn, 4)
		
		optBtn.MouseButton1Click:Connect(function()
			if callback then
				callback(option)
			end
			label.Text = name..": "..option
			isOpen = false
			Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 45)}, 0.2)
			arrow.Text = "▼"
		end)
	end
	
	header.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		if isOpen then
			Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 55 + #options * 35)}, 0.2)
			arrow.Text = "▲"
		else
			Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 45)}, 0.2)
			arrow.Text = "▼"
		end
	end)
	
	return dropFrame
end

--============================================================================--
--                          CLIENT-SIDE FEATURES                               --
--============================================================================--

-- FLY SYSTEM
local function ToggleFly(enabled)
	ClientFeatures.Fly = enabled
	
	if ClientConnections.Fly then
		ClientConnections.Fly:Disconnect()
		ClientConnections.Fly = nil
	end
	
	if ClientConnections.FlyBV then
		ClientConnections.FlyBV:Destroy()
		ClientConnections.FlyBV = nil
	end
	
	if enabled then
		local character = player.Character
		if not character then return end
		
		local humanoid = character:FindFirstChild("Humanoid")
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not rootPart then return end
		
		local bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.Parent = rootPart
		ClientConnections.FlyBV = bv
		
		local bg = Instance.new("BodyGyro")
		bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bg.P = 10000
		bg.Parent = rootPart
		ClientConnections.FlyBG = bg
		
		local flySpeed = 100
		
		ClientConnections.Fly = RunService.RenderStepped:Connect(function()
			if not ClientFeatures.Fly then return end
			
			local camera = workspace.CurrentCamera
			local moveDirection = Vector3.new(0, 0, 0)
			
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				moveDirection = moveDirection + camera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				moveDirection = moveDirection - camera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				moveDirection = moveDirection - camera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				moveDirection = moveDirection + camera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				moveDirection = moveDirection + Vector3.new(0, 1, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
				moveDirection = moveDirection - Vector3.new(0, 1, 0)
			end
			
			bv.Velocity = moveDirection.Unit * flySpeed
			bg.CFrame = camera.CFrame
		end)
	else
		if ClientConnections.FlyBG then
			ClientConnections.FlyBG:Destroy()
			ClientConnections.FlyBG = nil
		end
	end
	
	ActionRemote:FireServer("Fly", enabled)
end

-- NOCLIP SYSTEM
local function ToggleNoclip(enabled)
	ClientFeatures.Noclip = enabled
	
	if ClientConnections.Noclip then
		ClientConnections.Noclip:Disconnect()
		ClientConnections.Noclip = nil
	end
	
	if enabled then
		ClientConnections.Noclip = RunService.Stepped:Connect(function()
			if not ClientFeatures.Noclip then return end
			
			local character = player.Character
			if character then
				for _, part in ipairs(character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	end
	
	ActionRemote:FireServer("Noclip", enabled)
end

-- INFINITE JUMP
local function ToggleInfiniteJump(enabled)
	ClientFeatures.InfiniteJump = enabled
	
	if ClientConnections.InfiniteJump then
		ClientConnections.InfiniteJump:Disconnect()
		ClientConnections.InfiniteJump = nil
	end
	
	if enabled then
		ClientConnections.InfiniteJump = UserInputService.JumpRequest:Connect(function()
			if not ClientFeatures.InfiniteJump then return end
			
			local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end
	
	ActionRemote:FireServer("InfiniteJump", enabled)
end

-- ESP SYSTEM
local ESPFolder = nil

local function CreateESP(target, color, text)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "FELSKY_ESP"
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.AlwaysOnTop = true
	billboard.Adornee = target
	billboard.Parent = ESPFolder
	
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundColor3 = color
	frame.BackgroundTransparency = 0.5
	frame.Parent = billboard
	CreateCorner(frame, 4)
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextSize = 12
	label.Font = Enum.Font.GothamBold
	label.Parent = frame
	
	return billboard
end

local function ToggleESPPlayer(enabled)
	ClientFeatures.ESPPlayer = enabled
	
	if not ESPFolder then
		ESPFolder = Instance.new("Folder")
		ESPFolder.Name = "FELSKY_ESP"
		ESPFolder.Parent = workspace.CurrentCamera
	end
	
	-- Clear existing ESP
	for _, child in ipairs(ESPFolder:GetChildren()) do
		if child.Name == "FELSKY_ESP_Player" then
			child:Destroy()
		end
	end
	
	if ClientConnections.ESPUpdate then
		ClientConnections.ESPUpdate:Disconnect()
		ClientConnections.ESPUpdate = nil
	end
	
	if enabled then
		local function updateESP()
			-- Clear existing
			for _, child in ipairs(ESPFolder:GetChildren()) do
				if child.Name == "FELSKY_ESP_Player" then
					child:Destroy()
				end
			end
			
			for _, otherPlayer in ipairs(Players:GetPlayers()) do
				if otherPlayer ~= player then
					local character = otherPlayer.Character
					local rootPart = character and character:FindFirstChild("HumanoidRootPart")
					local head = character and character:FindFirstChild("Head")
					
					if head and rootPart then
						local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
						local distance = myRoot and math.floor((myRoot.Position - rootPart.Position).Magnitude) or 0
						
						local esp = CreateESP(head, Colors.ACCENT, otherPlayer.Name.."\n["..distance.."m]")
						esp.Name = "FELSKY_ESP_Player"
					end
				end
			end
		end
		
		updateESP()
		ClientConnections.ESPUpdate = RunService.Heartbeat:Connect(function()
			if not ClientFeatures.ESPPlayer then return end
			updateESP()
		end)
	end
	
	ActionRemote:FireServer("ESPPlayer", enabled)
end

--============================================================================--
--                          CREATE MAIN UI                                     --
--============================================================================--

function CreateMainUI()
	MainGui = Instance.new("ScreenGui")
	MainGui.Name = "FELSKY_Main"
	MainGui.ResetOnSpawn = false
	MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	MainGui.Parent = playerGui
	
	-- TOGGLE BUTTON ("sky kuyy")
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Name = "ToggleButton"
	toggleBtn.Size = UDim2.new(0, 100, 0, 40)
	toggleBtn.Position = UDim2.new(0, 20, 0.5, -20)
	toggleBtn.BackgroundColor3 = Colors.ACCENT
	toggleBtn.Text = "sky kuyy"
	toggleBtn.TextColor3 = Colors.TEXT_PRIMARY
	toggleBtn.TextSize = 14
	toggleBtn.Font = Enum.Font.GothamBold
	toggleBtn.AutoButtonColor = false
	toggleBtn.Parent = MainGui
	CreateCorner(toggleBtn, 8)
	CreateStroke(toggleBtn, Colors.ACCENT_HOVER, 2)
	
	-- Make draggable
	local dragging = false
	local dragStart, startPos
	
	toggleBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = toggleBtn.Position
		end
	end)
	
	toggleBtn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			toggleBtn.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
	
	-- MAIN PANEL
	local mainPanel = Instance.new("Frame")
	mainPanel.Name = "MainPanel"
	mainPanel.Size = UDim2.new(0, 700, 0, 500)
	mainPanel.Position = UDim2.new(0.5, -350, 0.5, -250)
	mainPanel.BackgroundColor3 = Colors.BACKGROUND
	mainPanel.Visible = false
	mainPanel.Parent = MainGui
	CreateCorner(mainPanel, 12)
	CreateStroke(mainPanel, Color3.fromRGB(60, 60, 80), 1)
	
	-- Header
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 50)
	header.BackgroundColor3 = Colors.SIDEBAR
	header.BorderSizePixel = 0
	header.Parent = mainPanel
	CreateCorner(header, 12)
	
	local headerFix = Instance.new("Frame")
	headerFix.Size = UDim2.new(1, 0, 0, 15)
	headerFix.Position = UDim2.new(0, 0, 1, -15)
	headerFix.BackgroundColor3 = Colors.SIDEBAR
	headerFix.BorderSizePixel = 0
	headerFix.Parent = header
	
	-- Title in header
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(0, 200, 1, 0)
	titleLabel.Position = UDim2.new(0, 20, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "⚡ FELSKY v2.0"
	titleLabel.TextColor3 = Colors.ACCENT
	titleLabel.TextSize = 20
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = header
	
	-- Minimize button (-)
	local minimizeBtn = Instance.new("TextButton")
	minimizeBtn.Name = "MinimizeBtn"
	minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
	minimizeBtn.Position = UDim2.new(1, -45, 0, 7)
	minimizeBtn.BackgroundColor3 = Colors.PANEL
	minimizeBtn.Text = "−"
	minimizeBtn.TextColor3 = Colors.TEXT_PRIMARY
	minimizeBtn.TextSize = 24
	minimizeBtn.Font = Enum.Font.GothamBold
	minimizeBtn.Parent = header
	CreateCorner(minimizeBtn, 6)
	
	-- Sidebar
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 180, 1, -60)
	sidebar.Position = UDim2.new(0, 0, 0, 55)
	sidebar.BackgroundColor3 = Colors.SIDEBAR
	sidebar.BorderSizePixel = 0
	sidebar.Parent = mainPanel
	CreateCorner(sidebar, 12)
	
	local sidebarFix = Instance.new("Frame")
	sidebarFix.Size = UDim2.new(0, 15, 1, 0)
	sidebarFix.Position = UDim2.new(1, -15, 0, 0)
	sidebarFix.BackgroundColor3 = Colors.SIDEBAR
	sidebarFix.BorderSizePixel = 0
	sidebarFix.Parent = sidebar
	
	-- Category buttons
	local categories = {
		{Name = "Movement", Icon = "🏃"},
		{Name = "God/Survival", Icon = "🛡️"},
		{Name = "Combat", Icon = "⚔️"},
		{Name = "Aura Hit", Icon = "💥"},
		{Name = "Visual", Icon = "👁️"},
		{Name = "Admin", Icon = "👑"},
		{Name = "Dev Tools", Icon = "🔧"},
	}
	
	local categoryLayout = Instance.new("UIListLayout")
	categoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
	categoryLayout.Padding = UDim.new(0, 5)
	categoryLayout.Parent = sidebar
	
	local categoryPadding = Instance.new("UIPadding")
	categoryPadding.PaddingTop = UDim.new(0, 10)
	categoryPadding.PaddingLeft = UDim.new(0, 10)
	categoryPadding.PaddingRight = UDim.new(0, 10)
	categoryPadding.Parent = sidebar
	
	-- Content area
	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.Size = UDim2.new(1, -195, 1, -65)
	contentArea.Position = UDim2.new(0, 190, 0, 55)
	contentArea.BackgroundColor3 = Colors.PANEL
	contentArea.BorderSizePixel = 0
	contentArea.Parent = mainPanel
	CreateCorner(contentArea, 8)
	
	-- Create content panels for each category
	local function createContentPanel(categoryName)
		local scroll = Instance.new("ScrollingFrame")
		scroll.Name = categoryName
		scroll.Size = UDim2.new(1, -20, 1, -20)
		scroll.Position = UDim2.new(0, 10, 0, 10)
		scroll.BackgroundTransparency = 1
		scroll.ScrollBarThickness = 4
		scroll.ScrollBarImageColor3 = Colors.ACCENT
		scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
		scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scroll.Visible = false
		scroll.Parent = contentArea
		
		local layout = Instance.new("UIListLayout")
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Padding = UDim.new(0, 8)
		layout.Parent = scroll
		
		ContentPanels[categoryName] = scroll
		return scroll
	end
	
	-- Create category buttons
	local categoryButtons = {}
	
	for i, cat in ipairs(categories) do
		local catBtn = Instance.new("TextButton")
		catBtn.Name = cat.Name
		catBtn.Size = UDim2.new(1, 0, 0, 40)
		catBtn.BackgroundColor3 = Colors.PANEL
		catBtn.Text = cat.Icon.." "..cat.Name
		catBtn.TextColor3 = Colors.TEXT_SECONDARY
		catBtn.TextSize = 13
		catBtn.Font = Enum.Font.GothamMedium
		catBtn.TextXAlignment = Enum.TextXAlignment.Left
		catBtn.AutoButtonColor = false
		catBtn.Parent = sidebar
		CreateCorner(catBtn, 6)
		CreatePadding(catBtn, 10)
		
		createContentPanel(cat.Name)
		categoryButtons[cat.Name] = catBtn
		
		catBtn.MouseButton1Click:Connect(function()
			currentCategory = cat.Name
			
			-- Update button styles
			for name, btn in pairs(categoryButtons) do
				if name == cat.Name then
					Tween(btn, {BackgroundColor3 = Colors.ACCENT}, 0.2)
					btn.TextColor3 = Colors.TEXT_PRIMARY
				else
					Tween(btn, {BackgroundColor3 = Colors.PANEL}, 0.2)
					btn.TextColor3 = Colors.TEXT_SECONDARY
				end
			end
			
			-- Show/hide panels
			for name, panel in pairs(ContentPanels) do
				panel.Visible = name == cat.Name
			end
		end)
	end
	
	-- Set default category
	categoryButtons["Movement"].BackgroundColor3 = Colors.ACCENT
	categoryButtons["Movement"].TextColor3 = Colors.TEXT_PRIMARY
	ContentPanels["Movement"].Visible = true
	
	--==========================================================================--
	--                          POPULATE PANELS                                  --
	--==========================================================================--
	
	-- MOVEMENT PANEL
	local movementPanel = ContentPanels["Movement"]
	
	CreateToggle(movementPanel, "Fly", "Toggle flight mode (WASD + Space/Ctrl)", function(state)
		ToggleFly(state)
	end)
	
	CreateToggle(movementPanel, "Noclip", "Walk through walls", function(state)
		ToggleNoclip(state)
	end)
	
	CreateToggle(movementPanel, "Infinite Jump", "Jump in mid-air", function(state)
		ToggleInfiniteJump(state)
	end)
	
	CreateSlider(movementPanel, "Walk Speed", 16, 500, 16, function(value)
		ActionRemote:FireServer("SetSpeed", value)
	end)
	
	CreateSlider(movementPanel, "Jump Power", 50, 500, 50, function(value)
		ActionRemote:FireServer("SetJump", value)
	end)
	
	CreateButton(movementPanel, "Teleport to Mouse", "Click to teleport", function()
		local mouse = player:GetMouse()
		local character = player.Character
		local rootPart = character and character:FindFirstChild("HumanoidRootPart")
		if rootPart and mouse.Hit then
			rootPart.CFrame = mouse.Hit + Vector3.new(0, 3, 0)
		end
	end)
	
	-- GOD/SURVIVAL PANEL
	local godPanel = ContentPanels["God/Survival"]
	
	CreateToggle(godPanel, "God Mode", "Infinite health, cannot die", function(state)
		ActionRemote:FireServer("GodMode", state)
	end)
	
	CreateToggle(godPanel, "Infinite Health", "Health always full", function(state)
		ActionRemote:FireServer("InfiniteHealth", state)
	end)
	
	CreateToggle(godPanel, "Auto Heal", "Slowly regenerate health", function(state)
		ActionRemote:FireServer("AutoHeal", state)
	end)
	
	CreateToggle(godPanel, "Auto Revive", "Auto respawn on death", function(state)
		ActionRemote:FireServer("AutoRevive", state)
	end)
	
	CreateButton(godPanel, "Respawn", "Reset your character", function()
		ActionRemote:FireServer("Respawn")
	end)
	
	-- COMBAT PANEL
	local combatPanel = ContentPanels["Combat"]
	
	CreateToggle(combatPanel, "Big Hitbox", "Increase your hitbox size", function(state)
		ActionRemote:FireServer("SetFeature", "BigHitbox", state)
	end)
	
	CreateSlider(combatPanel, "Hitbox Size", 1, 20, 5, function(value)
		ActionRemote:FireServer("SetFeature", "HitboxSize", value)
	end)
	
	CreateButton(combatPanel, "Kill All NPC", "Eliminate all NPCs", function()
		ActionRemote:FireServer("KillAllNPC")
	end)
	
	-- AURA HIT PANEL
	local auraPanel = ContentPanels["Aura Hit"]
	
	CreateToggle(auraPanel, "Aura Hit", "Auto damage nearby entities", function(state)
		ActionRemote:FireServer("AuraHit", state)
	end)
	
	CreateSlider(auraPanel, "Aura Radius", 5, 100, 50, function(value)
		ActionRemote:FireServer("SetAuraRadius", value)
	end)
	
	CreateSlider(auraPanel, "Aura Damage", 1, 100, 25, function(value)
		ActionRemote:FireServer("SetAuraDamage", value)
	end)
	
	CreateSlider(auraPanel, "Hit Interval", 1, 50, 5, function(value)
		ActionRemote:FireServer("SetAuraInterval", value / 10) -- Convert to seconds
	end)
	
	-- VISUAL PANEL
	local visualPanel = ContentPanels["Visual"]
	
	CreateToggle(visualPanel, "ESP Players", "See players through walls", function(state)
		ToggleESPPlayer(state)
	end)
	
	CreateToggle(visualPanel, "Invisible", "Other players can't see you", function(state)
		local character = player.Character
		if character then
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Transparency = state and 1 or 0
				end
				if part:IsA("Decal") then
					part.Transparency = state and 1 or 0
				end
			end
		end
		ActionRemote:FireServer("Invisible", state)
	end)
	
	-- ADMIN PANEL
	local adminPanel = ContentPanels["Admin"]
	
	-- Get player list for dropdown
	local playerNames = {}
	for _, p in ipairs(Players:GetPlayers()) do
		table.insert(playerNames, p.Name)
	end
	
	CreateDropdown(adminPanel, "Teleport to Player", playerNames, function(name)
		ActionRemote:FireServer("TeleportTo", name)
	end)
	
	CreateButton(adminPanel, "Teleport All Here", "Bring all players to you", function()
		ActionRemote:FireServer("TeleportAll")
	end)
	
	CreateDropdown(adminPanel, "Freeze Player", playerNames, function(name)
		ActionRemote:FireServer("Freeze", name, true)
	end)
	
	CreateDropdown(adminPanel, "Unfreeze Player", playerNames, function(name)
		ActionRemote:FireServer("Freeze", name, false)
	end)
	
	CreateDropdown(adminPanel, "Kick Player", playerNames, function(name)
		ActionRemote:FireServer("Kick", name, "Kicked by admin")
	end)
	
	-- DEV TOOLS PANEL
	local devPanel = ContentPanels["Dev Tools"]
	
	CreateButton(devPanel, "Spawn Tool", "Create a basic tool", function()
		ActionRemote:FireServer("SpawnTool", "TestTool")
	end)
	
	CreateButton(devPanel, "Print Server Stats", "Show server info", function()
		local stats = GetDataRemote:InvokeServer("ServerStats")
		if stats then
			print("=== FELSKY Server Stats ===")
			print("Players: "..stats.PlayerCount)
			print("Server Time: "..math.floor(stats.ServerTime).."s")
			print("Ping: "..math.floor(stats.Ping).."ms")
		end
	end)
	
	--==========================================================================--
	--                          TOGGLE MENU                                      --
	--==========================================================================--
	
	local function toggleMenu()
		isMenuOpen = not isMenuOpen
		
		if isMenuOpen then
			mainPanel.Visible = true
			mainPanel.Position = UDim2.new(0.5, -350, 1.5, 0)
			Tween(mainPanel, {Position = UDim2.new(0.5, -350, 0.5, -250)}, 0.4, Enum.EasingStyle.Back)
		else
			Tween(mainPanel, {Position = UDim2.new(0.5, -350, 1.5, 0)}, 0.3)
			wait(0.3)
			mainPanel.Visible = false
		end
	end
	
	toggleBtn.MouseButton1Click:Connect(toggleMenu)
	minimizeBtn.MouseButton1Click:Connect(toggleMenu)
	
	-- Hover effects
	toggleBtn.MouseEnter:Connect(function()
		Tween(toggleBtn, {BackgroundColor3 = Colors.ACCENT_HOVER}, 0.2)
	end)
	
	toggleBtn.MouseLeave:Connect(function()
		Tween(toggleBtn, {BackgroundColor3 = Colors.ACCENT}, 0.2)
	end)
	
	--==========================================================================--
	--                          NOTIFICATION HANDLER                             --
	--==========================================================================--
	
	local notificationContainer = Instance.new("Frame")
	notificationContainer.Name = "Notifications"
	notificationContainer.Size = UDim2.new(0, 300, 1, 0)
	notificationContainer.Position = UDim2.new(1, -320, 0, 0)
	notificationContainer.BackgroundTransparency = 1
	notificationContainer.Parent = MainGui
	
	local notifLayout = Instance.new("UIListLayout")
	notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
	notifLayout.Padding = UDim.new(0, 10)
	notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	notifLayout.Parent = notificationContainer
	
	local notifPadding = Instance.new("UIPadding")
	notifPadding.PaddingBottom = UDim.new(0, 20)
	notifPadding.Parent = notificationContainer
	
	NotifyRemote.OnClientEvent:Connect(function(data)
		local notifFrame = Instance.new("Frame")
		notifFrame.Size = UDim2.new(1, 0, 0, 70)
		notifFrame.BackgroundColor3 = Colors.SIDEBAR
		notifFrame.Parent = notificationContainer
		CreateCorner(notifFrame, 8)
		
		local accentColor = Colors.ACCENT
		if data.Type == "Success" then
			accentColor = Colors.SUCCESS
		elseif data.Type == "Error" then
			accentColor = Colors.ERROR
		elseif data.Type == "Warning" then
			accentColor = Colors.WARNING
		end
		
		local accent = Instance.new("Frame")
		accent.Size = UDim2.new(0, 4, 1, -10)
		accent.Position = UDim2.new(0, 5, 0, 5)
		accent.BackgroundColor3 = accentColor
		accent.Parent = notifFrame
		CreateCorner(accent, 2)
		
		local titleLabel = Instance.new("TextLabel")
		titleLabel.Size = UDim2.new(1, -30, 0, 25)
		titleLabel.Position = UDim2.new(0, 20, 0, 10)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = data.Title or "Notification"
		titleLabel.TextColor3 = Colors.TEXT_PRIMARY
		titleLabel.TextSize = 14
		titleLabel.Font = Enum.Font.GothamBold
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.Parent = notifFrame
		
		local msgLabel = Instance.new("TextLabel")
		msgLabel.Size = UDim2.new(1, -30, 0, 30)
		msgLabel.Position = UDim2.new(0, 20, 0, 35)
		msgLabel.BackgroundTransparency = 1
		msgLabel.Text = data.Message or ""
		msgLabel.TextColor3 = Colors.TEXT_SECONDARY
		msgLabel.TextSize = 12
		msgLabel.Font = Enum.Font.Gotham
		msgLabel.TextXAlignment = Enum.TextXAlignment.Left
		msgLabel.TextWrapped = true
		msgLabel.Parent = notifFrame
		
		-- Animate in
		notifFrame.Position = UDim2.new(1, 50, 0, 0)
		Tween(notifFrame, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)
		
		-- Auto remove
		delay(4, function()
			Tween(notifFrame, {Position = UDim2.new(1, 50, 0, 0)}, 0.3)
			wait(0.3)
			notifFrame:Destroy()
		end)
	end)
	
	-- Keyboard shortcut (RightControl to toggle)
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		
		if input.KeyCode == Enum.KeyCode.RightControl then
			toggleMenu()
		end
	end)
	
	-- Welcome notification
	wait(0.5)
	NotifyRemote.OnClientEvent:Fire({
		Title = "FELSKY Loaded",
		Message = "Welcome! Press 'sky kuyy' or RightCtrl to open menu.",
		Type = "Success"
	})
end

--============================================================================--
--                          INITIALIZATION                                     --
--============================================================================--

-- Start key system
CreateKeySystemUI()
]]

--============================================================================--
--                          PLAYER INITIALIZATION                              --
--============================================================================--

local function OnPlayerAdded(player)
	-- Cek apakah player adalah admin
	if not IsAdmin(player) then
		return -- Non-admin tidak mendapat UI sama sekali
	end
	
	-- Tunggu karakter load
	player.CharacterAdded:Wait()
	wait(1)
	
	-- Inject client script
	local clientScript = Instance.new("LocalScript")
	clientScript.Name = "FELSKY_Client"
	clientScript.Source = ClientUIScript
	clientScript.Parent = player:WaitForChild("PlayerGui")
	
	-- Alternative: gunakan loadstring jika Source tidak berfungsi
	-- Ini karena Roblox tidak mengizinkan set Source langsung
	-- Kita perlu menggunakan approach berbeda
end

local function OnPlayerRemoving(player)
	CleanupPlayer(player)
end

-- Connect events
Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)

-- Handle players yang sudah ada
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(function()
		OnPlayerAdded(player)
	end)
end

--============================================================================--
--                     ALTERNATIVE CLIENT INJECTION                            --
--============================================================================--

--[[
    CATATAN PENTING:
    Roblox tidak mengizinkan setting .Source pada LocalScript dari server.
    
    SOLUSI ALTERNATIF:
    1. Buat LocalScript manual di StarterPlayerScripts dengan nama "FELSKY_Client"
    2. Copy-paste isi ClientUIScript ke LocalScript tersebut
    
    ATAU gunakan ModuleScript approach (tapi ini melanggar aturan 1 file)
    
    Untuk demo, script ini akan membuat struktur yang diperlukan,
    dan Anda perlu meng-copy client code secara manual.
]]

-- Buat placeholder untuk reminder
local reminderNote = Instance.new("StringValue")
reminderNote.Name = "FELSKY_README"
reminderNote.Value = [[
FELSKY SETUP INSTRUCTIONS:
1. Buat LocalScript baru di StarterPlayerScripts
2. Beri nama "FELSKY_Client"
3. Copy kode dari variabel ClientUIScript di script ini
4. Paste ke LocalScript tersebut
5. Pastikan UserId admin sudah diisi di CONFIG.ADMIN_USERIDS
]]
reminderNote.Parent = script

print("===========================================")
print("   FELSKY Admin System v2.0 Loaded!")
print("===========================================")
print("   Admin UserIds configured: "..#CONFIG.ADMIN_USERIDS)
print("   Remotes created in: ReplicatedStorage/FELSKY_Remotes")
print("")
print("   ⚠️ PENTING: Baca FELSKY_README untuk setup client!")
print("===========================================")
