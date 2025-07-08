local GameClient = {};

local GameRemotes = require(game.ReplicatedStorage.Source.Game.GameRemotes);
local Signal = require(game.ReplicatedStorage.Source.Signal);

local CurrentGameStatus: GameRemotes.GameStatus?;

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Types                                   --
-- —————————————————————————————————————————————————————————————————————————— --

export type GameStatus = GameRemotes.GameStatus;
export type MatchInfo = GameRemotes.MatchInfo;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

function GameClient.ChangeMatchInfo(newMatchInfo: MatchInfo): GameStatus
	local currentStatus = GameClient.GetGameStatus();
	if currentStatus.IsMatchInProgress then return; end

	local success, result = xpcall(function()
		return GameRemotes.ChangeGameStatus:InvokeServer({ NewMatchInfo = newMatchInfo });
	end, warn);

	if not success then return currentStatus; end
	if result.Type == "Error" then
		warn(result.Error);
		return currentStatus;
	end

	return result.Data;
end

function GameClient.GetGameStatus(): GameRemotes.GameStatus?
	if not CurrentGameStatus then
		local success, result = xpcall(function()
			return GameRemotes.GetGameStatus:InvokeServer();
		end, warn);
		
		if not success then return nil; end
		if result.Type == "Error" then
			warn(result.Error);
			return nil;
		end

		CurrentGameStatus = result.Data;
	end

	return CurrentGameStatus;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Signals                                  --
-- —————————————————————————————————————————————————————————————————————————— --

GameClient.GameStatusChanged = Signal.New() :: Signal.TypedSignal<GameRemotes.GameStatus>;

-- —————————————————————————————————————————————————————————————————————————— --
--                                 Connections                                --
-- —————————————————————————————————————————————————————————————————————————— --

GameRemotes.GameStatusChanged.OnClientEvent:Connect(function(newStatus)
	CurrentGameStatus = newStatus;
	GameClient.GameStatusChanged:Fire(CurrentGameStatus);
end);

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

return GameClient;
