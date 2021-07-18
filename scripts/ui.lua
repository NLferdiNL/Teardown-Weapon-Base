#include "datascripts/color4.lua"

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

function drawToggle(label, value, callback)
	local enabledText = "Enabled"
	local disabledText = "Disabled"

	UiPush()
		UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
		
		if UiTextButton(label .. (value and enabledText or disabledText), 400, 40) then
			callback(not value)
		end
	UiPop()
end