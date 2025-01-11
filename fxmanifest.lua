fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Fabio'

shared_script {'config.lua', 'webhook.lua', 'historico.lua', 'transacoes.lua'}

client_scripts {'@vrp/lib/utils.lua', 'client.lua'}

server_scripts {'@vrp/lib/utils.lua', 'server.lua'}

ui_page "html/index.html"

files {'html/**/*'}
