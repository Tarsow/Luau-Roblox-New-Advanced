-- local script

local players = game:GetService("Players")
local RP = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = players.LocalPlayer
local mouse = player:GetMouse()

local recoilOut
local recoilIn = TweenService:Create(workspace.CurrentCamera,TweenInfo.new(0.7),{FieldOfView=60})

local shootAmount = 0

local gun = script.Parent

local activated = false

gun.Activated:Connect(function()
	if mouse.Target ~= nil then
		activated = true
		while activated do
			if shootAmount < 40 then
				recoilOut = TweenService:Create(workspace.CurrentCamera,TweenInfo.new(.2),{FieldOfView=70 + shootAmount})
			end
			RP.Events.AkShoot:FireServer(mouse.Hit.Position, false)
			wait(0.1)
			recoilOut:Play()
			if activated == false then
				break	
			end
			shootAmount += 2
		end
	else
		RP.Events.AkShoot:FireServer(mouse.Hit.Position, true)
	end
end)

mouse.Button1Up:Connect(function()
	activated = false
	local recoilOutCompleted = false
	recoilOut:Play()
	recoilOut.Completed:Connect(function()
		recoilOutCompleted = true
	end)
	
	local endTime = tick() + 1
	while not recoilOutCompleted and tick() < endTime do
		wait(0.1)
	end

	recoilIn:Play()
	shootAmount = 0
end)

-- server script

local RP = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local gunRange = 500

RP.Events.AkShoot.OnServerEvent:Connect(function(player, mousePosition, target)
	
	local gun = player.Character:FindFirstChildOfClass("Tool")
	
	if gun == nil then return end
	
	local damage = gun.gunDamage.Value
	
	local direction = (mousePosition - gun.Handle.Position) * gunRange
	
	local ray = RaycastParams.new()
	ray.FilterDescendantsInstances = {player.Character}
	ray.FilterType = Enum.RaycastFilterType.Exclude
	
	local final = workspace:Raycast(gun.Handle.Position, direction, ray)
	
	local bullet = RP.Models.Bullet:Clone()
	bullet.CFrame = gun.Handle.CFrame
	bullet.Parent = workspace
	
	local bulletSpeed = 0.2  * ((direction/gunRange).Magnitude)/50
	
	TweenService:Create(bullet, TweenInfo.new(bulletSpeed), {CFrame = CFrame.new(mousePosition)}):Play()
	
	if not target then
		task.wait(bulletSpeed)
			bullet:Destroy()
	else
		task.delay(1, function()
			bullet:Destroy()
		end)
	end
	
	if final == nil then return end
	
	local char = final.Instance.Parent
	
	if char == nil then return end
	
	local humanoid = char:FindFirstChild("Humanoid")
	
	if humanoid == nil then return end
	
	task.wait(bulletSpeed)
	
	humanoid.Health -= damage
	
end)
