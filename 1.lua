local Luxt1 = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

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

local function CreateParticles(parent)
    local ParticlesFrame = Instance.new("Frame")
    ParticlesFrame.Name = "ParticlesFrame"
    ParticlesFrame.Parent = parent
    ParticlesFrame.BackgroundTransparency = 1
    ParticlesFrame.Size = UDim2.new(1, 0, 1, 0)
    ParticlesFrame.ZIndex = 1
    ParticlesFrame.ClipsDescendants = true
    
    for i = 1, 12 do
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
                if Particle and Particle.Parent then
                    local newPos = UDim2.new(math.random(), 0, math.random(), 0)
                    TweenService:Create(Particle, TweenInfo.new(math.random(3, 6), Enum.EasingStyle.Sine), {
                        Position = newPos,
                        BackgroundTransparency = math.random(50, 90) / 100
                    }):Play()
                end
            end
        end)
    end
end

function Luxt1.CreateWindow(libName, logoId)
    libName = libName or "LuxtLib"
    logoId = logoId or ""
    
    local LuxtLib = Instance.new("ScreenGui")
    LuxtLib.Name = "LuxtLib"..libName
    LuxtLib.Parent = game.CoreGui
    LuxtLib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Notification Holder
    local NotificationHolder = Instance.new("Frame")
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
    
    local function CreateNotification(title, text, duration)
        local Notification = Instance.new("Frame")
        Notification.Parent = NotificationHolder
        Notification.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        Notification.Size = UDim2.new(1, 0, 0, 0)
        Notification.ClipsDescendants = true
        Notification.ZIndex = 100
        
        CreateGradient(Notification, {
            Color3.fromRGB(30, 20, 40),
            Color3.fromRGB(20, 30, 50)
        }, 45)
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 8)
        NotifCorner.Parent = Notification
        
        local NotifBar = Instance.new("Frame")
        NotifBar.Parent = Notification
        NotifBar.BackgroundColor3 = Color3.fromRGB(153, 255, 238)
        NotifBar.Size = UDim2.new(0, 3, 1, 0)
        NotifBar.BorderSizePixel = 0
        NotifBar.ZIndex = 101
        
        local NotifTitle = Instance.new("TextLabel")
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
        
        local NotifText = Instance.new("TextLabel")
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
        
        local NotifClose = Instance.new("TextButton")
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
            if Notification and Notification.Parent then
                Notification:Destroy()
            end
        end
        
        NotifClose.MouseButton1Click:Connect(CloseNotif)
        
        spawn(function()
            wait(duration or 5)
            CloseNotif()
        end)
    end

    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "shadow"
    shadow.Parent = LuxtLib
    shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.32, 0, 0.17, 0)
    shadow.Size = UDim2.new(0, 609, 0, 530)
    shadow.ZIndex = 0
    shadow.Image = "http://www.roblox.com/asset/?id=6105530152"
    shadow.ImageColor3 = Color3.fromRGB(100, 50, 150)
    shadow.ImageTransparency = 0.2

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = shadow
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.Position = UDim2.new(0.048, 0, 0.075, 0)
    MainFrame.Size = UDim2.new(0, 553, 0, 452)
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 5)
    MainCorner.Parent = MainFrame
    
    CreateGradient(MainFrame, {
        Color3.fromRGB(20, 20, 30),
        Color3.fromRGB(35, 25, 45),
        Color3.fromRGB(25, 35, 50)
    }, 45)
    
    CreateParticles(MainFrame)

    -- Side Panel
    local sideHeading = Instance.new("Frame")
    sideHeading.Name = "sideHeading"
    sideHeading.Parent = MainFrame
    sideHeading.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    sideHeading.Size = UDim2.new(0, 155, 0, 452)
    sideHeading.ZIndex = 2
    
    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 5)
    SideCorner.Parent = sideHeading
    
    CreateGradient(sideHeading, {
        Color3.fromRGB(10, 10, 20),
        Color3.fromRGB(25, 15, 35),
        Color3.fromRGB(15, 25, 40)
    }, 90)

    local sideCover = Instance.new("Frame")
    sideCover.Name = "sideCover"
    sideCover.Parent = sideHeading
    sideCover.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    sideCover.BorderSizePixel = 0
    sideCover.Position = UDim2.new(0.91, 0, 0, 0)
    sideCover.Size = UDim2.new(0, 14, 0, 452)

    -- Logo
    local hubLogo = Instance.new("ImageLabel")
    hubLogo.Name = "hubLogo"
    hubLogo.Parent = sideHeading
    hubLogo.BackgroundColor3 = Color3.fromRGB(153, 255, 238)
    hubLogo.Position = UDim2.new(0.057, 0, 0.024, 0)
    hubLogo.Size = UDim2.new(0, 30, 0, 30)
    hubLogo.ZIndex = 2
    hubLogo.Image = "rbxassetid://"..tostring(logoId)
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 999)
    LogoCorner.Parent = hubLogo

    -- Hub Name
    local hubName = Instance.new("TextLabel")
    hubName.Name = "hubName"
    hubName.Parent = sideHeading
    hubName.BackgroundTransparency = 1
    hubName.Position = UDim2.new(0.29, 0, 0.03, 0)
    hubName.Size = UDim2.new(0, 110, 0, 16)
    hubName.ZIndex = 2
    hubName.Font = Enum.Font.GothamSemibold
    hubName.Text = libName
    hubName.TextColor3 = Color3.fromRGB(153, 255, 238)
    hubName.TextSize = 14
    hubName.TextWrapped = true
    hubName.TextXAlignment = Enum.TextXAlignment.Left

    -- Username
    local usename = Instance.new("TextLabel")
    usename.Name = "usename"
    usename.Parent = sideHeading
    usename.BackgroundTransparency = 1
    usename.Position = UDim2.new(0.29, 0, 0.07, 0)
    usename.Size = UDim2.new(0, 110, 0, 16)
    usename.ZIndex = 2
    usename.Font = Enum.Font.GothamSemibold
    usename.Text = Players.LocalPlayer.Name
    usename.TextColor3 = Color3.fromRGB(103, 172, 161)
    usename.TextSize = 12
    usename.TextWrapped = true
    usename.TextXAlignment = Enum.TextXAlignment.Left

    -- Tab Frame
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = "tabFrame"
    tabFrame.Parent = sideHeading
    tabFrame.Active = true
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.Position = UDim2.new(0.076, 0, 0.126, 0)
    tabFrame.Size = UDim2.new(0, 135, 0, 347)
    tabFrame.ZIndex = 2
    tabFrame.ScrollBarThickness = 0
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = tabFrame
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)

    -- Wave Effect
    local wave = Instance.new("ImageLabel")
    wave.Name = "wave"
    wave.Parent = MainFrame
    wave.BackgroundTransparency = 1
    wave.Position = UDim2.new(0.021, 0, 0, 0)
    wave.Size = UDim2.new(0.979, 0, 0.558, 0)
    wave.Image = "http://www.roblox.com/asset/?id=6087537285"
    wave.ImageColor3 = Color3.fromRGB(181, 249, 255)
    wave.ImageTransparency = 0.5
    wave.ScaleType = Enum.ScaleType.Slice
    
    local WaveCorner = Instance.new("UICorner")
    WaveCorner.CornerRadius = UDim.new(0, 3)
    WaveCorner.Parent = wave
    
    CreateGradient(wave, {
        Color3.fromRGB(153, 255, 238),
        Color3.fromRGB(255, 153, 238),
        Color3.fromRGB(153, 200, 255)
    }, 45)

    -- Frames Container
    local framesAll = Instance.new("Frame")
    framesAll.Name = "framesAll"
    framesAll.Parent = MainFrame
    framesAll.BackgroundTransparency = 1
    framesAll.BorderSizePixel = 0
    framesAll.Position = UDim2.new(0.297, 0, 0.024, 0)
    framesAll.Size = UDim2.new(0, 381, 0, 431)
    framesAll.ZIndex = 2

    local pageFolder = Instance.new("Folder")
    pageFolder.Name = "pageFolder"
    pageFolder.Parent = framesAll

    -- Keybind Button
    local key1 = Instance.new("TextButton")
    key1.Name = "key1"
    key1.Parent = sideHeading
    key1.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    key1.Position = UDim2.new(0.051, 0, 0.935, 0)
    key1.Size = UDim2.new(0, 76, 0, 22)
    key1.ZIndex = 2
    key1.Font = Enum.Font.GothamSemibold
    key1.Text = "LeftAlt"
    key1.TextColor3 = Color3.fromRGB(153, 255, 238)
    key1.TextSize = 14
    
    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 5)
    KeyCorner.Parent = key1

    local keybindInfo1 = Instance.new("TextLabel")
    keybindInfo1.Name = "keybindInfo"
    keybindInfo1.Parent = sideHeading
    keybindInfo1.BackgroundTransparency = 1
    keybindInfo1.Position = UDim2.new(0.585, 0, 0.935, 0)
    keybindInfo1.Size = UDim2.new(0, 50, 0, 22)
    keybindInfo1.ZIndex = 2
    keybindInfo1.Font = Enum.Font.GothamSemibold
    keybindInfo1.Text = "Close"
    keybindInfo1.TextColor3 = Color3.fromRGB(255, 255, 255)
    keybindInfo1.TextSize = 13
    keybindInfo1.TextXAlignment = Enum.TextXAlignment.Left

    local oldKey = Enum.KeyCode.LeftAlt.Name

    key1.MouseButton1Click:Connect(function() 
        key1.Text = ". . ."
        local input = UserInputService.InputBegan:Wait()
        if input.KeyCode.Name ~= "Unknown" then
            key1.Text = input.KeyCode.Name
            oldKey = input.KeyCode.Name
        end
    end)

    UserInputService.InputBegan:Connect(function(current, gameProcessed) 
        if not gameProcessed then 
            if current.KeyCode.Name == oldKey then 
                LuxtLib.Enabled = not LuxtLib.Enabled
            end
        end
    end)

    -- Dragging
    local Camera = workspace:WaitForChild("Camera")
    local DragMousePosition
    local FramePosition
    local Draggable = false
    
    sideHeading.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Draggable = true
            DragMousePosition = Vector2.new(input.Position.X, input.Position.Y)
            FramePosition = Vector2.new(shadow.Position.X.Scale, shadow.Position.Y.Scale)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if Draggable then
            local NewPosition = FramePosition + ((Vector2.new(input.Position.X, input.Position.Y) - DragMousePosition) / Camera.ViewportSize)
            shadow.Position = UDim2.new(NewPosition.X, 0, NewPosition.Y, 0)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Draggable = false
        end
    end)

    -- Return Object
    local TabHandling = {}
    TabHandling.Notify = CreateNotification

    function TabHandling:Tab(tabText, tabId)
        tabText = tabText or "Tab"
        tabId = tabId or ""
        
        local tabBtnFrame = Instance.new("Frame")
        tabBtnFrame.Name = "tabBtnFrame"
        tabBtnFrame.Parent = tabFrame
        tabBtnFrame.BackgroundTransparency = 1
        tabBtnFrame.Size = UDim2.new(0, 135, 0, 30)
        tabBtnFrame.ZIndex = 2
        
        local TabGlow = Instance.new("Frame")
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

        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "tabBtn"
        tabBtn.Parent = tabBtnFrame
        tabBtn.BackgroundTransparency = 1
        tabBtn.Position = UDim2.new(0.246, 0, 0, 0)
        tabBtn.Size = UDim2.new(0, 101, 0, 30)
        tabBtn.ZIndex = 2
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.Text = tabText
        tabBtn.TextColor3 = Color3.fromRGB(153, 255, 238)
        tabBtn.TextSize = 14
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left

        local tabLogo = Instance.new("ImageLabel")
        tabLogo.Name = "tabLogo"
        tabLogo.Parent = tabBtnFrame
        tabLogo.BackgroundTransparency = 1
        tabLogo.Position = UDim2.new(-0.007, 0, 0.067, 0)
        tabLogo.Size = UDim2.new(0, 25, 0, 25)
        tabLogo.ZIndex = 2
        tabLogo.Image = "rbxassetid://"..tostring(tabId)
        tabLogo.ImageColor3 = Color3.fromRGB(153, 255, 238)

        local newPage = Instance.new("ScrollingFrame")
        newPage.Name = "newPage"..tabText
        newPage.Parent = pageFolder
        newPage.Active = true
        newPage.BackgroundTransparency = 1
        newPage.BorderSizePixel = 0
        newPage.Size = UDim2.new(1, 0, 1, 0)
        newPage.ZIndex = 2
        newPage.ScrollBarThickness = 0
        newPage.Visible = false
        
        local sectionList = Instance.new("UIListLayout")
        sectionList.Name = "sectionList"
        sectionList.Parent = newPage
        sectionList.SortOrder = Enum.SortOrder.LayoutOrder
        sectionList.Padding = UDim.new(0, 3)

        local function UpdateSize()
            local cS = sectionList.AbsoluteContentSize
            TweenService:Create(newPage, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {
                CanvasSize = UDim2.new(0, cS.X, 0, cS.Y)
            }):Play()
        end
        
        UpdateSize()
        newPage.ChildAdded:Connect(UpdateSize)
        newPage.ChildRemoved:Connect(UpdateSize)

        tabBtn.MouseButton1Click:Connect(function()
            UpdateSize()
            for _, v in pairs(pageFolder:GetChildren()) do
                v.Visible = false
            end
            newPage.Visible = true
            
            for _, v in pairs(tabFrame:GetChildren()) do
                if v:IsA("Frame") then
                    if v:FindFirstChild("TabGlow") then
                        TweenService:Create(v.TabGlow, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
                            BackgroundTransparency = 1
                        }):Play()
                    end
                    
                    for _, child in pairs(v:GetChildren()) do
                        if child:IsA("TextButton") then
                            TweenService:Create(child, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
                                TextColor3 = Color3.fromRGB(80, 80, 100)
                            }):Play()
                        end
                        if child:IsA("ImageLabel") and child.Name == "tabLogo" then
                            TweenService:Create(child, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
                                ImageColor3 = Color3.fromRGB(80, 80, 100)
                            }):Play()
                        end
                    end
                end
            end
            
            TweenService:Create(TabGlow, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
                BackgroundTransparency = 0.85
            }):Play()
            TweenService:Create(tabLogo, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
                ImageColor3 = Color3.fromRGB(153, 255, 238)
            }):Play()
            TweenService:Create(tabBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
                TextColor3 = Color3.fromRGB(153, 255, 238)
            }):Play()
        end)

        local sectionHandling = {}

        function sectionHandling:Section(sectionText)
            sectionText = sectionText or "Section"
            local isDropped = false
            
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = newPage
            sectionFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
            sectionFrame.Size = UDim2.new(1, 0, 0, 36)
            sectionFrame.ZIndex = 2
            sectionFrame.ClipsDescendants = true
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 5)
            SectionCorner.Parent = sectionFrame
            
            CreateGradient(sectionFrame, {
                Color3.fromRGB(20, 15, 30),
                Color3.fromRGB(15, 20, 35)
            }, 90)
            
            local sectionInnerList = Instance.new("UIListLayout")
            sectionInnerList.Name = "sectionInnerList"
            sectionInnerList.Parent = sectionFrame
            sectionInnerList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            sectionInnerList.SortOrder = Enum.SortOrder.LayoutOrder
            sectionInnerList.Padding = UDim.new(0, 3)

            local mainSectionHead = Instance.new("Frame")
            mainSectionHead.Name = "mainSectionHead"
            mainSectionHead.Parent = sectionFrame
            mainSectionHead.BackgroundTransparency = 1
            mainSectionHead.Size = UDim2.new(0, 381, 0, 36)

            local sectionName = Instance.new("TextLabel")
            sectionName.Name = "sectionName"
            sectionName.Parent = mainSectionHead
            sectionName.BackgroundTransparency = 1
            sectionName.Position = UDim2.new(0.024, 0, 0, 0)
            sectionName.Size = UDim2.new(0, 302, 0, 36)
            sectionName.Font = Enum.Font.GothamSemibold
            sectionName.Text = sectionText
            sectionName.TextColor3 = Color3.fromRGB(153, 255, 238)
            sectionName.TextSize = 14
            sectionName.TextXAlignment = Enum.TextXAlignment.Left

            local sectionExpand = Instance.new("ImageButton")
            sectionExpand.Name = "sectionExpand"
            sectionExpand.Parent = mainSectionHead
            sectionExpand.BackgroundTransparency = 1
            sectionExpand.Position = UDim2.new(0.919, 0, 0.139, 0)
            sectionExpand.Size = UDim2.new(0, 25, 0, 25)
            sectionExpand.ZIndex = 2
            sectionExpand.Image = "rbxassetid://3926305904"
            sectionExpand.ImageColor3 = Color3.fromRGB(153, 255, 238)
            sectionExpand.ImageRectOffset = Vector2.new(564, 284)
            sectionExpand.ImageRectSize = Vector2.new(36, 36)
            
            sectionExpand.MouseButton1Click:Connect(function()
                if isDropped then
                    isDropped = false
                    sectionFrame:TweenSize(UDim2.new(1, 0, 0, 36), "In", "Quint", 0.10)
                    TweenService:Create(sectionExpand, TweenInfo.new(0.10, Enum.EasingStyle.Quad), {
                        Rotation = 0
                    }):Play()
                else
                    isDropped = true
                    sectionFrame:TweenSize(UDim2.new(1, 0, 0, sectionInnerList.AbsoluteContentSize.Y + 5), "In", "Quint", 0.10)
                    TweenService:Create(sectionExpand, TweenInfo.new(0.10, Enum.EasingStyle.Quad), {
                        Rotation = 180
                    }):Play()
                end
                wait(0.10)
                UpdateSize()
            end)

            local ItemHandling = {}

            function ItemHandling:Button(btnText, callback)
                btnText = btnText or "Button"
                callback = callback or function() end
                
                local ButtonFrame = Instance.new("Frame")
                ButtonFrame.Name = "ButtonFrame"
                ButtonFrame.Parent = sectionFrame
                ButtonFrame.BackgroundTransparency = 1
                ButtonFrame.Size = UDim2.new(0, 365, 0, 36)
                
                local BtnListLayout = Instance.new("UIListLayout")
                BtnListLayout.Parent = ButtonFrame
                BtnListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                BtnListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                local TextButton = Instance.new("TextButton")
                TextButton.Parent = ButtonFrame
                TextButton.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                TextButton.Size = UDim2.new(0, 365, 0, 36)
                TextButton.ZIndex = 2
                TextButton.AutoButtonColor = false
                TextButton.Text = btnText
                TextButton.Font = Enum.Font.GothamSemibold
                TextButton.TextColor3 = Color3.fromRGB(180, 180, 200)
                TextButton.TextSize = 14
                
                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 3)
                BtnCorner.Parent = TextButton
                
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

                TextButton.MouseEnter:Connect(function()
                    TweenService:Create(TextButton, TweenInfo.new(0.18), {
                        TextColor3 = Color3.fromRGB(250, 250, 255)
                    }):Play()
                end)
                
                TextButton.MouseLeave:Connect(function()
                    TweenService:Create(TextButton, TweenInfo.new(0.18), {
                        TextColor3 = Color3.fromRGB(180, 180, 200)
                    }):Play()
                end)
                
                TextButton.MouseButton1Down:Connect(function()
                    TextButton:TweenSize(UDim2.new(0, 359, 0, 30), "InOut", "Quint", 0.18, true)
                end)
                
                TextButton.MouseButton1Up:Connect(function()
                    TextButton:TweenSize(UDim2.new(0, 365, 0, 36), "InOut", "Quint", 0.18, true)
                end)
            end

            function ItemHandling:Toggle(toggInfo, callback)
                toggInfo = toggInfo or "Toggle"
                callback = callback or function() end
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = "ToggleFrame"
                ToggleFrame.Parent = sectionFrame
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Size = UDim2.new(0, 365, 0, 36)
                
                local TogListLayout = Instance.new("UIListLayout")
                TogListLayout.Parent = ToggleFrame
                TogListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                TogListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                local toggleFrame = Instance.new("Frame")
                toggleFrame.Name = "toggleFrame"
                toggleFrame.Parent = ToggleFrame
                toggleFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                toggleFrame.Size = UDim2.new(0, 365, 0, 36)
                toggleFrame.ZIndex = 2
                
                local TogCorner = Instance.new("UICorner")
                TogCorner.CornerRadius = UDim.new(0, 3)
                TogCorner.Parent = toggleFrame
                
                CreateGradient(toggleFrame, {
                    Color3.fromRGB(18, 18, 28),
                    Color3.fromRGB(25, 20, 35)
                }, 45)
                
                local toginPad = Instance.new("UIPadding")
                toginPad.Parent = toggleFrame
                toginPad.PaddingLeft = UDim.new(0, 7)
                
                local togInList = Instance.new("UIListLayout")
                togInList.Parent = toggleFrame
                togInList.FillDirection = Enum.FillDirection.Horizontal
                togInList.VerticalAlignment = Enum.VerticalAlignment.Center
                togInList.Padding = UDim.new(0, 5)

                local checkBtn = Instance.new("ImageButton")
                checkBtn.Name = "checkBtn"
                checkBtn.Parent = toggleFrame
                checkBtn.BackgroundTransparency = 1
                checkBtn.Size = UDim2.new(0, 25, 0, 25)
                checkBtn.ZIndex = 2
                checkBtn.Image = "rbxassetid://3926311105"
                checkBtn.ImageColor3 = Color3.fromRGB(97, 97, 117)
                checkBtn.ImageRectOffset = Vector2.new(940, 784)
                checkBtn.ImageRectSize = Vector2.new(48, 48)

                local toggleInfo = Instance.new("TextLabel")
                toggleInfo.Name = "toggleInfo"
                toggleInfo.Parent = toggleFrame
                toggleInfo.BackgroundTransparency = 1
                toggleInfo.Size = UDim2.new(0, 300, 0, 36)
                toggleInfo.ZIndex = 2
                toggleInfo.Font = Enum.Font.GothamSemibold
                toggleInfo.Text = toggInfo
                toggleInfo.TextColor3 = Color3.fromRGB(97, 97, 117)
                toggleInfo.TextSize = 14
                toggleInfo.TextXAlignment = Enum.TextXAlignment.Left

                local on = false
                local togDe = false
                
                checkBtn.MouseButton1Click:Connect(function()
                    if not togDe then
                        togDe = true
                        on = not on
                        callback(on)
                        
                        if on then
                            TweenService:Create(toggleInfo, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(153, 255, 238)}):Play()
                            TweenService:Create(checkBtn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(153, 255, 238)}):Play()
                            checkBtn.ImageRectOffset = Vector2.new(4, 836)
                        else
                            TweenService:Create(toggleInfo, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(97, 97, 117)}):Play()
                            TweenService:Create(checkBtn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(97, 97, 117)}):Play()
                            checkBtn.ImageRectOffset = Vector2.new(940, 784)
                        end
                        
                        wait(0.3)
                        togDe = false
                    end
                end)
            end

            function ItemHandling:Label(labelInfo)
                labelInfo = labelInfo or "Label"
                
                local LabelFrame = Instance.new("Frame")
                LabelFrame.Name = "LabelFrame"
                LabelFrame.Parent = sectionFrame
                LabelFrame.BackgroundTransparency = 1
                LabelFrame.Size = UDim2.new(0, 365, 0, 36)
                
                local LabelListLayout = Instance.new("UIListLayout")
                LabelListLayout.Parent = LabelFrame
                LabelListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                LabelListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                local TextLabel = Instance.new("TextLabel")
                TextLabel.Parent = LabelFrame
                TextLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                TextLabel.Size = UDim2.new(0, 365, 0, 36)
                TextLabel.ZIndex = 2
                TextLabel.Font = Enum.Font.GothamSemibold
                TextLabel.Text = labelInfo
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextSize = 14
                
                local LabelCorner = Instance.new("UICorner")
                LabelCorner.CornerRadius = UDim.new(0, 5)
                LabelCorner.Parent = TextLabel
                
                CreateGradient(TextLabel, {
                    Color3.fromRGB(18, 18, 28),
                    Color3.fromRGB(25, 20, 35)
                }, 45)
            end

            function ItemHandling:Credit(creditWho)
                creditWho = creditWho or "Credit"
                
                local CreditFrame = Instance.new("Frame")
                CreditFrame.Name = "CreditFrame"
                CreditFrame.Parent = sectionFrame
                CreditFrame.BackgroundTransparency = 1
                CreditFrame.Size = UDim2.new(0, 365, 0, 36)
                
                local CreditListLayout = Instance.new("UIListLayout")
                CreditListLayout.Parent = CreditFrame
                CreditListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                CreditListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                local TextLabel = Instance.new("TextLabel")
                TextLabel.Parent = CreditFrame
                TextLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                TextLabel.Size = UDim2.new(0, 365, 0, 36)
                TextLabel.ZIndex = 2
                TextLabel.Font = Enum.Font.Gotham
                TextLabel.Text = "  "..creditWho
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextSize = 14
                TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local CreditCorner = Instance.new("UICorner")
                CreditCorner.CornerRadius = UDim.new(0, 5)
                CreditCorner.Parent = TextLabel
                
                CreateGradient(TextLabel, {
                    Color3.fromRGB(18, 18, 28),
                    Color3.fromRGB(25, 20, 35)
                }, 45)
            end

            function ItemHandling:Slider(slidInfo, minvalue, maxvalue, callback)
                slidInfo = slidInfo or "Slider"
                minvalue = minvalue or 0
                maxvalue = maxvalue or 100
                callback = callback or function() end
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = "SliderFrame"
                SliderFrame.Parent = sectionFrame
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Size = UDim2.new(0, 365, 0, 36)
                
                local SliderListLayout = Instance.new("UIListLayout")
                SliderListLayout.Parent = SliderFrame
                SliderListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                SliderListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = "sliderFrame"
                sliderFrame.Parent = SliderFrame
                sliderFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
                sliderFrame.Size = UDim2.new(0, 365, 0, 36)
                sliderFrame.ZIndex = 2
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 3)
                SliderCorner.Parent = sliderFrame
                
                CreateGradient(sliderFrame, {
                    Color3.fromRGB(18, 18, 28),
                    Color3.fromRGB(25, 20, 35)
                }, 45)
                
                local sliderlist = Instance.new("UIListLayout")
                sliderlist.Parent = sliderFrame
                sliderlist.FillDirection = Enum.FillDirection.Horizontal
                sliderlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
                sliderlist.VerticalAlignment = Enum.VerticalAlignment.Center
                sliderlist.Padding = UDim.new(0, 8)

                local sliderbtn = Instance.new("TextButton")
                sliderbtn.Name = "sliderbtn"
                sliderbtn.Parent = sliderFrame
                sliderbtn.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
                sliderbtn.Size = UDim2.new(0, 150, 0, 6)
                sliderbtn.ZIndex = 2
                sliderbtn.AutoButtonColor = false
                sliderbtn.Text = ""
                
                local SliderBtnCorner = Instance.new("UICorner")
                SliderBtnCorner.CornerRadius = UDim.new(0, 5)
                SliderBtnCorner.Parent = sliderbtn

                local dragSlider = Instance.new("Frame")
                dragSlider.Name = "dragSlider"
                dragSlider.Parent = sliderbtn
                dragSlider.BackgroundColor3 = Color3.fromRGB(153, 255, 238)
                dragSlider.Size = UDim2.new(0, 0, 0, 6)
                dragSlider.ZIndex = 2
                
                local DragCorner = Instance.new("UICorner")
                DragCorner.CornerRadius = UDim.new(0, 5)
                DragCorner.Parent = dragSlider
                
                CreateGradient(dragSlider, {
                    Color3.fromRGB(153, 255, 238),
                    Color3.fromRGB(255, 153, 238)
                }, 0)

                local sliderInfo = Instance.new("TextLabel")
                sliderInfo.Name = "sliderInfo"
                sliderInfo.Parent = sliderFrame
                sliderInfo.BackgroundTransparency = 1
                sliderInfo.Size = UDim2.new(0, 193, 0, 36)
                sliderInfo.ZIndex = 2
                sliderInfo.Font = Enum.Font.GothamSemibold
                sliderInfo.Text = slidInfo .. " [" .. minvalue .. "]"
                sliderInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
                sliderInfo.TextSize = 14
                sliderInfo.TextXAlignment = Enum.TextXAlignment.Left

                local mouse = Players.LocalPlayer:GetMouse()

                sliderbtn.MouseButton1Down:Connect(function()
                    local Value = math.floor((((maxvalue - minvalue) / 150) * dragSlider.AbsoluteSize.X) + minvalue)
                    pcall(function() callback(Value) end)
                    sliderInfo.Text = slidInfo .. " [" .. Value .. "]"
                    dragSlider.Size = UDim2.new(0, math.clamp(mouse.X - dragSlider.AbsolutePosition.X, 0, 150), 0, 6)
                    
                    local moveConn, releaseConn
                    
                    moveConn = mouse.Move:Connect(function()
                        Value = math.floor((((maxvalue - minvalue) / 150) * dragSlider.AbsoluteSize.X) + minvalue)
                        pcall(function() callback(Value) end)
                        sliderInfo.Text = slidInfo .. " [" .. Value .. "]"
                        dragSlider.Size = UDim2.new(0, math.clamp(mouse.X - dragSlider.AbsolutePosition.X, 0, 150), 0, 6)
                    end)
                    
                    releaseConn = UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Value = math.floor((((maxvalue - minvalue) / 150) * dragSlider.AbsoluteSize.X) + minvalue)
                            pcall(function() callback(Value) end)
                            sliderInfo.Text = slidInfo .. " [" .. Value .. "]"
                            moveConn:Disconnect()
                            releaseConn:Disconnect()
                        end
                    end)
                end)
            end

            return ItemHandling
        end
        
        return sectionHandling
    end
    
    CreateNotification("GUI Loaded", libName .. " успешно загружен!", 3)
    
    return TabHandling
end

return Luxt1
