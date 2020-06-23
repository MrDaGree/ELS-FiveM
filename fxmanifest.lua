fx_version 'bodacious'
games { 'gta5' }

author 'MrDaGree'
description 'ELS FiveM'
version '1.7.0'

client_script {
    'vcf.lua',
    'config.lua',
    'client/**/*.lua'
}

server_script {
    'vcf.lua',
    'config.lua',
    'server/server.lua',
    'server/xml.lua'
}

shared_script 'shared/*.lua'


