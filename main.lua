#include "datascripts/color4.lua"
#include "scripts/utils.lua"
#include "scripts/savedata.lua"
#include "scripts/ui.lua"
#include "scripts/menu.lua"
#include "datascripts/inputList.lua"
#include "customlist.lua"

toolName = "moddyweapon"
toolReadableName = "Moddy Weapon"

name = "Shotgun"
magSize = 30 -- TODO: Add option to menu
currMag = magSize -- TODO: Add visual
maxAmmo = 300 -- TODO: Add option to menu
spread = 0.05
projectiles = 10 -- 1 for single bullet, multiple for buckshot
shotCooldownTime = 0.2 -- max time between each shot
currentShotCooldown = 0
fullAuto = false
burstFireMax = 0  -- TODO: Add option to menu
burstFire = burstFireMax
maxReloadTime = 3
reloadTime = 0
minRndSpread = 1
maxRndSpread = 10
maxDistance = 100
hitForce = 4000 -- TODO: Add option to menu
hitscanBullets = true
explosiveBullets = false
explosiveBulletMinSize = 0.3
explosiveBulletMaxSize = 0.5
projectileBulletSpeed = 100
applyForceOnHit = true
softRadiusMin = 3
softRadiusMax = 4
mediumRadiusMin = 10
mediumRadiusMax = 15
hardRadiusMin = 10
hardRadiusMax = 15
sfx = {}

-- CHEATS:

infiniteAmmo = false
infiniteMag = false
particlesEnabled = true
soundEnabled = true

--TODO: Shotgun reload/additive reload

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
	explosive = false,
	explosiveMin = 0.5,
	explosiveMax = 1,
}

local firedProjectiles = {}
local firedShotLines = {}
local currentSelectedWeapon = 1
local prevFrameSelectedWeapon = 1

name = GetNameByIndex(currentSelectedWeapon)
ApplySettingsByIndex(currentSelectedWeapon)

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
	
	prevFrameSelectedWeapon = currentSelectedWeapon
	
	weaponTypeSelectionHandler()
	
	if needsReload() then
		if getAmmoCount() <= 0 then
			return
		end
		
		reloadLogic(dt)
		return
	end
	
	handleBurstFire()
	
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
	if not isHoldingGun() then
		return
	end
	
	drawWeaponSelection()
end

function drawWeaponSelection()
	local prevIndex = currentSelectedWeapon - 1
	local nextIndex = currentSelectedWeapon + 1
	
	local listCount = GetListCount()
	
	if prevIndex <= 0 then
		prevIndex = listCount
	end
	
	if nextIndex > listCount then
		nextIndex = 1
	end
	
	local prevWeaponName = GetNameByIndex(prevIndex)
	local currWeaponName = name
	local nextWeaponName = GetNameByIndex(nextIndex)
	
	UiPush()
		UiAlign("center bottom")
		UiTranslate(UiWidth() * 0.5, UiHeight() * 0.95)
		UiFont("regular.ttf", 26)
		UiTextShadow(0, 0, 0, 0.5, 2.0)
		UiText("[" .. binds["Prev_Weapon"]:upper() .. "] " .. prevWeaponName .. " | " .. currWeaponName .. " | [" .. binds["Next_Weapon"]:upper() .. "] " .. nextWeaponName)
	UiPop()
end

-- Creation Functions

function createProjectileBullet(startPos, direction)
	local firedProjectile = deepcopy(bulletProjectileClass)
	
	firedProjectile.lifetime = maxDistance
	firedProjectile.currentPos = startPos
	firedProjectile.lastPos = startPos
	firedProjectile.velocity = VecScale(direction, projectileBulletSpeed)
	firedProjectile.explosive = explosiveBullets
	firedProjectile.explosiveMin = explosiveBulletMinSize
	firedProjectile.explosiveMax = explosiveBulletMaxSize
	
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
			doBulletHoleAt(currShot, hitPoint, normal, true)
			
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
			doBulletHoleAt(currShot, currPos, VecDir(currPos, GetPlayerTransform().pos), false)
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

function handleBurstFire()
	if burstFireMax > 0 and burstFire < burstFireMax and not isFiringGun() then
		burstFire = burstFireMax
	end
end

-- World Sound functions

-- Tool Functions

function weaponTypeSelectionHandler()
	local movement = 0
	
	if InputPressed(binds["Prev_Weapon"]) then
		movement = movement - 1
	end
	
	if InputPressed(binds["Next_Weapon"]) then
		movement = movement + 1
	end
	
	local newIndex = currentSelectedWeapon + movement
	local listCount = GetListCount()
	
	if newIndex < 1 then
		newIndex = listCount
	elseif newIndex > GetListCount() then
		newIndex = 1
	end
	
	if movement == 0 then
		return
	end
	
	currentSelectedWeapon = newIndex
	
	name = GetNameByIndex(currentSelectedWeapon)
	ApplySettingsByIndex(currentSelectedWeapon)
end

function getAmmoCount()
	if infiniteAmmo then
		return 9999
	end

	return GetInt("game.tool." .. toolName .. ".ammo")
end

function addToAmmo(addedAmmo)
	local currAmmo = getAmmoCount() + addedAmmo
	
	SetInt("game.tool." .. toolName .. ".ammo", currAmmo)
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
	local isHoldingGun = GetString("game.player.tool") == toolName
	local isFiringFullAuto = fullAuto and InputDown("usetool")
	local isFiringSingleFire = not fullAuto and InputPressed("usetool") and burstFireMax <= 0
	local isBurstFiring = not fullAuto and InputDown("usetool") and burstFireMax > 0
	
	return (isFiringFullAuto or isFiringSingleFire or isBurstFiring) and isHoldingGun
end

function hasChangedSettings()
	return currentSelectedWeapon ~= prevFrameSelectedWeapon
end

function isReadyToFire()
	local required = reloadTime <= 0 and currMag > 0 and currentShotCooldown <= 0 and not isMenuOpen() and GetPlayerVehicle() == 0

	if burstFireMax > 0 then
		return required and burstFire > 0
	end
	
	return required
end

function needsReload(dt)
	if currMag <= 0 then
		return true
	end
	
	if reloadTime > 0 then
		return true
	end
	
	if InputPressed(binds["Reload"]) then
		addToAmmo(currMag)
		
		currMag = 0
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

function setupShotSmokeParticle()	
	ParticleReset()
	ParticleType("smoke")
	ParticleRadius(0.1, 0.3)
	ParticleGravity(0.4)
	ParticleColor(1, 1, 1, 0, 0, 0)
	ParticleCollide(1)
end

function setupShotFireParticle()	
	ParticleReset()
	ParticleType("plain")
	ParticleTile(5)
	ParticleStretch(1, 0.3)
	ParticleColor(1, 0.6, 0.2, 0, 0, 0)
	ParticleRadius(0.4, 0.2, "smooth")
	ParticleEmissive(1, 0, "smooth")
	ParticleGravity(0)
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

function fakeHitScanBullet()
	local newBullet = createProjectileBullet(Vec(0, 0, 0), Vec(0, 0, 0))

	return newBullet
end

function applyForceToHitObject(shape, hitPoint, shotDirection)
	local shapeBody = GetShapeBody(shape)
	
	ApplyBodyImpulse(shapeBody, hitPoint, VecScale(shotDirection, hitForce))
end

function doBulletHoleAt(bullet, hitPoint, normal, hitParticles)
	setupHitParticle()
	
	if particlesEnabled and hitParticles then
		SpawnParticle(hitPoint, normal, 5)
	end
	
	if bullet.explosive then
		Explosion(hitPoint, math.random(bullet.explosiveMin, bullet.explosiveMax))
	else
		local softRadius = math.random(softRadiusMin, softRadiusMax) / 10
		local mediumRadius = math.random(mediumRadiusMin, mediumRadiusMax) / 10
		local hardRadius = math.random(hardRadiusMin, hardRadiusMax) / 10
	
		MakeHole(hitPoint, softRadius, mediumRadius, hardRadius)
	end
end

function doHitScanShot(shotStartPos, shotDirection)
	local hit, hitPoint, distance, normal, shape = raycast(shotStartPos, shotDirection, maxDistance)
	
	if not hit then
		hitPoint = VecAdd(shotStartPos, VecScale(shotDirection, 500))
		normal = VecDir(hitPoint, shotStartPos)
	end

	doBulletHoleAt(fakeHitScanBullet(), hitPoint, normal, hit)
	
	if applyForceOnHit and hit then
		applyForceToHitObject(shape, hitPoint, shotDirection)
	end
		
	return hitPoint
end

function shootLogic()
	currentShotCooldown = shotCooldownTime
	
	if not infiniteMag then
		currMag = currMag - 1
	end
	
	if burstFireMax > 0 then
		burstFire = burstFire - 1
	end
	
	for i = 1, projectiles do
		local gunFrontPos, gunFrontDir, shotStartPos, shotDirection = GenerateBulletTrajectory()
		
		local hitPoint = nil
		
		if hitscanBullets then
			hitPoint = doHitScanShot(shotStartPos, shotDirection)
		end
		
		if i == 1 then
			if sfx["shot"] ~= nil and soundEnabled then
				PlaySound(sfx["shot"], gunFrontPos, math.random(7, 10) / 10)
			end
			
			if particlesEnabled then
				setupShotSmokeParticle()
				SpawnParticle(gunFrontPos, gunFrontDir, 3)
				setupShotFireParticle()
				SpawnParticle(gunFrontPos, gunFrontDir, 0.5)
			end
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
