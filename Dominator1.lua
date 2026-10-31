local MODEL_ID = 14049094068
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local InsertService = game:GetService("InsertService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
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
local W, Pl, IS, RS, TS, SS = workspace, game:GetService("Players"), game:GetService("InsertService"), game:GetService("RunService"), game:GetService("TweenService"), game:GetService("SoundService")
local lp = Pl.LocalPlayer

local driveState = {
    forward = false, reverse = false, left = false, right = false, brake = false,
    currentSpeed = 0, deployed = false, deployProgress = false, lightsOn = false, preDeployCFrame = nil, engineKillOverride = false
}

local muffleEQ = SS:FindFirstChild("D1InteriorMuffle") or Instance.new("EqualizerSoundEffect", SS)
muffleEQ.Name, muffleEQ.HighGain, muffleEQ.MidGain, muffleEQ.LowGain, muffleEQ.Enabled = "D1InteriorMuffle", 0, 0, 0, true

local mdl = nil
-- Delta Executor direct object injector wrapper fix
local function tryLoad(assetStr)
    local s, res = pcall(function() return game:GetObjects(assetStr) end)
    if s and type(res) == "table" then
        for _, o in ipairs(res) do if o:IsA("Model") then return o end end
    elseif s and typeof(res) == "Instance" and res:IsA("Model") then
        return res
    end
    return nil
end

mdl = tryLoad("assetid=" .. d.M) or tryLoad("rbxassetid://" .. d.M) or tryLoad("http://roblox.com" .. d.M)
if not mdl then pcall(function() mdl = IS:LoadAsset(d.M):FindFirstChildOfClass("Model") end) end

-- Fallback generation check if InsertService fails completely
if not mdl then
    warn("Delta failed to download model asset directly. Generating local placeholder chassis framework.")
    mdl = Instance.new("Model")
    local primaryPart = Instance.new("Part", mdl)
    primaryPart.Name = "ChassisCore"
    primaryPart.Size = Vector3.new(6, 2, 12)
    mdl.PrimaryPart = primaryPart
end

mdl.Name = "SpawnedStormInterceptor"
for _, p in ipairs(mdl:GetDescendants()) do if p:IsA("BasePart") then p.Anchored, p.CanCollide = true, true end end
mdl.Parent = W
mdl:PivotTo(CFrame.new(d.RP.Position) * (d.RP.CFrame - d.RP.CFrame.Position) * CFrame.new(0, 0.05, -22))

local prim = mdl.PrimaryPart
if not prim then
    for _, obj in ipairs(mdl:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "HumanoidRootPart" or obj.Name:lower():find("chassis") or obj.Name:lower():find("floor")) then
            prim = obj break
        end
    end
end
prim = prim or mdl:FindFirstChildOfClass("BasePart") or mdl:FindFirstChildOfClass("MeshPart")

for _, p in ipairs(mdl:GetDescendants()) do
    if p:IsA("BasePart") and p ~= prim then
        if (p.Position - prim.Position).Magnitude > 45 then p.CFrame = prim.CFrame end
        local w = Instance.new("WeldConstraint", prim) w.Part0, w.Part1 = prim, p p.Anchored = false
    end
end
prim.Anchored = false

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

local lv = Instance.new("LinearVelocity", prim) lv.Name, lv.MaxForce, lv.VelocityConstraintMode = "VehicleEngine", 800000, Enum.VelocityConstraintMode.Vector
local av = Instance.new("AngularVelocity", prim) av.Name, av.MaxTorque = "VehicleSteer", 900000
local att = Instance.new("Attachment", prim) att.Name, lv.Attachment0, av.Attachment0 = "DriveAttachment", att, att

local seat = Instance.new("Part", mdl) seat.Name, seat.Size, seat.Transparency, seat.CanCollide, seat.CFrame = "CustomDriverSeat", Vector3.new(4, 2, 4), 1, false, prim.CFrame * CFrame.new(0.6, 1.1, -0.6)
local sW = Instance.new("WeldConstraint", seat) sW.Part0, sW.Part1 = prim, seat

local engAtt = Instance.new("Attachment", prim) engAtt.Name, engAtt.Position = "D1EngineSoundOrigin", Vector3.new(0, 0, -8)
local function sSnd(n, id, v, l)
    local s = Instance.new("Sound", engAtt) s.Name, s.SoundId, s.Volume, s.Looped = n, "rbxassetid://"..id, v, l
    s.RollOffMaxDistance, s.RollOffMinDistance, s.RollOffMode = 150, 12, Enum.RollOffMode.Inverse return s
end
local sStart, sEng = sSnd("Dominator1StartupAudio", "97946758343425", 2.0, false), sSnd("Dominator1EngineAudio", "18995838902", 0, true)
local aDep, aUndep = sSnd("AudioDeploy", "119289479120380", 2.5, false), sSnd("AudioUndeploy", "122259650084409", 2.5, false)
local isSeated, pW, jC, cC, BRAKE_FACTOR, engState = false, nil, nil, nil, 6.8, "Off"

local function startEng()
    if engState ~= "Off" or driveState.engineKillOverride then return end
    engState = "Starting" sEng.Volume, sEng.Pitch = 0, 0.85 sEng:Play() sStart:Play()
    task.spawn(function()
        local dNum, e = sStart.TimeLength > 0 and sStart.TimeLength or 2.5, 0
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
    else d.BE.Text, d.BE.BackgroundColor3 = "ENG ON", Color3.fromRGB(20, 100, 20) if isSeated then startEng() end end
end)

local function bind(b, k, c)
    b.InputBegan:Connect(function(input) if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and not driveState.deployProgress and not driveState.engineKillOverride then if driveState.deployed then return end driveState[k] = true b.BackgroundTransparency = 0.1 if c then b.TextColor3 = c end end end)
    b.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then driveState[k] = false b.BackgroundTransparency = 0.4 if k == "brake" then b.TextColor3 = Color3.fromRGB(220, 60, 60) elseif k == "forward" then b.TextColor3 = Color3.fromRGB(60, 180, 60) else b.TextColor3 = Color3.fromRGB(245, 245, 245) end end end)
end
bind(d.BF, "forward", Color3.fromRGB(100, 255, 100)) bind(d.BRev, "reverse", Color3.fromRGB(255, 255, 100)) bind(d.BL, "left") bind(d.BR, "right") bind(d.BB, "brake", Color3.fromRGB(255, 100, 100))

d.BLi.MouseButton1Click:Connect(function() driveState.lightsOn = not driveState.lightsOn hL.Enabled, hR.Enabled = driveState.lightsOn, driveState.lightsOn d.BLi.BackgroundColor3 = driveState.lightsOn and Color3.fromRGB(230, 200, 50) or Color3.fromRGB(50, 50, 50) d.BLi.TextColor3 = driveState.lightsOn and Color3.new(0,0,0) or Color3.fromRGB(245, 245, 245) end)
d.BDep.MouseButton1Click:Connect(function()
    if driveState.deployProgress then return end driveState.deployProgress = true
    if not driveState.deployed then
        d.BDep.Text, d.BDep.BackgroundColor3 = "DEPLOYING...", Color3.fromRGB(180, 100, 30) aDep:Play() prim.Anchored = true
        TS:Create(prim, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(prim.Position.X, prim.Position.Y - 1.2, prim.Position.Z) * (prim.CFrame - prim.CFrame.Position)}):Play() task.wait(3)
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

local lYaw, lPitch = 0, 0
local function enableCam()
    local cam = W.CurrentCamera lYaw, lPitch = 0, 0
    cC = RS.RenderStepped:Connect(function(dt)
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if (hum and hum.SeatPart == seat or isSeated) and (cam.Focus.Position - cam.CFrame.Position).Magnitude < 1.5 then
            local currentYaw, currentPitch = cam.CFrame:ToEulerAnglesYXZ()
            local targetYaw = math.deg(currentYaw)
            local targetPitch = math.deg(currentPitch)
            
            if prim and prim.Parent then
                local chassisYaw = math.deg(select(2, prim.CFrame:ToEulerAnglesYXZ()))
                targetYaw = targetYaw + (chassisYaw - targetYaw) * 0.1
            end
            
            lYaw = lYaw + (targetYaw - lYaw) * (7.5 * dt)
            lPitch = lPitch + (targetPitch - lPitch) * (7.5 * dt)
            cam.CFrame = CFrame.new(cam.CFrame.Position) * CFrame.Angles(math.rad(lYaw), math.rad(lPitch), 0)
        end
    end)
end
local function exitS()
    if not isSeated then return end isSeated, d.SG.Enabled = false, false if cC then cC:Disconnect() end cC = nil stopEng()
    driveState.forward, driveState.reverse, driveState.left, driveState.right, driveState.brake, driveState.currentSpeed = false, false, false, false, false, 0
    if pW and pW.Parent then pW:Destroy() end pW = nil if jC then jC:Disconnect() end jC = nil
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then lp.Character.HumanoidRootPart.CFrame = prim.CFrame * CFrame.new(-6, 2, 0) end
    local hum = lp.Character:FindFirstChildOfClass("Humanoid") if hum then hum.Sit = false end
end
local function enterS()
    if isSeated or not lp.Character then return end local hrp, hum = lp.Character:FindFirstChild("HumanoidRootPart"), lp.Character:FindFirstChildOfClass("Humanoid")
    if hrp and hum and hum.Health > 0 then
        isSeated, d.SG.Enabled = true, true hrp.CFrame, hum.Sit = prim.CFrame * CFrame.new(0.6, 2.1, -0.6), true
        pW = Instance.new("WeldConstraint", hrp) pW.Name, pW.Part0, pW.Part1 = "ForcedSeatLock", prim, hrp enableCam() startEng()
        jC = hum:GetPropertyChangedSignal("Jump"):Connect(function() if hum.Jump then exitS() end end)
    end
end
seat.Touched:Connect(function(hit) if hit.Parent == lp.Character then enterS() end end)
sitTool.Activated:Connect(enterS)
RS.Heartbeat:Connect(function()
    if not mdl or not mdl.Parent then return end local cam = W.CurrentCamera
    if isSeated and cam then
        local cSub = cam.CameraSubject
        if cSub and cSub:IsA("Humanoid") and cSub.Parent == lp.Character then
            local head = lp.Character:FindFirstChild("Head")
            if head and (cam.CFrame.Position - head.Position).Magnitude <= 1.8 then muffleEQ.HighGain, muffleEQ.MidGain = -26, -14 else muffleEQ.HighGain, muffleEQ.MidGain = 0, 0 end
        else muffleEQ.HighGain, muffleEQ.MidGain = 0, 0 end
    else muffleEQ.HighGain, muffleEQ.MidGain = 0, 0 end
    if isSeated and prim and prim.Parent and not driveState.deployed then
        local cLook = prim.CFrame.LookVector local absSp = math.abs(driveState.currentSpeed)
        local ray = Ray.new(prim.Position, Vector3.new(0, -6, 0)) local hitPart = W:FindPartOnRayWithIgnoreList(ray, {mdl, lp.Character})
        local isOff = false
        if hitPart and hitPart.Material == Enum.Material.Grass then
            isOff = true
        end
        local maxS = isOff and 65 or 105 local maxR = isOff and -25 or -35
        local fFactor = math.clamp(1 - (absSp / maxS), 0.12, 1.0) local rFactor = math.clamp(1 - (absSp / math.abs(maxR)), 0.25, 1.0)
        if driveState.brake then driveState.currentSpeed = driveState.currentSpeed > 0 and math.max(0, driveState.currentSpeed - BRAKE_FACTOR) or math.min(0, driveState.currentSpeed + BRAKE_FACTOR)
        elseif driveState.forward and not driveState.engineKillOverride then driveState.currentSpeed = math.min(maxS, driveState.currentSpeed + (2.1 * fFactor))
        elseif driveState.reverse and not driveState.engineKillOverride then driveState.currentSpeed = math.max(maxR, driveState.currentSpeed - (1.4 * rFactor))
        else
            if driveState.currentSpeed > maxS then driveState.currentSpeed = math.max(maxS, driveState.currentSpeed - 2.5)
            elseif driveState.currentSpeed > 0 then driveState.currentSpeed = math.max(0, driveState.currentSpeed - 1.1)
            elseif driveState.currentSpeed < maxR then driveState.currentSpeed = math.min(maxR, driveState.currentSpeed + 2.5)
            elseif driveState.currentSpeed < 0 then driveState.currentSpeed = math.min(0, driveState.currentSpeed + 1.1) end
        end
        local sMod = math.clamp(1.4 - (absSp / maxS), 0.35, 1.2) if isOff then sMod = sMod * 0.8 end
        local tTurn = 0 if absSp > 0.1 then if driveState.left then tTurn = 1.8 * sMod elseif driveState.right then tTurn = -1.8 * sMod end end
        lv.VectorVelocity = cLook * driveState.currentSpeed av.AngularVelocity = Vector3.new(0, tTurn, 0)
        d.ST.Text = string.format("%03d", math.abs(math.floor(driveState.currentSpeed)))
    else if lv and av then lv.VectorVelocity, av.AngularVelocity = Vector3.zero, Vector3.zero end end
end)
local P, W, RS = game:GetService("Players"), game:GetService("Workspace"), game:GetService("RunService")
local lp = P.LocalPlayer
if not lp or not lp.Character then return end
for _, i in ipairs(lp.Backpack:GetChildren()) do if i.Name == "Reset Interceptor" then i:Destroy() end end
local tool = Instance.new("Tool", lp.Backpack) tool.Name = "Reset Interceptor" tool.RequiresHandle = false
tool.Activated:Connect(function()
    local oldM = W:FindFirstChild("SpawnedStormInterceptor") if oldM then oldM:Destroy() end
    local oldU = game:GetService("CoreGui"):FindFirstChild("DominatorDriveUI") if oldU then oldU:Destroy() end
    _G.D1DataShared = nil
    print("Dominator 1 Reset Tracker triggered. Re-run Part 1 and Part 2 now.")
end)
task.spawn(function()
    while true do
        task.wait(0.2)
        local sh = _G.D1DataShared
        local interceptor = W:FindFirstChild("SpawnedStormInterceptor")
        if interceptor and sh then
            local prim = interceptor.PrimaryPart or interceptor:FindFirstChildOfClass("BasePart")
            local lv = prim and prim:FindFirstChild("VehicleEngine")
            if prim and lv then
                RS.Heartbeat:Connect(function(dt)
                    if not prim or not prim.Parent then return end
                    local rayO = prim.Position + Vector3.new(0, 2, 0)
                    local rayD = Vector3.new(0, -12, 0)
                    local params = RaycastParams.new()
                    params.FilterDescendantsInstances = {interceptor, lp.Character}
                    params.FilterType = Enum.RaycastFilterType.Exclude
                    local res = W:Raycast(rayO, rayD, params)
                    if res then
                        local norm = res.Normal
                        local mat = res.Material
                        local pos = res.Position
                        local targetH = pos.Y + 1.6
                        local hDiff = targetH - prim.Position.Y
                        local fwd = prim.CFrame.LookVector
                        local rgt = fwd:Cross(norm).Unit
                        local trueFwd = norm:Cross(rgt).Unit
                        local targetCF = CFrame.fromMatrix(
                            Vector3.new(prim.Position.X, prim.Position.Y + (hDiff * 0.15), prim.Position.Z),
                            rgt, norm, -trueFwd
                        )
                        local incline = math.clamp(fwd:Dot(Vector3.new(0, 1, 0)), -1, 1)
                        local slowFactor = math.clamp(1 - math.abs(incline), 0.2, 1.0)
                        if mat == Enum.Material.Grass then
                            if lv.VectorVelocity.Magnitude > 65 then
                                local curSp = lv.VectorVelocity.Magnitude
                                local smoothSp = math.max(65, curSp - (18 * dt))
                                lv.VectorVelocity = prim.CFrame.LookVector * smoothSp * slowFactor
                            end
                        else
                            local curSp = lv.VectorVelocity.Magnitude
                            if curSp > 5 then
                                lv.VectorVelocity = prim.CFrame.LookVector * curSp * slowFactor
                            end
                        end
                        if not prim.Anchored and lv.VectorVelocity.Magnitude > 0.5 then
                            prim.CFrame = prim.CFrame:Lerp(targetCF, 0.12)
                        end
                    end
                end)
                break
            end
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
