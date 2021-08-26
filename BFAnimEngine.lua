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
},{Parts={},BoundToCharacter=false},{}

function engine:Hook()
	assert(not data.BoundToCharacter,"Already bound to character")
	data.BoundToCharacter = true
	local chr = localplayer.Character
	assert(chr,"No player character found")
	data.Parts = {
		Head = {Part=chr:WaitForChild("Head"):WaitForChild("Head"),AnchorPart=chr:WaitForChild("Torso"):WaitForChild("Torso")},
		Torso = {Part=chr.Torso.Torso,AnchorPart=chr:WaitForChild("HumanoidRootPart")},
		LArm = {Part=chr:WaitForChild("LArm"):WaitForChild("LArm"),AnchorPart=chr.Torso.Torso},
		RArm = {Part=chr:WaitForChild("RArm"):WaitForChild("RArm"),AnchorPart=chr.Torso.Torso},
		LLeg = {Part=chr:WaitForChild("LLeg"):WaitForChild("LLeg"),AnchorPart=chr.Torso.Torso},
		RLeg = {Part=chr:WaitForChild("RLeg"):WaitForChild("RLeg"),AnchorPart=chr.Torso.Torso}
	}
	local constraintcontainer = create("Hole",{
		Parent = chr,
		Name = "BFAnimConstraints"
	})
	for i, v in next, data.Parts do
		local a0,a1 = create("Attachment",{
			Parent = v.Part,
			Name = i,
			CFrame = config.AttachmentOffsets[i]
		}),create("Attachment",{
			Parent = v.AnchorPart,
			Name = i
		})
		local alignp,aligno = create("AlignPosition",{
			Parent = constraintcontainer,
			Name = string.format("AlignP %s",i),
			MaxForce = 10000,
			Responsiveness = 200,
			Attachment0 = a0,
			Attachment1 = a1,
		}),create("AlignOrientation",{
			Parent = constraintcontainer,
			Name = string.format("AlignO %s",i),
			MaxTorque = 10000,
			Responsiveness = 200,
			Attachment0 = a0,
			Attachment1 = a1,
		})
		v.Mover = a1
	end
	for i, v in next, chr.Torso.Torso:GetChildren() do
		if v:IsA("Motor6D") then
			v:Destroy()
		end
	end
	chr.HumanoidRootPart.Torso:Destroy()
	connections = {
		run.Stepped:Connect(function()
			setsimulationradius(1e308, 1/0)
			for i, v in next, data.Parts do
				local offset = _G.BFAnim.Offsets[i]
				if offset and typeof(offset) == "CFrame" and v.Mover then
					v.Mover.CFrame = _G.BFAnim.Offsets[i]
				end
			end
			setsimulationradius(1e308, 1/0)
		end),
		run.RenderStepped:Connect(function()
			setsimulationradius(1e308, 1/0)
		end),
		run.Heartbeat:Connect(function()
			setsimulationradius(1e308, 1/0)
		end)
	}
end

localplayer.CharacterAdded:Connect(function()
	for i, v in next, connections do
		v:Disconnect()
	end
	data.BoundToCharacter = false
end)

_G.BFAnim = setmetatable({C0=config.C0,Offsets={Head=cn(),Torso=cn(),LArm=cn(),RArm=cn(),LLeg=cn(),RLeg=cn()}},engine)
return _G.BFAnim
