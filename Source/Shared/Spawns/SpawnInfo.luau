local SpawnInfo = {};
local Meta = { __index = SpawnInfo };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --



-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function SpawnInfo.New(name: string, location: Vector3, colour: Color3)
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Name = name;
	self.Location = location;
	self.Colour = colour;

	return self;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type SpawnInfo = typeof(SpawnInfo.New(...));
return SpawnInfo;
