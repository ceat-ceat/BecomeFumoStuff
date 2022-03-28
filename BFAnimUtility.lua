-- ceat#6144
-- from: https://github.com/ceat-ceat/BecomeFumoStuff/blob/main/BFAnimUtility.lua
local plrs,run = game:GetService("Players"),game:GetService("RunService")
local localplayer = plrs.LocalPlayer
function create(class,prop)
	local inst = Instance.new(class)
	for i, v in next, prop do
		inst[i] = v
	end
	return inst
end
local cn = CFrame.new

if _G.BFAnim then return _G.BFAnim end

local shp = sethiddenproperty or set_hidden_property or set_hidden_prop or sethiddenprop

local engine = {
	Offsets = {Head=cn(),Torso=cn(),LArm=cn(),RArm=cn(),LLeg=cn(),RLeg=cn()}, -- this offsets table is fallback
	__tostring = function()
		return "\n\nBFAnimEngine\nUse _G.BFAnim:Hook() to hook _G.BFAnim up to the localplayer character\n"
	end,
	__metatable = "The metatable is locked"
}
engine.__index = engine
local config,data,connections = {
	C0 = {
		Head = cn(0, 0.628292561, 0.0139501104, 1, 0, 0, 0, 1, 0, 0, 0, 1),
		LArm = cn(-0.338289261, 0.408066511, -0.03577739, 0.656062782, 0.754706323, 0, -0.754706323, 0.656062782, -0, -0, 0, 1),RArm=cn(0.331710815, 0.408066511, -0.03577739, 0.656062782, -0.754706323, 0, 0.754706323, 0.656062782, 0, 0, 0, 1),
		LLeg = cn(-0.312480927, -0.383209348, 0.0139501104, 1, 0, 0, 0, 1, 0, 0, 0, 1),
		RLeg = cn(0.312480927, -0.383209586, 0.0139501104, 1, 0, 0, 0, 1, 0, 0, 0, 1),
		Torso = cn(0, -0.0499287844, 4.9890019e-05, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	},
	AttachmentOffsets = {
		Torso = cn(0, -0.05, 0),
		LArm = cn(0, 0.3125, 0),
		RArm = cn(0, 0.3125, 0),
		LLeg = cn(0, 0.4085, 0),
		RLeg = cn(0, 0.4085, 0),
		Head = cn(0, -0.7, 0.075)
	}
},{Parts={},BoundToCharacter=false,Container=nil},{}

function bindpart(part0,part1,c0,name)
	assert(data.Container,"Constraint container not found. Use _G.BFAnim:Hook()")
	local name = tostring(name) or part1.Name
	local a0,a1 = create("Attachment",{
		Parent = part1,
		Name = name,
		CFrame = typeof(c0) == "CFrame" and c0:Inverse() or cn()
	}),create("Attachment",{
		Parent = part0,
		Name = name
	})
	local alignp,aligno = create("AlignPosition",{
		Parent = data.Container,
		Name = string.format("AlignP %s",name),
		MaxForce = 10000,
		Responsiveness = 200,
		Attachment0 = a0,
		Attachment1 = a1,
	}),create("AlignOrientation",{
		Parent = data.Container,
		Name = string.format("AlignO %s",name),
		MaxTorque = 10000,
		Responsiveness = 200,
		Attachment0 = a0,
		Attachment1 = a1,
	})
	data.Parts[name].Mover = a1
	_G.BFAnim.Offsets[name] = _G.BFAnim.Offsets[name] or cn()
end

function engine:Hook()
	assert(not data.BoundToCharacter,"Already bound to character")
	data.BoundToCharacter = true
	local chr = localplayer.Character
	assert(chr,"No player character found")
	data.Parts,data.Container = {
		Head = {Part=chr:WaitForChild("Head"):WaitForChild("Head"),AnchorPart=chr:WaitForChild("Torso"):WaitForChild("Torso")},
		Torso = {Part=chr.Torso.Torso,AnchorPart=chr:WaitForChild("HumanoidRootPart")},
		LArm = {Part=chr:WaitForChild("LArm"):WaitForChild("LArm"),AnchorPart=chr.Torso.Torso},
		RArm = {Part=chr:WaitForChild("RArm"):WaitForChild("RArm"),AnchorPart=chr.Torso.Torso},
		LLeg = {Part=chr:WaitForChild("LLeg"):WaitForChild("LLeg"),AnchorPart=chr.Torso.Torso},
		RLeg = {Part=chr:WaitForChild("RLeg"):WaitForChild("RLeg"),AnchorPart=chr.Torso.Torso}
	},create("Hole",{
		Parent = chr,
		Name = "BFAnimConstraints"
	})
	local chrscale = chr.HumanoidRootPart.Size.Z/0.598
	for i, v in next, data.Parts do
		local baseoffset = config.AttachmentOffsets[i]
		bindpart(v.AnchorPart,v.Part,CFrame.new(baseoffset.X*chrscale,baseoffset.Y*chrscale,baseoffset.Z*chrscale):Inverse(),i)
	end
	for i, v in next, chr.Torso.Torso:GetChildren() do
		if v:IsA("Motor6D") then
			v:Destroy()
		end
	end
	chr.HumanoidRootPart.Torso:Destroy()
	connections = {
		run.Stepped:Connect(function()
			if shp then
				shp(localplayer, "SimulationRadius", math.huge)
			end
			for i, v in next, data.Parts do
				local offset = _G.BFAnim.Offsets[i]
				if offset and typeof(offset) == "CFrame" and v.Mover then
					v.Mover.CFrame = _G.BFAnim.Offsets[i] or cn()
				end
			end
		end),
		run.Heartbeat:Connect(function()
			for i, v in next, data.Parts do
				if v.Part.Velocity == Vector3.new() then
					v.Part.Velocity = Vector3.new(0,0,45)	
				end
			end
		end),
	}
	pcall(function()
   		settings().Physics.AllowSleep = false
		settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
	end)
end

function engine:AddPart(name,params)
	assert(data.BoundToCharacter,"Not bound to character. Use _G.BFAnim:Hook()")
	assert(tostring(name),"Argument 1 invalid or nil")
	assert(not data.Parts[tostring(name)],"Name is already in use")
	assert(typeof(params) == "table","Argument 2 invalid or nil")
	assert(typeof(params.Part0) == "Instance" and params.Part0:IsA("BasePart") and typeof(params.Part1) == "Instance" and params.Part1:IsA("BasePart"),"Part0 and Part1 invalid or nil")
	assert(params.Part1 ~= localplayer.Character:FindFirstChild("HumanoidRootPart"),"Not allowed to bind HumanoidRootPart")
	data.Parts[name] = {Part=params.Part1,AnchorPart=params.Part0}
	bindpart(params.Part0,params.Part1,params.C0,name)
	return true
end

localplayer.CharacterAdded:Connect(function()
	for i, v in next, connections do
		v:Disconnect()
	end
	data.BoundToCharacter = false
end)

_G.BFAnim = setmetatable({C0=config.C0,Offsets={Head=cn(),Torso=cn(),LArm=cn(),RArm=cn(),LLeg=cn(),RLeg=cn()}},engine)
return _G.BFAnim
