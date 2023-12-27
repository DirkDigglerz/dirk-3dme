CreateThread(function()
  for k,v in pairs(Config.textTypes) do
    print('Registering command ', k) 
    RegisterCommand(k, function(source, args, rawCommand)
      print('Command')
      local message = table.concat(args, " ", 1)
      local myPed = GetPlayerPed(source)
      print('my ped is ', myPed)
      local myNetId = NetworkGetNetworkIdFromEntity(myPed)
      print('my net id is ', myNetId)
      TriggerClientEvent("dirk-3dme:newText", -1, myNetId, k, message)
    end, false)
  end
end)

