local TeamGroupRemotes = {};
local RemoteWriter = require(game.ReplicatedStorage.Source.RemoteWriter);

local SpawnInfo = require(game.ReplicatedStorage.Source.Maps.Spawns.SpawnInfo);

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Types                                   --
-- —————————————————————————————————————————————————————————————————————————— --

export type TeamGroupInfo = {
	Id: string;
	Name: string;
	TeamColour: BrickColor;
	GroupId: number?;
	SpawnInfos: { SpawnInfo.SpawnInfo };
};

-- —————————————————————————————————————————————————————————————————————————— --
--                              Server -> Client                              --
-- —————————————————————————————————————————————————————————————————————————— --

TeamGroupRemotes.ForceRefresh = RemoteWriter.GetEvent("ForceTeamGroupRefresh")
:: RemoteWriter.Event<(), ()>;

-- —————————————————————————————————————————————————————————————————————————— --
--                              Client -> Server                              --
-- —————————————————————————————————————————————————————————————————————————— --

-- GetTeamGroupInfo • To retrieve TeamGroupInfo
-- GetBulkTeamGroupInfos • To retrieve a selection of them. idk if needed ...
-- GetAllTeamGroupInfos • To retrieve all the current TeamGroupInfos in use

TeamGroupRemotes.GetTeamGroupInfo = RemoteWriter.GetFunction("GetTeamGroupInfo")
:: RemoteWriter.Function<(), (), ({ TeamGroupId: string }), ({ TeamGroupInfo: TeamGroupInfo })>;

TeamGroupRemotes.GetAllTeamGroupInfos = RemoteWriter.GetFunction("GetAllTeamGroupInfos")
:: RemoteWriter.Function<(), (), (), ({ AllTeamGroupInfos: { TeamGroupInfo } })>

TeamGroupRemotes.ChangeTeamGroup = RemoteWriter.GetEvent("ChangeTeamGroup")
:: RemoteWriter.Event<(), ({ TeamGroupId: string })>;

-- Admin

TeamGroupRemotes.CreateTeamGroup = RemoteWriter.GetFunction("CreateTeamGroup")
:: RemoteWriter.Function<(), (), (), ({ TeamGroupInfo: TeamGroupInfo })>;

TeamGroupRemotes.UpdateTeamGroup = RemoteWriter.GetEvent("UpdateTeamGroup")
:: RemoteWriter.Event<(), ({ TeamGroupId: string, NewTeamGroupInfo: TeamGroupInfo })>;

TeamGroupRemotes.MatchInProgress = RemoteWriter.GetFunction("MatchInProgress")
:: RemoteWriter.Function<(), (), (), (boolean)>;

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

return TeamGroupRemotes;
