local spawnTreasureChest = CreatureEvent("SpawnTreasureChest")
function spawnTreasureChest.onKill(creature, target)
	Spdlog.warn(HUNTING_TREASURES.name .. " - Player kill monster")
	return true
end
spawnTreasureChest:register()
