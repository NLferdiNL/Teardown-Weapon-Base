local textboxClass = {
	name = "TextBox",
	disabled = false,
	description = "",
	mouseOver = false,
	value = "",
	width = 100,
	height = 40,
	limitsActive = false,
	numberMin = 0,
	numberMax = 1,
	inputActive = false,
	lastInputActive = false,
	onInputFinished = nil,
}

local inputNumbers = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "."}
local inputLetters = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "space"}

local textboxes = {}

local descriptionBoxMargin = 20

function textboxClass_tick()
	for i = 1, #textboxes do
		local textBox = textboxes[i]
		textboxClass_inputTick(textBox)
	end
end

function disableButtonStyle()
	UiButtonImageBox("ui/common/box-outline-6.png", 6, 6, 0.25, 0.25, 0.25, 1)
	UiButtonPressColor(1, 1, 1)
	UiButtonHoverColor(1, 1, 1)
	UiButtonPressDist(0)
		
end

function textboxClass_render(me)
	if me == nil then
		return
	end

	UiPush()
		UiFont("regular.ttf", 26)
		
		local labelString = me.name
		local nameWidth, nameHeight = UiGetTextSize(labelString)
		
		UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
		
		UiPush()
			UiAlign("center right")
			UiTranslate(-nameWidth / 2 - me.width / 2, me.height / 5)
			UiText(labelString)
		UiPop()
		
		if not me.disabled then
			if textboxClass_checkMouseInRect(me) and not me.inputActive then
				UiColor(1,1,0)
			elseif me.inputActive then
				UiColor(0,1,0)
			else
				UiColor(1,1,1)
			end
		end
		
		UiPush()
			local fontSize = getMaxTextSize(me.value, 26, me.width - 2)
			
			UiFont("regular.ttf", fontSize)
			
			local tempVal = me.value
			
			if tempVal == "" then
				tempVal = " "
			end
			
			if me.disabled then
				disableButtonStyle()
			end
			
			if UiTextButton(tempVal, me.width, me.height) then
				if not me.disabled then
					me.inputActive = not me.inputActive
				end
			end
		UiPop()
		
		UiPush()
		if textboxClass_checkMouseInRect(me) and (me.description ~= nil and me.description ~= "") and not me.inputActive then
			me.mouseOver = true
		else
			me.mouseOver = false
		end
		UiPop()
	UiPop()
end

function textboxClass_drawDescriptions()
	UiPush()
		UiFont("regular.ttf", 26)
	
		for i = 1, #textboxes do
			local currentTextbox = textboxes[i]
			
			if currentTextbox.mouseOver then
				currentTextbox.mouseOver = false
				
				local mX, mY = UiGetMousePos()
				UiAlign("top left")
				UiTranslate(mX, mY)
				
				local textWidth, textHeight = UiGetTextSize(currentTextbox.description)
				
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
				UiText(currentTextbox.description)
			end
		end
	UiPop()
end

function textboxClass_getTextBox(id)
	if id == nil then
		return 
	end
	
	if id <= -1 then
		id = #textboxes + 1
	end
	local textBox = textboxes[id]
	local newBox = false
	
	if textBox == nil then
		textboxes[id] = deepcopy(textboxClass)
		textBox = textboxes[id]
		newBox = true
	end
	
	return textBox, newBox
end

 function textboxClass_inputTick(me)
	if me == nil then
		return
	end

 
	if me.inputActive ~= me.lastInputActive then
		me.lastInputActive = me.inputActive
	end

	if me.inputActive then
		if InputPressed("lmb") then
			textboxClass_setActiveState(me, textboxClass_checkMouseInRect(me))
		elseif InputPressed("return") then
			textboxClass_setActiveState(me, false)
		elseif InputPressed("backspace") then
			me.value = me.value:sub(1, #me.value - 1)
		else
			for j = 1, #inputNumbers do
				if InputPressed(inputNumbers[j]) then
					me.value = me.value .. inputNumbers[j]
				end
			end
			if not me.numbersOnly then
				for j = 1, #inputLetters do
					if InputPressed(inputLetters[j]) then
						local newLetter = inputLetters[j]
						
						if newLetter == "space" then
							newLetter = " "
						elseif InputDown("shift") then
							newLetter = newLetter:upper()
						end
						me.value = me.value .. newLetter
					end
				end
			end
		end
	end
end

function textboxClass_inputFinished(me)
	if me == nil then
		return true
	end

	return not me.inputActive and me.lastInputActive
end

function textboxClass_checkMouseInRect(me)
	if me == nil then
		return false
	end
	
	UiPush()
		UiAlign("center middle")
		local isInsideMe = UiIsMouseInRect(me.width, me.height)
	UiPop()
	
	return isInsideMe
end

function textboxClass_setActiveState(me, newState)
	if me == nil or newState == nil then
		return
	end

	me.inputActive = newState
	if not me.inputActive then
		if me.numbersOnly then
			if me.value == "" then
				me.value = me.numberMin .. ""
			end
			
			if me.limitsActive then
				local tempVal = tonumber(me.value)
				
				if tempVal == nil then
					me.value = me.numberMin
				elseif tempVal < me.numberMin then
					me.value = me.numberMin .. ""
				elseif tempVal > me.numberMax then
					me.value = me.numberMax .. ""
				end
			end
		end
		
		if me.lastInputActive and me.onInputFinished ~= nil then
			me.onInputFinished(me.value)
		end
	end
end

function textboxClass_anyInputActive()
	for i = 1, #textboxes do
		local textBox = textboxes[i]
		
		if textBox.inputActive then
			return true, i
		end
	end
end

function textboxClass_getTextBoxCount()
	return #textboxes
end

function getMaxTextSize(text, fontSize, maxSize, minFontSize)
	minFontSize = minFontSize or 1
	UiPush()
		UiFont("regular.ttf", fontSize)
		
		local currentSize = UiGetTextSize(text)
		
		while currentSize > maxSize and fontSize > minFontSize do
			fontSize = fontSize - 0.1
			UiFont("regular.ttf", fontSize)
			currentSize = UiGetTextSize(text)
		end
	UiPop()
	return fontSize, fontSize > minFontSize
end