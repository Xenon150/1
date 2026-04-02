--[[
    AUTO FISHING SCRIPT
    Автоматическая рыбалка с авто-кликером в мини-игре
    
    Горячие клавиши:
    F6 - Включить/Выключить авто-рыбалку
    F7 - Включить/Выключить авто-продажу (продаёт всех рыб кроме epic)
    F8 - Телепортация к ближайшей точке рыбалки
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Packets = ReplicatedStorage:WaitForChild("Packets")
local FishingPacket = require(Packets:WaitForChild("Fishing"))
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Utility = require(Modules:WaitForChild("Utility"))
local Storage = ReplicatedStorage:WaitForChild("Storage")
local FishStore = require(Storage:WaitForChild("FishStore"))
local Replica = Utility.Replica.WaitForReplica(LocalPlayer)

local FishingPoints = workspace:WaitForChild("Map"):WaitForChild("Miscs"):WaitForChild("FishingPoints")

-- ==================== НАСТРОЙКИ ====================
local CONFIG = {
    AUTO_FISH_ENABLED = false,       -- Авто-рыбалка
    AUTO_SELL_ENABLED = false,       -- Авто-продажа
    AUTO_CLICK_SPEED = 0.11,         -- Скорость авто-клика (секунды между кликами)
    FISH_DELAY = 2.0,               -- Задержка между забросами (секунды)
    SELL_KEEP_EPIC = true,           -- Оставлять epic рыб
    SELL_KEEP_RARE = false,          -- Оставлять rare рыб
    TELEPORT_TO_SPOT = false,        -- Телепорт к точке
    MAX_INVENTORY_BEFORE_SELL = 0.9, -- Продавать когда инвентарь заполнен на 90%
}

-- ==================== СОСТОЯНИЕ ====================
local State = {
    isFishing = false,
    isInMinigame = false,
    isMinigameStarted = false,
    isWaitingResult = false,
    currentSpotId = nil,
    currentSpot = nil,
    fishProgress = 0.5,
    catchProgress = 0,
    successPosition = 0,
    successWidth = 0.3,
    gameParams = nil,
    endingTime = 0,
    catchValue = 0,
    catchGoal = 0,
    minigameConnection = nil,
    autoClickConnection = nil,
    mainLoopConnection = nil,
}

-- ==================== UI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFishGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 180)
mainFrame.Position = UDim2.new(0, 10, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 130, 255)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 50, 100)
title.BackgroundTransparency = 0.3
title.TextColor3 = Color3.fromRGB(100, 180, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Text = "🐟 Auto Fishing"
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 20)
statusLabel.Position = UDim2.new(0, 5, 0, 35)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Text = "Status: Idle"
statusLabel.Parent = mainFrame

-- Кнопка авто-рыбалки
local fishBtn = Instance.new("TextButton")
fishBtn.Size = UDim2.new(0.9, 0, 0, 28)
fishBtn.Position = UDim2.new(0.05, 0, 0, 60)
fishBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
fishBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
fishBtn.Font = Enum.Font.GothamBold
fishBtn.TextSize = 12
fishBtn.Text = "[F6] Auto Fish: OFF"
fishBtn.Parent = mainFrame

local fishBtnCorner = Instance.new("UICorner")
fishBtnCorner.CornerRadius = UDim.new(0, 6)
fishBtnCorner.Parent = fishBtn

-- Кнопка авто-продажи
local sellBtn = Instance.new("TextButton")
sellBtn.Size = UDim2.new(0.9, 0, 0, 28)
sellBtn.Position = UDim2.new(0.05, 0, 0, 95)
sellBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
sellBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
sellBtn.Font = Enum.Font.GothamBold
sellBtn.TextSize = 12
sellBtn.Text = "[F7] Auto Sell: OFF"
sellBtn.Parent = mainFrame

local sellBtnCorner = Instance.new("UICorner")
sellBtnCorner.CornerRadius = UDim.new(0, 6)
sellBtnCorner.Parent = sellBtn

-- Кнопка телепорта
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.9, 0, 0, 28)
tpBtn.Position = UDim2.new(0.05, 0, 0, 130)
tpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
tpBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 12
tpBtn.Text = "[F8] TP to Fishing Spot"
tpBtn.Parent = mainFrame

local tpBtnCorner = Instance.new("UICorner")
tpBtnCorner.CornerRadius = UDim.new(0, 6)
tpBtnCorner.Parent = tpBtn

-- Счётчик пойманных рыб
local catchCount = 0
local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(1, -10, 0, 16)
countLabel.Position = UDim2.new(0, 5, 0, 162)
countLabel.BackgroundTransparency = 1
countLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
countLabel.Font = Enum.Font.Gotham
countLabel.TextSize = 10
countLabel.TextXAlignment = Enum.TextXAlignment.Left
countLabel.Text = "Caught: 0"
countLabel.Parent = mainFrame

-- Делаем GUI перетаскиваемым
local dragging = false
local dragStart, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ==================== ФУНКЦИИ ====================

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
end

local function setStatus(text)
    statusLabel.Text = "Status: " .. text
end

-- Найти ближайшую точку рыбалки
local function findNearestSpot()
    local character = LocalPlayer.Character
    if not character then return nil, nil end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil end
    
    local nearest = nil
    local nearestDist = math.huge
    
    for _, spot in pairs(FishingPoints:GetChildren()) do
        if spot:IsA("Model") and not spot:GetAttribute("occupied") then
            local pos = spot:GetPivot().Position
            local dist = (hrp.Position - pos).Magnitude
            if dist < nearestDist then
                nearest = spot
                nearestDist = dist
            end
        end
    end
    
    return nearest, nearestDist
end

-- Телепорт к точке рыбалки
local function teleportToSpot()
    local spot, _ = findNearestSpot()
    if not spot then
        setStatus("No fishing spot found!")
        return false
    end
    
    local character = LocalPlayer.Character
    if not character then return false end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    -- Используем plrLoc атрибут если есть, иначе позицию модели
    local targetCF = spot:GetAttribute("plrLoc")
    if targetCF then
        hrp.CFrame = targetCF
    else
        hrp.CFrame = spot:GetPivot() + Vector3.new(0, 3, 0)
    end
    
    setStatus("Teleported!")
    task.wait(0.5)
    return true
end

-- Авто-продажа рыб
local function autoSell()
    if not CONFIG.AUTO_SELL_ENABLED then return end
    
    local inventory = Replica.Data.FishInventory
    local inventorySize = Replica.Data.FishInventorySize or 10
    
    -- Считаем рыб
    local fishCount = 0
    for _ in pairs(inventory) do
        fishCount = fishCount + 1
    end
    
    -- Проверяем заполненность инвентаря
    if fishCount / inventorySize < CONFIG.MAX_INVENTORY_BEFORE_SELL then
        return
    end
    
    setStatus("Selling fish...")
    
    -- Находим рыбу для продажи
    for uid, fish in pairs(inventory) do
        local fishInfo = nil
        pcall(function()
            fishInfo = FishStore.getFishInfo(fish.id)
        end)
        
        if fishInfo then
            local shouldKeep = false
            if CONFIG.SELL_KEEP_EPIC and fishInfo.tier == "epic" then
                shouldKeep = true
            end
            if CONFIG.SELL_KEEP_RARE and fishInfo.tier == "rare" then
                shouldKeep = true
            end
            
            if not shouldKeep then
                -- Продаём рыбу
                FishingPacket.sellFish.send(uid)
                task.wait(0.3)
            end
        end
    end
    
    task.wait(1)
end

-- ==================== МИНИ-ИГРА ====================

-- Симуляция мини-игры (авто-кликер)
local minigameRandom = Random.new()
local mg_targetPos = 0
local mg_currentPos = 0
local mg_nextMoveTime = 0
local mg_nextMoveDuration = 0

local function simulateMinigame(dt)
    if not State.isMinigameStarted or not State.gameParams then return end
    
    local params = State.gameParams
    local now = tick()
    
    -- Движение зоны успеха (имитируем серверную логику)
    if now >= mg_nextMoveTime then
        mg_nextMoveTime = now + minigameRandom:NextNumber(params.minMoveInterval, params.maxMoveInterval)
        local moveRange = params.moveRange or 0.1
        local newTarget = mg_targetPos + (math.random() * 2 - 1) * moveRange * 0.75
        mg_targetPos = math.clamp(newTarget, 0, 1 - params.successWidth)
    end
    
    mg_currentPos = mg_currentPos + (mg_targetPos - mg_currentPos) * params.moveSpeed * dt
    mg_currentPos = math.clamp(mg_currentPos, 0, 1 - params.successWidth)
    
    local successEnd = mg_currentPos + params.successWidth
    
    -- Decay fishProgress
    State.fishProgress = math.clamp(State.fishProgress - params.decayRate * dt, 0, 1)
    
    -- Проверяем попадание
    local inZone = State.fishProgress >= mg_currentPos and State.fishProgress <= successEnd
    
    if inZone then
        State.catchProgress = math.clamp(
            State.catchProgress + State.catchValue * params.catchFillScale * dt, 0, 100
        )
    else
        State.catchProgress = math.clamp(
            State.catchProgress - State.catchValue * params.catchDecayScale * dt, 0, 100
        )
    end
    
    -- Проверяем окончание
    if State.endingTime < now then
        local won = State.catchProgress / 100 > State.catchGoal
        State.isInMinigame = false
        State.isMinigameStarted = false
        
        if State.minigameConnection then
            State.minigameConnection:Disconnect()
            State.minigameConnection = nil
        end
        if State.autoClickConnection then
            State.autoClickConnection:Disconnect()
            State.autoClickConnection = nil
        end
        
        FishingPacket.gameResult.send(won)
        State.isWaitingResult = true
        setStatus(won and "Won minigame!" or "Lost minigame...")
    end
end

-- Авто-клик: держим fishProgress в центре зоны успеха
local lastClickTime = 0

local function autoClick()
    if not State.isMinigameStarted or not State.gameParams then return end
    
    local now = tick()
    if now - lastClickTime < CONFIG.AUTO_CLICK_SPEED then return end
    
    local params = State.gameParams
    
    -- Целевая позиция — центр зоны успеха
    local targetFishPos = mg_currentPos + params.successWidth / 2
    
    -- Кликаем только если fishProgress ниже целевой позиции
    if State.fishProgress < targetFishPos + 0.05 then
        lastClickTime = now
        State.fishProgress = math.clamp(
            State.fishProgress + params.clickIncrease, 0, 1
        )
    end
end

-- ==================== СЛУШАТЕЛИ ПАКЕТОВ ====================

-- Начало рыбалки
FishingPacket.beginFishing.listen(function(text)
    if CONFIG.AUTO_FISH_ENABLED then
        State.isFishing = true
        State.isWaitingResult = false
        setStatus("Fishing: " .. tostring(text))
    end
end)

-- Начало мини-игры
FishingPacket.playGame.listen(function(params)
    if CONFIG.AUTO_FISH_ENABLED then
        State.gameParams = params
        State.isInMinigame = true
        
        -- Инициализация
        local initPos = 0.5 - params.successWidth / 2
        mg_currentPos = math.max(0, initPos)
        mg_targetPos = mg_currentPos
        mg_nextMoveTime = tick() + minigameRandom:NextNumber(params.minMoveInterval, params.maxMoveInterval)
        
        local duration = tonumber(params.endTimestamp) - workspace:GetServerTimeNow()
        State.endingTime = duration + tick()
        State.fishProgress = 0.5
        State.catchProgress = 0
        State.catchValue = 100 / (duration - 1.5)
        State.catchGoal = params.catchGoal
        
        setStatus("Minigame started!")
        
        -- Ждём 1.5 секунды как в оригинале
        task.delay(1.5, function()
            State.isMinigameStarted = true
            
            -- Подключаем симуляцию мини-игры
            if State.minigameConnection then
                State.minigameConnection:Disconnect()
            end
            State.minigameConnection = RunService.RenderStepped:Connect(simulateMinigame)
            
            -- Подключаем авто-кликер
            if State.autoClickConnection then
                State.autoClickConnection:Disconnect()
            end
            State.autoClickConnection = RunService.RenderStepped:Connect(autoClick)
        end)
    end
end)

-- Результат (награда)
FishingPacket.reward.listen(function(rewardData)
    if CONFIG.AUTO_FISH_ENABLED then
        State.isFishing = false
        State.isWaitingResult = false
        State.isInMinigame = false
        State.isMinigameStarted = false
        
        if rewardData.rewardType ~= "Failed" then
            catchCount = catchCount + 1
            
            local fishName = "Unknown"
            if rewardData.rewardInfo then
                pcall(function()
                    local info = FishStore.getFishInfo(rewardData.rewardInfo.id)
                    fishName = info.name or rewardData.rewardInfo.id
                end)
            end
            
            setStatus("Caught: " .. fishName .. " (#" .. catchCount .. ")")
        else
            setStatus("Failed to catch!")
        end
        
        updateUI()
    end
end)

-- Выход из рыбалки
FishingPacket.quit.listen(function()
    State.isFishing = false
    State.isInMinigame = false
    State.isMinigameStarted = false
    State.isWaitingResult = false
    
    if State.minigameConnection then
        State.minigameConnection:Disconnect()
        State.minigameConnection = nil
    end
    if State.autoClickConnection then
        State.autoClickConnection:Disconnect()
        State.autoClickConnection = nil
    end
    
    if CONFIG.AUTO_FISH_ENABLED then
        setStatus("Quit detected, restarting...")
    end
end)

-- Подтверждение продажи (авто-подтверждаем)
FishingPacket.sellFish.listen(function(uid)
    if CONFIG.AUTO_SELL_ENABLED then
        task.wait(0.2)
        FishingPacket.sellConfirm.send(true)
    end
end)

FishingPacket.sellConfirm.listen(function()
    -- Продажа подтверждена
end)

-- ==================== ГЛАВНЫЙ ЦИКЛ ====================

local function mainLoop()
    while task.wait(0.5) do
        if CONFIG.AUTO_FISH_ENABLED then
            -- Проверяем, не идёт ли уже рыбалка
            if State.isFishing or State.isInMinigame or State.isWaitingResult then
                continue
            end
            
            -- Авто-продажа перед началом
            if CONFIG.AUTO_SELL_ENABLED then
                autoSell()
            end
            
            -- Находим ближайшую точку
            local spot, dist = findNearestSpot()
            if not spot then
                setStatus("No fishing spot nearby")
                task.wait(2)
                continue
            end
            
            if dist > 10 then
                if CONFIG.TELEPORT_TO_SPOT then
                    teleportToSpot()
                    task.wait(1)
                    spot, dist = findNearestSpot()
                end
                
                if not spot or dist > 10 then
                    setStatus("Too far from spot (" .. math.floor(dist) .. " studs)")
                    task.wait(1)
                    continue
                end
            end
            
            local spotId = spot:GetAttribute("spotId")
            if not spotId then
                setStatus("Spot has no ID")
                task.wait(1)
                continue
            end
            
            -- Начинаем рыбалку
            setStatus("Casting rod...")
            State.currentSpot = spot
            State.currentSpotId = spotId
            FishingPacket.start.send(spotId)
            
            -- Ждём начала или таймаут
            local waitStart = tick()
            while not State.isFishing and tick() - waitStart < 10 do
                task.wait(0.1)
            end
            
            if not State.isFishing then
                setStatus("Timeout waiting for fish start")
                task.wait(CONFIG.FISH_DELAY)
                continue
            end
            
            -- Ждём завершения рыбалки
            while (State.isFishing or State.isInMinigame or State.isWaitingResult) and CONFIG.AUTO_FISH_ENABLED do
                task.wait(0.2)
            end
            
            -- Задержка перед следующей рыбалкой
            task.wait(CONFIG.FISH_DELAY)
        else
            setStatus("Idle")
        end
    end
end

-- ==================== ГОРЯЧИЕ КЛАВИШИ ====================

local function toggleAutoFish()
    CONFIG.AUTO_FISH_ENABLED = not CONFIG.AUTO_FISH_ENABLED
    
    if not CONFIG.AUTO_FISH_ENABLED then
        -- Очищаем состояние
        if State.minigameConnection then
            State.minigameConnection:Disconnect()
            State.minigameConnection = nil
        end
        if State.autoClickConnection then
            State.autoClickConnection:Disconnect()
            State.autoClickConnection = nil
        end
        State.isFishing = false
        State.isInMinigame = false
        State.isMinigameStarted = false
        State.isWaitingResult = false
        setStatus("Idle")
    else
        setStatus("Starting...")
    end
    
    updateUI()
end

local function toggleAutoSell()
    CONFIG.AUTO_SELL_ENABLED = not CONFIG.AUTO_SELL_ENABLED
    updateUI()
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F6 then
        toggleAutoFish()
    elseif input.KeyCode == Enum.KeyCode.F7 then
        toggleAutoSell()
    elseif input.KeyCode == Enum.KeyCode.F8 then
        teleportToSpot()
    end
end)

fishBtn.MouseButton1Click:Connect(toggleAutoFish)
sellBtn.MouseButton1Click:Connect(toggleAutoSell)
tpBtn.MouseButton1Click:Connect(teleportToSpot)

-- ==================== ЗАПУСК ====================

updateUI()
task.spawn(mainLoop)

print("[Auto Fish] Loaded! Press F6 to toggle.")
print("[Auto Fish] F6 = Auto Fish | F7 = Auto Sell | F8 = Teleport")
