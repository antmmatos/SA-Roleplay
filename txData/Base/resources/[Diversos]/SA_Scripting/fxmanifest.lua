fx_version 'cerulean'
game 'gta5'

shared_script {
    '@es_extended/imports.lua',
    'shared/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

client_scripts {
    'client/*.lua'
}