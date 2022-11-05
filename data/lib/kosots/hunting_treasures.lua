HUNTING_TREASURES ={
	name = 'Hunting Treasures',
	chance = 0.01, -- Chance to spawn
	delay = 25, -- Delay in minutes
	onlyVip = false,
}

-- Spawn treasure cheast near the player
function Player.spawnTreasureChest(self)
	Spdlog.warn(HUNTING_TREASURES.name .. " - Player spawned treasure hunt")
	if player:getVipDays() > 0 then
		Spdlog.warn(HUNTING_TREASURES.name .. " - is VIP")
	end
	return true
end

-- Check if player can spawn Treasure Chest
function Player.canSpawnTreasureChest(self)

end

-- Random a chest based on a player's level
function Player.randTreasureChest(self)

end

-- Check if item is treasure chest
function Item.isTreasureChest(self)
	return false
end

-- Fire event after user click on treasure chest
function Item.clickTreasureChest(self)
	Spdlog.warn(HUNTING_TREASURES.name .. " - Player started treasure event")
	return false
end

-- Randomize loot based on config
function Item.randomizeReward(self)
	return false
end

-- Check if creature is a treasure monster
function Monster:isTreasureMonster(self)

end



Spdlog.info(HUNTING_TREASURES.name .. " - Loaded")
