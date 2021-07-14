#include "scripts/utils.lua"
#include "custom/shotgun.lua"
#include "custom/minigun.lua"
#include "custom/pistol.lua"
#include "custom/burstsmg.lua"
#include "custom/rocketlauncher.lua"

local customList = {
	shotgun,
	minigun,
	pistol,
	burstsmg,
	rocketlauncher,
}

local loadedSfx = {}

local listSize = #customList

--local customList_backup = deepcopy(customList)

function GetSettingsByIndex(index)
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
			handle = LoadSound(path)
			loadedSfx[path] = handle
		end
		
		sfx[key] = handle
	end
	
	return settings, sfx
end

function GetNameByIndex(index)
	local settings = GetSettingsByIndex(index)
	
	if settings == nil then
		return ""
	end
	
	return settings.name
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
	
	name = newSettings.name
	additiveReload = newSettings.additiveReload
	additiveReloading = false
	magSize = newSettings.magSize
	currMag = magSize
	maxAmmo = newSettings.maxAmmo
	spread = newSettings.spread
	projectiles = newSettings.projectiles
	shotCooldownTime = newSettings.shotCooldownTime
	currentShotCooldown = 0
	fullAuto = newSettings.fullAuto
	burstFireMax = newSettings.burstFireMax
	burstFire = burstFireMax
	maxReloadTime = newSettings.maxReloadTime
	minRndSpread = newSettings.minRndSpread
	maxRndSpread = newSettings.maxRndSpread
	maxDistance = newSettings.maxDistance
	hitForce = newSettings.hitForce
	hitscanBullets = newSettings.hitscanBullets
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
	infinitePenetration = newSettings.infinitePenetration
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