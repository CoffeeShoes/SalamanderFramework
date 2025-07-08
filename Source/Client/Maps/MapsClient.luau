local MapsClient = {};

local GameClient = require("../Game/GameClient");
local MapRemotes = require(game.ReplicatedStorage.Source.Maps.MapRemotes);
local MapInfo = require(game.ReplicatedStorage.Source.Maps.MapInfo);
local CapturePointInfo = require(game.ReplicatedStorage.Source.Maps.CapturePoints.CapturePointInfo);
local SpawnInfo = require(game.ReplicatedStorage.Source.Maps.Spawns.SpawnInfo);
local Signal = require(game.ReplicatedStorage.Source.Signal);

local CurrentMapInfo: MapInfo.MapInfo?;
local CurrentMapId: string?;
local AllMapInfos: { MapInfo.MapInfo }?;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function MapsClient.ChangeMap(mapId: string)
	if mapId == CurrentMapId then return; end
	if GameClient.GetGameStatus().IsMatchInProgress then return; end

	local success, result = pcall(function()
		return MapRemotes.ChangeMap:InvokeServer({ MapId = mapId });
	end);
	
	if not success then
		warn("Could not change map:", result);
		return;
	end
	if result.Type == "Error" then
		warn("Could not change map:", result.Error)
	end

	return result.Data;
end

function MapsClient.GetCurrentMapInfo(): MapInfo.MapInfo?
	if CurrentMapInfo then return CurrentMapInfo; end

	if CurrentMapId and AllMapInfos then
		for _, info in AllMapInfos do
			if info.Id ~= CurrentMapId then continue; end
			return info;
		end
	end

	local success, result = pcall(function()
		return MapRemotes.GetCurrentMapInfo:InvokeServer();
	end);
	
	if not success then
		warn("Could not get current MapInfo:", result);
		return;
	end
	if result.Type == "Error" then
		warn("Could not get current MapInfo:", result.Error)
	end

	CurrentMapInfo = result.Data;
	CurrentMapId = result.Data.Id;
	return result.Data;
end

function MapsClient.GetAllMapInfos(): { MapInfo.MapInfo }?
	if AllMapInfos then return AllMapInfos; end

	local success, result = pcall(function()
		return MapRemotes.GetAllMapInfos:InvokeServer();
	end);
	
	if not success then
		warn("Could not get all MapInfos:", result);
		return;
	end
	if result.Type == "Error" then
		warn("Could not get all MapInfos:", result.Error)
	end

	AllMapInfos = result.Data;
	return AllMapInfos;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Signals                                  --
-- —————————————————————————————————————————————————————————————————————————— --

MapsClient.MapChanged = Signal.New() :: Signal.TypedSignal<{ NewMapInfo: MapInfo.MapInfo? }>;

-- —————————————————————————————————————————————————————————————————————————— --
--                                 Connections                                --
-- —————————————————————————————————————————————————————————————————————————— --

MapRemotes.MapChanged.OnClientEvent:Connect(function(request)
	MapsClient.MapChanged:Fire(request);
end);

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

return MapsClient;
