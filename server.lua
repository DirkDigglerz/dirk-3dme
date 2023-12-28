local loaded_designs = {}


local extractID = function(src, _type)
  return GetPlayerIdentifierByType(src, _type)
end

CreateThread(function()
  local rawFiles = LoadResourceFile(GetCurrentResourceName(), "saved_designs/data.json")
  if not rawFiles then 
    loaded_designs = {}
  else
    loaded_designs = json.decode(rawFiles)
  end 
  for k,v in pairs(Config.textTypes) do
    RegisterCommand(k, function(source, args, rawCommand)
      local src = source
      local myDesign = nil
      if Config.allowCustomDesigns then 
        local myId = extractID(src, Config.identifierType)
        myDesign = loaded_designs[myId]

      end

      local myPed = GetPlayerPed(src)
      local message = table.concat(args, " ", 1)
      local myNetId = NetworkGetNetworkIdFromEntity(myPed)

      TriggerClientEvent("dirk-3dme:newText", -1, myNetId, k, message, myDesign)
    end, false)
  end
end)

local checkHasDiscordRole = function(src)
  if not Config.lockCustomToRole then return true; end
  local roles = exports.Badger_Discord_API:GetDiscordRoles(src)
  print(json.encode(roles, {indent = true}))
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