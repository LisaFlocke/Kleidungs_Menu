--MIT License

--Copyright (c) 2019 LisaFlocke

--Permission is hereby granted, free of charge, to any person obtaining a copy
--of this software and associated documentation files (the "Software"), to deal
--in the Software without restriction, including without limitation the rights
--to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--copies of the Software, and to permit persons to whom the Software is
--furnished to do so, subject to the following conditions:

--The above copyright notice and this permission notice shall be included in all
--copies or substantial portions of the Software.

--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--SOFTWARE.

GUI = {}
MenuM = {}

MenuMs = {}

GUI.maxVisOptions = 10

GUI.titleText = {255, 255, 255, 255, 7}
GUI.titleRect = {52, 73, 94, 255}
GUI.optionText = {255, 255, 255, 255, 6}
GUI.optionRect = {40, 40, 40, 190}
GUI.scroller = {127, 140, 140, 240}

local MenuMOpen = false
local prevMenuM = nil
local curMenuM = nil
local titleTextSize = {0.85, 0.85}
local titleRectSize = {0.23, 0.085}
local optionTextSize = {0.5, 0.5}
local optionRectSize = {0.23, 0.035}
local MenuMX = 0.12
local MenuMYModify = 0.1174 -- Default: 0.1174
local MenuMYOptionDiv = 3.35 -- Default: 3.56
local MenuMYOptionAdd = 0.14 -- Default: 0.142
local selectPressed = false
local leftPressed = false
local rightPressed = false
local currentOption = 1
local optionCount = 0

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function MenuM.IsOpen() 
	return MenuMOpen == true
end

function MenuM.SetupMenuM(MenuM, title)
	MenuMs[MenuM] = {}
	MenuMs[MenuM].title = title
	MenuMs[MenuM].optionCount = 0
	MenuMs[MenuM].options = {}
	currentOption = 1
end

function MenuM.addOption(MenuM, option)
	if not (MenuMs[MenuM].title == nil) then
		MenuMs[MenuM].optionCount = MenuMs[MenuM].optionCount + 1
		MenuMs[MenuM].options[MenuMs[MenuM].optionCount] = option
	end
end

function MenuM.Switch(prevMenuM, MenuM)
	curMenuM = MenuM
	prevMenuM = prevMenuM
end

function MenuM.DisplayCurMenuM()
	if not (curMenuM == "") then
		MenuMOpen = true
		MenuM.Title(MenuMs[curMenuM].title)
		for k,v in pairs(MenuMs[curMenuM].options) do
			v()
		end
		MenuM.updateSelection()
	end
end

function GUI.Text(text, color, position, size, center)
	SetTextCentre(center)
	SetTextColour(color[1], color[2], color[3], color[4])
	SetTextFont(color[5])
	SetTextScale(size[1], size[2])
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(position[1], position[2])
end

function GUI.Rect(color, position, size)
	DrawRect(position[1], position[2], size[1], size[2], color[1], color[2], color[3], color[4])
end

function MenuM.Title(title)
	GUI.Text(title, GUI.titleText, {MenuMX, MenuMYModify - 0.02241}, titleTextSize, true)
	GUI.Rect(GUI.titleRect, {MenuMX, MenuMYModify}, titleRectSize)
end

function MenuM.Option(option)
	optionCount = optionCount + 1

	local thisOption = nil
	if(currentOption == optionCount) then
		thisOption = true
	else
		thisOption = false
	end

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(option, GUI.optionText, {MenuMX - 0.1, ((MenuMYOptionAdd - 0.018) + (optionCount / MenuMYOptionDiv) * MenuMYModify)},  optionTextSize, false)
		GUI.Rect(GUI.optionRect, { MenuMX, (MenuMYOptionAdd + (optionCount / MenuMYOptionDiv) * MenuMYModify) }, optionRectSize)
		if(thisOption) then
			GUI.Rect(GUI.scroller, { MenuMX, (MenuMYOptionAdd + (optionCount / MenuMYOptionDiv) * MenuMYModify) }, optionRectSize)
		end
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(option, GUI.optionText, {MenuMX - 0.1, ((MenuMYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuMYOptionDiv) * MenuMYModify)},  optionTextSize, false)
		GUI.Rect(GUI.optionRect, { MenuMX, (MenuMYOptionAdd + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuMYOptionDiv) * MenuMYModify) }, optionRectSize)
		if(thisOption) then
			GUI.Rect(GUI.scroller, { MenuMX, (MenuMYOptionAdd + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuMYOptionDiv) * MenuMYModify) }, optionRectSize)
		end
	end

	if (optionCount == currentOption and selectPressed) then
		return true
	end

	return false
end

function MenuM.changeMenuM(option, MenuM)
	if (MenuM.Option(option)) then
		MenuM.Switch(curMenuM, MenuM)
	end

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(">>", GUI.optionText, { MenuMX + 0.068, ((MenuMYOptionAdd - 0.018) + (optionCount / MenuMYOptionDiv) * MenuMYModify)}, optionTextSize, true)
	elseif(optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(">>", GUI.optionText, { MenuMX + 0.068, ((MenuMYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuMYOptionDiv) * MenuMYModify)}, optionTextSize, true)
	end

	if (optionCount == currentOption and selectPressed) then
		return true
	end

	return false
end

function MenuM.Bool(option, bool, cb)
	MenuM.Option(option)

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		if(bool) then
			GUI.Text("~g~ON", GUI.optionText, { MenuMX + 0.068, ((MenuMYOptionAdd - 0.018) + (optionCount / MenuMYOptionDiv) * MenuMYModify)}, optionTextSize, true)
		else
			GUI.Text("~r~OFF", GUI.optionText, { MenuMX + 0.068, ((MenuMYOptionAdd - 0.018) + (optionCount / MenuMYOptionDiv) * MenuMYModify)}, optionTextSize, true)
		end
	elseif(optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		if(bool) then
			GUI.Text("~g~ON", GUI.optionText, { MenuMX + 0.068, ((MenuMYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuMYOptionDiv) * MenuMYModify)}, optionTextSize, true)
		else
			GUI.Text("~r~OFF", GUI.optionText, { MenuMX + 0.068, ((MenuMYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuMYOptionDiv) * MenuMYModify)}, optionTextSize, true)
		end
	end

	if (optionCount == currentOption and selectPressed) then
		cb(not bool)
		return true
	end

	return false
end

function MenuM.Int(option, int, min, max, cb)
	MenuM.Option(option);

	if (optionCount == currentOption) then
		if (leftPressed) then
			if(int > min) then int = int - 1 else int = max end-- : _int = max;
		end
		if (rightPressed) then
			if(int < max) then int = int + 1 else int = min end
		end
	end

	if (currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(tostring(int), GUI.optionText, { MenuMX + 0.068, ((MenuMYOptionAdd - 0.018) + (optionCount / MenuMYOptionDiv) * MenuMYModify)}, optionTextSize, true)
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(tostring(int), GUI.optionText, { MenuMX + 0.068, ((MenuMYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuMYOptionDiv) * MenuMYModify)}, optionTextSize, true)
	end

	if (optionCount == currentOption and selectPressed) then cb(position) return true
    elseif (optionCount == currentOption and leftPressed) then cb(position)
    elseif (optionCount == currentOption and rightPressed) then cb(position) end

	return false
end

function MenuM.StringArray(option, array, position, cb)

	MenuM.Option(option);

	if (optionCount == currentOption) then
		local max = tablelength(array)
		local min = 1
		if (leftPressed) then
			if(position > min) then position = position - 1 else position = max end
		end
		if (rightPressed) then
			if(position < max) then position = position + 1 else position = min end
		end
	end

	if (currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(array[position], GUI.optionText, { MenuMX + 0.068, ((MenuMYOptionAdd - 0.018) + (optionCount / MenuMYOptionDiv) * MenuMYModify)}, optionTextSize, true)
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(array[position], GUI.optionText, { MenuMX + 0.068, ((MenuMYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuMYOptionDiv) * MenuMYModify)}, optionTextSize, true)
	end

	if (optionCount == currentOption and selectPressed) then cb(position) return true
    elseif (optionCount == currentOption and leftPressed) then cb(position)
    elseif (optionCount == currentOption and rightPressed) then cb(position) end

	return false
end


function MenuM.updateSelection()
	selectPressed = false;
	leftPressed = false;
	rightPressed = false;

	if IsControlJustPressed(1, 173)  then
		if(currentOption < optionCount) then
			currentOption = currentOption + 1
		else
			currentOption = 1
		end
	elseif IsControlJustPressed(1, 172) then
		if(currentOption > 1) then
			currentOption = currentOption - 1
		else
			currentOption = optionCount
		end
	elseif IsControlJustPressed(1, 174) then
		leftPressed = true
	elseif IsControlJustPressed(1, 175) then
		rightPressed = true
	elseif IsControlJustPressed(1, 176)  then
		selectPressed = true
	elseif IsControlJustPressed(1, 177) then
		if (prevMenuM == nil) then
			MenuM.Switch(nil, "")
			MenuMOpen = false
		end
		if not (prevMenuM == nil) then
			MenuM.Switch(nil, prevMenuM)
		end
	end
	optionCount = 0
end
