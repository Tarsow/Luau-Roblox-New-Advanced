-- server script

local debris = game:GetService("Debris")

local Gun = script.Parent
local Model = Gun.Parent

local BulletDamage = 10
local FireRate = 0.2
local BulletSpeed = 300
local DetectDistance = 150

local Bullet = game.ReplicatedStorage.Bullet

local function canSeeTarget(target)
	local ray = Ray.new(Gun.Position, (target.Position - Gun.Position).Unit*DetectDistance) -- creates new ray
	local hit, position = game.Workspace:FindPartOnRayWithIgnoreList(ray, {Gun, Bullet}) -- casts new ray
	
	if hit == target then
		return true
	else	
		return false
	end

end

local function findTarget()
	local maxDistance = DetectDistance
	local target
	local players = game.Players:GetChildren()
	for i, player in pairs(players) do
		local char = player.Character
		if not char then return end
		local HRP = char.HumanoidRootPart
		local humanoid = char.Humanoid
		if HRP and humanoid and humanoid.Health > 0 then
			local distance = (Gun.Position - HRP.Position).Magnitude
			if distance < maxDistance then
				maxDistance = distance
				target = HRP
			end
		end
	end
	return target
end


local function fire(target)
	Gun.CFrame = CFrame.new(Gun.Position, target.Position) -- turns the front surface in the direction of the target
	local debounce = false
	local newBullet = Bullet:Clone()
	newBullet.Parent = workspace
	newBullet.Position = Gun.Position
	newBullet.CanCollide = false

	newBullet.Velocity = Gun.CFrame.LookVector * BulletSpeed

	newBullet.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid and not debounce then
			debounce = true
			humanoid.Health -= BulletDamage
		end
		debris:AddItem(newBullet, 10) -- Destroys the bullet after 10 seconds passed
	end)
	debounce = false
end

while task.wait(FireRate) do
	local target = findTarget()

	if target and canSeeTarget(target) then
		fire(target)
	end
end
