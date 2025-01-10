local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vRP", "jogoBicho")

cRP = {}
Tunnel.bindInterface("jogoBicho", cRP)
vSERVER = Tunnel.getInterface("jogoBicho")

-- Lista de NPCs
local npcs = {
    {
        position = vector3(-267.0, -959.0, 31.2), -- Coordenadas do NPC
        model = "g_f_importexport_01", -- Modelo do NPC
        blipName = "Jogo do Bicho" -- Nome do Blip
    },
    {
        position = vector3(300.0, -500.0, 43.35), -- Outra posição
        model = "g_m_importexport_01", -- Outro modelo de NPC
        blipName = "Jogo do Bicho" -- Nome do Blip
    }
}

local isNearNPC = false -- Para evitar múltiplas interações

-- Criação dos NPCs e Blips
Citizen.CreateThread(function()
    for _, npcData in ipairs(npcs) do
        -- Criar o blip
        local blip = AddBlipForCoord(npcData.position)
        SetBlipSprite(blip, 605) -- Ícone de apostas
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.9)
        SetBlipColour(blip, 2) -- Verde
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(npcData.blipName)
        EndTextCommandSetBlipName(blip)

        -- Criar o NPC
        local model = GetHashKey(npcData.model)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(10)
        end

        local npc = CreatePed(4, model, npcData.position.x, npcData.position.y, npcData.position.z - 1, 3374176.0, false, true)
        SetEntityInvincible(npc, true) -- NPC não pode ser morto
        SetBlockingOfNonTemporaryEvents(npc, true)
        FreezeEntityPosition(npc, true) -- NPC não se move
    end
end)

-- Detecção de interação com os NPCs
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        isNearNPC = false -- Reseta a interação a cada ciclo

        for _, npcData in ipairs(npcs) do
            local distance = #(playerPos - npcData.position)
            if distance < 2.0 then
                -- Exibe uma mensagem de interação
                isNearNPC = true
                DrawText3D(npcData.position.x, npcData.position.y, npcData.position.z + 1.0, "[E] Para iniciar a aposta")
                if IsControlJustPressed(0, 38) then -- Tecla E
                    TriggerEvent("jogoBicho:abrirAposta")
                end
                break -- Não verifica mais NPCs se já encontrou um próximo
            end
        end

        if not isNearNPC then
            Wait(500) -- Reduz a frequência de verificações quando longe dos NPCs
        else
            Wait(0) -- Atualização rápida quando próximo de um NPC
        end
    end
end)

-- Evento para abrir a interface de aposta
RegisterNetEvent("jogoBicho:abrirAposta")
AddEventHandler("jogoBicho:abrirAposta", function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "showUI" })
end)

-- Callback para registrar a aposta
RegisterNUICallback("registrarAposta", function(data, cb)
    if not data.bicho or not data.valor or tonumber(data.valor) <= 0 then
        print("Erro: Dados inválidos para aposta") -- Debug
        cb("error")
        return
    end

    -- Envia a aposta para o servidor
    TriggerServerEvent("jogoBicho:registrarAposta", data.bicho, tonumber(data.valor))
    cb("ok")
end)

-- Callback para esconder a interface
RegisterNUICallback("hideUI", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNetEvent("jogoBicho:resultado")
AddEventHandler("jogoBicho:resultado", function(success, message, bichosSorteados)
    local title
    local fullMessage

    if #bichosSorteados == 0 then
        -- Caso nenhum bicho tenha sido sorteado
        title = "Erro"
        fullMessage = message .. "."
    else
        -- Converte a tabela de bichos sorteados em uma string
        local premios = {"1º Prêmio:", "2º Prêmio:", "3º Prêmio:"}
        local bichosTexto = ""

        for i, bicho in ipairs(bichosSorteados) do
            bichosTexto = bichosTexto .. premios[i] .. " " .. bicho .. "<br>"
        end
        title = success and "Você ganhou!" or "Você perdeu!"
        fullMessage = message .. "<br>Os bichos sorteados foram: <br>" .. bichosTexto
    end

    -- Envia os dados para o NUI
    SendNUIMessage({
        action = "showResult",
        title = title,
        message = fullMessage,
    })
end)

-- Função para exibir texto 3D
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local scale = 0.35

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
