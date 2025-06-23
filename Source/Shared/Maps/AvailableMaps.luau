local MapInfo = require("./MapInfo")
local SpawnInfo = require("./Spawns/SpawnInfo");

local MountainRaid: MapInfo.MapInfo; do
	local northSpawn = SpawnInfo.New("North", Vector3.new(), Color3.new(.5, .5, .5));
	local southSpawn = SpawnInfo.New("South", Vector3.new(), Color3.new(.5, .5, .5));
	local imageAssetId = "rbxassetid://0";
	MountainRaid = MapInfo.New("MountainRaid", "Mountain Raid", { northSpawn, southSpawn }, "Medium", imageAssetId);
end

local AvailableMaps = {
	MountainRaid;
};

return AvailableMaps;
