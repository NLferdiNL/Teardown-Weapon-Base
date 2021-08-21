#include "customlist.lua"
#include "datascripts/color4.lua"
#include "scripts/utils.lua"
#include "scripts/savedata.lua"
#include "scripts/ui.lua"
#include "scripts/menu.lua"
#include "datascripts/inputList.lua"

toolName = "moddyweapon"
toolReadableName = "Moddy Weapon"

-- TODO: Add custom gun saves

name = "Shotgun"
customProfile = false
additiveReload = true -- TODO: Add option to menu
additiveReloading = false
magSize = 30 -- TODO: Add option to menu
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
hitForce = 4000 -- TODO: Add option to menu
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
infinitePenetration = false
sfx = {}
sfxLength = {}
fireTime = 0
particlesEnabled = true

-- MISC/UNSORTED:
infinitePenetrationHitScanStart = 5
infinitePenetrationHitScanDamageStep = 0.2

-- CHEATS:

infiniteAmmo = false
infiniteMag = false
soundEnabled = true

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
	incendiary = false,
	explosive = false,
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
	firedProjectile.currentPos = startPos
	firedProjectile.lastPos = startPos
	firedProjectile.velocity = VecScale(direction, projectileBulletSpeed)
	firedProjectile.incendiary = incendiaryBullets
	firedProjectile.explosive = explosiveBullets
	firedProjectile.explosiveSize = math.random(explosiveBulletMinSize * 100, explosiveBulletMaxSize * 100) / 100
	firedProjectile.softRadius = math.random(softRadiusMin, softRadiusMax) / 10
	firedProjectile.mediumRadius = math.random(mediumRadiusMin, mediumRadiusMax) / 10
	firedProjectile.hardRadius = math.random(hardRadiusMin, hardRadiusMax) / 10
	
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
		
		local directionToNextPos = VecNormalize(currShot.velocity)
		
		local distanceTraveled = VecDist(currPos, nextPos)
		
		local holeMade = false
		
		if infinitePenetration then
			DrawLine(currPos, nextPos)
			for i = 0, distanceTraveled, infinitePenetrationHitScanDamageStep do
				local damageStepPos = VecAdd(currPos, VecScale(directionToNextPos, i))
				doBulletHoleAt(currShot, damageStepPos, VecDir(damageStepPos, GetPlayerTransform().pos), false)
			end
		else
			local hit, hitPoint, distance, normal, shape = raycast(currPos, directionToNextPos, distanceTraveled)
			
			if hit then
				doBulletHoleAt(currShot, hitPoint, normal, true)
				
				if applyForceOnHit then
					applyForceToHitObject(shape, hitPoint, directionToNextPos)
				end
				
				DrawLine(currPos, hitPoint)
				
				holeMade = true
			else
				DrawLine(currPos, nextPos)
			end
		end
		
		currShot.currentPos = nextPos
		
		currShot.lifetime = currShot.lifetime - distanceTraveled

		if currShot.lifetime <= 0 or (holeMade and not infinitePenetration) then
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
	ParticleTile(3)
	ParticleStretch(1, 0.3)
	ParticleColor(1, 0.75, 0.4, 0, 0, 0)
	ParticleRadius(0.4, 0.2, "smooth")
	ParticleEmissive(1, 0, "smooth")
	ParticleGravity(0)
	ParticleCollide(1)
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
	
	if infinitePenetration then
		local fakeBullet = fakeHitScanBullet()
		local startIndex = infinitePenetrationHitScanStart and explosiveBullets or 0
		
		for i = infinitePenetrationHitScanStart, maxDistance, infinitePenetrationHitScanDamageStep do
			local currPos = VecAdd(shotStartPos, VecScale(shotDirection, i))
			
			doBulletHoleAt(fakeBullet, currPos, normal, i >= maxDistance)
		end
	else
		doBulletHoleAt(fakeHitScanBullet(), hitPoint, normal, hit)
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
			if particlesEnabled then
				setupShotSmokeParticle()
				SpawnParticle(gunFrontPos, gunFrontDir, 3)
				setupShotFireParticle()
				SpawnParticle(gunFrontPos, gunFrontDir, 0.3)
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
