local PlayerUI = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local Wrapper = PlayerUI:WaitForChild("UI").Wrapper
local Searchbar = Wrapper.Presser.Searchbar
local Results = Wrapper.Results
local Template = Results.TemplateFrame
local Input = script.Parent

--//

local Loading = Wrapper.Progress
local Limit = Wrapper.Presser.Limit.Input
local Rows = Wrapper.Presser.Rows.Input

--//

local Rep = game:GetService("ReplicatedStorage")
local sendReq = Rep:WaitForChild("Requires").getUsers
local sendReq_ = Rep:WaitForChild("Requires").getStatus
local sendReq__ = Rep:WaitForChild("Requires").getAge

--//

local cache = {}

--//

Input.FocusLost:Connect(function(enterpressed)
	local broke
	local current_task
	local text = Input.Text:lower()
	if not string.find(text, " ") and string.len(text) >= 3 and enterpressed then
		if string.find(Rows.Text, " ") or Rows.Text == "" then Rows.Text = 57 end
		if string.find(Limit.Text, " ") or Limit.Text == "" then Limit.Text = 50 end
		Loading.Visible = true
		local current_time = tick()
		local toget = tick()
		local SendRows = Rows.Text
		local tbl = sendReq:InvokeServer(text, SendRows)
		local toTake = tick() - toget
		toTake *= 10
		toTake = math.floor(toTake)
		toTake = toTake / 10
		if not broke then
			game.StarterGui:SetCore(
				"SendNotification",
				{
					Title = "Fetched Data";
					Text = "Time taken: "..tostring(toTake).."s";
					Icon = "";
					Duration = 4;
				}
			)
		end	
		current_task = text
		for i, v in pairs(Results:GetChildren()) do if v.Name == "VIS" then v:Destroy() end end
		local success, err = pcall(function()
			for i, user in ipairs(tbl) do
				local doing = current_task
				if doing ~= text then broke = true break end
				if current_time - tick() >= tonumber(Limit.Text) then broke = true break end
				local newFrame = Template:Clone()
				--
				newFrame.Parent = Results
				newFrame.Name = "VIS"
				--
				newFrame.RealuserName.Text = user.Name
				newFrame.UniqueID.Text = "User ID: "..user.UserId
				local tot = sendReq__:InvokeServer(user.UserId)
				newFrame.AgeNum.Text = tot[1].."/"..tot[2].."/"..tot[3]
				if user.PreviousUserNamesCsv ~= "" then
					local past_ = user.PreviousUserNamesCsv
					local SplitString = past_:split(', ')
					newFrame.PastUsers.Text = SplitString[1]
				else
					newFrame.PastUsers.Text = ""
				end	
				if user.Blurb ~= "" and user.Blurb ~= " " then
					newFrame.BlurbSpot.Text = "\""..user.Blurb.."\""
				else
					newFrame.BlurbSpot.Text = "This user has no description."
				end
				local Olz = sendReq_:InvokeServer(user.UserId)
				if doing ~= text then broke = true break end
				if Olz.IsOnline == true then
					if Olz.PresenceType == 1 then
						-- online
						newFrame.Shot.isOnline.ImageColor3 = Color3.fromRGB(20, 163, 255)
						newFrame.LayoutOrder = -1
						newFrame.LastSeen.Visible = false
					elseif Olz.PresenceType == 2 then
						-- playing
						newFrame.Shot.isOnline.ImageColor3 = Color3.fromRGB(39, 242, 13)
						newFrame.LayoutOrder = -5
						newFrame.LastSeen.Visible = false
					elseif Olz.PresenceType == 3 then
						-- studio
						newFrame.Shot.isOnline.ImageColor3 = Color3.fromRGB(233, 133, 43)
						newFrame.LayoutOrder = -3
						newFrame.LastSeen.Visible = false
					end
				else
					-- offline
					newFrame.Shot.isOnline.ImageColor3 = Color3.fromRGB(252, 66, 94)
					local DT = Olz.LastOnline
					local lastDate = DateTime.fromIsoDate(DT):ToUniversalTime()
					newFrame.LastSeen.Text = "Last seen: "..lastDate.Month.."/"..lastDate.Day.."/"..lastDate.Year
				end
				newFrame.Shot.Bust.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..user.UserId.."&width=420&height=420&format=png"
				newFrame.Visible = true
			end
		end)
		if not success then warn(err) end
		local timeTaken = tick() - current_time
		timeTaken *= 10
		timeTaken = math.floor(timeTaken)
		timeTaken = timeTaken / 10
		Loading.Visible = false
		if not broke then
			game.StarterGui:SetCore(
				"SendNotification",
				{
					Title = "Task Completed";
					Text = "Task was completed.\nTime taken: "..tostring(timeTaken).."s";
					Icon = "";
					Duration = 4;
				}
			)
		end	
		--local absoluteSize = list.UIGridLayout.AbsoluteContentSize
		--list.CanvasSize = UDim2.new(0, absoluteSize.X, 0, absoluteSize.Y)
		broke = false
	end
end)