local MatchInitialiser = {};

local Teams = game:GetService("Teams");

local TeamGroup = require("./TeamGroup");

local ActiveTeamGroups = {} :: { TeamGroup.TeamGroup };
local MatchInProgress = false;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function MatchInitialiser.GetActiveTeamGroups()
	return ActiveTeamGroups;
end

function MatchInitialiser.AddTeamGroups(teamGroups: { TeamGroup.TeamGroup })
	if MatchInProgress then return; end
	for _, group in teamGroups do
		group.Team.Parent = Teams;
		table.insert(ActiveTeamGroups, group);
	end
end

function MatchInitialiser.DeleteAllTeamGroups()
	for _, group in ActiveTeamGroups do
		group:Destroy();
	end
	table.clear(ActiveTeamGroups);
end

function MatchInitialiser.IsRoundInProgress()
	return MatchInProgress;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

return MatchInitialiser;
