local MapInfo = {};
local Meta = { __index = MapInfo };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

local SpawnInfo = require("./Spawns/SpawnInfo");
local CapturePointInfo = require("./CapturePoints/CapturePointInfo");

export type MapSize = (
	| "Small"
	| "Medium"
	| "Large"
);

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

function MapInfo.New(
	id: string,
	displayName: string,
	size: MapSize,
	spawnInfos: { SpawnInfo.SpawnInfo },
	capturePointInfos: { CapturePointInfo.CapturePointInfo },
	imageAssetId: string?
)
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Id = id;
	self.DisplayName = displayName;
	self.SpawnInfos = spawnInfos;
	self.CapturePointInfos = (capturePointInfos or {}) :: { CapturePointInfo.CapturePointInfo };
	self.Size = size;
	self.ImageAssetId = imageAssetId or "rbxassetid://0";

	return self;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type MapInfo = typeof(MapInfo.New(...));
return MapInfo;
