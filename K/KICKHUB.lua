-- KICK GUI スクリプト
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- GUI作成
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KickGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.new(1, 1, 1)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- タイトル
local title = Instance.new("TextLabel")
title.Text = "KICK GUI"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- 状態変数
local kickGrabEnabled = false
local kickAuraEnabled = false

-- KickGrabボタン
local kickGrabButton = Instance.new("TextButton")
kickGrabButton.Text = "KickGrab: OFF"
kickGrabButton.Size = UDim2.new(0.8, 0, 0, 40)
kickGrabButton.Position = UDim2.new(0.1, 0, 0.2, 0)
kickGrabButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
kickGrabButton.TextColor3 = Color3.new(1, 1, 1)
kickGrabButton.TextScaled = true
kickGrabButton.Parent = mainFrame

-- KickAuraボタン
local kickAuraButton = Instance.new("TextButton")
kickAuraButton.Text = "KickAura: OFF"
kickAuraButton.Size = UDim2.new(0.8, 0, 0, 40)
kickAuraButton.Position = UDim2.new(0.1, 0, 0.5, 0)
kickAuraButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
kickAuraButton.TextColor3 = Color3.new(1, 1, 1)
kickAuraButton.TextScaled = true
kickAuraButton.Parent = mainFrame

-- 閉じるボタン
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -25, 0, 0)
closeButton.BackgroundColor3 = Color3.new(1, 0, 0)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Parent = mainFrame

-- ボタンの機能
local function updateButtonAppearance(button, enabled)
    if enabled then
        button.BackgroundColor3 = Color3.new(0, 0.5, 0)
        button.Text = button.Text:gsub("OFF", "ON"):gsub("ON", "ON")
    else
        button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        button.Text = button.Text:gsub("ON", "OFF"):gsub("OFF", "OFF")
    end
end

-- KickGrab機能
kickGrabButton.MouseButton1Click:Connect(function()
    kickGrabEnabled = not kickGrabEnabled
    updateButtonAppearance(kickGrabButton, kickGrabEnabled)
    
    if kickGrabEnabled then
        spawn(function()
            while kickGrabEnabled and RunService.Heartbeat:Wait() do
                -- ターゲットを探して処理するロジック
                local target = findNearestPlayer()
                if target then
                    performKickGrab(target)
                end
            end
        end)
    end
end)

-- KickAura機能
kickAuraButton.MouseButton1Click:Connect(function()
    kickAuraEnabled = not kickAuraEnabled
    updateButtonAppearance(kickAuraButton, kickAuraEnabled)
    
    if kickAuraEnabled then
        spawn(function()
            while kickAuraEnabled and RunService.Heartbeat:Wait() do
                -- 範囲内の全プレイヤーを処理
                local players = getPlayersInRange(50) -- 50スタジオ単位以内
                for _, target in pairs(players) do
                    performKickGrab(target)
                end
            end
        end)
    end
end)

-- 補助関数
local function findNearestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local humanoid = otherPlayer.Character:FindFirstChild("Humanoid")
            local rootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and rootPart then
                local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = otherPlayer
                end
            end
        end
    end
    
    return closestPlayer
end

local function getPlayersInRange(range)
    local playersInRange = {}
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local humanoid = otherPlayer.Character:FindFirstChild("Humanoid")
            local rootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and rootPart then
                local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
if distance <= range then
                    table.insert(playersInRange, otherPlayer)
                end
            end
        end
    end
    
    return playersInRange
end

local function performKickGrab(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        local character = targetPlayer.Character
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            -- 浮遊状態を作成
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 50, 0) -- 上方向に浮遊
            bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
            bodyVelocity.Parent = rootPart
            
            -- アンチチートトリガー（ゲームの仕組みに依存）
            -- ここでは基本的な物理的操作のみ
            wait(0.1)
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
    end
end

-- 閉じるボタン
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- GUIを最前面に
screenGui.DisplayOrder = 999
