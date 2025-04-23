_G.prisma = {}

if _G.prisma.Loaded == true then
	return
elseif _G.prisma.Loaded == false or _G.prisma.Loaded == nil then
	if not game:IsLoaded() then game.Loaded:Wait() end
end



--- Static ---
prisma = _G.prisma
prisma.commands = {}
prisma.version = "<!#FV> 2.6.15 </#FV>"
prisma.version = string.sub(prisma.version,8,13)
prisma.binds = {}

--- Locals ---
local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()

--- Services ---
local players = game:GetService("Players")
local runservice = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local tweenservice = game:GetService("TweenService")
local logservice = game:GetService("LogService")
local debris = game:GetService("Debris")
local httpService = game:GetService("HttpService")


--- Dynamic ---
local FLYING = false
local QEfly = true
local flyspeed = 1
local vehicleflyspeed = 1


local GUI = nil
function initUi()

local gui = Instance.new("ScreenGui")
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Name = "prisma"
gui.Parent = game.CoreGui
GUI = gui

local input = Instance.new("TextBox")
input.Font = Enum.Font.TitilliumWeb
input.Text = "Prisma | v3.2.1"
input.TextColor3 = Color3.new(0.972549, 0.972549, 0.972549)
input.TextScaled = true
input.TextSize = 27
input.TextWrapped = true
input.AnchorPoint = Vector2.new(0, 1)
input.BackgroundColor3 = Color3.new(0.0666667, 0.0666667, 0.0666667)
input.BackgroundTransparency = 0.699999988079071
input.BorderColor3 = Color3.new(0.972549, 0.972549, 0.972549)
input.BorderSizePixel = 0
input.Position = UDim2.new(0, 0, 1, 0)
input.Size = UDim2.new(0, 200, 0, 25)
input.Visible = true
input.ZIndex = 5
input.Name = "CMDbar"
input.Parent = gui

local uitext_size_constraint = Instance.new("UITextSizeConstraint")
uitext_size_constraint.MaxTextSize = 20
uitext_size_constraint.Parent = input

local contents = Instance.new("CanvasGroup")
contents.GroupTransparency = 1
contents.AnchorPoint = Vector2.new(0.5, 1)
contents.BackgroundColor3 = Color3.new(0.0666667, 0.0666667, 0.0666667)
contents.BackgroundTransparency = 0.699999988079071
contents.BorderColor3 = Color3.new(0, 0, 0)
contents.BorderSizePixel = 0
contents.Position = UDim2.new(0.5, 0, 9, 0)
contents.Size = UDim2.new(1, 0, 0, 200)
contents.Visible = true
contents.Name = "contents"
contents.Parent = input

local template = Instance.new("TextLabel")
template.Font = Enum.Font.TitilliumWeb
template.Text = "Fly"
template.TextColor3 = Color3.new(1, 1, 1)
template.TextSize = 23
template.TextXAlignment = Enum.TextXAlignment.Left
template.Visible = false
template.BackgroundColor3 = Color3.new(1, 1, 1)
template.BackgroundTransparency = 1
template.BorderColor3 = Color3.new(0, 0, 0)
template.BorderSizePixel = 0
template.Size = UDim2.new(1, 0, 0.150000006, 0)
template.Visible = true
template.Parent = contents

local uipadding = Instance.new("UIPadding")
uipadding.PaddingLeft = UDim.new(0, 5)
uipadding.PaddingTop = UDim.new(0, 5)
uipadding.Parent = contents

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 4)
uicorner.Parent = contents

local thin = Instance.new("Frame")
thin.BackgroundColor3 = Color3.new(0.338407, 1, 0)
thin.BackgroundTransparency = 0.25
thin.BorderColor3 = Color3.new(0, 0, 0)
thin.BorderSizePixel = 0
thin.Size = UDim2.new(1, 0, 0.0299999993, 0)
thin.Visible = true
thin.Name = "thin"
thin.Parent = input

local uigrid = Instance.new("UIGridLayout")
uigrid.Parent = contents
uigrid.CellPadding = UDim2.new(0,0,0,0)
uigrid.CellSize = UDim2.new(1, 0, 0.13, 0)
uigrid.FillDirection = Enum.FillDirection.Vertical



local function autoComplete()

	for i,v in pairs(contents:GetChildren()) do
		if v:IsA("TextLabel") then
			v:Destroy()
		end
	end

	local commands = {}

	for i,v in pairs(prisma.commands) do
		if v.Alias ~= nil then
			if string.sub(v.Command, 1, string.len(input.Text)) == input.Text or string.sub(v.Alias, 1, string.len(input.Text)) == input.Text then
				table.insert(commands, v)
			end
		else
			if string.sub(v.Command, 1, string.len(input.Text)) == input.Text then
				table.insert(commands, v)
			end
		end
	end
	for i,v in pairs(prisma.commands) do
		if not table.find(commands, v) then
			table.insert(commands, v)
		end
	end

	for i,v in ipairs(commands) do
		local clone = template:Clone()
		if v.Alias == nil then
			clone.Text = string.upper(string.sub(v.Command, 1, 1))..string.sub(v.Command, 2, string.len(v.Command))
		else
			clone.Text = `{string.upper(string.sub(v.Command, 1, 1))..string.sub(v.Command, 2, string.len(v.Command))} | {string.upper(string.sub(v.Alias, 1, 1))..string.sub(v.Alias, 2, string.len(v.Alias))}`
		end
		clone.Parent = contents
		clone.Visible = true
	end
end

uis.InputBegan:Connect(function(key, chatting)
	if not chatting and key.KeyCode == Enum.KeyCode.RightAlt then
		input:CaptureFocus()
	end
end)
local cmdTween = true
local versionTag = `Prisma | v{prisma.version}`

input.Focused:Connect(function()
	autoComplete()
	cmdTween = false
	tweenservice:Create(contents, TweenInfo.new(.4,Enum.EasingStyle.Exponential), {
		Position = UDim2.new(0.5, 0, 0, 0),
		GroupTransparency = 0
	}):Play()
end)
input.Changed:Connect(function(property)
	if property == "Text" then
		autoComplete()
	end
end)
input.FocusLost:Connect(function(enterPressed)

	if enterPressed then
		prisma:parseInput(input.Text)
	end

	tweenservice:Create(contents, TweenInfo.new(1,Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 9, 0),
		GroupTransparency = 1
	}):Play()
	
	local middle = #versionTag / 2
	cmdTween = true
	for i = 0,middle do
		
		if cmdTween == false then
			cmdTween = true
			input.Text = ""
			break
		end
		
		input.Text = string.sub(versionTag, middle - i,middle + i)
		wait(.08)
	end
end)

runservice.RenderStepped:Connect(function()
	thin.BackgroundColor3 = Color3.fromHSV(tick() % 20/20, 1, 1)
end)

end
initUi()



--- Command handling stuff ---
function prisma:isValidCommand(String,send)
	for _,v in pairs(prisma.commands) do
		if v.Command == String or v.Alias == String then
			if send then
				return v
			else
				return true
			end
		end
	end
end

function prisma:executeCommand(command,arg1,arg2,arg3)
	for i,v in pairs(prisma.commands) do
		if v.Command == command or v.Alias == command then
			v.CallBack(arg1,arg2,arg3)
		end
	end
end

function prisma:parseInput(txt)
	if txt ~= " " and string.len(txt) ~= 0 then
		local text = string.lower(txt)
		if text == "" then return end

		local args = {}

		for Argument in string.gmatch(text,"[^%s]+") do
			table.insert(args,Argument)
		end

		if prisma:isValidCommand(args[1]) then
			local commandT = prisma:isValidCommand(args[1],true)

			if commandT.SendFull then
				local asub = nil

				if args[1] == commandT.Command then
					asub = string.len(commandT.Command) + 2
				elseif args[1] == commandT.Alias then
					asub = string.len(commandT.Alias) + 2
				end

				local fstring = string.sub(text,asub,100)
				coroutine.wrap(function()
					commandT.CallBack(fstring,args[2],args[3])
					coroutine.yield()
				end)()
			else
				coroutine.wrap(function()
					commandT.CallBack(args[2],args[3],args[4])
					coroutine.yield()
				end)()
			end

		end
	end
end

function prisma:addCMD(command,alias,callback,sendfull)
	local fc = callback
	if callback == nil or callback == "" or type(callback) == "string" then
		fc = sendfull
	end

	table.insert(prisma.commands,{
		Command = command,
		Alias = alias,
		CallBack = fc,
		SendFull = sendfull,
	})
end

--- binds system ---
function prisma:addBind(keycode,Function)
	table.insert(prisma.binds,{
		Key = keycode,
		CallBack = Function,
		Enabled = true,
	})
end
uis.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then return end
	for i,v in pairs(prisma.binds) do
		if v.Key == input.KeyCode then
			if v.Enabled then
				v.CallBack()
			end
		end
	end
end)

--- Functions ---

function prisma:chat(text)

	local function generateMsg(msgdict)
		return '<font color="#'..msgdict["Color"]..'"><font size="'..msgdict["FontSize"]..'"><font face="'..msgdict["Font"]..'">'..msgdict["Text"]..'</font></font></font>'
	end

	if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.LegacyChatService then
		repeat
			task.wait()
			local Success = pcall(function()
				game.StarterGui:SetCore("ChatMakeSystemMessage", {
					Text = ">> [PRISMA]: "..text;
					Font = Enum.Font.SourceSansBold;
					Color = Color3.fromRGB(255, 255, 255);
					FontSize = 25;
				})
			end)
		until Success
	else
		local chat = game:GetService("TextChatService")
		local channel = chat:WaitForChild("TextChannels"):WaitForChild("RBXSystem")

		channel:DisplaySystemMessage(generateMsg({
				Text = ">> [PRISMA]: "..text;
				Font = "SourceSansBold";
				Color = Color3.fromRGB(255, 255, 255):ToHex();
				FontSize = 20;
			})
		)
	end
end

function getRoot()
	return plr.Character.HumanoidRootPart
end

function round(n)
	return math.floor(n + 0.5)
end

flyKeyDown = nil
flyKeyUp = nil
function sFLY(vfly)
	repeat wait() until plr and plr.Character and getRoot() and plr.Character:FindFirstChildOfClass("Humanoid")
	repeat wait() until mouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	local T = getRoot()
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		task.spawn(function()
			repeat wait()
				if not vfly and plr.Character:FindFirstChildOfClass('Humanoid') then
					plr.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if plr.Character:FindFirstChildOfClass('Humanoid') then
				plr.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	flyKeyDown = mouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and vehicleflyspeed or flyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (vfly and vehicleflyspeed or flyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (vfly and vehicleflyspeed or flyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R = (vfly and vehicleflyspeed or flyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = (vfly and vehicleflyspeed or flyspeed)*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -(vfly and vehicleflyspeed or flyspeed)*2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = mouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end

function NOFLY()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if plr.Character:FindFirstChildOfClass('Humanoid') then
		plr.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

function prisma:findplr(args, tbl)
	if tbl == nil then
		local tbl = game.Players:GetPlayers()
		if args == "me" then
			return plr
		elseif args == "random" then 
			return tbl[math.random(1,#tbl)]
		elseif args == "new" then
			local vAges = {} 
			for _,v in pairs(tbl) do
				if v.AccountAge < 30 and v ~= plr then
					vAges[#vAges+1] = v
				end
			end
			return vAges[math.random(1,#vAges)]
		elseif args == "old" then
			local vAges = {} 
			for _,v in pairs(tbl) do
				if v.AccountAge > 30 and v ~= plr then
					vAges[#vAges+1] = v
				end
			end
			return vAges[math.random(1,#vAges)]
		elseif args == "bacon" then
			local vAges = {} 
			for _,v in pairs(tbl) do
				if v.Character:FindFirstChild("Pal Hair") or v.Character:FindFirstChild("Kate Hair") and v ~= plr then
					vAges[#vAges+1] = v
				end
			end
			return vAges[math.random(1,#vAges)]
		elseif args == "friend" then
			local vAges = {} 
			for _,v in pairs(tbl) do
				if v:IsFriendsWith(plr.UserId) and v ~= plr then
					vAges[#vAges+1] = v
				end
			end
			return vAges[math.random(1,#vAges)]
		elseif args == "notfriend" then
			local vAges = {} 
			for _,v in pairs(tbl) do
				if not v:IsFriendsWith(plr.UserId) and v ~= plr then
					vAges[#vAges+1] = v
				end
			end
			return vAges[math.random(1,#vAges)]
		elseif args == "ally" then
			local vAges = {} 
			for _,v in pairs(tbl) do
				if v.Team == plr.Team and v ~= plr then
					vAges[#vAges+1] = v
				end
			end
			return vAges[math.random(1,#vAges)]
		elseif args == "enemy" then
			local vAges = {} 
			for _,v in pairs(tbl) do
				if v.Team ~= plr.Team then
					vAges[#vAges+1] = v
				end
			end
			return vAges[math.random(1,#vAges)]
		elseif args == "near" then
			local vAges = {} 
			for _,v in pairs(tbl) do
				if v ~= plr then
					local math = (v.Character:FindFirstChild("HumanoidRootPart").Position - plr.Character.HumanoidRootPart.Position).magnitude
					if math < 30 then
						vAges[#vAges+1] = v
					end
				end
			end
			return vAges[math.random(1,#vAges)]
		elseif args == "far" then
			local vAges = {} 
			for _,v in pairs(tbl) do
				if v ~= plr then
					local math = (v.Character:FindFirstChild("HumanoidRootPart").Position - plr.Character.HumanoidRootPart.Position).magnitude
					if math > 30 then
						vAges[#vAges+1] = v
					end
				end
			end
			return vAges[math.random(1,#vAges)]
		else 
			for _,v in pairs(tbl) do
				if v.Name:lower():find(args:lower()) or v.DisplayName:lower():find(args:lower()) then
					return v
				end
			end
		end
	else
		for _, plr in pairs(tbl) do
			if plr.UserName:lower():find(args:lower()) or plr.DisplayName:lower():find(args:lower()) then
				return plr
			end
		end
	end
end

function playSound(id,volume,loop,parent)
	local sound = Instance.new("Sound",parent)
	sound.SoundId = id
	sound.PlayOnRemove = true
	sound.Volume = volume
	sound.Looped = loop
	sound:Destroy()
end

function FindInTable(tbl,val)
	if tbl == nil then return false end
	for _,v in pairs(tbl) do
		if v == val then return true end
	end 
	return false
end




--- Cross Compatibility Shit ---

local waiting = {}

function formatText(text)

	local ColorizePattern = '<font color="%s">%s</font>'

	local function Colorize(keyword, color)
		return string.format(ColorizePattern, color, keyword)
	end

	local words = {}
	local newWords = {}
	for word in string.gmatch(text,"[^%s]+") do
		table.insert(words,word)
	end
	for i,v in pairs(words) do
		if string.match(v,"!") then
			local colorValues = "#"..string.sub(v,2,7)
			table.insert(newWords,Colorize(string.sub(v,8,300),colorValues))
		else
			table.insert(newWords,v)
		end
	end
	local text = ""
	for i,v in pairs(newWords) do
		--print(v)
		text = text..v.." "
	end
	return text
end


function prisma:notify(text,lifetime,format)
	lifetime = lifetime or 1
	if not GUI:FindFirstChild("holder") then
		local holder = Instance.new("Frame")
		holder.AnchorPoint = Vector2.new(0.5, 0)
		holder.BackgroundColor3 = Color3.new(1, 1, 1)
		holder.BackgroundTransparency = 1
		holder.BorderColor3 = Color3.new(0, 0, 0)
		holder.BorderSizePixel = 0
		holder.Position = UDim2.new(0.5, 0, 0, 5)
		holder.Size = UDim2.new(0.349999994 / 1.7, 0, 0.949999988 / 1.7, 0)
		holder.Visible = true
		holder.Name = "holder"
		holder.Parent = GUI

		local uilist_layout = Instance.new("UIListLayout")
		uilist_layout.Padding = UDim.new(0, 15)
		uilist_layout.SortOrder = Enum.SortOrder.LayoutOrder
		uilist_layout.Parent = holder

		local template = Instance.new("TextButton")
		template.Font = Enum.Font.SourceSans
		template.Text = ""
		template.TextColor3 = Color3.new(0, 0, 0)
		template.TextSize = 14
		template.BackgroundColor3 = Color3.new(0.203922, 0.203922, 0.203922)
		template.BorderColor3 = Color3.new(0, 0, 0)
		template.BorderSizePixel = 0
		template.Size = UDim2.new(1, 0, 0.129999995, 0)
		template.Visible = false
		template.Name = "template"
		template.AnchorPoint = Vector2.new(0.5, 0)
		template.Parent = holder

		local uicorner = Instance.new("UICorner")
		uicorner.CornerRadius = UDim.new(0, 6)
		uicorner.Parent = template

		local uistroke = Instance.new("UIStroke")
		uistroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		uistroke.Color = Color3.new(1, 1, 1)
		uistroke.Parent = template

		local title = Instance.new("TextLabel")
		title.Font = Enum.Font.Unknown
		title.Text = "PRISMA"
		title.TextColor3 = Color3.new(1, 1, 1)
		title.TextScaled = true
		title.TextSize = 14
		title.TextStrokeColor3 = Color3.new(1, 1, 1)
		title.TextWrapped = true
		title.AnchorPoint = Vector2.new(0.5, 0)
		title.BackgroundColor3 = Color3.new(1, 1, 1)
		title.BackgroundTransparency = 1
		title.BorderColor3 = Color3.new(0, 0, 0)
		title.BorderSizePixel = 0
		title.Position = UDim2.new(0.5, 0, 0, 0)
		title.Size = UDim2.new(1, 0, 0.400000006, 0)
		title.Visible = true
		title.Name = "title"
		title.Parent = template

		local uipadding = Instance.new("UIPadding")
		uipadding.PaddingBottom = UDim.new(0, 5)
		uipadding.PaddingLeft = UDim.new(0, 5)
		uipadding.PaddingRight = UDim.new(0, 5)
		uipadding.PaddingTop = UDim.new(0, 5)
		uipadding.Parent = template

		local line = Instance.new("Frame")
		line.AnchorPoint = Vector2.new(0.5, 0.5)
		line.BackgroundColor3 = Color3.new(1, 1, 1)
		line.BorderColor3 = Color3.new(0, 0, 0)
		line.BorderSizePixel = 0
		line.Position = UDim2.new(0.5, 0, 0.400000006, 0)
		line.Size = UDim2.new(1, 0, 0, 1)
		line.Visible = true
		line.Name = "line"
		line.Parent = template

		local contents = Instance.new("TextLabel")
		contents.Font = Enum.Font.Unknown
		contents.RichText = true
		contents.Text = "Noclip disabled"
		contents.TextColor3 = Color3.new(1, 1, 1)
		contents.TextScaled = true
		contents.TextSize = 14
		contents.TextStrokeColor3 = Color3.new(1, 1, 1)
		contents.TextWrapped = true
		contents.AnchorPoint = Vector2.new(0.5, 1)
		contents.BackgroundColor3 = Color3.new(1, 1, 1)
		contents.BackgroundTransparency = 1
		contents.BorderColor3 = Color3.new(0, 0, 0)
		contents.BorderSizePixel = 0
		contents.Position = UDim2.new(0.5, 0, 1, 0)
		contents.Size = UDim2.new(1, 0, 0.5, 0)
		contents.Visible = true
		contents.Name = "contents"
		contents.Parent = template

		local uitext_size_constraint = Instance.new("UITextSizeConstraint")
		uitext_size_constraint.MaxTextSize = 25
		uitext_size_constraint.Parent = contents
	end

	local holder = GUI.holder

	local notification = holder:FindFirstChild("template"):Clone()

	notification.contents.Text = text
	notification.Visible = true
	notification.Parent = holder
	notification.Size = UDim2.new(1, 0, 0, 0)

	tweenservice:Create(notification, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = UDim2.new(1, 0, 0.129999995, 0)
	}):Play()
	tweenservice:Create(notification:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.05, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Thickness = 1
	}):Play()
	tweenservice:Create(notification.line, TweenInfo.new(0.05, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0
	}):Play()

	tweenservice:Create(notification.line, TweenInfo.new(lifetime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
		Size = UDim2.new(0, 0, 0, 1)
	}):Play()

	delay(lifetime, function()
		notification.title.Visible = false
		notification.contents.Visible = false
		tweenservice:Create(notification:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Thickness = 0
		}):Play()
		tweenservice:Create(notification.line, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			BackgroundTransparency = 1
		}):Play()
		local tween = tweenservice:Create(notification, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {
			Size = UDim2.new(1, 0, 0, 0)
		})
		tween:Play()

		tween.Completed:Wait()
		notification:Destroy()
	end)
end

--- Binds ---

prisma:addBind(Enum.KeyCode.V,function()
	if mouse.Target == nil then return end
	pcall(function()
		local humanoid = getRoot().Parent:FindFirstChild("Humanoid")
		local hipHeight = humanoid and humanoid.HipHeight > 0 and (humanoid.HipHeight + 1)
		local rootPart = getRoot()
		local rootPartPosition = rootPart.Position
		local hitPosition = mouse.Hit.Position
		local newCFrame = CFrame.new(
			hitPosition, 
			Vector3.new(rootPartPosition.X, hitPosition.Y, rootPartPosition.Z)
		) * CFrame.Angles(0, math.pi, 0)

		rootPart.CFrame = newCFrame + Vector3.new(0, hipHeight or 4, 0)
	end)
end)

prisma:addBind(Enum.KeyCode.F5,function()
	if FLYING then
		prisma:executeCommand("unfly")
	else
		prisma:executeCommand("fly",tostring(flyspeed))
	end
end)

local Noclipping = nil
local Clip = true
prisma:addBind(Enum.KeyCode.F6,function()
	if Clip then
		Clip = false
		wait(0.1)
		local function NoclipLoop()
			if Clip == false and plr.Character ~= nil then
				for _, child in pairs(plr.Character:GetDescendants()) do
					if child:IsA("BasePart") and child.CanCollide == true then
						child.CanCollide = false
					end
				end
			end
		end
		Noclipping = runservice.Stepped:Connect(NoclipLoop)
		prisma:notify("Noclip On",2)
	else
		if Noclipping then
			Noclipping:Disconnect()
		end
		Clip = true
		prisma:notify("Noclip Off",2)
	end
end)

prisma:addBind(Enum.KeyCode.F3,function()
	if FLYING then
		NOFLY()
	else
		NOFLY()
		wait()
		sFLY(true)
	end
end)

local delClipboard = {}
prisma:addBind(Enum.KeyCode.Delete,function()
	prisma:executeCommand("clickdelete")
end)

local profly = false
prisma:addBind(Enum.KeyCode.F2,function()
	if not profly then
		profly = true

		spawn(function()
			repeat
				task.wait(.2)
				local part = Instance.new("Part")
				part.Color = Color3.new(0.843137, 0.772549, 0.603922)
				part.Size = Vector3.new(4, 1, 4)
				part.Parent = workspace
				part.Transparency = 0.15
				part.CanCollide = false
				part.Anchored = true
				part.Position = plr.Character.HumanoidRootPart.Position - Vector3.new(0,2.6,0)


				local mesh = Instance.new("SpecialMesh")
				mesh.MeshType = Enum.MeshType.FileMesh
				mesh.MeshId = "rbxassetid://6120788966"
				mesh.TextureId = "rbxassetid://6120789019"
				mesh.Scale = Vector3.new(1, 0.5, 1)
				mesh.Parent = part
				game:GetService("TweenService"):Create(mesh,TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{
					Scale = Vector3.new(4, 0.5, 4)
				}):Play()
				game:GetService("TweenService"):Create(part,TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{
					Transparency = 1
				}):Play()
				game:GetService("Debris"):AddItem(part,1)
			until not profly
		end)

		repeat
			task.wait()
			pro = Instance.new("Part",workspace)
			pro.Anchored = true
			pro.Size = Vector3.new(5,1,5)
			pro.Color = Color3.fromRGB(255, 255, 255)
			pro.Material = Enum.Material.ForceField
			pro.Transparency = 1

			local debris = game:GetService("Debris")
			debris:AddItem(pro,1)
			pro.CFrame = plr.Character.HumanoidRootPart.CFrame - Vector3.new(0,3.5,0)
		until not profly
	else
		profly = false
	end
end)

prisma:addBind(Enum.KeyCode.F8,function()
	prisma:executeCommand("breakvel")
	prisma:notify("Broken Velocity", 0.5)
end)

prisma:addBind(Enum.KeyCode.F10,function()
	prisma:executeCommand("launch")
end)

prisma:addBind(Enum.KeyCode.T,function()
	if profly then
		local Sound = Instance.new("Sound",plr.Character.HumanoidRootPart)
		Sound.SoundId = "rbxassetid://4580495407"
		Sound.PlayOnRemove = true
		Sound.Volume = 3
		Sound.TimePosition = .05
		Sound:Destroy()
		local Anim = Instance.new("Animation")
		Anim.AnimationId = "rbxassetid://188632011"
		local track = plr.Character.Humanoid:LoadAnimation(Anim)
		track:Play()
		track:AdjustSpeed(2)
		local Vele = Instance.new("BodyVelocity",plr.Character.HumanoidRootPart)
		plr.Character.HumanoidRootPart.Anchored = false
		Vele.MaxForce = Vector3.new(1,1,1) * math.huge
		Vele.Velocity = Vector3.new(0,100,0)
		game.Debris:AddItem(Vele,.15)
		local part = Instance.new("Part")
		part.Color = Color3.new(0.843137, 0.772549, 0.603922)
		part.Size = Vector3.new(4, 1, 4)
		part.Parent = workspace
		part.Transparency = 0.15
		part.CanCollide = false
		part.Anchored = true
		part.Position = plr.Character.HumanoidRootPart.Position - Vector3.new(0,2.6,0)


		local mesh = Instance.new("SpecialMesh")
		mesh.MeshType = Enum.MeshType.FileMesh
		mesh.MeshId = "rbxassetid://6120788966"
		mesh.TextureId = "rbxassetid://6120789019"
		mesh.Scale = Vector3.new(1, 0.5, 1)
		mesh.Parent = part
		game:GetService("TweenService"):Create(mesh,TweenInfo.new(2,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{
			Scale = Vector3.new(10, 0.5,  10)
		}):Play()
		game:GetService("TweenService"):Create(part,TweenInfo.new(2,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{
			Transparency = 1
		}):Play()
		game:GetService("Debris"):AddItem(part,2)
	end
end)

prisma:addBind(Enum.KeyCode.F1,function()
	prisma:executeCommand("through")
end)

--- Commands ---


prisma:addCMD("togglebind","bind",function(arg)
	local an;
	if arg == "all" then
		prisma:notify("Toggled All Binds")
		for i,v in pairs(prisma.binds) do
			if v.Enabled then
				v.Enabled = false
			else
				v.Enabled = true
			end
		end
	else
		for i,v in pairs(prisma.binds) do
			if string.sub(string.lower(tostring(v.Key)),14,100) == arg then
				if v.Enabled then
					prisma:notify("Disabled bind for "..tostring(v.Key))
					v.Enabled = false
				else
					prisma:notify("Enabled bind for "..tostring(v.Key))
					v.Enabled = true
				end
			else
				an = true
			end
		end
		if an then
			prisma:notify("No bind with that keycode")
		end
	end
end)

local espConnections = {}

function breakConnection(name)
	for i,v in pairs(espConnections) do
		if v.Player == name then
			v.Connection:Disconnect()
			table.remove(espConnections,i)
		end
	end
end

prisma:addCMD("nameesp","esp",function(arg)
	local cmdlp = game.Players.LocalPlayer
	local cmdp = game.Players

	ESPNEnabled = false
	TrackN = false



	function CreateN(xPlayer, xHead)
		local ESP = Instance.new("BillboardGui", xHead)
		local ESPSquare = Instance.new("Frame", ESP)
		local ESPText = Instance.new("TextLabel", ESP)
		ESP.Name = "ESP"
		ESP.Adornee = xHead
		ESP.AlwaysOnTop = true
		ESP.ExtentsOffset = Vector3.new(0, 1, 0)
		ESP.Size = UDim2.new(0, 5, 0, 5)
		ESPText.Name = "NAME"
		ESPText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ESPText.BackgroundTransparency = 1
		ESPText.BorderSizePixel = 0
		ESPText.Position = UDim2.new(0, 0, 0, -40)
		ESPText.Size = UDim2.new(1, 0, 10, 0)
		ESPText.Visible = true
		ESPText.ZIndex = 10
		ESPText.Font = Enum.Font.SourceSansSemibold
		ESPText.TextStrokeTransparency = 0
		ESPText.TextColor = xPlayer.TeamColor
		ESPText.TextSize = 18

		local uitext_size_constraint = Instance.new("UITextSizeConstraint",ESPText)
		uitext_size_constraint.MaxTextSize = 14
		uitext_size_constraint.MinTextSize = 9

		if xPlayer.DisplayName == xPlayer.Name then
			ESPText.Text = xPlayer.Name
		else
			ESPText.Text = xPlayer.DisplayName.." ("..xPlayer.Name..")"
		end

		local connection = runservice.RenderStepped:Connect(function()

			if xPlayer.Character ~= nil then
				local human = xPlayer.Character:FindFirstChild("Humanoid")
				if human then
					if human.Health <= 0 then
						breakConnection(xPlayer.Name)
					end
				end
			end

			ESPText.TextColor = xPlayer.TeamColor
		end)
		table.insert(espConnections,{
			Player = xPlayer.Name,
			Connection = connection
		})

		-- if arg == nil then

		-- elseif arg == "true" or arg == "yes" then
		-- ESPText.Text = xPlayer.DisplayName
		-- end
	end


	ESPNEnabled = true

	local function Handler(player)
		if player ~= plr and ESPNEnabled then
			repeat
				wait()
				local suc = pcall(function()
					CreateN(player,player.Character.Head)
				end)
			until suc
		end
	end

	for i,v in pairs(game.Players:GetPlayers()) do
		Handler(v)
		v.CharacterAdded:Connect(function()
			task.wait(1)
			Handler(v)
		end)
	end

	game.Players.PlayerAdded:Connect(function(play)
		task.wait(1)
		Handler(play)
		play.CharacterAdded:Connect(function()
			Handler(play)
		end)
	end)

end)

game.Players.PlayerRemoving:Connect(function(player)
	breakConnection(player.Name)
end)

prisma:addCMD("debugconnectiontest","dbct",function()
	print(#espConnections)
end)

prisma:addCMD("unesp",nil,function()
	ESPNEnabled = false
	pcall(function()
		for i,v in pairs(game.Players:GetPlayers()) do
			if v.Character then
				if v.Character.Head:FindFirstChild("ESP") then
					v.Character.Head.ESP:Destroy()
				end
			end
		end
	end)
end)

prisma:addCMD("walkspeed","ws",function(arg)
	local speed = tonumber(arg)
	local suc = pcall(function()
		if speed == nil then
			local error = plr.Character.Position
		end
		plr.Character.Humanoid.WalkSpeed = speed
	end)
	task.wait(.3)
end)

prisma:addCMD("jumppower","jp",function(arg)
	local jump = tonumber(arg)
	local suc = pcall(function()
		if jump == nil then
			local error = plr.Character.Position
		end
		plr.Character.Humanoid.JumpPower = jump
	end)
	task.wait(.3)
end)

prisma:addCMD("suicide","reset",function(arg)
	plr.Character:BreakJoints()
	task.wait(.1)
end)

walkspeedLoop = nil

prisma:addCMD("loopws","lws",function(speed)
	local suc = pcall(function()
		local setspeed = tonumber(speed)
		if setspeed == nil then
			local error = plr.Character.Position
		end
		if walkspeedLoop ~= nil then
			walkspeedLoop:Disconnect()
		end
		walkspeedLoop = plr.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			plr.Character.Humanoid.WalkSpeed = setspeed
		end)
		plr.Character.Humanoid.WalkSpeed = setspeed
	end)
	task.wait(.3)
end)

prisma:addCMD("unloopws","unlws",function()
	pcall(function()
		walkspeedLoop:Disconnect()
		walkspeedLoop = nil
		task.wait(.3)
	end)
end)

prisma:addCMD("clickdelete","delete",function()
	pcall(function()
		local target = mouse.Target
		if target:IsA("BasePart") then
			table.insert(delClipboard,{
				instance = target,
				parent = target.Parent,
				children = target:GetChildren()
			})
		end
		target:Destroy()
	end)
end)

prisma:addCMD("undodelete","undel",function()
	local tab = delClipboard[#delClipboard]
	if tab ~= nil and tab ~= 0 then
		local inst = tab.instance:Clone()
		inst.Parent = tab.parent
		for i,v in pairs(tab.children) do
			v:Clone().Parent = inst
		end
		table.remove(delClipboard,#delClipboard)
	end
end)

prisma:addCMD("goto","to","Teleports to specified player",function(player)
	target = prisma:findplr(player)
	if target then
		plr.Character.Humanoid.Jump = true
		plr.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
	end
end)

prisma:addCMD("gravity","grav",function(arg)
	local grav = tonumber(arg) or 196.2
	workspace.Gravity = grav
end)

prisma:addCMD("sit",nil,function()
	plr.Character.Humanoid.Sit = true
end)

prisma:addCMD("up",nil,function(amount)
	local degree = tonumber(amount) or 0
	plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,degree,0)
end)

prisma:addCMD("forward",nil,function(amount)
	local degree = tonumber(amount) or 0
	plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,degree*-1)
end)

stunned = false
prisma:addCMD("stun","ragdoll",function()
	stunned = true
	repeat
		wait()
		plr.Character.Humanoid.PlatformStand = true
	until not stunned
	task.wait(1)
	plr.Character.Humanoid.PlatformStand = true
end)

prisma:addCMD("unstun","unragdoll",function()
	stunned = false
	repeat wait()
		plr.Character.Humanoid.PlatformStand = false
	until plr.Character.Humanoid.PlatformStand == false
end)

prisma:addCMD("fixcam",nil,function()
	workspace.CurrentCamera:remove()
	wait(.1)
	repeat wait() until plr.Character ~= nil
	workspace.CurrentCamera.CameraSubject = plr.Character:FindFirstChildWhichIsA('Humanoid')
	workspace.CurrentCamera.CameraType = "Custom"
	plr.CameraMinZoomDistance = 0.5
	plr.CameraMaxZoomDistance = 400
	plr.CameraMode = "Classic"
	plr.Character.Head.Anchored = false
end)

local desp = false

prisma:addCMD("health",nil,nil,function()

	-- local espBottle = Instance.new("Folder",plr.PlayerGui)
	-- espBottle.Name = "DetailedEsp"

	local function createESP(part)
		local Health = Instance.new("BillboardGui")
		local main = Instance.new("Frame")


		Health.Name = "DetailedEsp"
		Health.Parent = part
		Health.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		Health.Active = true
		Health.Adornee = part
		Health.AlwaysOnTop = true
		Health.LightInfluence = 1.000
		Health.Size = UDim2.new(0.5, 0, 4.8, 0)
		Health.StudsOffset = Vector3.new(0, -0.5, 0)

		main.Name = "main"
		main.Parent = Health
		main.AnchorPoint = Vector2.new(0.5, 0.5)
		main.Position = UDim2.new(0.5, 0, 0.5, 0)
		main.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		main.Size = UDim2.new(1, 0, 1, 0)
		main.BorderSizePixel = 1
		main.BorderColor3 = Color3.fromRGB(0,0,0)

		coroutine.resume(coroutine.create(function()

			local part = part
			local hum = part.Parent.Humanoid

			part.Parent.Humanoid.Died:Connect(function()
				coroutine.yield()
			end)

			hum.HealthChanged:Connect(function()
				main:TweenSize(UDim2.new(1,0,hum.Health / hum.MaxHealth/10*10,0), Enum.EasingDirection.Out,Enum.EasingStyle.Quint,0.5,true)

				main.BackgroundColor3 = Color3.fromHSV((hum.Health/hum.MaxHealth)*.3, 1, 1)
			end)

		end))

	end

	desp = true

	repeat
		wait()
		for i,v in pairs(game.Players:GetPlayers()) do
			pcall(function()
				if not v.Character.HumanoidRootPart:FindFirstChild("DetailedEsp") and v ~= plr then
					createESP(v.Character.HumanoidRootPart)
				end
			end)
		end
	until not desp

end)


prisma:addCMD("unhealth",nil,nil,function()
	desp = false
	task.wait(1)
	for i,v in pairs(game.Players:GetPlayers()) do
		if v.Character then
			if v.Character.HumanoidRootPart then
				if v.Character.HumanoidRootPart:FindFirstChild("DetailedEsp") then
					v.Character.HumanoidRootPart["DetailedEsp"]:Destroy()
				end
			end
		end
	end
end)


prisma:addCMD("detailesp","desp",nil,function(tracers)
	prisma:executeCommand("health")
	prisma:executeCommand("nameesp")
end)

prisma:addCMD("launch",nil,nil,function(multiplier)
	multiplier = tonumber(multiplier) or 1
	local char = plr.Character
	local vel = Instance.new("BodyVelocity",char.HumanoidRootPart)
	char.HumanoidRootPart.Anchored = false
	vel.MaxForce = Vector3.new(9999999999,99999999999,99999999999999)
	vel.Velocity = Vector3.new(0,350 * multiplier,0)
	debris:AddItem(vel,.15)
end)

prisma:addCMD("breakvelocity","breakvel",nil,function()
	plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
end)

prisma:addCMD("nocdlimits",nil,nil,function()
	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA("ClickDetector") then
			v.MaxActivationDistance = math.huge
		end
	end
end)

prisma:addCMD("say","talk",nil,function(message)
	local args = {
		[1] = message,
		[2] = "All"
	}

	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))

end,true)

prisma:addCMD("freeze",nil,nil,function()
	getRoot().Anchored = true
end)

prisma:addCMD("unfreeze","thaw",nil,function()
	getRoot().Anchored = false
end)

local animTrack
prisma:addCMD('dance', nil, "Dances",function()
	local dances = {"27789359", "30196114", "248263260", "45834924", "33796059", "28488254", "52155728"}
	local animation = Instance.new("Animation")        animation.AnimationId = "rbxassetid://" .. dances[math.random(1, #dances)]
	animTrack = plr.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(animation)
	animTrack:Play()
end)

prisma:addCMD('undance','nodance', "Stops Dancing",function()
	if animTrack then
		animTrack:Stop()
		animTrack:Destroy()
	end
end)

prisma:addCMD("fly",nil,nil,function(speed)
	NOFLY()
	wait()
	sFLY()
	flyspeed = tonumber(speed) or 1
end)

prisma:addCMD("unfly",nil,nil,function(speed)
	NOFLY()
end)

prisma:addCMD("vflyspeed","vspeed",nil,function(speed)
	vehicleflyspeed = tonumber(speed) or 1
end)

prisma:addCMD("flyspeed","fspeed",nil,function(speed)
	flyspeed = tonumber(speed) or 1
end)

local cor
local spawnpart
prisma:addCMD("setspawn","spawn",nil,function()
	local x,y,z = round(plr.Character.HumanoidRootPart.Position.X),round(plr.Character.HumanoidRootPart.Position.Y),round(plr.Character.HumanoidRootPart.Position.Z)
	prisma:notify("Set spawn at "..tostring(Vector3.new(x,y,z)),2)
	if cor ~= nil then
		cor:Disconnect()
	end

	-- local Spawn = getRoot().CFrame

	spawnpart = Instance.new("Part",workspace)
	spawnpart.Anchored = true
	spawnpart.CanCollide = false
	spawnpart.Transparency = 1
	spawnpart.CFrame = getRoot().CFrame

	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {plr.Character}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	local raycastResult = workspace:Raycast(spawnpart.Position, Vector3.new(0,-1*8,0), raycastParams)

	if raycastResult then
		if raycastResult.Instance:IsA("Part") then
			local weld = Instance.new("WeldConstraint",spawnpart)
			spawnpart.Anchored = false
			weld.Part0 = spawnpart
			weld.Part1 = raycastResult.Instance
			prisma:notify("Rayhit",3)
		end
	end

	cor = plr.CharacterAdded:Connect(function()
		task.wait(.5)
		getRoot().CFrame = spawnpart.CFrame
	end)

end)

prisma:addCMD("deletespawn","unspawn",nil,function()
	if cor ~= nil then
		prisma:notify("Deleted spawn",2)
		cor:Disconnect()
		spawnpart:Destroy()
	end
end)

prisma:addCMD("view",nil,nil,function(player)
	target = prisma:findplr(player)
	if target then
		plr.Character.Humanoid.Jump = true
		workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
	end
end)

prisma:addCMD("unview",nil,nil,function(player)
	workspace.CurrentCamera.CameraSubject = getRoot().Parent.Humanoid
end)

prisma:addCMD("fullbright","fb",nil,function()
	game.Lighting.Brightness = 2
	game.Lighting.ClockTime = 14
	game.Lighting.FogEnd = 100000
	game.Lighting.GlobalShadows = false
	game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end)

local chams = false

prisma:addCMD("serverpopulation","pop",function()
	prisma:notify(#game.Players:GetPlayers().." players")
end)

local headsitRun
prisma:addCMD("headsit","climb",function(arg)
	local target = prisma:findplr(arg)
	if target then
		headsitRun = runservice.RenderStepped:Connect(function()
			pcall(function()
				plr.Character.Humanoid.Sit = true
				plr.Character.HumanoidRootPart.CFrame = target.Character.Head.CFrame
			end)
		end)
	end
end)

prisma:addCMD("unheadsit","unclimb",function(arg)
	if headsitRun then
		headsitRun:Disconnect()
	end
end)

prisma:addCMD("showinvisible","sight",function(arg)
	local affected = {}
	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA("Part") then
			if v.Transparency == 1 then
				table.insert(affected,v)
				v.Transparency = 0
			end
		end
	end
	task.wait(5)
	for i,v in pairs(affected) do
		v.Transparency = 1
	end
end)

prisma:addCMD("loopjp","llp",function(speed)
	local suc = pcall(function()
		local setspeed = tonumber(speed)
		if setspeed == nil then
			local error = plr.Character.Position
		end
		if JumpLoop ~= nil then
			JumpLoop:Disconnect()
		end
		JumpLoop = plr.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			plr.Character.Humanoid.JumpPower = setspeed
		end)
		plr.Character.Humanoid.JumpPower = setspeed
	end)
	task.wait(.3)
end)


prisma:addCMD("unloopjp","unljp",function()
	pcall(function()
		JumpLoop:Disconnect()
		JumpLoop = nil
		task.wait(.3)
	end)
end)

local waypoints = {}

local globalWaypoints = {}
-- selene: allow(undefined_variable)
local success, error = pcall(function()
	readfile("prismaWaypoints.config")
end)
if success then
	-- selene: allow(undefined_variable)
	globalWaypoints = readfile("prismaWaypoints.config")
end

if typeof(globalWaypoints) == "string" then
	globalWaypoints = httpService:JSONDecode(globalWaypoints)
end

for _,gameValue in pairs(globalWaypoints) do
	if gameValue.PlaceId == game.PlaceId then
		print("Found Existing Waypoints")
		waypoints = gameValue.Waypoints
	end
end

for i,v in pairs(waypoints) do
	if typeof(v.CF) == "string" then
		v.CF = CFrame.new(Vector3.new(v.CF:match("(.+), (.+), (.+)")))
	end
end

function updateWaypointFile()
	local newWp = {}
	for i,v in pairs(waypoints) do
		table.insert(newWp, {
			Name = v.Name,
			CF = tostring(v.CF.Position)
		})
	end

	table.insert(globalWaypoints, {
		PlaceId = game.PlaceId,
		Waypoints = newWp,
	})
	-- selene: allow(undefined_variable)
	writefile("prismaWaypoints.config", httpService:JSONEncode(globalWaypoints))
end

prisma:addCMD("waypoint","wp",function(name)
	local found = false
	for i,v in pairs(waypoints) do
		if v.Name == name then
			found = true
		end
	end
	if not found then
		table.insert(waypoints,{
			Name = name,
			CF = getRoot().CFrame
		})
		local position = getRoot().CFrame
		local x,y,z = math.round(position.X),math.round(position.Y),math.round(position.Z)
		updateWaypointFile()
		prisma:notify(`Set waypoint {name} at ({x}, {y}, {z})`, 2.5)
	else
		local act = nil
		for i,v in pairs(waypoints) do
			if v.Name == name then
				act = v
			end
		end
		getRoot().CFrame = act.CF
		prisma:notify("Teleported to "..act.Name)
	end
end)

prisma:addCMD("deletewaypoint","delwp",function(name)
	local found = false
	for i,v in pairs(waypoints) do
		if v.Name == name then
			found = true

			table.remove(waypoints, i)
			updateWaypointFile()
			prisma:notify(`Deleted Waypoint, {name}`, 1.5)

		end
	end
	if not found then
		prisma:notify(`Invalid Waypoint, {name}`, 1.5)
	end
end)

prisma:addCMD("refresh","re",function()
	local old = getRoot().CFrame
	plr.Character:BreakJoints()
	reloadev = plr.CharacterAdded:Connect(function()
		task.wait(.5)
		getRoot().CFrame = old
		reloadev:Disconnect()
	end)
end)

prisma:addCMD("help",nil,function()
	local amountOfCmds = #prisma.commands
	for i,v in pairs(prisma.commands) do
		print(v.Command)
	end
	prisma:chat("Press F9 to see commands")
end)

prisma:addCMD("spin",nil,function(speed)
	local spinSpeed = tonumber(speed) or 20
	for i,v in pairs(getRoot():GetChildren()) do
		if v.Name == "Spinning" then
			v:Destroy()
		end
	end
	local Spin = Instance.new("BodyAngularVelocity")
	Spin.Name = "Spinning"
	Spin.Parent = getRoot()
	Spin.MaxTorque = Vector3.new(0, math.huge, 0)
	Spin.AngularVelocity = Vector3.new(0,spinSpeed,0)
end)
prisma:addCMD("unspin",nil,function()
	for i,v in pairs(getRoot():GetChildren()) do
		if v.Name == "Spinning" then
			v:Destroy()
		end
	end
end)

local undo
prisma:addCMD("precisionflight","pfly",function(arg)
	task.wait(1)
	-- plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(0),math.rad(180),math.rad(0))
	-- workspace.CurrentCamera.CFrame = CFrame.new(0,0,0)
	local movePart = Instance.new("Part",workspace)
	movePart.Anchored = true
	movePart.CFrame = plr.Character.HumanoidRootPart.CFrame
	movePart.Transparency = 1
	movePart.CanCollide = false

	pfSpeed = 1

	function asignKeycodeToBool(keycode,bool)
		uis.InputBegan:Connect(function(input,chatting)
			if input.KeyCode == keycode and not chatting then
				bool = true
			end
		end)
		uis.InputEnded:Connect(function(input,chatting)
			if input.KeyCode == keycode then
				bool = false
			end
		end)

		return function()
			return bool
		end
	end

	local Getup,Getdown = asignKeycodeToBool(Enum.KeyCode.Space,false),asignKeycodeToBool(Enum.KeyCode.LeftControl,false)
	local up,down,shift

	uis.InputBegan:Connect(function(input,chatting)
		if input.KeyCode == Enum.KeyCode.LeftShift and not chatting then
			shift = true
		end
	end)
	uis.InputEnded:Connect(function(input,chatting)
		if input.KeyCode == Enum.KeyCode.LeftShift then
			shift = false
		end
	end)

	moveLoop = runservice.RenderStepped:Connect(function(dt)
		if arg == nil then
			plr.Character.Humanoid.PlatformStand = true
		end

		up,down,shift = Getup(),Getdown()

		movePart.CFrame = movePart.CFrame + plr.Character.Humanoid.MoveDirection

		local moveVel = 0.8
		if up then
			movePart.CFrame = movePart.CFrame * CFrame.new(0,moveVel,0)
		elseif down then
			movePart.CFrame = movePart.CFrame * CFrame.new(0,-moveVel,0)
		end

		--#TODO make player look towards movement direction
		plr.Character.HumanoidRootPart.CFrame = movePart.CFrame	
		plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
		workspace.CurrentCamera.CameraSubject = movePart
	end)


	function undo()
		moveLoop:Disconnect()
		movePart:Destroy()
		workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
		plr.Character.Humanoid.PlatformStand = false
	end

	plr.Character.Humanoid.Died:Connect(function()
		undo()
	end)
end)

prisma:addCMD("unprecisionflight","unpfly",function()
	undo()
end)

prisma:addCMD("precisionflightspeed","pflyspeed",function(integer)
	pfSpeed = tonumber(integer) or 100
end)

function visualizeRay(origin,result)
	if result then
		local distance = (origin - result.Position).Magnitude
		local p = Instance.new("Part")
		p.Anchored = true
		p.Parent = workspace
		p.CanCollide = false
		p.Color = Color3.fromRGB(255,0,0)
		p.Size = Vector3.new(0.1, 0.1, distance)
		p.CFrame = CFrame.lookAt(origin, result.Position)*CFrame.new(0, 0, -distance/2)
		return p
	end
end

prisma:addCMD("through","thru",function()
	local function GetNormalFromFace(part, normalId)
		return part.CFrame:VectorToWorldSpace(Vector3.FromNormalId(normalId))
	end

	local function NormalToFace(normalVector, part)

		local TOLERANCE_VALUE = 1 - 0.001
		local allFaceNormalIds = {
			Enum.NormalId.Front,
			Enum.NormalId.Back,
			Enum.NormalId.Bottom,
			Enum.NormalId.Top,
			Enum.NormalId.Left,
			Enum.NormalId.Right
		}    
	
		for _, normalId in pairs( allFaceNormalIds ) do
			if GetNormalFromFace(part, normalId):Dot(normalVector) > TOLERANCE_VALUE then
				return normalId
			end
		end
		
		return nil
	
	end
	
	local function addRotation(part)
		return part.CFrame.Rotation.X+part.CFrame.Rotation.Y+part.CFrame.Rotation.Z
	end


	local function tpshit(root,raycastResult)
		local size = nil
		local face = NormalToFace(raycastResult.Normal,raycastResult.Instance)

		if face == Enum.NormalId.Left or face == Enum.NormalId.Right then
			size = raycastResult.Instance.Size.X
		elseif face == Enum.NormalId.Front or face == Enum.NormalId.Back then
			size = raycastResult.Instance.Size.Z
		end

		size = size + 4

		local new = root.CFrame * CFrame.new(0,0,-size)
		root.CFrame = new
		return new
	end

	local root = Instance.new("Part",workspace)
	root.Anchored = true
	root.CanCollide = false
	root.CFrame = getRoot().CFrame
	root.Size = Vector3.new(1.5,1.5,1.5)

	local rayOrigin = root.CFrame.p
	local rayDirection = root.CFrame.LookVector * 10
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {getRoot().Parent,root}


	local raycastResult = workspace:Raycast(rayOrigin, rayDirection,params)

	local visss = {}

	if raycastResult then
		--local vis = visualizeRay(rayOrigin,raycastResult)
		--vis.Parent = game.Lighting
		--table.insert(visss,vis)
		local pos = tpshit(root,raycastResult).Position

		for i = 1,5 do
			rayOrigin = pos
			rayDirection = root.CFrame.LookVector * 8
			raycastResult = workspace:Raycast(rayOrigin, rayDirection,params)

			if raycastResult then
				--local vis = visualizeRay(rayOrigin,raycastResult)
				--vis.Parent = game.Lighting
				--table.insert(visss,vis)
				pos = tpshit(root,raycastResult).Position
			else
				break
			end
		end
		for i,v in pairs(visss) do
			v.Parent = workspace
		end
		getRoot().CFrame = root.CFrame
		root:Destroy()
	else
		root:Destroy()
	end
end)


local teleoffset = 9000
function teleportWithoutTween(cframe)
	local root = getRoot()
	root.CFrame = root.CFrame * CFrame.new(0,teleoffset,0)
	task.wait(.08)
	root.CFrame = cframe
end

local dodgeEnabled = false
local Held = false
local origin
local ogSubject
uis.InputBegan:Connect(function(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
		Held = true
		if dodgeEnabled then
			ogSubject = workspace.CurrentCamera.CameraSubject
			local root = getRoot()
			origin = Instance.new("Part",workspace)
			origin.Position = root.Position
			origin.Anchored = true
			origin.CanCollide = false
			origin.Transparency = 1
			workspace.CurrentCamera.CameraSubject = origin
		end
	end
end)

uis.InputEnded:Connect(function(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
		Held = false
		if dodgeEnabled then
			workspace.CurrentCamera.CameraSubject = ogSubject
			origin:Destroy()
		end
	end
end)

prisma:addCMD("dodge","dod",function()
	local dodgeoffset = 8
	local dodgeRenderstep
	
	function dodgeEnable()
		local function getRand()
			return math.random(dodgeoffset*-1,dodgeoffset)
		end
		
		
		dodgeRenderstep = coroutine.create(function()
			while task.wait(.1) do
				if dodgeRenderstep == nil or dodgeRenderstep == false then
					break
				end
				
				if Held and dodgeEnabled then
					teleportWithoutTween(origin.CFrame*CFrame.new(getRand(),math.random(0,dodgeoffset),getRand()))
				end
			end
			coroutine.yield()
		end)
		coroutine.resume(dodgeRenderstep)
	end

	function dodgeDisable()
		workspace.CurrentCamera.CameraSubject = ogSubject
		origin:Destroy()
		dodgeRenderstep = nil
	end

	if dodgeEnabled then
		dodgeEnabled = false
		dodgeDisable()
	else
		dodgeEnabled = true
		dodgeEnable()
	end
end)

prisma:addCMD("rejoin","rj",function()

	local TeleportCheck = false
	-- selene: allow(undefined_variable)
	local queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
	game.Players.LocalPlayer.OnTeleport:Connect(function(State)
		if (not TeleportCheck) and queueteleport then
			TeleportCheck = true
		end
	end)

	local Players = game.Players
	local TeleportService = game:GetService("TeleportService")
	if #Players:GetPlayers() <= 1 then
		Players.LocalPlayer:Kick("\nHeheha...")
		wait()
		TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
	else
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
	end
end)

local toolloop
prisma:addCMD("toolloop","tool",function(arg)
	toolloop = runservice.RenderStepped:Connect(function()
		pcall(function()
			plr.Character:FindFirstChildOfClass("Tool"):Activate()
		end)
	end)
end)
prisma:addCMD("untoolloop","unloop",function(arg)
	if toolloop then
		toolloop:Disconnect()
	end
end)

prisma:addCMD("hyrdo","rspy",function()
	local owner = "Upbolt"
	local branch = "revision"

	local function webImport(file)
		return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
	end

	webImport("init")
	webImport("ui/main")
end)

prisma:addCMD("dex",nil,function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end)

prisma:addCMD("replaceshiftlockbind","replaceshift",function(arg)
	local keys = "LeftControl,RightControl"
	local mouseLockController = plr.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("MouseLockController")
	local obj = mouseLockController:FindFirstChild("BoundKeys")
	if obj then
		obj.Value = keys
	else
		obj = Instance.new("StringValue")
		obj.Name = "BoundKeys"
		obj.Value = keys
		obj.Parent = mouseLockController
	end
end)

prisma:addCMD("locate", "lc", function(player)
	target = prisma:findplr(player)
	if target then
		local highlight = Instance.new("Highlight",target.Character)
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.FillTransparency = 1
		highlight.OutlineTransparency = 0
		highlight.OutlineColor = Color3.fromRGB(255,255,255)
		highlight.Name = "Locate"
	else
		prisma:notify("Invalid Player")
	end
end)

prisma:addCMD("unlocate", "unlc", function(player)
	target = prisma:findplr(player)
	if target then
		local highlight = target.Character:FindFirstChild("Locate")
		if highlight then highlight:Destroy() end
	end
end)

prisma:addCMD("gotoposition", "gotopos", function(pos : string)
	getRoot().CFrame = CFrame.new(Vector3.new(pos:match("(.+), (.+), (.+)")))
end)

prisma:chat("Loaded Prisma")
task.wait(.05)
prisma:chat("Version: "..prisma.version)
