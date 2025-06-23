local SpawnInfo = {};
local Meta = { __index = SpawnInfo };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --



-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function SpawnInfo.New(id: string, displayName: string, location: Vector3, colour: Color3?, protectionDistanceStuds: number?)
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Id = id;
	self.DisplayName = displayName;
	self.Location = location;
	self.Colour = colour or Color3.new(1, 1, 1);
	self.ProtectionDistance = protectionDistanceStuds or 0;

	return self;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type SpawnInfo = typeof(SpawnInfo.New(...));
return SpawnInfo;
