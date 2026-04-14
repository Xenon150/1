local v_u_1 = false
local v_u_2 = false
local v_u_3 = game:GetService("ReplicatedStorage")
local v_u_4 = game:GetService("Debris")
local v_u_5 = false
local v_u_6 = false
local v_u_7 = require(v_u_3:WaitForChild("CooldownModule"))
local v_u_8 = require(game:GetService("ReplicatedFirst").Dependencies.GloveCommonClient)

local lp = game.Players.LocalPlayer
local ts = game:GetService("TweenService")

v_u_8:BindAbility(function()
    -- Убрана проверка v_u_6 (кулдаун), теперь можно спамить
    if v_u_5 then
        v_u_8:CancelOncomingTooltip()
        
        local char = lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        -- Ускорение без задержек
        if hum then
            hum.WalkSpeed = 40
            ts:Create(hum, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {WalkSpeed = 20}):Play()
        end
        
        -- Эффекты пердежа
        if hrp and v_u_3:FindFirstChild("Assets") then
            local p = v_u_3.Assets.Default.FartBlastParticle:Clone()
            p.Parent = hrp
            p:Emit(7)
            v_u_4:AddItem(p, 1.1)
        end
        
        if game.SoundService:FindFirstChild("MegaFart") then
            game.SoundService.MegaFart.TimePosition = 0.25
            game.SoundService.MegaFart:Play()
        end
        
        v_u_3.Remotes.Framework_UseAbility:FireServer("ReplicateSound")
        
        -- Тряска камеры (FOV)
        local cam = workspace.CurrentCamera
        if cam then
            ts:Create(cam, TweenInfo.new(0.1), {FieldOfView = 80}):Play()
            task.delay(0.1, function()
                if cam then
                    ts:Create(cam, TweenInfo.new(0.9, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {FieldOfView = 70}):Play()
                end
            end)
        end
        
        -- Кулдаун v_u_7.Cooldown(3.5) полностью удален
    end
end)

-- Регистрация экипировки
script.Parent.Equipped:Connect(function()
    local char = script.Parent.Parent
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        slaptrack = hum:LoadAnimation(v_u_3.Slap)
    end
    v_u_5 = true
end)

script.Parent.Unequipped:Connect(function()
    v_u_5 = false
end)

-- Обычный удар (ЛКМ)
script.Parent.Activated:Connect(function()
    if not v_u_2 then
        v_u_2 = true
        if slaptrack then slaptrack:Play() end
        task.wait(1)
        v_u_2 = false
    end
end)

-- Логика попадания по игроку
script.Parent:WaitForChild("Glove").Touched:Connect(function(p10)
    if p10.Parent ~= script.Parent.Parent and p10.Parent:FindFirstChildOfClass("Humanoid") and p10:IsA("BasePart") then
        if not v_u_1 and v_u_2 then
            local arenaVal = p10.Parent:FindFirstChild("isInArena")
            if arenaVal and arenaVal.Value == true then
                v_u_1 = true
                v_u_3.b:FireServer(p10)
                task.wait(0.5)
                v_u_1 = false
            end
        end
    end
end)

if v_u_8:IsFirstTimeUsingGlove(script.Parent.Name) then
    v_u_8:ShowTipAfterTime(10, "Use your 'E' ability to get a speed boost!")
end
