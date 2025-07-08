local RemoteWriter = {};

local RemoteFolder = Instance.new("Folder");
RemoteFolder.Name = "Bindables";
RemoteFolder.Parent = game:GetService("ReplicatedStorage");

local IsClient = game:GetService("RunService"):IsClient();

-- —————————————————————————————————————————————————————————————————————————— --
--                                    Types                                   --
-- —————————————————————————————————————————————————————————————————————————— --

export type Event<Input...> = {
	Fire: (unknown, Input...) -> ();
	Event: {
		Connect: (unknown, (Input...) -> ()) -> (RBXScriptConnection);
		ConnectParallel: (unknown, (Input...) -> ()) -> (RBXScriptConnection);
	};
};

export type Function<Input..., Output...> = {
	Invoke: (unknown, Input...) -> (Output...);
	OnInvoke: (Input...) -> (Output...);
};

type Response<R> = { Type: "Response", Data: R };
type Error<E> = { Type: "Error", Error: E };
export type Result<R, E> = Response<R> | Error<E>;

-- —————————————————————————————————————————————————————————————————————————— --
--                                   Methods                                  --
-- —————————————————————————————————————————————————————————————————————————— --

local function Get(className: "Event" | "Function", name: string)
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
	return Get("Event", name) :: BindableEvent;
end

function RemoteWriter.GetFunction(name: string)
	return Get("Function", name) :: BindableFunction;
end

-- —————————————————————————————————————————————————————————————————————————— --
--                                     ...                                    --
-- —————————————————————————————————————————————————————————————————————————— --

return RemoteWriter;