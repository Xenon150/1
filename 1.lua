local v_u_1 = false
local v_u_2 = false
local v_u_3 = game:GetService("ReplicatedStorage")
game:GetService("ContextActionService")
local v_u_4 = game:GetService("Debris")
local v_u_5 = false
local v_u_6 = false -- Дебаунс (кулдаун)
game:GetService("UserInputService")
local v_u_7 = require(game.ReplicatedStorage.CooldownModule)
local v_u_8 = require(game.ReplicatedFirst.Dependencies.GloveCommonClient)

-- Основная абилка
v_u_8:BindAbility(function()
	-- Убрана проверка "and not v_u_6", чтобы можно было спамить
	if v_u_5 then
		-- v_u_6 = true -- Блокировка отключена
		v_u_8:CancelOncomingTooltip()
		
		if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 40
			game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.Humanoid, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.In, 0, false, 0), {
				["WalkSpeed"] = 20
			}):Play()
		end
		
		local v9 = v_u_3.Assets.Default.FartBlastParticle:Clone()
		v9.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
		v9:Emit(7)
		v_u_4:AddItem(v9, 1.1)
		
		game.SoundService.MegaFart.TimePosition = 0.25
		game.SoundService.MegaFart:Play()
		
		-- Отправка на сервер (если там есть проверка кулдауна, может не сработать визуально для других)
		v_u_3.Remotes.Framework_UseAbility:FireServer("ReplicateSound")
		
		game:GetService("TweenService"):Create(workspace.Camera, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {
			["FieldOfView"] = 80
		}):Play()
		
		task.delay(0.1, function()
			game:GetService("TweenService"):Create(workspace.Camera, TweenInfo.new(0.9, Enum.EasingStyle.Cubic, Enum.EasingDirection.In, 0, false, 0), {
				["FieldOfView"] = 70
			}):Play()
		end)
		
		-- v_u_7.Cooldown(3.5) -- Визуальный кулдаун отключен
		v_u_6 = false
	end
end)

-- Экипировка
script.Parent.Equipped:Connect(function()
	if script.Parent.Parent:FindFirstChild("Humanoid") then
		slaptrack = script.Parent.Parent.Humanoid:LoadAnimation(v_u_3.Slap)
	end
	v_u_5 = true
end)

-- Снятие перчатки
script.Parent.Unequipped:Connect(function()
	v_u_5 = false
end)

-- Удар (ЛКМ)
script.Parent.Activated:Connect(function()
	if not v_u_2 then
		v_u_2 = true
		if slaptrack then slaptrack:Play() end
		task.wait(1)
		v_u_2 = false
	end
end)

-- Касание (Slap)
script.Parent:WaitForChild("Glove").Touched:Connect(function(p10)
	if p10.Parent ~= script.Parent.Parent and (p10.Parent:FindFirstChild("Humanoid") and (p10:IsA("BasePart") and (not v_u_1 and (v_u_2 and p10.Parent:FindFirstChild("isInArena").Value == true)))) then
		v_u_1 = true
		v_u_3.b:FireServer(p10)
		task.wait(0.1) -- Уменьшил задержку удара для скорости
		v_u_1 = false
	end
end)

if v_u_8:IsFirstTimeUsingGlove(script.Parent.Name) then
	v_u_8:ShowTipAfterTime(10, "Use your 'E' ability to get a speed boost!")
end
