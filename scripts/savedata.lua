#include "scripts/utils.lua"
#include "scripts/json.lua"
#include "custom/blankProfile.lua"

moddataPrefix = "savegame.mod.moddyweapon"

local customList = GetList()

function saveFileInit()
	saveVersion = GetInt(moddataPrefix .. "Version")
	
	if saveVersion < 1 or saveVersion == nil then
		saveVersion = 1
		SetInt(moddataPrefix .. "Version", saveVersion)
		
		customProfiles = 0
		SetInt(moddataPrefix .. "CustomProfiles", customProfiles)
	end
	
	if saveVersion < 2 then
		saveVersion = 2
		SetInt(moddataPrefix .. "Version", saveVersion)
		
		infiniteAmmo = false
		SetBool(moddataPrefix .. "InfiniteAmmo", infiniteAmmo)
		
		infiniteMag = false
		SetBool(moddataPrefix .. "InfiniteMag", infiniteMag)	
		
		soundEnabled = true
		SetBool(moddataPrefix .. "SoundEnabled", soundEnabled)
		
		--menuOpenKey = "m"
		SetString(moddataPrefix .. "OpenMenuKey", binds["Open_Menu"])
	end
	
	if saveVersion < 3 then
		saveVersion = 3
		SetInt(moddataPrefix .. "Version", saveVersion)
		
		SetString(moddataPrefix .. "Reload", binds["Reload"])
		SetString(moddataPrefix .. "Prev_Weapon", binds["Prev_Weapon"])
		SetString(moddataPrefix .. "Next_Weapon", binds["Next_Weapon"])
	end
	
	customProfiles = GetInt(moddataPrefix .. "CustomProfiles")
	infiniteAmmo = GetBool(moddataPrefix .. "InfiniteAmmo")
	infiniteMag = GetBool(moddataPrefix .. "InfiniteMag")	
	soundEnabled = GetBool(moddataPrefix .. "SoundEnabled")
	binds["Open_Menu"] = GetString(moddataPrefix .. "OpenMenuKey")
	binds["Reload"] = GetString(moddataPrefix .. "Reload")
	binds["Prev_Weapon"] = GetString(moddataPrefix .. "Prev_Weapon")
	binds["Next_Weapon"] = GetString(moddataPrefix .. "Next_Weapon")
	
	if customList ~= nil and customProfiles > 0 then
		loadCustomProfiles()
		savedCustomProfiles = customProfiles
	end
end

function saveSettings()
	SetBool(moddataPrefix .. "InfiniteAmmo", infiniteAmmo)
	SetBool(moddataPrefix .. "InfiniteMag", infiniteMag)	
	SetBool(moddataPrefix .. "SoundEnabled", soundEnabled)
	SetString(moddataPrefix .. "OpenMenuKey", binds["Open_Menu"])
	SetString(moddataPrefix .. "Reload", binds["Reload"])
	SetString(moddataPrefix .. "Prev_Weapon", binds["Prev_Weapon"])
	SetString(moddataPrefix .. "Next_Weapon", binds["Next_Weapon"])
end

function loadCustomProfiles()
	local profilesUpdated = false
	
	for i = 1, customProfiles do
		local currentProfileJSON = GetString(moddataPrefix .. "CustomProfile_" .. i)
		
		local currentProfileObject = json_decode(currentProfileJSON)
		
		if not checkSettingsUpToDate(currentProfileObject) then
			currentProfileObject = updateSettings(currentProfileObject)
			profilesUpdated = true
		end
		
		customList[#customList + 1] = currentProfileObject
	end
	
	if profilesUpdated then
		saveCustomProfiles()
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
	
	savedCustomProfiles = customProfiles
end