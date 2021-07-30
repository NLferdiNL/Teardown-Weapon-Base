#include "scripts/utils.lua"
#include "custom/shotgun.lua"
#include "custom/minigun.lua"
#include "custom/pistol.lua"
#include "custom/burstsmg.lua"
#include "custom/rocketlauncher.lua"
#include "custom/assaultrifle.lua"
#include "custom/railgun.lua"
#include "custom/lasercutter.lua"

local customList = {
	shotgun,
	minigun,
	pistol,
	burstsmg,
	rocketlauncher,
	assaultrifle,
	railgun,
	lasercutter,
}

local loadedSfx = {}

local listSize = #customList

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
	return listSize
end

function GetList()
	return customList
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
	particlesEnabled = newSettings.particlesEnabled
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