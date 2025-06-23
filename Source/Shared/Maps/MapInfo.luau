local MapInfo = {};
local Meta = { __index = MapInfo };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

local SpawnInfo = require("./Spawns/SpawnInfo");

export type MapSize = (
	| "Small"
	| "Medium"
	| "Large"
);

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function MapInfo.New(id: string, displayName: string, spawnInfos: { SpawnInfo.SpawnInfo }, size: MapSize, imageAssetId: string?)
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Id = id;
	self.DisplayName = displayName;
	self.SpawnInfos = spawnInfos;
	self.NumberOfSpawns = #self.SpawnInfos;
	self.Size = size;
	self.ImageAssetId = imageAssetId or "rbxassetid://0";

	return self;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type MapInfo = typeof(MapInfo.New(...));
return MapInfo;
