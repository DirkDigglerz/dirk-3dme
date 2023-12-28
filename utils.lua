
local isServer = IsDuplicityVersion()
QBCore = exports['qb-core']:GetCoreObject() --\\ Uncomment for QBCORE
-- ESX = exports['es_extended']:getSharedObject() --\\ Uncomment for ESX

if isServer then 
  notifyPlayer = function(src, msg, type)

    
    --[[
       UNCOMMENT BELOW FOR QBCORE
    ]]
    -- local player = QBCore.Functions.GetPlayer(src)
    -- if not player then return false; end
    -- player.Functions.Notify(msg, type)

    --[[
       UNCOMMENT BELOW FOR ESX
    ]]
    -- local player = ESX.GetPlayerFromId(src)
    -- if not player then return false; end
    -- player.showNotification(msg, type)

    TriggerClientEvent('chat:addMessage', src, {
      color = type == "error" and {255, 0, 0} or {0, 255, 0},
      multiline = true,
      args = {'DIRK-3DME', msg}
    })
  end
else
  notifyPlayer = function(msg, type)


    --[[
       UNCOMMENT BELOW FOR QBCORE
    ]]
    QBCore.Functions.Notify(msg, type)

    --[[
       UNCOMMENT BELOW FOR ESX
    ]]
    -- ESX.ShowNotification(msg, type)

    TriggerEvent('chat:addMessage', {
      color = type == "error" and {255, 0, 0} or {0, 255, 0},
      multiline = true,
      args = {'DIRK-3DME', msg}
    })
  end
end