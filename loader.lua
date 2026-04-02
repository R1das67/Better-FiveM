local function LoadModule(url)
    local content = nil
    PerformHttpRequest(url, function(err, text)
        if err == 200 then content = text end
    end, "GET")

    local timeout = 0
    while content == nil and timeout < 5000 do
        Citizen.Wait(100)
        timeout = timeout + 100
    end

    if content then
        local func = load(content)
        if func then func() end
    end
end

LoadModule("https://raw.githubusercontent.com/R1das67/Better-FiveM/refs/heads/main/menu.lua")
LoadModule("https://raw.githubusercontent.com/R1das67/Better-FiveM/refs/heads/main/main.lua")
