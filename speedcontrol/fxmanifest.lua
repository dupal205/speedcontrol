fx_version 'cerulean'
game 'gta5'

server_scripts {
    "@vrp/lib/utils.lua",
    "server.lua",
    "config.lua"
}

client_scripts {
    "@vrp/client/Tunnel.lua",
    "@vrp/client/Proxy.lua",
    "client.lua"
}

ui_page 'html/index.html'
file 'html/**'