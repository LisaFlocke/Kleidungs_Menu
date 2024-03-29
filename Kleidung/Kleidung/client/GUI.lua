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
Menu = {}

Menus = {}

GUI.maxVisOptions = 10

GUI.titleText = {255, 255, 255, 255, 7}
GUI.titleRect = {52, 73, 94, 255}
GUI.optionText = {255, 255, 255, 255, 6}
GUI.optionRect = {40, 40, 40, 190}
GUI.scroller = {127, 140, 140, 240}

local MenuOpen = false
local prevMenu = nil
local curMenu = nil
local titleTextSize = {0.85, 0.85}
local titleRectSize = {0.23, 0.085}
local optionTextSize = {0.5, 0.5}
local optionRectSize = {0.23, 0.035}
local MenuX = 0.12
local MenuYModify = 0.1174 -- Default: 0.1174
local MenuYOptionDiv = 3.35 -- Default: 3.56
local MenuYOptionAdd = 0.14 -- Default: 0.142
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

function Menu.IsOpen() 
	return MenuOpen == true
end

function Menu.SetupMenu(Menu, title)
	Menus[Menu] = {}
	Menus[Menu].title = title
	Menus[Menu].optionCount = 0
	Menus[Menu].options = {}
	currentOption = 1
end

function Menu.addOption(Menu, option)
	if not (Menus[Menu].title == nil) then
		Menus[Menu].optionCount = Menus[Menu].optionCount + 1
		Menus[Menu].options[Menus[Menu].optionCount] = option
	end
end

function Menu.Switch(prevMenu, Menu)
	curMenu = Menu
	prevMenu = prevMenu
end

function Menu.DisplayCurMenu()
	if not (curMenu == "") then
		MenuOpen = true
		Menu.Title(Menus[curMenu].title)
		for k,v in pairs(Menus[curMenu].options) do
			v()
		end
		Menu.updateSelection()
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

function Menu.Title(title)
	GUI.Text(title, GUI.titleText, {MenuX, MenuYModify - 0.02241}, titleTextSize, true)
	GUI.Rect(GUI.titleRect, {MenuX, MenuYModify}, titleRectSize)
end

function Menu.Option(option)
	optionCount = optionCount + 1

	local thisOption = nil
	if(currentOption == optionCount) then
		thisOption = true
	else
		thisOption = false
	end

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(option, GUI.optionText, {MenuX - 0.1, ((MenuYOptionAdd - 0.018) + (optionCount / MenuYOptionDiv) * MenuYModify)},  optionTextSize, false)
		GUI.Rect(GUI.optionRect, { MenuX, (MenuYOptionAdd + (optionCount / MenuYOptionDiv) * MenuYModify) }, optionRectSize)
		if(thisOption) then
			GUI.Rect(GUI.scroller, { MenuX, (MenuYOptionAdd + (optionCount / MenuYOptionDiv) * MenuYModify) }, optionRectSize)
		end
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(option, GUI.optionText, {MenuX - 0.1, ((MenuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuYOptionDiv) * MenuYModify)},  optionTextSize, false)
		GUI.Rect(GUI.optionRect, { MenuX, (MenuYOptionAdd + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuYOptionDiv) * MenuYModify) }, optionRectSize)
		if(thisOption) then
			GUI.Rect(GUI.scroller, { MenuX, (MenuYOptionAdd + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuYOptionDiv) * MenuYModify) }, optionRectSize)
		end
	end

	if (optionCount == currentOption and selectPressed) then
		return true
	end

	return false
end

function Menu.changeMenu(option, Menu)
	if (Menu.Option(option)) then
		Menu.Switch(curMenu, Menu)
	end

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(">>", GUI.optionText, { MenuX + 0.068, ((MenuYOptionAdd - 0.018) + (optionCount / MenuYOptionDiv) * MenuYModify)}, optionTextSize, true)
	elseif(optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(">>", GUI.optionText, { MenuX + 0.068, ((MenuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuYOptionDiv) * MenuYModify)}, optionTextSize, true)
	end

	if (optionCount == currentOption and selectPressed) then
		return true
	end

	return false
end

function Menu.Bool(option, bool, cb)
	Menu.Option(option)

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		if(bool) then
			GUI.Text("~g~ON", GUI.optionText, { MenuX + 0.068, ((MenuYOptionAdd - 0.018) + (optionCount / MenuYOptionDiv) * MenuYModify)}, optionTextSize, true)
		else
			GUI.Text("~r~OFF", GUI.optionText, { MenuX + 0.068, ((MenuYOptionAdd - 0.018) + (optionCount / MenuYOptionDiv) * MenuYModify)}, optionTextSize, true)
		end
	elseif(optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		if(bool) then
			GUI.Text("~g~ON", GUI.optionText, { MenuX + 0.068, ((MenuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuYOptionDiv) * MenuYModify)}, optionTextSize, true)
		else
			GUI.Text("~r~OFF", GUI.optionText, { MenuX + 0.068, ((MenuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuYOptionDiv) * MenuYModify)}, optionTextSize, true)
		end
	end

	if (optionCount == currentOption and selectPressed) then
		cb(not bool)
		return true
	end

	return false
end

function Menu.Int(option, int, min, max, cb)
	Menu.Option(option);

	if (optionCount == currentOption) then
		if (leftPressed) then
			if(int > min) then int = int - 1 else int = max end-- : _int = max;
		end
		if (rightPressed) then
			if(int < max) then int = int + 1 else int = min end
		end
	end

	if (currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(tostring(int), GUI.optionText, { MenuX + 0.068, ((MenuYOptionAdd - 0.018) + (optionCount / MenuYOptionDiv) * MenuYModify)}, optionTextSize, true)
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(tostring(int), GUI.optionText, { MenuX + 0.068, ((MenuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuYOptionDiv) * MenuYModify)}, optionTextSize, true)
	end

	if (optionCount == currentOption and selectPressed) then cb(position) return true
    elseif (optionCount == currentOption and leftPressed) then cb(position)
    elseif (optionCount == currentOption and rightPressed) then cb(position) end

	return false
end

function Menu.StringArray(option, array, position, cb)

	Menu.Option(option);

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
		GUI.Text(array[position], GUI.optionText, { MenuX + 0.068, ((MenuYOptionAdd - 0.018) + (optionCount / MenuYOptionDiv) * MenuYModify)}, optionTextSize, true)
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(array[position], GUI.optionText, { MenuX + 0.068, ((MenuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / MenuYOptionDiv) * MenuYModify)}, optionTextSize, true)
	end

	if (optionCount == currentOption and selectPressed) then cb(position) return true
    elseif (optionCount == currentOption and leftPressed) then cb(position)
    elseif (optionCount == currentOption and rightPressed) then cb(position) end

	return false
end


function Menu.updateSelection()
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
		if (prevMenu == nil) then
			Menu.Switch(nil, "")
			MenuOpen = false
		end
		if not (prevMenu == nil) then
			Menu.Switch(nil, prevMenu)
		end
	end
	optionCount = 0
end