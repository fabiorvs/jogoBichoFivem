-- Criação da tabela de histórico de apostas
CREATE TABLE jogobicho_historico_apostas (
    id INT AUTO_INCREMENT PRIMARY KEY,                -- Identificador único da aposta
    user_id INT NOT NULL,                             -- ID do jogador (relacionado ao sistema vRP)
    valor_aposta DECIMAL(10, 2) NOT NULL,            -- Valor apostado
    bicho_escolhido INT NOT NULL,                    -- ID do bicho escolhido
    premio_1 INT NOT NULL,                           -- ID do bicho do 1º prêmio
    premio_2 INT NOT NULL,                           -- ID do bicho do 2º prêmio
    premio_3 INT NOT NULL,                           -- ID do bicho do 3º prêmio
    resultado VARCHAR(50) NOT NULL,                           -- ID do bicho do 3º prêmio
    valor_ganho DECIMAL(10, 2) NOT NULL DEFAULT 0.0, -- Valor ganho pelo jogador (ou 0)
    data_aposta DATETIME NOT NULL DEFAULT NOW(),     -- Data e hora da aposta
    INDEX (user_id),                                 -- Índice para melhorar consultas por usuário
    INDEX (data_aposta)                              -- Índice para melhorar consultas ordenadas por data
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
