local loaded_designs = {}

local extractID = function(src, _type)
  return GetPlayerIdentifierByType(src, _type)
end

local last_used = {}
postTextOnClient = function(src, type, message, design)
  local now = os.time()
  if last_used[src] then return false; end
  last_used[src] = now 
  SetTimeout(5000, function()
    last_used[src] = false
  end)

  if Config.allowCustomDesigns and not design then 
    local myId = extractID(src, Config.identifierType)
    design = loaded_designs[myId]
  end
  local myPed = GetPlayerPed(src)
  local myNetId = NetworkGetNetworkIdFromEntity(myPed)
  TriggerClientEvent("dirk-3dme:newText", -1, myNetId, type, message, design)
end


CreateThread(function()
  local rawFiles = LoadResourceFile(GetCurrentResourceName(), "saved_designs/data.json")
  if not rawFiles then 
    loaded_designs = {}
  else
    loaded_designs = json.decode(rawFiles) or {}
  end 
  for k,v in pairs(Config.textTypes) do
    print('DIRK-3DME: Registering command: /' .. k)
    RegisterCommand(k, function(source, args, rawCommand)
      local src = source
      local message = table.concat(args, " ")
      postTextOnClient(src, k, message, v.design)
    end, false)
  end
end)

local checkHasDiscordRole = function(src)
  if not Config.lockCustomToRole then return true; end
  local roles = exports.Badger_Discord_API:GetDiscordRoles(src)
  if not roles then return false; end
  for k,v in pairs(Config.lockCustomToRole) do 
    for k2,v2 in pairs(roles) do 
      if v == v2 then return true; end
    end
  end

  notifyPlayer(src, "You do not have permission to use this command", "error")

  return false 
end


RegisterCommand('dirk-3dme:uploadBackground', function(source, args, rawCommand)
  local hasRole = checkHasDiscordRole(source)
  if not hasRole then return false; end
  local src = source
  local myId = extractID(src, Config.identifierType)
  local myDesign = loaded_designs[myId]
  if not myDesign then loaded_designs[myId] = {}; end

  local mySite = args[1]
  if not mySite then return false; end
  loaded_designs[myId].background = mySite
  
  SaveResourceFile(GetCurrentResourceName(), "saved_designs/data.json", json.encode(loaded_designs, {indent = true}) )

  notifyPlayer(src, "Your design has been updated!", "success")

end, false)

RegisterCommand('dirk-3dme:uploadImage', function(source, args, rawCommand)
  local hasRole = checkHasDiscordRole(source)
  if not hasRole then return false; end
  local mySite = args[1]
  if not mySite then return false; end
  local src = source
  local myId = extractID(src, Config.identifierType)
  local myDesign = loaded_designs[myId]
  if not myDesign then loaded_designs[myId] = {}; end
  loaded_designs[myId].backgroundLogo = mySite
  SaveResourceFile(GetCurrentResourceName(), "saved_designs/data.json", json.encode(loaded_designs, {indent = true}) )

  notifyPlayer(src, "Your design has been updated!", "success")

end, false)
