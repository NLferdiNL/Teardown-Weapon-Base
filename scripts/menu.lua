#include "datascripts/inputList.lua"
#include "datascripts/color4.lua"
#include "scripts/ui.lua"
#include "scripts/textbox.lua"
#include "scripts/utils.lua"

binds = {
	Open_Menu = "m", -- Only one that can't be changed!
}

local bindBackup = deepcopy(binds)

local bindOrder = {
}
		
local bindNames = {
	Open_Menu = "Open Menu",
}

local enabledText = "Enabled"
local disabledText = "Disabled"

local menuOpened = false
local rebinding = nil

local erasingBinds = 0

local menuWidth = 0.25
local menuHeight = 0.6

local spreadTextBox = nil
local projectilesTextBox = nil
local shotCooldownTimeTextBox = nil
local maxReloadTimeTextBox = nil
local minRndSpreadTextBox = nil
local maxRndSpreadTextBox = nil

function menu_init()
	
end

function menu_tick(dt)
	if InputPressed(binds["Open_Menu"]) and GetString("game.player.tool") == toolName then
		menuOpened = not menuOpened
		
		if not menuOpened then
			menuCloseActions()
		end
	end
	
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
		
		UiTranslate(0, -UiHeight() * menuWidth)
		
		UiFont("bold.ttf", 45)
		
		UiTranslate(0, 10)
		
		UiText(toolReadableName .. " Settings")
		
		UiFont("regular.ttf", 26)
	
		UiPush()
			UiTranslate(-UiWidth() * (menuWidth / 2), 50)
			for i = 1, #bindOrder do
				local id = bindOrder[i]
				local key = binds[id]
				drawRebindable(id, key)
				UiTranslate(0, 50)
			end
		UiPop()
		
		UiTranslate(0, 50 * (#bindOrder + 1))
		
		UiPush()
			UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
			
			if UiTextButton("Infinite Ammo: " .. (infiniteAmmo and enabledText or disabledText), 400, 40) then
				infiniteAmmo = not infiniteAmmo
			end
		UiPop()
		
		UiTranslate(0, 50)
		
		UiPush()
			UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
			
			if UiTextButton("Infinite Mag: " .. (infiniteMag and enabledText or disabledText), 400, 40) then
				infiniteMag = not infiniteMag
			end
		UiPop()
		
		UiTranslate(0, 50)
		
		UiPush()
			UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
			
			if UiTextButton("Particles: " .. (particlesEnabled and enabledText or disabledText), 400, 40) then
				particlesEnabled = not particlesEnabled
			end
		UiPop()
		
		UiTranslate(0, 50)
		
		UiPush()
			local textBox01, newBox01 = textboxClass_getTextBox(1)
			
			UiTranslate(textBox01.width, 0)

			if newBox01 then
				textBox01.name = "Spread"
				textBox01.value = spread .. ""
				textBox01.numbersOnly = true
				textBox01.limitsActive = true
				textBox01.numberMin = 0
				textBox01.numberMax = 0.1
				
				spreadTextBox = textBox01
			end
			
			local textBox02, newBox02 = textboxClass_getTextBox(2)

			if newBox02 then
				textBox02.name = "Projectiles"
				textBox02.value = projectiles .. ""
				textBox02.numbersOnly = true
				textBox02.limitsActive = true
				textBox02.numberMin = 1
				textBox02.numberMax = 100
				
				projectilesTextBox = textBox02
			end
			
			local textBox03, newBox03 = textboxClass_getTextBox(3)

			if newBox03 then
				textBox03.name = "Shot Cooldown Time"
				textBox03.value = shotCooldownTime .. ""
				textBox03.numbersOnly = true
				textBox03.limitsActive = true
				textBox03.numberMin = 0
				textBox03.numberMax = 100
				
				shotCooldownTimeTextBox = textBox03
			end
			
			local textBox04, newBox04 = textboxClass_getTextBox(4)

			if newBox04 then
				textBox04.name = "Max Reload Time"
				textBox04.value = maxReloadTime .. ""
				textBox04.numbersOnly = true
				textBox04.limitsActive = true
				textBox04.numberMin = 0
				textBox04.numberMax = 100
				
				maxReloadTimeTextBox = textBox04
			end
			
			local textBox05, newBox05 = textboxClass_getTextBox(5)

			if newBox05 then
				textBox05.name = "Min Rnd Spread"
				textBox05.value = minRndSpread .. ""
				textBox05.numbersOnly = true
				textBox05.limitsActive = true
				textBox05.numberMin = 0
				textBox05.numberMax = 100
				
				minRndSpreadTextBox = textBox05
			end
			
			local textBox06, newBox06 = textboxClass_getTextBox(6)

			if newBox06 then
				textBox06.name = "Max Rnd Spread"
				textBox06.value = maxRndSpread .. ""
				textBox06.numbersOnly = true
				textBox06.limitsActive = true
				textBox06.numberMin = 0
				textBox06.numberMax = 100
				
				maxRndSpreadTextBox = textBox06
			end
			
			textboxClass_render(textBox01)
			
			UiTranslate(0, 50)
			
			textboxClass_render(textBox02)
			
			UiTranslate(0, 50)
			
			textboxClass_render(textBox03)
			
			UiTranslate(0, 50)
			
			textboxClass_render(textBox04)
			
			UiTranslate(0, 50)
			
			textboxClass_render(textBox05)
			
			UiTranslate(0, 50)
			
			textboxClass_render(textBox06)
		UiPop()
		
		UiTranslate(0, 50 * 6)
		
		UiPush()
			UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
			
			if erasingBinds > 0 then
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
			
			UiTranslate(0, 50)
			
			if UiTextButton("Close" , 400, 40) then
				menuCloseActions()
			end
		UiPop()
	UiPop()
end

function drawRebindable(id, key)
	UiPush()
		UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
	
		UiTranslate(UiWidth() * menuWidth / 1.5, 0)
	
		UiAlign("right middle")
		UiText(bindNames[id] .. "")
		
		UiTranslate(UiWidth() * menuWidth * 0.1, 0)
		
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

function menuCloseActions()
	menuOpened = false
	rebinding = nil
	spread = tonumber(spreadTextBox.value)
	projectiles = tonumber(projectilesTextBox.value)
	shotCooldownTime = tonumber(shotCooldownTimeTextBox.value)
	maxReloadTime = tonumber(maxReloadTimeTextBox.value)
	minRndSpread = tonumber(minRndSpreadTextBox.value)
	maxRndSpread = tonumber(maxRndSpreadTextBox.value)
end

function isMenuOpen()
	return menuOpened
end

function setMenuOpen(val)
	menuOpened = val
end