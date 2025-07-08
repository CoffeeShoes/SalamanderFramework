local AdminUI = {};

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local ColourPickerWindow = require("./ColourPickerWindow");
local MapWindow = require("./MapWindow");
local SpawnPickerScreen = require("./SpawnPickerScreen");
local TeamLeaderAssignmentWindow = require("./TeamLeaderAssignmentWindow");
local TeamsWindow = require("./TeamsWindow");

local Client = Players.LocalPlayer;
local SharedAssets = ReplicatedStorage.Assets;
local UIAssets = SharedAssets.UI.Admin;
local Gui = UIAssets.AdminGui;
local MenuSelectionWindow = Gui.MenuSelectionWindow;

local Enabled = false;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function AdminUI.Enable()
	if Enabled then return; end
	Enabled = true;

	MenuSelectionWindow.Visible = true;
end

function AdminUI.Disable()
	if not Enabled then return; end
	Enabled = false;
	
	MapWindow.Disable();
	TeamsWindow.Disable();
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

for _, frame in Gui:GetChildren() do
	if not frame:IsA("Frame") then continue; end
	frame.Visible = frame == Gui.TeamsWindow;
end

Gui.ResetOnSpawn = false;
Gui.Enabled = true;
Gui.Parent = Client.PlayerGui;

return AdminUI;
