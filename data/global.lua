math.randomseed(os.time())
dofile('data/lib/lib.lua')

NOT_MOVEABLE_ACTION = 100
PARTY_PROTECTION = 1 -- Set to 0 to disable.
ADVANCED_SECURE_MODE = 1 -- Set to 0 to disable.

STORAGEVALUE_PROMOTION = 30018

SERVER_NAME = configManager.getString(configKeys.SERVER_NAME)

-- Bestiary charm
GLOBAL_CHARM_GUT = 0
GLOBAL_CHARM_SCAVENGE = 0

--WEATHER
weatherConfig = {
	groundEffect = CONST_ME_LOSEENERGY,
	fallEffect = CONST_ANI_SMALLICE,
	thunderEffect = configManager.getBoolean(configKeys.WEATHER_THUNDER),
	minDMG = 1,
	maxDMG = 5
}

-- Event Schedule
SCHEDULE_LOOT_RATE = 0
SCHEDULE_EXP_RATE = 0
SCHEDULE_SKILL_RATE = 0
SCHEDULE_SPAWN_RATE = 0

-- MARRY
PROPOSED_STATUS = 1
MARRIED_STATUS = 2
PROPACCEPT_STATUS = 3
LOOK_MARRIAGE_DESCR = TRUE
ITEM_WEDDING_RING = 3004
ITEM_ENGRAVED_WEDDING_RING = 9585

-- Scarlett Etzel
SCARLETT_MAY_TRANSFORM = 0
SCARLETT_MAY_DIE = 0

ropeSpots = {386, 421, 386, 7762, 12202, 12936, 14238, 17238, 23363, 21965, 21966, 21967, 21968}
specialRopeSpots = { 12935 }

-- Impact Analyser
-- Every 2 seconds
updateInterval = 2
-- Healing
-- Global table to insert data
healingImpact = {}
-- Damage
-- Global table to insert data
damageImpact = {}

startupGlobalStorages = {
	GlobalStorage.TheAncientTombs.AshmunrahSwitchesGlobalStorage,
	GlobalStorage.TheAncientTombs.DiprathSwitchesGlobalStorage,
	GlobalStorage.TheAncientTombs.ThalasSwitchesGlobalStorage,
	GlobalStorage.HeroRathleton.FirstMachines,
	GlobalStorage.HeroRathleton.SecondMachines,
	GlobalStorage.HeroRathleton.ThirdMachines,
	GlobalStorage.HeroRathleton.DeepRunning,
	GlobalStorage.HeroRathleton.HorrorRunning,
	GlobalStorage.HeroRathleton.LavaRunning,
	GlobalStorage.HeroRathleton.MaxxenRunning,
	GlobalStorage.HeroRathleton.LavaCounter,
	GlobalStorage.HeroRathleton.FourthMachines,
	GlobalStorage.FerumbrasAscendant.Crystals.Crystal1,
	GlobalStorage.FerumbrasAscendant.Crystals.Crystal2,
	GlobalStorage.FerumbrasAscendant.Crystals.Crystal3,
	GlobalStorage.FerumbrasAscendant.Crystals.Crystal4,
	GlobalStorage.FerumbrasAscendant.Crystals.Crystal5,
	GlobalStorage.FerumbrasAscendant.Crystals.Crystal6,
	GlobalStorage.FerumbrasAscendant.Crystals.Crystal7,
	GlobalStorage.FerumbrasAscendant.Crystals.Crystal8,
	GlobalStorage.FerumbrasAscendant.Crystals.AllCrystals,
	GlobalStorage.FerumbrasAscendant.FerumbrasEssence,
	GlobalStorage.Feroxa.Active,
	GlobalStorage.FerumbrasAscendant.Habitats.AllHabitats,
	GlobalStorage.FerumbrasAscendant.Elements.Active,
	GlobalStorage.FerumbrasAscendant.Elements.First,
	GlobalStorage.FerumbrasAscendant.Elements.Second,
	GlobalStorage.FerumbrasAscendant.Elements.Third,
	GlobalStorage.FerumbrasAscendant.Elements.Done
}

table.contains = function(array, value)
	for _, targetColumn in pairs(array) do
		if targetColumn == value then
			return true
		end
	end
	return false
end

string.split = function(str, sep)
	local res = {}
	for v in str:gmatch("([^" .. sep .. "]+)") do
		res[#res + 1] = v
	end
	return res
end

string.splitTrimmed = function(str, sep)
	local res = {}
	for v in str:gmatch("([^" .. sep .. "]+)") do
		res[#res + 1] = v:trim()
	end
	return res
end

string.trim = function(str)
	return str:match'^()%s*$' and '' or str:match'^%s*(.*%S)'
end

-- Stamina
if nextUseStaminaTime == nil then
	nextUseStaminaTime = {}
end

if nextUseXpStamina == nil then
	nextUseXpStamina = {}
end

if lastItemImbuing == nil then
	lastItemImbuing = {}
end

-- Delay potion
if not playerDelayPotion then
	playerDelayPotion = {}
end

-- for use of: data\scripts\globalevents\customs\save_interval.lua
SAVE_INTERVAL_TYPE = configManager.getString(configKeys.SAVE_INTERVAL_TYPE)
SAVE_INTERVAL_CONFIG_TIME = configManager.getNumber(configKeys.SAVE_INTERVAL_TIME)
SAVE_INTERVAL_TIME = 0
if SAVE_INTERVAL_TYPE == "second" then
	SAVE_INTERVAL_TIME = 1000
elseif SAVE_INTERVAL_TYPE == "minute" then
	SAVE_INTERVAL_TIME = 60 * 1000
elseif SAVE_INTERVAL_TYPE == "hour" then
	SAVE_INTERVAL_TIME = 60 * 60 * 1000
end

-- Increase Stamina when Attacking Trainer
staminaBonus = {
	target = 'Training Machine',
	period = configManager.getNumber(configKeys.STAMINA_TRAINER_DELAY) * 60 * 1000, -- time on miliseconds trainers
	bonus = configManager.getNumber(configKeys.STAMINA_TRAINER_GAIN), -- gain stamina trainers
	eventsTrainer = {}, -- stamina in trainers
	eventsPz = {} -- stamina in Pz
}

function addStamina(playerId, ...)
	-- Creature:onTargetCombat
	if playerId then
		local player = Player(playerId)
		if configManager.getBoolean(configKeys.STAMINA_TRAINER) then
			if not player then
				staminaBonus.eventsTrainer[playerId] = nil
			else
				local target = player:getTarget()
				if not target or target:getName() ~= staminaBonus.target then
					staminaBonus.eventsTrainer[playerId] = nil
				else
					player:setStamina(player:getStamina() + staminaBonus.bonus)
					player:sendTextMessage(MESSAGE_STATUS,
																string.format("%i of stamina has been refilled.",
																configManager.getNumber(configKeys.STAMINA_TRAINER_GAIN)))
					staminaBonus.eventsTrainer[playerId] = addEvent(addStamina, staminaBonus.period, playerId)
				end
			end
		end
		return not configManager.getBoolean(configKeys.STAMINA_TRAINER)
	end

	-- Player:onChangeZone
	local localPlayerId, delay = ...

	if localPlayerId and delay then
		if not staminaBonus.eventsPz[localPlayerId] then return false end
		stopEvent(staminaBonus.eventsPz[localPlayerId])

		local player = Player(localPlayerId)
		if not player then
			staminaBonus.eventsPz[localPlayerId] = nil
			return false
		end

		local actualStamina = player:getStamina()

		if actualStamina > 2400 and actualStamina < 2520 then
			delay = configManager.getNumber(configKeys.STAMINA_GREEN_DELAY) * 60 * 1000 -- Stamina Green 12 min.
		elseif actualStamina == 2520 then
			player:sendTextMessage(MESSAGE_STATUS, "You are no longer refilling stamina, \z
                                                         because your stamina is already full.")
			staminaBonus.eventsPz[localPlayerId] = nil
			return false
		end

		player:setStamina(player:getStamina() + configManager.getNumber(configKeys.STAMINA_PZ_GAIN))
		player:sendTextMessage(MESSAGE_STATUS,
                               string.format("%i of stamina has been refilled.",
                                             configManager.getNumber(configKeys.STAMINA_PZ_GAIN)
                               )
        )
		staminaBonus.eventsPz[localPlayerId] = addEvent(addStamina, delay, nil, localPlayerId, delay)
		return true
	end
	return false
end

-- Exercise Training
onExerciseTraining = {}
