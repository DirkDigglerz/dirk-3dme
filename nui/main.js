let curDisplay = {}





let removeEntityText = function(entity) {
  let curActive = curDisplay[entity]
  if (curActive) {
    curActive.container.remove()
    delete curDisplay[entity]
  }
} 



let removeMessageById = function(entity, messageID) {
  let curActive = curDisplay[entity]
  if (curActive) {
    let curMessage = curActive.messages[messageID]
    if (curMessage) {
      curMessage.container.remove()
      delete curDisplay[entity].messages[messageID]
    }
  }
}
let removeIndividualText = function(entity, messageID) {
  let curActive = curDisplay[entity]
  if (!curActive) {
    return
  }
  let curMessage =  curDisplay[entity].messages[messageID]

  if (!curMessage) {
    return
  }

  curMessage.container.remove()


  delete  curDisplay[entity].messages[messageID]




  let currentMsgLength = Object.keys(curDisplay[entity].messages).length  
  if (currentMsgLength == 0) {
    removeEntityText(entity)
  }
}



let updateEntityText = function(entity, pos) {
  let curActive = curDisplay[entity]
  if (curActive) {
    curActive.container.css({
      left: pos.x + "%",
      top: pos.y + "%",
    })
  }
}


addEntityText = function(entity, messages, pos) {
  let curActive = curDisplay[entity]
  if (!curActive) {
    curDisplay[entity] = {
      messages: {},
      container: $("<textBox></textBox>").appendTo("body"),
    }
  }
  let curContainer = curDisplay[entity].container

  //  ENSURE CORRECT POSITION
  curContainer.css({
    left: pos.x + "%",
    top: pos.y + "%",
  })

  // convert to upper string 
  

  for (let i = 0; i < messages.length; i++) {
    let message = messages[i]
    let messageID = message.id
    let curMessage = curDisplay[entity].messages[messageID]
    if (!curMessage) {
      curDisplay[entity].messages[messageID] = {
        message: message,
        container: $(`
        <message> 
          <topLeftBubble>${message.action.toUpperCase()}</topLeftBubble>
          <backgroundImg></backgroundImg>
          <backgroundLogo></backgroundLogo>
          <content>${message.message}</content>
        </message>`).appendTo(curContainer),
      }
    }
    

  }
}





window.addEventListener('message', function(event) {
  if (event.data.action == "addEntityText") {
    addEntityText(event.data.entity, event.data.messages, event.data.pos)
  } else if (event.data.action == "removeEntityText") {
    removeEntityText(event.data.entity)
  } else if (event.data.action == "removeIndividualText") {
    removeIndividualText(event.data.entity, event.data.messageID)
  } else if (event.data.action == "updateEntityText") {
    updateEntityText(event.data.entity, event.data.pos)
  }

})