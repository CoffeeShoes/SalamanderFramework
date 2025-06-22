local TeamSelectionController = {};

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Teams = game:GetService("Teams");

local TeamGroupRemotes = require(ReplicatedStorage.Source.TeamGroups.TeamGroupRemotes);

local Client = Players.LocalPlayer;
local SharedAssets = ReplicatedStorage.Assets;
local TeamSelectionAssets = SharedAssets.UI.TeamSelection;

local TeamButton = TeamSelectionAssets.TeamButton;

local Gui= TeamSelectionAssets.TeamSelectionGui;
	local MainWindow = Gui.MainWindow;

local TeamSelectionEnabled = false;

-- —————————————————————————————————————————————————————————————————————————— --
--                                  Functions                                 --
-- —————————————————————————————————————————————————————————————————————————— --

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function TeamSelectionController.ResetTeamList()
	for _, button in MainWindow:GetChildren() do
		if not button:IsA("GuiButton") then continue; end
		button:Destroy();
	end

	for _, team in Teams:GetTeams() do
		local button = TeamButton:Clone();

		button.Name, button.Text = team.Name, team.Name;
		button.BackgroundColor3 = team.TeamColor.Color;
		button.Visible = true;

		button.Activated:Connect(function()

		end);

		button.Parent = MainWindow.Parent;
	end
end

function TeamSelectionController.Enable()
	if TeamSelectionEnabled then return; end
end

function TeamSelectionController.Disable()
	if not TeamSelectionEnabled then return; end
end

function TeamSelectionController.Toggle()
	if TeamSelectionEnabled then TeamSelectionController.Disable() else TeamSelectionController.Enable(); end
end

-- —————————————————————————————————————————————————————————————————————————— --
--                             Gui Initialisation                             --
-- —————————————————————————————————————————————————————————————————————————— --

Gui.ResetOnSpawn = false;
Gui.Parent = Client.PlayerGui;

return TeamSelectionController;
