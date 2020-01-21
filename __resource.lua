resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ELS FiveM'

version '1.7'

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