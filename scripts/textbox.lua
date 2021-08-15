textboxClass = {
	inputNumbers = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "."},
	inputLetters = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"},
	
	textboxes = { },
	
	default = {
		name = "TextBox",
		value = "",
		width = 100,
		height = 40,
		limitsActive = false,
		numberMin = 0,
		numberMax = 1,
		inputActive = false,
		lastInputActive = false,
	},
}

function textboxClass_tick()
	for i = 1, #textboxClass.textboxes do
		local textBox = textboxClass.textboxes[i]
		textboxClass_inputTick(textBox)
	end
end

function textboxClass_render(me)
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
	
	if textboxClass_checkMouseInRect(me) and not me.inputActive then
		UiColor(1,1,0)
	elseif me.inputActive then
		UiColor(0,1,0)
	else
		UiColor(1,1,1)
	end
	
	UiPush()
		local fontSize = getMaxTextSize(me.value, 26, me.width - 2)
		
		if fontSize ~= 26 then
			DebugWatch("size", fontSize)
		end
		
		UiFont("regular.ttf", fontSize)
		
		local tempVal = me.value
		
		if tempVal == "" then
			tempVal = " "
		end
		
		if UiTextButton(tempVal, me.width, me.height) then
			me.inputActive = not me.inputActive
		end
	UiPop()
UiPop()
end

function textboxClass_getTextBox(id)
	if id <= -1 then
		id = #textboxes + 1
	end
	local textBox = textboxClass.textboxes[id]
	local newBox = false
	
	if textBox == nil then
		textboxClass.textboxes[id] = deepcopy(textboxClass.default)
		textBox = textboxClass.textboxes[id]
		newBox = true
	end
	
	return textBox, newBox
end

 function textboxClass_inputTick(me)
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
			for j = 1, #textboxClass.inputNumbers do
				if InputPressed(textboxClass.inputNumbers[j]) then
					me.value = me.value .. textboxClass.inputNumbers[j]
				end
			end
			if not me.numbersOnly then
				for j = 1, #textboxClass.inputLetters do
					if InputPressed(textboxClass.inputLetters[j]) then
						me.value = me.value .. textboxClass.inputLetters[j]
					end
				end
			end
		end
	end
end

function textboxClass_inputFinished(me)
	return not me.inputActive and me.lastInputActive
end

function textboxClass_checkMouseInRect(me)
	return UiIsMouseInRect(me.width, me.height)
end

function textboxClass_setActiveState(me, newState)
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
	end
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