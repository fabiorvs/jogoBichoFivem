local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
local Webhook = module("jogoBicho", "webhook") -- Importar o módulo Webhook
local Historico = module("jogoBicho", "historico") -- Importar o módulo Historico
local Transacoes = module("jogoBicho", "transacoes") -- Importar o módulo Transações

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

cRP = {}
Tunnel.bindInterface("jogoBicho", cRP)
vCLIENT = Tunnel.getInterface("jogoBicho")

local multiplicadores = Config.multiplicadores
local bichos = Config.Bichos

if not Config or not Config.Bichos or not Config.multiplicadores then
    print("[Erro] Configuração inválida! Verifique o arquivo config.lua.")
    return
end

RegisterNetEvent("jogoBicho:registrarAposta")
AddEventHandler("jogoBicho:registrarAposta", function(bicho, valor)
    local source = source
    local user_id = vRP.getUserId(source)

    if user_id then
        -- Validação das entradas
        if not bicho or not tonumber(bicho) or tonumber(bicho) < 1 or tonumber(bicho) > 25 then
            TriggerClientEvent("jogoBicho:resultado", source, false, "Número do bicho inválido!", {}, "Nenhum")
            return
        end

        if not valor or not tonumber(valor) or tonumber(valor) <= 0 then
            TriggerClientEvent("jogoBicho:resultado", source, false, "O valor da aposta deve ser maior que zero!", {},
                "Nenhum")
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

            -- Adicionar o valor da aposta ao saldo
            Transacoes.registrarTransacao("aposta", valor, "Aposta registrada pelo jogador")

            -- Sorteio de 3 bichos diferentes
            local sorteados = {}
            local indicesDisponiveis = {}

            for i = 1, 25 do
                table.insert(indicesDisponiveis, i)
            end

            for i = 1, 3 do
                local randomIndex = math.random(1, #indicesDisponiveis)
                local sorteio = table.remove(indicesDisponiveis, randomIndex)
                table.insert(sorteados, sorteio)
            end

            local sorteadosNomes = {bichos[sorteados[1]], bichos[sorteados[2]], bichos[sorteados[3]]}

            TriggerClientEvent("jogoBicho:exibirSorteio", source, sorteadosNomes)

            Citizen.Wait(6000) -- Tempo para a animação ocorrer

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
            else
                resultado = "Nenhum"
            end

            -- Registrar histórico no banco de dados
            Historico.registrarAposta(user_id, tonumber(bicho), valor, sorteados, resultado, premio)

            if premio > 0 then
                vRP.giveMoney(user_id, premio)

                -- Retirar o valor do prêmio do saldo
                Transacoes.registrarTransacao("premio", -premio, "Pagamento de prêmio ao jogador")

                local premioFormatado = formatBRL(premio)
                TriggerClientEvent("jogoBicho:resultado", source, true,
                    "Você ganhou no " .. resultado .. "! <br>Prêmio: " .. premioFormatado, sorteadosNomes, resultado)
            else
                TriggerClientEvent("jogoBicho:resultado", source, false, "Que pena! Você não ganhou desta vez.",
                    sorteadosNomes, "Nenhum")
            end

            -- Enviar log para webhook, se configurado
            if Config.urlWebhook and Config.urlWebhook ~= "" then
                local fields = {{
                    name = "ID do Jogador",
                    value = tostring(user_id),
                    inline = true
                }, {
                    name = "Valor da Aposta",
                    value = formatBRL(valor),
                    inline = true
                }, {
                    name = "Bicho Escolhido",
                    value = bichos[tonumber(bicho)],
                    inline = true
                }, {
                    name = "1º Prêmio",
                    value = bichos[primeiroBicho],
                    inline = true
                }, {
                    name = "2º Prêmio",
                    value = bichos[segundoBicho],
                    inline = true
                }, {
                    name = "3º Prêmio",
                    value = bichos[terceiroBicho],
                    inline = true
                }, {
                    name = "Resultado",
                    value = resultado,
                    inline = true
                }, {
                    name = "Valor Ganhado",
                    value = formatBRL(premio),
                    inline = true
                }}

                local color = premio > 0 and 3066993 or 15158332 -- Verde para vitória, vermelho para derrota

                Webhook.sendLog(Config.urlWebhook, "Jogo do Bicho - Resultado", "Detalhes da aposta:", fields, color)
            end

        else
            TriggerClientEvent("jogoBicho:resultado", source, false, "Você não tem dinheiro suficiente para apostar!",
                {}, "Nenhum")
        end
    else
        TriggerClientEvent("jogoBicho:resultado", source, false, "Erro ao identificar o jogador.", {}, "Nenhum")
    end
end)

RegisterNetEvent("jogoBicho:getHistorico")
AddEventHandler("jogoBicho:getHistorico", function()
    local source = source
    local user_id = vRP.getUserId(source)

    if user_id then
        -- Delegar a consulta ao módulo historico.lua
        local resultado = Historico.buscarHistorico(user_id)

        if resultado and #resultado > 0 then
            -- Enviar o histórico no formato JSON
            TriggerClientEvent("jogoBicho:receberHistorico", source, resultado)
        else
            -- Enviar uma lista vazia para o cliente
            TriggerClientEvent("jogoBicho:receberHistorico", source, {})
        end
    else
        -- Enviar uma lista vazia caso o jogador não seja encontrado
        TriggerClientEvent("jogoBicho:receberHistorico", source, {})
    end
end)

-- Comando para setar um novo dono
RegisterCommand("setdonobicho", function(source, args)
    local user_id = vRP.getUserId(source)
    if user_id and vRP.hasPermission(user_id, "admin.permissao") then
        local novo_user_id = tonumber(args[1])
        if novo_user_id then
            -- Atualizar o dono atual
            vRP._execute("jogoBicho/unset_dono_atual")
            vRP._execute("jogoBicho/set_novo_dono", {
                user_id = novo_user_id
            })

            TriggerClientEvent("Notify", source, "sucesso", "Novo dono do jogo do bicho setado com sucesso.")
        else
            TriggerClientEvent("Notify", source, "negado", "Você deve fornecer um ID válido.")
        end
    else
        TriggerClientEvent("Notify", source, "negado", "Você não tem permissão para executar este comando.")
    end
end)

-- Comando para atualizar o saldo
RegisterCommand("setsaldobicho", function(source, args)
    local user_id = vRP.getUserId(source)
    if user_id and vRP.hasPermission(user_id, "admin.permissao") then
        local novo_saldo = tonumber(args[1])
        if novo_saldo then
            vRP._execute("jogoBicho/update_saldo", {
                saldo = novo_saldo
            })
            -- Registrar a transação no histórico de transações
            vRP._execute("jogoBicho/insert_transacao", {
                tipo_transacao = "ajuste",
                valor = novo_saldo,
                descricao = string.format("Admin %d ajustou o saldo.", user_id)
            })
            TriggerClientEvent("Notify", source, "sucesso", "Saldo atualizado com sucesso.")
        else
            TriggerClientEvent("Notify", source, "negado", "Você deve fornecer um valor válido.")
        end
    else
        TriggerClientEvent("Notify", source, "negado", "Você não tem permissão para executar este comando.")
    end
end)

-- Comando para verificar o dono e saldo atual
RegisterCommand("verbicho", function(source)
    local user_id = vRP.getUserId(source)
    if user_id and vRP.hasPermission(user_id, "admin.permissao") then
        local resultado_dono = vRP.query("jogoBicho/get_dono_atual")
        local resultado_saldo = vRP.query("jogoBicho/get_saldo_atual")

        if #resultado_dono > 0 and #resultado_saldo > 0 then
            local dono_atual = resultado_dono[1].user_id
            local saldo_atual = resultado_saldo[1].saldo
            TriggerClientEvent("Notify", source, "importante",
                string.format("Dono atual: %d | Saldo atual: %s", dono_atual, formatBRL(saldo_atual)))
        else
            TriggerClientEvent("Notify", source, "negado", "Informações do dono ou saldo não encontradas.")
        end
    else
        TriggerClientEvent("Notify", source, "negado", "Você não tem permissão para executar este comando.")
    end
end)

-- Função para atualizar o saldo global do jogo
function atualizarSaldo(valor)
    vRP._prepare("jogoBicho/update_saldo", [[
                UPDATE jogobicho_saldo
                SET saldo = saldo + @valor,
                    atualizado_em = NOW()
                WHERE id = 1
            ]])

    vRP._execute("jogoBicho/update_saldo", {
        valor = valor
    })
end

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

