local defplugins = {
    "https://raw.githubusercontent.com/ceat-ceat/BecomeFumoStuff/main/BBF/DefaultPlugins/BetterNameTags.lua"
  }
loadstring(game:HttpGet("https://raw.githubusercontent.com/ceat-ceat/BecomeFumoStuff/main/BBF/BBF.lua"))()
for i, v in next, defplugins do
  loadstring(game:HttpGet(v))()
end
