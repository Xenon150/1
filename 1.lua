local Luxt1 = {}

-- Создание градиента
local function CreateGradient(parent, colors, rotation)
    local Gradient = Instance.new("UIGradient")
    Gradient.Parent = parent
    Gradient.Rotation = rotation or 45
    
    local colorSequence = {}
    for i, color in ipairs(colors) do
        table.insert(colorSequence, ColorSequenceKeypoint.new((i-1)/(#colors-1), color))
    end
    Gradient.Color = ColorSequence.new(colorSequence)
    
    return Gradient
end

-- Создание системы частиц
local function CreateParticles(parent)
    local ParticlesFrame = Instance.new("Frame")
    ParticlesFrame.Name = "ParticlesFrame"
    ParticlesFrame.Parent = parent
    ParticlesFrame.BackgroundTransparency = 1
    ParticlesFrame.Size = UDim2.new(1, 0, 1, 0)
    ParticlesFrame.ZIndex = 1
    ParticlesFrame.ClipsDescendants = true
    
    for i = 1, 15 do
        local Particle = Instance.new("Frame")
        Particle.Parent = ParticlesFrame
        Particle.BackgroundColor3 = Color3.fromRGB(153, 255, 238)
        Particle.BackgroundTransparency = 0.7
        Particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
        Particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
        Particle.ZIndex = 1
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(1, 0)
        Corner.Parent = Particle
        
        spawn(function()
            while Particle and Particle.Parent do
                wait(math.random(2, 5))
                local newPos = UDim2.new(math.random(), 0, math.random(), 0)
                game:GetService("TweenService"):Create(Particle, TweenInfo.new(math.random(3, 6), Enum.EasingStyle.Sine), {
                    Position = newPos,
                    BackgroundTransparency = math.random(50, 90) / 100
                }):Play()
            end
        end)
    end
end

function Luxt1.CreateWindow(libName, logoId)
    local LuxtLib = Instance.new("ScreenGui")
    local shadow = Instance.new("ImageLabel")
    local MainFrame = Instance.new("Frame")
    local sideHeading = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local sideCover = Instance.new("Frame")
    local hubLogo = Instance.new("ImageLabel")
    local MainCorner_2 = Instance.new("UICorner")
    local hubName = Instance.new("TextLabel")
    local tabFrame = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local usename = Instance.new("TextLabel")
    local MainCorner_3 = Instance.new("UICorner")
    local wave = Instance.new("ImageLabel")
    local MainCorner_4 = Instance.new("UICorner")
    local framesAll = Instance.new("Frame")
    local pageFolder = Instance.new("Folder")

    local key1 = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local keybindInfo1 = Instance.new("TextLabel")
    
    -- Система уведомлений
    local NotificationHolder = Instance.new("Frame")

    libName = libName or "LuxtLib"
    logoId = logoId or ""

    LuxtLib.Name = "LuxtLib"..libName
    LuxtLib.Parent = game.CoreGui
    LuxtLib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Holder для уведомлений
    NotificationHolder.Name = "NotificationHolder"
    NotificationHolder.Parent = LuxtLib
    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.Position = UDim2.new(1, -320, 0, 10)
    NotificationHolder.Size = UDim2.new(0, 300, 1, -20)
    NotificationHolder.ZIndex = 100
    
    local NotifList = Instance.new("UIListLayout")
    NotifList.Parent = NotificationHolder
    NotifList.SortOrder = Enum.SortOrder.LayoutOrder
    NotifList.Padding = UDim.new(0, 10)
    NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    
    -- Функция создания уведомлений (локальная)
    local function CreateNotification(title, text, duration)
        local Notification = Instance.new("Frame")
        local NotifCorner = Instance.new("UICorner")
        local NotifTitle = Instance.new("TextLabel")
        local NotifText = Instance.new("TextLabel")
        local NotifClose = Instance.new("TextButton")
        local NotifBar = Instance.new("Frame")
        
        Notification.Parent = NotificationHolder
        Notification.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        Notification.Size = UDim2.new(1, 0, 0, 0)
        Notification.ClipsDescendants = true
        Notification.ZIndex = 100
        
        CreateGradient(Notification, {
            Color3.fromRGB(30, 20, 40),
            Color3.fromRGB(20, 30, 50)
        }, 45)
        
        NotifCorner.CornerRadius = UDim.new(0, 8)
        NotifCorner.Parent = Notification
        
        NotifBar.Parent = Notification
        NotifBar.BackgroundColor3 = Color3.fromRGB(153, 255, 238)
        NotifBar.Size = UDim2.new(0, 3, 1, 0)
        NotifBar.BorderSizePixel = 0
        NotifBar.ZIndex = 101
        
        NotifTitle.Parent = Notification
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Position = UDim2.new(0, 15, 0, 8)
        NotifTitle.Size = UDim2.new(1, -50, 0, 20)
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.Text = title or "Notification"
        NotifTitle.TextColor3 = Color3.fromRGB(153, 255, 238)
        NotifTitle.TextSize = 14
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.ZIndex = 101
        
        NotifText.Parent = Notification
        NotifText.BackgroundTransparency = 1
        NotifText.Position = UDim2.new(0, 15, 0, 30)
        NotifText.Size = UDim2.new(1, -25, 1, -40)
        NotifText.Font = Enum.Font.Gotham
        NotifText.Text = text or ""
        NotifText.TextColor3 = Color3.fromRGB(200, 200, 200)
        NotifText.TextSize = 12
        NotifText.TextWrapped = true
        NotifText.TextXAlignment = Enum.TextXAlignment.Left
        NotifText.TextYAlignment = Enum.TextYAlignment.Top
        NotifText.ZIndex = 101
        
        NotifClose.Parent = Notification
        NotifClose.BackgroundTransparency = 1
        NotifClose.Position = UDim2.new(1, -25, 0, 5)
        NotifClose.Size = UDim2.new(0, 20, 0, 20)
        NotifClose.Font = Enum.Font.GothamBold
        NotifClose.Text = "×"
        NotifClose.TextColor3 = Color3.fromRGB(255, 100, 100)
        NotifClose.TextSize = 18
        NotifClose.ZIndex = 101
        
        Notification:TweenSize(UDim2.new(1, 0, 0, 70), "Out", "Quint", 0.3, true)
        
        local function CloseNotif()
            Notification:TweenSize(UDim2.new(1, 0, 0, 0), "In", "Quint", 0.3, true)
            wait(0.3)
            if Notification then
                Notification:Destroy()
            end
        end
        
        NotifClose.MouseButton1Click:Connect(CloseNotif)
        
        spawn(function()
            wait(duration or 5)
            CloseNotif()
        end)
    end

    -- Основной фрейм с градиентом
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = shadow
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.Position = UDim2.new(0.048, 0, 0.075, 0)
    MainFrame.Size = UDim2.new(0, 553, 0, 452)
    
    CreateGradient(MainFrame, {
        Color3.fromRGB(20, 20, 30),
        Color3.fromRGB(35, 25, 45),
        Color3.fromRGB(25, 35, 50)
    }, 45)
    
    CreateParticles(MainFrame)

    -- Боковая панель
    sideHeading.Name = "sideHeading"
    sideHeading.Parent = MainFrame
    sideHeading.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    sideHeading.Size = UDim2.new(0, 155, 0, 452)
    sideHeading.ZIndex = 2
    
    CreateGradient(sideHeading, {
        Color3.fromRGB(10, 10, 20),
        Color3.fromRGB(25, 15, 35),
        Color3.fromRGB(15, 25, 40)
    }, 90)

    MainCorner.CornerRadius = UDim.new(0, 5)
    MainCorner.Name = "MainCorner"
    MainCorner.Parent = sideHeading

    sideCover.Name = "sideCover"
    sideCover.Parent = sideHeading
    sideCover.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    sideCover.BorderSizePixel = 0
    sideCover.Position = UDim2.new(0.909677446, 0, 0, 0)
    sideCover.Size = UDim2.new(0, 14, 0, 452)

    hubLogo.Name = "hubLogo"
    hubLogo.Parent = sideHeading
    hubLogo.BackgroundColor3 = Color3.fromRGB(153, 255, 238)
    hubLogo.Position = UDim2.new(0.0567928664, 0, 0.0243411884, 0)
    hubLogo.Size = UDim2.new(0, 30, 0, 30)
    hubLogo.ZIndex = 2
    hubLogo.Image = "rbxassetid://"..logoId

    MainCorner_2.CornerRadius = UDim.new(0, 999)
    MainCorner_2.Name = "MainCorner"
    MainCorner_2.Parent = hubLogo

    hubName.Name = "hubName"
    hubName.Parent = sideHeading
    hubName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hubName.BackgroundTransparency = 1.000
    hubName.Position = UDim2.new(0.290000081, 0, 0.0299999975, 0)
    hubName.Size = UDim2.new(0, 110, 0, 16)
    hubName.ZIndex = 2
    hubName.Font = Enum.Font.GothamSemibold
    hubName.Text = libName
    hubName.TextColor3 = Color3.fromRGB(153, 255, 238)
    hubName.TextSize = 14.000
    hubName.TextWrapped = true
    hubName.TextXAlignment = Enum.TextXAlignment.Left

    tabFrame.Name = "tabFrame"
    tabFrame.Parent = sideHeading
    tabFrame.Active = true
    tabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabFrame.BackgroundTransparency = 1.000
    tabFrame.BorderSizePixel = 0
    tabFrame.Position = UDim2.new(0.0761478543, 0, 0.126385808, 0)
    tabFrame.Size = UDim2.new(0, 135, 0, 347)
    tabFrame.ZIndex = 2
    tabFrame.ScrollBarThickness = 0

    UIListLayout.Parent = tabFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    usename.Name = "usename"
    usename.Parent = sideHeading
    usename.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    usename.BackgroundTransparency = 1.000
    usename.Position = UDim2.new(0.290000081, 0, 0.0700000152, 0)
    usename.Size = UDim2.new(0, 110, 0, 16)
    usename.ZIndex = 2
    usename.Font = Enum.Font.GothamSemibold
    usename.Text = game.Players.LocalPlayer.Name
    usename.TextColor3 = Color3.fromRGB(103, 172, 161)
    usename.TextSize = 12.000
    usename.TextWrapped = true
    usename.TextXAlignment = Enum.TextXAlignment.Left

    MainCorner_3.CornerRadius = UDim.new(0, 5)
    MainCorner_3.Name = "MainCorner"
    MainCorner_3.Parent = MainFrame

    wave.Name = "wave"
    wave.Parent = MainFrame
    wave.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    wave.BackgroundTransparency = 1.000
    wave.Position = UDim2.new(0.0213434305, 0, 0, 0)
    wave.Size = UDim2.new(0.97865659, 0, 0.557522118, 0)
    wave.Image = "http://www.roblox.com/asset/?id=6087537285"
    wave.ImageColor3 = Color3.fromRGB(181, 249, 255)
    wave.ImageTransparency = 0.500
    wave.ScaleType = Enum.ScaleType.Slice
    
    CreateGradient(wave, {
        Color3.fromRGB(153, 255, 238),
        Color3.fromRGB(255, 153, 238),
        Color3.fromRGB(153, 200, 255)
    }, 45)

    MainCorner_4.CornerRadius = UDim.new(0, 3)
    MainCorner_4.Name = "MainCorner"
    MainCorner_4.Parent = wave

    framesAll.Name = "framesAll"
    framesAll.Parent = MainFrame
    framesAll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    framesAll.BackgroundTransparency = 1.000
    framesAll.BorderSizePixel = 0
    framesAll.Position = UDim2.new(0.296564192, 0, 0.0242873337, 0)
    framesAll.Size = UDim2.new(0, 381, 0, 431)
    framesAll.ZIndex = 2

    shadow.Name = "shadow"
    shadow.Parent = LuxtLib
    shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shadow.BackgroundTransparency = 1.000
    shadow.Position = UDim2.new(0.319562584, 0, 0.168689325, 0)
    shadow.Size = UDim2.new(0, 609, 0, 530)
    shadow.ZIndex = 0
    shadow.Image = "http://www.roblox.com/asset/?id=6105530152"
    shadow.ImageColor3 = Color3.fromRGB(100, 50, 150)
    shadow.ImageTransparency = 0.200

    pageFolder.Name = "pageFolder"
    pageFolder.Parent = framesAll

    -- Кнопка скрытия
    key1.Name = "key1"
    key1.Parent = sideHeading
    key1.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    key1.Position = UDim2.new(0.0508064516, 0, 0.935261786, 0)
    key1.Size = UDim2.new(0, 76, 0, 22)
    key1.ZIndex = 2
    key1.Font = Enum.Font.GothamSemibold
    key1.Text = "LeftAlt"
    key1.TextColor3 = Color3.fromRGB(153, 255, 238)
    key1.TextSize = 14.000

    local oldKey = Enum.KeyCode.LeftAlt.Name

    key1.MouseButton1Click:connect(function(e) 
        key1.Text = ". . ."
        local a, b = game:GetService('UserInputService').InputBegan:wait();
        if a.KeyCode.Name ~= "Unknown" then
            key1.Text = a.KeyCode.Name
            oldKey = a.KeyCode.Name;
        end
    end)

    game:GetService("UserInputService").InputBegan:connect(function(current, ok) 
        if not ok then 
            if current.KeyCode.Name == oldKey then 
                if LuxtLib.Enabled == true then
                    LuxtLib.Enabled = false
                else
                    LuxtLib.Enabled = true
                end
            end
        end
    end)

    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = key1

    keybindInfo1.Name = "keybindInfo"
    keybindInfo1.Parent = sideHeading
    keybindInfo1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    keybindInfo1.BackgroundTransparency = 1.000
    keybindInfo1.Position = UDim2.new(0.585064113, 0, 0.935261846, 0)
    keybindInfo1.Size = UDim2.new(0, 50, 0, 22)
    keybindInfo1.ZIndex = 2
    keybindInfo1.Font = Enum.Font.GothamSemibold
    keybindInfo1.Text = "Close"
    keybindInfo1.TextColor3 = Color3.fromRGB(255, 255, 255)
    keybindInfo1.TextSize = 13.000
    keybindInfo1.TextXAlignment = Enum.TextXAlignment.Left

    -- Перетаскивание
    local UserInputService = game:GetService("UserInputService")
    local TopBar = sideHeading
    local Camera = workspace:WaitForChild("Camera")
    local DragMousePosition
    local FramePosition
    local Draggable = false
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Draggable = true
            DragMousePosition = Vector2.new(input.Position.X, input.Position.Y)
            FramePosition = Vector2.new(shadow.Position.X.Scale, shadow.Position.Y.Scale)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if Draggable == true then
            local NewPosition = FramePosition + ((Vector2.new(input.Position.X, input.Position.Y) - DragMousePosition) / Camera.ViewportSize)
            shadow.Position = UDim2.new(NewPosition.X, 0, NewPosition.Y, 0)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Draggable = false
        end
    end)

    -- Возвращаемый объект с функциями
    local TabHandling = {}
    
    -- ВАЖНО: Добавляем Notify как метод возвращаемого объекта
    TabHandling.Notify = CreateNotification

    function TabHandling:Tab(tabText, tabId)
        local tabBtnFrame = Instance.new("Frame")
        local tabBtn = Instance.new("TextButton")
        local tabLogo = Instance.new("ImageLabel")
        local TabGlow = Instance.new("Frame")

        tabText = tabText or "Tab"
        tabId = tabId or ""

        tabBtnFrame.Name = "tabBtnFrame"
        tabBtnFrame.Parent = tabFrame
        tabBtnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabBtnFrame.BackgroundTransparency = 1.000
        tabBtnFrame.Size = UDim2.new(0, 135, 0, 30)
        tabBtnFrame.ZIndex = 2
        
        TabGlow.Name = "TabGlow"
        TabGlow.Parent = tabBtnFrame
        TabGlow.BackgroundColor3 = Color3.fromRGB(153, 255, 238)
        TabGlow.BackgroundTransparency = 1
        TabGlow.Position = UDim2.new(0, -5, 0, -5)
        TabGlow.Size = UDim2.new(1, 10, 1, 10)
        TabGlow.ZIndex = 1
        
        local GlowCorner = Instance.new("UICorner")
        GlowCorner.CornerRadius = UDim.new(0, 8)
        GlowCorner.Parent = TabGlow

        tabBtn.Name = "tabBtn"
        tabBtn.Parent = tabBtnFrame
        tabBtn.BackgroundColor3 = Color3.fromRGB(166, 248, 255)
        tabBtn.BackgroundTransparency = 1.000
        tabBtn.Position = UDim2.new(0.245534033, 0, 0, 0)
        tabBtn.Size = UDim2.new(0, 101, 0, 30)
        tabBtn.ZIndex = 2
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.Text = tabText
        tabBtn.TextColor3 = Color3.fromRGB(153, 255, 238)
        tabBtn.TextSize = 14.000
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left

        tabLogo.Name = "tabLogo"
        tabLogo.Position = UDim2.new(-0.007, 0, 0.067, 0)
        tabLogo.Parent = tabBtnFrame
        tabLogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabLogo.BackgroundTransparency = 1.000
        tabLogo.BorderSizePixel = 0
        tabLogo.Size = UDim2.new(0, 25, 0, 25)
        tabLogo.ZIndex = 2
        tabLogo.Image = "rbxassetid://"..tabId
        tabLogo.ImageColor3 = Color3.fromRGB(153, 255, 238)

        local newPage = Instance.new("ScrollingFrame")
        local sectionList = Instance.new("UIListLayout")

        newPage.Name = "newPage"..tabText
        newPage.Parent = pageFolder
        newPage.Active = true
        newPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        newPage.BackgroundTransparency = 1.000
        newPage.BorderSizePixel = 0
        newPage.Size = UDim2.new(1, 0, 1, 0)
        newPage.ZIndex = 2
        newPage.ScrollBarThickness = 0
        newPage.Visible = false

        sectionList.Name = "sectionList"
        sectionList.Parent = newPage
        sectionList.SortOrder = Enum.SortOrder.LayoutOrder
        sectionList.Padding = UDim.new(0, 3)

        local function UpdateSize()
            local cS = sectionList.AbsoluteContentSize
            game.TweenService:Create(newPage, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                CanvasSize = UDim2.new(0, cS.X, 0, cS.Y)
            }):Play()
        end
        
        UpdateSize()
        newPage.ChildAdded:Connect(UpdateSize)
        newPage.ChildRemoved:Connect(UpdateSize)

        tabBtn.MouseButton1Click:Connect(function()
            UpdateSize()
            for i,v in next, pageFolder:GetChildren() do
                UpdateSize()
                v.Visible = false
            end
            newPage.Visible = true
            
            for i,v in next, tabFrame:GetChildren() do
                if v:IsA("Frame") then
                    if v:FindFirstChild("TabGlow") then
                        game.TweenService:Create(v.TabGlow, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                            BackgroundTransparency = 1
                        }):Play()
                    end
                    
                    for _,child in next, v:GetChildren() do
                        if child:IsA("TextButton") then
                            game.TweenService:Create(child, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                                TextColor3 = Color3.fromRGB(80, 80, 100)
                            }):Play()
                        end
                        if child:IsA("ImageLabel") and child.Name == "tabLogo" then
                            game.TweenService:Create(child, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                                ImageColor3 = Color3.fromRGB(80, 80, 100)
                            }):Play()
                        end
                    end
                end
            end
            
            game.TweenService:Create(TabGlow, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                BackgroundTransparency = 0.85
            }):Play()
            
            game.TweenService:Create(tabLogo, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                ImageColor3 = Color3.fromRGB(153, 255, 238)
            }):Play()
            game.TweenService:Create(tabBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                TextColor3 = Color3.fromRGB(153, 255, 238)
            }):Play()
        end)

        local sectionHandling = {}

        function sectionHandling:Section(sectionText)
            local sectionFrame = Instance.new("Frame")
            local MainCorner = Instance.new("UICorner")
            local mainSectionHead = Instance.new("Frame")
            local sectionName = Instance.new("TextLabel")
            local sectionExpannd = Instance.new("ImageButton")
            local sectionInnerList = Instance.new("UIListLayout")

            sectionInnerList.Name = "sectionInnerList"
            sectionInnerList.Parent = sectionFrame
            sectionInnerList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            sectionInnerList.SortOrder = Enum.SortOrder.LayoutOrder
            sectionInnerList.Padding = UDim.new(0, 3)
            
            sectionText = sectionText or "Section"
            local isDropped = false

            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = newPage
            sectionFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
            sectionFrame.Position = UDim2.new(0, 0, 7.08064434e-08, 0)
            sectionFrame.Size = UDim2.new(1, 0, 0, 36)
            sectionFrame.ZIndex = 2
            sectionFrame.ClipsDescendants = true
            
            CreateGradient(sectionFrame, {
                Color3.fromRGB(20, 15, 30),
                Color3.fromRGB(15, 20, 35)
            }, 90)

            MainCorner.CornerRadius = UDim.new(0, 5)
            MainCorner.Name = "MainCorner"
            MainCorner.Parent = sectionFrame

            mainSectionHead.Name = "mainSectionHead"
            mainSectionHead.Parent = sectionFrame
            mainSectionHead.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            mainSectionHead.BackgroundTransparency = 1.000
            mainSectionHead.BorderSizePixel = 0
            mainSectionHead.Size = UDim2.new(0, 381, 0, 36)

            sectionName.Name = "sectionName"
            sectionName.Parent = mainSectionHead
            sectionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sectionName.BackgroundTransparency = 1.000
            sectionName.Position = UDim2.new(0.0236220472, 0, 0, 0)
            sectionName.Size = UDim2.new(0, 302, 0, 36)
            sectionName.Font = Enum.Font.GothamSemibold
            sectionName.Text = sectionText
            sectionName.TextColor3 = Color3.fromRGB(153, 255, 238)
            sectionName.TextSize = 14.000
            sectionName.TextXAlignment = Enum.TextXAlignment.Left

            sectionExpannd.Name = "sectionExpannd"
            sectionExpannd.Parent = mainSectionHead
            sectionExpannd.BackgroundTransparency = 1.000
            sectionExpannd.Position = UDim2.new(0.91863519, 0, 0.138888896, 0)
            sectionExpannd.Size = UDim2.new(0, 25, 0, 25)
            sectionExpannd.ZIndex = 2
            sectionExpannd.Image = "rbxassetid://3926305904"
            sectionExpannd.ImageColor3 = Color3.fromRGB(153, 255, 238)
            sectionExpannd.ImageRectOffset = Vector2.new(564, 284)
            sectionExpannd.ImageRectSize = Vector2.new(36, 36)
            
            sectionExpannd.MouseButton1Click:Connect(function()
                if isDropped then
                    isDropped = false
                    sectionFrame:TweenSize(UDim2.new(1, 0, 0, 36), "In", "Quint", 0.10)
                    game.TweenService:Create(sectionExpannd, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Rotation = 0
                    }):Play()
                    wait(0.10)
                    UpdateSize()
                else
                    isDropped = true
                    sectionFrame:TweenSize(UDim2.new(1, 0, 0, sectionInnerList.AbsoluteContentSize.Y + 5), "In", "Quint", 0.10)
                    game.TweenService:Create(sectionExpannd, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Rotation = 180
                    }):Play()
                    wait(0.10)
                    UpdateSize()
                end
            end)

            local ItemHandling = {}

            function ItemHandling:Button(btnText, callback)
                local ButtonFrame = Instance.new("Frame")
                local TextButton = Instance.new("TextButton")
                local BtnCorner = Instance.new("UICorner")
                local BtnListLayout = Instance.new("UIListLayout")
                local ButtonGlow = Instance.new("Frame")

                btnText = btnText or "TextButton"
                callback = callback or function() end

                ButtonFrame.Name = "ButtonFrame"
                ButtonFrame.Parent = sectionFrame
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                ButtonFrame.BackgroundTransparency = 1.000
                ButtonFrame.Size = UDim2.new(0, 365, 0, 36)
                
                ButtonGlow.Name = "ButtonGlow"
                ButtonGlow.Parent = ButtonFrame
                ButtonGlow.BackgroundColor3 = Color3.fromRGB(153, 255, 238)
                ButtonGlow.BackgroundTransparency = 1
                ButtonGlow.Position = UDim2.new(0.5, -185, 0.5, -21)
                ButtonGlow.Size = UDim2.new(0, 370, 0, 42)
                ButtonGlow.ZIndex = 1
                
                local GlowC = Instance.new("UICorner")
                GlowC.CornerRadius = UDim.new(0, 6)
                GlowC.Parent = ButtonGlow

                TextButton.Parent = ButtonFrame
                TextButton.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                TextButton.Size = UDim2.new(0, 365, 0, 36)
                TextButton.ZIndex = 2
                TextButton.AutoButtonColor = false
                TextButton.Text = btnText
                TextButton.Font = Enum.Font.GothamSemibold
                TextButton.TextColor3 = Color3.fromRGB(180, 180, 200)
                TextButton.TextSize = 14.000
                
                CreateGradient(TextButton, {
                    Color3.fromRGB(18, 18, 28),
                    Color3.fromRGB(25, 20, 35)
                }, 45)

                local debounce = false
                TextButton.MouseButton1Click:Connect(function()
                    if not debounce then
                        debounce = true
                        callback()
                        wait(0.5)
                        debounce = false
                    end
                end)

                BtnCorner.CornerRadius = UDim.new(0, 3)
                BtnCorner.Parent = TextButton

                BtnListLayout.Parent = ButtonFrame
                BtnListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                BtnListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                BtnListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                TextButton.MouseButton1Up:Connect(function()
                    TextButton:TweenSize(UDim2.new(0, 365, 0, 36), "InOut", "Quint", 0.18, true)
                    game.TweenService:Create(ButtonGlow, TweenInfo.new(0.18, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 1
                    }):Play()
                end)
                
                TextButton.MouseButton1Down:Connect(function()
                    TextButton:TweenSize(UDim2.new(0, 359, 0, 30), "InOut", "Quint", 0.18, true)
                    game.TweenService:Create(ButtonGlow, TweenInfo.new(0.18, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0.7
                    }):Play()
                end)
                
                TextButton.MouseEnter:Connect(function()
                    game.TweenService:Create(TextButton, TweenInfo.new(0.18, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                        TextColor3 = Color3.fromRGB(250, 250, 255)
                    }):Play()
                    game.TweenService:Create(ButtonGlow, TweenInfo.new(0.18, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0.9
                    }):Play()
                end)
                
                TextButton.MouseLeave:Connect(function()
                    game.TweenService:Create(TextButton, TweenInfo.new(0.18, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                        TextColor3 = Color3.fromRGB(180, 180, 200)
                    }):Play()
                    game.TweenService:Create(ButtonGlow, TweenInfo.new(0.18, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 1
                    }):Play()
                end)
            end

            function ItemHandling:Toggle(toggInfo, callback)
                local ToggleFrame = Instance.new("Frame")
                local toggleFrame = Instance.new("Frame")
                local TogCorner = Instance.new("UICorner")
                local checkBtn = Instance.new("ImageButton")
                local toggleInfo = Instance.new("TextLabel")
                local togInList = Instance.new("UIListLayout")
                local toginPad = Instance.new("UIPadding")
                local TogListLayout = Instance.new("UIListLayout")
                
                toggInfo = toggInfo or "Toggle"
                callback = callback or function() end

                ToggleFrame.Name = "ToggleFrame"
                ToggleFrame.Parent = sectionFrame
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                ToggleFrame.BackgroundTransparency = 1.000
                ToggleFrame.Size = UDim2.new(0, 365, 0, 36)

                toggleFrame.Name = "toggleFrame"
                toggleFrame.Parent = ToggleFrame
                toggleFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                toggleFrame.Size = UDim2.new(0, 365, 0, 36)
                toggleFrame.ZIndex = 2
                
                CreateGradient(toggleFrame, {
                    Color3.fromRGB(18, 18, 28),
                    Color3.fromRGB(25, 20, 35)
                }, 45)

                TogCorner.CornerRadius = UDim.new(0, 3)
                TogCorner.Parent = toggleFrame

                checkBtn.Name = "checkBtn"
                checkBtn.Parent = toggleFrame
                checkBtn.BackgroundTransparency = 1.000
                checkBtn.Position = UDim2.new(0.0191780813, 0, 0.138888896, 0)
                checkBtn.Size = UDim2.new(0, 25, 0, 25)
                checkBtn.ZIndex = 2
                checkBtn.Image = "rbxassetid://3926311105"
                checkBtn.ImageColor3 = Color3.fromRGB(97, 97, 117)
                checkBtn.ImageRectOffset = Vector2.new(940, 784)
                checkBtn.ImageRectSize = Vector2.new(48, 48)

                toggleInfo.Name = "toggleInfo"
                toggleInfo.Parent = toggleFrame
                toggleInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleInfo.BackgroundTransparency = 1.000
                toggleInfo.Position = UDim2.new(0.104109593, 0, 0, 0)
                toggleInfo.Size = UDim2.new(0.254794508, 162, 1, 0)
                toggleInfo.ZIndex = 2
                toggleInfo.Font = Enum.Font.GothamSemibold
                toggleInfo.Text = toggInfo
                toggleInfo.TextColor3 = Color3.fromRGB(97, 97, 117)
                toggleInfo.TextSize = 14.000
                toggleInfo.TextXAlignment = Enum.TextXAlignment.Left

                togInList.Name = "togInList"
                togInList.Parent = toggleFrame
                togInList.FillDirection = Enum.FillDirection.Horizontal
                togInList.SortOrder = Enum.SortOrder.LayoutOrder
                togInList.VerticalAlignment = Enum.VerticalAlignment.Center
                togInList.Padding = UDim.new(0, 5)

                toginPad.Name = "toginPad"
                toginPad.Parent = toggleFrame
                toginPad.PaddingLeft = UDim.new(0, 7)

                TogListLayout.Parent = ToggleFrame
                TogListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                TogListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                TogListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                local on = false
                local togDe = false
                
                checkBtn.MouseButton1Click:Connect(function()
                    if not togDe then
                        togDe = true
                        on = not on
                        callback(on)
                        
                        if on then
                            game.TweenService:Create(toggleInfo, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(153, 255, 238)}):Play()
                            game.TweenService:Create(checkBtn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(153, 255, 238)}):Play()
                            checkBtn.ImageRectOffset = Vector2.new(4, 836)
                        else
                            game.TweenService:Create(toggleInfo, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(97, 97, 117)}):Play()
                            game.TweenService:Create(checkBtn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(97, 97, 117)}):Play()
                            checkBtn.ImageRectOffset = Vector2.new(940, 784)
                        end
                        
                        wait(0.3)
                        togDe = false
                    end
                end)

                checkBtn.MouseButton1Up:Connect(function()
                    toggleFrame:TweenSize(UDim2.new(0, 365, 0, 36), "InOut", "Quint", 0.18, true)
                end)

                checkBtn.MouseButton1Down:Connect(function()
                    toggleFrame:TweenSize(UDim2.new(0, 359, 0, 30), "InOut", "Quint", 0.18, true)
                end)
            end

            function ItemHandling:Label(labelInfo)
                local TextLabelFrame = Instance.new("Frame")
                local LabelListLayout = Instance.new("UIListLayout")
                local TextLabel = Instance.new("TextLabel")
                local LabelCorner = Instance.new("UICorner")
                labelInfo = labelInfo or "Text Label"

                TextLabelFrame.Name = "TextLabelFrame"
                TextLabelFrame.Parent = sectionFrame
                TextLabelFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                TextLabelFrame.BackgroundTransparency = 1.000
                TextLabelFrame.Size = UDim2.new(0, 365, 0, 36)

                LabelListLayout.Parent = TextLabelFrame
                LabelListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                LabelListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                LabelListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                TextLabel.Parent = TextLabelFrame
                TextLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                TextLabel.Size = UDim2.new(0, 365, 0, 36)
                TextLabel.ZIndex = 2
                TextLabel.Font = Enum.Font.GothamSemibold
                TextLabel.Text = labelInfo
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextSize = 14.000
                
                CreateGradient(TextLabel, {
                    Color3.fromRGB(18, 18, 28),
                    Color3.fromRGB(25, 20, 35)
                }, 45)

                LabelCorner.CornerRadius = UDim.new(0, 5)
                LabelCorner.Parent = TextLabel
            end

            function ItemHandling:Credit(creditWho)
                local TextLabelFrame = Instance.new("Frame")
                local CreditListLayout = Instance.new("UIListLayout")
                local TextLabel = Instance.new("TextLabel")
                local CreditCorner = Instance.new("UICorner")
                creditWho = creditWho or "Credit"

                TextLabelFrame.Name = "TextLabelFrame"
                TextLabelFrame.Parent = sectionFrame
                TextLabelFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                TextLabelFrame.BackgroundTransparency = 1.000
                TextLabelFrame.Size = UDim2.new(0, 365, 0, 36)

                CreditListLayout.Parent = TextLabelFrame
                CreditListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                CreditListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                CreditListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                TextLabel.Parent = TextLabelFrame
                TextLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                TextLabel.Size = UDim2.new(0, 365, 0, 36)
                TextLabel.ZIndex = 2
                TextLabel.Font = Enum.Font.Gotham
                TextLabel.Text = "  "..creditWho
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextSize = 14.000
                TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                CreateGradient(TextLabel, {
                    Color3.fromRGB(18, 18, 28),
                    Color3.fromRGB(25, 20, 35)
                }, 45)

                CreditCorner.CornerRadius = UDim.new(0, 5)
                CreditCorner.Parent = TextLabel
            end

            function ItemHandling:Slider(slidInfo, minvalue, maxvalue, callback)
                local SliderFrame = Instance.new("Frame")
                local sliderFrame = Instance.new("Frame")
                local SliderCorner = Instance.new("UICorner")
                local sliderbtn = Instance.new("TextButton")
                local SliderBtnCorner = Instance.new("UICorner")
                local dragSlider = Instance.new("Frame")
                local DragCorner = Instance.new("UICorner")
                local sliderInfo = Instance.new("TextLabel")
                local SliderListLayout = Instance.new("UIListLayout")
                local sliderlist_2 = Instance.new("UIListLayout")
                
                slidInfo = slidInfo or "Slider"
                minvalue = minvalue or 0
                maxvalue = maxvalue or 100
                callback = callback or function() end

                SliderFrame.Name = "SliderFrame"
                SliderFrame.Parent = sectionFrame
                SliderFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                SliderFrame.BackgroundTransparency = 1.000
                SliderFrame.Size = UDim2.new(0, 365, 0, 36)

                sliderFrame.Name = "sliderFrame"
                sliderFrame.Parent = SliderFrame
                sliderFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                sliderFrame.Size = UDim2.new(0, 365, 0, 36)
                sliderFrame.ZIndex = 2
                
                CreateGradient(sliderFrame, {
                    Color3.fromRGB(18, 18, 28),
                    Color3.fromRGB(25, 20, 35)
                }, 45)

                SliderCorner.CornerRadius = UDim.new(0, 3)
                SliderCorner.Parent = sliderFrame

                sliderbtn.Name = "sliderbtn"
                sliderbtn.Parent = sliderFrame
                sliderbtn.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
                sliderbtn.Position = UDim2.new(0.0167808235, 0, 0.416333348, 0)
                sliderbtn.Size = UDim2.new(0, 150, 0, 6)
                sliderbtn.ZIndex = 2
                sliderbtn.AutoButtonColor = false
                sliderbtn.Font = Enum.Font.SourceSans
                sliderbtn.Text = ""
                sliderbtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                sliderbtn.TextSize = 14.000

                SliderBtnCorner.CornerRadius = UDim.new(0, 5)
                SliderBtnCorner.Parent = sliderbtn

                dragSlider.Name = "dragSlider"
                dragSlider.Parent = sliderbtn
                dragSlider.BackgroundColor3 = Color3.fromRGB(153, 255, 238)
                dragSlider.Size = UDim2.new(0, 0, 0, 6)
                dragSlider.ZIndex = 2
                
                CreateGradient(dragSlider, {
                    Color3.fromRGB(153, 255, 238),
                    Color3.fromRGB(255, 153, 238)
                }, 0)

                DragCorner.CornerRadius = UDim.new(0, 5)
                DragCorner.Parent = dragSlider

                sliderInfo.Name = "sliderInfo"
                sliderInfo.Parent = sliderFrame
                sliderInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderInfo.BackgroundTransparency = 1.000
                sliderInfo.Position = UDim2.new(0.466095895, 0, 0, 0)
                sliderInfo.Size = UDim2.new(0, 193, 0, 36)
                sliderInfo.ZIndex = 2
                sliderInfo.Font = Enum.Font.GothamSemibold
                sliderInfo.Text = slidInfo .. " [" .. minvalue .. "]"
                sliderInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
                sliderInfo.TextSize = 14.000
                sliderInfo.TextXAlignment = Enum.TextXAlignment.Left

                sliderlist_2.Name = "sliderlist"
                sliderlist_2.Parent = sliderFrame
                sliderlist_2.FillDirection = Enum.FillDirection.Horizontal
                sliderlist_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
                sliderlist_2.SortOrder = Enum.SortOrder.LayoutOrder
                sliderlist_2.VerticalAlignment = Enum.VerticalAlignment.Center
                sliderlist_2.Padding = UDim.new(0, 8)

                SliderListLayout.Parent = SliderFrame
                SliderListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                SliderListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                SliderListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                local mouse = game.Players.LocalPlayer:GetMouse()
                local uis = game:GetService("UserInputService")
                local Value;

                sliderbtn.MouseButton1Down:Connect(function()
                    Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 150) * dragSlider.AbsoluteSize.X) + tonumber(minvalue)) or 0
                    pcall(function()
                        callback(Value)
                    end)
                    sliderInfo.Text = slidInfo .. " [" .. Value .. "]"
                    dragSlider.Size = UDim2.new(0, math.clamp(mouse.X - dragSlider.AbsolutePosition.X, 0, 150), 0, 6)
                    
                    local moveconnection
                    local releaseconnection
                    
                    moveconnection = mouse.Move:Connect(function()
                        Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 150) * dragSlider.AbsoluteSize.X) + tonumber(minvalue))
                        pcall(function()
                            callback(Value)
                        end)
                        sliderInfo.Text = slidInfo .. " [" .. Value .. "]"
                        dragSlider.Size = UDim2.new(0, math.clamp(mouse.X - dragSlider.AbsolutePosition.X, 0, 150), 0, 6)
                    end)
                    
                    releaseconnection = uis.InputEnded:Connect(function(Mouse)
                        if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
                            Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 150) * dragSlider.AbsoluteSize.X) + tonumber(minvalue))
                            pcall(function()
                                callback(Value)
                            end)
                            sliderInfo.Text = slidInfo .. " [" .. Value .. "]"
                            moveconnection:Disconnect()
                            releaseconnection:Disconnect()
                        end
                    end)
                end)
            end

            return ItemHandling
        end
        
        return sectionHandling
    end
    
    -- Показываем уведомление при загрузке
    CreateNotification("GUI Loaded", libName .. " успешно загружен!", 3)
    
    return TabHandling
end

return Luxt1
