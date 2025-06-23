local MapLoader = {};

local ServerStorage = game:GetService("ServerStorage");
local Terrain = workspace.Terrain;

local TerrainSaveLoad = require("./TerrainSaveLoad");
local MapInfo = require(game.ReplicatedStorage.Source.Maps.MapInfo);
local MatchInitialiser = require("../TeamGroups/MatchInitialiser");
local SpawnLocation = require("./Spawns/SpawnLocation")

local MapStorage = ServerStorage.Assets.Maps;
local ModelStorage = MapStorage.Models;
local TerrainStorage = MapStorage.Terrain;

local ActiveModelFolder: Folder?;
local ActiveSpawnLocations = {} :: { SpawnLocation.SpawnLocation };

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function MapLoader.UnloadCurrentMap()
	local teamGroups = MatchInitialiser.GetActiveTeamGroups();
	for _, group in teamGroups do
		group:RemoveAllSpawnLocations();
	end
	if ActiveModelFolder then ActiveModelFolder:Destroy(); ActiveModelFolder = nil; end
	workspace.Terrain:Clear();

	for _, spawn in ActiveSpawnLocations do
		spawn:Destroy();
	end
	table.clear(ActiveSpawnLocations);
end

function MapLoader.LoadMapFromInfo(info: MapInfo.MapInfo)
	MapLoader.UnloadCurrentMap();
	
	local teamGroups = MatchInitialiser.GetActiveTeamGroups();
	local id = info.Id;
	local terrain = TerrainStorage:FindFirstChild(id);
	local models = ModelStorage:FindFirstChild(id);

	if terrain and terrain:IsA("TerrainRegion") then TerrainSaveLoad.Load(terrain); end
	if models and models:IsA("Folder") then ActiveModelFolder = models; models.Parent = workspace; end

	for i, spawnInfo in info.SpawnInfos do
		local spawnLocation = SpawnLocation.New(spawnInfo);
		table.insert(ActiveSpawnLocations, spawnLocation);

--		This automatically assignes a spawn to each team when a new map
--		is loaded. Just for practicality and quality of life.
		if not teamGroups[i] then continue; end
		teamGroups[i]:AddSpawnLocation(spawnLocation);
	end
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

return MapLoader;
