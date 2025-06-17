local QuickAccessController = {};

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Client = Players.LocalPlayer;
local SharedAssets = ReplicatedStorage.Assets;
local Gui = SharedAssets.UI.QuickAccess.QuickAccessGui;
local Elements = Gui.Elements;
local AccessWindow = Elements.AccessWindow;
local AccessButtons = AccessWindow.AccessButtons;

local QuickAccessEnabled = false;

-- —————————————————————————————————————————————————————————————————————————— --
--                                Private Setup                               --
-- —————————————————————————————————————————————————————————————————————————— --

--* TeamSelection

--* ClassSelection

--* UniformSelection (Missing Gui)

--* Config (Missing Gui)

--* Admin

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

-- am i really gonna need anything here?

-- —————————————————————————————————————————————————————————————————————————— --
--                               Initialise Gui                               --
-- —————————————————————————————————————————————————————————————————————————— --

Gui.ResetOnSpawn = false;
Gui.Parent = Client.PlayerGui;

return QuickAccessController;
