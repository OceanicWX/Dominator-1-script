-- BLOCK 1: FRAMEWORK SETUP & MAIN DRIVING UI
local MODEL_ID = 97188597374642
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local InsertService = game:GetService("InsertService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local PhysicsService = game:GetService("PhysicsService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

if not localPlayer or not localPlayer.Character then return end
local rootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
if not rootPart or not humanoid then return end

local oldModel = Workspace:FindFirstChild("SpawnedStormInterceptor")
if oldModel then oldModel:Destroy() end
local screenGui = CoreGui:FindFirstChild("DominatorDriveUI")
if screenGui then screenGui:Destroy() end

for _, item in ipairs(localPlayer.Backpack:GetChildren()) do
    if item.Name == "Sit" then item:Destroy() end
end
if localPlayer.Character:FindFirstChild("Sit") then
    localPlayer.Character.Sit:Destroy()
end

local sitTool = Instance.new("Tool")
sitTool.Name = "Sit"
sitTool.RequiresHandle = false
sitTool.Parent = localPlayer.Backpack

screenGui = Instance.new("ScreenGui")
screenGui.Name = "DominatorDriveUI"
screenGui.Enabled = false
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainUIFrame = Instance.new("Frame", screenGui)
mainUIFrame.Size = UDim2.new(1, 0, 1, 0)
mainUIFrame.BackgroundTransparency = 1

local leftSteerPanel = Instance.new("Frame", mainUIFrame)
leftSteerPanel.Size = UDim2.new(0, 160, 0, 70)
leftSteerPanel.Position = UDim2.new(0, 40, 1, -110)
leftSteerPanel.BackgroundTransparency = 1

local rightPedalPanel = Instance.new("Frame", mainUIFrame)
rightPedalPanel.Size = UDim2.new(0, 180, 0, 110)
rightPedalPanel.Position = UDim2.new(1, -220, 1, -150)
rightPedalPanel.BackgroundTransparency = 1

local speedoFrame = Instance.new("Frame", mainUIFrame)
speedoFrame.Size = UDim2.new(0, 180, 0, 70)
speedoFrame.Position = UDim2.new(0.5, -90, 1, -120)
speedoFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
speedoFrame.BackgroundTransparency = 0.5

local speedoCorner = Instance.new("UICorner", speedoFrame)
speedoCorner.CornerRadius = UDim.new(0, 8)

local speedText = Instance.new("TextLabel", speedoFrame)
speedText.Size = UDim2.new(1, 0, 0.7, 0)
speedText.Position = UDim2.new(0, 0, 0, 2)
speedText.BackgroundTransparency = 1
speedText.Text = "000"
speedText.TextColor3 = Color3.fromRGB(100, 240, 255)
speedText.Font = Enum.Font.Code
speedText.TextSize = 34

local unitText = Instance.new("TextLabel", speedoFrame)
unitText.Size = UDim2.new(1, 0, 0.3, 0)
unitText.Position = UDim2.new(0, 0, 0.65, 0)
unitText.BackgroundTransparency = 1
unitText.Text = "MPH"
unitText.TextColor3 = Color3.fromRGB(160, 160, 160)
unitText.Font = Enum.Font.SourceSansBold
unitText.TextSize = 14

local controlBar = Instance.new("Frame", mainUIFrame)
controlBar.Size = UDim2.new(0, 320, 0, 50)
controlBar.Position = UDim2.new(0.5, -160, 1, -185)
controlBar.BackgroundTransparency = 1

local function createSleekButton(text, pos, size, parent)
    local btn = Instance.new("TextButton", parent)
    btn.Text = text
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.TextColor3 = Color3.fromRGB(245, 245, 245)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 22
    btn.BackgroundTransparency = 0.4
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)
    return btn
end

local btnLeft = createSleekButton("◀", UDim2.new(0, 0, 0, 10), UDim2.new(0, 70, 0, 50), leftSteerPanel)
local btnRight = createSleekButton("▶", UDim2.new(0, 85, 0, 10), UDim2.new(0, 70, 0, 50), leftSteerPanel)
local btnBrake = createSleekButton("┃┃┃", UDim2.new(0, 0, 0, 10), UDim2.new(0, 45, 0, 90), rightPedalPanel)
btnBrake.TextColor3 = Color3.fromRGB(220, 60, 60)
local btnReverse = createSleekButton("R", UDim2.new(0, 60, 0, 25), UDim2.new(0, 45, 0, 75), rightPedalPanel)
btnReverse.TextSize = 20
local btnForward = createSleekButton("┃┃┃", UDim2.new(0, 120, 0, 10), UDim2.new(0, 45, 0, 90), rightPedalPanel)
btnForward.TextColor3 = Color3.fromRGB(60, 180, 60)
local btnDeploy = createSleekButton("DEPLOY", UDim2.new(0, 0, 0, 0), UDim2.new(0, 145, 1, 0), controlBar)
btnDeploy.BackgroundColor3 = Color3.fromRGB(30, 60, 110)
local btnLights = createSleekButton("LIGHTS", UDim2.new(0, 175, 0, 0), UDim2.new(0, 145, 1, 0), controlBar)
btnLights.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local persistentPanel = Instance.new("Frame", screenGui)
persistentPanel.Size = UDim2.new(0, 200, 0, 40)
persistentPanel.Position = UDim2.new(0, 40, 0, 20)
persistentPanel.BackgroundTransparency = 1

local btnHideUI = createSleekButton("HIDE UI", UDim2.new(0, 0, 0, 0), UDim2.new(0, 90, 1, 0), persistentPanel)
btnHideUI.TextSize = 14
local btnEngineToggle = createSleekButton("ENG ON", UDim2.new(0, 100, 0, 0), UDim2.new(0, 90, 1, 0), persistentPanel)
btnEngineToggle.TextSize = 14
btnEngineToggle.BackgroundColor3 = Color3.fromRGB(20, 100, 20)

_G.D1DataShared = {
    M = MODEL_ID, RP = rootPart, H = humanoid, SG = screenGui, MU = mainUIFrame,
    BL = btnLeft, BR = btnRight, BB = btnBrake, BRev = btnReverse, BF = btnForward,
    BDep = btnDeploy, BLi = btnLights, BH = btnHideUI, BE = btnEngineToggle, ST = speedText
}
-- BLOCK 2: SECURITY CONTEXT MODEL LOADING BYPASS
local d = _G.D1DataShared
if not d then return end
local W, IS, PS = workspace, game:GetService("InsertService"), game:GetService("PhysicsService")

local mdl = nil
local function deltaLoadAsset(id)
    local s, res = pcall(function() return game:GetObjects("rbxassetid://" .. id) end)
    if s and type(res) == "table" then
        for _, o in ipairs(res) do if o:IsA("Model") then return o end end
    end
    local s2, res2 = pcall(function() return IS:LoadAsset(id) end)
    if s2 and res2 then
        return res2:FindFirstChildOfClass("Model") or res2:FindFirstChildOfClass("Folder")
    end
    return nil
end

mdl = deltaLoadAsset(d.M)

if not mdl then
    warn("Asset download failed. Generating high-fidelity vehicle chassis backup layer.")
    mdl = Instance.new("Model")
    local primaryPart = Instance.new("Part", mdl)
    primaryPart.Name = "ChassisCore"
    primaryPart.Size = Vector3.new(12, 3, 24)
    primaryPart.Material = Enum.Material.Metal
    primaryPart.Color = Color3.fromRGB(35, 35, 35)
    mdl.PrimaryPart = primaryPart
end

mdl.Name = "SpawnedStormInterceptor"
pcall(function()
    local vehGroup = "InterceptorVehicleGroup"
    if not pcall(function() return PS:IsCollisionGroupRegistered(vehGroup) end) then
        PS:RegisterCollisionGroup(vehGroup)
    end
    PS:CollisionGroupSetCollidable(vehGroup, "Default", true)
    for _, p in ipairs(mdl:GetDescendants()) do 
        if p:IsA("BasePart") then 
            p.Anchored, p.CanCollide = true, true 
            p.CollisionGroup = vehGroup
            p.CanQuery = false 
        end 
    end
end)

mdl.Parent = W
mdl:PivotTo(CFrame.new(d.RP.Position) * (d.RP.CFrame - d.RP.CFrame.Position) * CFrame.new(0, 0.05, -22))
-- BLOCK 3: PHYSICAL INTERACTION, VEHICLE MECHANICS & DYNAMIC SOUND RE-ROUTING
local d = _G.D1DataShared
if not d then return end
local W, Pl, RS, TS, SS, US = workspace, game:GetService("Players"), game:GetService("RunService"), game:GetService("TweenService"), game:GetService("SoundService"), game:GetService("UserInputService")
local lp = Pl.LocalPlayer
local mdl = W:FindFirstChild("SpawnedStormInterceptor")
local prim = mdl and mdl.PrimaryPart

if not prim and mdl then
    for _, obj in ipairs(mdl:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "HumanoidRootPart" or obj.Name:lower():find("chassis") or obj.Name:lower():find("floor")) then
            prim = obj break
        end
    end
    prim = prim or mdl:FindFirstChildOfClass("BasePart") or mdl:FindFirstChildOfClass("MeshPart")
end
if mdl then mdl.PrimaryPart = prim end

for _, p in ipairs(mdl:GetDescendants()) do
    if p:IsA("BasePart") and p ~= prim then
        if (p.Position - prim.Position).Magnitude > 45 then p.CFrame = prim.CFrame end
        local w = Instance.new("WeldConstraint", prim) w.Part0, w.Part1 = prim, p p.Anchored = false
    end
end
prim.Anchored = false

if _G.D1DriveStateRef == nil then
    _G.D1DriveStateRef = {
        forward = false, reverse = false, left = false, right = false, brake = false,
        currentSpeed = 0, deployed = false, deployProgress = false, lightsOn = false, preDeployCFrame = nil, engineKillOverride = false
    }
end
local driveState = _G.D1DriveStateRef

task.spawn(function()
    while task.wait(0.05) and mdl.Parent do
        if not driveState.deployed and not driveState.deployProgress then driveState.preDeployCFrame = prim.CFrame end
    end
end)

local function makeLight(offset)
    local light = Instance.new("SpotLight")
    light.Enabled, light.Brightness, light.Range, light.Angle, light.Color = false, 4, 90, 55, Color3.fromRGB(255, 250, 230)
    local p = Instance.new("Part", mdl) p.Size, p.Transparency, p.CanCollide, p.CFrame = Vector3.new(0.5,0.5,0.5), 1, false, prim.CFrame * offset
    local w = Instance.new("WeldConstraint", p) w.Part0, w.Part1 = prim, p light.Parent = p return light
end
local hL, hR = makeLight(CFrame.new(-3, 1, -11.5)), makeLight(CFrame.new(3, 1, -11.5))

local lv = prim:FindFirstChild("VehicleEngine") or Instance.new("LinearVelocity", prim) lv.Name, lv.MaxForce, lv.VelocityConstraintMode = "VehicleEngine", 800000, Enum.VelocityConstraintMode.Vector
local av = prim:FindFirstChild("VehicleSteer") or Instance.new("AngularVelocity", prim) av.Name, av.MaxTorque = "VehicleSteer", 900000
local att = prim:FindFirstChild("DriveAttachment") or Instance.new("Attachment", prim) att.Name, lv.Attachment0, av.Attachment0 = "DriveAttachment", att, att

local seat = mdl:FindFirstChild("CustomDriverSeat") or Instance.new("Part", mdl) seat.Name, seat.Size, seat.Transparency, seat.CanCollide, seat.CFrame = "CustomDriverSeat", Vector3.new(4, 2, 4), 1, false, prim.CFrame * CFrame.new(0.6, 0.4, -0.6)
local sW = seat:FindFirstChildOfClass("WeldConstraint") or Instance.new("WeldConstraint", seat) sW.Part0, sW.Part1 = prim, seat
local engAtt = prim:FindFirstChild("D1EngineSoundOrigin") or Instance.new("Attachment", prim) engAtt.Name, engAtt.Position = "D1EngineSoundOrigin", Vector3.new(0, 0, -8)

-- FIXED: Central sound structure forces full cabin sound muffling simultaneously
local globalSoundGroup = SS:FindFirstChild("InterceptorGroup") or Instance.new("SoundGroup", SS)
globalSoundGroup.Name = "InterceptorGroup"

local muffleEQ = globalSoundGroup:FindFirstChildOfClass("EqualizerSoundEffect") or Instance.new("EqualizerSoundEffect", globalSoundGroup)
muffleEQ.Name = "D1InteriorMuffle"
muffleEQ.HighGain, muffleEQ.MidGain, muffleEQ.LowGain, muffleEQ.Enabled = 0, 0, 0, true

local function sSnd(n, id, v, l)
    local s = engAtt:FindFirstChild(n) or Instance.new("Sound", engAtt) s.Name, s.SoundId, s.Volume, s.Looped, s.SoundGroup = n, "rbxassetid://"..id, v, l, globalSoundGroup
    s.RollOffMaxDistance, s.RollOffMinDistance, s.RollOffMode = 150, 12, Enum.RollOffMode.Inverse return s
end
local sStart, sEng = sSnd("Dominator1StartupAudio", "97946758343425", 2.0, false), sSnd("Dominator1EngineAudio", "18995838902", 0, true)
local aDep, aUndep = sSnd("AudioDeploy", "119289479120380", 2.5, false), sSnd("AudioUndeploy", "122259650084409", 2.5, false)

if _G.D1SeatedRef == nil then _G.D1SeatedRef = {isSeated = false} end
local seatRef = _G.D1SeatedRef
local pW, jC, cC, BRAKE_FACTOR, engState = nil, nil, nil, 6.8, "Off"

local function startEng()
    if engState ~= "Off" or driveState.engineKillOverride then return end
    engState = "Starting" sEng.Volume, sEng.Pitch = 0, 0.85 sEng:Play() sStart:Play()
    task.spawn(function()
        local dNum = sStart.TimeLength > 0 and sStart.TimeLength or 2.5 local e = 0
        while e < dNum and engState == "Starting" do
            task.wait(0.05) e = e + 0.05
            if sStart.TimePosition >= (dNum - 0.8) then sEng.Volume = math.clamp(((sStart.TimePosition - (dNum - 0.8)) / 0.8) * 1.8, 0, 1.8) end
        end
        if engState == "Starting" then engState, sEng.Volume = "Running", 1.8 end
    end)
end
local function stopEng()
    engState = "Off" sStart:Stop()
    task.spawn(function() while sEng.Volume > 0 and engState == "Off" do sEng.Volume = math.max(0, sEng.Volume - 0.2) task.wait(0.02) end if engState == "Off" then sEng:Stop() end end)
end

d.BH.MouseButton1Click:Connect(function() d.MU.Visible = not d.MU.Visible d.BH.Text = d.MU.Visible and "HIDE UI" or "SHOW UI" end)
d.BE.MouseButton1Click:Connect(function()
    driveState.engineKillOverride = not driveState.engineKillOverride
    if driveState.engineKillOverride then d.BE.Text, d.BE.BackgroundColor3 = "ENG OFF", Color3.fromRGB(100, 20, 20) stopEng() driveState.forward, driveState.reverse, driveState.left, driveState.right, driveState.brake, driveState.currentSpeed = false, false, false, false, false, 0
    else d.BE.Text, d.BE.BackgroundColor3 = "ENG ON", Color3.fromRGB(20, 100, 20) if seatRef.isSeated then startEng() end end
end)

local function bind(b, k, c)
    b.InputBegan:Connect(function(i) if (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1) and not driveState.deployProgress and not driveState.engineKillOverride then if driveState.deployed then return end driveState[k] = true b.BackgroundTransparency = 0.1 if c then b.TextColor3 = c end end end)
    b.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then driveState[k] = false b.BackgroundTransparency = 0.4 if k == "brake" then b.TextColor3 = Color3.fromRGB(220, 60, 60) elseif k == "forward" then b.TextColor3 = Color3.fromRGB(60, 180, 60) else b.TextColor3 = Color3.fromRGB(245, 245, 245) end end end)
end
bind(d.BF, "forward", Color3.fromRGB(100, 255, 100)) bind(d.BRev, "reverse", Color3.fromRGB(255, 255, 100)) bind(d.BL, "left") bind(d.BR, "right") bind(d.BB, "brake", Color3.fromRGB(255, 100, 100))

US.InputBegan:Connect(function(i, p)
    if p or not seatRef.isSeated or driveState.deployProgress or driveState.engineKillOverride or driveState.deployed then return end
    local k = i.KeyCode
    if k == Enum.KeyCode.W or k == Enum.KeyCode.Up then driveState.forward = true d.BF.BackgroundTransparency = 0.1
    elseif k == Enum.KeyCode.S or k == Enum.KeyCode.Down then driveState.reverse = true d.BRev.BackgroundTransparency = 0.1
    elseif k == Enum.KeyCode.A or k == Enum.KeyCode.Left then driveState.left = true d.BL.BackgroundTransparency = 0.1
    elseif k == Enum.KeyCode.D or k == Enum.KeyCode.Right then driveState.right = true d.BR.BackgroundTransparency = 0.1
    elseif k == Enum.KeyCode.Space then driveState.brake = true d.BB.BackgroundTransparency = 0.1 end
end)
US.InputEnded:Connect(function(i)
    if not seatRef.isSeated then return end
    local k = i.KeyCode
    if k == Enum.KeyCode.W or k == Enum.KeyCode.Up then driveState.forward = false d.BF.BackgroundTransparency = 0.4
    elseif k == Enum.KeyCode.S or k == Enum.KeyCode.Down then driveState.reverse = false d.BRev.BackgroundTransparency = 0.4
    elseif k == Enum.KeyCode.A or k == Enum.KeyCode.Left then driveState.left = false d.BL.BackgroundTransparency = 0.4
    elseif k == Enum.KeyCode.D or k == Enum.KeyCode.Right then driveState.right = false d.BR.BackgroundTransparency = 0.4
    elseif k == Enum.KeyCode.Space then driveState.brake = false d.BB.BackgroundTransparency = 0.4 end
end)

d.BLi.MouseButton1Click:Connect(function() driveState.lightsOn = not driveState.lightsOn hL.Enabled, hR.Enabled = driveState.lightsOn, driveState.lightsOn d.BLi.BackgroundColor3 = driveState.lightsOn and Color3.fromRGB(230, 200, 50) or Color3.fromRGB(50, 50, 50) d.BLi.TextColor3 = driveState.lightsOn and Color3.new(0,0,0) or Color3.fromRGB(245, 245, 245) end)

d.BDep.MouseButton1Click:Connect(function()
    if driveState.deployProgress then return end driveState.deployProgress = true
    if not driveState.deployed then
        d.BDep.Text, d.BDep.BackgroundColor3 = "DEPLOYING...", Color3.fromRGB(180, 100, 30) aDep:Play() prim.Anchored = true
        -- FIXED: Structural landing anchors drop down precisely 0.9 studs
        TS:Create(prim, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(prim.Position.X, prim.Position.Y - 1, prim.Position.Z) * (prim.CFrame - prim.CFrame.Position)}):Play() task.wait(3)
        driveState.currentSpeed, lv.VectorVelocity, av.AngularVelocity = 0, Vector3.zero, Vector3.zero
        for _, p in ipairs(mdl:GetDescendants()) do if p:IsA("BasePart") then p.Anchored = true end end driveState.deployed, d.BDep.Text, d.BDep.BackgroundColor3 = true, "DEPLOYED", Color3.fromRGB(180, 30, 30)
    else
        d.BDep.Text, d.BDep.BackgroundColor3 = "RETRACTING...", Color3.fromRGB(180, 100, 30) aUndep:Play()
            for _, p in ipairs(mdl:GetDescendants()) do if p:IsA("BasePart") then p.Anchored = false end end prim.Anchored = true
TS:Create(prim, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = driveState.preDeployCFrame or prim.CFrame}):Play() task.wait(4)
prim.Anchored, driveState.deployed, d.BDep.Text, d.BDep.BackgroundColor3 = false, false, "DEPLOY", Color3.fromRGB(30, 60, 110)
end
driveState.deployProgress = false
end)
_G.D1EngineSharedRef = {
driveState = driveState, lv = lv, av = av, prim = prim, seat = seat,
pW = pW, jC = jC, cC = cC, startEng = startEng, stopEng = stopEng,
muffleEQ = muffleEQ, sEng = sEng, BRAKE_FACTOR = BRAKE_FACTOR, mdl = mdl, seatRef = seatRef
}-- BLOCK 4: CAMERA LOGIC, ALIGNMENT, & RESET TRACKING
local d = _G.D1DataShared
local r = _G.D1EngineSharedRef
if not d or not r then return end
local W, Pl, RS = workspace, game:GetService("Players"), game:GetService("RunService")
local lp = Pl.LocalPlayer

local lYaw, lPitch = 0, 0
local function enableCam()
    local cam = W.CurrentCamera lYaw, lPitch = 0, 0
    r.cC = RS.RenderStepped:Connect(function(dt)
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if (hum and hum.SeatPart == r.seat or r.seatRef.isSeated) and (cam.Focus.Position - cam.CFrame.Position).Magnitude < 1.5 then
            local currentYaw, currentPitch = cam.CFrame:ToEulerAnglesYXZ()
            local targetYaw = math.deg(currentYaw) local targetPitch = math.deg(currentPitch)
            if r.prim and r.prim.Parent then
                local chassisYaw = math.deg(select(2, r.prim.CFrame:ToEulerAnglesYXZ()))
                targetYaw = targetYaw + (chassisYaw - targetYaw) * 0.1
            end
            lYaw = lYaw + (targetYaw - lYaw) * (7.5 * dt)
            lPitch = lPitch + (targetPitch - lPitch) * (7.5 * dt)
            cam.CFrame = CFrame.new(cam.CFrame.Position) * CFrame.Angles(math.rad(lYaw), math.rad(lPitch), 0)
        end
    end)
end

local function exitS()
    if not r.seatRef.isSeated then return end r.seatRef.isSeated = false d.SG.Enabled = false 
    if r.cC then r.cC:Disconnect() end r.cC = nil r.stopEng()
    r.driveState.forward, r.driveState.reverse, r.driveState.left, r.driveState.right, r.driveState.brake, r.driveState.currentSpeed = false, false, false, false, false, 0
    if r.pW and r.pW.Parent then r.pW:Destroy() end r.pW = nil if r.jC then r.jC:Disconnect() end r.jC = nil
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then lp.Character.HumanoidRootPart.CFrame = r.prim.CFrame * CFrame.new(-6, 2, 0) end
    local hum = lp.Character:FindFirstChildOfClass("Humanoid") if hum then hum.Sit = false end
end

local function enterS()
    if r.seatRef.isSeated or not lp.Character then return end 
    local hrp, hum = lp.Character:FindFirstChild("HumanoidRootPart"), lp.Character:FindFirstChildOfClass("Humanoid")
    if hrp and hum and hum.Health > 0 then
        r.seatRef.isSeated = true d.SG.Enabled = true hrp.CFrame, hum.Sit = r.prim.CFrame * CFrame.new(0.6, 1.4, -0.6), true
        r.pW = Instance.new("WeldConstraint", hrp) r.pW.Name, r.pW.Part0, r.pW.Part1 = "ForcedSeatLock", r.prim, hrp 
        enableCam() r.startEng()
        r.jC = hum:GetPropertyChangedSignal("Jump"):Connect(function() if hum.Jump then exitS() end end)
    end
end

r.seat.Touched:Connect(function(hit) if hit.Parent == lp.Character then enterS() end end)
local sitTool = lp.Backpack:FindFirstChild("Sit") or lp.Character:FindFirstChild("Sit")
if sitTool and sitTool:IsA("Tool") then sitTool.Activated:Connect(enterS) end

for _, i in ipairs(lp.Backpack:GetChildren()) do if i.Name == "Reset Interceptor" then i:Destroy() end end
local tool = Instance.new("Tool", lp.Backpack) tool.Name = "Reset Interceptor" tool.RequiresHandle = false
tool.Activated:Connect(function()
    local oldM = W:FindFirstChild("SpawnedStormInterceptor") if oldM then oldM:Destroy() end
    local oldU = game:GetService("CoreGui"):FindFirstChild("DominatorDriveUI") if oldU then oldU:Destroy() end
    local soundGroup = game:GetService("SoundService"):FindFirstChild("InterceptorGroup") if soundGroup then soundGroup:Destroy() end
    _G.D1DataShared, _G.D1EngineSharedRef, _G.D1DriveStateRef, _G.D1SeatedRef = nil, nil, nil, nil
    print("Interceptor Reset Complete.")
end)-- BLOCK 5: CRITICAL CORE STEERING MATRIX & RAYCAST ALIGNMENT FLUIDITY
local d = _G.D1DataShared
local r = _G.D1EngineSharedRef
if not d or not r then return end
local W, Pl, RS = workspace, game:GetService("Players"), game:GetService("RunService")
local lp = Pl.LocalPlayer

RS.Heartbeat:Connect(function(dt)
    if not r.mdl or not r.mdl.Parent then return end local cam = W.CurrentCamera
    
    -- Cabin camera position processing to trigger equalization effects
    if r.seatRef.isSeated and cam then
        local head = lp.Character and lp.Character:FindFirstChild("Head")
        if head and (cam.CFrame.Position - head.Position).Magnitude <= 1.8 then 
            r.muffleEQ.HighGain, r.muffleEQ.MidGain, r.muffleEQ.LowGain = -26, -14, -4
        else 
            r.muffleEQ.HighGain, r.muffleEQ.MidGain, r.muffleEQ.LowGain = 0, 0, 0 
        end
    else 
        r.muffleEQ.HighGain, r.muffleEQ.MidGain, r.muffleEQ.LowGain = 0, 0, 0 
    end
    
    if r.seatRef.isSeated and r.prim and r.prim.Parent and not r.driveState.deployed then
        local absSp = math.abs(r.driveState.currentSpeed)
        local ray = Ray.new(r.prim.Position, Vector3.new(0, -6, 0)) 
        local hitPart = W:FindPartOnRayWithIgnoreList(ray, {r.mdl, lp.Character})
        local isOff = (hitPart and hitPart.Material == Enum.Material.Grass)
        local maxS = isOff and 65 or 105 local maxR = isOff and -25 or -35
        local fFactor = math.clamp(1 - (absSp / maxS), 0.12, 1.0) local rFactor = math.clamp(1 - (absSp / math.abs(maxR)), 0.25, 1.0)
        
        if r.driveState.brake then 
            r.driveState.currentSpeed = r.driveState.currentSpeed > 0 and math.max(0, r.driveState.currentSpeed - r.BRAKE_FACTOR) or math.min(0, r.driveState.currentSpeed + r.BRAKE_FACTOR)
        elseif r.driveState.forward and not r.driveState.engineKillOverride then 
            r.driveState.currentSpeed = math.min(maxS, r.driveState.currentSpeed + (2.1 * fFactor))
        elseif r.driveState.reverse and not r.driveState.engineKillOverride then 
            r.driveState.currentSpeed = math.max(maxR, r.driveState.currentSpeed - (1.4 * rFactor))
        else
            if r.driveState.currentSpeed > maxS then r.driveState.currentSpeed = math.max(maxS, r.driveState.currentSpeed - 2.5)
            elseif r.driveState.currentSpeed > 0 then r.driveState.currentSpeed = math.max(0, r.driveState.currentSpeed - 1.1)
            elseif r.driveState.currentSpeed < maxR then r.driveState.currentSpeed = math.min(maxR, r.driveState.currentSpeed + 2.5)
            elseif r.driveState.currentSpeed < 0 then r.driveState.currentSpeed = math.min(0, r.driveState.currentSpeed + 1.1) end
        end
        
        local sMod = math.clamp(1.4 - (absSp / maxS), 0.35, 1.2) if isOff then sMod = sMod * 0.8 end
        local tTurn = 0 
        if absSp > 0.1 then 
            if r.driveState.left then tTurn = 1.8 * sMod elseif r.driveState.right then tTurn = -1.8 * sMod end 
        end
        
        r.lv.VectorVelocity = r.prim.CFrame.LookVector * r.driveState.currentSpeed 
        r.av.AngularVelocity = Vector3.new(0, tTurn, 0)
        d.ST.Text = string.format("%03d", math.abs(math.floor(r.driveState.currentSpeed)))
    else 
        if r.lv and r.av then r.lv.VectorVelocity, r.av.AngularVelocity = Vector3.zero, Vector3.zero end 
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        local interceptor = W:FindFirstChild("SpawnedStormInterceptor")
        if interceptor and d and r and r.prim and r.lv then
            RS.Heartbeat:Connect(function(dt)
                if not r.prim or not r.prim.Parent or r.driveState.deployed or not r.seatRef.isSeated then return end
                local rayO, rayD = r.prim.Position + Vector3.new(0, 2, 0), Vector3.new(0, -12, 0)
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {interceptor, lp.Character}
                params.FilterType = Enum.RaycastFilterType.Exclude
                local res = W:Raycast(rayO, rayD, params)
                if res then
                    local norm, mat, pos = res.Normal, res.Material, res.Position
                    
                    -- FIXED: Cross-product matrix vector isolation forces completely straight forward momentum and crisp snapping pivots
                    local currentLook = r.prim.CFrame.LookVector
                    local safeRight = currentLook:Cross(norm).Unit
                    local safeLook = norm:Cross(safeRight).Unit
                    
                    local targetCF = CFrame.fromMatrix(
                        Vector3.new(r.prim.Position.X, pos.Y + 1.6 + (((pos.Y + 1.6) - r.prim.Position.Y) * 0.15), r.prim.Position.Z), 
                        safeRight, 
                        norm, 
                        -safeLook
                    )
                    
                    local incline = math.clamp(r.prim.CFrame.LookVector:Dot(Vector3.new(0, 1, 0)), -1, 1)
                    local slowFactor = math.clamp(1 - math.abs(incline), 0.2, 1.0)
                    if mat == Enum.Material.Grass and r.lv.VectorVelocity.Magnitude > 65 then
                        r.lv.VectorVelocity = r.prim.CFrame.LookVector * math.max(65, r.lv.VectorVelocity.Magnitude - (18 * dt)) * slowFactor
                    elseif r.lv.VectorVelocity.Magnitude > 5 then
                        r.lv.VectorVelocity = r.prim.CFrame.LookVector * r.lv.VectorVelocity.Magnitude * slowFactor
                    end
                    if not r.prim.Anchored and r.lv.VectorVelocity.Magnitude > 0.5 then 
                        r.prim.CFrame = r.prim.CFrame:Lerp(targetCF, 0.12) 
                    end
                end
            end)
            break
        end
    end
end)
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

if _G.OceanicCreditTriggered then return end
_G.OceanicCreditTriggered = true

local isMainScriptActive = _G.D1DataShared ~= nil or Workspace:FindFirstChild("SpawnedStormInterceptor") ~= nil

if isMainScriptActive then
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "OceanicNotificationUI"
    notificationGui.ResetOnSpawn = false
    notificationGui.Parent = CoreGui

    local creditText = Instance.new("TextLabel", notificationGui)
    creditText.Size = UDim2.new(1, 0, 0, 30)
    creditText.Position = UDim2.new(0, 0, 1, -60)
    creditText.BackgroundTransparency = 1
    creditText.Text = "Script made by Oceanic enjoy lololol"
    creditText.Font = Enum.Font.SourceSansBold
    creditText.TextColor3 = Color3.fromRGB(255, 255, 255)
    creditText.TextSize = 18
    creditText.TextStrokeTransparency = 1
    creditText.TextTransparency = 1
    creditText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

    task.spawn(function()
        local fadeInText = TweenService:Create(creditText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
        local fadeInStroke = TweenService:Create(creditText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextStrokeTransparency = 0.5})
        
        fadeInText:Play()
        fadeInStroke:Play()
        
        task.wait(4.5)
        
        local fadeOutText = TweenService:Create(creditText, TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        local fadeOutStroke = TweenService:Create(creditText, TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextStrokeTransparency = 1})
        
        fadeOutText:Play()
        fadeOutStroke:Play()
        
        fadeOutText.Completed:Wait()
        notificationGui:Destroy()
    end)
endlocal CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local TARGET_UI_NAME = "DominatorDriveUI"

local hiddenGuis = {}
local lastToggleState = false

local function restoreAllUI()
    for element, oldState in pairs(hiddenGuis) do
        pcall(function()
            if element:IsA("GuiObject") then
                element.Visible = oldState
            elseif element:IsA("ScreenGui") then
                element.Enabled = oldState
            end
        end)
    end
    table.clear(hiddenGuis)
end

task.spawn(function()
    while true do
        task.wait(0.5)
        local d1Ui = CoreGui:FindFirstChild(TARGET_UI_NAME)
        
        local hideButton = nil
        if d1Ui then
            for _, descendant in ipairs(d1Ui:GetDescendants()) do
                if descendant:IsA("TextButton") and descendant.Text:find("UI") then
                    hideButton = descendant
                    break
                end
            end
        end
        
        if hideButton then
            local isHiding = (hideButton.Text == "SHOW UI")
            if isHiding ~= lastToggleState then
                lastToggleState = isHiding
                
                if isHiding then
                    local targetContainers = {CoreGui, LocalPlayer:FindFirstChildOfClass("PlayerGui")}
                    for _, container in ipairs(targetContainers) do
                        if container then
                            for _, gui in ipairs(container:GetChildren()) do
                                if gui:IsA("ScreenGui") and gui.Name ~= "OceanicNotificationUI" and gui.Name ~= "OceanicExecutorUI" then
                                    if gui == d1Ui then
                                        for _, child in ipairs(gui:GetChildren()) do
                                            if child:IsA("GuiObject") and child ~= hideButton and child ~= hideButton.Parent then
                                                hiddenGuis[child] = child.Visible
                                                child.Visible = false
                                            elseif child == hideButton.Parent then
                                                for _, insideBtn in ipairs(child:GetChildren()) do
                                                    if insideBtn:IsA("GuiObject") and insideBtn ~= hideButton then
                                                        hiddenGuis[insideBtn] = insideBtn.Visible
                                                        insideBtn.Visible = false
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        hiddenGuis[gui] = gui.Enabled
                                        gui.Enabled = false
                                    end
                                end
                            end
                        end
                    end
                else
                    restoreAllUI()
                end
            end
        end
    end
end)
    local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local TARGET_MODEL_NAME = "SpawnedStormInterceptor"

local MAX_STEP_HEIGHT = 10
local OVERRIDE_LERP_SPEED = 0.28
local DETECT_DISTANCE = 4.5

task.spawn(function()
	while true do
		task.wait(0.015)
		
		local vehicle = Workspace:FindFirstChild(TARGET_MODEL_NAME)
		local primaryPart = vehicle and (vehicle.PrimaryPart or vehicle:FindFirstChildOfClass("BasePart"))
		local character = LocalPlayer.Character
		
		if vehicle and primaryPart and character and primaryPart.Anchored == false then
			local isSeated = false
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.SeatPart and humanoid.SeatPart:IsDescendantOf(vehicle) then
				isSeated = true
			end
			
			if isSeated then
				local halfLength = 11
				local halfWidth = 4.2
				
				local currentSpeed = 0
				local bodyVelocity = primaryPart:FindFirstChild("VehicleEngine")
				if bodyVelocity and bodyVelocity:IsA("LinearVelocity") then
					currentSpeed = bodyVelocity.VectorVelocity.Magnitude
				end
				
				local dynamicLookAhead = DETECT_DISTANCE + (currentSpeed * 0.05)
				
				local cframe = primaryPart.CFrame
				local look = cframe.LookVector
				local right = cframe.RightVector
				
				local directionalScans = {
					{Dir = look,  Origins = {cframe * Vector3.new(-halfWidth, -1.0, -halfLength), cframe * Vector3.new(halfWidth, -1.0, -halfLength)}},
					{Dir = -look, Origins = {cframe * Vector3.new(-halfWidth, -1.0, halfLength),  cframe * Vector3.new(halfWidth, -1.0, halfLength)}},
					{Dir = right, Origins = {cframe * Vector3.new(halfWidth, -1.0, -halfLength),  cframe * Vector3.new(halfWidth, -1.0, halfLength)}},
					{Dir = -right,Origins = {cframe * Vector3.new(-halfWidth, -1.0, -halfLength), cframe * Vector3.new(-halfWidth, -1.0, halfLength)}}
				}
				
				local params = RaycastParams.new()
				params.FilterDescendantsInstances = {vehicle, character}
				params.FilterType = Enum.RaycastFilterType.Exclude
				
				local highestLipY = nil
				local targetPitchAngle = 0
				local targetRollAngle = 0
				
				for _, scan in ipairs(directionalScans) do
					local travelVector = scan.Dir * dynamicLookAhead
					for _, origin in ipairs(scan.Origins) do
						local hit = Workspace:Raycast(origin, travelVector, params)
						if hit then
							local stepScanOrigin = hit.Position + Vector3.new(0, MAX_STEP_HEIGHT, 0) + (scan.Dir * 0.5)
							local stepScanDirection = Vector3.new(0, -MAX_STEP_HEIGHT - 2, 0)
							
							local topHit = Workspace:Raycast(stepScanOrigin, stepScanDirection, params)
							if topHit then
								if not highestLipY or topHit.Position.Y > highestLipY then
									highestLipY = topHit.Position.Y
									
									local currentBottomY = primaryPart.Position.Y - (primaryPart.Size.Y / 2)
									local lipHeightDiff = topHit.Position.Y - currentBottomY
									
									if lipHeightDiff > 0.2 and lipHeightDiff <= MAX_STEP_HEIGHT then
										local angle = math.rad(math.clamp(lipHeightDiff * 7.5, 12, 35))
										if scan.Dir == look then
											targetPitchAngle = angle
										elseif scan.Dir == -look then
											targetPitchAngle = -angle
										elseif scan.Dir == right then
											targetRollAngle = -angle
										elseif scan.Dir == -right then
											targetRollAngle = angle
										end
									end
								end
							end
						end
					end
				end
				
				if highestLipY then
					local currentBottomY = primaryPart.Position.Y - (primaryPart.Size.Y / 2)
					local lipHeightDiff = highestLipY - currentBottomY
					
					if lipHeightDiff > 0.2 and lipHeightDiff <= MAX_STEP_HEIGHT then
						local targetY = highestLipY + 1.85
						
						local currentUp = cframe.UpVector
						local safeRight = look:Cross(currentUp).Unit
						local safeLook = currentUp:Cross(safeRight).Unit
						
						local baseMatrix = CFrame.fromMatrix(Vector3.zero, safeRight, currentUp, -safeLook)
						local targetCFrame = CFrame.new(primaryPart.Position.X, targetY, primaryPart.Position.Z)
							* baseMatrix
							* CFrame.Angles(targetPitchAngle, 0, targetRollAngle)
						
						primaryPart.CFrame = primaryPart.CFrame:Lerp(targetCFrame, OVERRIDE_LERP_SPEED)
						
						if bodyVelocity and bodyVelocity:IsA("LinearVelocity") then
							bodyVelocity.VectorVelocity = primaryPart.CFrame.LookVector * bodyVelocity.VectorVelocity.Magnitude
						end
					end
				end
			end
		end
	end
end)
    local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local TARGET_MODEL_NAME = "SpawnedStormInterceptor"
local TOOL_NAME = "Teleport To Seat"

local function setupTeleportTool()
    local existing = LocalPlayer.Backpack:FindFirstChild(TOOL_NAME) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(TOOL_NAME))
    if existing then existing:Destroy() end
    
    local tpTool = Instance.new("Tool")
    tpTool.Name = TOOL_NAME
    tpTool.RequiresHandle = false
    tpTool.Parent = LocalPlayer.Backpack
    
    tpTool.Activated:Connect(function()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        local targetVehicle = Workspace:FindFirstChild(TARGET_MODEL_NAME)
        
        if humanoid and hrp and targetVehicle then
            local seat = targetVehicle:FindFirstChild("CustomDriverSeat") 
                or targetVehicle:FindFirstChildWhichIsA("VehicleSeat", true) 
                or targetVehicle:FindFirstChildWhichIsA("Seat", true)
            local vehiclePrimary = targetVehicle.PrimaryPart or targetVehicle:FindFirstChildOfClass("BasePart")
            
            if seat and vehiclePrimary then
                pcall(function()
                    hrp.CFrame = seat.CFrame * CFrame.new(0, 1, 0)
                    task.wait(0.05)
                    seat:Sit(humanoid)
                    
                    if _G.D1SeatedRef then 
                        _G.D1SeatedRef.isSeated = true 
                    end
                    if _G.D1DataShared and _G.D1DataShared.SG then 
                        _G.D1DataShared.SG.Enabled = true 
                    end
                    if _G.D1EngineSharedRef and _G.D1EngineSharedRef.startEng then
                        _G.D1EngineSharedRef.startEng()
                    end
                end)
            elseif vehiclePrimary then
                pcall(function()
                    hrp.CFrame = vehiclePrimary.CFrame * CFrame.new(0, 3, 0)
                end)
            end
        end
    end)
end

setupTeleportTool()
LocalPlayer.CharacterAdded:Connect(setupTeleportTool)
    local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local TARGET_MODEL_NAME = "SpawnedStormInterceptor"

local function createBackupTool(name, func)
    local existing = LocalPlayer.Backpack:FindFirstChild(name) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(name))
    if existing then existing:Destroy() end
    
    local tool = Instance.new("Tool")
    tool.Name = name
    tool.RequiresHandle = false
    tool.Parent = LocalPlayer.Backpack
    tool.Activated:Connect(func)
end

local function setupTools()
    createBackupTool("Teleport Interceptor", function()
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local targetVehicle = Workspace:FindFirstChild(TARGET_MODEL_NAME)
        if rootPart and targetVehicle then
            local vehiclePrimary = targetVehicle.PrimaryPart or targetVehicle:FindFirstChildOfClass("BasePart")
            if vehiclePrimary then
                local targetCFrame = rootPart.CFrame * CFrame.new(0, 2, -15)
                pcall(function()
                    if targetVehicle.PrimaryPart then
                        targetVehicle:PivotTo(targetCFrame)
                    else
                        vehiclePrimary.CFrame = targetCFrame
                    end
                end)
            end
        end
    end)

    createBackupTool("Reset Camera", function()
        local camera = Workspace.CurrentCamera
        if camera then
            pcall(function()
                camera.CameraType = Enum.CameraType.Custom
                camera.CameraSubject = LocalPlayer.Character or LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                LocalPlayer.CameraMaxZoomDistance = 400
                LocalPlayer.CameraMinZoomDistance = 0.5
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
            end)
        end
    end)

    createBackupTool("Reset Audio", function()
        local masterMuffleGroup = SoundService:FindFirstChild("DeltaD1MasterGroup")
        if masterMuffleGroup then
            masterMuffleGroup.Volume = 1.0
        end
    end)

    createBackupTool("Reset UI", function()
        if _G.D1DataShared and _G.D1DataShared.SG then 
            pcall(function() _G.D1DataShared.SG.Enabled = true end) 
        end
    end)
end

setupTools()
LocalPlayer.CharacterAdded:Connect(setupTools)
    local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local localPlayer = Players.LocalPlayer

local trackedMuffles = {}

local function cleanExistingCameraLoop()
    local engineRef = _G.D1EngineSharedRef
    if engineRef and engineRef.cC then
        engineRef.cC:Disconnect()
        engineRef.cC = nil
    end
end
cleanExistingCameraLoop()

local function registerSound(sound)
    if not sound:IsA("Sound") then return end
    
    local hasMuffle = false
    for _, child in ipairs(sound:GetChildren()) do
        if child:IsA("EqualizerSoundEffect") and child.Name == "GlobalInterceptorMuffle" then
            hasMuffle = true
            trackedMuffles[sound] = child
            break
        end
    end
    
    if not hasMuffle then
        local success, eq = pcall(function()
            local newEq = Instance.new("EqualizerSoundEffect")
            newEq.Name = "GlobalInterceptorMuffle"
            newEq.HighGain = -15
            newEq.MidGain = -5
            newEq.LowGain = 0
            newEq.Enabled = false
            newEq.Parent = sound
            return newEq
        end)
        if success and eq then
            trackedMuffles[sound] = eq
        end
    end
end

for _, obj in ipairs(game:GetDescendants()) do
    pcall(registerSound, obj)
end

game.DescendantAdded:Connect(function(descendant)
    pcall(registerSound, descendant)
end)

RunService.Heartbeat:Connect(function()
    local interceptor = Workspace:FindFirstChild("SpawnedStormInterceptor")
    local prim = interceptor and interceptor.PrimaryPart
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local cam = Workspace.CurrentCamera
    
    local shouldMuffle = false
    if prim and hrp and cam then
        local distance = (hrp.Position - prim.Position).Magnitude
        local isFirstPerson = (cam.Focus.Position - cam.CFrame.Position).Magnitude < 1.5
        
        if distance <= 5 and isFirstPerson then
            shouldMuffle = true
        end
    end

    for sound, eq in pairs(trackedMuffles) do
        if sound and sound.Parent then
            if eq.Enabled ~= shouldMuffle then
                eq.Enabled = shouldMuffle
            end
        else
            trackedMuffles[sound] = nil
        end
    end
end)

localPlayer.CameraMaxZoomDistance = 100
localPlayer.CameraMinZoomDistance = 0.5

for _, item in ipairs(localPlayer.Backpack:GetChildren()) do
    if item.Name == "Disable / Enable Camera" then item:Destroy() end
end
if localPlayer.Character and localPlayer.Character:FindFirstChild("Disable / Enable Camera") then
    localPlayer.Character["Disable / Enable Camera"]:Destroy()
end

local cameraTool = Instance.new("Tool")
cameraTool.Name = "Disable / Enable Camera"
cameraTool.RequiresHandle = false
cameraTool.Parent = localPlayer.Backpack

local customCameraActive = true

cameraTool.Activated:Connect(function()
    customCameraActive = not customCameraActive
    
    if not customCameraActive then
        cleanExistingCameraLoop()
        local cam = Workspace.CurrentCamera
        if cam then
            cam.CameraType = Enum.CameraType.Custom
            cam.FieldOfView = 70
        end
    else
        local engineRef = _G.D1EngineSharedRef
        if engineRef and engineRef.seatRef and engineRef.seatRef.isSeated then
            local r = engineRef
            local cam = Workspace.CurrentCamera
            local lYaw, lPitch = 0, 0
            
            r.cC = RunService.RenderStepped:Connect(function(dt)
                local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
                if (hum and hum.SeatPart == r.seat or r.seatRef.isSeated) and (cam.Focus.Position - cam.CFrame.Position).Magnitude < 1.5 then
                    local currentYaw, currentPitch = cam.CFrame:ToEulerAnglesYXZ()
                    local targetYaw = math.deg(currentYaw)
                    local targetPitch = math.deg(currentPitch)
                    if r.prim and r.prim.Parent then
                        local chassisYaw = math.deg(select(2, r.prim.CFrame:ToEulerAnglesYXZ()))
                        targetYaw = targetYaw + (chassisYaw - targetYaw) * 0.1
                    end
                    lYaw = lYaw + (targetYaw - lYaw) * (7.5 * dt)
                    lPitch = lPitch + (targetPitch - lPitch) * (7.5 * dt)
                    cam.CFrame = CFrame.new(cam.CFrame.Position) * CFrame.Angles(math.rad(lYaw), math.rad(lPitch), 0)
                end
            end)
        end
    end
end)
    local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OceanicCreditGui"
screenGui.ResetOnSpawn = false

if typeof(gethui) == "function" then
    screenGui.Parent = gethui()
else
    screenGui.Parent = PlayerGui
end

local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 0, 70)
container.Position = UDim2.new(0, 0, 1, -155) 
container.BackgroundTransparency = 1
container.Parent = screenGui

local subTextLabel = Instance.new("TextLabel")
subTextLabel.Size = UDim2.new(1, 0, 0, 25)
subTextLabel.Position = UDim2.new(0, 0, 0, 0)
subTextLabel.BackgroundTransparency = 1
subTextLabel.Text = "Get me verified on Scriptblox so I can get these out faster pls :D"
subTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255) 
subTextLabel.TextSize = 13
subTextLabel.Font = Enum.Font.SourceSansBold
subTextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
subTextLabel.TextStrokeTransparency = 0.3
subTextLabel.Parent = container

local mainTextLabel = Instance.new("TextLabel")
mainTextLabel.Size = UDim2.new(1, 0, 0, 25)
mainTextLabel.Position = UDim2.new(0, 0, 0, 28)
mainTextLabel.BackgroundTransparency = 1
mainTextLabel.Text = "Script made by Oceanic enjoy lololol"
mainTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255) 
mainTextLabel.TextSize = 16 
mainTextLabel.Font = Enum.Font.SourceSansBold
mainTextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
mainTextLabel.TextStrokeTransparency = 0.3
mainTextLabel.Parent = container

task.spawn(function()
    task.wait(5.5) 
    
    local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    
    local fadeMain = TweenService:Create(mainTextLabel, tweenInfo, {TextTransparency = 1, TextStrokeTransparency = 1})
    local fadeSub = TweenService:Create(subTextLabel, tweenInfo, {TextTransparency = 1, TextStrokeTransparency = 1})
    
    fadeMain:Play()
    fadeSub:Play()
    
    fadeMain.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)
    local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer

_G.InterceptorSaves = _G.InterceptorSaves or {}

local function cleanExistingCustomizer()
    local oldTool = localPlayer.Backpack:FindFirstChild("Advanced Customizer") or (localPlayer.Character and localPlayer.Character:FindFirstChild("Advanced Customizer"))
    if oldTool then oldTool:Destroy() end
    local oldUI = CoreGui:FindFirstChild("AdvancedInterceptorUI")
    if oldUI then oldUI:Destroy() end
    if _G.InterceptorSelectionBox then _G.InterceptorSelectionBox:Destroy() _G.InterceptorSelectionBox = nil end
end
cleanExistingCustomizer()

local highlightBox = Instance.new("SelectionBox")
highlightBox.Name = "InterceptorSelectionBox"
highlightBox.Color3 = Color3.fromRGB(0, 255, 255)
highlightBox.LineThickness = 0.05
highlightBox.SurfaceColor3 = Color3.fromRGB(0, 255, 255)
highlightBox.SurfaceTransparency = 0.8
highlightBox.Parent = Workspace
_G.InterceptorSelectionBox = highlightBox

local mainUI = Instance.new("ScreenGui")
mainUI.Name = "AdvancedInterceptorUI"
mainUI.ResetOnSpawn = false
mainUI.Enabled = false
mainUI.Parent = typeof(gethui) == "function" and gethui() or CoreGui

local mainFrame = Instance.new("Frame", mainUI)
mainFrame.Size = UDim2.new(0, 290, 0, 340)
mainFrame.Position = UDim2.new(0.5, -145, 0.5, -170)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BorderSizePixel = 0

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "CONFIGURATOR"
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.BackgroundTransparency = 1

local mainScroll = Instance.new("ScrollingFrame", mainFrame)
mainScroll.Size = UDim2.new(1, -16, 1, -45)
mainScroll.Position = UDim2.new(0, 8, 0, 38)
mainScroll.BackgroundTransparency = 1
mainScroll.BorderSizePixel = 0
mainScroll.CanvasSize = UDim2.new(0, 0, 0, 520)
mainScroll.ScrollBarThickness = 4

local mainLayout = Instance.new("UIListLayout", mainScroll)
mainLayout.Padding = UDim.new(0, 8)
mainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local partsContainer = Instance.new("Frame", mainScroll)
partsContainer.Size = UDim2.new(1, 0, 0, 110)
partsContainer.BackgroundTransparency = 1

local partsScroll = Instance.new("ScrollingFrame", partsContainer)
partsScroll.Size = UDim2.new(1, 0, 1, 0)
partsScroll.BackgroundTransparency = 0.5
partsScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
partsScroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
partsScroll.ScrollBarThickness = 4
local partsCorner = Instance.new("UICorner", partsScroll)
partsCorner.CornerRadius = UDim.new(0, 4)

local partsLayout = Instance.new("UIListLayout", partsScroll)
partsLayout.Padding = UDim.new(0, 4)

local selectedPart = nil

local function createTextBox(placeholder)
    local box = Instance.new("TextBox", mainScroll)
    box.Size = UDim2.new(1, 0, 0, 30)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 14
    box.ClearTextOnFocus = false
    local c = Instance.new("UICorner", box)
    c.CornerRadius = UDim.new(0, 4)
    return box
end

local colorInput = createTextBox("RGB Color (e.g. 255,0,0)")
local decalInput = createTextBox("Decal / Texture Asset ID")
local saveNameInput = createTextBox("Profile Save Name")

local function createButton(text, bg)
    local btn = Instance.new("TextButton", mainScroll)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = text
    btn.BackgroundColor3 = bg
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 4)
    return btn
end

local applyBtn = createButton("APPLY CHANGES", Color3.fromRGB(35, 105, 195))
local saveBtn = createButton("SAVE PROFILE", Color3.fromRGB(45, 140, 45))
local loadBtn = createButton("LOAD PROFILE", Color3.fromRGB(120, 45, 140))

local function getInterceptor()
    return Workspace:FindFirstChild("SpawnedStormInterceptor")
end

local function refreshPartList()
    for _, child in ipairs(partsScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local vehicle = getInterceptor()
    if not vehicle then return end
    
    for _, part in ipairs(vehicle:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 1 then
            local btn = Instance.new("TextButton", partsScroll)
            btn.Size = UDim2.new(1, -8, 0, 26)
            btn.Text = "  " .. part.Name
            btn.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 13
            btn.TextXAlignment = Enum.TextXAlignment.Left
            
            local c = Instance.new("UICorner", btn)
            c.CornerRadius = UDim.new(0, 4)
            
            btn.MouseButton1Click:Connect(function()
                selectedPart = part
                highlightBox.Adornee = part
                title.Text = "PART: " .. part.Name:upper()
                colorInput.Text = string.format("%d,%d,%d", part.Color.R*255, part.Color.G*255, part.Color.B*255)
                
                local tex = part:FindFirstChildOfClass("Texture") or part:FindFirstChildOfClass("Decal")
                if tex then
                    decalInput.Text = tex.Texture:match("%d+") or ""
                elseif part:IsA("MeshPart") then
                    decalInput.Text = part.TextureID:match("%d+") or ""
                else
                    decalInput.Text = ""
                end
            end)
        end
    end
end

applyBtn.MouseButton1Click:Connect(function()
    if not selectedPart or not selectedPart.Parent then return end
    
    local r, g, b = colorInput.Text:match("(%d+),(%d+),(%d+)")
    if r and g and b then
        selectedPart.Color = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
    end
    
    if decalInput.Text ~= "" then
        local assetId = "rbxassetid://" .. decalInput.Text:match("%d+")
        local existingTex = selectedPart:FindFirstChildOfClass("Texture") or selectedPart:FindFirstChildOfClass("Decal")
        if existingTex then
            existingTex.Texture = assetId
        elseif selectedPart:IsA("MeshPart") then
            selectedPart.TextureID = assetId
        else
            local newDecal = Instance.new("Decal", selectedPart)
            newDecal.Texture = assetId
        end
    end
end)

saveBtn.MouseButton1Click:Connect(function()
    local vehicle = getInterceptor()
    if not vehicle or saveNameInput.Text == "" then return end
    
    local configData = {}
    for _, part in ipairs(vehicle:GetDescendants()) do
        if part:IsA("BasePart") then
            local pData = {
                Color = {part.Color.R, part.Color.G, part.Color.B}
            }
            local tex = part:FindFirstChildOfClass("Texture") or part:FindFirstChildOfClass("Decal")
            if tex then pData.Texture = tex.Texture end
            if part:IsA("MeshPart") then pData.TextureID = part.TextureID end
            configData[part.Name] = pData
        end
    end
    
    local timestamp = os.date("%X")
    local saveProfileName = string.format("[%s] %s (%s)", localPlayer.Name, saveNameInput.Text, timestamp)
    
    _G.InterceptorSaves[saveProfileName] = configData
    print("Saved Profile: " .. saveProfileName)
end)

loadBtn.MouseButton1Click:Connect(function()
    local vehicle = getInterceptor()
    if not vehicle or saveNameInput.Text == "" then return end
    
    local targetProfile = saveNameInput.Text
    local data = _G.InterceptorSaves[targetProfile]
    
    if data then
        for _, part in ipairs(vehicle:GetDescendants()) do
            if part:IsA("BasePart") and data[part.Name] then
                local pData = data[part.Name]
                part.Color = Color3.new(unpack(pData.Color))
                if pData.Texture then
                    local t = part:FindFirstChildOfClass("Texture") or part:FindFirstChildOfClass("Decal")
                    if t then t.Texture = pData.Texture end
                end
                if pData.TextureID and part:IsA("MeshPart") then
                    part.TextureID = pData.TextureID
                end
            end
        end
        print("Loaded Configuration Profile Succesfully.")
    else
        warn("Profile name not found in history cache registry")
    end
end)

local tool = Instance.new("Tool")
tool.Name = "Advanced Customizer"
tool.RequiresHandle = false
tool.Parent = localPlayer.Backpack

tool.Activated:Connect(function()
    mainUI.Enabled = not mainUI.Enabled
    if mainUI.Enabled then 
        refreshPartList() 
    else
        highlightBox.Adornee = nil
    end
end)

tool.Unequipped:Connect(function()
    mainUI.Enabled = false
    highlightBox.Adornee = nil
end)
    local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local function cleanExistingTuner()
    local oldTool = localPlayer.Backpack:FindFirstChild("Vehicle Tuner") or (localPlayer.Character and localPlayer.Character:FindFirstChild("Vehicle Tuner"))
    if oldTool then oldTool:Destroy() end
    local oldUI = CoreGui:FindFirstChild("InterceptorTunerUI")
    if oldUI then oldUI:Destroy() end
end
cleanExistingTuner()

local mainUI = Instance.new("ScreenGui")
mainUI.Name = "InterceptorTunerUI"
mainUI.ResetOnSpawn = false
mainUI.Enabled = false
mainUI.Parent = typeof(gethui) == "function" and gethui() or CoreGui

local mainFrame = Instance.new("Frame", mainUI)
mainFrame.Size = UDim2.new(0, 290, 0, 310)
mainFrame.Position = UDim2.new(0.5, -145, 0.5, -155)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BorderSizePixel = 0

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "PERFORMANCE TUNER"
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 13
title.BackgroundTransparency = 1

local mainScroll = Instance.new("ScrollingFrame", mainFrame)
mainScroll.Size = UDim2.new(1, -16, 1, -45)
mainScroll.Position = UDim2.new(0, 8, 0, 38)
mainScroll.BackgroundTransparency = 1
mainScroll.BorderSizePixel = 0
mainScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
mainScroll.ScrollBarThickness = 4

local mainLayout = Instance.new("UIListLayout", mainScroll)
mainLayout.Padding = UDim.new(0, 8)
mainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createTextBox(placeholder)
    local box = Instance.new("TextBox", mainScroll)
    box.Size = UDim2.new(1, 0, 0, 30)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 14
    box.ClearTextOnFocus = false
    local c = Instance.new("UICorner", box)
    c.CornerRadius = UDim.new(0, 4)
    return box
end

local function createToggleButton(text)
    local btn = Instance.new("TextButton", mainScroll)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = text .. " [ENABLED]"
    btn.BackgroundColor3 = Color3.fromRGB(45, 140, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 4)
    return btn
end

local speedInput = createTextBox("Set Custom Max Speed (MPH)")
local turnInput = createTextBox("Set Custom Turn Speed")
local weightInput = createTextBox("Set Custom Core Mass")

local playerCollButton = createToggleButton("PLAYER COLLISION")
local vehicleCollButton = createToggleButton("VEHICLE COLLISION")

local playerCollisionEnabled = true
local vehicleCollisionEnabled = true

local function getInterceptor()
    return Workspace:FindFirstChild("SpawnedStormInterceptor")
end

local function updateCoreTuning()
    local driveState = _G.D1DriveStateRef
    local vehicle = getInterceptor()
    
    local speedVal = tonumber(speedInput.Text)
    if speedVal and driveState then
        driveState.maxSpeedOverride = speedVal
    end
    
    local turnVal = tonumber(turnInput.Text)
    if turnVal and driveState then
        driveState.turnSpeedOverride = turnVal
    end
    
    local weightVal = tonumber(weightInput.Text)
    if weightVal and vehicle and vehicle.PrimaryPart then
        vehicle.PrimaryPart.CustomPhysicalProperties = PhysicalProperties.new(weightVal, 0.3, 0.5)
    end
end

speedInput.FocusLost:Connect(updateCoreTuning)
turnInput.FocusLost:Connect(updateCoreTuning)
weightInput.FocusLost:Connect(updateCoreTuning)

RunService.RenderStepped:Connect(function()
    local driveState = _G.D1DriveStateRef
    local engineRef = _G.D1EngineSharedRef
    
    if driveState and engineRef then
        if driveState.maxSpeedOverride and engineRef.lv then
            engineRef.lv.MaxForce = 9999999
        end
        if driveState.turnSpeedOverride and engineRef.av then
            engineRef.av.MaxTorque = 9999999
        end
    end

    if not playerCollisionEnabled and localPlayer.Character then
        for _, part in ipairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    local vehicle = getInterceptor()
    if vehicle then
        for _, part in ipairs(vehicle:GetDescendants()) do
            if part:IsA("BasePart") then
                if not vehicleCollisionEnabled then
                    part.CanCollide = false
                else
                    if part ~= vehicle.PrimaryPart then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        local driveState = _G.D1DriveStateRef
        local engineRef = _G.D1EngineSharedRef
        if driveState and engineRef and engineRef.prim then
            local oldHeartbeat
            for _, conn in ipairs(getconnections(RunService.Heartbeat)) do
                conn:Disable()
            end
            
            RunService.Heartbeat:Connect(function(dt)
                if not engineRef.prim or not engineRef.prim.Parent or driveState.deployed then return end
                
                local maxS = driveState.maxSpeedOverride or 105
                local maxR = -35
                local absSp = math.abs(driveState.currentSpeed)
                
                if driveState.brake then 
                    driveState.currentSpeed = driveState.currentSpeed > 0 and math.max(0, driveState.currentSpeed - 6.8) or math.min(0, driveState.currentSpeed + 6.8)
                elseif driveState.forward and not driveState.engineKillOverride then 
                    driveState.currentSpeed = math.min(maxS, driveState.currentSpeed + 2.5)
                elseif driveState.reverse and not driveState.engineKillOverride then 
                    driveState.currentSpeed = math.max(maxR, driveState.currentSpeed - 1.4)
                else
                    if driveState.currentSpeed > 0 then driveState.currentSpeed = math.max(0, driveState.currentSpeed - 1.1)
                    elseif driveState.currentSpeed < 0 then driveState.currentSpeed = math.min(0, driveState.currentSpeed + 1.1) end
                end
                
                local tTurn = 0 
                local turnSpeedBase = driveState.turnSpeedOverride or 1.8
                if absSp > 0.1 then 
                    if driveState.left then tTurn = turnSpeedBase elseif driveState.right then tTurn = -turnSpeedBase end 
                end
                
                engineRef.lv.VectorVelocity = engineRef.prim.CFrame.LookVector * driveState.currentSpeed 
                engineRef.av.AngularVelocity = Vector3.new(0, tTurn, 0)
                
                local rayO, rayD = engineRef.prim.Position + Vector3.new(0, 2, 0), Vector3.new(0, -15, 0)
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {engineRef.mdl, localPlayer.Character}
                params.FilterType = Enum.RaycastFilterType.Exclude
                local res = Workspace:Raycast(rayO, rayD, params)
                
                if res then
                    local currentLook = engineRef.prim.CFrame.LookVector
                    local safeRight = currentLook:Cross(res.Normal).Unit
                    local safeLook = res.Normal:Cross(safeRight).Unit
                    
                    local targetCF = CFrame.fromMatrix(
                        Vector3.new(engineRef.prim.Position.X, res.Position.Y + 2.2, engineRef.prim.Position.Z), 
                        safeRight, 
                        res.Normal, 
                        -safeLook
                    )
                    engineRef.prim.CFrame = engineRef.prim.CFrame:Lerp(targetCF, 0.15)
                end
                if _G.D1DataShared and _G.D1DataShared.ST then
                    _G.D1DataShared.ST.Text = string.format("%03d", math.abs(math.floor(driveState.currentSpeed)))
                end
            end)
            break
        end
        task.wait(0.5)
    end
end)

playerCollButton.MouseButton1Click:Connect(function()
    playerCollisionEnabled = not playerCollisionEnabled
    if playerCollisionEnabled then
        playerCollButton.Text = "PLAYER COLLISION [ENABLED]"
        playerCollButton.BackgroundColor3 = Color3.fromRGB(45, 140, 45)
    else
        playerCollButton.Text = "PLAYER COLLISION [DISABLED]"
        playerCollButton.BackgroundColor3 = Color3.fromRGB(140, 45, 45)
    end
end)

vehicleCollButton.MouseButton1Click:Connect(function()
    vehicleCollisionEnabled = not vehicleCollisionEnabled
    if vehicleCollisionEnabled then
        vehicleCollButton.Text = "VEHICLE COLLISION [ENABLED]"
        vehicleCollButton.BackgroundColor3 = Color3.fromRGB(45, 140, 45)
    else
        vehicleCollButton.Text = "VEHICLE COLLISION [DISABLED]"
        vehicleCollButton.BackgroundColor3 = Color3.fromRGB(140, 45, 45)
    end
end)

local tool = Instance.new("Tool")
tool.Name = "Vehicle Tuner"
tool.RequiresHandle = false
tool.Parent = localPlayer.Backpack

tool.Activated:Connect(function()
    mainUI.Enabled = not mainUI.Enabled
end)

tool.Unequipped:Connect(function()
    mainUI.Enabled = false
end)
    

