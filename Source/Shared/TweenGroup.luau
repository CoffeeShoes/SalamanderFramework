
local TweenGroup = {};
local Members = {
	__index = TweenGroup;
	__mode = "k";
};
setmetatable(Members :: any, Members);

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Class                                   --
-- —————————————————————————————————————————————————————————————————————————— --

local Signal = require(script.Parent.Signal);
local DebuggerUIService = game:GetService("DebuggerUIService")
local TweenService = game:GetService("TweenService");

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Object                                   --
-- —————————————————————————————————————————————————————————————————————————— --

--	Init

function TweenGroup.New()
	local self, priv = setmetatable({}, Members), {};
	Members[self] = priv;

	self.AllCompleted = Signal.New();

	priv.IsInProgress = false;
	priv.Completed = false;
	priv.LongestTime = 0;
	priv.Longest = nil :: Tween?;
	priv.Playing = {};
	priv.Tweens = {} :: { { Instances: { Instance }, TweenInfo: TweenInfo, PropertyTable: { [string]: any } } };

	return self;
end

--	Public

function TweenGroup:AddInstances(instances: { Instance } | Instance, tweenInfo: TweenInfo, propertyTable: { [string]: any })
	local priv = Members[self];

	if typeof(instances) == "Instance" then
		instances = { instances };
	end

	if tweenInfo.Time > priv.LongestTime then
		priv.LongestTime = tweenInfo.Time;
	end

	table.insert(priv.Tweens, {
		Instances = instances;
		TweenInfo = tweenInfo;
		PropertyTable = propertyTable;
	});

	return self;
end

function TweenGroup:Play(): TweenGroup
	local priv = Members[self];

	if priv.IsInProgress then return; end
	priv.IsInProgress = true;

	priv.Playing = {};

	for _, info in priv.Tweens do
		for _, instance in info.Instances do
			local tween = TweenService:Create(instance, info.TweenInfo, info.PropertyTable);
			table.insert(priv.Playing, tween);

			if not priv.Longest and info.TweenInfo.Time >= priv.LongestTime then
				priv.Longest = tween;
				local c: RBXScriptConnection;
				c = tween:GetPropertyChangedSignal("PlaybackState"):Connect(function()
					if tween.PlaybackState == Enum.PlaybackState.Playing then return; end
					self.AllCompleted:Fire();
					priv.Completed = true;
					c:Disconnect();
				end);
			end
		end
	end

	for _, tween in priv.Playing do
		tween:Play();
	end

	return self; --> why don't normal tween have this
end

function TweenGroup:Pause()
	local priv = Members[self];

	for _, tween in priv.Playing do
		tween:Pause();
	end
end

function TweenGroup:Cancel()
	local priv = Members[self];

	if priv.Completed then return; end
	if not priv.IsInProgress then return; end

	for _, tween in priv.Playing do
		tween:Cancel();
	end
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

export type TweenGroup = typeof(TweenGroup.New(...));
return TweenGroup;
