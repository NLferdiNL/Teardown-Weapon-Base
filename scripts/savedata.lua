#include "scripts/utils.lua"
#include "scripts/json.lua"
#include "custom/blankProfile.lua"

moddataPrefix = "savegame.mod.moddyweapon"

local customList = GetList()

function saveFileInit()
	saveVersion = GetInt(moddataPrefix .. "Version")
	customProfiles = GetInt(moddataPrefix .. "CustomProfiles")
	infiniteAmmo = GetBool(moddataPrefix .. "InfiniteAmmo")
	infiniteMag = GetBool(moddataPrefix .. "InfiniteMag")	
	soundEnabled = GetBool(moddataPrefix .. "SoundEnabled")
	menuOpenKey = GetString(moddataPrefix .. "OpenMenuKey")
	
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
		
		menuOpenKey = "m"
		SetString(moddataPrefix .. "OpenMenuKey", menuOpenKey)
	end
	
	if customList ~= nil and customProfiles > 0 then
		loadCustomProfiles()
		savedCustomProfiles = customProfiles
	end
end

function saveSettings()
	SetBool(moddataPrefix .. "InfiniteAmmo", infiniteAmmo)
	SetBool(moddataPrefix .. "InfiniteMag", infiniteMag)	
	SetBool(moddataPrefix .. "SoundEnabled", soundEnabled)
	SetString(moddataPrefix .. "OpenMenuKey", menuOpenKey)
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
	
	--[[function test(tablet)
		for key, value in pairs(tablet) do
			if value == nil then
				DebugPrint("nil " .. key)
			elseif type(value) == "nil" then
				DebugPrint("nil " .. key)
			elseif type(value) == "table" then
				test(value)
			end
		end
	end]]--
	
	--tableToText(inputTable, loopThroughTables, useIPairs, addIndex, addNewLine, printSeperately)
	--test(customList[1 + customListDefaultCount])
	
	for i = 1, customProfiles do
		local currentProfileObject = customList[i + customListDefaultCount]
		
		--DebugPrint("test: " .. i)
		--DebugPrint(tableToText_legacy(currentProfileObject))
		
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