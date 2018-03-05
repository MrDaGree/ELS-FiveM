description "ELS FiveM" -- Resource Descrption

client_script {
	'config.lua',
	'client/client.lua',
	'client/leds.lua',
	'client/patterns.lua',
}

server_script {
	'config.lua',
	'server/server.lua',
	'server/xml.lua',
}

ui_page 'client/index.html'

files {
	"client/index.html",
	"client/jquery.min.js",
	"client/script.js",
}