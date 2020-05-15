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
AddEventHandler('esx_dig:startDig', function(breakToolPercent, digLabel, toolLabel, digItem, ItemAmount, needTool)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(digItem)
	
	if sourceItem.limit ~= -1 and (sourceItem.count + ItemAmount) > sourceItem.limit then
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U("not_enough_place", ItemAmount, digLabel))
	else
		xPlayer.addInventoryItem(digItem, ItemAmount)
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U("got", ItemAmount, digLabel))
		
		math.randomseed(GetGameTimer())
		local ranBreak = math.random(1, 100)
		if ranBreak < breakToolPercent then
			xPlayer.removeInventoryItem(needTool, 1)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U("tool_broken", toolLabel))
		end	
	end
end)