fx_version 'cerulean' 
lua54 'yes' 
games { 'rdr3', 'gta5' } 
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.' 
author 'DirkScripts' 
description '3D ME System from dirkscripts.com' 
version '1.0.0' 
 
shared_script{ 
  'config.lua', 
  'utils.lua',
} 
 
client_script { 
  'client.lua',
} 
 
server_script { 
  'server.lua',
} 

escrow_ignore{
  'save_designs/*.json',
  'utils.lua', 
  'config.lua',
}

server_export{
  'postTextOnClient', --## ARGS: src, type, message, design
}

-- NUI
ui_page 'nui/index.html'

files{
  'nui/index.html',
  -- MAIN
  'nui/main.css',
  -- MODULES
  'nui/main.js',
  -- IMAGES
  'nui/imgs/*.png',
  'nui/imgs/*.jpg',
}

