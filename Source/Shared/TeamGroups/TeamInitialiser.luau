local RoundInitialiser = {};

local Teams = game:GetService("Teams");

local TeamGroup = require("./TeamGroup");

local ActiveTeamGroups = {} :: { TeamGroup.TeamGroup };
local RoundInProgress = false;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function RoundInitialiser.GetActiveTeamGroups()
	return ActiveTeamGroups;
end

function RoundInitialiser.AddTeamGroups(teamGroups: { TeamGroup.TeamGroup })
	if RoundInProgress then return; end
	for _, group in teamGroups do
		group.Team.Parent = Teams;
		table.insert(ActiveTeamGroups, group);
	end
end

function RoundInitialiser.DeleteTeamGroups()
	for _, group in ActiveTeamGroups do
		group:Destroy();
	end
	table.clear(ActiveTeamGroups);
end

function RoundInitialiser.IsRoundInProgress()
	return RoundInProgress;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

return RoundInitialiser;
