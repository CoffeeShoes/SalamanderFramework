# Maps

## Create a New Map

### Step 1 • Create the Map

Make your terrain and place all your models as you desire. When everything is in place — or preferably as you're working on the map — place all the models that are part of the map inside a folder in Workspace. Anything models not inside this folder will not be saved/loaded with the map. Come up with a display name for your map, and a unique ID. This could for example be:

ID: MountainRaid
Display name: Mountain Raid

The ID is very important later on for the system to recognise and use the correct models and terrain.

### Step 2 • Save the Map

To save the terrain, start by copying this script and change the map ID variable at the top to your chosen map ID, before running it in the console in studio.

```luau
local MAP_ID = "YOUR_MAP_ID_HERE";

local TerrainSaveLoad = require(game.ReplicatedStorage.Source.Server.TerrainSaveLoad);
local TerrainRegion = TerrainSaveLoad.Save();
TerrainRegion.Name = `Save as '{MAP_ID}' to 'Assets\Server\Maps\Terrain'.`;
TerrainRegion.Parent = game.ServerStorage;
print("Map saved to 'game.ServerStorage'.")
```

From here on out, you *have* to make changes directly in the GitHub repository — not in studio. If you navigate to ServerStorage in studio, you should see a new TerrainRegion named after your maps ID. Save this to ``Assets\Server\Maps\Terrain`` in the repository — also naming it the same as your map ID. In a similar fasion, save the folder with all the map's models to ``Assets\Server\Maps\Models``, also naming it after the maps ID.

### Step 3 • Create the MapInfo

Navigate to ``Source\Shared\Maps``, and open the script called ``AvailableMaps.luau``. In here, you need to create a MapInfo to be used by both the server and the client, for example in the admin gui to display map info when selecting maps.
