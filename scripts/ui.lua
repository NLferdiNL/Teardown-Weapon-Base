#include "datascripts/color4.lua"

local activeDescription = nil

function c_UiColor(color4)
	UiColor(color4.r, color4.g, color4.b, color4.a)
end

function c_UiColorFilter(color4)
	UiColorFilter(color4.r, color4.g, color4.b, color4.a)
end

function c_UiTextOutline(color4, thickness)
	thickness = thickness or 0.1
	
	UiTextOutline(color4.r, color4.g, color4.b, color4.a, thickness)
end

function c_UiTextShadow(color4, distance, blur)
	distance = distance or 1.0
	blur = blur or 0.5
	
	UiTextShadow(color4.r, color4.g, color4.b, color4.a, distance, blur)
end

function c_UiButtonImageBox(path, borderWidth, borderHeight, color4)
	color4 = color4 or Color4.White
	
	UiButtonImageBox(path, borderWidth, borderHeight, color4.r, color4.g, color4.b, color4.a)
end

function c_UiButtonHoverColor(color4)
	UiButtonHoverColor(color4.r, color4.g, color4.b, color4.a)
end

function c_UiButtonPressColor(color4)
	UiButtonPressColor(color4.r, color4.g, color4.b, color4.a)
end

function drawToggle(label, value, callback, description)
	local enabledText = "Enabled"
	local disabledText = "Disabled"

	UiPush()
		UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
		
		local isInsideMe = UiIsMouseInRect(400, 40)
		
		if isInsideMe then
			activeDescription = description
		end
		
		
		if UiTextButton(label .. (value and enabledText or disabledText), 400, 40) then
			callback(not value)
		end
	UiPop()
end

function drawToggleBox(value, callback)
	UiPush()
		local image = "ui/common/box-outline-6.png"
		
		if UiImageButton(image, 120, 120) then
			callback(not value)
		end
		
		if value then
			UiPush()
				UiColorFilter(0, 1, 0)
				UiImageBox("ui/terminal/checkmark.png", 25, 25, 0, 0)
			UiPop()
		end
	UiPop()
end

function c_drawDescription(descriptionBoxMargin)
	descriptionBoxMargin = descriptionBoxMargin or 20
	
	if activeDescription == nil or activeDescription == "" then
		return
	end
	
	UiPush()
		UiFont("regular.ttf", 26)
	
		local mX, mY = UiGetMousePos()
		UiAlign("top left")
		UiTranslate(mX, mY)
		
		local textWidth, textHeight = UiGetTextSize(activeDescription)
		
		local boxWidth = mX + textWidth + descriptionBoxMargin
		
		local textOffsetX = 10
		
		if boxWidth > UiWidth() then
			UiAlign("top right")
			textOffsetX = -10
		end
		
		UiColor(1, 1, 1, 0.75)
		UiImageBox("ui/hud/infobox.png", textWidth + descriptionBoxMargin, textHeight + descriptionBoxMargin, 10, 10)
		
		UiTranslate(textOffsetX, 10)
		
		UiColor(1, 1, 1, 1)
		UiText(activeDescription)
	UiPop()
	
	activeDescription = nil
end