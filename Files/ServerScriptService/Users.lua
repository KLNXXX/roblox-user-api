local Rep = game:GetService("ReplicatedStorage")
local getRequest = Rep:WaitForChild("Requires").getUsers

getRequest.OnServerInvoke = function(plrwhosent, text, rows)
	local RawData = game:GetService("HttpService"):GetAsync("https://www.rprxy.xyz/search/users/results?keyword="..text.."&maxRows="..rows.."&startIndex=0")
	local Decoded = game:GetService("HttpService"):JSONDecode(RawData)
	local DataTable = Decoded.UserSearchResults
	return DataTable
end