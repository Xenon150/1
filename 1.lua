-- Конфигурация
local MAX_BUFFER_SIZE = 500 -- Сколько строк хранить перед копированием (чтобы не лагало)
local logBuffer = {}
local LOG_HEADER = "--- [RE REAL-TIME LOG START] ---\n"

-- Функция для записи в буфер и клипборд
local function logToClipboard(text)
    local timestamp = os.date("%H:%M:%S")
    local entry = string.format("[%s] %s", timestamp, text)
    table.insert(logBuffer, entry)
    
    print(entry) -- Дублируем в консоль для удобства

    if #logBuffer >= MAX_BUFFER_SIZE then
        local fullLog = LOG_HEADER .. table.concat(logBuffer, "\n")
        if setclipboard then
            setclipboard(fullLog)
            warn("!!! BUFFER FULL: Logs copied to clipboard !!!")
        end
        logBuffer = {} -- Очищаем буфер после копирования
    end
end

-- 1. ОТСЛЕЖИВАНИЕ НОВЫХ ОБЪЕКТОВ
game.DescendantAdded:Connect(function(obj)
    pcall(function()
        logToClipboard(string.format("NEW INSTANCE: %s | Class: %s | Parent: %s", obj:GetFullName(), obj.ClassName, tostring(obj.Parent)))
    end)
end)

-- 2. ОТСЛЕЖИВАНИЕ УДАЛЕНИЯ
game.DescendantRemoving:Connect(function(obj)
    pcall(function()
        logToClipboard(string.format("REMOVED: %s (from %s)", obj.Name, tostring(obj.Parent)))
    end)
end)

-- 3. ХУК МЕТАТАБЛИЦЫ (Слежка за изменением свойств скриптами)
-- Это "сердце" реверс-инжиниринга. Мы видим, когда скрипт меняет свойство.
local mt = getrawmetatable(game)
local oldNewIndex = mt.__newindex
setreadonly(mt, false)

mt.__newindex = newcclosure(function(t, k, v)
    -- Фильтруем шум (не логируем изменения в GUI игрока, если их слишком много)
    if not tostring(t):find("PlayerGui") then
        local callingScript = getfenv(2).script -- Пытаемся определить, какой скрипт вызвал изменение
        local scriptPath = callingScript and callingScript:GetFullName() or "Unknown/Internal"
        
        logToClipboard(string.format("PROPERTY CHANGE: %s.%s = %s | BY SCRIPT: %s", tostring(t), tostring(k), tostring(v), scriptPath))
    end
    return oldNewIndex(t, k, v)
end)

setreadonly(mt, true)

-- 4. ОТСЛЕЖИВАНИЕ АТРИБУТОВ (Часто используется в новых играх)
local function trackAttributes(obj)
    obj.AttributeChanged:Connect(function(attr)
        logToClipboard(string.format("ATTRIBUTE CHANGE: %s | Attr: %s | Value: %s", obj:GetFullName(), attr, tostring(obj:GetAttribute(attr))))
    end)
end

-- Применяем трекер атрибутов ко всем существующим объектам (осторожно, может быть ресурсоемко)
for _, v in ipairs(game:GetDescendants()) do
    pcall(trackAttributes, v)
end

-- 5. ГОРЯЧАЯ КЛАВИША ДЛЯ ПРИНУДИТЕЛЬНОГО КОПИРОВАНИЯ
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        local currentLog = LOG_HEADER .. table.concat(logBuffer, "\n")
        setclipboard(currentLog)
        warn("--- LOG MANUALLY COPIED TO CLIPBOARD ---")
    end
end)

print("--- [MONITORING ACTIVE: Press RightControl to Copy Logs] ---")
