local displayPlayers = {}


local currentDisplay = {}

local deepCloneTable = function(original)
  local cloned = {}
  for key, value in pairs(original) do
    if type(value) == "table" then
      cloned[key] = deepCloneTable(value)  -- Recursive call for nested tables
    else
      cloned[key] = value  -- Copy non-table values directly
    end
  end
  
  return cloned
end

local generateID = function(entity)
  local id = string.format('TextID_%s_%s', entity, math.random(1, 999999))
  if currentDisplay[id] then
    return generateID(entity)
  end
  return id
end




local displayEntityText = function(entity, messages, pos, dist)
  local updateScreenPos = false
  local toAdd = {}

  for k,v in pairs(messages) do 

    local exists = currentDisplay[v.id]
    if not exists then 
      currentDisplay[v.id] = true
      local design = deepCloneTable(Config.textTypes[v.action].design or Config.baseDesign)
      if v.design then 
        design.background =  v.design.background
        design.backgroundLogo = v.design.backgroundLogo
      end
    
      toAdd[#toAdd + 1] = {
        id = v.id,
        message = v.msg, 
        action  = v.action,
        icon = Config.textTypes[v.action].icon,
        label = Config.textTypes[v.action].label,
        design = design,
      }
    end
  end

  if #toAdd == 0 then 
    SendNuiMessage(json.encode({
      action = 'updateEntityText',
      entity = entity,
      pos = pos,
    }))
    return 
  end
  SendNuiMessage(json.encode({
    action = 'addEntityText',
    messages = toAdd,
    pos = pos,
    entity = entity,
  }))

end

local removeEntityText = function(entity)
  for k,v in pairs(displayPlayers[entity]) do 
    currentDisplay[v.id] = nil
  end
  SendNuiMessage(json.encode({
    action = 'removeEntityText',
    entity = entity,
  }))
end

local findIndexById = function(entity, id)
  for k,v in pairs(displayPlayers[entity]) do 
    if v.id == id then return k; end
  end
  return false
end

local removeIndividualText = function(entity, id)
  currentDisplay[id] = nil
  SendNuiMessage(json.encode({
    action = 'removeIndividualText',
    messageID = id,
    entity = entity,
  }))
  local messageExists = findIndexById(entity, id)
  if messageExists then 
    table.remove(displayPlayers[entity], messageExists)
  end

  local messageCount = #displayPlayers[entity]
  if messageCount == 0 then 
    removeEntityText(entity)
    displayPlayers[entity] = nil
  end
end



newText = function(netId, action, msg, design)
  local textDetails = Config.textTypes[action]
  local existsOnNetwork = NetworkDoesEntityExistWithNetworkId(netId)
  if not existsOnNetwork then return false; end 
  local getPlayerEntity = NetworkGetEntityFromNetworkId(netId)
  if not DoesEntityExist(getPlayerEntity) then return false; end
  if not displayPlayers[getPlayerEntity] then displayPlayers[getPlayerEntity] = {} end
  local newIndex = #displayPlayers[getPlayerEntity] + 1
  local newID = generateID(getPlayerEntity)
  displayPlayers[getPlayerEntity][newIndex] = {id = newID, action = action, msg = msg, design = design}

  ---## Timeouit to remove 
  SetTimeout(textDetails.timeout, function()
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
        local positionOffset = GetOffsetFromEntityInWorldCoords(entity, Config.offset.x, Config.offset.y, Config.offset.z)
        local ret, xxx, yyy = GetHudScreenPositionFromWorldPosition(positionOffset.x, positionOffset.y, positionOffset.z)
        local onScreen = ret ~= 2 and ret ~= 3 and ret ~= 4 and true or false
        if onScreen then 
          displayEntityText(entity, messages, {x = xxx * 100, y = yyy * 100}, dist)
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


for action, textDetails in pairs(Config.textTypes) do
  TriggerEvent('chat:addSuggestion', '/' .. action, textDetails.chatSuggestion, {
    { name="message", help=Config.enterMessageText },
  })
end

TriggerEvent('chat:addSuggestion', '/dirk-3dme:uploadBackground', Config.uploadBGSuggestion, {
  { name="image", help=Config.theURL },
})

TriggerEvent('chat:addSuggestion', '/dirk-3dme:uploadImage', Config.uploadLogoSuggestion, {
  { name="image", help=Config.theURL },
})