-- Link to your file using these includes
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

-- And add the array name here. (NOT name = "Shotgun", the one at the top of the file)
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

-- You can ignore the rest, this is just to link this file to the rest of the code.
local customListDefaultCount = #customList

function getCustomList()
	return customList
end

function getCustomListDefaultCountFromListFile()
	return customListDefaultCount
end