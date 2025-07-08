local MapRemotes = {};
local RemoteWriter = require(game.ReplicatedStorage.Source.RemoteWriter);
local MapInfo = require(game.ReplicatedStorage.Source.Maps.MapInfo); 

-- —————————————————————————————————————————————————————————————————————————— --
--                              Server -> Client                              --
-- —————————————————————————————————————————————————————————————————————————— --

MapRemotes.MapChanged = RemoteWriter.GetEvent("MapChanged")
:: RemoteWriter.Event<({ NewMapInfo: MapInfo.MapInfo? }), ()>;

-- —————————————————————————————————————————————————————————————————————————— --
--                              Client -> Server                              --
-- —————————————————————————————————————————————————————————————————————————— --

MapRemotes.GetAllMapInfos = RemoteWriter.GetFunction("GetAllMapInfos")
:: RemoteWriter.Function<(), (), (), (RemoteWriter.Result<{ MapInfo.MapInfo }, string>)>;

MapRemotes.GetCurrentMapInfo = RemoteWriter.GetFunction("GetCurrentMapInfo")
:: RemoteWriter.Function<(), (), (), (RemoteWriter.Result<MapInfo.MapInfo, string>)>;

MapRemotes.ChangeMap = RemoteWriter.GetFunction("ChangeMap")
:: RemoteWriter.Function<(), (), ({ MapId: string }), (RemoteWriter.Result<MapInfo.MapInfo, string>)>;

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

return MapRemotes;
