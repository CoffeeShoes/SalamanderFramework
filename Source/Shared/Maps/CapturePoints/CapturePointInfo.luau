local CapturePointInfo = {};
local Meta = { __index = CapturePointInfo };
local Members = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --



-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

--[=[
@param id • The capture point's id.
@param displayName string • The capture point's display name.
@param location Vector3 • The capture point's coordinates.
@param timeToCapture number? • The number of seconds it takes for one person to capture. Default value: '10'.
@param playerBonusMultipler number? • For each player advantage over 1, the progress will increase by this factor. Default value: '1' (no increase from bonus).
@param maxBonus number? • For limiting the bonus. If the player advantage over 1 is more than this, it will be clamped beneath this value. Default value: '10'.
]=]--
function CapturePointInfo.New(
	id: string,
	displayName: string,
	location: Vector3,
	timeToCapture: number?,
	playerBonusMultiplier: number?,
	maxBonus: number?
)
	local self, priv = setmetatable({}, Meta), {};
	Members[self] = priv;

	self.Id = id;
	self.DisplayName = displayName;
	self.Location = location;
	self.TimeToCapture = timeToCapture or 10;
	self.PlayerBonusMultiplier = playerBonusMultiplier or 1;
	self.MaxBonux = maxBonus or 10;

	return self;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type CapturePointInfo = typeof(CapturePointInfo.New(...));
return CapturePointInfo;
