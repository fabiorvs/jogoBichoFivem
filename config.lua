Config = {}

-- Array com os nomes dos 25 bichos
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

-- Array Multiplicadores
Config.multiplicadores = {10, 5, 2}

-- Array NPCS
Config.npcs = {{
    position = vector3(-267.0, -959.0, 31.2), -- Coordenadas do NPC
    model = "g_f_importexport_01", -- Modelo do NPC
    heading = 337.0, -- Rotação do NPC
    blipName = "Jogo do Bicho", -- Nome do Blip
    tableModel = "prop_astro_table_01", -- Modelo da mesa
    tableOffset = vector3(0.0, 1.0, 0.0) -- Posição da mesa em relação ao NPC
}, {
    position = vector3(300.0, -500.0, 43.35), -- Outra posição
    model = "g_m_importexport_01", -- Outro modelo de NPC
    heading = 337.0, -- Rotação do NPC
    blipName = "Jogo do Bicho", -- Nome do Blip
    tableModel = "prop_astro_table_01", -- Modelo da mesa
    tableOffset = vector3(0.0, 1.0, 0.0) -- Posição da mesa em relação ao NPC
}, {
    position = vector3(-2570.28, 2789.27, 3.6), -- Outra posição
    model = "a_m_m_golfer_01", -- Outro modelo de NPC
    heading = 337.0, -- Rotação do NPC
    blipName = "Jogo do Bicho", -- Nome do Blip
    tableModel = "prop_astro_table_01", -- Modelo da mesa
    tableOffset = vector3(0.0, 1.0, 0.0) -- Posição da mesa em relação ao NPC
}}

-- Array Aniations
Config.animations = {
    "WORLD_HUMAN_SMOKING", 
    "WORLD_HUMAN_CLIPBOARD",
     "WORLD_HUMAN_STAND_IMPATIENT",
    "WORLD_HUMAN_DRINKING", 
    "WORLD_HUMAN_AA_SMOKE",
    "WORLD_HUMAN_AA_COFFEE"
}

-- Webhook
Config.urlWebhook = "https://discord.com/api/webhooks/835333818822819841/rBuX5z6uNSdRBHqlySxNsw4Nw6TWoToSgD8msNxbJ8NgbUDHGLzeQDqBOZOD8KqjFqOJ"