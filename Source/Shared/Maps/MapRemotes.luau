local MapRemotes = {};
local RemoteWriter = require(game.ReplicatedStorage.Source.RemoteWriter);
local MapInfo = require(game.ReplicatedStorage.Source.Maps.MapInfo); 

MapRemotes.GetCurrentMapInfo = RemoteWriter.GetFunction("GetCurrentMapInfo")
:: RemoteWriter.Function<(), (), (), ({ MapInfo: MapInfo.MapInfo })>;

return MapRemotes;
