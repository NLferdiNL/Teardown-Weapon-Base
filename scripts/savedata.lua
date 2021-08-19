#include "scripts/utils.lua"
#include "scripts/json.lua"
#include "custom/blankProfile.lua"

moddataPrefix = "savegame.mod.moddyweapon"

local customList = GetList()

function saveFileInit()
	saveVersion = GetInt(moddataPrefix .. "Version")
	customProfiles = GetInt(moddataPrefix .. "CustomProfiles")
	
	if saveVersion < 1 or saveVersion == nil then
		saveVersion = 1
		SetInt(moddataPrefix .. "Version", saveVersion)
		
		customProfiles = 0
		SetInt(moddataPrefix .. "CustomProfiles", customProfiles)
	end
	
	if customList ~= nil and customProfiles > 0 then
		loadCustomProfiles()
	end
end

function loadCustomProfiles()
	for i = 1, customProfiles do
		local currentProfileJSON = GetString(moddataPrefix .. "CustomProfile_" .. i)
		
		local currentProfileObject = json_decode(currentProfileJSON)
		
		customList[#customList + 1] = currentProfileObject
	end
end

function saveCustomProfiles()
	local customListDefaultCount = GetCustomListDefaultCount()
	
	for i = 1, customProfiles do
		local currentProfileObject = customList[i + customListDefaultCount]
		
		local ammoBackup = currentProfileObject.currAmmo
		local magBackup = currentProfileObject.currMag
		
		currentProfileObject.currAmmo = -1
		currentProfileObject.currMag = -1
		
		local currentProfileJSON = json_encode(currentProfileObject)
		
		currentProfileObject.currAmmo = ammoBackup
		currentProfileObject.currMag = magBackup
		
		SetString(moddataPrefix .. "CustomProfile_" .. i, currentProfileJSON)
	end
	
	SetInt(moddataPrefix .. "CustomProfiles", customProfiles)
end