--[[
by ceat_ceat (userid: 145632006)

Joint - same as motor6ds
	<BasePart> Part0
	<BasePart> Part1
	<BasePart> C0
	<BasePart> C1
	<BasePart> Transform

<Joint> constructor.new()
	creates a blank joint
	
<Joint> constructor.new(Motor6D)
	creates a joint that copies the motor6d
	and then removes the motor6d
	
]]

local runservice = game:GetService("RunService")

if _G.BFAnimv2 then
	return _G.BFAnimv2
end

local constructor = {}
local joint = {}

function getnameforattachment(self)
	return tostring(self._.Properties.Part0) .. " 🡪 " .. tostring(self._.Properties.Part1)
end

function updatejoint(self)
	if self._.Instances.Attachment0 and self._.Instances.Attachment1 then
		if not self._.Instances.AlignP then
			local new = Instance.new("AlignPosition", self._.Instances.Attachment0)
			new.Attachment0 = self._.Instances.Attachment1 -- alignpositions and alignorientation apply forces on attachment0s parent
			new.Attachment1 = self._.Instances.Attachment0 -- and i wanna move part1 to part0 not the other way around so its like this
			new.MaxForce = 10000
			new.Responsiveness = 200
			
			self._.Instances.AlignP = new
		end
		
		if not self._.Instances.AlignO then
			local new = Instance.new("AlignOrientation", self._.Instances.Attachment0)
			new.Attachment0 = self._.Instances.Attachment1
			new.Attachment1 = self._.Instances.Attachment0
			new.MaxTorque = 10000
			new.Responsiveness = 200
			
			self._.Instances.AlignO = new
		end
	else
		if self._.Instances.AlignP then
			self._.Instances.AlignP:Destroy()
			self._.Instances.AlignP = nil
		end
		
		if self._.Instances.AlignO then
			self._.Instances.AlignO:Destroy()
			self._.Instances.AlignO = nil
		end
	end
	
	if self._.Instances.Attachment0 then
		self._.Instances.Attachment0.Name = getnameforattachment(self)
	end
	
	if self._.Instances.Attachment1 then
		self._.Instances.Attachment1.Name = getnameforattachment(self)
	end
end

local propertychanged = {
	Joint = {
		Part0 = function(self, val)
			assert(val == nil or (typeof(val) == "Instance" and val:IsA("BasePart")), "expected BasePart, got " .. (typeof(val) == "Instance" and val.ClassName or typeof(val)))

			if val then
				if not self._.Instances.Attachment0 then
					local attachment = Instance.new("Attachment", val)
					attachment.CFrame = self._.Properties.C0 * self._.Properties.Transform

					self._.Instances.Attachment0 = attachment
				end
			else
				if self._.Instances.Attachment0 then
					self._.Instances.Attachment0:Destroy()
					self._.Instances.Attachment0 = nil
				end
			end
			
			updatejoint(self)
		end,
		Part1 = function(self, val)
			assert(val == nil or (typeof(val) == "Instance" and val:IsA("BasePart")), "expected BasePart, got " .. (typeof(val) == "Instance" and val.ClassName or typeof(val)))

			if val then
				if not self._.Instances.Attachment1 then
					local attachment = Instance.new("Attachment", val)
					attachment.CFrame = self._.Properties.C1

					self._.Instances.Attachment1 = attachment
				end
			else
				if self._.Instances.Attachment1 then
					self._.Instances.Attachment1:Destroy()
					self._.Instances.Attachment1 = nil
				end
			end
			
			updatejoint(self)
		end,
		C0 = function(self, val)
			assert(typeof(val) == "CFrame", "expected CFrame, got " .. typeof(val))

			if self._.Instances.Attachment0 then
				self._.Instances.Attachment0.CFrame = val * self._.Properties.Transform
			end
		end,
		C1 = function(self, val)
			assert(typeof(val) == "CFrame", "expected CFrame, got " .. typeof(val))

			if self._.Instances.Attachment1 then
				self._.Instances.Attachment1.CFrame = val
			end
		end,
		Transform = function(self, val)
			assert(typeof(val) == "CFrame", "expected CFrame, got " .. typeof(val))

			if self._.Instances.Attachment0 then
				self._.Instances.Attachment0.CFrame = self._.Properties.C0 * val
			end
		end,
	}
}

joint.__index = function(self, idx)
	return self._.Properties[idx]
end

joint.__newindex = function(self, idx, val)
	assert(propertychanged[self.Type][idx], idx .. " is not a valid member of " .. self.Type)
	
	if self._.Properties[idx] == val then
		return
	end
	
	propertychanged[self.Type][idx](self, val)
	self._.Properties[idx] = val
end

function constructor.new(jointtoreplace: Motor6D?): Motor6D
	local new = setmetatable({
		Type = "Joint",
		_ = {
			Instances = {
				Attachment0 = nil,
				Attachment1 = nil,
				AlignP = nil,
				AlignO = nil,
			},
			Properties = {
				Part0 = nil,
				Part1 = nil,
				C0 = CFrame.new(),
				C1 = CFrame.new(),
				Transform = CFrame.new()
			}
		}
	}, joint)
	
	if typeof(jointtoreplace) == "Instance" and jointtoreplace:IsA("Motor6D") then
		new.Part0 = jointtoreplace.Part0
		new.Part1 = jointtoreplace.Part1
		new.C0 = jointtoreplace.C0
		new.C1 = jointtoreplace.C1
		new.Transform = jointtoreplace.Transform
		
		jointtoreplace:Destroy()
	end
	
	return new
end

_G.BFAnimv2 = constructor
return constructor
