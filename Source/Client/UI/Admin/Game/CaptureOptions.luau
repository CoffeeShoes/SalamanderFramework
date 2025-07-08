local CaptureOptions = {};

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local CaptureMatchInfo = require(game.ReplicatedStorage.Source.Game.Matches.CaptureMatchInfo);
local Colours = require(game.ReplicatedStorage.Source.Colours);
local GameClient = require("../../../Game/GameClient");
local MapsClient = require("../../../Maps/MapsClient");
local NumberDragger = require("./NumberDragger");

local UIAssets = ReplicatedStorage.Assets.UI;
local AdminUIAssets = UIAssets.Admin;
local GameUIAssets = AdminUIAssets.Game;
local Gui = AdminUIAssets.AdminGui;
local GameWindow = Gui.GameWindow;
local Main = GameWindow.ContentHolder.Capture;

local DraggerInputs = { Enum.UserInputType.Touch, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonA };
local ScoreDragger = NumberDragger.New(Main.ScoreGoal.Dragger, Main.ScoreGoal.Dragger, DraggerInputs, "Y", 1000, 100, 1000000, 100, 5, true);
local HourDragger = NumberDragger.New(Main.Time.ClockInput.HourDragger, Main.Time.ClockInput.HourDragger, DraggerInputs, "Y", 0, 0, 10, 1, 30, false, "H");
local MinuteDragger = NumberDragger.New(Main.Time.ClockInput.MinuteDragger, Main.Time.ClockInput.MinuteDragger, DraggerInputs, "Y", 30, 0, 59, 1, 10, true, "M");
local SecondDragger = NumberDragger.New(Main.Time.ClockInput.SecondDragger, Main.Time.ClockInput.SecondDragger, DraggerInputs, "Y", 0, 0, 59, 1, 5, true, "S");

local Enabled = false;
local CurrentMatchInfo: GameClient.MatchInfo?;
local EnabledCapturePointsIds = {};

-- —————————————————————————————————————————————————————————————————————————— --
--                                  Functions                                 --
-- —————————————————————————————————————————————————————————————————————————— --

local function RegenerateEnabledCapturePointToggles()
	table.clear(EnabledCapturePointsIds);
	
	for _, toggle in Main.CapturePoints.Toggles:GetChildren() do
		if toggle.ClassName ~= GameUIAssets.CaptureToggle.ClassName then continue; end
		toggle:Destroy();
	end

	local currentMapInfo = MapsClient.GetCurrentMapInfo();
	if not currentMapInfo then return; end

	for _, cap in currentMapInfo.CapturePointInfos do
		local isEnabled = true;
		local toggle = GameUIAssets.CaptureToggle:Clone();
		toggle.Name = cap.Id;
		toggle.Text = cap.DisplayName;
		toggle.Visible = true;
		toggle.Parent = Main.CapturePoints.Toggles;
		table.insert(EnabledCapturePointsIds, cap.Id);

		toggle.Activated:Connect(function()
			isEnabled = not isEnabled;

			if isEnabled then
				local i = table.find(EnabledCapturePointsIds, cap.Id);
				if not i then table.insert(EnabledCapturePointsIds, cap.Id); end
				toggle.BackgroundColor3 = Colours.Accept;
			else
				local i = table.find(EnabledCapturePointsIds, cap.Id);
				if i then table.remove(EnabledCapturePointsIds, i); end
				toggle.BackgroundColor3 = Colours.Neutral;
			end
		end);
	end
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function CaptureOptions.Start()
	if Enabled then return; end
	Enabled = true;
	Main.Visible = true;

	local info = CaptureMatchInfo.New(
		EnabledCapturePointsIds,
		HourDragger:GetValue() * 3600 + MinuteDragger:GetValue() * 60 + SecondDragger:GetValue(),
		ScoreDragger:GetValue()
	);

	CurrentMatchInfo = info;
end

function CaptureOptions:GetConfiguredMatchInfo()
	return CurrentMatchInfo;
end

function CaptureOptions.Finished(): GameClient.MatchInfo
	if not Enabled then return; end
	Enabled = false;
	Main.Visible = false;

	local info = CurrentMatchInfo;
	CurrentMatchInfo = nil;

	return info;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

RegenerateEnabledCapturePointToggles();
CaptureOptions.Disable();

return CaptureOptions;
