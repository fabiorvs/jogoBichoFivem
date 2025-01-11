-- Criação da tabela para saldo global do jogo do bicho
CREATE TABLE jogobicho_saldo (
    id INT AUTO_INCREMENT PRIMARY KEY,          -- Identificador único (sempre 1 registro)
    saldo DECIMAL(20, 2) NOT NULL DEFAULT 0.00, -- Saldo global do jogo do bicho
    atualizado_em DATETIME DEFAULT NOW() ON UPDATE NOW() -- Data e hora da última atualização
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Inserir o saldo inicial de 1 milhão
INSERT INTO jogobicho_saldo (saldo) VALUES (1000000.00);

CREATE TABLE jogobicho_historico_transacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,        -- Identificador único da transação
    tipo_transacao VARCHAR(255) NOT NULL, -- Tipo de transação
    valor DECIMAL(10, 2) NOT NULL,            -- Valor da transação
    descricao VARCHAR(255) DEFAULT NULL,      -- Descrição opcional
    data_transacao DATETIME NOT NULL DEFAULT NOW(), -- Data e hora da transação
    saldo_apos DECIMAL(10, 2) DEFAULT NULL,   -- Saldo após a transação
    INDEX(tipo_transacao),                    -- Índice para consultas por tipo de transação
    INDEX(data_transacao)                     -- Índice para consultas por data
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;