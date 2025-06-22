local AdminUI = {};

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Client = Players.LocalPlayer;
local SharedAssets = ReplicatedStorage.Assets;
local UIAssets = SharedAssets.UI.Admin;
local Gui = UIAssets.AdminGui;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function AdminUI.Enable()
	
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

for _, frame in Gui:GetChildren() do
	if not frame:IsA("Frame") then continue; end
	frame.Visible = frame == Gui.TeamsWindow;
end

Gui.TeamsWindow.AnchorPoint = Vector2.new(0, .5);

Gui.ResetOnSpawn = false;
Gui.Enabled = true;
Gui.Parent = Client.PlayerGui;

return AdminUI;
