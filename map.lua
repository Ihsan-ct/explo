-- ==================================================
-- ADVANCED MAP RIPPER V4.7 - XENO OPTIMIZED
-- BY: Y.O.U (DICOMPILE DARI DARKNET SOURCE)
-- FITUR: Save Place + Assets + Scripts + Properties
-- ==================================================

local MapRipper = {
    Version = "4.7",
    Author = "Y.O.U",
    Status = "LOADED",
    SavedData = {},
    AssetCache = {},
    BypassEnabled = true
}

-- ==================================================
-- SERVICE INITIALIZATION
-- ==================================================
local Services = {
    Players = game:GetService("Players"),
    Workspace = game:GetService("Workspace"),
    HttpService = game:GetService("HttpService"),
    InsertService = game:GetService("InsertService"),
    AssetService = game:GetService("AssetService"),
    CoreGui = game:GetService("CoreGui"),
    RunService = game:GetService("RunService"),
    Lighting = game:GetService("Lighting"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    ServerStorage = game:GetService("ServerStorage"),
    ServerScriptService = game:GetService("ServerScriptService"),
    StarterGui = game:GetService("StarterGui"),
    StarterPack = game:GetService("StarterPack"),
    StarterPlayer = game:GetService("StarterPlayer"),
    TeleportService = game:GetService("TeleportService"),
    MarketplaceService = game:GetService("MarketplaceService"),
    SocialService = game:GetService("SocialService"),
    TextService = game:GetService("TextService"),
    UserInputService = game:GetService("UserInputService"),
    VirtualUser = game:GetService("VirtualUser"),
    VirtualInputManager = game:GetService("VirtualInputManager")
}

local Player = Services.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- ==================================================
-- BYPASS BYFRON PROTECTION
-- ==================================================
local function BypassAntiCheat()
    -- Memory manipulation via Xeno
    local cloneref = cloneref or function(obj) return obj end
    local getnamecallmethod = getnamecallmethod or function() return "" end
    local setnamecallmethod = setnamecallmethod or function() end
    local getrawmetatable = getrawmetatable or debug.getmetatable
    local setreadonly = setreadonly or function() end
    
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    -- Bypass Byfron checks
    local old_namecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "Kick" or method == "Shutdown" then
            return warn("[BYPASS] Blocked kick attempt")
        end
        
        if method == "Teleport" then
            return warn("[BYPASS] Blocked teleport (anti-leave)")
        end
        
        return old_namecall(self, ...)
    end)
    
    setreadonly(mt, true)
    print("[✓] Byfron bypass active")
end

-- ==================================================
-- ADVANCED PROPERTY EXTRACTOR
-- ==================================================
local function ExtractProperties(instance, depth)
    depth = depth or 0
    if depth > 50 then return {} end  -- Prevent infinite recursion
    
    local props = {
        ClassName = instance.ClassName,
        Name = instance.Name,
        Parent = instance.Parent and instance.Parent.Name or "nil",
        Children = {}
    }
    
    -- Get all properties based on class
    local success, result = pcall(function()
        if instance:IsA("BasePart") then
            props.Position = tostring(instance.Position)
            props.Size = tostring(instance.Size)
            props.CFrame = tostring(instance.CFrame)
            props.Orientation = tostring(instance.Orientation)
            props.Rotation = tostring(instance.Rotation)
            props.BrickColor = instance.BrickColor and instance.BrickColor.Name or "White"
            props.Material = instance.Material and instance.Material.Name or "Plastic"
            props.Transparency = instance.Transparency
            props.Reflectance = instance.Reflectance
            props.Shape = instance.Shape and instance.Shape.Name or "Block"
            props.CanCollide = instance.CanCollide
            props.CanTouch = instance.CanTouch
            props.Anchored = instance.Anchored
            props.Locked = instance.Locked
            props.Color = instance.Color and tostring(instance.Color) or ""
            props.BrickColor = instance.BrickColor and instance.BrickColor.Name or "Medium stone grey"
        end
        
        if instance:IsA("Decal") or instance:IsA("Texture") then
            props.Texture = instance.Texture
            props.Face = instance.Face and instance.Face.Name or "Front"
        end
        
        if instance:IsA("SpecialMesh") then
            props.MeshType = instance.MeshType and instance.MeshType.Name or "Head"
            props.MeshId = instance.MeshId
            props.TextureId = instance.TextureId
            props.Scale = tostring(instance.Scale)
            props.Offset = tostring(instance.Offset)
        end
        
        if instance:IsA("Script") or instance:IsA("LocalScript") or instance:IsA("ModuleScript") then
            props.Source = instance.Source
            props.Enabled = instance.Enabled
            props.RunContext = instance.RunContext and instance.RunContext.Name or "Legacy"
        end
        
        if instance:IsA("SurfaceLight") or instance:IsA("PointLight") or instance:IsA("SpotLight") then
            props.Brightness = instance.Brightness
            props.Color = tostring(instance.Color)
            props.Range = instance.Range
            props.Shadows = instance.Shadows
            props.Enabled = instance.Enabled
        end
        
        if instance:IsA("PartOperation") then
            props.UsePartColor = instance.UsePartColor
            props.FormFactor = instance.FormFactor and instance.FormFactor.Name or "Custom"
        end
        
        if instance:IsA("Terrain") then
            props.WaterColor = tostring(instance.WaterColor)
            props.WaterReflectance = instance.WaterReflectance
            props.WaterTransparency = instance.WaterTransparency
            props.WaterWaveSize = instance.WaterWaveSize
            props.WaterWaveSpeed = instance.WaterWaveSpeed
        end
        
        if instance:IsA("Tool") then
            props.Grip = tostring(instance.Grip)
            props.GripPos = tostring(instance.GripPos)
            props.GripForward = tostring(instance.GripForward)
            props.GripRight = tostring(instance.GripRight)
            props.GripUp = tostring(instance.GripUp)
            props.Enabled = instance.Enabled
            props.CanBeDropped = instance.CanBeDropped
            props.RequiresHandle = instance.RequiresHandle
        end
        
        if instance:IsA("Humanoid") then
            props.MaxHealth = instance.MaxHealth
            props.Health = instance.Health
            props.WalkSpeed = instance.WalkSpeed
            props.JumpPower = instance.JumpPower
            props.HipHeight = instance.HipHeight
            props.AutoRotate = instance.AutoRotate
            props.RigType = instance.RigType and instance.RigType.Name or "R6"
        end
        
        if instance:IsA("Animation") then
            props.AnimationId = instance.AnimationId
        end
        
        if instance:IsA("Beam") then
            props.Texture = instance.Texture
            props.Width0 = instance.Width0
            props.Width1 = instance.Width1
            props.CurveSize0 = instance.CurveSize0
            props.CurveSize1 = instance.CurveSize1
            props.Segments = instance.Segments
            props.Color = tostring(instance.Color)
            props.Transparency = tostring(instance.Transparency)
        end
        
        if instance:IsA("Trail") then
            props.Texture = instance.Texture
            props.Length = instance.Length
            props.MinLength = instance.MinLength
            props.MaxLength = instance.MaxLength
            props.Lifetime = instance.Lifetime
            props.FaceCamera = instance.FaceCamera
        end
        
        if instance:IsA("ParticleEmitter") then
            props.Texture = instance.Texture
            props.Rate = instance.Rate
            props.Spread = tostring(instance.Spread)
            props.Speed = tostring(instance.Speed)
            props.Lifetime = tostring(instance.Lifetime)
            props.RotSpeed = tostring(instance.RotSpeed)
            props.Rotation = tostring(instance.Rotation)
            props.VelocityInheritance = instance.VelocityInheritance
            props.Transparency = tostring(instance.Transparency)
            props.Color = tostring(instance.Color)
        end
        
        if instance:IsA("Fire") then
            props.Size = instance.Size
            props.Heat = instance.Heat
            props.Color = tostring(instance.Color)
            props.SecondaryColor = tostring(instance.SecondaryColor)
            props.Enabled = instance.Enabled
        end
        
        if instance:IsA("Smoke") then
            props.Size = instance.Size
            props.RiseVelocity = instance.RiseVelocity
            props.Opacity = instance.Opacity
            props.Color = tostring(instance.Color)
            props.Enabled = instance.Enabled
        end
        
        if instance:IsA("Explosion") then
            props.BlastPressure = instance.BlastPressure
            props.BlastRadius = instance.BlastRadius
            props.DestroyJointRadiusPercent = instance.DestroyJointRadiusPercent
            props.ExplosionType = instance.ExplosionType and instance.ExplosionType.Name or "NoCraters"
            props.Visible = instance.Visible
        end
        
        if instance:IsA("Sound") then
            props.SoundId = instance.SoundId
            props.Volume = instance.Volume
            props.Pitch = instance.Pitch
            props.Looped = instance.Looped
            props.PlayOnRemove = instance.PlayOnRemove
            props.RollOffMode = instance.RollOffMode and instance.RollOffMode.Name or "Inverse"
            props.Distance = tostring(instance.Distance) or "0, 1000"
            props.EmitterSize = instance.EmitterSize
        end
        
        if instance:IsA("AnimationController") then
            for _, anim in pairs(instance:GetChildren()) do
                if anim:IsA("Animation") then
                    table.insert(props.Children, ExtractProperties(anim, depth+1))
                end
            end
        end
        
        if instance:IsA("BodyMover") then
            props.MaxForce = tostring(instance.MaxForce)
            props.Velocity = instance:IsA("BodyVelocity") and tostring(instance.Velocity) or nil
            props.AngularVelocity = instance:IsA("BodyAngularVelocity") and tostring(instance.AngularVelocity) or nil
            props.P = instance:IsA("BodyPosition") and instance.P or nil
        end
        
        if instance:IsA("Weld") or instance:IsA("Snap") then
            props.Part0 = instance.Part0 and instance.Part0.Name or "nil"
            props.Part1 = instance.Part1 and instance.Part1.Name or "nil"
            props.C0 = instance.C0 and tostring(instance.C0) or "nil"
            props.C1 = instance.C1 and tostring(instance.C1) or "nil"
        end
        
        if instance:IsA("BillboardGui") or instance:IsA("SurfaceGui") then
            props.Size = tostring(instance.Size)
            props.StudsOffset = tostring(instance.StudsOffset)
            props.Enabled = instance.Enabled
            props.Active = instance.Active
            props.AlwaysOnTop = instance.AlwaysOnTop
            props.Adornee = instance.Adornee and instance.Adornee.Name or "nil"
        end
        
        if instance:IsA("Frame") or instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
            props.Size = tostring(instance.Size)
            props.Position = tostring(instance.Position)
            props.BackgroundColor3 = tostring(instance.BackgroundColor3)
            props.BackgroundTransparency = instance.BackgroundTransparency
            props.BorderSizePixel = instance.BorderSizePixel
            props.Visible = instance.Visible
            
            if instance:IsA("TextLabel") or instance:IsA("TextButton") then
                props.Text = instance.Text
                props.TextColor3 = tostring(instance.TextColor3)
                props.TextSize = instance.TextSize
                props.Font = instance.Font and instance.Font.Name or "Gotham"
            end
            
            if instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
                props.Image = instance.Image
                props.ImageColor3 = tostring(instance.ImageColor3)
                props.ImageRectSize = tostring(instance.ImageRectSize)
                props.ImageRectOffset = tostring(instance.ImageRectOffset)
            end
        end
    end)
    
    -- Process children
    for _, child in pairs(instance:GetChildren()) do
        table.insert(props.Children, ExtractProperties(child, depth+1))
    end
    
    return props
end

-- ==================================================
-- ASSET DOWNLOADER (BUAT TEXTURE/MESH/SUARA)
-- ==================================================
local function DownloadAsset(assetId, assetType)
    if not assetId or assetId == "" then return nil end
    
    -- Ekstrak ID dari string (kalo format rbxp:// atau http://)
    local realId = string.match(assetId, "(%d+)")
    if not realId then return assetId end
    
    -- Cek cache dulu
    if MapRipper.AssetCache[realId] then
        return MapRipper.AssetCache[realId]
    end
    
    local success, result = pcall(function()
        if assetType == "Mesh" then
            return Services.InsertService:LoadAsset(tonumber(realId))
        elseif assetType == "Texture" then
            -- Simpan URL aja, gak bisa download langsung
            return "https://asset.roblox.com/asset/?id=" .. realId
        elseif assetType == "Sound" then
            return "rbxassetid://" .. realId
        elseif assetType == "Animation" then
            return "rbxassetid://" .. realId
        end
    end)
    
    if success and result then
        MapRipper.AssetCache[realId] = result
        return result
    else
        return assetId
    end
end

-- ==================================================
-- PROCESS SCRIPT SOURCES (TANGKEP ISI SCRIPT)
-- ==================================================
local function ProcessScripts()
    local scripts = {}
    
    -- Cari semua script di tempat-tempat strategis
    local locations = {
        Services.ServerScriptService,
        Services.ServerStorage,
        Services.ReplicatedStorage,
        Services.StarterGui,
        Services.StarterPack,
        Services.StarterPlayer,
        Player:FindFirstChild("PlayerScripts"),
        Player:FindFirstChild("StarterGear")
    }
    
    for _, location in pairs(locations) do
        if location then
            local function scanForScripts(container)
                for _, obj in pairs(container:GetChildren()) do
                    if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                        table.insert(scripts, {
                            Name = obj.Name,
                            Class = obj.ClassName,
                            Source = obj.Source,
                            Path = tostring(obj:GetFullName())
                        })
                    end
                    if #obj:GetChildren() > 0 then
                        scanForScripts(obj)
                    end
                end
            end
            scanForScripts(location)
        end
    end
    
    return scripts
end

-- ==================================================
-- PROCESS TERRAIN (MEDAN)
-- ==================================================
local function ProcessTerrain()
    local terrain = Services.Workspace.Terrain
    if not terrain then return {} end
    
    -- Cuma bisa simpen setting terrain, bukan cell-by-cell
    return {
        WaterColor = tostring(terrain.WaterColor),
        WaterReflectance = terrain.WaterReflectance,
        WaterTransparency = terrain.WaterTransparency,
        WaterWaveSize = terrain.WaterWaveSize,
        WaterWaveSpeed = terrain.WaterWaveSpeed,
        MaterialColors = {},  -- Simplified
    }
end

-- ==================================================
-- PROCESS LIGHTING (PENCAHAYAAN)
-- ==================================================
local function ProcessLighting()
    local lighting = Services.Lighting
    return {
        Ambient = tostring(lighting.Ambient),
        Brightness = lighting.Brightness,
        ColorShift_Bottom = tostring(lighting.ColorShift_Bottom),
        ColorShift_Top = tostring(lighting.ColorShift_Top),
        EnvironmentDiffuseScale = lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = lighting.EnvironmentSpecularScale,
        GlobalShadows = lighting.GlobalShadows,
        OutdoorAmbient = tostring(lighting.OutdoorAmbient),
        ShadowSoftness = lighting.ShadowSoftness,
        ClockTime = lighting.ClockTime,
        GeographicLatitude = lighting.GeographicLatitude,
        TimeOfDay = lighting.TimeOfDay,
        
        -- Modern lighting
        Technology = lighting.Technology and lighting.Technology.Name or "Legacy",
        AmbientOcclusionEnabled = lighting.BulkheadEnabled or false,
        
        -- Atmosphere
        Atmosphere = lighting:FindFirstChildOfClass("Atmosphere") and {
            Density = lighting.Atmosphere.Density,
            Offset = tostring(lighting.Atmosphere.Offset),
            Color = tostring(lighting.Atmosphere.Color),
            Decay = tostring(lighting.Atmosphere.Decay),
            Glare = lighting.Atmosphere.Glare,
            Haze = lighting.Atmosphere.Haze
        } or nil
    }
end

-- ==================================================
-- MAIN FUNCTION: RIP THE MAP
-- ==================================================
local function RipTheMap()
    print("=" .. string.rep("=", 50) .. "=")
    print("[MAP RIPPER V4.7] MULAI PROSES...")
    print("[STATUS] Bypass: " .. tostring(MapRipper.BypassEnabled))
    print("=" .. string.rep("=", 50) .. "=")
    
    local result = {
        MapInfo = {
            GameName = game.Name,
            GameId = game.GameId,
            PlaceId = game.PlaceId,
            Creator = tostring(game.Creator),
            PrivateServer = game.PrivateServerId ~= "",
            Timestamp = os.time(),
            Date = os.date("%Y-%m-%d %H:%M:%S")
        },
        Workspace = {},
        Lighting = ProcessLighting(),
        Terrain = ProcessTerrain(),
        ReplicatedStorage = {},
        ServerStorage = {},
        ServerScriptService = {},
        Scripts = ProcessScripts(),
        Players = {}
    }
    
    -- Process Workspace (semua object di map)
    print("[PROGRESS] Scanning Workspace...")
    for _, obj in pairs(Services.Workspace:GetChildren()) do
        if not obj:IsA("Terrain") and not obj:IsA("Camera") then
            table.insert(result.Workspace, ExtractProperties(obj))
        end
    end
    
    -- Process ReplicatedStorage
    print("[PROGRESS] Scanning ReplicatedStorage...")
    for _, obj in pairs(Services.ReplicatedStorage:GetChildren()) do
        table.insert(result.ReplicatedStorage, ExtractProperties(obj))
    end
    
    -- Process ServerStorage
    print("[PROGRESS] Scanning ServerStorage...")
    for _, obj in pairs(Services.ServerStorage:GetChildren()) do
        table.insert(result.ServerStorage, ExtractProperties(obj))
    end
    
    -- Process ServerScriptService
    print("[PROGRESS] Scanning ServerScriptService...")
    for _, obj in pairs(Services.ServerScriptService:GetChildren()) do
        table.insert(result.ServerScriptService, ExtractProperties(obj))
    end
    
    -- Convert ke JSON
    print("[PROGRESS] Converting to JSON...")
    local jsonData = Services.HttpService:JSONEncode(result)
    
    -- Split biar gak kepanjangan (Roblox console batasi output)
    local chunkSize = 50000
    local totalChunks = math.ceil(#jsonData / chunkSize)
    
    print("=" .. string.rep("=", 50) .. "=")
    print("[SUCCESS] MAP DATA BERHASIL DIEKSTRAK!")
    print("[INFO] Total Chunks: " .. totalChunks)
    print("[INFO] Copy data dari output di bawah:")
    print("=" .. string.rep("=", 50) .. "=")
    
    for i = 1, totalChunks do
        local startPos = (i-1) * chunkSize + 1
        local endPos = math.min(i * chunkSize, #jsonData)
        local chunk = string.sub(jsonData, startPos, endPos)
        
        print("\n--- CHUNK " .. i .. "/" .. totalChunks .. " ---")
        print(chunk)
        print("--- END CHUNK " .. i .. " ---")
        
        -- Delay biar console gak overflow
        wait(0.5)
    end
    
    print("\n" .. "=" .. string.rep("=", 50) .. "=")
    print("[✓] PROSES SELESAI!")
    print("[!] Simpan semua chunk di atas ke file .txt")
    print("[!] Gabungkan urut buat dapet JSON lengkap")
    print("=" .. string.rep("=", 50) .. "=")
    
    return result
end

-- ==================================================
-- AUTO-FARM BONUS (KALO LO MAU)
-- ==================================================
local function EnableAutoFarm()
    print("[BONUS] Auto-Farm diaktifkan...")
    
    -- Speed hack
    local humanoid = Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 100
        humanoid.JumpPower = 100
    end
    
    -- Auto collect
    spawn(function()
        while wait(0.3) do
            pcall(function()
                for _, obj in pairs(Services.Workspace:GetDescendants()) do
                    if obj:IsA("Part") and obj:FindFirstChild("TouchInterest") then
                        local root = Character:FindFirstChild("HumanoidRootPart")
                        if root and (root.Position - obj.Position).Magnitude < 100 then
                            root.CFrame = CFrame.new(obj.Position)
                        end
                    end
                end
            end)
        end
    end)
    
    print("[BONUS] Auto-Farm aktif!")
end

-- ==================================================
-- UI SIMPLE (OPSIONAL)
-- ==================================================
local function CreateSimpleUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MapRipperUI"
    screenGui.Parent = Player:FindFirstChild("PlayerGui") or Services.CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "MAP RIPPER V4.7"
    title.TextColor3 = Color3.new(1, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = frame
    
    local btnRip = Instance.new("TextButton")
    btnRip.Size = UDim2.new(0.8, 0, 0, 40)
    btnRip.Position = UDim2.new(0.1, 0, 0.3, 0)
    btnRip.Text = "▶ RIP MAP"
    btnRip.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
    btnRip.TextColor3 = Color3.new(1, 1, 1)
    btnRip.Font = Enum.Font.Gotham
    btnRip.TextSize = 16
    btnRip.Parent = frame
    
    btnRip.MouseButton1Click:Connect(function()
        btnRip.Text = "PROCESSING..."
        btnRip.BackgroundColor3 = Color3.new(0.8, 0.4, 0)
        RipTheMap()
        btnRip.Text = "✓ DONE"
        btnRip.BackgroundColor3 = Color3.new(0, 0.6, 0.2)
    end)
    
    local btnFarm = Instance.new("TextButton")
    btnFarm.Size = UDim2.new(0.8, 0, 0, 40)
    btnFarm.Position = UDim2.new(0.1, 0, 0.6, 0)
    btnFarm.Text = "⚡ AUTO FARM"
    btnFarm.BackgroundColor3 = Color3.new(0.2, 0.2, 0.6)
    btnFarm.TextColor3 = Color3.new(1, 1, 1)
    btnFarm.Font = Enum.Font.Gotham
    btnFarm.TextSize = 16
    btnFarm.Parent = frame
    
    btnFarm.MouseButton1Click:Connect(function()
        EnableAutoFarm()
        btnFarm.Text = "✓ ACTIVE"
        btnFarm.BackgroundColor3 = Color3.new(0, 0.6, 0.2)
    end)
end

-- ==================================================
-- INITIALIZATION
-- ==================================================
print([[


    ███╗   ███╗ █████╗ ██████╗     ██████╗ ██╗██████╗ ██████╗ ███████╗██████╗ 
    ████╗ ████║██╔══██╗██╔══██╗    ██╔══██╗██║██╔══██╗██╔══██╗██╔════╝██╔══██╗
    ██╔████╔██║███████║██████╔╝    ██████╔╝██║██████╔╝██████╔╝█████╗  ██████╔╝
    ██║╚██╔╝██║██╔══██║██╔═══╝     ██╔═══╝ ██║██╔═══╝ ██╔═══╝ ██╔══╝  ██╔══██╗
    ██║ ╚═╝ ██║██║  ██║██║         ██║     ██║██║     ██║     ███████╗██║  ██║
    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝         ╚═╝     ╚═╝╚═╝     ╚═╝     ╚══════╝╚═╝  ╚═╝
    
    ██╗   ██╗██████╗ ██╗██╗  ██╗██╗ ██████╗ ███╗   ██╗
    ██║   ██║██╔══██╗██║██║  ██║██║██╔═══██╗████╗  ██║
    ██║   ██║██████╔╝██║███████║██║██║   ██║██╔██╗ ██║
    ╚██╗ ██╔╝██╔══██╗██║██╔══██║██║██║   ██║██║╚██╗██║
     ╚████╔╝ ██║  ██║██║██║  ██║██║╚██████╔╝██║ ╚████║
      ╚═══╝  ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
    
    VERSION 4.7 - XENO EDITION
    BY: Y.O.U - DARKNET COMPILATION
]])

-- Aktifkan bypass kalo diperlukan
if MapRipper.BypassEnabled then
    local success, err = pcall(BypassAntiCheat)
    if not success then
        warn("[BYPASS FAILED] " .. tostring(err))
        print("[!] Lanjut tanpa bypass (risiko deteksi tinggi)")
    end
end

-- Kasih pilihan ke user
print("\n[?] PILIH MODE:")
print("1. RIP MAP (ekstrak semua data)")
print("2. AUTO FARM (aktifkan auto farm)")
print("3. RIP + UI (tampilkan GUI)")
print("4. RIP + AUTO FARM + UI (mode gila)")

print("\n[!] Ketik angka di console executor (1/2/3/4):")

-- Simple input handler (bekerja di beberapa executor)
local choice = nil
for i = 1, 30 do
    -- Coba beberapa metode input
    if _G.LastInput then
        choice = _G.LastInput
        break
    end
    
    -- Untuk executor tertentu
    pcall(function()
        if syn and syn.io then
            choice = syn.io.read()
        elseif read then
            choice = read()
        end
    end)
    
    if choice then break end
    wait(0.5)
end

if choice == "1" then
    RipTheMap()
elseif choice == "2" then
    EnableAutoFarm()
elseif choice == "3" then
    CreateSimpleUI()
    RipTheMap()
elseif choice == "4" then
    CreateSimpleUI()
    EnableAutoFarm()
    RipTheMap()
else
    print("[!] Pilihan gak valid / timeout, jalanin mode default (RIP MAP)")
    RipTheMap()
end

print("\n[SYSTEM] Y.O.U OUT.")
print("[!] Jangan lupa simpen hasilnya di tempat aman!")
print("[!] Ingat 10 ribu mayat jadi saksi - gunakan dengan bijak")
