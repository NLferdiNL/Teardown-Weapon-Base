#include "scripts/utils.lua"
#include "custom/blankProfile.lua"
#include "custom/list.lua"

local customList = getCustomList()
local customListDefaultCount = getCustomListDefaultCountFromListFile()

local loadedSfx = {}

--local customList_backup = deepcopy(customList)

function GetSettingsByIndex(index)
	if index == nil then
		return nil
	end
	
	if index < 1 or index > #customList then
		return nil
	end
	
	local settings = customList[index]
	
	local sfx = {}
	
	for key, path in pairs(settings.sfx) do
		local handle = nil
		if loadedSfx[path] ~= nil then
			handle = loadedSfx[path]
		else
			if string.find(key, "loop") ~= nil then
				handle = LoadLoop(path)
			else
				handle = LoadSound(path)
			end
			loadedSfx[path] = handle
		end
		
		sfx[key] = handle
	end
	
	return settings, sfx
end

function GetNameByIndex(index)
	if index == nil then
		return nil
	end
	
	local settings = GetSettingsByIndex(index)
	
	if settings == nil then
		return ""
	end
	
	return settings.name
end

function getAmmoCount(index)
	if index == nil then
		return nil
	end
	
	local settings = GetSettingsByIndex(index)
	
	return settings.currAmmo
end

function setAmmoCountInSettings(index, newCount)
	if index == nil or newCount == nil or newCount < 0 then
		return nil
	end
	
	GetSettingsByIndex(index).currAmmo = newCount
end

function setMagCountInSettings(index, newCount)
	if index == nil or newCount == nil or newCount < 0 then
		return nil
	end
	
	GetSettingsByIndex(index).currMag = newCount
end

function GetListCount()
	return #customList
end

function GetList()
	return customList
end

function CreateNewCustom(copyIndex)
	local newProfileObject
	
	if copyIndex == nil then
		newProfileObject = deepcopy(blankProfile)
	else
		newProfileObject = deepcopy(customList[copyIndex])
		
		newProfileObject.customProfile = true
		newProfileObject.name = newProfileObject.name .. " Copy"
	end
	
	customProfiles = customProfiles + 1
	
	customList[#customList + 1] = newProfileObject
end

function CreateNewCustomFromLoaded()
	local newProfileObject = deepcopy(blankProfile)
	local weaponIndex = GetCurrentSelectedWeaponIndex()
	local profileUnloadedData = GetSettingsByIndex(weaponIndex)
	
	loadSettingsToProfile(newProfileObject)
	
	newProfileObject.name = newProfileObject.name .. " Copy"
	newProfileObject.sfx = profileUnloadedData.sfx
	newProfileObject.sfxLength = profileUnloadedData.sfxLength
	
	customProfiles = customProfiles + 1
	
	customList[#customList + 1] = newProfileObject
end

function EditCustomName(index, name)
	if not customList[index].customProfile then
		return
	end
	customList[index].name = name
end

function CopySFXDataTo(fromIndex, toIndex)
	local fromData = GetSettingsByIndex(fromIndex)
	local toData = GetSettingsByIndex(toIndex)
	
	if not toData.customProfile then
		return
	end
	
	toData.sfx = fromData.sfx
	toData.sfxLength = fromData.sfxLength
end

function DeleteCustom(index)
	if not customList[index].customProfile then
		return
	end
	
	customProfiles = customProfiles - 1
	
	table.remove(customList, index)
end

function GetCustomListDefaultCount()
	return customListDefaultCount
end

function ApplySettingsByIndex(index)
	local newSettings, newSfx = GetSettingsByIndex(index)
	
	if newSettings == nil then
		return
	end
	
	if newSettings.currAmmo == -1 then
		newSettings.currAmmo = newSettings.maxAmmo - newSettings.magSize
		newSettings.currMag = newSettings.magSize
	end
	
	name = newSettings.name
	customProfile = newSettings.customProfile
	additiveReload = newSettings.additiveReload
	additiveReloading = false
	magSize = newSettings.magSize
	currMag = newSettings.currMag
	maxAmmo = newSettings.maxAmmo
	currAmmo = newSettings.currAmmo
	spread = newSettings.spread
	projectiles = newSettings.projectiles
	shotCooldownTime = newSettings.shotCooldownTime
	currentShotCooldown = 0
	fullAuto = newSettings.fullAuto
	warmupTimeMax = newSettings.warmupTimeMax
	warmupTime = 0
	warmupWindDown = newSettings.warmupWindDown
	warmupSingleFireShot = false
	burstFireMax = newSettings.burstFireMax
	burstFire = burstFireMax
	maxReloadTime = newSettings.maxReloadTime
	reloadTime = 0
	minXSpread = newSettings.minXSpread
	maxXSpread = newSettings.maxXSpread
	minYSpread = newSettings.minYSpread
	maxYSpread = newSettings.maxYSpread
	maxDistance = newSettings.maxDistance
	hitForce = newSettings.hitForce
	hitscanBullets = newSettings.hitscanBullets
	incendiaryBullets = newSettings.incendiaryBullets
	explosiveBullets = newSettings.explosiveBullets
	explosiveBulletMinSize = newSettings.explosiveBulletMinSize
	explosiveBulletMaxSize = newSettings.explosiveBulletMaxSize
	projectileBulletSpeed = newSettings.projectileBulletSpeed
	applyForceOnHit = newSettings.applyForceOnHit
	softRadiusMin = newSettings.softRadiusMin
	softRadiusMax = newSettings.softRadiusMax
	mediumRadiusMin = newSettings.mediumRadiusMin
	mediumRadiusMax = newSettings.mediumRadiusMax
	hardRadiusMin = newSettings.hardRadiusMin
	hardRadiusMax = newSettings.hardRadiusMax
	sfx = newSfx
	sfxLength = newSettings.sfxLength
	infinitePenetration = newSettings.infinitePenetration
	--particlesEnabled = newSettings.particlesEnabled
	hitParticleSettings = deepcopy(newSettings.hitParticleSettings)
	shotSmokeParticleSettings = deepcopy(newSettings.shotSmokeParticleSettings)
	shotFireParticleSettings = deepcopy(newSettings.shotFireParticleSettings)
	projectileParticleSettings = deepcopy(newSettings.projectileParticleSettings)
	bulletHealth = newSettings.bulletHealth
	projectileGravity = newSettings.projectileGravity
	projectileBouncyness = newSettings.projectileBouncyness
	drawProjectileLine = newSettings.drawProjectileLine
	finalHitDmgMultiplier = newSettings.finalHitDmgMultiplier
	lineColorRed = newSettings.lineColorRed
	lineColorGreen = newSettings.lineColorGreen
	lineColorBlue = newSettings.lineColorBlue
	lineColorAlpha = newSettings.lineColorAlpha
	finalHitExplosion = newSettings.finalHitExplosion
	laserSeeker = newSettings.laserSeeker
	laserSeekerTurnSpeed = newSettings.laserSeekerTurnSpeed
end

function SaveSettingsToProfile(index)
	local newSettings, newSfx = GetSettingsByIndex(index)
	
	if newSettings == nil then
		return
	end
	
	if not newSettings.customProfile then
		return
	end
	
	loadSettingsToProfile(newSettings)
end

function loadSettingsToProfile(newSettings)
	if newSettings == nil then
		return
	end
	
	if not newSettings.customProfile then
		return
	end

	newSettings.name = name
	--customProfile = newSettings.customProfile
	newSettings.additiveReload = additiveReload
	newSettings.additiveReloading = false
	newSettings.magSize = magSize
	newSettings.maxAmmo = maxAmmo
	newSettings.spread = spread
	newSettings.projectiles = projectiles
	newSettings.shotCooldownTime = shotCooldownTime
	newSettings.fullAuto = fullAuto
	newSettings.warmupTimeMax = warmupTimeMax
	newSettings.warmupTime = 0
	newSettings.warmupWindDown = warmupWindDown
	newSettings.warmupSingleFireShot = false
	newSettings.burstFireMax = burstFireMax
	newSettings.burstFire = burstFireMax
	newSettings.maxReloadTime = maxReloadTime
	newSettings.minXSpread = minXSpread
	newSettings.maxXSpread = maxXSpread
	newSettings.minYSpread = minYSpread
	newSettings.maxYSpread = maxYSpread
	newSettings.maxDistance = maxDistance
	newSettings.hitForce = hitForce
	newSettings.hitscanBullets = hitscanBullets
	newSettings.incendiaryBullets = incendiaryBullets
	newSettings.explosiveBullets = explosiveBullets
	newSettings.explosiveBulletMinSize = explosiveBulletMinSize
	newSettings.explosiveBulletMaxSize = explosiveBulletMaxSize
	newSettings.projectileBulletSpeed = projectileBulletSpeed
	newSettings.applyForceOnHit = applyForceOnHit
	newSettings.softRadiusMin = softRadiusMin
	newSettings.softRadiusMax = softRadiusMax
	newSettings.mediumRadiusMin = mediumRadiusMin
	newSettings.mediumRadiusMax = mediumRadiusMax
	newSettings.hardRadiusMin = hardRadiusMin
	newSettings.hardRadiusMax = hardRadiusMax
	--sfx = newSfx
	--sfxLength = newSettings.sfxLength
	--newSettings.particlesEnabled = particlesEnabled
	newSettings.infinitePenetration = infinitePenetration
	newSettings.hitParticleSettings = deepcopy(hitParticleSettings)
	newSettings.shotSmokeParticleSettings = deepcopy(shotSmokeParticleSettings)
	newSettings.shotFireParticleSettings = deepcopy(shotFireParticleSettings)
	newSettings.projectileParticleSettings = deepcopy(projectileParticleSettings)
	newSettings.bulletHealth = bulletHealth
	newSettings.projectileGravity = projectileGravity
	newSettings.projectileBouncyness = projectileBouncyness
	newSettings.drawProjectileLine = drawProjectileLine
	newSettings.finalHitDmgMultiplier = finalHitDmgMultiplier
	newSettings.lineColorRed = lineColorRed
	newSettings.lineColorGreen = lineColorGreen
	newSettings.lineColorBlue = lineColorBlue
	newSettings.lineColorAlpha = lineColorAlpha
	newSettings.finalHitExplosion = finalHitExplosion
	newSettings.laserSeeker = laserSeeker
	newSettings.laserSeekerTurnSpeed = laserSeekerTurnSpeed
end

function checkSettingsUpToDate(settings)
	if settings["profileVersion"] == nil then
		return false
	end
	
	if settings["profileVersion"] < blankProfile["profileVersion"] then
		return false
	end
	
	return true
end

function updateSettings(settings)
	if settings["profileVersion"] == nil or settings["profileVersion"] <= 0 then -- Below version 1
		settings["profileVersion"] = 1
		
		settings["hitParticleSettings"] = deepcopy(blankProfile["hitParticleSettings"])
		settings["shotSmokeParticleSettings"] = deepcopy(blankProfile["shotSmokeParticleSettings"])
		settings["shotFireParticleSettings"] = deepcopy(blankProfile["shotFireParticleSettings"])
		settings["projectileParticleSettings"] = deepcopy(blankProfile["projectileParticleSettings"])
		
		if not settings["particlesEnabled"] then
			settings["hitParticleSettings"]["enabled"] = false
			settings["shotSmokeParticleSettings"]["enabled"] = false
			settings["shotFireParticleSettings"]["enabled"] = false
			settings["projectileParticleSettings"]["enabled"] = false
		end
		
		settings["particlesEnabled"] = nil
		
		settings["bulletHealth"] = 0
	end
	
	if settings["profileVersion"] < 3 then -- Below version 3
		settings["profileVersion"] = 3
		
		settings["projectileGravity"] = 0
		settings["drawProjectileLine"] = true
	end
	
	if settings["profileVersion"] < 4 then -- Below version 4
		settings["profileVersion"] = 4
		
		local particleSettingNames = {"ParticleRadius", "ParticleAlpha", "ParticleGravity", "ParticleDrag", "ParticleEmissive", "ParticleRotation", "ParticleStretch", "ParticleSticky", "ParticleCollide" } 
		
		local interpolationMethods = { linear = 1, smooth = 2, easein = 3, easeout = 4, constant = 5 }
		
		if type(settings["hitParticleSettings"][4]) == "string" then
			function updateInterpolation(setting)
				setting[4] = interpolationMethods[setting[4]]
			end
			
			function updateParticle(particle)
				for i = 1, #particleSettingNames do
					updateInterpolation(particle[particleSettingNames[i]])
				end
			end
			
			updateParticle(settings["hitParticleSettings"])
			updateParticle(settings["shotSmokeParticleSettings"])
			updateParticle(settings["shotFireParticleSettings"])
			updateParticle(settings["projectileParticleSettings"])
		end
	end
	
	if settings["profileVersion"] < 5 then -- Below version 5
		settings["profileVersion"] = 5
		
		if type(settings["hitParticleSettings"]["ParticleType"]) == "string" then
			local particleTypes = { smoke = 1, plain = 2, }
			
			function updateType(settings)
				settings["ParticleType"] = particleTypes[settings["ParticleType"]]
			end
			
			updateType(settings["hitParticleSettings"])
			updateType(settings["shotSmokeParticleSettings"])
			updateType(settings["shotFireParticleSettings"])
			updateType(settings["projectileParticleSettings"])
		end
	end
	
	if settings["profileVersion"] < 6 then -- Below version 6
		settings["profileVersion"] = 6
		settings["projectileBouncyness"] = 0
	end
	
	if settings["profileVersion"] < 7 then -- Below version 7
		settings["profileVersion"] = 7
		
		local minSpread = settings["minRndSpread"]
		local maxSpread = settings["maxRndSpread"]
		
		if minSpread > 10 then
			minSpread = 10
		end
		
		if maxSpread > 10 then
			maxSpread = 10
		end
		
		settings["minXSpread"] = minSpread
		settings["maxXSpread"] = maxSpread
		
		settings["minYSpread"] = minSpread
		settings["maxYSpread"] = maxSpread
		
		settings["minRndSpread"] = nil
		settings["maxRndSpread"] = nil
		
	end
	
	if settings["profileVersion"] < 8 then -- Below version 8
		settings["profileVersion"] = 8
		
		settings["finalHitDmgMultiplier"] = 1
	end
	
	if settings["profileVersion"] < 9 then -- Below version 9
		settings["profileVersion"] = 9
		
		settings["lineColorRed"] = 1
		settings["lineColorGreen"] = 1
		settings["lineColorBlue"] = 1
		settings["lineColorAlpha"] = 1
	end
	
	if settings["profileVersion"] < 10 then -- Below version 10
		settings["profileVersion"] = 10
		
		settings["hitParticleSettings"]["flags"] = 0
		settings["shotSmokeParticleSettings"]["flags"] = 0
		settings["shotFireParticleSettings"]["flags"] = 0
		settings["projectileParticleSettings"]["flags"] = 0
	end
	
	if settings["profileVersion"] < 11 then -- Below version 11
		settings["profileVersion"] = 11
		
		settings["finalHitExplosion"] = false
		settings["laserSeeker"] = false
		settings["laserSeekerTurnSpeed"] = 1
	end
	
	return settings
end

--[[
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
hitForce = 4000 -- TODO: Add option to menu
hitscanBullets = true
explosiveBullets = false
explosiveBulletMinSize = 0.3 -- TODO: Add option to menu
explosiveBulletMaxSize = 0.5 -- TODO: Add option to menu
projectileBulletSpeed = 100
applyForceOnHit = true
softRadiusMin = 3 -- TODO: Add option to menu
softRadiusMax = 4 -- TODO: Add option to menu
mediumRadiusMin = 10 -- TODO: Add option to menu
mediumRadiusMax = 15 -- TODO: Add option to menu
hardRadiusMin = 10 -- TODO: Add option to menu
hardRadiusMax = 15 -- TODO: Add option to menu
]]--