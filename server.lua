local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

cRP = {}
Tunnel.bindInterface("jogoBicho", cRP)
vCLIENT = Tunnel.getInterface("jogoBicho")

local multiplicadores = Config.multiplicadores
local bichos = Config.Bichos

RegisterNetEvent("jogoBicho:registrarAposta")
AddEventHandler("jogoBicho:registrarAposta", function(bicho, valor)
    local source = source
    local user_id = vRP.getUserId(source)

    if user_id then
        if not valor or tonumber(valor) <= 0 then
            TriggerClientEvent("jogoBicho:resultado", source, false, "O valor da aposta deve ser maior que zero!", {},
                "Nenhum")
            return
        end

        if not bicho or tonumber(bicho) < 1 or tonumber(bicho) > 25 then
            TriggerClientEvent("jogoBicho:resultado", source, false,
                "Número do bicho inválido! Escolha um número entre 1 e 25.", {}, "Nenhum")
            return
        end

        local wallet = vRP.getMoney(user_id)
        local bank = vRP.getBankMoney(user_id)
        local total = wallet + bank

        if total >= valor then
            if wallet >= valor then
                vRP.tryFullPayment(user_id, valor)
            else
                local restante = valor - wallet
                vRP.tryFullPayment(user_id, wallet)
                vRP.setBankMoney(user_id, bank - restante)
            end

            -- Sorteio de 3 bichos diferentes
            local sorteados = {}
            local indicesDisponiveis = {}

            -- Preenche uma tabela com todos os índices possíveis
            for i = 1, 25 do
                table.insert(indicesDisponiveis, i)
            end

            -- Realiza o sorteio garantindo que sejam únicos
            for i = 1, 3 do
                local randomIndex = math.random(1, #indicesDisponiveis)
                local sorteio = table.remove(indicesDisponiveis, randomIndex) -- Remove do array disponível
                table.insert(sorteados, sorteio)
            end

            -- Enviar os bichos sorteados para a animação no cliente
            local sorteadosNomes = {bichos[sorteados[1]], bichos[sorteados[2]], bichos[sorteados[3]]}

            TriggerClientEvent("jogoBicho:exibirSorteio", source, sorteadosNomes)

            Citizen.Wait(6000) -- Tempo para a animação ocorrer

            -- Determinar resultado
            local primeiroBicho = sorteados[1]
            local segundoBicho = sorteados[2]
            local terceiroBicho = sorteados[3]

            local premio = 0
            local resultado = "Nenhum"
            if tonumber(bicho) == primeiroBicho then
                premio = valor * multiplicadores[1]
                resultado = "Primeiro Prêmio"
            elseif tonumber(bicho) == segundoBicho then
                premio = valor * multiplicadores[2]
                resultado = "Segundo Prêmio"
            elseif tonumber(bicho) == terceiroBicho then
                premio = valor * multiplicadores[3]
                resultado = "Terceiro Prêmio"
            end

            if premio > 0 then
                vRP.giveMoney(user_id, premio)
                local premioFormatado = formatBRL(premio)
                TriggerClientEvent("jogoBicho:resultado", source, true,
                    "Você ganhou no " .. resultado .. "! <br>Prêmio: " .. premioFormatado, sorteadosNomes, resultado)
            else
                TriggerClientEvent("jogoBicho:resultado", source, false, "Que pena! Você não ganhou desta vez.",
                    sorteadosNomes, "Nenhum")
            end
        else
            TriggerClientEvent("jogoBicho:resultado", source, false, "Você não tem dinheiro suficiente para apostar!",
                {}, "Nenhum")
        end
    else
        TriggerClientEvent("jogoBicho:resultado", source, false, "Erro ao identificar o jogador.", {}, "Nenhum")
    end
end)

function formatBRL(value)
    local formatted = string.format("%.2f", value)
    formatted = formatted:gsub("%.", ",")
    formatted = formatted:reverse():gsub("(%d%d%d)", "%1."):reverse()
    formatted = formatted:gsub("^%.", "")
    return "R$ " .. formatted
end

function table.includes(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end
