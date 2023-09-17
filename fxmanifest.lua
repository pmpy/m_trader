fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'Manny'
description 'VORP compatible pelt / animal parts trader script'

dependencies {
    'uiprompt',
    'redemrp_menu_base',
}

shared_scripts {
    'shared/sh_*.lua'
}

client_scripts {
    "@uiprompt/uiprompt.lua",
    'client/cl_init.lua',
    'client/cl_*.lua'
}

server_scripts {
    'server/sv_init.lua',
    'server/sv_*.lua'
}