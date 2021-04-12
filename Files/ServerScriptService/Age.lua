local Rep = game:GetService("ReplicatedStorage")
local getRequest = Rep:WaitForChild("Requires").getAge

getRequest.OnServerInvoke = function(plrwhosent, text)
	local RawData = game:GetService("HttpService"):GetAsync("https://users.rprxy.xyz/v1/users/"..tonumber(text))
	local Decoded = game:GetService("HttpService"):JSONDecode(RawData)
	local DataTable = Decoded.created
	local createdDate = DateTime.fromIsoDate(DataTable):ToUniversalTime()
	return {createdDate.Month, createdDate.Day, createdDate.Year}
end