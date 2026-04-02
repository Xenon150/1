--[[
    AUTO FISHING v3 - Эмулирует действия игрока через UI
    F6 - Авто-рыбалка
    F8 - Телепорт к точке
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local FishingPoints = workspace:WaitForChild("Map"):WaitForChild("Miscs"):WaitForChild("FishingPoints")

-- ==================== НАСТРОЙКИ ====================
local AUTO_ENABLED = false
local CLICK_INTERVAL = 0.12
local FISH_DELAY = 3.0
local catchCount = 0

-- ==================== GUI ====================
local sg = Instance.new("ScreenGui")
sg.Name = "AF3"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 100)
frame.Position = UDim2.new(0, 10, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
local s = Instance.new("UIStroke", frame)
s.Color = Color3.fromRGB(60, 120, 255)
s.Thickness = 2

local titleL = Instance.new("TextLabel")
titleL.Size = UDim2.new(1, 0, 0, 24)
titleL.BackgroundColor3 = Color3.fromRGB(25, 40, 80)
titleL.BackgroundTransparency = 0.2
titleL.TextColor3 = Color3.fromRGB(100, 180, 255)
titleL.Font = Enum.Font.GothamBold
titleL.TextSize = 12
titleL.Text = "🐟 Auto Fish v3"
titleL.Parent = frame
Instance.new("UICorner", titleL).CornerRadius = UDim.new(0, 8)

local statusL = Instance.new("TextLabel")
statusL.Size = UDim2.new(1, -8, 0, 16)
statusL.Position = UDim2.new(0, 4, 0, 28)
statusL.BackgroundTransparency = 1
statusL.TextColor3 = Color3.fromRGB(200, 200, 200)
statusL.Font = Enum.Font.Gotham
statusL.TextSize = 10
statusL.TextXAlignment = Enum.TextXAlignment.Left
statusL.Text = "Status: Ready"
statusL.Parent = frame

local fishB = Instance.new("TextButton")
fishB.Size = UDim2.new(0.9, 0, 0, 24)
fishB.Position = UDim2.new(0.05, 0, 0, 48)
fishB.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
fishB.TextColor3 = Color3.fromRGB(255, 100, 100)
fishB.Font = Enum.Font.GothamBold
fishB.TextSize = 11
fishB.Text = "[F6] OFF"
fishB.Parent = frame
Instance.new("UICorner", fishB).CornerRadius = UDim.new(0, 6)

local countL = Instance.new("TextLabel")
countL.Size = UDim2.new(1, -8, 0, 14)
countL.Position = UDim2.new(0, 4, 0, 78)
countL.BackgroundTransparency = 1
countL.TextColor3 = Color3.fromRGB(150, 255, 150)
countL.Font = Enum.Font.Gotham
countL.TextSize = 10
countL.TextXAlignment = Enum.TextXAlignment.Left
countL.Text = "Caught: 0"
countL.Parent = frame

-- Перетаскивание
local dr, ds, sp = false, nil, nil
titleL.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dr = true; ds = i.Position; sp = frame.Position
    end
end)
titleL.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dr = false end
end)
UserInputService.InputChanged:Connect(function(i)
    if dr and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - ds
        frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
    end
end)

-- ==================== ПОИСК UI ЭЛЕМЕНТОВ ИГРЫ ====================

local function setStatus(t)
    statusL.Text = "Status: " .. t
end

local function updateUI()
    if AUTO_ENABLED then
        fishB.Text = "[F6] ON"
        fishB.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        fishB.Text = "[F6] OFF"
        fishB.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    countL.Text = "Caught: " .. catchCount
end

-- Ищем FishUI модуль через клиентские скрипты
local function findFishUIScript()
    for _, desc in pairs(PlayerGui:GetDescendants()) do
        if desc:IsA("LocalScript") and desc.Name == "Fishing" then
            return desc
        end
    end
    return nil
end

-- Находим кнопку рыбалки в UI игры
local function findGameButton(name)
    for _, desc in pairs(PlayerGui:GetDescendants()) do
        if desc:IsA("TextButton") or desc:IsA("ImageButton") then
            if desc.Name == name then
                return desc
            end
        end
    end
    return nil
end

-- Ищем все TextButton и ImageButton с определённым текстом
local function findButtonByText(searchText)
    for _, desc in pairs(PlayerGui:GetDescendants()) do
        if (desc:IsA("TextButton") or desc:IsA("TextLabel")) then
            if desc.Text and string.find(string.lower(desc.Text), string.lower(searchText)) then
                if desc:IsA("TextButton") then
                    return desc
                end
                -- Проверяем родителя
                local parent = desc.Parent
                if parent and (parent:IsA("TextButton") or parent:IsA("ImageButton")) then
                    return parent
                end
            end
        end
    end
    return nil
end

-- Ближайшая точка рыбалки
local function findNearestSpot()
    local char = LocalPlayer.Character
    if not char then return nil, 999 end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, 999 end
    
    local nearest, nd = nil, math.huge
    for _, spot in pairs(FishingPoints:GetChildren()) do
        if spot:IsA("Model") and not spot:GetAttribute("occupied") then
            local d = (hrp.Position - spot:GetPivot().Position).Magnitude
            if d < nd then nearest = spot; nd = d end
        end
    end
    return nearest, nd
end

local function teleportToSpot()
    local spot = findNearestSpot()
    if not spot then setStatus("No spot!"); return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local t = spot:GetAttribute("plrLoc")
    hrp.CFrame = t or (spot:GetPivot() + Vector3.new(0, 3, 0))
    setStatus("Teleported!")
end

-- ==================== ВИРТУАЛЬНЫЙ КЛИК ====================

local function virtualClick(x, y)
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
        task.wait(0.02)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
    end)
end

local function clickButton(button)
    if not button or not button.Parent then return false end
    if not button.Visible then return false end
    
    -- Проверяем видимость всех родителей
    local current = button.Parent
    while current and current ~= PlayerGui do
        if current:IsA("GuiObject") and not current.Visible then
            return false
        end
        current = current.Parent
    end
    
    local pos = button.AbsolutePosition
    local size = button.AbsoluteSize
    local cx = pos.X + size.X / 2
    local cy = pos.Y + size.Y / 2
    
    virtualClick(cx, cy)
    return true
end

-- ==================== ОПРЕДЕЛЕНИЕ СОСТОЯНИЯ ИГРЫ ====================

-- Проверяем состояние через UI элементы
local function isInFishingUI()
    -- Ищем характерные элементы UI рыбалки
    for _, desc in pairs(PlayerGui:GetDescendants()) do
        if desc:IsA("TextLabel") then
            local txt = desc.Text or ""
            if string.find(txt, "Click!") or string.find(txt, "Reeling") or 
               string.find(txt, "Waiting") or string.find(txt, "casting") then
                if desc.Visible ~= false then
                    return true
                end
            end
        end
    end
    return false
end

local function isMinigameActive()
    -- Ищем прогресс-бар мини-игры
    for _, desc in pairs(PlayerGui:GetDescendants()) do
        if desc:IsA("Frame") or desc:IsA("CanvasGroup") then
            if desc.Name == "MinigameBar" or desc.Name == "ProgressBar" or 
               desc.Name == "CatchBar" or desc.Name == "FishBar" then
                if desc.Visible ~= false and desc.Parent and desc.Parent.Visible ~= false then
                    return true
                end
            end
        end
    end
    return false
end

local function isResultScreen()
    for _, desc in pairs(PlayerGui:GetDescendants()) do
        if desc:IsA("TextLabel") then
            local txt = string.lower(desc.Text or "")
            if (string.find(txt, "caught") or string.find(txt, "failed") or 
                string.find(txt, "reward") or string.find(txt, "you got")) then
                if desc.Visible ~= false then
                    return true
                end
            end
        end
    end
    return false
end

-- ==================== ГЛАВНЫЙ ЦИКЛ ====================

local autoClickConn = nil
local isAutoClicking = false

local function startAutoClick()
    if isAutoClicking then return end
    isAutoClicking = true
    
    autoClickConn = RunService.RenderStepped:Connect(function()
        if not AUTO_ENABLED or not isAutoClicking then
            if autoClickConn then autoClickConn:Disconnect() end
            isAutoClicking = false
            return
        end
        
        -- Кликаем в центр экрана для мини-игры
        local viewport = workspace.CurrentCamera.ViewportSize
        virtualClick(viewport.X / 2, viewport.Y / 2)
    end)
end

local function stopAutoClick()
    isAutoClicking = false
    if autoClickConn then
        autoClickConn:Disconnect()
        autoClickConn = nil
    end
end

-- Ищем кнопку "Fish" в UI игры
local function findAndClickFishButton()
    -- Метод 1: Ищем по Callback свойству через fireClick
    for _, desc in pairs(PlayerGui:GetDescendants()) do
        if (desc:IsA("TextButton") or desc:IsA("ImageButton")) and desc.Visible then
            local txt = ""
            pcall(function() txt = string.lower(desc.Text or "") end)
            
            if string.find(txt, "fish") and not string.find(txt, "auto") then
                -- Проверяем что все родители видимы
                local vis = true
                local p = desc.Parent
                while p and p ~= PlayerGui do
                    if p:IsA("GuiObject") then
                        pcall(function()
                            if not p.Visible then vis = false end
                        end)
                    end
                    p = p.Parent
                end
                
                if vis then
                    clickButton(desc)
                    return true
                end
            end
        end
    end
    
    -- Метод 2: firesignal на все видимые кнопки с рыбалкой
    return false
end

local function findAndClickResultButton()
    for _, desc in pairs(PlayerGui:GetDescendants()) do
        if (desc:IsA("TextButton") or desc:IsA("ImageButton")) and desc.Visible then
            local txt = ""
            pcall(function() txt = string.lower(desc.Text or "") end)
            
            if string.find(txt, "ok") or string.find(txt, "continue") or 
               string.find(txt, "close") or string.find(txt, "next") then
                local vis = true
                local p = desc.Parent
                while p and p ~= PlayerGui do
                    if p:IsA("GuiObject") then
                        pcall(function()
                            if not p.Visible then vis = false end
                        end)
                    end
                    p = p.Parent
                end
                if vis then
                    clickButton(desc)
                    return true
                end
            end
        end
    end
    return false
end

-- ==================== ОСНОВНОЙ АВТОМАТИЗАТОР ====================

task.spawn(function()
    while true do
        task.wait(0.3)
        
        if not AUTO_ENABLED then
            stopAutoClick()
            continue
        end
        
        -- Проверяем расстояние до точки
        local spot, dist = findNearestSpot()
        if not spot or dist > 12 then
            setStatus("Get closer to fishing spot!")
            stopAutoClick()
            task.wait(1)
            continue
        end
        
        -- Определяем текущее состояние
        local fishing = false
        local minigame = false
        local result = false
        
        -- Сканируем UI для определения состояния
        for _, desc in pairs(PlayerGui:GetDescendants()) do
            if not desc:IsA("GuiObject") then continue end
            
            local visible = true
            pcall(function()
                if desc.Visible == false then visible = false end
            end)
            if not visible then continue end
            
            local txt = ""
            pcall(function()
                if desc:IsA("TextLabel") or desc:IsA("TextButton") then
                    txt = string.lower(desc.Text or "")
                end
            end)
            
            -- Проверяем мини-игру по наличию прогресс-элементов
            if desc.Name and (string.find(string.lower(desc.Name), "catch") or 
                             string.find(string.lower(desc.Name), "minigame") or
                             string.find(string.lower(desc.Name), "progress")) then
                minigame = true
            end
            
            if string.find(txt, "waiting") or string.find(txt, "reeling") then
                fishing = true
            end
            
            if string.find(txt, "caught") or string.find(txt, "failed") then
                result = true
            end
        end
        
        if result then
            setStatus("Result screen...")
            stopAutoClick()
            task.wait(2)
            -- Кликаем чтобы закрыть
            local viewport = workspace.CurrentCamera.ViewportSize
            virtualClick(viewport.X / 2, viewport.Y / 2)
            task.wait(1)
            findAndClickResultButton()
            task.wait(FISH_DELAY)
            
        elseif minigame then
            setStatus("Minigame - clicking!")
            -- Авто-клик для мини-игры
            if not isAutoClicking then
                startAutoClick()
            end
            
        elseif fishing then
            setStatus("Waiting for bite...")
            stopAutoClick()
            
        else
            -- Ничего не происходит - пробуем начать рыбалку
            stopAutoClick()
            setStatus("Starting fish...")
            
            -- Пробуем нажать кнопку рыбалки
            local clicked = findAndClickFishButton()
            
            if not clicked then
                -- Альтернативный метод - firesignal
                setStatus("Looking for fish button...")
            end
            
            task.wait(FISH_DELAY)
        end
    end
end)

-- Отдельный цикл авто-клика для мини-игры с правильным интервалом  
task.spawn(function()
    while true do
        task.wait(CLICK_INTERVAL)
        if AUTO_ENABLED and isAutoClicking then
            local viewport = workspace.CurrentCamera.ViewportSize
            virtualClick(viewport.X / 2, viewport.Y / 2)
        end
    end
end)

-- ==================== КЛАВИШИ ====================

local function toggle()
    AUTO_ENABLED = not AUTO_ENABLED
    if not AUTO_ENABLED then
        stopAutoClick()
        setStatus("Stopped")
    else
        setStatus("Starting...")
    end
    updateUI()
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F6 then toggle()
    elseif input.KeyCode == Enum.KeyCode.F8 then teleportToSpot()
    end
end)

fishB.MouseButton1Click:Connect(toggle)

updateUI()
setStatus("Ready! F6 to start")
print("[AutoFish v3] Loaded! F6=Toggle F8=TP")
print("[AutoFish v3] Stand near fishing spot and press F6")
