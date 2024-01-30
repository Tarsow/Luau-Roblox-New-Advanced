-- this is the framework i use in most of my scripts

-- Module Function

local debris = game:GetService("Debris")

local Functions = {}

function Functions.SpawnBallWithVelocity(X:number, Z:number, Size:Vector3, lifeTime:number, velocityRange:"number (default is 10)")
	if velocityRange == nil then
		velocityRange = 10
	end
	local Ball = Instance.new("Part", workspace)
	Ball.CanCollide = true
	Ball.Shape = Enum.PartType.Ball
	Ball.Position = Vector3.new(X, 0, Z) 
	Ball.Size = Vector3.new(Size)

	Ball.TopSurface = Enum.SurfaceType.Smooth
	Ball.BottomSurface =  Enum.SurfaceType.Smooth

	local velocity = Instance.new("BodyVelocity", Ball)
	velocity.Velocity = Vector3.new(math.random(-velocityRange,velocityRange),math.random(-velocityRange,velocityRange),math.random(-velocityRange,velocityRange))

	debris:AddItem(Ball, lifeTime)
end

function Functions.randomString(length:number, words:number)
	local caracters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local resultTable = {}
	for i = 1, words do
		local result = ""
		for i = 1, length do
			local randomNum = math.random(1, #caracters)
			local randomChar = string.sub(caracters, randomNum, randomNum)
			result = result .. randomChar
		end
		table.insert(resultTable, result)
	end

	return resultTable
end

return Functions
