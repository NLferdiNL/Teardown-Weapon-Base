#include "datascripts/color4.lua"
#include "scripts/utils.lua"
#include "scripts/savedata.lua"
#include "scripts/ui.lua"
#include "scripts/menu.lua"
#include "datascripts/inputList.lua"

toolName = "moddyweapon"
toolReadableName = "Moddy Weapon"

magSize = 30
currMag = magSize
maxAmmo = 300
spread = 0.05
projectiles = 10 -- 1 for single bullet, multiple for buckshot
shotCooldownTime = 0.2 -- max time between each shot
currentShotCooldown = 0
maxReloadTime = 3
reloadTime = 0
minRndSpread = 1
maxRndSpread = 10
maxDistance = 100
hitForce = 4000
hitscanBullets = true
explosiveBullets = false
explosiveBulletMinSize = 0.3 -- TODO: Add option to menu
explosiveBulletMaxSize = 0.5 -- TODO: Add option to menu
projectileBulletSpeed = 100
applyForceOnHit = true
softRadiusMin = 3
softRadiusMax = 4
mediumRadiusMin = 10
mediumRadiusMax = 15
hardRadiusMin = 10
hardRadiusMax = 15

-- CHEATS:

infiniteAmmo = false
infiniteMag = false
particlesEnabled = true

--TODO: FIX PARTICLE NOT RESETTING

local firedShotLineClass = {
	lifetime = 0.4,
	startPos = nil,
	endPos = nil,
}

local bulletProjectileClass = {
	lifetime = maxDistance,
	currentPos = nil,
	lastPos = nil,
	velocity = nil,
}

local firedProjectiles = {}
local firedShotLines = {}

function init()
	saveFileInit()
	menu_init()
	
	if infiniteAmmo then
		maxAmmo = 999
	end
	
	RegisterTool(toolName, "Moddy Weapon", "MOD/vox/tool.vox")
	SetBool("game.tool." .. toolName .. ".enabled", true)

	SetInt("game.tool." .. toolName .. ".ammo", maxAmmo)
end

function tick(dt)
	menu_tick(dt)
	
	cooldownLogic(dt)
	
	handleAllFiredShotLines(dt)
	handleAllProjectiles(dt)
	
	if not isHoldingGun() then
		if reloadTime > 0 then
			reloadTime = maxReloadTime
		end
		
		return
	end
	
	if needsReload() then
		if getAmmoCount() <= 0 then
			return
		end
		
		reloadLogic(dt)
		return
	end
	
	if not isReadyToFire() then
		return
	end
	
	if isFiringGun() then
		shootLogic()
	end
end

function draw(dt)	
	menu_draw(dt)

	drawUI(dt)
end

-- UI Functions (excludes sound specific functions)

function drawUI(dt)
	
end

-- Creation Functions

function createProjectileBullet(startPos, direction)
	local firedProjectile = deepcopy(bulletProjectileClass)
	
	firedProjectile.currentPos = startPos
	firedProjectile.lastPos = startPos
	firedProjectile.velocity = VecScale(direction, projectileBulletSpeed)
	
	return firedProjectile
end

function createFiredShot(startPos, endPos)
	local firedShot = deepcopy(firedShotLineClass)
	
	firedShot.startPos = startPos
	firedShot.endPos = endPos
	
	return firedShot
end

-- Object handlers

function handleAllProjectiles(dt)
	if #firedProjectiles <= 0 then
		return
	end
	
	for i = #firedProjectiles, 1, -1 do
		local currShot = firedProjectiles[i]
		
		local currPos = currShot.currentPos
		
		currShot.lastPos = VecCopy(currPos)
		
		local nextPos = VecAdd(currPos, VecScale(currShot.velocity, dt * 10))
		
		local directionToNextPos = VecDir(currPos, nextPos)
		
		local distanceTraveled = VecDist(currPos, nextPos)
		
		local hit, hitPoint, distance, normal, shape = raycast(currPos, directionToNextPos, distanceTraveled)
		
		if hit then
			currShot.lifetime = 0
			doBulletHoleAt(hitPoint, normal)
			
			if applyForceOnHit then
				applyForceToHitObject(shape, hitPoint, directionToNextPos)
			end
			
			DrawLine(currPos, hitPoint)
		else
			DrawLine(currPos, nextPos)
		end
		
		currShot.currentPos = nextPos
		
		currShot.lifetime = currShot.lifetime - distanceTraveled
		
		if currShot.lifetime <= 0 then
			table.remove(firedProjectiles, i, 1)
		end
	end
end

function handleAllFiredShotLines(dt)
	if #firedShotLines <= 0 then
		return
	end
	
	for i = #firedShotLines, 1, -1 do
		local currShot = firedShotLines[i]
		
		currShot.lifetime = currShot.lifetime - dt
		
		if currShot.lifetime <= 0 then
			table.remove(firedShotLines, i, 1)
		else
			local alpha = currShot.lifetime / firedShotLineClass.lifetime
		
			DrawLine(currShot.startPos, currShot.endPos, 1, 1, 1, alpha)
		end
	end
end

-- World Sound functions

-- Tool Functions

function getAmmoCount()
	if infiniteAmmo then
		return 9999
	end

	return GetInt("game.tool." .. toolName .. ".ammo")
end

function subFromAmmo(removedAmmo)
	local currAmmo = getAmmoCount()
	local loadedAmmo = removedAmmo
	
	if removedAmmo > currAmmo then
		loadedAmmo = currAmmo
		currAmmo = 0
	else
		currAmmo = currAmmo - removedAmmo
	end
	
	if not infiniteAmmo then
		SetInt("game.tool." .. toolName .. ".ammo", currAmmo)
	end
	
	return loadedAmmo
end

function isHoldingGun()
	return GetString("game.player.tool") == toolName
end

function isFiringGun()
	return InputDown("usetool") and GetString("game.player.tool") == toolName
end

function isReadyToFire()
	return reloadTime <= 0 and currMag > 0 and currentShotCooldown <= 0 and not isMenuOpen()
end

function needsReload(dt)
	if currMag <= 0 then
		return true
	end
	
	if reloadTime > 0 then
		return true
	end
	
	return false
end

function reloadLogic(dt)
	if reloadTime > 0 then
		reloadTime = reloadTime - dt
		
		if reloadTime <= 0 then
			reloadTime = 0
			finishReload()
		else
			local gunBody = GetToolBody()
			local gunTransform = GetBodyTransform(gunBody)
			
			local rotation = QuatEuler(45, 0, 0)
			
			local gunRot = QuatSlerp(gunTransform.rot, rotation, 1)
			
			SetToolTransform(Transform(gunTransform.pos, gunRot))
		end
	elseif currMag <= 0 then
		reloadTime = maxReloadTime
	end
end

function finishReload()
	local loadedAmmo = subFromAmmo(magSize)
	
	currMag = loadedAmmo
end

function cooldownLogic(dt)
	if currentShotCooldown > 0 then
		currentShotCooldown = currentShotCooldown - dt
	end
end

-- Particle Functions

function setupHitParticle()
	ParticleReset()
	ParticleType("smoke")
	ParticleRadius(0.5, 1)
	ParticleCollide(1)
end

function setupShotParticle()	
	ParticleReset()
	ParticleType("smoke")
	ParticleRadius(0.1, 0.3)
	ParticleGravity(0.4)
	ParticleCollide(1)
end

-- Action functions

function posAroundCircle(i, points, originPos, radius)
	local x = originPos[1] + radius * math.cos(2 * i * math.pi / points)
	local z = originPos[3] - radius * math.sin(2 * i * math.pi / points)
	
	return {x, originPos[2], z}
end

function GenerateRandomSpread()
	local index = math.random(0, 360)
	local endPos = posAroundCircle(index, 360, Vec(0, 0, 0), spread)

	--[[local xSpread = math.random(-spread * 100, spread * 100) / 100
	local ySpread = math.random(-spread * 100, spread * 100) / 100]]--
	
	local xSpread = endPos[1] * (math.random(minRndSpread, maxRndSpread) / 10)
	local ySpread = endPos[3] * (math.random(minRndSpread, maxRndSpread) / 10)
	
	return Vec(xSpread, ySpread, 0)
end

function GenerateBulletTrajectory()
	local gunBody = GetToolBody()
	local gunTransform = GetBodyTransform(gunBody)
	
	local gunWidth = 0.5
	local gunHeight = -0.2
	local gunLength = -1.25
	
	local gunFrontPos = TransformToParentPoint(gunTransform, Vec(gunWidth, gunHeight, gunLength))
	local gunFrontPosForward = TransformToParentPoint(gunTransform, Vec(gunWidth, gunHeight, gunLength - 1))
	
	local gunFrontDir = VecDir(gunFrontPos, gunFrontPosForward)
	
	local cameraTransform = GetCameraTransform()
	
	local localShotDirection = Vec(0, 0, -1)
	local spreadVec = GenerateRandomSpread()
	
	localShotDirection = VecAdd(localShotDirection, spreadVec)
	
	local shotDirection = VecDir(cameraTransform.pos, TransformToParentPoint(cameraTransform, localShotDirection))
	
	return gunFrontPos, gunFrontDir, cameraTransform.pos, shotDirection
end

function applyForceToHitObject(shape, hitPoint, shotDirection)
	local shapeBody = GetShapeBody(shape)
	
	ApplyBodyImpulse(shapeBody, hitPoint, VecScale(shotDirection, hitForce))
end

function doBulletHoleAt(hitPoint, normal)
	local softRadius = math.random(softRadiusMin, softRadiusMax) / 10
	local mediumRadius = softRadius - math.random(mediumRadiusMin, mediumRadiusMax) / 100
	local hardRadius = mediumRadius - math.random(hardRadiusMin, hardRadiusMax) / 100
	
	setupHitParticle()
	
	if particlesEnabled then
		SpawnParticle(hitPoint, normal, 5)
	end
	
	if explosiveBullets then
		Explosion(hitPoint, math.random(explosiveBulletMinSize, explosiveBulletMaxSize))
	else
		MakeHole(hitPoint, softRadius, mediumRadius, hardRadius)
	end
end

function doHitScanShot(shotStartPos, shotDirection)
	local hit, hitPoint, distance, normal, shape = raycast(shotStartPos, shotDirection, maxDistance)
	
	if hit then
		doBulletHoleAt(hitPoint, normal)
		
		if applyForceOnHit then
			applyForceToHitObject(shape, hitPoint, shotDirection)
		end
		
		return hitPoint
	end
	
	return VecAdd(shotStartPos, VecScale(shotDirection, 500))
end

function shootLogic()
	currentShotCooldown = shotCooldownTime
	
	if not infiniteMag then
		currMag = currMag - 1
	end
	
	setupShotParticle()
	
	for i = 1, projectiles do
		local gunFrontPos, gunFrontDir, shotStartPos, shotDirection = GenerateBulletTrajectory()
		
		local hitPoint = nil
		
		if hitscanBullets then
			hitPoint = doHitScanShot(shotStartPos, shotDirection)
		end
		
		if i == 1 and particlesEnabled then
			SpawnParticle(gunFrontPos, gunFrontDir, 3)
		end
		
		if hitscanBullets then
			local firedShot = createFiredShot(gunFrontPos, hitPoint)
			
			table.insert(firedShotLines, firedShot)
		else
			local firedProjectile = createProjectileBullet(shotStartPos, shotDirection)
			
			table.insert(firedProjectiles, firedProjectile)
		end
	end
end

-- Sprite functions

-- UI Sound Functions
