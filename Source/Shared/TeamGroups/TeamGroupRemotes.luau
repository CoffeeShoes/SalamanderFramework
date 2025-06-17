local TeamGroupRemotes = {};
local RemoteWriter = require(game.ReplicatedStorage.Source.RemoteWriter);

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Types                                   --
-- —————————————————————————————————————————————————————————————————————————— --

export type TeamGroupInfo = {
	Id: string;
	Name: string;
	TeamColour: BrickColor;
	Colour: Color3;
};

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Remotes                                  --
-- —————————————————————————————————————————————————————————————————————————— --

-- GetTeamGroupInfo • To retrieve TeamGroupInfo
-- GetBulkTeamGroupInfos • To retrieve a selection of them. idk if needed ...
-- GetAllTeamGroupInfos • To retrieve all the current TeamGroupInfos in use

TeamGroupRemotes.GetTeamGroupInfo = RemoteWriter.GetFunction("GetTeamGroupInfo")
:: RemoteWriter.Function<(), (), ({ TeamGroupId: string }), ({ TeamGroupInfo: TeamGroupInfo })>;

TeamGroupRemotes.GetTeamGroupInfos = RemoteWriter.GetFunction("GetAllTeamGroupInfos")
:: RemoteWriter.Function<(), (), (), ({ AllTeamGroupInfos: { TeamGroupInfo } })>

TeamGroupRemotes.ChangeTeamGroup = RemoteWriter.GetEvent("ChangeTeamGroup")
:: RemoteWriter.Event<(), ({ TeamGroupId: string })>;

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

return TeamGroupRemotes;
