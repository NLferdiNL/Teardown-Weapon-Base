#include "scripts/utils.lua"
#include "custom/blankProfile.lua"
#include "custom/shotgun.lua"
#include "custom/minigun.lua"
#include "custom/pistol.lua"
#include "custom/burstsmg.lua"
#include "custom/rocketlauncher.lua"
#include "custom/assaultrifle.lua"
#include "custom/railgun.lua"
#include "custom/lasercutter.lua"
#include "custom/forcegun.lua"
#include "custom/holecutter.lua"
#include "custom/plasmapistol.lua"

local customList = {
	shotgun,
	minigun,
	pistol,
	burstsmg,
	rocketlauncher,
	assaultrifle,
	railgun,
	lasercutter,
	forcegun,
	holecutter,
	plasmapistol,
}

local customListDefaultCount = #customList

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
	
	loadSettingsToProfile(newProfileObject)
	
	newProfileObject.name = newProfileObject.name .. " Copy"
	
	customProfiles = customProfiles + 1
	
	customList[#customList + 1] = newProfileObject
end

function EditCustomName(index, name)
	if not customList[index].customProfile then
		return
	end
	customList[index].name = name
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
	minRndSpread = newSettings.minRndSpread
	maxRndSpread = newSettings.maxRndSpread
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
	drawProjectileLine = newSettings.drawProjectileLine
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
	newSettings.minRndSpread = minRndSpread
	newSettings.maxRndSpread = maxRndSpread
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
	newSettings.drawProjectileLine = drawProjectileLine
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
		
		settings["hitParticleSettings"] = deepcopy(hitParticleSettings)
		settings["shotSmokeParticleSettings"] = deepcopy(shotSmokeParticleSettings)
		settings["shotFireParticleSettings"] = deepcopy(shotFireParticleSettings)
		settings["projectileParticleSettings"] = deepcopy(projectileParticleSettings)
		
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
	
	if settings["profileVersion"] < 4 then -- Below version 3
		settings["profileVersion"] = 4
		
		local particleSettingNames = {"ParticleRadius", "ParticleAlpha", "ParticleGravity", "ParticleDrag", "ParticleEmissive", "ParticleRotation", "ParticleStretch", "ParticleSticky", "ParticleCollide" } 
		
		local interpolationMethods = { linear = 1, smooth = 2, easein = 3, easeout = 4, constant = 5 }
		
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