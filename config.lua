Config = {
  identifierType     = "fivem", --## This is the identifier type that will be used to save the designs.
  allowCustomDesigns = true, --## allow players to use the commands to upload their own designs
  lockCustomToRole   = false, --## Bunch of roles that can use the custom designs can also be false to allow everyone to use this feature
  --[[
    addBackgroundImageCommand = "dirk-3dme:uploadBackground", --## This is the command that will be used to upload the background image
    addLogoImageCommand       = "dirk-3dme:uploadLogo", --## This is the command that will be used to upload the logo image
  ]]
 
  baseDesign = {
    backgroundOpacity  = "0.5", --## This is the opacity of the background
    backgroundLogo     = "imgs/serverLogo.png",
    backgroundLogoSize = "100% 100%",
    background      = "imgs/background.png",
    backgroundSize  = "cover",
    bubbleOutline   = "solid 2px #000",
    bubbleTextColor = "black",
    bubbleColor     = "rgba(255, 255, 255, 1.0)",
    messageOutline  = "2px solid white",
  },  


  --## CHAT COMMAND SUGGESTION STUFF
  enterMessageText      = "Insert the message you wish to display here", --## used for the chat suggestion
  uploadBGSuggestion    = "Upload a background image for your 3DME",
  uploadLogoSuggestion  = "Upload a logo image for your 3DME",
  theURL                = "The URL of the image you wish to upload",


  offset              = vector3(0.0, 0.0, 1.3), --## Will be off to the side of the ped 
  textDisplayDistance = 25.0, --## how far to show the text

  textTypes = {
    ['do'] = {
      label = "Do",
      icon  = "fas fa-question-circle",
      timeout = 5000,
      chatSuggestion = "Use this command to describe what your character is doing. For example: /do is wearing a black jacket and jeans.",
      -- OPTIONAL DESIGN PER COMMAND
      --[[
        design = { 
          backgroundOpacity  = "0.5", --## This is the opacity of the background
          backgroundLogo     = "imgs/serverLogo.png",
          backgroundLogoSize = "100% 100%",
          background      = "imgs/background.png",
          backgroundSize  = "cover",
          bubbleOutline   = "solid 2px #000",
          bubbleTextColor = "black",
          bubbleColor     = "rgba(255, 255, 255, 1.0)",
          messageOutline  = "2px solid white",
        },
      ]]
    },

    ['me'] = {
      label = "Me",
      icon  = "fas fa-info-circle",
      timeout = 5000,
      chatSuggestion = "Use this command to describe what your character is doing. For example: /do is wearing a black jacket and jeans.",
    }
  }
}


