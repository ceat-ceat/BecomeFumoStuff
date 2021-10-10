local plrs,http = game:GetService("Players"),game:GetService("HttpService")
local BBF = loadstring(game:HttpGet("https://raw.githubusercontent.com/ceat-ceat/BecomeFumoStuff/main/BBF/BBF.lua"))()
if not BBF then return end
if _G.BBFbnt then BBF.warn("BetterNameTags is already running, silly!",3) return end
local localplayer = plrs.LocalPlayer or plrs:GetPropertyChangedSignal("LocalPlayer"):Wait()
_G.BBFbnt = true
local nametags = {}

local settings do
	local function updatetags()
		for i, v in next, nametags do
			local sdn,sun = settings.showdisplayname.Value,settings.showusername.Value
			v.BB.Active = sdn and sun
			if i.Name ~= i.DisplayName then
				local usertransparency = (sun and not sdn or i.Name == i.DisplayName) and 0 or not sun and 1 or 0.6
				BBF.tween(v.BB:WaitForChild("User"),{Size=UDim2.new(1, 0,sun and not sdn and 1 or 0.2, 0),TextTransparency=usertransparency,TextStrokeTransparency=usertransparency},0.3):Play()
				BBF.tween(v.BB:WaitForChild("Display"),{Size=UDim2.new(1, 0,sdn and 1 or 0.2, 0),TextTransparency=(sdn and not sun) and 0 or not sdn and 1 or 0,TextStrokeTransparency=(sdn and not sun) and 0 or not sdn and 1 or 0},0.3):Play()
			else
				BBF.tween(v.BB:WaitForChild("User"),{Size=UDim2.new(1, 0,sun and 1 or 0.2, 0),TextTransparency=sun and 0 or 1,TextStrokeTransparency=sun and 0 or 1},0.3):Play()
			end
		end
	end
	settings = {
		showdisplayname = {Value=true,Update=updatetags},
		showusername = {Value=true,Update=updatetags}, 
		reversenames = {Value=false,Update=function(value)
			for i, v in next, nametags do
				local username = string.format("@%s",i.Name)
				local bb = v.BB
				if i.Name ~= i.DisplayName then
					bb:WaitForChild("User").Text,bb:WaitForChild("Display").Text = value and i.DisplayName or username,value and username or i.DisplayName
				end
			end
		end},
		copyusernameonclick = {Value=true},
		enabled = {Value=true,Update=function(value)
			for i, v in next, nametags do
				v.BB.Enabled,v.real.Enabled  = value,not value
			end
		end},
		buttons = {},
		Ids = {{"Enabled","enabled","enabled"},{"Show DisplayNames","showdisplayname","sdn"},{"Show UserNames","showusername","sun"},{"Reverse Names","reversenames","rn"},{"Copy UserName on click","copyusernameonclick","cunoc"}}
	}
end


local success,data = pcall(readfile,"BBF_BNT_SETTINGS.json")
if success then
	local decoded,newdata = pcall(http.JSONDecode,http,data)
	if decoded then
		for i, v in next, settings.Ids do
			local setting,val = settings[v[2]],newdata[v[3]]
			if typeof(val) ~= "boolean" then val = settings.Value end
			setting.Value = val
			if setting.Update and v[2] ~= "showdisplayname" and v[2] ~= "showusername" then setting.Update(val) end
		end
		settings.showusername.Update()
	end
end

local window = BBF.new("BetterNameTags",Vector2.new(0.25, 0.7))

for i = 1, 5 do
	local setting = settings[settings.Ids[i][2]]
	local j = BBF.createElement("Boolean w/ Label",{Default=setting.Value,Position=Vector2.new(0.133, 0.208+0.14*(i-1)),Size=Vector2.new(0.75, 0.104),ButtonSize=0.2,Text=settings.Ids[i][1],PropertyOverrides={
		Parent = window.Frame
	}})
	j.ValueChanged:Connect(function(value)
		setting.Value = value
		if setting.Update then setting.Update(value) end
	end)
end

local screengui = BBF.create{
	Class = "ScreenGui",
	Parent = localplayer:WaitForChild("PlayerGui"),
	ResetOnSpawn = false,
	Name = "BetterNameTags"
}
if not game:IsLoaded() then game.Loaded:Wait() end
function setupplr(plr)
	local nametag = BBF.create{
		Class = "BillboardGui",
		Size = UDim2.new(2, 0,0.5, 0),
		StudsOffset = Vector3.new(0, 1.5, 0),
		Parent = screengui,
		Name = plr.Name,
		Active = true,
		{
			Class = "TextLabel",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0,1, 0),
			Font = Enum.Font.Fantasy,
			Text = settings.reversenames.Value and string.format("@%s",plr.Name) or plr.DisplayName,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextStrokeTransparency = 0,
			Visible = plr.Name ~= plr.DisplayName,
			ZIndex = 2,
			Name = "Display"
		},
		{
			Class = "TextLabel",
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0,1, 0),
			Size = UDim2.new(1, 0,plr.Name == plr.DisplayName and 1 or 0.4, 0),
			Font = Enum.Font.Fantasy,
			Text = plr.Name == plr.DisplayName and plr.Name or settings.reversenames.Value and plr.DisplayName or string.format("@%s",plr.Name),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextTransparency = plr.Name == plr.DisplayName and 0 or 0.6,
			TextStrokeTransparency = plr.Name == plr.DisplayName and 0 or 0.6,
			ZIndex = 1,
			Name = "User"
		}
	}
	nametag.Enabled = settings.enabled.Value
	local info = {Hovering=false,BB=nametag,real=nil}
	nametags[plr] = info
	local display,user = nametag:FindFirstChild("Display"),nametag.User
	local button = BBF.create{
		Class = "TextButton",
		Parent = nametag,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0,1, 0),
		Text = "",
		ZIndex = 3
	}
	if plr.Name ~= plr.DisplayName then
		button.MouseEnter:Connect(function()
			info.Hovering = true
			BBF.tween(user,{Size=UDim2.new(1, 0,1, 0),TextTransparency=0,TextStrokeTransparency=0,ZIndex=2},0.3):Play()
			BBF.tween(display,{Size=UDim2.new(1, 0,settings.showusername.Value and 0.2 or 1, 0),TextTransparency=settings.showusername.Value  and 0.6 or 0,TextStrokeTransparency=settings.showusername.Value and 0.6 or 0,ZIndex=1},0.3):Play()
		end)
		button.MouseLeave:Connect(function()
			info.Hovering = false
			BBF.tween(display,{Size=UDim2.new(1, 0,1, 0),TextTransparency=0,TextStrokeTransparency=0,ZIndex=2},0.3):Play()
			BBF.tween(user,{Size=UDim2.new(1, 0,settings.showdisplayname.Value and 0.2 or 1, 0),TextTransparency=settings.showdisplayname.Value and 0.6 or 0,TextStrokeTransparency=settings.showdisplayname.Value and 0.6 or 0,ZIndex=1},0.3):Play()
		end)
	end
	button.MouseButton1Click:Connect(function()
		if not settings.copyusernameonclick.Value then return end
		local toclipboard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
		if not toclipboard then warn("Incompatible exploit, could not copy username") return end
		toclipboard(plr.Name)
	end)
	local function setupchr(chr)
		local head = chr:WaitForChild("Head"):WaitForChild("Head")
		nametag.Adornee = head
		local realnametag = head:WaitForChild("NameTag")
		info.real,realnametag.Enabled = realnametag,not settings.enabled.Value
		nametag.StudsOffset = realnametag.StudsOffset
		info.Hovering = false
	end
	if plr.Character then setupchr(plr.Character) end
	plr.CharacterAdded:Connect(setupchr)
end

for i, v in next, plrs:GetPlayers() do
	setupplr(v)
end 
plrs.PlayerAdded:Connect(setupplr)
plrs.PlayerRemoving:Connect(function(plr)
	if plr == localplayer then
		local savedata = {}
		for i, v in next, settings.Ids do
			savedata[v[3]] = settings[v[2]].Value
		end
		pcall(writefile,"BBF_BNT_SETTINGS.json",http:JSONEncode(savedata))
	end
	nametags[plr].BB:Destroy()
	nametags[plr] = nil
end)
