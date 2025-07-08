local KillsOptions = {};

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local KillsMatchInfo = require(game.ReplicatedStorage.Source.Game.Matches.KillsMatchInfo);
local GameClient = require("../../../Game/GameClient");
local NumberDragger = require("./NumberDragger");

local UIAssets = ReplicatedStorage.Assets.UI;
local AdminUIAssets = UIAssets.Admin;
local Gui = AdminUIAssets.AdminGui;
local GameWindow = Gui.GameWindow;
local Main = GameWindow.ContentHolder.Kills;

local DraggerInputs = { Enum.UserInputType.Touch, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonA };
local KillDragger = NumberDragger.New(Main.KillGoal.Dragger, Main.KillGoal.Dragger, DraggerInputs, "Y", 100, 10, 10000, 1, 4, true);
local HourDragger = NumberDragger.New(Main.Time.ClockInput.HourDragger, Main.Time.ClockInput.HourDragger, DraggerInputs, "Y", 0, 0, 10, 1, 30, false, "H");
local MinuteDragger = NumberDragger.New(Main.Time.ClockInput.MinuteDragger, Main.Time.ClockInput.MinuteDragger, DraggerInputs, "Y", 30, 0, 59, 1, 10, true, "M");
local SecondDragger = NumberDragger.New(Main.Time.ClockInput.SecondDragger, Main.Time.ClockInput.SecondDragger, DraggerInputs, "Y", 0, 0, 59, 1, 5, true, "S");

local Enabled = false;
local CurrentMatchInfo: GameClient.MatchInfo?;

-- —————————————————————————————————————————————————————————————————————————— --
--                                  Functions                                 --
-- —————————————————————————————————————————————————————————————————————————— --

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function KillsOptions.Start()
	if Enabled then return; end
	Enabled = true;
	Main.Visible = true;

	local info = KillsMatchInfo.New(
		KillDragger:GetValue(),
		HourDragger:GetValue() * 3600 + MinuteDragger:GetValue() * 60 + SecondDragger:GetValue()
	);

	CurrentMatchInfo = info;
end

function KillsOptions:GetConfiguredMatchInfo()
	return CurrentMatchInfo;
end

function KillsOptions.Finish(): GameClient.MatchInfo
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

KillsOptions.Disable();

return KillsOptions;
