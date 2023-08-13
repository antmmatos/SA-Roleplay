fx_version 'adamant'
game 'gta5'


ui_page "interface/ui.html"

files {
    "interface/ui.html",
	"interface/assets/*.png",
	"interface/assets/faces/*.jpg",
	"interface/fonts/Circular-Bold.ttf",
	"interface/fonts/Circular-Book.ttf",
	"interface/js/app.js",
	"interface/js/vuescript.js",
	"interface/style.css",
}

client_scripts {
	'@es_extended/imports.lua',
    'client.lua',
}

dependencies {
	'es_extended'
}