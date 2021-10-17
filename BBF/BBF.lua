local plrs,ts,startergui,rs,run = game:GetService("Players"),game:GetService("TweenService"),game:GetService("StarterGui"),game:GetService("ReplicatedStorage"),game:GetService("RunService")

function create(tree,parent)
	local inst = Instance.new(tree.Class)
	local parent2 = parent
	inst.Parent = parent or tree.Parent
	for i, v in next, tree do
		if i ~= "Class" then
			if typeof(v) == "table" and v.Class then
				create(v,inst)
			else
				inst[i] = v
			end
		end
	end
	return inst
end

function tween(inst,prop,dur,dir,eas)
	return ts:Create(inst,TweenInfo.new(dur,eas or Enum.EasingStyle.Quad,dir or Enum.EasingDirection.Out),prop)
end

if game.PlaceId ~= 6238705697 and not run:IsStudio() then return end
if _G.BBF then return _G.BBF end
local bbf = {}
local localplayer = plrs.LocalPlayer
local maingui = localplayer:WaitForChild("PlayerGui"):WaitForChild("MainGui")
local screengui = create{
	Class = "ScreenGui",
	Parent = localplayer:FindFirstChildOfClass("PlayerGui"),
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	DisplayOrder = 2,
	Name = "BBF"
}
local open = false
local reference = {SortOrders=Enum.SortOrder:GetEnumItems()}

local baseinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/ceat-ceat/roblox-script-utils/main/custominstance.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ceat-ceat/roblox-script-utils/main/fakebindable.lua"))()

-- ui setup

local settingsframe = maingui:WaitForChild("SettingsFrame")
local closeevent = settingsframe:WaitForChild("Close")
local button = create{
	Class = "TextButton",
	BackgroundTransparency = 0.95,
	BorderColor3 = Color3.fromRGB(255, 255, 255),
	Size = UDim2.new(0.85, 0,0.045, 0),
	Font = Enum.Font.Bodoni,
	Text = "become fumo but i added stuff to it",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextScaled = true,
	Name = "zBBF",
	Parent = settingsframe:WaitForChild("ScrollingFrame")
}

local frame = create{
	Class = "Frame",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0,0.5, 0),
	Size = UDim2.new(0, 0,0, 0),
	BackgroundTransparency = 1,
	Parent = screengui,
	Name = "BBF",
	{
		Class = "TextButton",
		BackgroundTransparency = 1,
		Position = UDim2.new(-0.008, 0,-0.02, 0),
		Size = UDim2.new(0.078, 0,0.118, 0),
		Font = Enum.Font.Code,
		Text = "X",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextScaled = true,
		TextStrokeTransparency = 0,
		ZIndex = 2,
		Name = "Close"
	},
	{
		Class = "TextLabel",
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.86, 0,0.007, 0),
		Size = UDim2.new(0.467, 0,0.072, 0),
		Font = Enum.Font.Code,
		Text = "BBF",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextScaled = true,
		TextStrokeTransparency = 0,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 2,
		Name = "Brand"
	},
	{
		Class = "ImageLabel",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0,1, 0),
		Image = "rbxassetid://6258462926",
		Name = "Background"
	},
	{
		Class = "ScrollingFrame",
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0,0.12, 0),
		Size = UDim2.new(0.8, 0,0.8, 0),
		CanvasSize = UDim2.new(0, 0,0, 0),
		ScrollBarImageColor3 = Color3.fromRGB(184, 255, 198),
		ScrollBarThickness = 12,
		{
			Class = "Frame",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0,0.448, 0),
			Name = "List",
			{
				Class = "UIListLayout",
				Padding = UDim.new(0.05, 0),
				Name = "Layout"
			},
			{
				Class = "UIAspectRatioConstraint",
				AspectRatio = 1.369,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Width
			}
		}
	},
	{
		Class = "UIAspectRatioConstraint",
		AspectRatio = 0.766,
		AspectType = Enum.AspectType.FitWithinMaxSize,
		DominantAxis = Enum.DominantAxis.Width
	}
}

local tweens = {
	[true] = tween(frame,{Size=UDim2.new(0.6, 0,0.7, 0),Visible=true},0.5),
	[false] = tween(frame,{Size=UDim2.new(0, 0,0, 0),Visible=false},0.5)
}

button.MouseButton1Click:Connect(function()
	open = not open
	tweens[open]:Play()
	closeevent:Fire()
end)
frame.Close.MouseButton1Click:Connect(function()
	open = false
	tweens[false]:Play()
end)
frame.ScrollingFrame.List.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	frame.ScrollingFrame.CanvasSize = UDim2.new(0, 0,0, frame.ScrollingFrame.List.Layout.AbsoluteContentSize.Y)
end)

-- functionality

local presets = {
	Button = {
		Class = "TextButton",
		BackgroundTransparency = 0.95,
		BorderColor3 = Color3.fromRGB(255, 255, 255),
		Size = UDim2.new(1, 0,0.3, 0),
		Font = Enum.Font.Bodoni,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextScaled = true
	},
	ScriptWindow = {
		Class = "Frame",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0,0.5, 0),
		Size = UDim2.new(),
		{
			Class = "Frame",
			BackgroundTransparency = 1,
			Position = UDim2.new(-0.008, 0,-0.02, 0),
			Size = UDim2.new(0.187, 0,0.118, 0),
			Name = "Buttons",
			ZIndex = 2,
			{
				Class = "TextButton",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0,1, 0),
				Font = Enum.Font.Code,
				Text = "X",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextStrokeTransparency = 0,
				ZIndex = 2,
				Name = "Close"
			},
			{
				Class = "TextButton",
				BackgroundTransparency = 1,
				Position = UDim2.new(1, 0,0, 0),
				Size = UDim2.new(1, 0,1, 0),
				Font = Enum.Font.Code,
				Text = "<",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextStrokeTransparency = 0,
				ZIndex = 2,
				Name = "Back"
			},
			{
				Class = "UIAspectRatioConstraint",
				AspectRatio = 1.212
			}
		},
		{
			Class = "Frame",
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0,0.5, 0),
			Size = UDim2.new(0.85, 0,0.85, 0),
			Name = "Screen"
		},
		{
			Class = "ImageLabel",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0,1, 0),
			Image = "rbxassetid://6258462926"
		}
	},
	Label = {
		Class = "TextLabel",
		BackgroundTransparency = 1,
		Font = Enum.Font.Fantasy,
		TextScaled = true,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextStrokeTransparency = 0
	},
	List = {
		Class = "ScrollingFrame",
		BackgroundTransparency = 1,
		CanvasSize = UDim2.new(0, 0,0, 0),
		ScrollBarImageColor3 = Color3.fromRGB(184, 255, 198),
		ScrollBarThickness = 12,
		{
			Class = "Frame",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0,0.448, 0),
			Name = "List",
			{
				Class = "UIListLayout",
				Padding = UDim.new(0.05, 0),
				Name = "Layout"
			},
			{
				Class = "UIAspectRatioConstraint",
				AspectRatio = 1.369,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Width
			}
		}
	},
	textbox = {
		Class = "TextBox",
		BackgroundTransparency = 0.95,
		BorderColor3 = Color3.fromRGB(255, 255, 255),
		Size = UDim2.new(1, 0,0.3, 0),
		Font = Enum.Font.Bodoni,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextScaled = true
	},
}

local elements do
	local function override(inst,prop)
		if typeof(prop) == "table" then
			for i, v in next, prop do
				inst[i] = v
			end
		end
	end
	elements = {
		Boolean = function(params)
			params.Position,params.Size = typeof(params.Position) == "Vector2" and params.Position or Vector2.new(),typeof(params.Size) == "Vector2" and params.Size or Vector2.new()
			local button,val = create(presets.Button),typeof(params.Default) == "boolean" and params.Default or false
			local bindable = _G.FakeBindable.new()
			button.Position,button.Size,button.Text = UDim2.new(params.Position.X, 0,params.Position.Y, 0),UDim2.new(params.Size.X, 0,params.Size.Y, 0),tostring(val)
			local obj = baseinstance.new("Boolean",{
				Value = {
					Value = val,
					Filter = function(value)
						assert(typeof(value) == "boolean")
						return value
					end,
				},
				Position = {
					Value = params.Position,
					Filter = function(value)
						assert(typeof(value) == "Vector2")
						return value
					end,
				},
				Size = {
					Value = params.Size,
					Filter = function(value)
						assert(typeof(value) == "Vector2")
						return value
					end,
				},
				Button = {
					ReadOnly = true,
					Value = button
				}
			},{
				ValueChanged = bindable.Event
			},{
				Destroy = function()
					button:Destroy()
				end,
			})
			button.MouseButton1Click:Connect(function()
				obj.Value = not obj.Value
			end)
			obj.Changed:Connect(function(prop,newval)
				if prop == "Value" then
					button.Text = tostring(newval)
					bindable:Fire(newval)
				elseif prop == "Position" then
					button.Position = UDim2.new(obj.Position.X, 0,obj.Position.Y, 0)
				elseif prop == "Size" then
					button.Size = UDim2.new(obj.Size.X, 0,obj.Size.Y, 0)
				end
			end)
			override(button,params.PropertyOverrides)
			return obj
		end,
		["Boolean w/ Label"] = function(params)
			params.Position,params.Size,params.ButtonSize,params.Default = typeof(params.Position) == "Vector2" and params.Position or Vector2.new(),typeof(params.Size) == "Vector2" and params.Size or Vector2.new(),tonumber(params.ButtonSize) or 0.2,typeof(params.Default) == "boolean" and params.Default or false
			local frame = create{
				Class = "Frame",
				BackgroundTransparency = 1,
				Position = UDim2.new(params.Position.X, 0,params.Position.Y,0 ),
				Size = UDim2.new(params.Size.X, 0,params.Size.Y, 0)
			}
			local bool,label = elements.Boolean{Default=params.Default,Size=Vector2.new(math.min(params.ButtonSize,0.5), 1)},elements.Label{Position=Vector2.new(math.min(params.ButtonSize,0.5)+0.02,0),Size=Vector2.new(1-math.min(params.ButtonSize,0.5)-0.02, 1),Text=params.Text,PropertyOverrides={
				TextXAlignment = Enum.TextXAlignment.Left
			}}
			bool.Button.Parent,label.Parent = frame,frame
			local obj = baseinstance.new("BooleanLabel",{
				Position = {
					Value = params.Position,
					Filter = function(value)
						assert(typeof(value) == "Vector2")
						return value
					end,
				},
				Size = {
					Value = params.Size,
					Filter = function(value)
						assert(typeof(value) == "Vector2")
						return value
					end,
				},
				ButtonSize = {
					Value = math.min(params.ButtonSize,0.5),
					Filter = function(value)
						return math.min(tonumber(value) or 0,0.5)
					end,
				},
				Frame = {
					ReadOnly = true,
					Value = frame
				}
			},{
				ValueChanged = bool.ValueChanged
			},{
				Destroy = function()
					frame:Destroy()
				end,
			})
			obj.Changed:Connect(function(prop,newval)
				if prop == "Position" then
					frame.Position = Vector2.new(newval.X, 0,newval.Y, 0)
				elseif prop == "Size" then
					frame.Size = Vector2.new(newval.X, 0,newval.Y, 0)
				elseif prop == "ButtonSize" then
					bool.Button.Size,label.Size = UDim2.new(newval, 0,1, 0),UDim2.new(1-newval, 0,1, 0)
				end
			end)
			override(frame,params.PropertyOverrides)
			return obj
		end,
		Button = function(params)
			params.Position,params.Size = typeof(params.Position) == "Vector2" and params.Position or Vector2.new(),typeof(params.Size) == "Vector2" and params.Size or Vector2.new()
			local button = create(presets.Button)
			local bindable = _G.FakeBindable.new()
			button.Position,button.Size,button.Text = UDim2.new(params.Position.X, 0,params.Position.Y, 0),UDim2.new(params.Size.X, 0,params.Size.Y, 0),tostring(params.Text or "")
			local obj = baseinstance.new("Boolean",{
				Position = {
					Value = params.Position,
					Filter = function(value)
						assert(typeof(value) == "Vector2")
						return value
					end,
				},
				Size = {
					Value = params.Size,
					Filter = function(value)
						assert(typeof(value) == "Vector2")
						return value
					end,
				},
				Text = {
					Value = button.Text,
					Filter = tostring,
				},
				Button = {
					ReadOnly = true,
					Value = button
				}
			},{
				Click = bindable.Event
			},{
				Destroy = function()
					button:Destroy()
				end,
			})
			button.MouseButton1Click:Connect(function()
				bindable:Fire()
			end)
			obj.Changed:Connect(function(prop,newval)
				if prop == "Position" then
					button.Position = UDim2.new(obj.Position.X, 0,obj.Position.Y, 0)
				elseif prop == "Size" then
					button.Size = UDim2.new(obj.Size.X, 0,obj.Size.Y, 0)
				elseif prop == "Text" then
					button.Text = newval
				end
			end)
			override(button,params.PropertyOverrides)
			return obj
		end,
		Label = function(params)
			params.Position,params.Size = typeof(params.Position) == "Vector2" and params.Position or Vector2.new(),typeof(params.Size) == "Vector2" and params.Size or Vector2.new()
			local label = create(presets.Label)
			label.Text,label.Position,label.Size = tostring(params.Text) or "",UDim2.new(params.Position.X, 0,params.Position.Y, 0),UDim2.new(params.Size.X, 0,params.Size.Y, 0)
			override(label,params.PropertyOverrides)
			return label
		end,
		TextBox = function(params)
			params.Position,params.Size = typeof(params.Position) == "Vector2" and params.Position or Vector2.new(),typeof(params.Size) == "Vector2" and params.Size or Vector2.new()
			local new = create(presets.textbox)
			new.Position,new.Size,new.PlaceholderText = UDim2.new(params.Position.X, 0,params.Position.Y, 0),UDim2.new(params.Size.X, 0,params.Size.Y, 0),params.PlaceHolderText == nil and "" or tostring(params.PlaceHolderText)
			new.Text = ""
			override(new,params.PropertyOverrides)
			return new
		end,
		List = function(params)
			params.Position,params.Size,params.Padding,params.SortOrder = typeof(params.Position) == "Vector2" and params.Position or Vector2.new(),typeof(params.Size) == "Vector2" and params.Size or Vector2.new(),typeof(params.Padding) == "UDim" and params.Padding or UDim.new(),table.find(reference.SortOrders,params.SortOrder) and params.SortOrder or Enum.SortOrder.LayoutOrder
			local new = create(presets.List)
			local layout = new.List.Layout
			new.Position,new.Size,layout.Padding,layout.SortOrder = UDim2.new(params.Position.X, 0,params.Position.Y, 0),UDim2.new(params.Size.X, 0,params.Size.Y, 0),params.Padding,params.SortOrder
			local obj = baseinstance.new("List",{
				Position = {
					Value = params.Position,
					Filter = function(value)
						assert(typeof(value) == "Vector2")
						return value
					end,
				},
				Size = {
					Value = params.Size,
					Filter = function(value)
						assert(typeof(value) == "Vector2")
						return value
					end,
				},
				Padding = {
					Value = params.Padding,
					Filter = function(value)
						assert(typeof(value) == "UDim")
						return value
					end,
				},
				SortOrder = {
					Value = params.SortOrder,
					Filter = function(value)
						assert(table.find(reference.SortOrders,value))
						return value
					end,
				},
				Frame = {
					ReadOnly = true,
					Value = new.List
				}
			},nil,{
				Destroy = function()
					new:Destroy()
				end,
			})
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				new.CanvasSize = UDim2.new(0, 0,0, layout.AbsoluteContentSize.Y)
			end)
			obj.Changed:Connect(function(prop,value)
				if prop == "Position" then
					new.Position = UDim2.new(value.X, 0,value.Y, 0)
				elseif prop == "Size" then
					new.Size = UDim2.new(value.X, 0,value.Y, 0)
				elseif prop == "Padding" then
					layout.Padding = value
				elseif prop == "SortOrder" then
					layout.SortOrder = value
				end
			end)
			override(new,params.PropertyOverrides)
			return obj
		end,
		Image = function(params)
			params.Position,params.Size = typeof(params.Position) == "Vector2" and params.Position or Vector2.new(),typeof(params.Size) == "Vector2" and params.Size or Vector2.new()
			local image = create{
				Class = "ImageLabel",
				Position = UDim2.new(params.Position.X, 0,params.Position.Y, 0),
				Size = UDim2.new(params.Size.X, 0,params.Size.Y, 0),
				Image = params.Image or "rbxasset://textures/ui/GuiImagePlaceholder.png"
			}
			override(image,params.PropertyOverrides)
			return image
		end,
	}
end

local scriptwindow = {}
scriptwindow.__index = scriptwindow

function scriptwindow:Destroy()
	self.Frame:Destroy()
	self.Button:Destroy()
end

function scriptwindow:Open()
	self.Inst.IsOpen = true
	tween(self.Frame,{Size=self.Inst.Size,Visible=true},0.5):Play()
end

function scriptwindow:Close()
	self.Inst.IsOpen = false
	tween(self.Frame,{Size=UDim2.new(),Visible=false},0.5):Play()
end

scriptwindow.destroy,scriptwindow.remove,scriptwindow.Remove = scriptwindow.Destroy,scriptwindow.Destroy,scriptwindow.Destroy

function bbf.new(name: string,windowsize: Vector2)
	assert(typeof(windowsize) == "Vector2","Argument 2 must be a Vector2")
	assert(typeof(name) == "string","Argument 1 must be a string")
	local newui,newbutton = create(presets.ScriptWindow),create(presets.Button)
	newui.Visible = false
	local functions = setmetatable({},scriptwindow)
	local new = baseinstance.new("ScriptWindow",{
		Size = {
			ReadOnly = true,
			Value = UDim2.new(windowsize.X, 0,windowsize.Y, 0)
		},
		IsOpen = {
			Value = false
		},
		Frame = {
			ReadOnly = true,
			Value = newui
		},
		Button = {
			ReadOnly = true,
			Value = newbutton
		}
	},nil,functions)
	newbutton.Text,newbutton.Name,newui.Name = name,name,name
	newui.Parent,newbutton.Parent = screengui,frame.ScrollingFrame.List
	functions.Inst = new
	newbutton.MouseButton1Click:Connect(function()
		open = false
		tweens[open]:Play()
		new:Open()
	end)
	newui.Buttons.Close.MouseButton1Click:Connect(function()
		new:Close()
	end)
	newui.Buttons.Back.MouseButton1Click:Connect(function()
		open = true
		tweens[open]:Play()
		new:Close()
	end)
	return new
end

function bbf.createElement(element,params)
	assert(elements[element],"Invalid Element type")
	assert(typeof(params) == "table","Params must be a table")
	return elements[element](params)
end

function bbf.notify(txt,dur)
	local folder = rs:FindFirstChild("GameMessages")
	if not folder then warn("GameMessages Folder not found, could not notify") return end
	local bindable = folder:FindFirstChild("ClientMessage")
	if not bindable then warn("ClientMessage BindableEvent not found, could not notify") return end
	bindable:Fire(tostring(txt),tonumber(dur) or 0)
end

function bbf.warn(txt,dur)
	local folder = rs:FindFirstChild("GameMessages")
	if not folder then warn("GameMessages Folder not found, could not notify") return end
	local bindable = folder:FindFirstChild("ClientToolWarning")
	if not bindable then warn("ClientToolWarning BindableEvent not found, could not notify") return end
	bindable:Fire(tostring(txt),tonumber(dur) or 0)
end

bbf.create,bbf.tween,bbf.Screen = create,tween,screengui

_G.BBF = bbf

if not game:IsLoaded() then game.Loaded:Wait() end
bbf.notify("BBF Beta ver 2 is now running successfully!",3)
return _G.BBF
