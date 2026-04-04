-- [[ ARMORED NETWORK SPY - IN & OUT ]] --
local LogTable = {}
local MaxEntries = 500 -- Лимит записей, чтобы память не взорвалась

-- Функция превращения всего в текст (безопасная)
local function safeString(v)
    local s, res = pcall(function() return tostring(v) end)
    return s and res or "???"
end

-- Функция записи (в отдельном потоке)
local function logEvent(dir, remote, args)
    task.spawn(function()
        if #LogTable >= MaxEntries then table.remove(LogTable, 1) end
        
        local argStr = ""
        for i, v in pairs(args) do
            argStr = argStr .. string.format("[%d]: %s (%s) | ", i, safeString(v), type(v))
        end
        
        local entry = string.format("[%s] [%s] %s\nPath: %s\nArgs: %s\n%s", 
            os.date("%X"), dir, remote.Name, remote:GetFullName(), argStr, string.rep("-", 20))
        
        table.insert(LogTable, entry)
        print(string.format("[%s] %s", dir, remote.Name))
    end)
end

-- ХУК: Исходящие (Твои действия)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" or method == "InvokeServer" then
        logEvent("OUT", self, args)
    end
    
    return oldNamecall(self, ...)
end)

-- ХУК: Входящие (Ответы сервера)
-- Мы подменяем метод Connect, чтобы ловить сигналы сервера "на лету"
mt.__index = newcclosure(function(t, k)
    local res = oldIndex(t, k)
    if k == "OnClientEvent" and t:IsA("RemoteEvent") then
        local oldConnect = res.Connect
        res.Connect = function(self, func)
            return oldConnect(self, function(...)
                logEvent("IN", t, {...})
                return func(...)
            end)
        end
    end
    return res
end)

setreadonly(mt, true)

-- КОМАНДА ДЛЯ КОПИРОВАНИЯ
_G.CopyLog = function()
    local finalLog = table.concat(LogTable, "\n")
    if setclipboard then
        setclipboard(finalLog)
        warn("!!! ЛОГ ИЗ " .. #LogTable .. " СОБЫТИЙ СКОПИРОВАН !!!")
    else
        print(finalLog)
    end
end

print("-----------------------------------------")
print("[+] ШПИОН ЗАПУЩЕН (ИН/АУТ).")
print("[!] Если меч не работает - значит сервер проверяет скорость.")
print("[!] Команда: _G.CopyLog()")
print("-----------------------------------------")
