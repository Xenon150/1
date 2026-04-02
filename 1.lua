--[[
    AUTO FISHING SCRIPT v2 (FIXED)
    F6 - Авто-рыбалка ON/OFF
    F7 - Авто-продажа ON/OFF  
    F8 - Телепорт к точке рыбалки
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Ждём загрузки всех модулей
local Packets = ReplicatedStorage:WaitForChild("Packets", 30)
local Modules = ReplicatedStorage:WaitForChild("Modules", 30)
local Storage = ReplicatedStorage:WaitForChild("Storage", 30)

local FishingPacket = require(Packets:WaitForChild("Fishing", 30))
local Utility = require(Modules:WaitForChild("Utility", 30))

-- Ждём Replica правильно
local Replica = nil
local function waitForReplica()
    local maxWait = 30
    local waited = 0
    while waited < maxWait do
        local success, result = pcall(function()
            return Utility.Replica.WaitForReplica(LocalPlayer)
        end)
        if success and result and result.Data then
            Replica = result
            return true
        end
        task.wait(1)
        waited = waited + 1
    end
    return false
end

if not waitForReplica() then
    warn("[Auto Fish] Failed to load Replica data. Retrying...")
    task.wait(5)
    if not waitForReplica() then
        warn("[Auto Fish] Could not load. Aborting.")
        return
    end
end

-- FishStore загружаем безопасно
local FishStore = nil
pcall(function()
    FishStore = require(Storage:WaitForChild("FishStore", 30))
end)

local FishingPoints = workspace:WaitForChild("Map", 30)
    :WaitForChild("Miscs", 30)
    :WaitForChild("FishingPoints", 30)

print("[Auto Fish] All modules loaded successfully!")

-- ==================== НАСТРОЙКИ ====================
local CONFIG = {
    AUTO_FISH_ENABLED = false,
    AUTO_SELL_ENABLED = false,
    AUTO_CLICK_SPEED = 0.11,
    FISH_DELAY = 2.5,
    SELL_KEEP_EPIC = true,
    SELL_KEEP_RARE = false,
    MAX_INVENTORY_BEFORE_SELL = 0.85,
}

-- ==================== СОСТОЯНИЕ ====================
local State = {
    isFishing = false,
    isInMinigame = false,
    isMinigameStarted = false,
    isWaitingResult = false,
    fishProgress = 0.5,
    catchProgress = 0,
    gameParams = nil,
    endingTime = 0,
    catchValue = 0,
    catchGoal = 0,
    minigameConnection = nil,
    autoClickConnection = nil,
}

local catchCount = 0
local mg_targetPos = 0
local mg_currentPos = 0
local mg_nextMoveTime = 0
local mgRandom = Random.new()
local lastClickTime = 0

-- ==================== GUI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFishGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 185)
mainFrame.Position = UDim2.new(0, 10, 0.5, -92)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
local stk = Instance.new("UIStroke", mainFrame)
stk.Color = Color3.fromRGB(60, 120, 255)
stk.Thickness = 2

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundColor3 = Color3.fromRGB(25, 40, 80)
title.BackgroundTransparency = 0.2
title.TextColor3 = Color3.fromRGB(100, 180, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.Text = "🐟 Auto Fishing v2"
title.Parent = mainFrame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 18)
statusLabel.Position = UDim2.new(0, 5, 0, 32)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Text = "Status: Ready"
statusLabel.Parent = mainFrame

local function makeButton(text, yPos, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 26)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Text = text
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local fishBtn = makeButton("[F6] Auto Fish: OFF", 55, mainFrame)
local sellBtn = makeButton("[F7] Auto Sell: OFF", 87, mainFrame)
local tpBtn = makeButton("[F8] TP to Spot", 119, mainFrame)
tpBtn.TextColor3 = Color3.fromRGB(200, 200, 200)

local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(1, -10, 0, 16)
countLabel.Position = UDim2.new(0, 5, 0, 150)
countLabel.BackgroundTransparency = 1
countLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
countLabel.Font = Enum.Font.Gotham
countLabel.TextSize = 10
countLabel.TextXAlignment = Enum.TextXAlignment.Left
countLabel.Text = "Caught: 0"
countLabel.Parent = mainFrame

local invLabel = Instance.new("TextLabel")
invLabel.Size = UDim2.new(1, -10, 0, 14)
invLabel.Position = UDim2.new(0, 5, 0, 167)
invLabel.BackgroundTransparency = 1
invLabel.TextColor3 = Color3.fromRGB(200, 200, 150)
invLabel.Font = Enum.Font.Gotham
invLabel.TextSize = 9
invLabel.TextXAlignment = Enum.TextXAlignment.Left
invLabel.Text = "Inventory: ?/?"
invLabel.Parent = mainFrame

-- Перетаскивание
local dragging, dragStart, startPos = false, nil, nil
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- ==================== ФУНКЦИИ ====================

local function setStatus(t)
    statusLabel.Text = "Status: " .. t
end

local function getInventoryCount()
    local count = 0
    local success, data = pcall(function() return Replica.Data.FishInventory end)
    if success and data then
        for _ in pairs(data) do count = count + 1 end
    end
    return count
end

local function getInventorySize()
    local success, size = pcall(function() return Replica.Data.FishInventorySize end)
    if success and size then return size end
    return 10
end

local function updateUI()
    if CONFIG.AUTO_FISH_ENABLED then
        fishBtn.Text = "[F6] Auto Fish: ON"
        fishBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        fishBtn.Text = "[F6] Auto Fish: OFF"
        fishBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    if CONFIG.AUTO_SELL_ENABLED then
        sellBtn.Text = "[F7] Auto Sell: ON"
        sellBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        sellBtn.Text = "[F7] Auto Sell: OFF"
        sellBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    countLabel.Text = string.format("Caught: %d", catchCount)
    
    local ic = getInventoryCount()
    local is = getInventorySize()
    invLabel.Text = string.format("Inventory: %d/%d", ic, is)
end

local function findNearestSpot()
    local char = LocalPlayer.Character
    if not char then return nil, 999 end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, 999 end
    
    local nearest, nearestDist = nil, math.huge
    for _, spot in pairs(FishingPoints:GetChildren()) do
        if spot:IsA("Model") and not spot:GetAttribute("occupied") then
            local dist = (hrp.Position - spot:GetPivot().Position).Magnitude
            if dist < nearestDist then
                nearest = spot
                nearestDist = dist
            end
        end
    end
    return nearest, nearestDist
end

local function teleportToSpot()
    local spot = findNearestSpot()
    if not spot then
        setStatus("No spot found!")
        return
    end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local target = spot:GetAttribute("plrLoc")
    if target then
        hrp.CFrame = target
    else
        hrp.CFrame = spot:GetPivot() + Vector3.new(0, 3, 0)
    end
    setStatus("Teleported!")
end

local function cleanupMinigame()
    if State.minigameConnection then
        State.minigameConnection:Disconnect()
        State.minigameConnection = nil
    end
    if State.autoClickConnection then
        State.autoClickConnection:Disconnect()
        State.autoClickConnection = nil
    end
    State.isInMinigame = false
    State.isMinigameStarted = false
end

-- ==================== МИНИ-ИГРА ====================

local function simulateMinigame(dt)
    if not State.isMinigameStarted or not State.gameParams then return end
    local p = State.gameParams
    local now = tick()
    
    if now >= mg_nextMoveTime then
        mg_nextMoveTime = now + mgRandom:NextNumber(p.minMoveInterval, p.maxMoveInterval)
        local newT = mg_targetPos + (math.random() * 2 - 1) * (p.moveRange or 0.1) * 0.75
        mg_targetPos = math.clamp(newT, 0, 1 - p.successWidth)
    end
    
    mg_currentPos = mg_currentPos + (mg_targetPos - mg_currentPos) * p.moveSpeed * dt
    mg_currentPos = math.clamp(mg_currentPos, 0, 1 - p.successWidth)
    
    local successEnd = mg_currentPos + p.successWidth
    
    State.fishProgress = math.clamp(State.fishProgress - p.decayRate * dt, 0, 1)
    
    local inZone = State.fishProgress >= mg_currentPos and State.fishProgress <= successEnd
    if inZone then
        State.catchProgress = math.clamp(State.catchProgress + State.catchValue * p.catchFillScale * dt, 0, 100)
    else
        State.catchProgress = math.clamp(State.catchProgress - State.catchValue * p.catchDecayScale * dt, 0, 100)
    end
    
    if State.endingTime < now then
        local won = State.catchProgress / 100 > State.catchGoal
        cleanupMinigame()
        FishingPacket.gameResult.send(won)
        State.isWaitingResult = true
        setStatus(won and "Won!" or "Lost!")
    end
end

local function autoClick()
    if not State.isMinigameStarted or not State.gameParams then return end
    local now = tick()
    if now - lastClickTime < CONFIG.AUTO_CLICK_SPEED then return end
    
    local p = State.gameParams
    local target = mg_currentPos + p.successWidth / 2
    
    if State.fishProgress < target + 0.05 then
        lastClickTime = now
        State.fishProgress = math.clamp(State.fishProgress + p.clickIncrease, 0, 1)
    end
end

-- ==================== СЛУШАТЕЛИ ====================

FishingPacket.beginFishing.listen(function(text)
    if CONFIG.AUTO_FISH_ENABLED then
        State.isFishing = true
        State.isWaitingResult = false
        setStatus("Waiting for bite...")
    end
end)

FishingPacket.playGame.listen(function(params)
    if not CONFIG.AUTO_FISH_ENABLED then return end
    
    State.gameParams = params
    State.isInMinigame = true
    
    local initPos = math.max(0, 0.5 - params.successWidth / 2)
    mg_currentPos = initPos
    mg_targetPos = initPos
    mg_nextMoveTime = tick() + mgRandom:NextNumber(params.minMoveInterval, params.maxMoveInterval)
    
    local duration = tonumber(params.endTimestamp) - workspace:GetServerTimeNow()
    State.endingTime = duration + tick()
    State.fishProgress = 0.5
    State.catchProgress = 0
    State.catchValue = 100 / math.max(duration - 1.5, 1)
    State.catchGoal = params.catchGoal
    
    setStatus("Minigame!")
    
    task.delay(1.5, function()
        if not CONFIG.AUTO_FISH_ENABLED then return end
        State.isMinigameStarted = true
        
        cleanupMinigame()
        State.isMinigameStarted = true
        State.isInMinigame = true
        State.minigameConnection = RunService.RenderStepped:Connect(simulateMinigame)
        State.autoClickConnection = RunService.RenderStepped:Connect(autoClick)
    end)
end)

FishingPacket.reward.listen(function(data)
    if not CONFIG.AUTO_FISH_ENABLED then return end
    
    State.isFishing = false
    State.isWaitingResult = false
    cleanupMinigame()
    
    if data.rewardType ~= "Failed" then
        catchCount = catchCount + 1
        local name = "fish"
        if data.rewardInfo then
            pcall(function()
                local info = FishStore.getFishInfo(data.rewardInfo.id)
                name = info.name or data.rewardInfo.id
            end)
        end
        setStatus("Caught: " .. name)
    else
        setStatus("Failed!")
    end
    updateUI()
end)

FishingPacket.quit.listen(function()
    State.isFishing = false
    State.isWaitingResult = false
    cleanupMinigame()
end)

-- Авто-подтверждение продажи
FishingPacket.sellFish.listen(function()
    if CONFIG.AUTO_SELL_ENABLED then
        task.wait(0.3)
        pcall(function()
            FishingPacket.sellConfirm.send(true)
        end)
    end
end)

-- ==================== АВТО-ПРОДАЖА ====================

local function autoSell()
    if not CONFIG.AUTO_SELL_ENABLED then return end
    if not Replica or not Replica.Data then return end
    
    local inv = Replica.Data.FishInventory
    if not inv then return end
    
    local count = getInventoryCount()
    local size = getInventorySize()
    
    if count / size < CONFIG.MAX_INVENTORY_BEFORE_SELL then return end
    
    setStatus("Selling...")
    
    for uid, fish in pairs(inv) do
        if not CONFIG.AUTO_SELL_ENABLED then break end
        
        local shouldKeep = false
        pcall(function()
            if FishStore then
                local info = FishStore.getFishInfo(fish.id)
                if CONFIG.SELL_KEEP_EPIC and info.tier == "epic" then shouldKeep = true end
                if CONFIG.SELL_KEEP_RARE and info.tier == "rare" then shouldKeep = true end
            end
        end)
        
        if not shouldKeep then
            pcall(function()
                FishingPacket.sellFish.send(uid)
            end)
            task.wait(0.5)
        end
    end
    task.wait(1)
end

-- ==================== ГЛАВНЫЙ ЦИКЛ ====================

task.spawn(function()
    while task.wait(0.5) do
        if CONFIG.AUTO_FISH_ENABLED then
            -- Обновляем UI
            updateUI()
            
            if State.isFishing or State.isInMinigame or State.isWaitingResult then
                -- Ждём завершения текущей рыбалки
                continue
            end
            
            -- Авто-продажа
            pcall(autoSell)
            
            -- Ищем точку
            local spot, dist = findNearestSpot()
            if not spot or dist > 10 then
                setStatus("Move closer to fishing spot!")
                task.wait(1)
                continue
            end
            
            local spotId = spot:GetAttribute("spotId")
            if not spotId then
                setStatus("Invalid spot")
                task.wait(1)
                continue
            end
            
            -- Забрасываем
            setStatus("Casting...")
            pcall(function()
                FishingPacket.start.send(spotId)
            end)
            
            -- Ждём начала
            local t = tick()
            while not State.isFishing and tick() - t < 8 do
                task.wait(0.1)
            end
            
            if not State.isFishing then
                setStatus("Timeout, retrying...")
                task.wait(CONFIG.FISH_DELAY)
                continue
            end
            
            -- Ждём завершения
            while (State.isFishing or State.isInMinigame or State.isWaitingResult) 
                  and CONFIG.AUTO_FISH_ENABLED do
                task.wait(0.2)
            end
            
            task.wait(CONFIG.FISH_DELAY)
        else
            updateUI()
        end
    end
end)

-- ==================== КЛАВИШИ ====================

local function toggleFish()
    CONFIG.AUTO_FISH_ENABLED = not CONFIG.AUTO_FISH_ENABLED
    if not CONFIG.AUTO_FISH_ENABLED then
        cleanupMinigame()
        State.isFishing = false
        State.isWaitingResult = false
        setStatus("Stopped")
    else
        setStatus("Starting...")
    end
    updateUI()
end

local function toggleSell()
    CONFIG.AUTO_SELL_ENABLED = not CONFIG.AUTO_SELL_ENABLED
    updateUI()
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F6 then toggleFish()
    elseif input.KeyCode == Enum.KeyCode.F7 then toggleSell()
    elseif input.KeyCode == Enum.KeyCode.F8 then teleportToSpot()
    end
end)

fishBtn.MouseButton1Click:Connect(toggleFish)
sellBtn.MouseButton1Click:Connect(toggleSell)
tpBtn.MouseButton1Click:Connect(teleportToSpot)

updateUI()
setStatus("Ready! Press F6")
print("[Auto Fish v2] Loaded! F6=Fish F7=Sell F8=TP")
