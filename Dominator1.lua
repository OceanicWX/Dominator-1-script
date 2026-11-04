
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
}
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
end)
local d = _G.D1DataShared
local r = _G.D1EngineSharedRef
if not d or not r then return end
local W, Pl, RS = workspace, game:GetService("Players"), game:GetService("RunService")
local lp = Pl.LocalPlayer

RS.Heartbeat:Connect(function(dt)
    if not r.mdl or not r.mdl.Parent then return end local cam = W.CurrentCamera
    
    
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
end
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

if _G.DeltaNoticeLoaded then return end
_G.DeltaNoticeLoaded = true

local player = Players.LocalPlayer
if not player then return end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaMessageGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

if gethud then
    screenGui.Parent = gethud()
elseif getgui then
    screenGui.Parent = getgui()
elseif cloneref then
    screenGui.Parent = cloneref(CoreGui)
else
    screenGui.Parent = CoreGui
end

local textLabel = Instance.new("TextLabel")
textLabel.Name = "NotificationText"
textLabel.Size = UDim2.new(1, 0, 0, 25)
textLabel.Position = UDim2.new(0, 0, 1, -50)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Sorry the script was broken for a bit I tried to update it but it broke :/"
textLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
textLabel.Font = Enum.Font.SourceSans
textLabel.TextSize = 15
textLabel.TextTransparency = 1
textLabel.TextStrokeTransparency = 1
textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
textLabel.Parent = screenGui

local tweenInfoIn = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfoOut = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local fadeIn = TweenService:Create(textLabel, tweenInfoIn, {TextTransparency = 0, TextStrokeTransparency = 0.3})
local fadeOut = TweenService:Create(textLabel, tweenInfoOut, {TextTransparency = 1, TextStrokeTransparency = 1})

fadeIn:Play()
task.wait(4.5)
fadeOut:Play()

fadeOut.Completed:Connect(function()
    screenGui:Destroy()
    _G.DeltaNoticeLoaded = nil
end)

