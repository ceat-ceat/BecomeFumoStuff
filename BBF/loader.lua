loadstring(game:HttpGet("https://raw.githubusercontent.com/ceat-ceat/BecomeFumoStuff/main/BBF/BBF.lua"))()
for i, v in next, {
    "https://raw.githubusercontent.com/ceat-ceat/BecomeFumoStuff/main/BBF/DefaultPlugins/BetterNameTags.lua"
  } do
  loadstring(game:HttpGet(v))()
end
