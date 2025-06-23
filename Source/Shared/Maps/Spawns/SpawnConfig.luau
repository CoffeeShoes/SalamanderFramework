local SpawnConfig = {};

local SpawnInfo = require("./SpawnInfo");

SpawnConfig.AvailableSpawns = {
	SpawnInfo.New("North", Vector3.new(), Color3.new());
	SpawnInfo.New("South", Vector3.new(), Color3.new());
};

return SpawnConfig;
