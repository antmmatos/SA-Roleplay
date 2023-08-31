fx_version "adamant"
game "gta5"

ui_page 'html/ui.html'

shared_script '@es_extended/imports.lua'

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"config.lua",
	"server.lua"
}

client_scripts {
	"config.lua",
	"client.lua"
}

files {
  'html/ui.html',
  'html/ui.css', 
  'html/ui.js'
}