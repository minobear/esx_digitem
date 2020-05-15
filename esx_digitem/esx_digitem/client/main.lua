ESX = nil
local Place = {}
local digging = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	CreateBlips()
	while true do			
		for k,v in pairs(Config.Digs) do
			local count = 0			
			if #Place == 0 then
				for i=1, (v.maxSpawn/3) do
					Wait(100)
					RandomSpawn(k, v.x, v.y, v.areaRange)
				end
			else
				for i=1, #Place do				
					if Place[i].key == k then
						count = count + 1
					end		
				end
				if count == 0 then
					for i=1, (v.maxSpawn/3) do
						Wait(100)
						RandomSpawn(k, v.x, v.y, v.areaRange)
					end					
				elseif count < v.maxSpawn then
					RandomSpawn(k, v.x, v.y, v.areaRange)				
				end					
			end
		end	
		Wait(math.random(Config.SpawnWaitMin, Config.SpawnWaitMax))			
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		for k,v in pairs(Place) do
			DrawMarker(28, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 204, 102, 0, 100, false, false, 2, false, false, false, false)
		end
		if digging then
			DisableViolentActions()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if not digging then
			for k,v in pairs(Place) do
				local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
				local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z)

				if dist <= 1.3 then
					for i=1, #Config.Digs do
						if i == v.key then
							hintToDisplay(_U("press_dig", Config.Digs[i].digLabel))					
							if IsControlJustReleased (0, 38) then		
								ESX.TriggerServerCallback("esx_dig:checkTool", function(hasItem)
									if hasItem then
										local playerPed = PlayerPedId()									
										TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_GARDENER_PLANT", 0, true)
										digging = true
										Wait(Config.DigTime)
										ClearPedTasks(playerPed)
										digging = false
										TriggerServerEvent("esx_dig:startDig", Config.Digs[i].breakToolPercent, Config.Digs[i].digLabel, Config.Digs[i].toolLabel, Config.Digs[i].digItem[1], Config.Digs[i].digItem[2], Config.Digs[i].needTool)
										table.remove(Place, k)
									else
										ESX.ShowNotification(_U("no_tools", Config.Digs[i].toolLabel))
									end
								end, Config.Digs[i].needTool)
							end
						end
					end
				end
			end
		end
	end
end)

function CreateBlips()
	for k,v in pairs(Config.Digs) do
		if v.blips then
			local bool = true			
			if bool then
				zoneblip = AddBlipForRadius(v.x,v.y,v.z, v.areaRange*30.0)
				SetBlipSprite(zoneblip, 1)
				SetBlipColour(zoneblip, 16)
				SetBlipAlpha(zoneblip, 75)	
				
				v.blip = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(v.blip, 483)
				SetBlipDisplay(v.blip, 4)
				SetBlipColour(v.blip, 16)
				SetBlipScale(v.blip, 0.7)
				SetBlipAsShortRange(v.blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.blipName)
				EndTextCommandSetBlipName(v.blip)
				bool = false			
			end
		end
	end	
end

function RandomSpawn(key, x, y, areaRange)	
	local isGoodPlace = true

	math.randomseed(GetGameTimer())
	local ranX = x+(math.random(-areaRange, areaRange))

	Citizen.Wait(100)

	math.randomseed(GetGameTimer())
	local ranY = y+(math.random(-areaRange, areaRange))

	local ranZ = GetCoordZ(ranX, ranY)
	if #Place > 0 then
		for k,v in pairs(Place) do
			if v.key == key then
				if GetDistanceBetweenCoords(ranX,ranY,ranZ, v.x,v.y,v.z, true) < 5 then
					isGoodPlace = false
					break
				end
			end
		end
		if isGoodPlace then
			table.insert(Place, {key = key, x = ranX, y = ranY, z = ranZ})
		else
			RandomSpawn(key, x, y, areaRange)
		end
	else
		table.insert(Place, {key = key, x = ranX, y = ranY, z = ranZ})
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
		if foundGround then
			return z
		end
	end

	return 43.0
end

function DisableViolentActions()
	local playerPed = PlayerPedId()

	if disable_actions == true then
		DisableAllControlActions(0)
	end

	DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
	DisablePlayerFiring(playerPed,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
    DisableControlAction(0, 106, true) -- Disable in-game mouse controls
    DisableControlAction(0, 140, true)
	DisableControlAction(0, 141, true)
	DisableControlAction(0, 142, true)
	DisableControlAction(0, 77, true)
	DisableControlAction(0, 26, true)
	DisableControlAction(0, 36, true)	
	DisableControlAction(0, 45, true)
	DisableControlAction(0, 83, true)
	EnableControlAction(0, 249, true)

	if IsDisabledControlJustPressed(2, 37) then --if Tab is pressed, send error message
		SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true) -- if tab is pressed it will set them to unarmed (this is to cover the vehicle glitch until I sort that all out)
	end

	if IsDisabledControlJustPressed(0, 106) then --if LeftClick is pressed, send error message
		SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true) -- If they click it will set them to unarmed
	end
end

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end