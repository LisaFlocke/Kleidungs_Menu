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

RegisterNetEvent("GUI:Title")
AddEventHandler("GUI:Title", function(title)
	Menu.Title(title)
end)

RegisterNetEvent("GUI:Option")
AddEventHandler("GUI:Option", function(option, cb)
	cb(Menu.Option(option))
end)

RegisterNetEvent("GUI:Bool")
AddEventHandler("GUI:Bool", function(option, bool, cb)
	Menu.Bool(option, bool, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI:Int")
AddEventHandler("GUI:Int", function(option, int, min, max, cb)
	Menu.Int(option, int, min, max, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI:StringArray")
AddEventHandler("GUI:StringArray", function(option, array, position, cb)
	Menu.StringArray(option, array, position, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI:Update")
AddEventHandler("GUI:Update", function()
	Menu.updateSelection()
end)

Citizen.CreateThread(function()
	TriggerServerEvent("player_join")

	local Menu = false
	local bool = false
	local int = 0
	local position = 1
	local array = {""}
	
	while true do

		if(IsControlJustPressed(0, 289)) then
			Menu = not Menu
		end

		if(Menu) then
			TriggerEvent("GUI:Title", "Kleidungs Menu")
			TriggerEvent("GUI:Option", "Maske Absetzen", function(cb)		--Maske Absetzen
				if(cb) then
					SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 240, 0)	
				end
			end)
			TriggerEvent("GUI:Option", "Hüte Absetzen", function(cb)		--Hüte Absetzen
				if(cb) then
					ClearPedProp(GetPlayerPed(-1), 0, 0, 240, 0)
				end
			end)
			TriggerEvent("GUI:Option", "Brille Absetzen", function(cb)		--Brille Absetzen
				if(cb) then
					ClearPedProp(GetPlayerPed(-1), 1, 0, 240, 0)
				end
			end)
			TriggerEvent("GUI:Option", "Ohrring Absetzen", function(cb)		--Ohrring Absetzen
				if(cb) then
					ClearPedProp(GetPlayerPed(-1), 2, 0, 240, 0)
				end
			end)
			TriggerEvent("GUI:Option", "Alles Anziehen", function(cb)		--Anziehen
				if(cb) then
					TriggerServerEvent("clothes:spawn")
				end
			end)

			TriggerEvent("GUI:Update")
		end

		Wait(0)
	end
end)

