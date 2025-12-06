getgenv().Config = {
	Invite = "discord.gg/flew",
	Version = "0.0",
}

getgenv().luaguardvars = {
	DiscordName = "dev",
}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/diaryyyy/Poems/refs/heads/main/lib/main.lua"))()

library:init() -- init lib do not delete

local Window = library.NewWindow({
	title = "poems | discord.gg/poems | zee hood",
	size = UDim2.new(0, 525, 0, 650)
})

local tabs = {
    Tab1 = Window:AddTab("Combat"),
    Tab2 = Window:AddTab("Player"),
    Tab3 = Window:AddTab("Visuals"),
	Settings = library:CreateSettingsTab(Window),
}

-- 1 = Set Section Box To The Left
-- 2 = Set Section Box To The Right

local sections = {
	Combat = tabs.Tab1:AddSection("Combat", 1),
	Movement = tabs.Tab2:AddSection("Walkspeed", 1),
    Visuals = tabs.Tab3:AddSection("Visuals", 1),
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local walkSpeedEnabled = false
local customWalkSpeed = 16

local function cframeWalk()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	while walkSpeedEnabled and character.Parent ~= nil do
		local deltaTime = RunService.Heartbeat:Wait() 
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
		    humanoid:ChangeState(Enum.HumanoidStateType.Running)
			humanoid.WalkSpeed = 0
		end

		local moveVector = Vector3.new(0, 0, 0)

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			moveVector = moveVector + Vector3.new(0, 0, -1)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			moveVector = moveVector + Vector3.new(0, 0, 1)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			moveVector = moveVector + Vector3.new(-1, 0, 0)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			moveVector = moveVector + Vector3.new(1, 0, 0)
		end

		if moveVector.Magnitude > 0 then
			local normalizedVector = moveVector.Unit 

			local worldMove = humanoidRootPart.CFrame:VectorToWorldSpace(normalizedVector) 
			local translation = worldMove * customWalkSpeed * deltaTime
			humanoidRootPart.CFrame = humanoidRootPart.CFrame + translation
		end
	end

	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = 16
		end
		end
end

sections.Movement:AddToggle({
	text = "Walkspeed",
	flag = "WalkSpeedToggle",
	tooltip = "Enables walkspeed | USE SHIFTLOCK FOR PROPER FUNCTIONALITY",
	risky = true,
	callback = function(toggle)
		walkSpeedEnabled = toggle
		if walkSpeedEnabled then
			task.spawn(cframeWalk) 
		else
		end
	end
})

sections.Movement:AddSlider({
	text = "Amount",
	flag = "WalkSpeedSlider",
	tooltip = "Walkspeed amount | MAY CAUSE YOU TO NOCLIP THROUGH OBJECTS.",
	value = customWalkSpeed,
	min = 16,
	max = 1000,
	increment = 1,
	callback = function(value)
		customWalkSpeed = value
	end
})

library:SendNotification("Loaded poems", 5, Color3.new(255, 0, 0))

local function deathHandler()
    if walkSpeedEnabled then
        task.spawn(smoothMove)
    end
end

player.CharacterAdded:Connect(deathHandler)
