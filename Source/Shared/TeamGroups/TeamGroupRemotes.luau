local TeamGroupRemotes = {};
local RemoteWriter = require(game.ReplicatedStorage.Source.RemoteWriter);

local SpawnInfo = require(game.ReplicatedStorage.Source.Maps.Spawns.SpawnInfo);
local TeamGroupInfo = require("./TeamGroupInfo");

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Types                                   --
-- —————————————————————————————————————————————————————————————————————————— --

export type TeamGroupInfo = TeamGroupInfo.TeamGroupInfo;

-- —————————————————————————————————————————————————————————————————————————— --
--                              Server -> Client                              --
-- —————————————————————————————————————————————————————————————————————————— --

TeamGroupRemotes.TeamGroupsChanged = RemoteWriter.GetEvent("TeamGroupsChanged")
:: RemoteWriter.Event<({ NewTeamGroups: { TeamGroupInfo } }), ()>;

-- —————————————————————————————————————————————————————————————————————————— --
--                              Client -> Server                              --
-- —————————————————————————————————————————————————————————————————————————— --

-- GetTeamGroupInfo • To retrieve TeamGroupInfo
-- GetBulkTeamGroupInfos • To retrieve a selection of them. idk if needed ...
-- GetAllTeamGroupInfos • To retrieve all the current TeamGroupInfos in use

TeamGroupRemotes.GetTeamGroupInfo = RemoteWriter.GetFunction("GetTeamGroupInfo")
:: RemoteWriter.Function<(), (), ({ TeamGroupId: string }), (RemoteWriter.Result<TeamGroupInfo, string>)>;

TeamGroupRemotes.GetAllTeamGroupInfos = RemoteWriter.GetFunction("GetAllTeamGroupInfos")
:: RemoteWriter.Function<(), (), (), (RemoteWriter.Result<{ TeamGroupInfo }, string>)>;

TeamGroupRemotes.ChangeTeamGroup = RemoteWriter.GetEvent("ChangeTeamGroup")
:: RemoteWriter.Event<(), ({ TeamGroupId: string })>;

-- Admin

--[=[
Creates a new TeamGroup, and returns the TeamGroupInfo in the ResponseResult object.
]=]--
TeamGroupRemotes.CreateTeamGroup = RemoteWriter.GetFunction("CreateTeamGroup")
:: RemoteWriter.Function<(), (), (), (RemoteWriter.Result<TeamGroupInfo, string>)>;

--[=[
@param TeamGroupId string The team group of the 
]=]--
TeamGroupRemotes.UpdateTeamGroup = RemoteWriter.GetEvent("UpdateTeamGroup")
:: RemoteWriter.Event<(), ({ TeamGroupId: string, NewTeamGroupInfo: TeamGroupInfo })>;

TeamGroupRemotes.IsMatchInProgress = RemoteWriter.GetFunction("IsMatchInProgress")
:: RemoteWriter.Function<(), (), (), (RemoteWriter.Result<boolean, string>)>;

--[=[
Updates the list of TeamLeaders in a TeamGroup.
@param TeamGroupId string • The ID of the TeamGroup in question.
@param TeamLeaders { Player } • An array of all players who should be TeamLeaders. Must be part of the TeamGroup.
@return TeamGroupInfo A result which, if the request was successful, contains an array with an updated TeamInfo.
]=]--
TeamGroupRemotes.UpdateTeamLeaders = RemoteWriter.GetFunction("AssignTeamLeader")
:: RemoteWriter.Function<(), (), ({ TeamGroupId: string, TeamLeaders: { Player } }), (RemoteWriter.Result<TeamGroupInfo, string>)>;

TeamGroupRemotes.UpdateTeamLeaders:InvokeServer()

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

return TeamGroupRemotes;
