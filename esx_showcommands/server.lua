PlayerData                = {}

ESX                             = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData() == nil do
		Citizen.Wait(10)
	end

  	PlayerData = ESX.GetPlayerData()
end)

local function getMoneyFromUser(id_user)
	local xPlayer = ESX.GetPlayerFromId(id_user)
	return xPlayer.getMoney()

end

local function getBlackMoneyFromUser(id_user)
		local xPlayer = ESX.GetPlayerFromId(id_user)
		local account = xPlayer.getAccount('black_money')
	return account.money

end

local function getBankFromUser(id_user)
		local xPlayer = ESX.GetPlayerFromId(id_user)
		local account = xPlayer.getAccount('bank')
	return account.money

end
	
TriggerEvent('es:addCommand', 'showjob', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.label
    local jobgrade = xPlayer.job.grade_label

TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You are working as: ' .. job .. ' - ' .. jobgrade})  
end, {help = "Check what job you have"})

TriggerEvent('es:addCommand', 'showcash', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local wallet 		= getMoneyFromUser(_source)

TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You currently have $' .. wallet .. ' in your wallet'})
end, {help = "Check how much is in your wallet"})

TriggerEvent('es:addCommand', 'showbank', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local bank 			= getBankFromUser(_source)

TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You currently have $' .. bank .. ' in your bank'})
end, {help = "Check how much is in your bank"})

TriggerEvent('es:addCommand', 'showdirty', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local black_money 	= getBlackMoneyFromUser(_source)

TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You currently have $' .. black_money .. ' dirty money in your wallet'})
end, {help = "Check how much dirty money you have"})

TriggerEvent('es:addCommand', 'showsociety', function(source)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.job.grade_name == 'boss' then
		local society = GetSociety(xPlayer.job.name)

		if society ~= nil then
			TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
				money = account.money
			end)
		else
			money = 0
		end
		
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You currently have $' .. money .. ' in the society account'})
																	
	else

		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Access not granted!'})
																			
	end
end, {help = "Check your society's balance"})

TriggerEvent('esx_society:getSocieties', function(societies) 
	RegisteredSocieties = societies
end)

function GetSociety(name)
  for i=1, #RegisteredSocieties, 1 do
    if RegisteredSocieties[i].name == name then
      return RegisteredSocieties[i]
    end
  end
end

