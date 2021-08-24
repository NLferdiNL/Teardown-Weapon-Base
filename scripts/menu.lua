#include "datascripts/inputList.lua"
#include "datascripts/color4.lua"
#include "scripts/ui.lua"
#include "scripts/textbox.lua"
#include "scripts/utils.lua"

-- TODO: Add new settings to menu open actions

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

local weaponListScrollPosition = 0
local isMouseInWeaponList = false
local listScreenHeight = 0
local listScreenMaxScroll = 0

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
	
	if newBox01 then
		textBox01.name = "Spread"
		textBox01.value = spread .. ""
		textBox01.numbersOnly = true
		textBox01.limitsActive = true
		textBox01.numberMin = 0
		textBox01.numberMax = 5
		
		spreadTextBox = textBox01
	end

	if newBox02 then
		textBox02.name = "Projectiles"
		textBox02.value = projectiles .. "" 
		textBox02.numbersOnly = true
		textBox02.limitsActive = true
		textBox02.numberMin = 1
		textBox02.numberMax = 100
		
		projectilesTextBox = textBox02
	end

	if newBox03 then
		textBox03.name = "Shot Cooldown Time"
		textBox03.value = shotCooldownTime .. ""
		textBox03.numbersOnly = true
		textBox03.limitsActive = true
		textBox03.numberMin = 0
		textBox03.numberMax = 100
		
		shotCooldownTimeTextBox = textBox03
	end

	if newBox04 then
		textBox04.name = "Max Reload Time"
		textBox04.value = maxReloadTime .. ""
		textBox04.numbersOnly = true
		textBox04.limitsActive = true
		textBox04.numberMin = 0
		textBox04.numberMax = 100
		
		maxReloadTimeTextBox = textBox04
	end

	if newBox05 then
		textBox05.name = "Min Rnd Spread"
		textBox05.value = minRndSpread .. ""
		textBox05.numbersOnly = true
		textBox05.limitsActive = true
		textBox05.numberMin = 0
		textBox05.numberMax = 100
		
		minRndSpreadTextBox = textBox05
	end

	if newBox06 then
		textBox06.name = "Max Rnd Spread"
		textBox06.value = maxRndSpread .. ""
		textBox06.numbersOnly = true
		textBox06.limitsActive = true
		textBox06.numberMin = 0
		textBox06.numberMax = 100
		
		maxRndSpreadTextBox = textBox06
	end

	if newBox07 then
		textBox07.name = "Projectile Bullet Speed"
		textBox07.value = projectileBulletSpeed .. ""
		textBox07.numbersOnly = true
		textBox07.limitsActive = true
		textBox07.numberMin = 1
		textBox07.numberMax = 10000
		
		projectileBulletSpeedTextBox = textBox07
	end

	if newBox08 then
		textBox08.name = "Explosive Bullet Min"
		textBox08.value = explosiveBulletMinSize .. ""
		textBox08.numbersOnly = true
		textBox08.limitsActive = true
		textBox08.numberMin = 0
		textBox08.numberMax = 4
		
		explosiveBulletMinSizeTextBox = textBox08
	end
	
	if newBox09 then
		textBox09.name = "Explosive Bullet Max"
		textBox09.value = explosiveBulletMaxSize .. ""
		textBox09.numbersOnly = true
		textBox09.limitsActive = true
		textBox09.numberMin = 0
		textBox09.numberMax = 4
		
		explosiveBulletMaxSizeTextBox = textBox09
	end
	
	if newBox10 then
		textBox10.name = "Soft Radius Min"
		textBox10.value = softRadiusMin .. ""
		textBox10.numbersOnly = true
		textBox10.limitsActive = true
		textBox10.numberMin = 0
		textBox10.numberMax = 1000
		
		softRadiusMinTextBox = textBox10
	end
	
	if newBox11 then
		textBox11.name = "Soft Radius Max"
		textBox11.value = softRadiusMax .. ""
		textBox11.numbersOnly = true
		textBox11.limitsActive = true
		textBox11.numberMin = 0
		textBox11.numberMax = 1000
		
		softRadiusMaxTextBox = textBox11
	end
	
	if newBox12 then
		textBox12.name = "Medium Radius Min"
		textBox12.value = mediumRadiusMin .. ""
		textBox12.numbersOnly = true
		textBox12.limitsActive = true
		textBox12.numberMin = 0
		textBox12.numberMax = 1000
		
		mediumRadiusMinTextBox = textBox12
	end
	
	if newBox13 then
		textBox13.name = "Medium Radius Max"
		textBox13.value = mediumRadiusMax .. ""
		textBox13.numbersOnly = true
		textBox13.limitsActive = true
		textBox13.numberMin = 0
		textBox13.numberMax = 1000
		
		mediumRadiusMaxTextBox = textBox13
	end
	
	if newBox14 then
		textBox14.name = "Hard Radius Min"
		textBox14.value = hardRadiusMin .. ""
		textBox14.numbersOnly = true
		textBox14.limitsActive = true
		textBox14.numberMin = 0
		textBox14.numberMax = 1000
		
		hardRadiusMinTextBox = textBox14
	end
	
	if newBox15 then
		textBox15.name = "Hard Radius Max"
		textBox15.value = hardRadiusMax .. ""
		textBox15.numbersOnly = true
		textBox15.limitsActive = true
		textBox15.numberMin = 0
		textBox15.numberMax = 1000
		
		hardRadiusMaxTextBox = textBox15
	end
	
	if newBox16 then
		textBox16.name = "Max Distance"
		textBox16.value = maxDistance .. ""
		textBox16.numbersOnly = true
		textBox16.limitsActive = true
		textBox16.numberMin = 1
		textBox16.numberMax = 1000
		
		maxDistanceTextBox = textBox16
	end
	
	if newBox17 then
		textBox17.name = "Burst Fire Max"
		textBox17.value = burstFireMax .. ""
		textBox17.numbersOnly = true
		textBox17.limitsActive = true
		textBox17.numberMin = 0
		textBox17.numberMax = 1000
		
		burstFireMaxTextBox = textBox17
	end
	
	if newBox18 then
		textBox18.name = "Hit Force"
		textBox18.value = hitForce .. ""
		textBox18.numbersOnly = true
		textBox18.limitsActive = true
		textBox18.numberMin = 0
		textBox18.numberMax = 100000
		
		hitForceTextBox = textBox18
	end
	
	if newBox19 then
		textBox19.name = "Name"
		textBox19.value = name
		textBox19.disabled = not customProfile
		textBox19.width = 300
		
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
		
		maxAmmoTextBox = textBox21
	end
end

function toggleButtons(dt)
	UiPush()
		UiTranslate(0, 50)
		
		UiPush()
			UiTranslate(-UiWidth() * (menuWidth / 4.5), 0)
		
			drawToggle("Infinite Ammo: ", infiniteAmmo, function (i) infiniteAmmo = i end)
			
			UiTranslate(0, 50)
			
			drawToggle("Infinite Mag: ", infiniteMag, function (i) infiniteMag = i end)
			
			UiTranslate(0, 50)
			
			drawToggle("Particles: ", particlesEnabled, function (i) particlesEnabled = i end)
			
			UiTranslate(0, 50)
			
			drawToggle("Hitscan bullets: ", hitscanBullets, function (i) hitscanBullets = i end)
			
			UiTranslate(0, 50)
			
			drawToggle("Apply Force To Hit Objects: ", applyForceOnHit, function (i) applyForceOnHit = i end)
		UiPop()
		
		UiPush()
			UiTranslate(UiWidth() * (menuWidth / 4.5), 0)
			
			drawToggle("Sound: ", soundEnabled, function (i) soundEnabled = i end)
			
			UiTranslate(0, 50)
			
			drawToggle("Full Auto: ", fullAuto, function (i) fullAuto = i end)
			
			UiTranslate(0, 50)
			
			drawToggle("Infinite Penetration: ", infinitePenetration, function (i) infinitePenetration = i end)
			
			UiTranslate(0, 50)
			
			drawToggle("Explosive Bullets: ", explosiveBullets, function (i) explosiveBullets = i end)
			
			UiTranslate(0, 50)
			
			drawToggle("Incendiary Bullets: ", incendiaryBullets, function (i) incendiaryBullets = i end)
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
			
			textboxClass_render(magSizeTextBox)
			
			UiTranslate(0, 50)
			
			textboxClass_render(maxAmmoTextBox)
			
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
	UiPop()
end

function centralMenu()
	UiPush()
		UiBlur(0.75)
		
		UiAlign("center middle")
		UiTranslate(UiWidth() * 0.5, UiHeight() * 0.5)
		UiImageBox("ui/hud/infobox.png", UiWidth() * menuWidth, UiHeight() * menuHeight, 10, 10)
		
		UiWordWrap(UiWidth() * menuWidth)
		
		UiTranslate(0, -UiHeight() * (menuHeight / 2))
		
		UiFont("bold.ttf", 45)
		
		UiTranslate(0, 40)
		
		UiText(toolReadableName .. " Settings")
		
		UiFont("regular.ttf", 26)
		
		setupTextBoxes()
		
		UiPush()
			UiTranslate(0, 50)
			
			textboxClass_render(nameTextBox)
			
			if nameTextBox.inputActive or nameTextBox.lastInputActive then
				name = nameTextBox.value
				
				EditCustomName(GetCurrentSelectedWeaponIndex(), name)
			end
			
			toggleButtons(dt)
			
			leftsideTextInputMenu(dt)
			middleSideTextInputMenu(dt)
			rightsideTextInputMenu(dt)
		UiPop()
		
		UiTranslate(0, UiHeight() * menuHeight * 0.9)
		
		UiPush()
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
				
					if UiTextButton("Delete Profile" , 200, 40) and customProfile then
						local currIndex = GetCurrentSelectedWeaponIndex()
					
						selectNewWeapon(1)
						DeleteCustom(currIndex)
						
						updateScrollSize()
					end
				UiPop()
				
				UiTranslate(210, 0)
				
				if UiTextButton("Copy Profile" , 200, 40) then
					CreateNewCustom(GetCurrentSelectedWeaponIndex())
					
					updateScrollSize()
				end
				
				UiTranslate(210, 0)
				
				if UiTextButton("Save Profiles" , 200, 40) then
					saveToolValues()
					saveCustomProfiles()
				end
			
				UiTranslate(210, 0)
				
				if UiTextButton("Close" , 200, 40) then
					menuCloseActions()
				end
			UiPop()
		UiPop()
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

function menu_draw(dt)
	if not isMenuOpen() then
		return
	end
	
	UiMakeInteractive()
	
	centralMenu()
	
	weaponQuickMenu()
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
	if nameTextBox ~= nil then
		nameTextBox.value = name
		nameTextBox.disabled = not customProfile
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
end

function menuCloseActions()
	menuOpened = false
	rebinding = nil
	saveToolValues()
	
	updateSavedBinds()

	saveSettings()
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