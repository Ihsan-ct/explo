-- ==================================================
-- MAP RIPPER V4.7 - COPY MAP ONLY
-- BY: Y.O.U (OPTIMIZED FOR XENO)
-- FITUR: Copy Map + Scripts + Assets + Rebuild Ready
-- ==================================================

local MapRipper = {
    Version = "4.7 COPY",
    Author = "Y.O.U",
    BypassEnabled = true,
    AssetCache = {},
    TotalObjects = 0
}

-- ==================================================
-- SERVICE INIT
-- ==================================================
local Services = {
    Players = game:GetService("Players"),
    Workspace = game:GetService("Workspace"),
    HttpService = game:GetService("HttpService"),
    InsertService = game:GetService("InsertService"),
    Lighting = game:GetService("Lighting"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    ServerStorage = game:GetService("ServerStorage"),
    ServerScriptService = game:GetService("ServerScriptService")
}

local Player = Services.Players.LocalPlayer

-- ==================================================
-- BYPASS BYFRON (XENO SPECIFIC)
-- ==================================================
local function BypassAntiCheat()
    local mt = getrawmetatable and getrawmetatable(game) or debug.getmetatable(game)
    if not mt then return end
    
    setreadonly(mt, false)
    local old_namecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "Shutdown" then return end
        return old_namecall(self, ...)
    end)
    setreadonly(mt, true)
    print("[✓] Bypass aktif")
end

-- ==================================================
-- GET ALL OBJECTS (CEPAT)
-- ==================================================
local function GetAllObjects()
    local objects = {}
    local scanned = {}
    
    local function scan(container, path)
        if not container or scanned[container] then return end
        scanned[container] = true
        
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("Folder") or 
               obj:IsA("Tool") or obj:IsA("Script") or obj:IsA("LocalScript") or 
               obj:IsA("ModuleScript") then
                
                table.insert(objects, {
                    Obj = obj,
                    Path = path .. "." .. obj.Name,
                    Class = obj.ClassName
                })
                MapRipper.TotalObjects = MapRipper.TotalObjects + 1
            end
            scan(obj, path .. "." .. obj.Name)
        end
    end
    
    -- Scan semua lokasi penting
    scan(Services.Workspace, "Workspace")
    scan(Services.ReplicatedStorage, "ReplicatedStorage")
    scan(Services.ServerStorage, "ServerStorage")
    scan(Services.ServerScriptService, "ServerScriptService")
    
    return objects
end

-- ==================================================
-- EXTRACT PROPERTIES LENGKAP
-- ==================================================
local function ExtractProperties(instance)
    if not instance then return {} end
    
    local props = {
        ClassName = instance.ClassName,
        Name = instance.Name,
        Properties = {}
    }
    
    pcall(function()
        -- BASE PART
        if instance:IsA("BasePart") then
            props.Properties = {
                Position = {instance.Position.X, instance.Position.Y, instance.Position.Z},
                Size = {instance.Size.X, instance.Size.Y, instance.Size.Z},
                CFrame = {
                    instance.CFrame.X, instance.CFrame.Y, instance.CFrame.Z,
                    instance.CFrame:ToEulerAnglesXYZ()
                },
                Color = {instance.Color.R, instance.Color.G, instance.Color.B},
                Transparency = instance.Transparency,
                Reflectance = instance.Reflectance,
                Material = instance.Material.Name,
                Shape = instance.Shape.Name,
                Anchored = instance.Anchored,
                CanCollide = instance.CanCollide,
                Locked = instance.Locked
            }
        end
        
        -- DECAL / TEXTURE
        if instance:IsA("Decal") or instance:IsA("Texture") then
            props.Properties.Texture = instance.Texture
            props.Properties.Face = instance.Face.Name
        end
        
        -- MESH
        if instance:IsA("SpecialMesh") then
            props.Properties.MeshType = instance.MeshType.Name
            props.Properties.MeshId = instance.MeshId
            props.Properties.TextureId = instance.TextureId
            props.Properties.Scale = {instance.Scale.X, instance.Scale.Y, instance.Scale.Z}
        end
        
        -- SCRIPT
        if instance:IsA("Script") or instance:IsA("LocalScript") or instance:IsA("ModuleScript") then
            props.Properties.Source = instance.Source
            props.Properties.Enabled = instance.Enabled
            props.Properties.RunContext = instance.RunContext and instance.RunContext.Name
        end
        
        -- HUMAN
        if instance:IsA("Humanoid") then
            props.Properties.MaxHealth = instance.MaxHealth
            props.Properties.Health = instance.Health
            props.Properties.WalkSpeed = instance.WalkSpeed
            props.Properties.JumpPower = instance.JumpPower
            props.Properties.RigType = instance.RigType.Name
        end
        
        -- SOUND
        if instance:IsA("Sound") then
            props.Properties.SoundId = instance.SoundId
            props.Properties.Volume = instance.Volume
            props.Properties.Pitch = instance.Pitch
            props.Properties.Looped = instance.Looped
        end
        
        -- LIGHT
        if instance:IsA("PointLight") or instance:IsA("SpotLight") or instance:IsA("SurfaceLight") then
            props.Properties.Brightness = instance.Brightness
            props.Properties.Color = {instance.Color.R, instance.Color.G, instance.Color.B}
            props.Properties.Range = instance.Range
            props.Properties.Shadows = instance.Shadows
        end
        
        -- WELD / CONSTRAINT
        if instance:IsA("Weld") or instance:IsA("Snap") then
            props.Properties.Part0 = instance.Part0 and instance.Part0.Name
            props.Properties.Part1 = instance.Part1 and instance.Part1.Name
            props.Properties.C0 = instance.C0 and {instance.C0:components()}
            props.Properties.C1 = instance.C1 and {instance.C1:components()}
        end
        
        -- GUI
        if instance:IsA("Frame") or instance:IsA("TextLabel") or instance:IsA("ImageLabel") then
            props.Properties.Size = {instance.Size.X.Offset, instance.Size.Y.Offset}
            props.Properties.Position = {instance.Position.X.Offset, instance.Position.Y.Offset}
            props.Properties.BackgroundColor = {instance.BackgroundColor3.R, instance.BackgroundColor3.G, instance.BackgroundColor3.B}
            props.Properties.BackgroundTransparency = instance.BackgroundTransparency
            props.Properties.Visible = instance.Visible
            
            if instance:IsA("TextLabel") then
                props.Properties.Text = instance.Text
                props.Properties.TextColor = {instance.TextColor3.R, instance.TextColor3.G, instance.TextColor3.B}
                props.Properties.TextSize = instance.TextSize
                props.Properties.Font = instance.Font.Name
            end
            
            if instance:IsA("ImageLabel") then
                props.Properties.Image = instance.Image
            end
        end
    end)
    
    -- Kumpulin child objects
    props.Children = {}
    for _, child in pairs(instance:GetChildren()) do
        if not child:IsA("BasePart") and not child:IsA("Model") then
            table.insert(props.Children, ExtractProperties(child))
        end
    end
    
    return props
end

-- ==================================================
-- PROCESS LIGHTING
-- ==================================================
local function GetLightingData()
    local l = Services.Lighting
    return {
        Ambient = {l.Ambient.R, l.Ambient.G, l.Ambient.B},
        Brightness = l.Brightness,
        ColorShift_Bottom = {l.ColorShift_Bottom.R, l.ColorShift_Bottom.G, l.ColorShift_Bottom.B},
        ColorShift_Top = {l.ColorShift_Top.R, l.ColorShift_Top.G, l.ColorShift_Top.B},
        ClockTime = l.ClockTime,
        FogColor = {l.FogColor.R, l.FogColor.G, l.FogColor.B},
        FogEnd = l.FogEnd,
        FogStart = l.FogStart,
        GlobalShadows = l.GlobalShadows,
        OutdoorAmbient = {l.OutdoorAmbient.R, l.OutdoorAmbient.G, l.OutdoorAmbient.B},
        ShadowSoftness = l.ShadowSoftness,
        Technology = l.Technology.Name
    }
end

-- ==================================================
-- PROCESS TERRAIN
-- ==================================================
local function GetTerrainData()
    local t = Services.Workspace.Terrain
    if not t then return {} end
    
    return {
        WaterColor = {t.WaterColor.R, t.WaterColor.G, t.WaterColor.B},
        WaterReflectance = t.WaterReflectance,
        WaterTransparency = t.WaterTransparency,
        WaterWaveSize = t.WaterWaveSize,
        WaterWaveSpeed = t.WaterWaveSpeed
    }
end

-- ==================================================
-- MAIN: COPY MAP
-- ==================================================
local function CopyMap()
    print("\n" .. string.rep("=", 60))
    print("MAP RIPPER V4.7 - MULAI COPY MAP")
    print(string.rep("=", 60))
    
    local mapData = {
        GameInfo = {
            Name = game.Name,
            PlaceId = game.PlaceId,
            GameId = game.GameId,
            Creator = tostring(game.Creator),
            Timestamp = os.time(),
            Date = os.date("%Y-%m-%d %H:%M:%S")
        },
        Lighting = GetLightingData(),
        Terrain = GetTerrainData(),
        Objects = {},
        Scripts = {}
    }
    
    print("[1/4] Scanning objects...")
    local objects = GetAllObjects()
    print("[✓] Ditemukan " .. #objects .. " objects")
    
    print("[2/4] Extracting properties...")
    for i, objData in ipairs(objects) do
        if i % 100 == 0 then print("  Progress: " .. i .. "/" .. #objects) end
        
        local objProps = ExtractProperties(objData.Obj)
        objProps.Path = objData.Path
        
        -- Pisahin script biar gampang dibaca
        if objData.Obj:IsA("Script") or objData.Obj:IsA("LocalScript") or objData.Obj:IsA("ModuleScript") then
            table.insert(mapData.Scripts, {
                Name = objData.Obj.Name,
                Class = objData.Obj.ClassName,
                Source = objData.Obj.Source,
                Path = objData.Path
            })
        else
            table.insert(mapData.Objects, objProps)
        end
        
        wait() -- Biar gak freeze
    end
    
    print("[3/4] Converting to JSON...")
    local jsonData = Services.HttpService:JSONEncode(mapData)
    
    print("[4/4] Output data...")
    print(string.rep("=", 60))
    print("COPY MAP SELESAI!")
    print("Total Objects: " .. #mapData.Objects)
    print("Total Scripts: " .. #mapData.Scripts)
    print("Data size: " .. string.format("%.2f", #jsonData / 1024) .. " KB")
    print(string.rep("=", 60))
    
    -- Output JSON (split biar gak kepotong)
    local chunkSize = 32000
    local chunks = math.ceil(#jsonData / chunkSize)
    
    print("\n--- MAP DATA START ---")
    for i = 1, chunks do
        local start = (i-1) * chunkSize + 1
        local finish = math.min(i * chunkSize, #jsonData)
        print(string.sub(jsonData, start, finish))
        if i < chunks then wait(0.2) end
    end
    print("--- MAP DATA END ---")
    
    print("\n" .. string.rep("=", 60))
    print("CARA PAKE HASILNYA:")
    print("1. Copy semua dari '--- MAP DATA START ---' sampe '--- MAP DATA END ---'")
    print("2. Simpan sebagai file .json")
    print("3. Buka pake notepad atau tools JSON viewer")
    print(string.rep("=", 60))
    
    return mapData
end

-- ==================================================
-- UI MINIMALIS
-- ==================================================
local function CreateUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MapRipperGUI"
    gui.Parent = Player:FindFirstChild("PlayerGui") or Services.CoreGui
    gui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 120)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "MAP RIPPER V4.7"
    title.TextColor3 = Color3.new(1, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = frame
    
    local btnCopy = Instance.new("TextButton")
    btnCopy.Size = UDim2.new(0.8, 0, 0, 35)
    btnCopy.Position = UDim2.new(0.1, 0, 0.4, 0)
    btnCopy.Text = "COPY MAP"
    btnCopy.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
    btnCopy.TextColor3 = Color3.new(1, 1, 1)
    btnCopy.Font = Enum.Font.Gotham
    btnCopy.TextSize = 14
    btnCopy.Parent = frame
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 25)
    status.Position = UDim2.new(0, 0, 0.8, 0)
    status.Text = "Ready"
    status.TextColor3 = Color3.new(0, 1, 0)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.Parent = frame
    
    btnCopy.MouseButton1Click:Connect(function()
        btnCopy.Text = "COPYING..."
        btnCopy.BackgroundColor3 = Color3.new(0.8, 0.4, 0)
        status.Text = "Processing..."
        
        spawn(function()
            local success, err = pcall(CopyMap)
            if success then
                status.Text = "Done!"
                btnCopy.Text = "✓ SUCCESS"
                btnCopy.BackgroundColor3 = Color3.new(0, 0.6, 0.2)
            else
                status.Text = "Error!"
                btnCopy.Text = "✗ FAILED"
                btnCopy.BackgroundColor3 = Color3.new(0.8, 0, 0)
                warn("Error: " .. tostring(err))
            end
        end)
    end)
end

-- ==================================================
-- START
-- ==================================================
print([[


    ╔══════════════════════════════════════════╗
    ║     MAP RIPPER V4.7 - COPY MAP ONLY      ║
    ║         BY: Y.O.U - XENO EDITION         ║
    ╚══════════════════════════════════════════╝
]])

-- Bypass
if MapRipper.BypassEnabled then
    pcall(BypassAntiCheat)
end

-- Menu
print("\n[?] PILIH:")
print("1. COPY MAP (LANGSUNG)")
print("2. COPY MAP + UI")

local choice = nil
for i = 1, 20 do
    pcall(function() 
        if read then choice = read() end
    end)
    if choice then break end
    wait(0.5)
end

if choice == "1" then
    CopyMap()
elseif choice == "2" then
    CreateUI()
    CopyMap()
else
    print("[!] Auto-start COPY MAP dalam 3 detik...")
    wait(3)
    CopyMap()
end

print("\n[SYSTEM] Y.O.U OUT - HORMATI 10 RIBU MAYA")
