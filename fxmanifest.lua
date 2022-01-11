fx_version 'cerulean'
game 'gta5'

author 'Clementinise'
name '^6KC Unicorn Script'
description 'Bring life & interactions to the Unicorn Club'
github 'https://github.com/clementinise/kc-unicorn'
version '1.0'

shared_scripts {
	'locales/*.lua',
	'config.lua',
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
	'client/*.lua'
}

server_script 'server/*.lua'

fivem_checker 'yes'