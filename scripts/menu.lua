#include "datascripts/inputList.lua"
#include "datascripts/color4.lua"
#include "scripts/ui.lua"
#include "scripts/textbox.lua"
#include "scripts/utils.lua"

binds = {
	Prev_Weapon = "z",
	Next_Weapon = "x",
	Reload = "r",
	Open_Menu = "m",
}

local bindBackup = deepcopy(binds)

local bindOrder = {
	"Open_Menu"
}
		
local bindNames = {
	Prev_Weapon = "Previous Weapon",
	Next_Weapon = "Next Weapon",
	Reload = "Reload",
	Open_Menu = "Open Menu",
}

local menuOpened = false
local menuOpenLastFrame = false

local rebinding = nil
local deletingProfile = 0

local erasingBinds = 0

local menuWidth = 0.6
local menuHeight = 0.775

local nameTextBox = nil

local spreadTextBox = nil
local projectilesTextBox = nil
local shotCooldownTimeTextBox = nil
local maxReloadTimeTextBox = nil
local minRndSpreadTextBox = nil
local maxRndSpreadTextBox = nil
local projectileBulletSpeedTextBox = nil
local explosiveBulletMinSizeTextBox = nil
local explosiveBulletMaxSizeTextBox = nil

local softRadiusMinTextBox = nil
local softRadiusMaxTextBox = nil

local mediumRadiusMinTextBox = nil
local mediumRadiusMaxTextBox = nil

local hardRadiusMinTextBox = nil
local hardRadiusMaxTextBox = nil

local maxDistanceTextBox = nil

local burstFireMaxTextBox = nil

local hitForceTextBox = nil

local magSizeTextBox = nil
local maxAmmoTextBox = nil

local bulletHealthBox = nil

local particleLifetimeBox = nil

local projectileGravityBox = nil

local textBoxCount = 0

local weaponListScrollPosition = 0
local isMouseInWeaponList = false
local listScreenHeight = 0
local listScreenMaxScroll = 0

local mainTabTitles = { "Main Options", "Particle Settings", "Sound Settings", "Mod Options" }
local currentMainTab = 1

local particleTabTitles = {"Hit Particles", "Shot Smoke Particles", "Shot Fire Particles", "Projectile Particle"}
local currentParticleTab = 1

local particleSettingNames = {"ParticleRadius", "ParticleAlpha", "ParticleGravity", "ParticleDrag", "ParticleEmissive", "ParticleRotation", "ParticleStretch", "ParticleSticky", "ParticleCollide" } 
local particleReadableNames = {"Particle Radius", "Particle Alpha", "Particle Gravity", "Particle Drag", "Particle Emissive", "Particle Rotation", "Particle Stretch", "Particle Sticky", "Particle Collide" } 

local hasAValueBeenChanged = false
local updateParticleSettings = false

function menu_init()
	binds["Open_Menu"] = menuOpenKey
end

function menu_tick(dt)
	if InputPressed(binds["Open_Menu"]) and GetString("game.player.tool") == toolName and not textboxClass_anyInputActive() and rebinding == nil then
		menuOpened = not menuOpened
		
		if not menuOpened then
			menuCloseActions()
		end
	end
	
	checkValuesChanged()
	
	if hasChangedSettings() then
		hasAValueBeenChanged = false
		updateParticleSettings = true
	end
	
	if menuOpened and hasChangedSettings() then
		menuUpdateActions()
	end
	
	if menuOpened and not menuOpenLastFrame then
		menuUpdateActions()
		menuOpenActions()
	end
	
	menuOpenLastFrame = menuOpened
	
	if rebinding ~= nil then
		local lastKeyPressed = getKeyPressed()
		
		if lastKeyPressed ~= nil then
			binds[rebinding] = lastKeyPressed
			rebinding = nil
		end
	end
	
	if deletingProfile > 0 then
		deletingProfile = deletingProfile - dt
	end
	
	textboxClass_tick()
	
	if erasingBinds > 0 then
		erasingBinds = erasingBinds - dt
	end
	
	if isMenuOpen() then
		checkMouseScroll()
	end
end

function setupTextBoxes()
	local textBox01, newBox01 = textboxClass_getTextBox(1) -- spread
	local textBox02, newBox02 = textboxClass_getTextBox(2) -- projectiles
	local textBox03, newBox03 = textboxClass_getTextBox(3) -- shotCooldownTime
	local textBox04, newBox04 = textboxClass_getTextBox(4) -- maxReloadTime
	local textBox05, newBox05 = textboxClass_getTextBox(5) -- minRndSpread
	local textBox06, newBox06 = textboxClass_getTextBox(6) -- maxRndSpread
	local textBox07, newBox07 = textboxClass_getTextBox(7) -- projectileBulletSpeed
	
	local textBox08, newBox08 = textboxClass_getTextBox(8) -- explosiveBulletMinSize
	local textBox09, newBox09 = textboxClass_getTextBox(9) -- explosiveBulletMaxSize
	
	local textBox10, newBox10 = textboxClass_getTextBox(10) -- softRadiusMin
	local textBox11, newBox11 = textboxClass_getTextBox(11) -- softRadiusMax
	
	local textBox12, newBox12 = textboxClass_getTextBox(12) -- mediumRadiusMin
	local textBox13, newBox13 = textboxClass_getTextBox(13) -- mediumRadiusMax
	
	local textBox14, newBox14 = textboxClass_getTextBox(14) -- hardRadiusMin
	local textBox15, newBox15 = textboxClass_getTextBox(15) -- hardRadiusMax
	
	local textBox16, newBox16 = textboxClass_getTextBox(16) -- maxDistance
	
	local textBox17, newBox17 = textboxClass_getTextBox(17) -- burstFireMax

	local textBox18, newBox18 = textboxClass_getTextBox(18) -- hitForce
	
	local textBox19, newBox19 = textboxClass_getTextBox(19) -- name
	
	local textBox20, newBox20 = textboxClass_getTextBox(20) -- magSize
	local textBox21, newBox21 = textboxClass_getTextBox(21) -- maxAmmo
	
	local textBox22, newBox22 = textboxClass_getTextBox(22) -- bulletHealth
	
	local textBox23, newBox23 = textboxClass_getTextBox(23) -- Particle lifetime
	
	local textBox24, newBox24 = textboxClass_getTextBox(24) -- Projectile Gravity
	
	textBoxCount = 24
	
	if newBox01 then
		textBox01.name = "Spread"
		textBox01.value = spread .. ""
		textBox01.numbersOnly = true
		textBox01.limitsActive = true
		textBox01.numberMin = 0
		textBox01.numberMax = 100
		textBox01.description = "Determines how big the spread circle will be.\nValues between 0 and 0.1 work the most realistic.\nMin: 0 | Max: 100"
		
		spreadTextBox = textBox01
	end

	if newBox02 then
		textBox02.name = "Projectiles"
		textBox02.value = projectiles .. "" 
		textBox02.numbersOnly = true
		textBox02.limitsActive = true
		textBox02.numberMin = 1
		textBox02.numberMax = 1000
		textBox02.description = "The amount of projectiles fired. For example useful for shotguns.\nMin: 1 | Max: 1000"
		
		projectilesTextBox = textBox02
	end

	if newBox03 then
		textBox03.name = "Shot Cooldown Time"
		textBox03.value = shotCooldownTime .. ""
		textBox03.numbersOnly = true
		textBox03.limitsActive = true
		textBox03.numberMin = 0
		textBox03.numberMax = 100
		textBox03.description = "The amount of time before you can shoot again after shooting.\nMin: 0 | Max: 100"
		
		shotCooldownTimeTextBox = textBox03
	end

	if newBox04 then
		textBox04.name = "Max Reload Time"
		textBox04.value = maxReloadTime .. ""
		textBox04.numbersOnly = true
		textBox04.limitsActive = true
		textBox04.numberMin = 0
		textBox04.numberMax = 100
		textBox04.description = "The time it takes to reload your gun.\nMin: 0 | Max: 100"
		
		maxReloadTimeTextBox = textBox04
	end

	if newBox05 then
		textBox05.name = "Min Rnd Spread"
		textBox05.value = minRndSpread .. ""
		textBox05.numbersOnly = true
		textBox05.limitsActive = true
		textBox05.numberMin = 0
		textBox05.numberMax = 100
		textBox05.description = "This indicates how close it has to be to the spread circle minimumly.\nMin: 0 | Max: 100"
		
		minRndSpreadTextBox = textBox05
	end

	if newBox06 then
		textBox06.name = "Max Rnd Spread"
		textBox06.value = maxRndSpread .. ""
		textBox06.numbersOnly = true
		textBox06.limitsActive = true
		textBox06.numberMin = 0
		textBox06.numberMax = 100
		textBox06.description = "This indicates how close it has to be to the spread circle maximumly.\nMin: 0 | Max: 100"
		
		maxRndSpreadTextBox = textBox06
	end

	if newBox07 then
		textBox07.name = "Projectile Bullet Speed"
		textBox07.value = projectileBulletSpeed .. ""
		textBox07.numbersOnly = true
		textBox07.limitsActive = true
		textBox07.numberMin = 0
		textBox07.numberMax = 10000
		textBox07.description = "How fast the bullet will travel, in meters.\nMin: 0 | Max: 10000"
		
		projectileBulletSpeedTextBox = textBox07
	end

	if newBox08 then
		textBox08.name = "Explosive Bullet Min"
		textBox08.value = explosiveBulletMinSize .. ""
		textBox08.numbersOnly = true
		textBox08.limitsActive = true
		textBox08.numberMin = 0
		textBox08.numberMax = 4
		textBox08.description = "Minimum explosive size. Picks a value between this and the maximum below.\nValues between 0.1 and 0.5 will all go to 0.5 due to engine limits.\nMin: 0.5 | Max: 4"
		
		explosiveBulletMinSizeTextBox = textBox08
	end
	
	if newBox09 then
		textBox09.name = "Explosive Bullet Max"
		textBox09.value = explosiveBulletMaxSize .. ""
		textBox09.numbersOnly = true
		textBox09.limitsActive = true
		textBox09.numberMin = 0
		textBox09.numberMax = 4
		textBox09.description = "Maxmimum explosive size. Picks a value between this and the minimum above.\nLimited to 4 due to engine limits.\nMin: 0.5 | Max: 4"
		
		explosiveBulletMaxSizeTextBox = textBox09
	end
	
	if newBox10 then
		textBox10.name = "Soft Radius Min"
		textBox10.value = softRadiusMin .. ""
		textBox10.numbersOnly = true
		textBox10.limitsActive = true
		textBox10.numberMin = 0
		textBox10.numberMax = 1000
		textBox10.description = "Minimum soft radius damage. Picks a value between this and the maximum below.\nSoft materials are glass, foliage, dirt, wood, plaster and plastic.\nValue is used in meters.\nMin: 0 | Max: 1000"
		
		softRadiusMinTextBox = textBox10
	end
	
	if newBox11 then
		textBox11.name = "Soft Radius Max"
		textBox11.value = softRadiusMax .. ""
		textBox11.numbersOnly = true
		textBox11.limitsActive = true
		textBox11.numberMin = 0
		textBox11.numberMax = 1000
		textBox11.description = "Maximum soft radius damage. Picks a value between this and the minimum above.\nSoft materials are glass, foliage, dirt, wood, plaster and plastic.\nValue is used in meters.\nMin: 0 | Max: 1000"
		
		softRadiusMaxTextBox = textBox11
	end
	
	if newBox12 then
		textBox12.name = "Medium Radius Min"
		textBox12.value = mediumRadiusMin .. ""
		textBox12.numbersOnly = true
		textBox12.limitsActive = true
		textBox12.numberMin = 0
		textBox12.numberMax = 1000
		textBox12.description = "Minimum medium radius damage. Picks a value between this and the maximum below.\nMedium materials are concrete, brick and weak metal.\nMaximum of this may not be higher than the previous tier.\nValue is used in meters.\nMin: 0 | Max: 1000"
		
		mediumRadiusMinTextBox = textBox12
	end
	
	if newBox13 then
		textBox13.name = "Medium Radius Max"
		textBox13.value = mediumRadiusMax .. ""
		textBox13.numbersOnly = true
		textBox13.limitsActive = true
		textBox13.numberMin = 0
		textBox13.numberMax = 1000
		textBox13.description = "Maximum medium radius damage. Picks a value between this and the minimum above.\nMedium materials are concrete, brick and weak metal.\nMaximum of this may not be higher than the previous tier.\nValue is used in meters.\nMin: 0 | Max: 1000"
		
		mediumRadiusMaxTextBox = textBox13
	end
	
	if newBox14 then
		textBox14.name = "Hard Radius Min"
		textBox14.value = hardRadiusMin .. ""
		textBox14.numbersOnly = true
		textBox14.limitsActive = true
		textBox14.numberMin = 0
		textBox14.numberMax = 1000
		textBox14.description = "Minimum hard radius damage. Picks a value between this and the maximum below.\nHard materials are hard metal and hard masonry.\nMaximum of this may not be higher than the previous tier.\nValue is used in meters.\nMin: 0 | Max: 1000"
		
		hardRadiusMinTextBox = textBox14
	end
	
	if newBox15 then
		textBox15.name = "Hard Radius Max"
		textBox15.value = hardRadiusMax .. ""
		textBox15.numbersOnly = true
		textBox15.limitsActive = true
		textBox15.numberMin = 0
		textBox15.numberMax = 1000
		textBox15.description = "Maximum hard radius damage. Picks a value between this and the minimum above.\nHard materials are hard metal and hard masonry.\nMaximum of this may not be higher than the previous tier.\nValue is used in meters.\nMin: 0 | Max: 1000"
		
		hardRadiusMaxTextBox = textBox15
	end
	
	if newBox16 then
		textBox16.name = "Max Distance"
		textBox16.value = maxDistance .. ""
		textBox16.numbersOnly = true
		textBox16.limitsActive = true
		textBox16.numberMin = 1
		textBox16.numberMax = 10000
		textBox16.description = "Maximum amount of distance the projectile(s) will travel, in meters.\nMin: 1 | Max: 10000"
		
		maxDistanceTextBox = textBox16
	end
	
	if newBox17 then
		textBox17.name = "Burst Fire Max"
		textBox17.value = burstFireMax .. ""
		textBox17.numbersOnly = true
		textBox17.limitsActive = true
		textBox17.numberMin = 0
		textBox17.numberMax = 1000
		textBox17.description = "The max amount of sequential bullets that will fire when the trigger is held.\nMin: 0 | Max: 1000"
		
		burstFireMaxTextBox = textBox17
	end
	
	if newBox18 then
		textBox18.name = "Hit Force"
		textBox18.value = hitForce .. ""
		textBox18.numbersOnly = true
		textBox18.limitsActive = true
		textBox18.numberMin = 0
		textBox18.numberMax = 100000
		textBox18.description = "The amount of force a projectile will put into an object on collision.\nOnly works on dynamic objects.\nMin: 0 | Max: 100000"
		
		hitForceTextBox = textBox18
	end
	
	if newBox19 then
		textBox19.name = "Name"
		textBox19.value = name
		textBox19.disabled = not customProfile
		textBox19.width = 300
		textBox19.description = "Only active on custom profiles."
		
		nameTextBox = textBox19
	end
	
	if newBox20 then
		textBox20.name = "Mag Size"
		textBox20.value = magSize .. ""
		textBox20.disabled = not customProfile
		textBox20.numbersOnly = true
		textBox20.limitsActive = true
		textBox20.numberMin = 1
		textBox20.numberMax = 100000
		textBox20.description = "Bullets in a magazine.\nThis is only enabled in custom profiles.\nMin: 1 | Max: 100000"
		
		magSizeTextBox = textBox20
	end
	
	if newBox21 then
		textBox21.name = "Max Ammo"
		textBox21.value = maxAmmo .. ""
		textBox21.disabled = not customProfile
		textBox21.numbersOnly = true
		textBox21.limitsActive = true
		textBox21.numberMin = 1
		textBox21.numberMax = 100000
		textBox21.description = "Maximum amount of bullets in the players bag.\nThis is only enabled in custom profiles.\nMin: 0 | Max: 100000"
		
		maxAmmoTextBox = textBox21
	end
	
	if newBox22 then
		textBox22.name = "Bullet Health"
		textBox22.value = bulletHealth .. ""
		textBox22.numbersOnly = true
		textBox22.limitsActive = true
		textBox22.numberMin = 0
		textBox22.numberMax = 100000
		textBox22.description = "Alternative to infinite penetration, takes damage upon hit.\nSoft materials do 1 damage.\nMedium materials do 2 damage.\nHard materials do 3 damage.\nMin: 0 | Max: 100000"
		
		bulletHealthBox = textBox22
	end
	
	if newBox23 then
		textBox23.name = "Particle Lifetime"
		textBox23.value = getCurrentParticle()["lifetime"] .. ""
		textBox23.numbersOnly = true
		textBox23.limitsActive = true
		textBox23.numberMin = 0.01
		textBox23.numberMax = 1000
		textBox23.description = "How long the particle will be around for.\nMin: 0.01 | Max: 1000"
		textBox23.onInputFinished = function(i) getCurrentParticle()["lifetime"] = tonumber(i) end
		
		particleLifetimeBox = textBox23
	end
	
	if newBox24 then
		textBox24.name = "Projectile Gravity"
		textBox24.value = projectileGravity .. ""
		textBox24.numbersOnly = true
		textBox24.limitsActive = true
		textBox24.numberMin = -1000
		textBox24.numberMax = 1000
		textBox24.description = "Gravity applied to projectiles. (Not functional in hitscan currently.)\nMin: -1000 | Max: 1000"
		
		projectileGravityBox = textBox24
	end
end

function modOptionsPage()
	UiPush()
		UiTranslate(0, 50)
		
		drawToggle("Infinite Ammo: ", infiniteAmmo, function (i) infiniteAmmo = i; hasAValueBeenChanged = true end)
				
		UiTranslate(0, 50)
		
		drawToggle("Infinite Mag: ", infiniteMag, function (i) infiniteMag = i; hasAValueBeenChanged = true end)
		
		UiTranslate(0, 50)
		
		drawToggle("Sound: ", soundEnabled, function (i) soundEnabled = i; hasAValueBeenChanged = true end)
		
		UiTranslate(0, 50)
		
		UiPush()
			UiTranslate(-50, 0)
			for i = 1, #bindOrder do
				local id = bindOrder[i]
				local key = binds[id]
				drawRebindable(id, key)
				UiTranslate(0, 50)
			end
		UiPop()
		
		--UiTranslate(0, 50 * (#bindOrder + 1))
	UiPop()
end

function mainToggleButtons(dt)
	UiPush()
		UiTranslate(0, 50)
		
		UiPush()
			UiTranslate(-UiWidth() * (menuWidth / 4.5), 0)
			drawToggle("Hitscan bullets: ", hitscanBullets, function (i) hitscanBullets = i; hasAValueBeenChanged = true end, "Instant bullets, for ex. classic Doom.")
			
			UiTranslate(0, 50)
			
			drawToggle("Apply Force To Hit Objects: ", applyForceOnHit, function (i) applyForceOnHit = i; hasAValueBeenChanged = true end, "Push an object when hit by a projectile.\nInfinite Penetration: Overrides this and disables it.")
			
			UiTranslate(0, 50)
			
			drawToggle("Draw Projectile Line: ", drawProjectileLine, function (i) drawProjectileLine = i; hasAValueBeenChanged = true end, "Draw a line where the projectile is.")
			
			UiTranslate(0, 50)
			
			drawToggle("Explosive Bullets: ", explosiveBullets, function (i) explosiveBullets = i; hasAValueBeenChanged = true end, "Explode on impact bullets.\nInfinite Penetration: Creates constant explosions as it travels.")
			
			UiTranslate(0, 50)
			
			drawToggle("Incendiary Bullets: ", incendiaryBullets, function (i) incendiaryBullets = i; hasAValueBeenChanged = true end, "Burn on impact bullets.\nInfinite Penetration: Creates constant fires as it travels.")
		UiPop()
		
		UiPush()
			UiTranslate(UiWidth() * (menuWidth / 4.5), 0)
			
			drawToggle("Full Auto: ", fullAuto, function (i) fullAuto = i; hasAValueBeenChanged = true end, "Hold to repeatedly fire, limited by shot cooldown time.")
			
			UiTranslate(0, 50)
			
			drawToggle("Infinite Penetration: ", infinitePenetration, function (i) infinitePenetration = i; hasAValueBeenChanged = true end, "Enabling this will mean the bullet will not stop for anything and keep traveling.\nEven if it cannot destroy whatever it touches.")
			
			UiTranslate(0, 50)
			
			drawToggle("Additive(Shotgun) Reload: ", additiveReload, function (i) additiveReload = i; hasAValueBeenChanged = true end, "Reload bullets one by one, rather than by magazine.")
		UiPop()
	UiPop()
end

function leftsideTextInputMenu(dt)
	UiPush()
		UiTranslate(-UiWidth() * (menuWidth / 3.5), 6 * 50)
			
		UiPush()
			UiTranslate(spreadTextBox.width, 0)

			textboxClass_render(spreadTextBox)
			
			UiTranslate(0, 50)
			
			textboxClass_render(projectilesTextBox)
			
			UiTranslate(0, 50)
			
			textboxClass_render(shotCooldownTimeTextBox)
			
			UiTranslate(0, 50)
			
			textboxClass_render(maxReloadTimeTextBox)
			
			UiTranslate(0, 50)
			
			textboxClass_render(minRndSpreadTextBox)
			
			UiTranslate(0, 50)
			
			textboxClass_render(maxRndSpreadTextBox)
			
			UiTranslate(0, 50)
			
			textboxClass_render(projectileBulletSpeedTextBox)
			
			UiTranslate(0, 50)
		
			textboxClass_render(maxDistanceTextBox)
		UiPop()
	UiPop()
end

function middleSideTextInputMenu(dt)
	UiPush()	
		UiTranslate(UiWidth() * (menuWidth / 10), 6 * 50)
		textboxClass_render(softRadiusMinTextBox)
			
		UiTranslate(0, 50)
		
		textboxClass_render(softRadiusMaxTextBox)
		
		UiTranslate(0, 50)
		
		textboxClass_render(mediumRadiusMinTextBox)
		
		UiTranslate(0, 50)
		
		textboxClass_render(mediumRadiusMaxTextBox)
		
		UiTranslate(0, 50)
		
		textboxClass_render(hardRadiusMinTextBox)
		
		UiTranslate(0, 50)
		
		textboxClass_render(hardRadiusMaxTextBox)
		
		UiTranslate(0, 50)
		
		textboxClass_render(explosiveBulletMinSizeTextBox)
			
		UiTranslate(0, 50)
		
		textboxClass_render(explosiveBulletMaxSizeTextBox)
	UiPop()
end

function rightsideTextInputMenu(dt)
	UiPush()
		UiTranslate(UiWidth() * (menuWidth / 3.5), 5 * 50)
		
		UiPush()
			UiTranslate(explosiveBulletMinSizeTextBox.width, 50)
			
			textboxClass_render(burstFireMaxTextBox)
			
			UiTranslate(0, 50)
			
			textboxClass_render(hitForceTextBox)
			
			UiTranslate(0, 50)
			
			textboxClass_render(bulletHealthBox)
			
			UiTranslate(0, 50)
			
			textboxClass_render(projectileGravityBox)
			
			UiTranslate(0, 50)
			
			textboxClass_render(magSizeTextBox)
			
			UiTranslate(0, 50)
			
			textboxClass_render(maxAmmoTextBox)
		UiPop()
	UiPop()
end

function mainSettings()
	UiPush()
		UiTranslate(0, 50)
		
		UiPush()
			textboxClass_render(nameTextBox)
			
			if nameTextBox.inputActive or nameTextBox.lastInputActive then
				name = nameTextBox.value
				
				EditCustomName(GetCurrentSelectedWeaponIndex(), name)
			end
			
			mainToggleButtons(dt)
			
			leftsideTextInputMenu(dt)
			middleSideTextInputMenu(dt)
			rightsideTextInputMenu(dt)
		UiPop()
	UiPop()
end

function drawBox(text, fontSize, bold, maxWidth, margin, boxColor4, textColor4)
	UiPush()
		fontSize = fontSize or 26
		bold = bold or false
		margin = margin or 20
		
		if bold then
			UiFont("bold.ttf", fontSize)
		else
			UiFont("regular.ttf", fontSize)
		end
		
		if maxWidth then
			UiWordWrap(maxWidth)
		end
		
		local titleBoxWidth, titleBoxHeight = UiGetTextSize(text)
		UiPush()
			if boxColor4 ~= nil then
				c_UiColorFilter(boxColor4)
			end
			
			UiImageBox("ui/hud/infobox.png", titleBoxWidth + margin, titleBoxHeight + margin, 10, 10)
		UiPop()
		
		UiPush()
			if textColor4 ~= nil then
				c_UiColorFilter(textColor4)
			end
			
			UiText(text)
		UiPop()
	UiPop()
end

function drawTitle()
	UiPush()
		UiTranslate(0, -40)
		
		local titleText = toolReadableName .. " Settings"
		
		drawBox(titleText, 45, true)
	UiPop()
end

function drawTabs(tabSpace, tabTitles, currentTab, callback)
	UiPush()
		UiFont("regular.ttf", 26)
		UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
		
		local buttonWidth = UiWidth() * tabSpace / #tabTitles
	
		UiTranslate(-UiWidth() * tabSpace / 2 + buttonWidth / 2, 0)
		
		for i = 1, #tabTitles do
			UiPush()
				UiTranslate((i - 1) * buttonWidth, 0)
				
				if UiTextButton(tabTitles[i], buttonWidth, 60) then
					callback(i)
				end
				
				if currentTab == i then
					UiTranslate(0, 30)
					
					c_UiColor(Color4.Black)
					
					UiRect(buttonWidth - 2, 15)
				end
			UiPop()
		end
	UiPop()
end

function bottomMenuButtons()
	UiPush()
		UiTranslate(0, UiHeight() * menuHeight * 0.9)
	
		UiFont("regular.ttf", 26)
	
		UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
		
		--[[if erasingBinds > 0 then
			UiPush()
			c_UiColor(Color4.Red)
			if UiTextButton("Are you sure?" , 400, 40) then
				binds = deepcopy(bindBackup)
				erasingBinds = 0
			end
			UiPop()
		else
			if UiTextButton("Reset binds to defaults" , 400, 40) then
				erasingBinds = 5
			end
		end
		
		UiTranslate(0, 50)]]--
		
		UiPush()
			UiTranslate(-420, 0)
			if UiTextButton("New Profile" , 200, 40) then
				CreateNewCustom()
				
				updateScrollSize()
			end
			
			UiTranslate(210, 0)
			
			UiPush()
				if not customProfile then
					disableButtonStyle()
				end
				
				if deletingProfile > 0 then
					UiPush()
						c_UiColor(Color4.Red)
						if UiTextButton("Are you sure?" , 200, 40) and customProfile then
							local currIndex = GetCurrentSelectedWeaponIndex()
						
							selectNewWeapon(1)
							DeleteCustom(currIndex)
							
							updateScrollSize()
						end
					UiPop()
				else
					if UiTextButton("Delete Profile" , 200, 40) and customProfile then
						deletingProfile = 5
					end
				end
			UiPop()
			
			UiTranslate(210, 0)
			
			if UiTextButton("Copy Profile" , 200, 40) then
				saveToolValues()
			
				CreateNewCustomFromLoaded()
				
				updateScrollSize()
			end
			
			UiTranslate(210, 0)
			
			UiPush()
			if savedCustomProfiles ~= customProfiles or hasAValueBeenChanged then
				greenAttentionButtonStyle()
			end
			
			if UiTextButton("Save Profiles" , 200, 40) then
				hasAValueBeenChanged = not customProfile
				saveToolValues()
				saveCustomProfiles()
			end
			UiPop()
		
			UiTranslate(210, 0)
			
			if UiTextButton("Close" , 200, 40) then
				menuCloseActions()
			end
		UiPop()
	UiPop()
end
--renderParticleInterpolationSelector
function renderParticleStringVarSelector(settingData, settingKey, settingTypes)
	local currentSettingIndex = settingData[settingKey]
	local optionWidth = 175
	local margin = 10
	
	UiPush()
		UiFont("regular.ttf", 26)
		UiAlign("center middle")
		
		UiImageBox("ui/common/box-outline-6.png", optionWidth, 40, 6, 6)
		
		UiPush()
			UiAlign("left middle")
			UiTranslate(-optionWidth / 2 + margin, 0)
			if UiImageButton("MOD/sprites/arrow-left.png", 60, 60) then
				currentSettingIndex = currentSettingIndex - 1
				hasAValueBeenChanged = true
				
				if currentSettingIndex < 1 then
					currentSettingIndex = #settingTypes
				end
			end
		UiPop()
		
		UiText(settingTypes[currentSettingIndex])
		
		UiPush()
			UiAlign("right middle")
			UiTranslate(optionWidth / 2 - margin, 0)
			if UiImageButton("MOD/sprites/arrow-right.png", 60, 60)	then
				currentSettingIndex = currentSettingIndex + 1
				hasAValueBeenChanged = true
				
				if currentSettingIndex > #settingTypes then
					currentSettingIndex = 1
				end
			end
		UiPop()
		
		settingData[settingKey] = currentSettingIndex
	UiPop()
end

function renderParticleSetting(settingReadableName, settingName, hasParticleChanged)
	UiPush()
		UiFont("regular.ttf", 26)
		UiAlign("left middle")
		
		local settingData = getCurrentParticle()[settingName]
		
		drawToggleBox(settingData[1], function(i) settingData[1] = i end)
		
		UiTranslate(60, 0)
		
		UiText(settingReadableName)
		
		UiTranslate(200, 0)
		
		local minBox, minBoxNewBox = textboxClass_getTextBox(textBoxCount + 1)
		local maxBox, maxBoxNewBox = textboxClass_getTextBox(textBoxCount + 2)
		local fadeInBox, fadeInNewBox = textboxClass_getTextBox(textBoxCount + 3)
		local fadeOutBox, fadeOutNewBox = textboxClass_getTextBox(textBoxCount + 4)
		
		textBoxCount = textBoxCount + 4
		
		if minBoxNewBox then
			minBox.name = "Min"
			minBox.value = settingData[2] .. ""
			minBox.numbersOnly = true
			minBox.limitsActive = true
			minBox.numberMin = -1000
			minBox.numberMax = 1000
			minBox.description = "Start value of this property.\nMin: -1000 | Max: 1000"
			minBox.onInputFinished = function(i)
				getCurrentParticle()[settingName][2] = tonumber(i) 
			end
		end
		
		if maxBoxNewBox then
			maxBox.name = "Max"
			maxBox.value = settingData[3] .. ""
			maxBox.numbersOnly = true
			maxBox.limitsActive = true
			maxBox.numberMin = -1000
			maxBox.numberMax = 1000
			maxBox.description = "End value of this property.\nMin: -1000 | Max: 1000"
			maxBox.onInputFinished = function(i) getCurrentParticle()[settingName][3] = tonumber(i) end
		end
		
		if fadeInNewBox then
			fadeInBox.name = "Fade In"
			fadeInBox.value = settingData[5] .. ""
			fadeInBox.numbersOnly = true
			fadeInBox.limitsActive = true
			fadeInBox.numberMin = -1000
			fadeInBox.numberMax = 1000
			fadeInBox.description = "Fade In value of this property.\nMin: -1000 | Max: 1000"
			fadeInBox.onInputFinished = function(i) getCurrentParticle()[settingName][5] = tonumber(i) end
		end
		
		if fadeOutBox then
			fadeOutBox.name = "Fade Out"
			fadeOutBox.value = settingData[6] .. ""
			fadeOutBox.numbersOnly = true
			fadeOutBox.limitsActive = true
			fadeOutBox.numberMin = -1000
			fadeOutBox.numberMax = 1000
			fadeOutBox.description = "Fade Out value of this property.\nMin: -1000 | Max: 1000"
			fadeOutBox.onInputFinished = function(i) getCurrentParticle()[settingName][6] = tonumber(i) end
		end
		
		if hasParticleChanged then
			minBox.value = settingData[2] .. ""
			maxBox.value = settingData[3] .. ""
			fadeInBox.value = settingData[5] .. ""
			fadeOutBox.value = settingData[6] .. ""
		end
		
		UiPush()
			UiAlign("center middle")
			UiTranslate(75, 0)
			
			textboxClass_render(minBox)
			
			UiTranslate(150, 0)
			
			textboxClass_render(maxBox)
			
			UiTranslate(150, 0)
			
			renderParticleStringVarSelector(settingData, 4, interpolationMethods)
			
			UiTranslate(225, 0)
			
			textboxClass_render(fadeInBox)
			
			UiTranslate(200, 0)
			
			textboxClass_render(fadeOutBox)
		UiPop()
	UiPop()
end

function drawParticleColorPicker(hasParticleChanged, offset, description)
	UiPush()
		local currentParticle = getCurrentParticle()
		local settingData = currentParticle["ParticleColor"]
		
		local redBox, redBoxNewBox = textboxClass_getTextBox(textBoxCount + 1)
		local greenBox, greenBoxNewBox = textboxClass_getTextBox(textBoxCount + 2)
		local blueBox, blueBoxNewBox = textboxClass_getTextBox(textBoxCount + 3)
		
		textBoxCount = textBoxCount + 3
		
		if redBoxNewBox then
			redBox.name = "R"
			redBox.value = settingData[1 + offset] .. ""
			redBox.numbersOnly = true
			redBox.limitsActive = true
			redBox.numberMin = 0
			redBox.numberMax = 1
			redBox.description = "Red value\nMin: 0 | Max: 1"
			
			if description ~= nil then
				redBox.description = description .. redBox.description
			end
			
			redBox.onInputFinished = function(i) getCurrentParticle()["ParticleColor"][1 + offset] = tonumber(i) end
		end
		
		if greenBoxNewBox then
			greenBox.name = "G"
			greenBox.value = settingData[2 + offset] .. ""
			greenBox.numbersOnly = true
			greenBox.limitsActive = true
			greenBox.numberMin = 0
			greenBox.numberMax = 1
			greenBox.description = "Green value\nMin: 0 | Max: 1"
			
			if description ~= nil then
				greenBox.description = description .. greenBox.description
			end
			
			greenBox.onInputFinished = function(i) getCurrentParticle()["ParticleColor"][2 + offset] = tonumber(i) end
		end
		
		if blueBoxNewBox then
			blueBox.name = "B"
			blueBox.value = settingData[3 + offset] .. ""
			blueBox.numbersOnly = true
			blueBox.limitsActive = true
			blueBox.numberMin = 0
			blueBox.numberMax = 1
			blueBox.description = "Blue value\nMin: 0 | Max: 1"
			
			if description ~= nil then
				blueBox.description = description .. blueBox.description
			end
			
			blueBox.onInputFinished = function(i) getCurrentParticle()["ParticleColor"][3 + offset] = tonumber(i) end
		end
		
		if hasParticleChanged then
			redBox.value = settingData[1 + offset] .. ""
			greenBox.value = settingData[2 + offset] .. ""
			blueBox.value = settingData[3 + offset] .. ""
		end
		
		UiPush()
			UiAlign("center middle")
			UiTranslate(125, 0)
			
			textboxClass_render(redBox)
			
			UiTranslate(150, 0)
			
			textboxClass_render(greenBox)
			
			UiTranslate(150, 0)
			
			textboxClass_render(blueBox)
		UiPop()
	UiPop()
end

function getCurrentParticle()
	local currentParticle = hitParticleSettings
		
	if currentParticleTab == 2 then
		currentParticle = shotSmokeParticleSettings
	elseif currentParticleTab == 3 then
		currentParticle = shotFireParticleSettings
	elseif currentParticleTab == 4 then
		currentParticle = projectileParticleSettings
	end
	
	return currentParticle
end

function drawParticleTilePicker(pickerWidth, pickerHeight, arrowWidth, pickerInnerMargin)
	local particleRows = 4
	local particleCols = 4
	
	local total = particleRows * particleCols - 1
	
	local imageSize = 130 * particleRows
	local tileSize = 130
	
	local currentParticle = getCurrentParticle()
	
	UiPush()
		c_UiColor(Color4.White)
		UiRect(pickerWidth, pickerHeight)
		
		UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
		
		UiPush()
			UiWindow(pickerWidth - pickerInnerMargin, pickerHeight - pickerInnerMargin, true)
			
			UiAlign("top left")
			
			UiPush()
				c_UiColor(Color4.Black)
				UiRect(UiWidth(), UiHeight())
			UiPop()
			
			local index = currentParticle["ParticleTile"]
			
			local currentX = index % particleRows
			local currentY = math.floor(index / particleRows)
			
			UiTranslate(-currentX * tileSize, -currentY * tileSize)
			UiImageBox("MOD/sprites/particles.png", imageSize, imageSize, 0, 0)
		UiPop()
		
		UiPush()
			UiTranslate(-pickerWidth / 2, 0)
			UiAlign("right middle")
			if UiTextButton("<", arrowWidth, pickerHeight) then
				index = index - 1
				
				if index > 6 and index < 12 then
					index = 6
				elseif index < 0 then
					index = total
				end
				
				hasAValueBeenChanged = true
			end
		UiPop()
		
		UiPush()
			UiTranslate(pickerWidth / 2, 0)
			UiAlign("left middle")
			if UiTextButton(">", arrowWidth, pickerHeight) then
				index = index + 1
				
				if index > 6 and index < 12 then
					index = 12
				elseif index > total then
					index = 0
				end
				
				hasAValueBeenChanged = true
			end
		UiPop()
		
		currentParticle["ParticleTile"] = index
	UiPop()
end

function particleSettings()
	UiPush()
		UiTranslate(0, 60)
		
		UiPush()
			drawTabs(menuWidth, particleTabTitles, currentParticleTab, function(i) currentParticleTab = i; updateParticleSettings = true end)
			
			local currentParticle = getCurrentParticle()
			
			if updateParticleSettings then
				if particleLifetimeBox ~= nil then
					particleLifetimeBox.value = currentParticle["lifetime"] .. ""
				end
			end
			
			UiTranslate(0, 50)
			
			drawToggle("Particle Enabled: ", currentParticle["enabled"], function (i) currentParticle["enabled"] = i; hasAValueBeenChanged = true end, "Spawn this particle?")
			
			UiTranslate(-menuWidth * UiWidth() / 2 + 20, 50)
			
			UiPush()
				UiTranslate(200, 0)
				textboxClass_render(particleLifetimeBox)
				
				UiTranslate(200, 0)
				renderParticleStringVarSelector(currentParticle, "ParticleType", particleTypes)
			UiPop()
			
			UiPush()
				UiTranslate(UiWidth() * menuWidth - 150, 0)
				drawParticleTilePicker(130, 130, 30, 3)
			UiPop()
			
			UiTranslate(0, 50)
			
			UiPush()
				UiTranslate(-70, 0)
				drawParticleColorPicker(updateParticleSettings, 0, "Start color.\n")
				
				UiTranslate(500, 0)
				
				UiText("to")
				
				UiTranslate(-40, 0)
				
				drawParticleColorPicker(updateParticleSettings, 3, "End color.\n")
			UiPop()
			
			UiTranslate(0, 50)
			
			UiPush()
			for i = 1, #particleSettingNames do
				local currentSettingName = particleSettingNames[i]
				local currentSettingReadableName = particleReadableNames[i]
				renderParticleSetting(currentSettingReadableName, currentSettingName, updateParticleSettings)
				UiTranslate(0, 50)
			end
			
			updateParticleSettings = false
			UiPop()
		UiPop()
	UiPop()
end

function soundSettings()
	UiPush()
		UiTranslate(0, 100)
		UiFont("bold.ttf", 48)
		UiText("Coming next update!")
	UiPop()
end

function weaponQuickMenu()
	UiPush()
		UiWordWrap(330)
		UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
		UiFont("regular.ttf", 26)

		UiTranslate(0, UiHeight())

		UiAlign("bottom left")

		UiColor(0, 0, 0, 0.75)

		UiRect(350, UiMiddle())

		UiAlign("top center")

		UiTranslate(175, -UiMiddle())

		UiColor(1, 1, 1, 0.75)

		UiRect(350, 30)

		UiColor(0, 0, 0, 1)

		UiText("Weapon Select")

		UiTranslate(-175, 30)

		UiAlign("top left")
		
		UiPush()
			isMouseInWeaponList = UiIsMouseInRect(350, UiMiddle() - 30)

			UiWindow(350, UiMiddle() - 30, true)

			UiColor(1, 1, 1, 1)

			for i = 0, GetListCount() - 1 do
				local weapon = GetNameByIndex(i + 1)
				
				if weapon == nil or weapon == "" then
					weapon = " "
				end
				
				UiPush()
					UiTranslate(0, i * 30 + 2 - weaponListScrollPosition)
					
					if i + 1 == GetCurrentSelectedWeaponIndex() then
						UiButtonImageBox("ui/common/box-outline-6.png", 6, 6, 0, 1, 0, 1)
					end
					
					local textWidth, textHeight = UiGetTextSize(weapon)
					local fontSize = 26
					local fontDecreaseIncrement = 2
					
					while textWidth > 320 do
						fontSize = fontSize - fontDecreaseIncrement

						UiFont("regular.ttf", fontSize)
						
						textWidth, textHeight = UiGetTextSize(weapon)
					end
					
					if UiTextButton(weapon, 330, 30) then
						selectNewWeapon(i + 1)
					end

					i = i + 1

				UiPop()
			end

			UiAlign("right middle")

			UiTranslate(350, (weaponListScrollPosition / listScreenMaxScroll) * 2 * UiMiddle())

			UiRect(20, 40)
		UiPop()

	UiPop()
end

function disableButtonStyle()
	UiButtonImageBox("ui/common/box-outline-6.png", 6, 6, 0.25, 0.25, 0.25, 1)
	UiButtonPressColor(1, 1, 1)
	UiButtonHoverColor(1, 1, 1)
	UiButtonPressDist(0)
end

function greenAttentionButtonStyle()
	local greenStrength = math.sin(GetTime() * 5)
	local otherStrength = 1 - greenStrength
	
	if greenStrength < otherStrength then
		greenStrength = otherStrength
	end
	
	UiButtonImageBox("ui/common/box-outline-6.png", 6, 6, otherStrength, greenStrength, otherStrength, 1)
end

function menu_draw(dt)
	if not isMenuOpen() then
		return
	end
	
	UiMakeInteractive()
	
	UiPush()
		UiBlur(0.75)
		
		UiAlign("center middle")
		UiTranslate(UiWidth() * 0.5, UiHeight() * 0.5)
		UiImageBox("ui/hud/infobox.png", UiWidth() * menuWidth, UiHeight() * menuHeight, 10, 10)
		
		UiWordWrap(UiWidth() * menuWidth)
		
		UiTranslate(0, -UiHeight() * (menuHeight / 2))
		
		UiPush()
			UiTranslate(0, 40)
			
			bottomMenuButtons()
		UiPop()
		
		if hasAValueBeenChanged or savedCustomProfiles ~= customProfiles then
			UiPush()
				UiTranslate(0, UiHeight() * menuHeight + 30)
				
				if customProfile then
					UiTranslate(0, 13)
					drawBox("Remember to save your changes!\nCurrent changes are lost upon restart/profile switch!", 26, false, 500, 20, Color4.Red, Color4.Red)
				else
					UiTranslate(0, 26)
					drawBox("If you wish to save these changes, copy these to a custom profile.\nCurrent changes are lost upon restart/profile switch!", 26, false, 500, 20, Color4.Red, Color4.Red)
				end
			UiPop()
		end
		
		drawTitle()
		
		UiTranslate(0, 30)
		
		drawTabs(menuWidth, mainTabTitles, currentMainTab, function(i) currentMainTab = i end)
		
		setupTextBoxes()
		
		UiFont("regular.ttf", 26)
		
		if currentMainTab == 1 then
			mainSettings()
		elseif currentMainTab == 2 then
			particleSettings()
		elseif currentMainTab == 3 then
			soundSettings()
		elseif currentMainTab == 4 then
			modOptionsPage()
		end
	UiPop()
	
	weaponQuickMenu()
	
	textboxClass_drawDescriptions()
	c_drawDescription()
end

function checkMouseScroll()
	if not isMouseInWeaponList then
		return
	end
	
	if listScreenMaxScroll < UiHeight() / 2 + 2 - listScreenHeight + 15 then
		return
	end

	weaponListScrollPosition = weaponListScrollPosition + -InputValue("mousewheel") * 10

	if weaponListScrollPosition < 0 then
		weaponListScrollPosition = 0
	elseif weaponListScrollPosition > listScreenMaxScroll then
		weaponListScrollPosition = listScreenMaxScroll
	end
end

function drawRebindable(id, key)
	UiPush()
		UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
	
		--UiTranslate(UiWidth() * menuWidth / 1.5, 0)
	
		UiAlign("right middle")
		UiText(bindNames[id] .. "")
		
		--UiTranslate(UiWidth() * menuWidth * 0.1, 0)
		
		UiAlign("left middle")
		
		if rebinding == id then
			c_UiColor(Color4.Green)
		else
			c_UiColor(Color4.Yellow)
		end
		
		if UiTextButton(key, 40, 40) then
			rebinding = id
		end
	UiPop()
end

function menuOpenActions()
	updateScrollSize()
end

function updateScrollSize()
	listScreenHeight = UiMiddle() - 20
	listScreenMaxScroll = (GetListCount() * 30 + 2) - listScreenHeight + 15
	
	weaponListScrollPosition = 0
end

function menuUpdateActions()
	deletingProfile = 0
	
	if nameTextBox ~= nil then
		nameTextBox.value = name
		nameTextBox.disabled = not customProfile
		
		if not customProfile then
			nameTextBox.description = "Only active on custom profiles."
		else
			nameTextBox.description = ""
		end
	end
	
	if spreadTextBox ~= nil then
		spreadTextBox.value =  spread .. ""
	end
	
	if projectilesTextBox ~= nil then
		projectilesTextBox.value = projectiles .. ""
	end
	
	if shotCooldownTimeTextBox ~= nil then
		shotCooldownTimeTextBox.value = shotCooldownTime .. ""
	end
	
	if maxReloadTimeTextBox ~= nil then
		maxReloadTimeTextBox.value = maxReloadTime .. ""
	end
	
	if minRndSpreadTextBox ~= nil then
		minRndSpreadTextBox.value = minRndSpread .. ""
	end
	
	if maxRndSpreadTextBox ~= nil then
		maxRndSpreadTextBox.value = maxRndSpread .. ""
	end
	
	if projectileBulletSpeedTextBox ~= nil then
		projectileBulletSpeedTextBox.value = projectileBulletSpeed .. ""
	end
	
	if explosiveBulletMinSizeTextBox ~= nil then
		explosiveBulletMinSizeTextBox.value = explosiveBulletMinSize .. ""
	end
	
	if explosiveBulletMaxSizeTextBox ~= nil then
		explosiveBulletMaxSizeTextBox.value = explosiveBulletMaxSize .. ""
	end
	
	if softRadiusMinTextBox ~= nil then
		softRadiusMinTextBox.value = softRadiusMin .. ""
	end
	
	if softRadiusMaxTextBox ~= nil then
		softRadiusMaxTextBox.value = softRadiusMax .. ""
	end
	
	if mediumRadiusMinTextBox ~= nil then
		mediumRadiusMinTextBox.value = mediumRadiusMin .. ""
	end
	
	if mediumRadiusMaxTextBox ~= nil then
		mediumRadiusMaxTextBox.value = mediumRadiusMax .. ""
	end
	
	if hardRadiusMinTextBox ~= nil then
		hardRadiusMinTextBox.value = hardRadiusMin .. ""
	end
	
	if hardRadiusMaxTextBox ~= nil then
		hardRadiusMaxTextBox.value = hardRadiusMax .. ""
	end
	
	if maxDistanceTextBox ~= nil then
		maxDistanceTextBox.value = maxDistance .. ""
	end
	
	if burstFireMaxTextBox ~= nil then
		burstFireMaxTextBox.value = burstFireMax .. ""
	end
	
	if hitForceTextBox ~= nil then
		hitForceTextBox.value = hitForce .. ""
	end
	
	if magSizeTextBox ~= nil then
		magSizeTextBox.value = magSize .. ""
		magSizeTextBox.disabled = not customProfile
	end
	
	if maxAmmoTextBox ~= nil then
		maxAmmoTextBox.value = maxAmmo .. ""
		maxAmmoTextBox.disabled = not customProfile
	end
	
	if bulletHealthBox ~= nil then
		bulletHealthBox.value = bulletHealth .. ""
	end
	
	if particleLifetimeBox ~= nil then
		particleLifetimeBox.value = getCurrentParticle()["lifetime"] .. ""
	end
	
	if projectileGravityBox ~= nil then
		projectileGravityBox.value = projectileGravity .. ""
	end
end

function menuCloseActions()
	menuOpened = false
	rebinding = nil
	deletingProfile = 0
	saveToolValues()
	
	updateSavedBinds()

	saveSettings()
end

function checkValuesChanged()
	if not customProfile then
		return
	end
	
	if textboxClass_anyInputActive() then
		hasAValueBeenChanged = true
	end
end

function updateSavedBinds()
	menuOpenKey = binds["Open_Menu"]
end
	
function saveToolValues()
	if spreadTextBox == nil then
		setupTextBoxes()
	end

	spread = tonumber(spreadTextBox.value)
	projectiles = tonumber(projectilesTextBox.value)
	shotCooldownTime = tonumber(shotCooldownTimeTextBox.value)
	maxReloadTime = tonumber(maxReloadTimeTextBox.value)
	minRndSpread = tonumber(minRndSpreadTextBox.value)
	maxRndSpread = tonumber(maxRndSpreadTextBox.value)
	projectileBulletSpeed = tonumber(projectileBulletSpeedTextBox.value)
	explosiveBulletMinSize = tonumber(explosiveBulletMinSizeTextBox.value)
	explosiveBulletMaxSize = tonumber(explosiveBulletMaxSizeTextBox.value)
	softRadiusMin = tonumber(softRadiusMinTextBox.value)
	softRadiusMax = tonumber(softRadiusMaxTextBox.value)
	mediumRadiusMin = tonumber(mediumRadiusMinTextBox.value)
	mediumRadiusMax = tonumber(mediumRadiusMaxTextBox.value)
	hardRadiusMin = tonumber(hardRadiusMinTextBox.value)
	hardRadiusMax = tonumber(hardRadiusMaxTextBox.value)
	maxDistance = tonumber(maxDistanceTextBox.value)
	burstFireMax = tonumber(burstFireMaxTextBox.value)
	hitForce = tonumber(hitForceTextBox.value)
	bulletHealth = tonumber(bulletHealthBox.value)
	projectileGravity = tonumber(projectileGravityBox.value)
	
	if customProfile then
		name = nameTextBox.value
		magSize = tonumber(magSizeTextBox.value)
		maxAmmo = tonumber(maxAmmoTextBox.value)
		SaveSettingsToProfile(GetCurrentSelectedWeaponIndex())
	end
end

function isMenuOpen()
	return menuOpened
end

function setMenuOpen(val)
	menuOpened = val
end