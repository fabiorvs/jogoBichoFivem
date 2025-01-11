CREATE TABLE jogobicho_donos (
    id INT AUTO_INCREMENT PRIMARY KEY,              -- Identificador único do registro
    user_id INT NOT NULL,                           -- Identificador do jogo do bicho
    data_inicio DATETIME NOT NULL DEFAULT NOW(),    -- Data de início como dono
    data_fim DATETIME DEFAULT NULL,                 -- Data de término como dono (NULL enquanto for o atual)
    atual BOOLEAN NOT NULL DEFAULT 1,               -- Flag para identificar o dono atual (1 = atual, 0 = não atual)
    FOREIGN KEY (id_jogo) REFERENCES jogobicho (id) -- Chave estrangeira referenciando a tabela principal do jogo
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO jogobicho_donos (user_id) VALUES (1);
