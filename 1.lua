local Luxt1 = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- Глобальные настройки темы
local Theme = {
    MainBg = Color3.fromRGB(25, 25, 25),
    SideBg = Color3.fromRGB(18, 18, 18),
    Primary = Color3.fromRGB(153, 255, 238), -- Неоновый голубой
    ItemBg = Color3.fromRGB(30, 30, 30),
    ItemHover = Color3.fromRGB(40, 40, 40),
    Stroke = Color3.fromRGB(45, 45, 45),
    Text = Color3.fromRGB(240, 240, 240),
    TextMuted = Color3.fromRGB(150, 150, 150)
}

-- Функция для быстрого создания Tween-анимаций
local function Tween(instance, properties, duration)
    duration = duration or 0.2
    local tween = TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

function Luxt1.CreateWindow(libName, logoId)
    local LuxtLib = Instance.new("ScreenGui")
    local shadow = Instance.new("ImageLabel")
    local MainFrame = Instance.new("Frame")
    local sideHeading = Instance.new("Frame")
    local sideCover = Instance.new("Frame")
    local hubLogo = Instance.new("ImageLabel")
    local hubName = Instance.new("TextLabel")
    local tabFrame = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local username = Instance.new("TextLabel")
    local wave = Instance.new("ImageLabel")
    local framesAll = Instance.new("Frame")
    local pageFolder = Instance.new("Folder")
    
    local key1 = Instance.new("TextButton")
    local keybindInfo1 = Instance.new("TextLabel")

    libName = libName or "LuxtLib"
    logoId = logoId or "13042861502"

    LuxtLib.Name = "LuxtLib_" .. libName
    LuxtLib.Parent = CoreGui
    LuxtLib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    shadow.Name = "shadow"
    shadow.Parent = LuxtLib
    shadow.BackgroundTransparency = 1.000
    shadow.Position = UDim2.new(0.5, -304, 0.5, -265)
    shadow.Size = UDim2.new(0, 609, 0, 530)
    shadow.Image = "http://www.roblox.com/asset/?id=6105530152"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.3

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = shadow
    MainFrame.BackgroundColor3 = Theme.MainBg
    MainFrame.Position = UDim2.new(0.048, 0, 0.075, 0)
    MainFrame.Size = UDim2.new(0, 553, 0, 452)
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
    
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Theme.Stroke
    MainStroke.Thickness = 1

    sideHeading.Name = "sideHeading"
    sideHeading.Parent = MainFrame
    sideHeading.BackgroundColor3 = Theme.SideBg
    sideHeading.Size = UDim2.new(0, 155, 0, 452)
    Instance.new("UICorner", sideHeading).CornerRadius = UDim.new(0, 6)

    sideCover.Name = "sideCover"
    sideCover.Parent = sideHeading
    sideCover.BackgroundColor3 = Theme.SideBg
    sideCover.BorderSizePixel = 0
    sideCover.Position = UDim2.new(1, -10, 0, 0)
    sideCover.Size = UDim2.new(0, 10, 0, 452)

    hubLogo.Name = "hubLogo"
    hubLogo.Parent = sideHeading
    hubLogo.BackgroundTransparency = 1
    hubLogo.Position = UDim2.new(0, 10, 0, 10)
    hubLogo.Size = UDim2.new(0, 30, 0, 30)
    hubLogo.Image = "rbxassetid://" .. logoId
    Instance.new("UICorner", hubLogo).CornerRadius = UDim.new(1, 0)

    hubName.Name = "hubName"
    hubName.Parent = sideHeading
    hubName.BackgroundTransparency = 1.000
    hubName.Position = UDim2.new(0, 48, 0, 12)
    hubName.Size = UDim2.new(0, 100, 0, 16)
    hubName.Font = Enum.Font.GothamBold
    hubName.Text = libName
    hubName.TextColor3 = Theme.Primary
    hubName.TextSize = 14.000
    hubName.TextXAlignment = Enum.TextXAlignment.Left

    username.Name = "username"
    username.Parent = sideHeading
    username.BackgroundTransparency = 1.000
    username.Position = UDim2.new(0, 48, 0, 28)
    username.Size = UDim2.new(0, 100, 0, 16)
    username.Font = Enum.Font.Gotham
    username.Text = Players.LocalPlayer.Name
    username.TextColor3 = Theme.TextMuted
    username.TextSize = 11.000
    username.TextXAlignment = Enum.TextXAlignment.Left

    tabFrame.Name = "tabFrame"
    tabFrame.Parent = sideHeading
    tabFrame.BackgroundTransparency = 1.000
    tabFrame.Position = UDim2.new(0, 10, 0, 60)
    tabFrame.Size = UDim2.new(0, 135, 0, 340)
    tabFrame.ScrollBarThickness = 0

    UIListLayout.Parent = tabFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    -- Настройки скрытия UI (Toggle UI Keybind)
    key1.Name = "key1"
    key1.Parent = sideHeading
    key1.BackgroundColor3 = Theme.ItemBg
    key1.Position = UDim2.new(0, 10, 1, -35)
    key1.Size = UDim2.new(0, 70, 0, 25)
    key1.Font = Enum.Font.GothamSemibold
    key1.Text = "LeftAlt"
    key1.TextColor3 = Theme.Primary
    key1.TextSize = 12.000
    Instance.new("UICorner", key1).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", key1).Color = Theme.Stroke

    keybindInfo1.Name = "keybindInfo"
    keybindInfo1.Parent = sideHeading
    keybindInfo1.BackgroundTransparency = 1.000
    keybindInfo1.Position = UDim2.new(0, 88, 1, -35)
    keybindInfo1.Size = UDim2.new(0, 50, 0, 25)
    keybindInfo1.Font = Enum.Font.Gotham
    keybindInfo1.Text = "Hide UI"
    keybindInfo1.TextColor3 = Theme.TextMuted
    keybindInfo1.TextSize = 12.000
    keybindInfo1.TextXAlignment = Enum.TextXAlignment.Left

    local oldKey = Enum.KeyCode.LeftAlt.Name
    key1.MouseButton1Click:Connect(function() 
        key1.Text = "..."
        local a = UserInputService.InputBegan:Wait()
        if a.KeyCode.Name ~= "Unknown" then
            key1.Text = a.KeyCode.Name
            oldKey = a.KeyCode.Name
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed) 
        if not gameProcessed and input.KeyCode.Name == oldKey then 
            LuxtLib.Enabled = not LuxtLib.Enabled
        end
    end)

    wave.Name = "wave"
    wave.Parent = MainFrame
    wave.BackgroundTransparency = 1.000
    wave.Position = UDim2.new(0.28, 0, 0, 0)
    wave.Size = UDim2.new(0.72, 0, 0.55, 0)
    wave.Image = "http://www.roblox.com/asset/?id=6087537285"
    wave.ImageColor3 = Theme.Primary
    wave.ImageTransparency = 0.8
    wave.ScaleType = Enum.ScaleType.Slice
    Instance.new("UICorner", wave).CornerRadius = UDim.new(0, 6)

    framesAll.Name = "framesAll"
    framesAll.Parent = MainFrame
    framesAll.BackgroundTransparency = 1.000
    framesAll.Position = UDim2.new(0, 165, 0, 10)
    framesAll.Size = UDim2.new(0, 378, 0, 432)
    
    pageFolder.Name = "pageFolder"
    pageFolder.Parent = framesAll

    -- Идеальная система Drag (перетаскивание)
    local dragging, dragInput, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        shadow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    sideHeading.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = shadow.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    sideHeading.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then updateDrag(input) end
    end)

    local TabHandling = {}
    local firstTab = true

    function TabHandling:Tab(tabText, tabId)
        local tabBtnFrame = Instance.new("Frame")
        local tabBtn = Instance.new("TextButton")
        local tabLogo = Instance.new("ImageLabel")

        tabText = tabText or "Tab"
        tabId = tabId or ""

        tabBtnFrame.Name = "tabBtnFrame"
        tabBtnFrame.Parent = tabFrame
        tabBtnFrame.BackgroundTransparency = 1.000
        tabBtnFrame.Size = UDim2.new(1, 0, 0, 30)

        tabBtn.Name = "tabBtn"
        tabBtn.Parent = tabBtnFrame
        tabBtn.BackgroundTransparency = 1.000
        tabBtn.Position = UDim2.new(0, 32, 0, 0)
        tabBtn.Size = UDim2.new(1, -32, 1, 0)
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.Text = tabText
        tabBtn.TextColor3 = firstTab and Theme.Primary or Theme.TextMuted
        tabBtn.TextSize = 13.000
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left

        tabLogo.Name = "tabLogo"
        tabLogo.Parent = tabBtnFrame
        tabLogo.BackgroundTransparency = 1.000
        tabLogo.Position = UDim2.new(0, 4, 0, 4)
        tabLogo.Size = UDim2.new(0, 22, 0, 22)
        tabLogo.Image = "rbxassetid://" .. tabId
        tabLogo.ImageColor3 = firstTab and Theme.Primary or Theme.TextMuted

        local newPage = Instance.new("ScrollingFrame")
        local sectionList = Instance.new("UIListLayout")

        newPage.Name = "newPage_" .. tabText
        newPage.Parent = pageFolder
        newPage.BackgroundTransparency = 1.000
        newPage.BorderSizePixel = 0
        newPage.Size = UDim2.new(1, 0, 1, 0)
        newPage.ScrollBarThickness = 2
        newPage.ScrollBarImageColor3 = Theme.Primary
        newPage.Visible = firstTab

        sectionList.Parent = newPage
        sectionList.SortOrder = Enum.SortOrder.LayoutOrder
        sectionList.Padding = UDim.new(0, 8)

        -- Автоматический размер страницы
        sectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            newPage.CanvasSize = UDim2.new(0, 0, 0, sectionList.AbsoluteContentSize.Y + 10)
        end)

        firstTab = false

        tabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(pageFolder:GetChildren()) do v.Visible = false end
            newPage.Visible = true

            for _, v in pairs(tabFrame:GetChildren()) do
                if v:IsA("Frame") then
                    Tween(v.tabBtn, {TextColor3 = Theme.TextMuted})
                    Tween(v.tabLogo, {ImageColor3 = Theme.TextMuted})
                end
            end
            Tween(tabBtn, {TextColor3 = Theme.Primary})
            Tween(tabLogo, {ImageColor3 = Theme.Primary})
        end)

        local sectionHandling = {}

        function sectionHandling:Section(sectionText)
            local sectionFrame = Instance.new("Frame")
            local sectionInnerList = Instance.new("UIListLayout")
            local mainSectionHead = Instance.new("Frame")
            local sectionName = Instance.new("TextLabel")
            local sectionExpand = Instance.new("ImageButton")

            sectionText = sectionText or "Section"
            local isDropped = true

            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = newPage
            sectionFrame.BackgroundColor3 = Theme.SideBg
            sectionFrame.Size = UDim2.new(1, -10, 0, 36)
            sectionFrame.ClipsDescendants = true
            Instance.new("UICorner", sectionFrame).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", sectionFrame).Color = Theme.Stroke

            sectionInnerList.Parent = sectionFrame
            sectionInnerList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            sectionInnerList.SortOrder = Enum.SortOrder.LayoutOrder
            sectionInnerList.Padding = UDim.new(0, 6)

            mainSectionHead.Name = "mainSectionHead"
            mainSectionHead.Parent = sectionFrame
            mainSectionHead.BackgroundTransparency = 1.000
            mainSectionHead.Size = UDim2.new(1, 0, 0, 36)

            sectionName.Name = "sectionName"
            sectionName.Parent = mainSectionHead
            sectionName.BackgroundTransparency = 1.000
            sectionName.Position = UDim2.new(0, 10, 0, 0)
            sectionName.Size = UDim2.new(1, -40, 1, 0)
            sectionName.Font = Enum.Font.GothamBold
            sectionName.Text = sectionText
            sectionName.TextColor3 = Theme.Primary
            sectionName.TextSize = 13.000
            sectionName.TextXAlignment = Enum.TextXAlignment.Left

            sectionExpand.Name = "sectionExpand"
            sectionExpand.Parent = mainSectionHead
            sectionExpand.BackgroundTransparency = 1.000
            sectionExpand.Position = UDim2.new(1, -30, 0, 5)
            sectionExpand.Size = UDim2.new(0, 26, 0, 26)
            sectionExpand.Image = "rbxassetid://3926305904"
            sectionExpand.ImageColor3 = Theme.Primary
            sectionExpand.ImageRectOffset = Vector2.new(564, 284)
            sectionExpand.ImageRectSize = Vector2.new(36, 36)
            sectionExpand.Rotation = 180

            -- Автоматический размер секции
            sectionInnerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isDropped then
                    sectionFrame.Size = UDim2.new(1, -10, 0, sectionInnerList.AbsoluteContentSize.Y + 8)
                end
            end)

            sectionExpand.MouseButton1Click:Connect(function()
                isDropped = not isDropped
                if isDropped then
                    Tween(sectionFrame, {Size = UDim2.new(1, -10, 0, sectionInnerList.AbsoluteContentSize.Y + 8)})
                    Tween(sectionExpand, {Rotation = 180})
                else
                    Tween(sectionFrame, {Size = UDim2.new(1, -10, 0, 36)})
                    Tween(sectionExpand, {Rotation = 0})
                end
            end)

            local ItemHandling = {}

            -- ======= ВНУТРЕННИЕ ЭЛЕМЕНТЫ UI ======= --

            function ItemHandling:Button(btnText, callback)
                btnText = btnText or "Button"
                callback = callback or function() end

                local ButtonFrame = Instance.new("Frame")
                local TextButton = Instance.new("TextButton")

                ButtonFrame.Parent = sectionFrame
                ButtonFrame.BackgroundTransparency = 1.000
                ButtonFrame.Size = UDim2.new(1, -16, 0, 32)

                TextButton.Parent = ButtonFrame
                TextButton.BackgroundColor3 = Theme.ItemBg
                TextButton.Size = UDim2.new(1, 0, 1, 0)
                TextButton.AutoButtonColor = false
                TextButton.Font = Enum.Font.GothamSemibold
                TextButton.Text = btnText
                TextButton.TextColor3 = Theme.Text
                TextButton.TextSize = 13.000
                Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 4)
                Instance.new("UIStroke", TextButton).Color = Theme.Stroke

                TextButton.MouseButton1Click:Connect(function()
                    callback()
                    Tween(TextButton, {Size = UDim2.new(0.95, 0, 0.9, 0), BackgroundColor3 = Theme.Primary, TextColor3 = Color3.fromRGB(0,0,0)}, 0.1)
                    task.wait(0.1)
                    Tween(TextButton, {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.ItemHover, TextColor3 = Theme.Text}, 0.1)
                end)
                TextButton.MouseEnter:Connect(function() Tween(TextButton, {BackgroundColor3 = Theme.ItemHover}) end)
                TextButton.MouseLeave:Connect(function() Tween(TextButton, {BackgroundColor3 = Theme.ItemBg}) end)
            end

            function ItemHandling:Toggle(toggInfo, callback)
                toggInfo = toggInfo or "Toggle"
                callback = callback or function() end

                local ToggleFrame = Instance.new("Frame")
                local toggleBtn = Instance.new("TextButton")
                local toggleLabel = Instance.new("TextLabel")
                local checkMark = Instance.new("Frame")
                local innerCheck = Instance.new("UIStroke")

                ToggleFrame.Parent = sectionFrame
                ToggleFrame.BackgroundTransparency = 1.000
                ToggleFrame.Size = UDim2.new(1, -16, 0, 32)

                toggleBtn.Parent = ToggleFrame
                toggleBtn.BackgroundColor3 = Theme.ItemBg
                toggleBtn.Size = UDim2.new(1, 0, 1, 0)
                toggleBtn.Text = ""
                toggleBtn.AutoButtonColor = false
                Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 4)
                Instance.new("UIStroke", toggleBtn).Color = Theme.Stroke

                toggleLabel.Parent = toggleBtn
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Position = UDim2.new(0, 10, 0, 0)
                toggleLabel.Size = UDim2.new(1, -50, 1, 0)
                toggleLabel.Font = Enum.Font.GothamSemibold
                toggleLabel.Text = toggInfo
                toggleLabel.TextColor3 = Theme.Text
                toggleLabel.TextSize = 13.000
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

                checkMark.Parent = toggleBtn
                checkMark.BackgroundColor3 = Theme.MainBg
                checkMark.Position = UDim2.new(1, -26, 0.5, -8)
                checkMark.Size = UDim2.new(0, 16, 0, 16)
                Instance.new("UICorner", checkMark).CornerRadius = UDim.new(0, 4)
                innerCheck.Parent = checkMark
                innerCheck.Color = Theme.Stroke
                innerCheck.Thickness = 1.5

                local on = false
                toggleBtn.MouseButton1Click:Connect(function()
                    on = not on
                    callback(on)
                    if on then
                        Tween(checkMark, {BackgroundColor3 = Theme.Primary})
                        Tween(toggleLabel, {TextColor3 = Theme.Primary})
                    else
                        Tween(checkMark, {BackgroundColor3 = Theme.MainBg})
                        Tween(toggleLabel, {TextColor3 = Theme.Text})
                    end
                end)
            end

            function ItemHandling:Slider(slidInfo, minvalue, maxvalue, callback)
                minvalue, maxvalue = minvalue or 0, maxvalue or 100
                callback = callback or function() end

                local SliderFrame = Instance.new("Frame")
                local sliderBg = Instance.new("Frame")
                local sliderLabel = Instance.new("TextLabel")
                local valLabel = Instance.new("TextLabel")
                local sliderTrack = Instance.new("TextButton")
                local sliderFill = Instance.new("Frame")

                SliderFrame.Parent = sectionFrame
                SliderFrame.BackgroundTransparency = 1.000
                SliderFrame.Size = UDim2.new(1, -16, 0, 42)

                sliderBg.Parent = SliderFrame
                sliderBg.BackgroundColor3 = Theme.ItemBg
                sliderBg.Size = UDim2.new(1, 0, 1, 0)
                Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 4)
                Instance.new("UIStroke", sliderBg).Color = Theme.Stroke

                sliderLabel.Parent = sliderBg
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Position = UDim2.new(0, 10, 0, 4)
                sliderLabel.Size = UDim2.new(0.7, 0, 0.5, 0)
                sliderLabel.Font = Enum.Font.GothamSemibold
                sliderLabel.Text = slidInfo
                sliderLabel.TextColor3 = Theme.Text
                sliderLabel.TextSize = 13.000
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left

                valLabel.Parent = sliderBg
                valLabel.BackgroundTransparency = 1
                valLabel.Position = UDim2.new(0.7, -10, 0, 4)
                valLabel.Size = UDim2.new(0.3, 0, 0.5, 0)
                valLabel.Font = Enum.Font.GothamBold
                valLabel.Text = tostring(minvalue)
                valLabel.TextColor3 = Theme.Primary
                valLabel.TextSize = 13.000
                valLabel.TextXAlignment = Enum.TextXAlignment.Right

                sliderTrack.Parent = sliderBg
                sliderTrack.BackgroundColor3 = Theme.MainBg
                sliderTrack.Position = UDim2.new(0, 10, 0.7, 0)
                sliderTrack.Size = UDim2.new(1, -20, 0, 6)
                sliderTrack.Text = ""
                sliderTrack.AutoButtonColor = false
                Instance.new("UICorner", sliderTrack).CornerRadius = UDim.new(1, 0)

                sliderFill.Parent = sliderTrack
                sliderFill.BackgroundColor3 = Theme.Primary
                sliderFill.Size = UDim2.new(0, 0, 1, 0)
                Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

                local mouse = Players.LocalPlayer:GetMouse()
                local dragging = false

                local function moveSlider()
                    local pos = math.clamp((mouse.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                    local value = math.floor(((maxvalue - minvalue) * pos) + minvalue)
                    valLabel.Text = tostring(value)
                    Tween(sliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                    pcall(callback, value)
                end

                sliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        moveSlider()
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then moveSlider() end
                end)
            end

            function ItemHandling:DropDown(dropInfo, list, callback)
                list = list or {}
                callback = callback or function() end

                local DropFrame = Instance.new("Frame")
                local dropBtn = Instance.new("TextButton")
                local dropLabel = Instance.new("TextLabel")
                local dropIcon = Instance.new("ImageLabel")
                local dropScroll = Instance.new("ScrollingFrame")
                local dropListLayout = Instance.new("UIListLayout")

                local isDropped = false

                DropFrame.Parent = sectionFrame
                DropFrame.BackgroundColor3 = Theme.ItemBg
                DropFrame.Size = UDim2.new(1, -16, 0, 32)
                DropFrame.ClipsDescendants = true
                Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 4)
                Instance.new("UIStroke", DropFrame).Color = Theme.Stroke

                dropBtn.Parent = DropFrame
                dropBtn.BackgroundTransparency = 1
                dropBtn.Size = UDim2.new(1, 0, 0, 32)
                dropBtn.Text = ""
                dropBtn.ZIndex = 2

                dropLabel.Parent = dropBtn
                dropLabel.BackgroundTransparency = 1
                dropLabel.Position = UDim2.new(0, 10, 0, 0)
                dropLabel.Size = UDim2.new(1, -40, 1, 0)
                dropLabel.Font = Enum.Font.GothamSemibold
                dropLabel.Text = dropInfo
                dropLabel.TextColor3 = Theme.Text
                dropLabel.TextSize = 13.000
                dropLabel.TextXAlignment = Enum.TextXAlignment.Left

                dropIcon.Parent = dropBtn
                dropIcon.BackgroundTransparency = 1
                dropIcon.Position = UDim2.new(1, -26, 0.5, -10)
                dropIcon.Size = UDim2.new(0, 20, 0, 20)
                dropIcon.Image = "rbxassetid://3926305904"
                dropIcon.ImageColor3 = Theme.TextMuted
                dropIcon.ImageRectOffset = Vector2.new(564, 284)
                dropIcon.ImageRectSize = Vector2.new(36, 36)

                dropScroll.Parent = DropFrame
                dropScroll.BackgroundTransparency = 1
                dropScroll.Position = UDim2.new(0, 0, 0, 35)
                dropScroll.Size = UDim2.new(1, 0, 1, -35)
                dropScroll.ScrollBarThickness = 2
                dropScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

                dropListLayout.Parent = dropScroll
                dropListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                dropListLayout.Padding = UDim.new(0, 2)

                dropListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    dropScroll.CanvasSize = UDim2.new(0, 0, 0, dropListLayout.AbsoluteContentSize.Y)
                end)

                dropBtn.MouseButton1Click:Connect(function()
                    isDropped = not isDropped
                    local targetSize = isDropped and math.clamp(dropListLayout.AbsoluteContentSize.Y + 40, 70, 150) or 32
                    Tween(DropFrame, {Size = UDim2.new(1, -16, 0, targetSize)})
                    Tween(dropIcon, {Rotation = isDropped and 180 or 0})
                end)

                for _, item in ipairs(list) do
                    local optionBtn = Instance.new("TextButton")
                    optionBtn.Parent = dropScroll
                    optionBtn.BackgroundColor3 = Theme.MainBg
                    optionBtn.Size = UDim2.new(1, -10, 0, 26)
                    optionBtn.Position = UDim2.new(0, 5, 0, 0)
                    optionBtn.Font = Enum.Font.Gotham
                    optionBtn.Text = item
                    optionBtn.TextColor3 = Theme.TextMuted
                    optionBtn.TextSize = 12.000
                    Instance.new("UICorner", optionBtn).CornerRadius = UDim.new(0, 4)

                    optionBtn.MouseButton1Click:Connect(function()
                        isDropped = false
                        dropLabel.Text = dropInfo .. ": " .. item
                        Tween(DropFrame, {Size = UDim2.new(1, -16, 0, 32)})
                        Tween(dropIcon, {Rotation = 0})
                        callback(item)
                    end)
                end
            end

            function ItemHandling:TextBox(infbix, textPlace, callback)
                local TxtFrame = Instance.new("Frame")
                local label = Instance.new("TextLabel")
                local box = Instance.new("TextBox")

                TxtFrame.Parent = sectionFrame
                TxtFrame.BackgroundColor3 = Theme.ItemBg
                TxtFrame.Size = UDim2.new(1, -16, 0, 32)
                Instance.new("UICorner", TxtFrame).CornerRadius = UDim.new(0, 4)
                local strk = Instance.new("UIStroke", TxtFrame)
                strk.Color = Theme.Stroke

                label.Parent = TxtFrame
                label.BackgroundTransparency = 1
                label.Position = UDim2.new(0, 10, 0, 0)
                label.Size = UDim2.new(0.6, 0, 1, 0)
                label.Font = Enum.Font.GothamSemibold
                label.Text = infbix or "TextBox"
                label.TextColor3 = Theme.Text
                label.TextSize = 13.000
                label.TextXAlignment = Enum.TextXAlignment.Left

                box.Parent = TxtFrame
                box.BackgroundColor3 = Theme.MainBg
                box.Position = UDim2.new(0.6, 0, 0.5, -10)
                box.Size = UDim2.new(0.38, 0, 0, 20)
                box.Font = Enum.Font.Gotham
                box.PlaceholderText = textPlace or "Type..."
                box.Text = ""
                box.TextColor3 = Theme.Primary
                box.TextSize = 12.000
                Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
                Instance.new("UIStroke", box).Color = Theme.Stroke

                box.Focused:Connect(function() Tween(strk, {Color = Theme.Primary}) end)
                box.FocusLost:Connect(function(enter)
                    Tween(strk, {Color = Theme.Stroke})
                    if enter then callback(box.Text) end
                end)
            end

            return ItemHandling
        end
        return sectionHandling
    end
    return TabHandling
end

return Luxt1
