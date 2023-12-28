let removeEntityText = function(entity) {
  let containerID = `entity-${entity}`
  let container = $(`#${containerID}`)
  if (container.length > 0) {
    container.remove()
  }

} 


let removeIndividualText = function(entity, messageID) {
  let message = $("body").find(`#${messageID}`)
  if (message.length > 0) {
    message.remove()
    
    let parent = message.parent()
    if (parent.children().length == 0) {
      parent.remove()
    }
  }
}

let updateEntityText = function(entity, pos) {
  let curEntityBox = $(`#entity-${entity}`)
  if (curEntityBox) {
    curEntityBox.css({
      left: pos.x + "%",
      top: pos.y + "%",
    })
  }
}


addEntityText = function(entity, messages, pos) {
  let containerID = `entity-${entity}`
  let container = $(`#${containerID}`)
  if (container.length == 0) {
    container = $(`<textBox id="${containerID}"></textBox>`).appendTo("body")
  }

  //  ENSURE CORRECT POSITION
  container.css({
    left: pos.x + "%",
    top: pos.y + "%",
  })

  // convert to upper string 
  
  for (let i = 0; i < messages.length; i++) {
    let message = messages[i]
    let messageID = message.id
    let curMessage = $(`#${messageID}`)
    if (curMessage.length == 0) {
      let newMessage = $(`
      <message id="${messageID}"> 
        <topLeftBubble>${message.action.toUpperCase()}</topLeftBubble>
        <backgroundImg></backgroundImg>
        <backgroundLogo></backgroundLogo>
        <content>${message.message}</content>
      </message>`).appendTo(container)

      newMessage.find('topLeftBubble').css({
        "background-color": message.design.bubbleColor,
        "outline-color": message.design.bubbleOutline,
        "color": message.design.bubbleTextColor,
      })

      newMessage.css({
        "outline": message.design.outline,
      });


      newMessage.find('backgroundImg').css({
        "opacity": message.design.backgroundOpacity,
        "background-image": `url(${message.design.background})`,
        "background-size": message.design.backgroundSize,
      })

      newMessage.find('backgroundLogo').css({
        "background-image": `url(${message.design.backgroundLogo})`,
        "background-size": message.design.backgroundLogoSize,
      })


    }
  }
}





window.addEventListener('message', function(event) {
  if (event.data.action == "addEntityText") {
    addEntityText(event.data.entity, event.data.messages, event.data.pos, event.data.scale)
  } else if (event.data.action == "removeEntityText") {
    removeEntityText(event.data.entity)
  } else if (event.data.action == "removeIndividualText") {
    removeIndividualText(event.data.entity, event.data.messageID)
  } else if (event.data.action == "updateEntityText") {
    updateEntityText(event.data.entity, event.data.pos, event.data.scale)
  }

})