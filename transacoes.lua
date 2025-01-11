local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

local Transacoes = {}

-- Preparar queries
vRP._prepare("jogoBicho/atualizar_saldo", [[
    UPDATE jogobicho_saldo
    SET saldo = saldo + @valor
]])

vRP._prepare("jogoBicho/registrar_transacao", [[
    INSERT INTO jogobicho_historico_transacoes (tipo_transacao, valor, descricao, saldo_apos)
    VALUES (@tipo_transacao, @valor, @descricao, @saldo_apos)
]])

vRP._prepare("jogoBicho/obter_saldo", [[
    SELECT saldo FROM jogobicho_saldo LIMIT 1
]])

-- Registrar uma transação e atualizar o saldo
function Transacoes.registrarTransacao(tipo, valor, descricao)
    local resultado = vRP.query("jogoBicho/obter_saldo")
    local saldo_atual = resultado[1] and resultado[1].saldo or 0

    -- Atualizar o saldo
    local novo_saldo = saldo_atual + valor
    vRP.execute("jogoBicho/atualizar_saldo", {
        valor = valor
    })

    -- Registrar no histórico de transações
    vRP.execute("jogoBicho/registrar_transacao", {
        tipo_transacao = tipo,
        valor = valor,
        descricao = descricao,
        saldo_apos = novo_saldo
    })
end

return Transacoes
