ESX = exports["es_extended"]:getSharedObject()
bossPeds = {}
pedsCreated = false
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    else 
        MySQL.Async.execute('DELETE FROM fakeid;', function() end)
    end
end)

lib.callback.register('tizid:getnames', function(meow)
    local restultas = lib.callback('tizid:getpeds', false)
    if restultas ~= "" then
        return true
    else
        return false
    end
end)
lib.callback.register('tizid:canpay', function(canPay)
    local playerId = source
    local money = exports.ox_inventory:GetItemCount(playerId, Config.PaymentType)

    if money >= Config.Price then
        return true
    else
        return false
    end
end)
RegisterNetEvent('tizid:giveid')
AddEventHandler("tizid:giveid", function(playerID, input)
    local _source = source  
    local xPlayer = ESX.GetPlayerFromId(_source)
    local newnamas = table.concat(input, ' ',1,2)
    local dob = table.concat(input, '', 3,3)
    local gender = table.concat(input, '', 4,4)
    local category = table.concat(input, '', 5,5)
    local height = table.concat(input, '', 6)

    MySQL.Async.execute('INSERT INTO fakeid (id, oldname, newname, type, dob, gender, category, height) VALUES (@id, @oldname, @newname, @type, @dob, @gender, @category, @height)', -- (id, oldname, newname, type, dob) -- (@id, @oldname, @newname, @type, @)
    {
        ['id']   = xPlayer.identifier,
        ['oldname']   = xPlayer.getName(),
        ['newname'] = newnamas,
        ['type'] = 'fakeid',
        ['dob'] = dob,
        ['gender'] = gender,
        ['category'] = category,
        ['height'] = height,
    }, function ()
    end)
end)
RegisterNetEvent('tizid:payment')
AddEventHandler("tizid:payment", function(playerID)
    local playerId = source
    exports.ox_inventory:RemoveItem(playerId, Config.PaymentType, Config.Price)
end)
--ID Open
ESX = exports["es_extended"]:getSharedObject()
-- Open ID card
RegisterServerEvent('tizid:openserver')
AddEventHandler('tizid:openserver', function(ID, targetID, type, mugshotass)
	local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source 	 = ESX.GetPlayerFromId(targetID).source
    local mugshots = mugshotass
	local show       = false
	MySQL.Async.fetchAll('SELECT newname, dob, gender, category, height, type FROM fakeid WHERE id = @identifier', {['@identifier'] = identifier},
	function (user)
		if (user[1] ~= nil) and type ~= nil then
            for i=1, #user, 1 do
                if type == 'fakeid' then
                    show = true
                end
            end
			if show then
				local array = {
					user = user,
				}
				TriggerClientEvent('tizid:openclient', _source, array, type, mugshots)
            end
		end
	end)
end)
lib.callback.register('tizid:checklicense', function(hasLicense)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier 
	local hasLicense = MySQL.prepare.await('SELECT `type` FROM `fakeid` WHERE `id` = ?', {
        identifier
    })
	if hasLicense == 'fakeid' then
        return false
    else 
        return true
    end
end)
