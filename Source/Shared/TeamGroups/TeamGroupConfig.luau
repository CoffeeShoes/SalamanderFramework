local TeamGroupConfig = {};
local Teams = game:GetService("Teams");
local TeamGroup = require("./TeamGroup");

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Config                                   --
-- —————————————————————————————————————————————————————————————————————————— --

TeamGroupConfig.DefaultLineup = {
	TeamGroup.New("Salamanders", BrickColor.new("Bright green"));
	TeamGroup.New("Iguanas", BrickColor.new("Bright blue"));
};

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

return TeamGroupConfig;
