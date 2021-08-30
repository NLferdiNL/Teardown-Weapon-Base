#include "customlist.lua"
#include "datascripts/color4.lua"
#include "scripts/utils.lua"
#include "scripts/savedata.lua"
#include "scripts/ui.lua"
#include "scripts/menu.lua"
#include "datascripts/inputList.lua"

toolName = "moddyweapon"
toolReadableName = "Moddy Weapon"

-- TODO: Add bindables to mod menu.
-- TODO: Add sound editor
-- TODO: Finish particle editor: Particle Type
-- TODO: Add projectile bouncyness (velocity * normal * bouncyness)
-- TODO: Fix projectile particles going the wrong way.
-- TODO: Seperate X and Y spread for wide low spread

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
minRndSpread = 1
maxRndSpread = 10
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
sfx = {} -- TODO: Add option to menu
sfxLength = {}
fireTime = 0
drawProjectileLine = true

hitParticleSettings = {
	enabled = true,
	ParticleType = "smoke",
	ParticleTile = 0,
	lifetime = 5,
	ParticleColor = {1, 1, 1, 1, 1, 1},
	ParticleRadius = 	{ true, 0.5, 1, "linear", 0, 1},
	ParticleAlpha = 	{ false, 1, 1, "linear", 0, 1},
	ParticleGravity = 	{ false, 0, 0, "linear", 0, 1},
	ParticleDrag = 		{ false, 0, 0, "linear", 0, 1},
	ParticleEmissive = 	{ false, 0, 0, "linear", 0, 1},
	ParticleRotation = 	{ false, 0, 0, "linear", 0, 1},
	ParticleStretch = 	{ false, 0, 0, "linear", 0, 1},
	ParticleSticky = 	{ false, 0, 0, "linear", 0, 1},
	ParticleCollide = 	{ true, 1, 1, "linear", 0, 1},
}

shotSmokeParticleSettings = {
	enabled = true,
	ParticleType = "smoke",
	ParticleTile = 0,
	lifetime = 3,
	ParticleColor = {0, 1, 0, 1, 1, 1},
	ParticleRadius = 	{ true, 0.1, 0.3, "linear", 0, 1},
	ParticleAlpha = 	{ false, 1, 1, "linear", 0, 1},
	ParticleGravity = 	{ false, 0.4, 0.4, "linear", 0, 1},
	ParticleDrag = 		{ false, 0, 0, "linear", 0, 1},
	ParticleEmissive = 	{ false, 0, 0, "linear", 0, 1},
	ParticleRotation = 	{ false, 0, 0, "linear", 0, 1},
	ParticleStretch = 	{ false, 0, 0, "linear", 0, 1},
	ParticleSticky = 	{ false, 0, 0, "linear", 0, 1},
	ParticleCollide = 	{ true, 1, 1, "linear", 0, 1},
}

shotFireParticleSettings = {
	enabled = true,
	ParticleType = "plain",
	ParticleTile = 3,
	lifetime = 0.5,
	ParticleColor = {0, 1, 0, 1, 1, 1},
	ParticleRadius = 	{ true, 0.4, 0.2, "smooth", 0, 1},
	ParticleAlpha = 	{ false, 1, 1, "linear", 0, 1},
	ParticleGravity = 	{ false, 0, 0, "linear", 0, 1},
	ParticleDrag = 		{ false, 0, 0, "linear", 0, 1},
	ParticleEmissive = 	{ true, 1, 0, "smooth", 0, 1},
	ParticleRotation = 	{ false, 0, 0, "linear", 0, 1},
	ParticleStretch = 	{ true, 1, 0.3, "linear", 0, 1},
	ParticleSticky = 	{ false, 0, 0, "linear", 0, 1},
	ParticleCollide = 	{ true, 1, 1, "linear", 0, 1},
}

projectileParticleSettings = {
	enabled = true,
	ParticleType = "smoke",
	ParticleTile = 0,
	lifetime = 3,
	ParticleColor = {0, 1, 1, 1, 1, 1},
	ParticleRadius = 	{ true, 0.1, 0.1, "linear", 0, 1},
	ParticleAlpha = 	{ false, 1, 1, "linear", 0, 1},
	ParticleGravity = 	{ false, 1, 1, "linear", 0, 1},
	ParticleDrag = 		{ false, 0, 0, "linear", 0, 1},
	ParticleEmissive = 	{ false, 0, 0, "linear", 0, 1},
	ParticleRotation = 	{ false, 0, 0, "linear", 0, 1},
	ParticleStretch = 	{ false, 0, 0, "linear", 0, 1},
	ParticleSticky = 	{ false, 0, 0, "linear", 0, 1},
	ParticleCollide = 	{ true, 1, 1, "linear", 0, 1},
}

--[[
exampleParticle = {
	enabled = true,
	ParticleType = "smoke",
	ParticleTile = 0,
	lifetime = 3,
	ParticleColor = {0.25, 0.25, 0.25, 1, 1, 1},
	ParticleRadius = 	{ true, 0.5, 1, "linear", 0, 1},
	ParticleAlpha = 	{ false, 1, 1, "linear", 0, 1},
	ParticleGravity = 	{ true, 1, 1, "linear", 0, 1},
	ParticleDrag = 		{ false, 0, 0, "linear", 0, 1},
	ParticleEmissive = 	{ false, 0, 0, "linear", 0, 1},
	ParticleRotation = 	{ false, 0, 0, "linear", 0, 1},
	ParticleStretch = 	{ false, 0, 0, "linear", 0, 1},
	ParticleSticky = 	{ false, 0, 0, "linear", 0, 1},
	ParticleCollide = 	{ true, 1, 1, "linear", 0, 1},
}--]]--

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

interpolationMethods = { "Linear", "Smooth", "Easein", "Easeout", "Constant" }

local firedShotLineClass = {
	lifetime = 0.4,
	startPos = nil,
	endPos = nil,
}

local bulletProjectileClass = {
	drawLine = true,
	lifetime = maxDistance,
	bulletHealth = 0,
	currentPos = nil,
	velocity = nil,
	incendiary = false,
	explosive = false,
	infinitePenetration = false,
	explosiveSize = 0.5,
	softRadius = 0,
	mediumRadius = 0,
	hardRadius = 0,
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
	
	RegisterTool(toolName, "Moddy Weapon", "MOD/vox/tool.vox")
	SetBool("game.tool." .. toolName .. ".enabled", true)
end

function tick(dt)
	if hasQuickLoaded() then
		saveFileInit()
	end

	menu_tick(dt)
	
	--[[
	local currPart = getCurrentParticle()
	
	DebugWatch("enabled", currPart.enabled)
	DebugWatch("ParticleType", currPart.ParticleType)
	DebugWatch("ParticleTile", currPart.ParticleTile)
	DebugWatch("lifetime", currPart.lifetime)
	DebugWatch("ParticleColor", tableToText(currPart.ParticleColor, true, false, false))
	DebugWatch("ParticleRadius", tableToText(currPart.ParticleRadius, true, false, false))
	DebugWatch("ParticleAlpha", tableToText(currPart.ParticleAlpha, true, false, false))
	DebugWatch("ParticleGravity", tableToText(currPart.ParticleGravity, true, false, false))
	DebugWatch("ParticleDrag", tableToText(currPart.ParticleDrag, true, false, false))
	DebugWatch("ParticleEmissive", tableToText(currPart.ParticleEmissive, true, false, false))
	DebugWatch("ParticleRotation", tableToText(currPart.ParticleRotation, true, false, false))
	DebugWatch("ParticleStretch", tableToText(currPart.ParticleStretch, true, false, false))
	DebugWatch("ParticleSticky", tableToText(currPart.ParticleSticky, true, false, false))
	DebugWatch("ParticleCollide", tableToText(currPart.ParticleCollide, true, false, false))--]]--
	
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
	
	if isMenuOpen() then
		return
	end
	
	weaponTypeSelectionHandler()
	
	shootingSoundLogic()
	handleFireTime(dt)
	handleWarmup(dt)
	
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
		UiAlign("center bottom")
		local yPosAdd = 0
		
		if infiniteAmmo and infiniteMag then
			yPosAdd = 0.02
		end
		
		UiTranslate(UiWidth() * 0.5, UiHeight() * (0.93 + yPosAdd))
		UiFont("regular.ttf", 26)
		UiTextShadow(0, 0, 0, 0.5, 2.0)
		
		UiText("[" .. binds["Prev_Weapon"]:upper() .. "] " .. prevWeaponName .. " | " .. currWeaponName .. " | [" .. binds["Next_Weapon"]:upper() .. "] " .. nextWeaponName)
		
		UiTranslate(0, 25)
		
		UiText("[" .. binds["Open_Menu"]:upper() .. "] Moddy Menu")
	UiPop()
end

-- Creation Functions

function createProjectileBullet(startPos, direction)
	local firedProjectile = deepcopy(bulletProjectileClass)
	
	firedProjectile.lifetime = maxDistance
	firedProjectile.bulletHealth = bulletHealth
	firedProjectile.currentPos = startPos
	firedProjectile.velocity = VecScale(direction, projectileBulletSpeed)
	firedProjectile.incendiary = incendiaryBullets
	firedProjectile.explosive = explosiveBullets
	firedProjectile.infinitePenetration = infinitePenetration
	firedProjectile.explosiveSize = math.random(explosiveBulletMinSize * 100, explosiveBulletMaxSize * 100) / 100
	firedProjectile.softRadius = math.random(softRadiusMin, softRadiusMax) / 10
	firedProjectile.mediumRadius = math.random(mediumRadiusMin, mediumRadiusMax) / 10
	firedProjectile.hardRadius = math.random(hardRadiusMin, hardRadiusMax) / 10
	firedProjectile.drawLine = drawProjectileLine
	
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
		
		local nextPos = VecAdd(currPos, VecScale(currShot.velocity, dt * 10))
		
		if projectileGravity ~= 0 then
			currShot.velocity = VecAdd(currShot.velocity, Vec(0, projectileGravity * dt, 0))
		end
		
		local directionToNextPos = VecNormalize(currShot.velocity)
		
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
				DrawLine(currPos, nextPos)
			end
			
			if (currShot.explosive and (VecDist(currPos, playerPos) > currShot.explosiveSize * minExplosiveDistanceMultiplier + math.abs(10 - distanceTraveled) or not smartExplosiveBullets)) or not currShot.explosive then
				for i = 0, distanceTraveled, infinitePenetrationHitScanDamageStep do
					local damageStepPos = VecAdd(currPos, VecScale(directionToNextPos, i))
					doBulletHoleAt(currShot, damageStepPos, VecDir(damageStepPos, playerPos), false)
					if projectileParticleSettings["enabled"] then
						setupParticleFromSettings(projectileParticleSettings)
						SpawnParticle(currPos, VecDir(currPos, damageStepPos), projectileParticleSettings["lifetime"])
					end
				end
			end
		else
			local hit, hitPoint, distance, normal, shape = raycast(currPos, directionToNextPos, distanceTraveled)
			
			if hit then
				local bulletDamage = getBulletDamage(shape, hitPoint)
				doBulletHoleAt(currShot, hitPoint, normal, true)
				
				if applyForceOnHit then
					applyForceToHitObject(shape, hitPoint, directionToNextPos)
				end
				
				if currShot.drawLine then
					DrawLine(currPos, hitPoint)
				end
				
				currShot.bulletHealth = currShot.bulletHealth - bulletDamage
				
				if currShot.bulletHealth < 0 then
					holeMade = true
				else
					nextPos = hitPoint
					distanceTraveled = VecDist(currPos, nextPos)
				end
			else
				if projectileParticleSettings["enabled"] then
					setupParticleFromSettings(projectileParticleSettings)
					SpawnParticle(currPos, directionToNextPos, projectileParticleSettings["lifetime"])
				end
				
				if currShot.drawLine then
					DrawLine(currPos, nextPos)
				end
			end
		end
		
		currShot.currentPos = nextPos
		
		currShot.lifetime = currShot.lifetime - distanceTraveled

		if currShot.lifetime <= 0 or holeMade then
			if not holeMade and not currShot.infinitePenetration then
				doBulletHoleAt(currShot, currPos, VecDir(currPos, GetPlayerTransform().pos), false)
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
	
	ParticleType(settings["ParticleType"])
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
	
	local xSpread = endPos[1] * (math.random(minRndSpread, maxRndSpread) / 10)
	local ySpread = endPos[3] * (math.random(minRndSpread, maxRndSpread) / 10)
	
	return Vec(xSpread, ySpread, 0)
end

function GenerateBulletTrajectory()
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

function doBulletHoleAt(bullet, hitPoint, normal, hitParticles)
	if hitParticleSettings["enabled"] and hitParticles then
		setupHitParticle()
		SpawnParticle(hitPoint, normal, hitParticleSettings["lifetime"])
	end
	
	if bullet.incendiary then
		SpawnFire(hitPoint)
	end
	
	if bullet.explosive then
		Explosion(hitPoint, bullet.explosiveSize)
	else
		local softRadius = bullet.softRadius
		local mediumRadius = bullet.mediumRadius
		local hardRadius = bullet.hardRadius
	
		MakeHole(hitPoint, softRadius, mediumRadius, hardRadius)
	end
end

function doHitScanShot(shotStartPos, shotDirection)
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
			
			doBulletHoleAt(fakeBullet, currPos, normal, i >= maxDistance)
			
			if projectileParticleSettings["enabled"] then
				setupParticleFromSettings(projectileParticleSettings)
				
				SpawnParticle(currPos, shotDirection, projectileParticleSettings["lifetime"])
			end
		end
	else
		if hit and bulletHealth > 0 then
			local bulletDamage = getBulletDamage(shape, hitPoint)
			
			local fakeBullet = fakeHitScanBullet()
			
			local currBulletHealth = bulletHealth - bulletDamage
			
			doBulletHoleAt(fakeBullet, hitPoint, normal, hit)
			
			while currBulletHealth > 0 do
				local hit, hitPoint, distance, normal, shape = raycast(shotStartPos, shotDirection, maxDistance)
				
				if not hit then
					currBulletHealth = 0
					break
				end
				
				doBulletHoleAt(fakeBullet, hitPoint, normal, hit)
				
				local bulletDamage = getBulletDamage(shape, hitPoint)
				
				currBulletHealth = currBulletHealth - bulletDamage
				
				finalHitPoint = hitPoint
			end
		else
			doBulletHoleAt(fakeHitScanBullet(), hitPoint, normal, hit)
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
	
	if warmupTimeMax > 0 and not fullAuto then
		warmupSingleFireShot = true
	end
	
	for i = 1, projectiles do
		local gunFrontPos, gunFrontDir, shotStartPos, shotDirection = GenerateBulletTrajectory()
		
		local hitPoint = nil
		
		if hitscanBullets then
			hitPoint = doHitScanShot(shotStartPos, shotDirection)
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
				local firedShot = createFiredShot(gunFrontPos, hitPoint)
				
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
	if minRndSpread > maxRndSpread then
		local backup = minRndSpread
		minRndSpread = maxRndSpread
		maxRndSpread = backup
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
