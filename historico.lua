local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

local Historico = {}

-- Preparar queries apenas uma vez ao carregar o script
vRP._prepare("jogoBicho/insert_historico", [[
    INSERT INTO jogobicho_historico_apostas 
    (user_id, valor_aposta, bicho_escolhido, premio_1, premio_2, premio_3, resultado, valor_ganho, data_aposta)
    VALUES 
    (@user_id, @valor_aposta, @bicho_escolhido, @premio_1, @premio_2, @premio_3, @resultado, @valor_ganho, NOW())
]])

-- Função para registrar uma aposta no histórico
function Historico.registrarAposta(user_id, bicho_escolhido, valor_aposta, premios, resultado, valor_ganho)
    print(valor_ganho)
    if not user_id or not bicho_escolhido or not valor_aposta or not premios or not valor_ganho then
        print("[Erro] Dados insuficientes para registrar aposta no histórico.")
        return
    end

    -- Executar a query com os valores
    vRP._execute("jogoBicho/insert_historico", {
        user_id = user_id,
        valor_aposta = valor_aposta,
        bicho_escolhido = bicho_escolhido,
        premio_1 = premios[1],
        premio_2 = premios[2],
        premio_3 = premios[3],
        resultado = resultado,
        valor_ganho = valor_ganho
    })
end

-- Buscar histórico de apostas do jogador
function Historico.buscarHistorico(user_id)
    vRP._prepare("jogoBicho/get_historico", [[
            SELECT valor_aposta, bicho_escolhido, premio_1, premio_2, premio_3, resultado, valor_ganho, data_aposta
            FROM jogobicho_historico_apostas
            WHERE user_id = @user_id
            ORDER BY data_aposta DESC
            LIMIT 100
        ]])

    return vRP.query("jogoBicho/get_historico", {
        user_id = user_id
    })
end
return Historico
