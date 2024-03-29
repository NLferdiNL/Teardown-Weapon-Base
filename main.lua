#include "customlist.lua"
#include "datascripts/color4.lua"
#include "scripts/utils.lua"
#include "scripts/savedata.lua"
#include "scripts/ui.lua"
#include "scripts/menu.lua"
#include "datascripts/inputList.lua"

toolName = "moddyweapon"
toolReadableName = "Moddy Weapon"
toolVersion = "V2.3.2"

-- TODO: Add sound editor
-- TODO: Fix projectileBouncyness for hitscan (DONT USE THE PROJECTILE BOUNCE, REUSE THE EQUATION)
-- TODO: Line color.
-- TODO: Projectile lighting
-- TODO: Fix final hit DMG MP on infinite pen.

name = "Shotgun"
customProfile = false
additiveReload = true
additiveReloading = false
magSize = 30
currMag = 0
maxAmmo = 300
currAmmo = maxAmmo
spread = 0.05
projectiles = 10 -- 1 for single bullet, multiple for buckshot
shotCooldownTime = 0.2 -- max time between each shot
currentShotCooldown = 0
fullAuto = false
warmupTimeMax = 0
warmupWindDown = false
warmupSingleFireShot = false
warmupTime = 0
burstFireMax = 0
burstFire = burstFireMax
maxReloadTime = 3
reloadTime = 0
minXSpread = 0
maxXSpread = 1
minYSpread = 0
maxYSpread = 1
maxDistance = 100
hitForce = 4000
hitscanBullets = true
incendiaryBullets = false
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
bulletHealth = 5
infinitePenetration = false
projectileGravity = 0
projectileBouncyness = 0
sfx = {} -- TODO: Add option to menu
sfxLength = {}
fireTime = 0
drawProjectileLine = true
finalHitDmgMultiplier = 1
lineColorRed = 1
lineColorGreen = 1
lineColorBlue = 1
lineColorAlpha = 1
finalHitExplosion = false
laserSeeker = false
laserSeekerTurnSpeed = 1
targetSeeker = false
targetSeekerOffset = false

hitParticleSettings = {
	enabled = true,
	ParticleType = 1,
	ParticleTile = 0,
	lifetime = 5,
	ParticleColor = {1, 1, 1, 1, 1, 1},
	ParticleRadius = 	{ true, 0.5, 1, 1, 0, 1},
	ParticleAlpha = 	{ false, 1, 1, 1, 0, 1},
	ParticleGravity = 	{ false, 0, 0, 1, 0, 1},
	ParticleDrag = 		{ false, 0, 0, 1, 0, 1},
	ParticleEmissive = 	{ false, 0, 0, 1, 0, 1},
	ParticleRotation = 	{ false, 0, 0, 1, 0, 1},
	ParticleStretch = 	{ false, 0, 0, 1, 0, 1},
	ParticleSticky = 	{ false, 0, 0, 1, 0, 1},
	ParticleCollide = 	{ true, 1, 1, 1, 0, 1},
}

shotSmokeParticleSettings = {
	enabled = true,
	ParticleType = 1,
	ParticleTile = 0,
	lifetime = 3,
	ParticleColor = {0, 1, 0, 1, 1, 1},
	ParticleRadius = 	{ true, 0.1, 0.3, 1, 0, 1},
	ParticleAlpha = 	{ false, 1, 1, 1, 0, 1},
	ParticleGravity = 	{ false, 0.4, 0.4, 1, 0, 1},
	ParticleDrag = 		{ false, 0, 0, 1, 0, 1},
	ParticleEmissive = 	{ false, 0, 0, 1, 0, 1},
	ParticleRotation = 	{ false, 0, 0, 1, 0, 1},
	ParticleStretch = 	{ false, 0, 0, 1, 0, 1},
	ParticleSticky = 	{ false, 0, 0, 1, 0, 1},
	ParticleCollide = 	{ true, 1, 1, 1, 0, 1},
}

shotFireParticleSettings = {
	enabled = true,
	ParticleType = 2,
	ParticleTile = 3,
	lifetime = 0.5,
	ParticleColor = {0, 1, 0, 1, 1, 1},
	ParticleRadius = 	{ true, 0.4, 0.2, 2, 0, 1},
	ParticleAlpha = 	{ false, 1, 1, 1, 0, 1},
	ParticleGravity = 	{ false, 0, 0, 1, 0, 1},
	ParticleDrag = 		{ false, 0, 0, 1, 0, 1},
	ParticleEmissive = 	{ true, 1, 0, 2, 0, 1},
	ParticleRotation = 	{ false, 0, 0, 1, 0, 1},
	ParticleStretch = 	{ true, 1, 0.3, 1, 0, 1},
	ParticleSticky = 	{ false, 0, 0, 1, 0, 1},
	ParticleCollide = 	{ true, 1, 1, 1, 0, 1},
}

projectileParticleSettings = {
	enabled = false,
	ParticleType = 1,
	ParticleTile = 0,
	lifetime = 3,
	ParticleColor = {0, 1, 1, 1, 1, 1},
	ParticleRadius = 	{ true, 0.1, 0.1, 1, 0, 1},
	ParticleAlpha = 	{ false, 1, 1, 1, 0, 1},
	ParticleGravity = 	{ false, 1, 1, 1, 0, 1},
	ParticleDrag = 		{ false, 0, 0, 1, 0, 1},
	ParticleEmissive = 	{ false, 0, 0, 1, 0, 1},
	ParticleRotation = 	{ false, 0, 0, 1, 0, 1},
	ParticleStretch = 	{ false, 0, 0, 1, 0, 1},
	ParticleSticky = 	{ false, 0, 0, 1, 0, 1},
	ParticleCollide = 	{ true, 1, 1, 1, 0, 1},
}

-- MISC/UNSORTED:
infinitePenetrationHitScanStart = 5
minExplosiveDistanceMultiplier = 6
minExplosiveDistanceHitscanMultiplier = 7.5
infinitePenetrationHitScanDamageStep = 0.2
hitscanParticleStep = 0.2

-- CHEATS:

-- Handled in savedata.lua now
--infiniteAmmo = false
--infiniteMag = false
--soundEnabled = true
smartExplosiveBullets = true

interpolationMethods = { "Linear", "Smooth", "Easein", "Easeout", "Constant", }
particleTypes = { "Smoke", "Plain", }

local firedShotLineClass = {
	lifetime = 0.4,
	points = {},
	lineColor = {1, 1, 1, 1},
}

local bulletProjectileClass = {
	bulletSettingsIndex = nil,
	drawLine = true,
	lifetime = maxDistance,
	bulletHealth = 0,
	currentPos = nil,
	direction = nil,
	velocity = 0,
	speed = 1,
	incendiary = false,
	explosive = false,
	infinitePenetration = false,
	explosiveSize = 0.5,
	softRadius = 0,
	mediumRadius = 0,
	hardRadius = 0,
	projectileGravity = 0,
	projectileBouncyness = 0,
	finalHitDmgMultiplier = 1,
	finalHitExplosion = false,
	lineColor = {1, 1, 1, 1},
	laserSeeker = false,
	laserSeekerTurnSpeed = 1,
	targetSeekerShape = -1,
	targetSeekerOffset = nil,
}

local firedProjectiles = {}
local firedShotLines = {}

local currentSelectedWeapon = 1
local prevFrameSelectedWeapon = 1

local laserEndPoint = Vec()
local laserTargetShape = -1

name = GetNameByIndex(currentSelectedWeapon)
ApplySettingsByIndex(currentSelectedWeapon)

function init()
	saveFileInit()
	menu_init()
	
	RegisterTool(toolName, toolReadableName, "MOD/vox/tool.vox")
	SetBool("game.tool." .. toolName .. ".enabled", true)
end

function tick(dt)
	if hasQuickLoaded() then
		saveFileInit()
	end

	menu_tick(dt)
	
	cooldownLogic(dt)
	
	handleAllFiredShotLines(dt)
	handleAllProjectiles(dt)
	
	prevFrameSelectedWeapon = currentSelectedWeapon
	
	if not isHoldingGun() then
		if reloadTime > 0 then
			reloadTime = maxReloadTime
		end
		
		if warmupTimeMax > 0 then
			warmupTime = 0
		end
		
		if additiveReloading then
			additiveReloading = false
			reloadTime = 0
		end
		
		return
	end
	
	
	local gunFrontPos, gunFrontDir, cameraPos, shotDirection = GenerateBulletTrajectory(true)
	
	local hit, hitPoint, distance, normal, shape = raycast(cameraPos, shotDirection)
	
	gunFrontPos = VecSub(gunFrontPos, VecScale(gunFrontDir, 0.2))
	
	if hit then
		laserEndPoint = hitPoint
		laserTargetShape = shape
	else
		laserEndPoint = VecAdd(gunFrontPos, VecScale(gunFrontDir, 200))
		laserTargetShape = -1
	end
	
	if laserSeeker or targetSeeker then
		if targetSeeker and laserTargetShape > -1 then
			DrawShapeOutline(laserTargetShape, 1, 0, 0, 1)
		end
		
		if hit then
			PointLight(hitPoint, 1, 0, 0, 0.2)
		end
	
		DrawLine(gunFrontPos, laserEndPoint, 1, 0, 0, 1)
	end
	
	if isMenuOpen() then
		return
	end
	
	weaponTypeSelectionHandler()
	
	shootingSoundLogic()
	handleFireTime(dt)
	handleWarmup(dt)
	
	--bounceLaserTest()
	
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
	
	checkRandomValues()
	
	if isFiringGun() then
		shootLogic()
	end
end

function draw(dt)	
	menu_draw(dt)

	drawUI(dt)
end

function hasQuickLoaded()
	local result = GetCustomListDefaultCount() + customProfiles ~= GetListCount()
	
	return result
end

-- UI Functions (excludes sound specific functions)

function drawUI(dt)
	if not isHoldingGun() then
		return
	end
	
	drawWeaponSelection()
	drawAmmoCount()
end

function drawAmmoCount()
	if infiniteAmmo and infiniteMag then
		return
	end
	
	UiPush()
		UiAlign("center bottom")
		UiTranslate(UiWidth() * 0.5, UiHeight() * 0.95)
		UiTranslate(0, 25)
		UiFont("regular.ttf", 26)
		UiTextShadow(0, 0, 0, 0.5, 2.0)
		UiText(getMagCount() .. " / " .. getAmmoCount())
	UiPop()
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
		UiAlign("center middle")
		local yPosAdd = 0
		
		if infiniteAmmo and infiniteMag then
			yPosAdd = 0.02
		end
		
		UiTranslate(UiWidth() * 0.5, UiHeight() * (0.93 + yPosAdd))
		
		UiTranslate(0, -45)
		
		UiFont("regular.ttf", 26)
		UiTextShadow(0, 0, 0, 0.5, 2.0)
		
		UiPush()
			local textDist = 60
			UiAlign("right middle")
			UiTranslate(-textDist, 0)
			
			UiText(prevWeaponName)
			
			UiAlign("center middle")
			UiTranslate(textDist, 0)
			
			UiText(" < [" .. binds["Prev_Weapon"]:upper() .. "] - [" .. binds["Next_Weapon"]:upper() .. "] > ")
			
			UiAlign("left middle")
			UiTranslate(textDist, 0)
			
			UiText(nextWeaponName)
			
		UiPop()
		
		UiTranslate(0, 25)
		
		UiText(currWeaponName)
		
		UiTranslate(0, 25)
		
		UiText("[" .. binds["Open_Menu"]:upper() .. "] Moddy Menu")
	UiPop()
end

-- Creation Functions

function createColorTable()
	return {lineColorRed, lineColorGreen, lineColorBlue, lineColorAlpha}
end

function createProjectileBullet(startPos, direction)
	local firedProjectile = deepcopy(bulletProjectileClass)
	
	firedProjectile.bulletSettingsIndex = currentSelectedWeapon
	firedProjectile.lifetime = maxDistance
	firedProjectile.bulletHealth = bulletHealth
	firedProjectile.currentPos = startPos
	firedProjectile.direction = direction
	firedProjectile.velocity = projectileBulletSpeed
	firedProjectile.speed = projectileBulletSpeed
	firedProjectile.incendiary = incendiaryBullets
	firedProjectile.explosive = explosiveBullets
	firedProjectile.infinitePenetration = infinitePenetration
	firedProjectile.explosiveSize = math.random(explosiveBulletMinSize * 100, explosiveBulletMaxSize * 100) / 100
	firedProjectile.softRadius = math.random(softRadiusMin, softRadiusMax) / 10
	firedProjectile.mediumRadius = math.random(mediumRadiusMin, mediumRadiusMax) / 10
	firedProjectile.hardRadius = math.random(hardRadiusMin, hardRadiusMax) / 10
	firedProjectile.drawLine = drawProjectileLine
	firedProjectile.projectileGravity = projectileGravity
	firedProjectile.projectileBouncyness = projectileBouncyness
	firedProjectile.finalHitDmgMultiplier = finalHitDmgMultiplier
	firedProjectile.lineColor = createColorTable()
	firedProjectile.finalHitExplosion = finalHitExplosion
	firedProjectile.laserSeeker = laserSeeker
	firedProjectile.laserSeekerTurnSpeed = laserSeekerTurnSpeed
	
	if targetSeeker then
		if targetSeekerOffset then
			local shapeTransform = GetShapeWorldTransform(laserTargetShape)
			
			firedProjectile.laserSeekerOffset = TransformToLocalPoint(shapeTransform, laserEndPoint)
		end
		
		firedProjectile.targetSeekerShape = laserTargetShape
	end
	
	return firedProjectile
end

function createFiredShot(startPos, points)
	local firedShot = deepcopy(firedShotLineClass)
	
	firedShot.points[1] = startPos
	firedShot.lineColor = createColorTable()
	firedShot.startAlpha = firedShot.lineColor[4]
	
	
	for i = 1, #points do
		firedShot.points[i + 1] = points[i]
	end
	
	return firedShot
end

-- Object handlers

function projectileBounce(currBullet, normal)
	local bounceVel = nil
	local bounced = currBullet.projectileBouncyness > 0
	
	if bounced then
		local velocity = VecScale(VecCopy(currBullet.direction), currBullet.projectileBouncyness)
		local dot = VecDot(normal, velocity)
		
		bounceVel = VecSub(currBullet.direction, VecScale(normal, dot * 2))
	end
	
	return bounced, bounceVel
end

function handleAllProjectiles(dt)
	if #firedProjectiles <= 0 then
		return
	end
	
	for i = #firedProjectiles, 1, -1 do
		local currShot = firedProjectiles[i]
		
		local currPos = currShot.currentPos
		
		local currLaserEndPoint = getLaserEndPoint(currShot)
		
		if currLaserEndPoint == "end" then
			currShot.lifetime = 0
		elseif currLaserEndPoint ~= nil then
			local dirFromShotToEnd = VecDir(currPos, currLaserEndPoint)
			
			local newDir = VecLerp(currShot.direction, dirFromShotToEnd, currShot.laserSeekerTurnSpeed * dt)
			
			currShot.direction = newDir
		end
		
		local currMovement = VecScale(currShot.direction, currShot.velocity)
		
		local nextPos = VecAdd(currPos, VecScale(currMovement, dt * 10))
		
		if currShot.projectileGravity ~= 0 then
			currShot.direction = VecAdd(currShot.direction, Vec(0, currShot.projectileGravity * dt, 0))
		end
		
		local directionToNextPos = VecNormalize(currMovement)
		
		local distanceTraveled = VecDist(currPos, nextPos)
		
		local holeMade = false
		if currShot.infinitePenetration then
			local playerPos = GetPlayerTransform().pos
			
			--[[DebugWatch("currPos", currPos)
			DebugWatch("playerPos", playerPos)
			DebugWatch("dist", VecDist(currPos, playerPos))
			DebugWatch("minDist", currShot.explosiveSize * minExplosiveDistanceMultiplier)
			DebugWatch("velocity", math.abs(10 - distanceTraveled))--]]--
			
			if currShot.drawLine then
				c_DrawLine(currPos, nextPos, currShot.lineColor)
			end
			
			if (currShot.explosive and (VecDist(currPos, playerPos) > currShot.explosiveSize * minExplosiveDistanceMultiplier + math.abs(10 - distanceTraveled) or not smartExplosiveBullets)) or not currShot.explosive then
				for i = 0, distanceTraveled, infinitePenetrationHitScanDamageStep do
					local damageStepPos = VecAdd(currPos, VecScale(directionToNextPos, i))
					doBulletHoleAt(currShot, damageStepPos, VecDir(damageStepPos, playerPos), false, false)
					
					local currProjectileParticleSettings = GetProjectileSettingsByIndex(currShot.bulletSettingsIndex, "projectileParticleSettings")
					
					if currProjectileParticleSettings["enabled"] then
						setupParticleFromSettings(currProjectileParticleSettings)
						SpawnParticle(damageStepPos, VecDir(damageStepPos, nextPos), currProjectileParticleSettings["lifetime"])
					end
				end
			end
		else
			local hit, hitPoint, distance, normal, shape = raycast(currPos, directionToNextPos, distanceTraveled)
			
			if hit then
				local bulletDamage = getBulletDamage(shape, hitPoint)
				
				if applyForceOnHit then
					applyForceToHitObject(shape, hitPoint, directionToNextPos)
				end
				
				if currShot.drawLine then
					c_DrawLine(currPos, nextPos, currShot.lineColor)
				end
				
				currShot.bulletHealth = currShot.bulletHealth - bulletDamage
				
				doBulletHoleAt(currShot, hitPoint, normal, true, currShot.bulletHealth <= 0)
				
				if currShot.bulletHealth < 0 then
					holeMade = true
				else
					local bounced, bounceVel = projectileBounce(currShot, normal)
					
					if bounced then
						currShot.direction = bounceVel
						hitPoint = VecAdd(hitPoint, VecScale(normal, 0.05))
					end
					
					nextPos = hitPoint
					distanceTraveled = VecDist(currPos, nextPos)
				end
			else
				local currProjectileParticleSettings = GetProjectileSettingsByIndex(currShot.bulletSettingsIndex, "projectileParticleSettings")
			
				if currProjectileParticleSettings["enabled"] then
					setupParticleFromSettings(currProjectileParticleSettings)
					SpawnParticle(currPos, directionToNextPos, currProjectileParticleSettings["lifetime"])
				end
				
				if currShot.drawLine then
					c_DrawLine(currPos, nextPos, currShot.lineColor)
				end
			end
			
			local currProjectileParticleSettings = GetProjectileSettingsByIndex(currShot.bulletSettingsIndex, "projectileParticleSettings")
			
			if currProjectileParticleSettings["enabled"] then
				setupParticleFromSettings(currProjectileParticleSettings)
				for i = 0, distanceTraveled, infinitePenetrationHitScanDamageStep do
					local damageStepPos = VecAdd(currPos, VecScale(directionToNextPos, i))
					SpawnParticle(damageStepPos, VecDir(damageStepPos, nextPos), currProjectileParticleSettings["lifetime"])
				end
			end
		end
		
		currShot.currentPos = nextPos
		
		currShot.lifetime = currShot.lifetime - distanceTraveled

		if currShot.lifetime <= 0 or holeMade then
			if not holeMade and not currShot.infinitePenetration then
				doBulletHoleAt(currShot, currPos, VecDir(currPos, GetPlayerTransform().pos), false, true)
			end
			
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
			local lineColorAlpha = currShot.lifetime / firedShotLineClass.lifetime * currShot.startAlpha
			for j = 1, #currShot.points - 1 do
				local pointA = currShot.points[j]
				local pointB = currShot.points[j + 1]
				
				currShot.lineColor[4] = lineColorAlpha
				
				c_DrawLine(pointA, pointB, currShot.lineColor)
			end
		end
	end
end

function handleBurstFire()
	if burstFireMax > 0 and burstFire < burstFireMax and not isFiringGun() then
		burstFire = burstFireMax
	end
end

function handleWarmup(dt)
	if warmupTime >= warmupTimeMax and (not fullAuto and warmupSingleFireShot) then
		warmupTime = 0
	end
	
	if warmupTime < warmupTimeMax and isFiringGun() and not needsReload() then
		if soundEnabled then
			if warmupTime == 0 and sfx["warmup_start"] ~= nil then
				PlaySound(sfx["warmup_start"], GetPlayerTransform().pos)
			elseif sfx["warmup_loop"] ~= nil and warmupTime > sfxLength["warmup_start"] then
				PlayLoop(sfx["warmup_loop"], GetPlayerTransform().pos)
			end
		end
		
		warmupTime = warmupTime + dt
	elseif not isFiringGun() and (warmupSingleFireShot or warmupTime > 0) then
		if warmupWindDown and not needsReload() then
			warmupTime = warmupTime - dt
			warmupSingleFireShot = false
			
			if sfx["warmup_loop"] ~= nil and fireTime <= 0 and soundEnabled then
				PlayLoop(sfx["warmup_loop"], GetPlayerTransform().pos)
			end
			
			if warmupTime < 0 then
				warmupTime = 0
				if fireTime <= 0 and soundEnabled then
					PlaySound(sfx["warmup_stop"], GetPlayerTransform().pos)
				end
			end
		else
			warmupSingleFireShot = false
			warmupTime = 0
		end
	end
end

function handleFireTime(dt)
	if fullAuto and isFiringGun() and warmupTime >= warmupTimeMax and not needsReload() then
		fireTime = fireTime + dt
	else
		fireTime = 0
	end
end

-- Tool Functions

function GetCurrentSelectedWeaponIndex()
	return currentSelectedWeapon
end

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
	
	selectNewWeapon(newIndex)
end

function selectNewWeapon(newIndex)
	setMagCountInSettings(currentSelectedWeapon, currMag)
	setAmmoCountInSettings(currentSelectedWeapon, currAmmo)

	currentSelectedWeapon = newIndex
	
	name = GetNameByIndex(currentSelectedWeapon)
	ApplySettingsByIndex(currentSelectedWeapon)
end

function getAmmoCount()
	if infiniteAmmo then
		return 9999
	end

	return currAmmo
end

function getMagCount()
	if infiniteMag then
		return 9999
	end

	return currMag
end

function setAmmoCount(newCount)
	currAmmo = newCount
end

function addToAmmo(addedAmmo)
	currAmmo = currAmmo + addedAmmo
end

function subFromAmmo(removedAmmo)
	local currAmmoCount = getAmmoCount()
	local loadedAmmo = removedAmmo
	
	if removedAmmo > currAmmoCount then
		loadedAmmo = currAmmoCount
		currAmmoCount = 0
	else
		currAmmoCount = currAmmoCount - removedAmmo
	end
	
	if not infiniteAmmo then
		setAmmoCount(currAmmoCount)
	end
	
	return loadedAmmo
end

function isHoldingGun()
	return GetString("game.player.tool") == toolName and GetBool("game.player.canusetool")
end

function isFiringGun()
	local isHoldingGun = GetString("game.player.tool") == toolName
	local isFiringFullAuto = fullAuto and InputDown("usetool")
	local isFiringSingleFire = not fullAuto and ((InputPressed("usetool") and warmupTimeMax == 0) or (InputDown("usetool") and warmupTimeMax > 0 and not warmupSingleFireShot)) and burstFireMax <= 0
	local isBurstFiring = not fullAuto and InputDown("usetool") and burstFireMax > 0
	
	return (isFiringFullAuto or isFiringSingleFire or isBurstFiring) and isHoldingGun
end

function getLaserEndPoint(currShot)
	if currShot.targetSeekerShape > -1 then
		if currShot.laserSeekerOffset ~= nil then
			local shapeTransform = GetShapeWorldTransform(currShot.targetSeekerShape)
			
			return TransformToParentPoint(shapeTransform, currShot.laserSeekerOffset)
		end
		
		local sMin, sMax = GetShapeBounds(currShot.targetSeekerShape)
		local center = VecLerp(sMin, sMax, 0.5)
		
		--DebugWatch("currShot.currentPos", currShot.currentPos)
		--DebugWatch("center", center)
		--DebugWatch("dist", VecDist(currShot.currentPos, center))
		--DebugWatch("currShot.velocity * 2", currShot.velocity * 2)
		
		--[[if VecDist(currShot.currentPos, center) < currShot.velocity * 0.25 then
			return "end"
		end]]--
		
		return center
	elseif currShot.laserSeeker then
		return laserEndPoint
	end
	
	return nil
end

function hasChangedSettings()
	return currentSelectedWeapon ~= prevFrameSelectedWeapon
end

function isReadyToFire()
	local required = reloadTime <= 0 and currMag > 0 and currentShotCooldown <= 0 and not isMenuOpen()

	if burstFireMax > 0 then
		required = required and burstFire > 0
	end
	
	if warmupTimeMax > 0 then
		required = required and warmupTime > warmupTimeMax
		
		if not fullAuto and burstFireMax == 0 then
			required = required and not warmupSingleFireShot
		end
	end
	
	return required
end

function needsReload(dt)
	if currMag <= 0 then
		if additiveReload and not additiveReloading then
			reloadTime = maxReloadTime
			additiveReloading = true
		end
		
		return true
	end
	
	if reloadTime > 0 and not additiveReload then
		return true
	end
	
	if additiveReloading and isFiringGun() and currMag > 0 then
		additiveReloading = false
		reloadTime = 0
		
		return false
	end
	
	if additiveReloading then
		return true
	end
	
	if InputPressed(binds["Reload"]) then
		if additiveReload then
			if not additiveReloading then
				reloadTime = maxReloadTime
				additiveReloading = true
			end
		elseif not additiveReload then
			addToAmmo(currMag)
			
			currMag = 0
		end
		
		return true
	end
	
	return false
end

function bounceLaserTest()
	local cameraTransform = GetCameraTransform()
	
	local localShotDirection = Vec(0, 0, -1)
	
	local currShotDirection = VecDir(cameraTransform.pos, TransformToParentPoint(cameraTransform, localShotDirection))
	
	local pos = VecCopy(cameraTransform.pos)
	
	local distTraveled = 0
	
	local maxSteps = 100
	
	while distTraveled < maxDistance and maxSteps > 0 do
		maxSteps = maxSteps - 1
		local hit, hitPoint, distance, normal, shape = raycast(pos, currShotDirection, distanceLeft)
		
		distTraveled = distTraveled + VecDist(hitPoint, pos)
		
		DrawLine(pos, hitPoint, 1, 0, 0)
		
		currShotDirection = VecSub(currShotDirection, VecScale(normal, VecDot(normal, currShotDirection) * 2))
		pos = VecAdd(hitPoint, VecScale(normal, 0.01))
	end
end

function reloadLogic(dt)
	if additiveReload then
		if reloadTime > 0 and currMag < magSize and additiveReloading then
			reloadTime = reloadTime - dt
			
			local gunRot = QuatEuler(-30, 10, 20)
				
			SetToolTransform(Transform(Vec(0,0,0), gunRot))
			
			if reloadTime <= 0 and getAmmoCount() >= 1 then
				local loadedAmmo = subFromAmmo(1)
				currMag = currMag + loadedAmmo
				reloadTime = maxReloadTime
				if sfx["reload"] ~= nil and soundEnabled then
					PlaySound(sfx["reload"], GetPlayerTransform().pos)
				end
				
				local gunRot = QuatEuler(-25, 10, 20)
				
				SetToolTransform(Transform(Vec(0,0,0), gunRot))
			end
			
			if currMag >= magSize or getAmmoCount() <= 0  then
				additiveReloading = false
				reloadTime = 0
			end
		end
	else
		if reloadTime > 0 then
			reloadTime = reloadTime - dt
			
			if reloadTime <= 0 then
				reloadTime = 0
				finishReload()
			else
				local gunRot = QuatEuler(-30, 10, 20)
				
				SetToolTransform(Transform(Vec(0,0,0), gunRot))
			end
		elseif currMag <= 0 then
			reloadTime = maxReloadTime
			if sfx["reload"] ~= nil and soundEnabled then
				PlaySound(sfx["reload"], GetPlayerTransform().pos)
			end
		end
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

function setupParticleLerpSetting(settings, callback)
	if not settings[1] then
		return
	end
	
	if settings[2] == settings[3] then
		callback(settings[2])
	else
		local interpolationMethod = interpolationMethods[settings[4]]:lower()
	
		callback(settings[2], settings[3], interpolationMethod, settings[5], settings[6])
	end
end

function setupParticleFromSettings(settings)
	ParticleReset()
	
	ParticleType(particleTypes[settings["ParticleType"]]:lower())
	ParticleTile(settings["ParticleTile"])
	
	local particleColorSettings = settings["ParticleColor"]
	
	if particleColorSettings[1] == particleColorSettings[4] and 
	   particleColorSettings[2] == particleColorSettings[5] and 
	   particleColorSettings[3] == particleColorSettings[6] then
		ParticleColor(particleColorSettings[1], particleColorSettings[2], particleColorSettings[3])
	else
		ParticleColor(particleColorSettings[1], particleColorSettings[2], particleColorSettings[3], 
					  particleColorSettings[4], particleColorSettings[5], particleColorSettings[6])
	end
	
	ParticleFlags(settings["flags"])
	
	setupParticleLerpSetting(settings["ParticleRadius"], ParticleRadius)
	setupParticleLerpSetting(settings["ParticleAlpha"], ParticleAlpha)
	setupParticleLerpSetting(settings["ParticleGravity"], ParticleGravity)
	setupParticleLerpSetting(settings["ParticleDrag"], ParticleDrag)
	setupParticleLerpSetting(settings["ParticleEmissive"], ParticleEmissive)
	setupParticleLerpSetting(settings["ParticleRotation"], ParticleRotation)
	setupParticleLerpSetting(settings["ParticleStretch"], ParticleStretch)
	setupParticleLerpSetting(settings["ParticleSticky"], ParticleSticky)
	setupParticleLerpSetting(settings["ParticleCollide"], ParticleCollide)
end

function setupHitParticle()
	setupParticleFromSettings(hitParticleSettings)
end

function setupShotSmokeParticle()
	setupParticleFromSettings(shotSmokeParticleSettings)
end

function setupShotFireParticle()
	setupParticleFromSettings(shotFireParticleSettings)
end

-- Action functions

function GenerateRandomSpread()
	local index = math.random(0, 360)
	local endPos = posAroundCircle(index, 360, Vec(0, 0, 0), spread)

	--[[local xSpread = math.random(-spread * 100, spread * 100) / 100
	local ySpread = math.random(-spread * 100, spread * 100) / 100]]--
	
	local xSpread = endPos[1] * math.random(minXSpread, maxXSpread) / 10
	local ySpread = endPos[3] * math.random(minYSpread, maxYSpread) / 10
	
	return Vec(xSpread, ySpread, 0)
end

function GenerateBulletTrajectory(laser)
	laser = laser or false

	local gunBody = GetToolBody()
	local gunTransform = GetBodyTransform(gunBody)
	
	local gunWidth = 0.5
	local gunHeight = -0.15
	local gunLength = -1.5
	
	local gunFrontPos = TransformToParentPoint(gunTransform, Vec(gunWidth, gunHeight, gunLength))
	local gunFrontPosForward = TransformToParentPoint(gunTransform, Vec(gunWidth, gunHeight, gunLength - 1))
	
	local gunFrontDir = VecDir(gunFrontPos, gunFrontPosForward)
	
	local cameraTransform = GetCameraTransform()
	
	local localShotDirection = Vec(0, 0, -1)
	local spreadVec = GenerateRandomSpread()
	
	if not laser then
		localShotDirection = VecAdd(localShotDirection, spreadVec)
	end
	
	local shotDirection = VecDir(cameraTransform.pos, TransformToParentPoint(cameraTransform, localShotDirection))
	
	return gunFrontPos, gunFrontDir, cameraTransform.pos, shotDirection
end

function fakeHitScanBullet()--pos, dir)
	local newBullet = createProjectileBullet(Vec(0, 0, 0), Vec(0, 0, 0))

	return newBullet
end

function applyForceToHitObject(shape, hitPoint, shotDirection)
	local shapeBody = GetShapeBody(shape)
	
	ApplyBodyImpulse(shapeBody, hitPoint, VecScale(shotDirection, hitForce))
end

function getBulletDamage(shape, hitPoint)
	local mat = GetShapeMaterialAtPosition(shape, hitPoint)
	local bulletDamage = 1
	
	if mat == "concrete" or mat == "brick" or mat == "weakmetal" then
		bulletDamage = 2
	elseif mat == "hardmetal" or mat == "hardmasonry" then
		bulletDamage = 3
	end
	
	
	
	return bulletDamage
end

function doBulletHoleAt(bullet, hitPoint, normal, hitParticles, finalhit)
	local currHitParticleSettings = GetProjectileSettingsByIndex(bullet.bulletSettingsIndex, "hitParticleSettings")

	if currHitParticleSettings["enabled"] and hitParticles then
		setupParticleFromSettings(currHitParticleSettings)
		SpawnParticle(hitPoint, normal, currHitParticleSettings["lifetime"])
	end
	
	if bullet.incendiary then
		SpawnFire(hitPoint)
	end
	
	if bullet.explosive then
		if finalhit then
			Explosion(hitPoint, bullet.explosiveSize * bullet.finalHitDmgMultiplier)
		else
			Explosion(hitPoint, bullet.explosiveSize)
		end
	else
		local softRadius = bullet.softRadius
		local mediumRadius = bullet.mediumRadius
		local hardRadius = bullet.hardRadius
		local bulletFinalHitDmgMultiplier = bullet.finalHitDmgMultiplier
		
		if finalhit then
			if bullet.finalHitExplosion then
				Explosion(hitPoint, bullet.explosiveSize * bullet.finalHitDmgMultiplier)
				return
			else
				softRadius = softRadius * bulletFinalHitDmgMultiplier
				mediumRadius = mediumRadius * bulletFinalHitDmgMultiplier
				hardRadius = hardRadius * bulletFinalHitDmgMultiplier
			end
		end
		
		MakeHole(hitPoint, softRadius, mediumRadius, hardRadius)
	end
end

--[[function doHitScanSecondHit(fakeBullet, currBulletHealth, distanceLeft, hitPoints)
	local currShotDirection = VecDir(fakeBullet.currentPos, fakeBullet.velocity)
				
	local hit, hitPoint, distance, normal, shape = raycast(fakeBullet.currentPos, currShotDirection, distanceLeft)
	
	if not hit or distanceLeft < 0 then
		currBulletHealth = 0
		hitPoints[#hitPoints + 1] =  VecAdd(fakeBullet.currentPos, VecScale(currShotDirection, distanceLeft))
		return hit, currBulletHealth, distanceLeft
	end
	
	doBulletHoleAt(fakeBullet, hitPoint, normal, hit)
	
	local bounced, bounceVel = projectileBounce(fakeBullet, normal)
	
	DebugPrint(VecToString(fakeBullet.currentPos) .. " | " .. VecToString(fakeBullet.velocity))
			
	if bounced then
		fakeBullet.velocity = bounceVel
		fakeBullet.currentPos = VecAdd(hitPoint, VecScale(normal, 0.01))
	else
		fakeBullet.currentPos = hitPoint
	end
	
	DebugPrint(VecToString(fakeBullet.currentPos) .. " | " .. VecToString(fakeBullet.velocity))
	
	if applyForceOnHit and hit then
		applyForceToHitObject(shape, hitPoint, currShotDirection)
	end
	
	local bulletDamage = getBulletDamage(shape, hitPoint)
	currBulletHealth = currBulletHealth - bulletDamage
	
	local distanceTraveled = VecDist(fakeBullet.currentPos, hitPoint)
	distanceLeft = distanceLeft - distanceTraveled
	
	hitPoints[#hitPoints + 1] = fakeBullet.currentPos
	
	return hit, currBulletHealth, distanceLeft
end

function doHitScanShot(shotStartPos, shotDirection, gunFrontPos)
	local hitPoints = { gunFrontPos }
	
	if infinitePenetration then
		local hitPoint = VecAdd(shotStartPos, VecScale(shotDirection, maxDistance))
		local normal = VecDir(hitPoint, shotStartPos)
	
		local fakeBullet = fakeHitScanBullet()
		
		local startIndex = 0
		
		if explosiveBullets then
			startIndex = infinitePenetrationHitScanStart + fakeBullet.explosiveSize * minExplosiveDistanceHitscanMultiplier
		end
		
		for i = startIndex, maxDistance, infinitePenetrationHitScanDamageStep do
			local currPos = VecAdd(shotStartPos, VecScale(shotDirection, i))
			
			doBulletHoleAt(fakeBullet, currPos, normal, i >= maxDistance)
			
			if projectileParticleSettings["enabled"] then
				setupParticleFromSettings(projectileParticleSettings)
				
				SpawnParticle(currPos, shotDirection, projectileParticleSettings["lifetime"])
			end
		end
		
		hitPoints[1] = VecAdd(shotStartPos, VecScale(shotDirection, maxDistance))
	else
		local fakeBullet = createProjectileBullet(shotStartPos, shotDirection)
		
		local hit, hitPoint, distance, normal, shape = raycast(shotStartPos, shotDirection, maxDistance)
	
		if hit and bulletHealth > 0 then
			local bulletDamage = getBulletDamage(shape, hitPoint)
			fakeBullet.bulletHealth = fakeBullet.bulletHealth - bulletDamage
			
			fakeBullet.currentPos = hitPoint
			
			hitPoints[#hitPoints + 1] = hitPoint
			
			local distanceTraveledFromStart = VecDist(shotStartPos, hitPoint)
			
			fakeBullet.lifetime = maxDistance - distanceTraveledFromStart
			
			doBulletHoleAt(fakeBullet, hitPoint, normal, hit)
			
			if applyForceOnHit and hit then
				applyForceToHitObject(shape, hitPoint, shotDirection)
			end
			
			local bounced, bounceVel = projectileBounce(fakeBullet, normal)
			
			DebugPrint(VecToString(fakeBullet.currentPos) .. " | " .. VecToString(fakeBullet.velocity))
			
			if bounced then
				fakeBullet.velocity = bounceVel
				fakeBullet.currentPos = VecAdd(hitPoint, VecScale(normal, 0.01))
			else
				fakeBullet.currentPos = hitPoint
			end
			
			DebugPrint(VecToString(fakeBullet.currentPos) .. " | " .. VecToString(fakeBullet.velocity))
			
			while fakeBullet.bulletHealth > 0 do
				local hit, newHealth, newDist = doHitScanSecondHit(fakeBullet, fakeBullet.bulletHealth, fakeBullet.lifetime, hitPoints)
				fakeBullet.bulletHealth = newHealth
				fakeBullet.lifetime = newDist
			end
		else
			hitPoints[2] = VecAdd(shotStartPos, VecScale(shotDirection, maxDistance))
			doBulletHoleAt(fakeHitScanBullet(), hitPoint, normal, hit)
		end
		
		DebugPrint(#hitPoints)
		
		if projectileParticleSettings["enabled"] then
			setupParticleFromSettings(projectileParticleSettings)
			
			for i = 1, #hitPoints - 1 do
				local pointA = hitPoints[i]
				local pointB = hitPoints[i + 1]
				
				local currPointDist = VecDist(pointA, pointB)
				local currDir = VecDir(pointA, pointB)
				
				for i = 0, currPointDist, hitscanParticleStep do
					local currentPos = VecAdd(pointA, VecScale(currDir, i))
					
					SpawnParticle(currentPos, currDir, projectileParticleSettings["lifetime"])
				end
			end
		end
	end
	
	return hitPoints
end]]--

function doHitScanShot(shotStartPos, shotDirection, gunFrontPos)
	local hit, hitPoint, distance, normal, shape = raycast(shotStartPos, shotDirection, maxDistance)
	
	if not hit then
		hitPoint = VecAdd(shotStartPos, VecScale(shotDirection, 500))
		normal = VecDir(hitPoint, shotStartPos)
	end
	
	local finalHitPoint = hitPoint
	
	if infinitePenetration then
		local fakeBullet = fakeHitScanBullet()
		
		local startIndex = 0
		
		if explosiveBullets then
			startIndex = infinitePenetrationHitScanStart + fakeBullet.explosiveSize * minExplosiveDistanceHitscanMultiplier
		end
		
		for i = startIndex, maxDistance, infinitePenetrationHitScanDamageStep do
			local currPos = VecAdd(shotStartPos, VecScale(shotDirection, i))
			
			doBulletHoleAt(fakeBullet, currPos, normal, i >= maxDistance, i / maxDistance >= 0.99)
			
			local currProjectileParticleSettings = GetProjectileSettingsByIndex(fakeBullet.bulletSettingsIndex, "projectileParticleSettings")
			
			if currProjectileParticleSettings["enabled"] then
				setupParticleFromSettings(currProjectileParticleSettings)
				
				SpawnParticle(currPos, shotDirection, currProjectileParticleSettings["lifetime"])
			end
		end
	else
		if hit and bulletHealth > 0 then
			local bulletDamage = getBulletDamage(shape, hitPoint)
			
			local fakeBullet = fakeHitScanBullet()
			
			local currBulletHealth = bulletHealth - bulletDamage
			
			doBulletHoleAt(fakeBullet, hitPoint, normal, hit, currBulletHealth <= 0)
			
			while currBulletHealth > 0 do
				local hit, hitPoint, distance, normal, shape = raycast(shotStartPos, shotDirection, maxDistance)
				
				if not hit then
					currBulletHealth = 0
					finalHitPoint = VecAdd(shotStartPos, VecScale(shotDirection, maxDistance))
					break
				end
				
				local bulletDamage = getBulletDamage(shape, hitPoint)
				
				currBulletHealth = currBulletHealth - bulletDamage
				
				doBulletHoleAt(fakeBullet, hitPoint, normal, hit, currBulletHealth <= 0)
				
				finalHitPoint = hitPoint
			end
		else
			doBulletHoleAt(fakeHitScanBullet(), hitPoint, normal, hit, true)
		end
		
		if projectileParticleSettings["enabled"] then
			setupParticleFromSettings(projectileParticleSettings)
			
			local finalHitDistance = VecDist(shotStartPos, finalHitPoint)
			
			for i = 0, finalHitDistance, hitscanParticleStep do
				local currentPos = VecAdd(shotStartPos, VecScale(shotDirection, i))
				
				SpawnParticle(currentPos, shotDirection, projectileParticleSettings["lifetime"])
			end
		end
	end
	
	if applyForceOnHit and hit then
		applyForceToHitObject(shape, hitPoint, shotDirection)
	end
		
	return { gunFrontPos, finalHitPoint }
end 

function shootLogic()
	currentShotCooldown = shotCooldownTime
	
	if not infiniteMag then
		currMag = currMag - 1
	end
	
	if burstFireMax > 0 then
		burstFire = burstFire - 1
	end
	
	if warmupTimeMax > 0 and not fullAuto then
		warmupSingleFireShot = true
	end
	
	for i = 1, projectiles do
		local gunFrontPos, gunFrontDir, shotStartPos, shotDirection = GenerateBulletTrajectory()
		
		local hitPoint = nil
		
		if hitscanBullets then
			hitPoints = doHitScanShot(shotStartPos, shotDirection, gunFrontPos)
		end
		
		if i == 1 then
			if shotSmokeParticleSettings["enabled"]  then
				setupShotSmokeParticle()
				SpawnParticle(gunFrontPos, gunFrontDir, shotSmokeParticleSettings["lifetime"])
			end
			
			if shotFireParticleSettings["enabled"] then
				setupShotFireParticle()
				SpawnParticle(gunFrontPos, VecScale(gunFrontDir, 5), shotFireParticleSettings["lifetime"])
			end
		end
		
		if hitscanBullets then
			if drawProjectileLine then
				local firedShot = createFiredShot(gunFrontPos, hitPoints)
				
				table.insert(firedShotLines, firedShot)
			end
		else
			local firedProjectile = createProjectileBullet(shotStartPos, shotDirection)
			
			table.insert(firedProjectiles, firedProjectile)
		end
	end
end

function shootingSoundLogic()
	if not soundEnabled then
		return
	end
	
	--[[if sfx["shot"] ~= nil and warmupTimeMax > 0 and warmupTime >= warmupTimeMax and isFiringGun() and isReadyToFire() then
		PlaySound(sfx["shot"], GetPlayerTransform().pos, math.random(7, 10) / 10)
		return
	end]]--
	
	if not isReadyToFire() and sfx["shot_loop"] == nil and warmupTimeMax <= 0 then
		return
	end
	
	if sfx["shot"] ~= nil and isFiringGun() and (warmupTimeMax <= 0 or (warmupTimeMax > 0 and warmupTime >= warmupTimeMax and warmupSingleFireShot)) then
		PlaySound(sfx["shot"], GetPlayerTransform().pos, math.random(7, 10) / 10)
		return
	end
	
	if not isFiringGun() or needsReload() then
		if fireTime > 0 and sfx["shot_stop"] ~= nil then
			PlaySound(sfx["shot_stop"], GetPlayerTransform().pos)
		end
		
		return
	end
	
	if warmupTimeMax > 0 and warmupTime < warmupTimeMax then
		return
	end

	if sfx["shot_start"] ~= nil and fireTime == 0 then
		PlaySound(sfx["shot_start"], GetPlayerTransform().pos)
	elseif sfx["shot_loop"] ~= nil and fireTime > sfxLength["shot_start"] then
		PlayLoop(sfx["shot_loop"], GetPlayerTransform().pos)
	end
end

-- Sprite Functions

-- UI Sound Functions

-- Misc Functions

function checkRandomValues()
	if minXSpread > maxXSpread then
		local backup = minXSpread
		minXSpread = maxXSpread
		maxXSpread = backup
	end
	
	if minYSpread > maxYSpread then
		local backup = minYSpread
		minYSpread = maxYSpread
		maxYSpread = backup
	end

	if explosiveBulletMinSize > explosiveBulletMaxSize then
		local backup = explosiveBulletMinSize
		explosiveBulletMinSize = explosiveBulletMaxSize
		explosiveBulletMaxSize = backup
	end

	if softRadiusMin > softRadiusMax then
		local backup = softRadiusMin
		softRadiusMin = softRadiusMax
		softRadiusMax = backup
	end

	if mediumRadiusMin > softRadiusMax then
		local backup = mediumRadiusMin
		mediumRadiusMin = softRadiusMax
		softRadiusMax = backup
	end

	if hardRadiusMin > hardRadiusMax then
		local backup = hardRadiusMin
		minRndhardRadiusMinSpread = hardRadiusMax
		hardRadiusMax = backup
	end
end

function c_DrawLine(from, to, color)
	DrawLine(from, to, color[1], color[2], color[3], color[4])
end