ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_dig:checkTool', function(source, cb, needTool)
	local xPlayer = ESX.GetPlayerFromId(source)
	local toolQuantity = xPlayer.getInventoryItem(needTool).count
	if toolQuantity > 0 then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx_dig:startDig')
AddEventHandler('esx_dig:startDig', function(breakToolPercent, ItemsTable, toolLabel, needTool)
	local ranItem = math.random(1, #ItemsTable)
	local digItem = ItemsTable[ranItem]
	
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(digItem[1])
	
	if sourceItem.limit ~= -1 and (sourceItem.count + digItem[2]) > sourceItem.limit then
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U("not_enough_place", digItem[2], digItem[3]))
	else
		xPlayer.addInventoryItem(digItem[1], digItem[2])
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U("got", digItem[2], digItem[3]))
		
		math.randomseed(GetGameTimer())
		local ranBreak = math.random(1, 100)
		if ranBreak < breakToolPercent then
			xPlayer.removeInventoryItem(needTool, 1)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U("tool_broken", toolLabel))
		end	
	end
end)