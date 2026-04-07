local setclipboard = setclipboard or print
local logBuffer = {}
local MAX_LOGS = 100

-- Список сервисов, которые мы ИГНОРИРУЕМ (они создают 99% лагов)
local Blacklist = {
    ["RunService"] = true,
    ["LogService"] = true,
    ["TextChatService"] = true,
    ["CoreGui"] = true,
    ["CorePackages"] = true,
    ["Lighting"] = true,
    ["Selection"] = true
}

local function log(text)
    local entry = string.format("[%s] %s", os.date("%X"), text)
    table.insert(logBuffer, entry)
    print(entry)
    
    if #logBuffer >= MAX_LOGS then
        setclipboard(table.concat(logBuffer, "\n"))
        logBuffer = {}
        warn("!!! Logs saved to clipboard !!!")
    end
end

-- 1. СЛЕЖИМ ТОЛЬКО ЗА ВАЖНЫМИ ОБЪЕКТАМИ (Workspace и ReplicatedStorage)
local function safeTrack(obj)
    local root = obj:GetFullName():split(".")[1]
    if Blacklist[root] then return end
    
    -- Логируем только если создано что-то подозрительное
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("ModuleScript") or obj:IsA("ValueBase") then
        log("INTERESTING OBJ: " .. obj.ClassName .. " | Path: " .. obj:GetFullName())
    end
end

game.DescendantAdded:Connect(safeTrack)

-- 2. УМНЫЙ ХУК (Фильтруем свойства)
local mt = getrawmetatable(game)
local oldNewIndex = mt.__newindex
setreadonly(mt, false)

mt.__newindex = newcclosure(function(t, k, v)
    local path = tostring(t)
    
    -- Логируем изменения только если это НЕ визуальные свойства
    -- Игнорируем CFrame, Position, Orientation (это источник лагов)
    local ignoredProps = {CFrame = true, Position = true, Orientation = true, Rotation = true, TimeOfDay = true}
    
    if not ignoredProps[k] and not Blacklist[path] then
        -- Логируем только если меняются значения (Value) или конфиги
        if k == "Value" or t:IsA("RemoteEvent") or t:IsA("ModuleScript") then
            log(string.format("PROP CHANGE: %s.%s = %s", path, tostring(k), tostring(v)))
        end
    end
    
    return oldNewIndex(t, k, v)
end)

setreadonly(mt, true)

log("--- SILENT MONITORING STARTED (FPS OPTIMIZED) ---")
