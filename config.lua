Config = {}

-- Lista dos nomes dos 25 bichos
-- Substitua os nomes caso queira modificar ou adicionar bichos.
-- Obs.: Caso altere esta lista, será necessário:
-- 1. Atualizar as imagens correspondentes na pasta "imagens" (ex.: 1.png, 2.png, etc.).
-- 2. Alterar a variável `bichosMap` no arquivo `script.js` para corresponder aos novos bichos.
-- Certifique-se de que as mudanças sejam consistentes em todas as partes do código.
Config.Bichos = {
    [1] = "Avestruz",
    [2] = "Águia",
    [3] = "Burro",
    [4] = "Cachorro",
    [5] = "Borboleta",
    [6] = "Cabra",
    [7] = "Carneiro",
    [8] = "Camelo",
    [9] = "Cobra",
    [10] = "Coelho",
    [11] = "Cavalo",
    [12] = "Elefante",
    [13] = "Galo",
    [14] = "Gato",
    [15] = "Jacaré",
    [16] = "Leão",
    [17] = "Macaco",
    [18] = "Porco",
    [19] = "Pavão",
    [20] = "Peru",
    [21] = "Touro",
    [22] = "Tigre",
    [23] = "Urso",
    [24] = "Veado",
    [25] = "Vaca"
}

-- Multiplicadores para os prêmios
-- O primeiro valor é para o 1º prêmio, o segundo para o 2º prêmio e o terceiro para o 3º prêmio.
Config.multiplicadores = {10, 5, 2}

-- Configuração dos NPCs no mapa
-- Adicione ou remova NPCs conforme necessário.
-- Cada NPC pode ter:
--   - position: As coordenadas no mapa.
--   - model: O modelo do NPC (verifique os modelos disponíveis no GTA).
--   - heading: Rotação do NPC para posicionamento correto.
--   - blipName: O nome que aparecerá no mapa.
--   - tableModel: Modelo da mesa que será colocada em frente ao NPC.
--   - tableOffset: Offset da posição da mesa em relação ao NPC.
Config.npcs = {
    {
        position = vector3(2615.61, -782.32, 77.99), -- Coordenadas do NPC
        model = "g_f_importexport_01", -- Modelo do NPC
        heading = 90.0, -- Rotação do NPC
        blipName = "Jogo do Bicho", -- Nome do Blip no mapa
        tableModel = "prop_astro_table_01", -- Modelo da mesa
        tableOffset = vector3(0.0, 1.0, 0.0) -- Posição relativa da mesa
    },
    {
        position = vector3( 959.73, 3615.68, 32.72), -- Coordenadas do NPC
        model = "u_m_m_partytarget", -- Modelo do NPC
        heading = 90.0, -- Rotação do NPC
        blipName = "Jogo do Bicho", -- Nome do Blip no mapa
        tableModel = "prop_astro_table_01", -- Modelo da mesa
        tableOffset = vector3(0.0, 1.0, 0.0) -- Posição relativa da mesa
    },
    {
        position = vector3(-2570.28, 2789.27, 3.6), -- Coordenadas do NPC
        model = "a_m_m_golfer_01", -- Modelo do NPC
        heading = 337.0, -- Rotação do NPC
        blipName = "Jogo do Bicho", -- Nome do Blip no mapa
        tableModel = "prop_astro_table_01", -- Modelo da mesa
        tableOffset = vector3(0.0, 1.0, 0.0) -- Posição relativa da mesa
    }
}

-- Animações que os NPCs podem executar
-- As animações são selecionadas aleatoriamente entre as disponíveis nesta lista.
Config.animations = {
    "WORLD_HUMAN_SMOKING", 
    "WORLD_HUMAN_CLIPBOARD",
    "WORLD_HUMAN_STAND_IMPATIENT",
    "WORLD_HUMAN_DRINKING", 
    "WORLD_HUMAN_AA_SMOKE",
    "WORLD_HUMAN_AA_COFFEE"
}

-- URL do Webhook
-- Caso deseje registrar logs do jogo em um canal do Discord, insira a URL do webhook aqui.
-- Deixe vazio ("") se não quiser usar o webhook.
Config.urlWebhook = "https://discord.com/api/webhooks/835333818822819841/rBuX5z6uNSdRBHqlySxNsw4Nw6TWoToSgD8msNxbJ8NgbUDHGLzeQDqBOZOD8KqjFqOJ"
