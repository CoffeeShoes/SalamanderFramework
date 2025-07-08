local GameRemotes = {};

local RemoteWriter = require(game.ReplicatedStorage.Source.RemoteWriter);

local CaptureMatchInfo = require("./Matches/CaptureMatchInfo");
local ConquestMatchInfo = require("./Matches/ConquestMatchInfo");
local FrontlinesMatchInfo = require("./Matches/FrontlinesMatchInfo");
local HardpointMatchInfo = require("./Matches/HardpointMatchInfo");
local KillsMatchInfo = require("./Matches/KillsMatchInfo");

local CaptureMatchStats = require("./Stats/CaptureMatchStats");
local ConquestMatchStats = require("./Stats/ConquestMatchStats");
local FrontlinesMatchStats = require("./Stats/FrontlinesMatchStats");
local HardpointMatchStats = require("./Stats/HardpointMatchStats");
local KillsMatchStats = require("./Stats/KillsMatchStats");

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Types                                   --
-- —————————————————————————————————————————————————————————————————————————— --

export type MatchInfo = (
	| CaptureMatchInfo.CaptureMatchInfo
	| ConquestMatchInfo.ConquestMatchInfo
	| FrontlinesMatchInfo.FrontlinesMatchInfo
	| HardpointMatchInfo.HardpointMatchInfo
	| KillsMatchInfo.KillsMatchInfo
);

export type MatchStats = (
	| CaptureMatchStats.CaptureMatchStats
	| ConquestMatchStats.ConquestMatchStats
	| FrontlinesMatchStats.FrontlinesMatchStats
	| HardpointMatchStats.HardpointMatchStats
	| KillsMatchStats.KillsMatchStats
)

export type GameStatus = { IsMatchInProgress: boolean, MatchStats: MatchStats?, MatchInfo: MatchInfo?  };

-- —————————————————————————————————————————————————————————————————————————— --
--                              Server -> Client                              --
-- —————————————————————————————————————————————————————————————————————————— --

--[=[
Server signal that fires when the current GameStatus has changed. The first
parameter is the new GameStatus.
]=]--
GameRemotes.GameStatusChanged = RemoteWriter.GetEvent("GameStatusChanged")
:: RemoteWriter.Event<(GameStatus), ()>

-- —————————————————————————————————————————————————————————————————————————— --
--                              Client -> Server                              --
-- —————————————————————————————————————————————————————————————————————————— --

--[=[
Client request by the admin to change the current GameStatus.
Returns a Result where the response is a confirmation copy / fixed version of
the GameStatus sent by the client.
]=]--
GameRemotes.ChangeMatchInfo = RemoteWriter.GetFunction("ChangeMatchInfo")
:: RemoteWriter.Function<(), (), ({ NewMatchInfo: MatchInfo }), (RemoteWriter.Result<GameStatus, string>)>;

GameRemotes.StartMatch = RemoteWriter.GetFunction("StartMatch");
GameRemotes.StopMatch = RemoteWriter.GetFunction("StopMatch");

--[=[
Client request to get the current GameStatus. Returns a Result where the
response is the current GameStatus.
]=]--
GameRemotes.GetGameStatus = RemoteWriter.GetFunction("GetGameStatus")
:: RemoteWriter.Function<(), (), (), (RemoteWriter.Result<GameStatus, string>)>;

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

return GameRemotes;
