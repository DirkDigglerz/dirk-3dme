local displayPlayers = {}


local currentDisplay = {}


local generateID = function(entity)
  local id = string.format('%s-%s', entity, math.random(1, 999999))
  if currentDisplay[id] then
    return generateID(entity)
  end
  return id
end


local displayEntityText = function(entity, messages, pos)
  local updateScreenPos = false
  local toAdd = {}
  for i = 1, #messages do
    local message = messages[i]
    if message then 
      if not currentDisplay[message.id] then
        toAdd[#toAdd + 1] = {
          id = message.id,
          message = message.msg, 
          action  = message.action,
          icon = Config.textTypes[message.action].icon,
          label = Config.textTypes[message.action].label,
        }
        currentDisplay[message.id] = true
      else
        updateScreenPos = true
      end
    end

  end

  if #toAdd > 0 then
    SendNuiMessage(json.encode({
      action = 'addEntityText',
      messages = toAdd,
      pos = pos,
      entity = entity,
    }))
  else
    if updateScreenPos then 
      SendNuiMessage(json.encode({
        action = 'updateEntityText',
        pos = pos,
        entity = entity,
      }))
    end
  end
end



local removeIndividualText = function(entity, id)
  if not currentDisplay[id] then return false; end 
  currentDisplay[id] = nil
  SendNuiMessage(json.encode({
    action = 'removeIndividualText',
    messageID = id,
    entity = entity,
  }))

  local messageCount = #displayPlayers[entity]
  if messageCount == 0 then 
    displayPlayers[entity] = nil
  end
end

local removeEntityText = function(entity)
  local countToRemove = 0
  local displayEntity = displayPlayers[entity]
  if not displayEntity then return false; end
  for i = 1, #displayEntity do
    local message = displayEntity[i]
    if message and currentDisplay[message.id] then 
      countToRemove = countToRemove + 1
      currentDisplay[message.id] = nil
    end
  end

  if countToRemove == 0 then return false; end
  SendNuiMessage(json.encode({
    action = 'removeEntityText',
    entity = entity,
  }))
end

newText = function(netId, action, msg)
  local textDetails = Config.textTypes[action]
  local existsOnNetwork = NetworkDoesEntityExistWithNetworkId(netId)
  if not existsOnNetwork then return false; end 
  local getPlayerEntity = NetworkGetEntityFromNetworkId(netId)
  if not DoesEntityExist(getPlayerEntity) then return false; end
  if not displayPlayers[getPlayerEntity] then displayPlayers[getPlayerEntity] = {} end
  local newIndex = #displayPlayers[getPlayerEntity] + 1
  local newID = generateID(getPlayerEntity)
  displayPlayers[getPlayerEntity][newIndex] = {id = newID, action = action, msg = msg}

  ---## Timeouit to remove 
  SetTimeout(textDetails.timeout, function()
    if displayPlayers[getPlayerEntity] == nil then return false; end
    displayPlayers[getPlayerEntity][newIndex] = nil
    removeIndividualText(getPlayerEntity, newID)
  end)
end

RegisterNetEvent('dirk-3dme:newText', newText)





CreateThread(function()
  while true do 
    local wait_time = 500
    local ply = PlayerPedId()
    local myPos = GetEntityCoords(ply)
    for entity, messages in pairs(displayPlayers) do
      local otherPlayerPos = GetEntityCoords(entity)
      local offsetPos    = vector3(otherPlayerPos.x + Config.offset.x, otherPlayerPos.y + Config.offset.y, otherPlayerPos.z + Config.offset.z)
      local dist = #(myPos - offsetPos)
      if dist <= Config.textDisplayDistance then
        wait_time = 0 
        local ret, xxx, yyy = GetHudScreenPositionFromWorldPosition(offsetPos.x, offsetPos.y, offsetPos.z)
        local onScreen = ret ~= 2 and ret ~= 3 and ret ~= 4 and true or false
        if onScreen then 
          displayEntityText(entity, messages, {x = xxx * 100, y = yyy * 100})
        else
          removeEntityText(entity)
        end
      else
        removeEntityText(entity)
      end
    end
    Wait(wait_time)
  end
end)