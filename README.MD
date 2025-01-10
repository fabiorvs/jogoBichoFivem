
# Jogo do Bicho - FiveM

Este é um recurso para servidores FiveM que implementa o clássico Jogo do Bicho com NPCs interativos, uma interface de apostas personalizada e um sistema dinâmico de prêmios.


## Funcionalidades

#### NPCs Personalizados
- NPCs Configuráveis: Modelos de NPCs específicos configurados via config.lua.
    - Localização Personalizada: NPCs posicionados em diferentes locais no mapa, com rotação e tabelas decorativas.
    - Blips no Mapa: Cada NPC possui um blip personalizado no mapa, identificado como "Jogo do Bicho", facilitando a localização para os jogadores.
-  Sistema de Apostas
    - Interface NUI:
        - Permite selecionar o bicho desejado e o valor da aposta de forma intuitiva.
        - Design responsivo e fácil de usar.
    - Três Prêmios:
        - Sorteio de três bichos para 1º, 2º e 3º prêmios, com multiplicadores configuráveis (padrão: x10, x5, x2).
        - Resultados exibidos com mensagens dinâmicas informando o prêmio e o valor ganho, ou se o jogador perdeu.
    - Tela de Sorteio Animada:
        - Exibe as imagens dos bichos girando aleatoriamente antes de revelar os resultados, proporcionando uma experiência imersiva.
        - Legendas para identificar o 1º, 2º e 3º prêmios durante o sorteio.
- Notificações e Feedback
    - Feedback Dinâmico via NUI:
    - Mensagens claras sobre o resultado da aposta, incluindo o valor ganho e os bichos sorteados.
    - Notificações para Erros e Interações:
        - Avisos amigáveis para casos como falta de dinheiro, valores inválidos ou seleção de bicho inválida.
    - Envio de Logs por Webhook (opcional):
        - Envia detalhes das apostas realizadas, incluindo:
            - ID do jogador.
            - Valor apostado.
            - Bicho escolhido.
            - IDs dos bichos sorteados nos prêmios.
            - Resultado do jogo (1º, 2º, 3º prêmio ou perda).
            - Valor ganho.
- Totalmente configurável via config.lua.

## Screenshots

![Print 1](https://raw.githubusercontent.com/fabiorvs/jogoBichoFivem/refs/heads/main/prints/1.png)

![Print 2](https://raw.githubusercontent.com/fabiorvs/jogoBichoFivem/refs/heads/main/prints/2.png)

![Print 3](https://raw.githubusercontent.com/fabiorvs/jogoBichoFivem/refs/heads/main/prints/3.png)

![Print 4](https://raw.githubusercontent.com/fabiorvs/jogoBichoFivem/refs/heads/main/prints/4.png)

![Print 5](https://raw.githubusercontent.com/fabiorvs/jogoBichoFivem/refs/heads/main/prints/5.png)

![Game](https://raw.githubusercontent.com/fabiorvs/jogoBichoFivem/refs/heads/main/prints/game.gif)