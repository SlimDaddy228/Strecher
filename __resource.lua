dependency "vrp"

client_scripts {
	"lib/Proxy.lua",
	"lib/Tunnel.lua",
	"client.lua",
	"prop.lua",
	"katalka.lua"
}

server_scripts {
    "@vrp/lib/utils.lua",
	"server.lua"
}

ui_page 'index.html'

files {
	"index.html"
}