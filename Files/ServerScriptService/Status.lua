local Rep = game:GetService("ReplicatedStorage")
local getRequest = Rep:WaitForChild("Requires").getStatus

getRequest.OnServerInvoke = function(plrwhosent, id)
	local RawData = game:GetService("HttpService"):GetAsync("https://api.rprxy.xyz/users/"..tostring(id).."/onlinestatus/")
	local Decoded = game:GetService("HttpService"):JSONDecode(RawData)
	return Decoded
end