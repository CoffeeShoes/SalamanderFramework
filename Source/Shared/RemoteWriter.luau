local RemoteWriter = {};

local RemoteFolder = Instance.new("Folder");
RemoteFolder.Name = "Remotes";
RemoteFolder.Parent = game.ReplicatedStorage;

local IsClient = game:GetService("RunService"):IsClient();

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Types                                   --
-- —————————————————————————————————————————————————————————————————————————— --

export type Event<ServerInput..., ClientInput...> = {
	FireClient: (unknown, client: Player, ServerInput...) -> ();
	FireAllClients: (unknown, ServerInput...) -> ();
	OnClientEvent: {
		Connect: (unknown, (ServerInput...) -> ()) -> (RBXScriptConnection);
		ConnectParallel: (unknown, (ServerInput...) -> ()) -> (RBXScriptConnection);
	};

	FireServer: (unknown, ClientInput...) -> ();
	OnServerEvent: {
		Connect: (unknown, (client: Player, ClientInput...) -> ()) -> (RBXScriptConnection);
		ConnectParallel: (unknown, (client: Player, ClientInput...) -> ()) -> (RBXScriptConnection);
	};
};

export type Function<ServerInput..., ClientResponse..., ClientInput..., ServerResponse...> = {
	InvokeClient: (unknown, client: Player, ServerInput...) -> (ClientResponse...);
	OnClientInvoke: (ServerInput...) -> (ClientResponse...);

	InvokeServer: (unknown, ClientInput...) -> (ServerResponse...);
	OnServerInvoke: (client: Player, ClientInput...) -> (ServerResponse...);
};

type Response<R> = { Type: "Response", Data: R };
type Error<E> = { Type: "Error", Error: E };
export type Result<R, E> = Response<R> | Error<E>;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

local function Get(className: "RemoteEvent" | "RemoteFunction" | "UnreliableRemoteEvent", name: string)
	local existing = script:FindFirstChild(name);
	if existing then return existing; end

	if IsClient then
		return RemoteFolder:WaitForChild(name);
	else
		local Remote = Instance.new(className);
		Remote.Name = name;
		Remote.Parent = RemoteFolder;
		return Remote;
	end
end

function RemoteWriter.GetEvent(name: string)
	return Get("RemoteEvent", name) :: RemoteEvent;
end

function RemoteWriter.GetUnreliableEvent(name: string)
	return Get("UnreliableRemoteEvent", name) :: UnreliableRemoteEvent;
end

function RemoteWriter.GetFunction(name: string)
	return Get("RemoteFunction", name) :: RemoteFunction;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

return RemoteWriter;