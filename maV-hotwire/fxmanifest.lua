fx_version "adamant"

description "MaveraV Store"
author "w1z4rd_"
version '1.0.0'
repository 'https://discord.gg/6xnpZqUkaP'

game "gta5"

client_scripts {
    'config.lua',
    'client.lua',

}
server_scripts {

    'config.lua',
    'server.lua',

}


escrow_ignore { 'config.lua' }

lua54 'yes'