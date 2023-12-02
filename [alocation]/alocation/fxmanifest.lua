fx_version 'adamant'
game 'gta5'
description 'AntOne of M'

fx_version 'cerulean'

games { 'gta5' };

lua54 'yes'


shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}

client_scripts {
    'config/*.lua',
    'client/*.lua'
    
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    'config/*.lua',
    'server/*.lua'
}
