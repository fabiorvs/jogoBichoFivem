-- webhook.lua
local Webhook = {}

-- Função para enviar log ao webhook
function Webhook.sendLog(url, title, description, fields, color)
    if not url or url == "" then
        print("URL do webhook não configurada.")
        return
    end

    -- Montar o payload do log
    local logMessage = {
        embeds = {
            {
                title = title,
                description = description or "",
                fields = fields or {},
                color = color or 16777215, -- Branco padrão se nenhuma cor for fornecida
                footer = {
                    text = os.date("%d/%m/%Y %H:%M:%S") -- Adiciona timestamp no footer
                }
            }
        }
    }

    -- Realiza o envio para o webhook
    PerformHttpRequest(url, function(err, text, headers)
        if err == 200 or err == 202 or err == 204 then
            print("Log enviado com sucesso para o webhook.")
        else
            print(string.format("Erro ao enviar log para o webhook. Código HTTP: %d. Resposta: %s", err, text))
        end
    end, "POST", json.encode(logMessage), { ["Content-Type"] = "application/json" })
end

return Webhook
