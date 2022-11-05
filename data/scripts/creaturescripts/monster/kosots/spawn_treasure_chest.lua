local spawnTreasureChest = CreatureEvent("SpawnTreasureChest")
function spawnTreasureChest.onKill(player,creature, target)
	if not player:isPlayer() or not creature:isMonster() or creature:hasBeenSummoned() or creature:isPlayer() then
		return true
	end



	Spdlog.warn(HUNTING_TREASURES.name .. " - Player kill monster")
	if player.isVip() then
		Spdlog.warn(HUNTING_TREASURES.name .. " - VIP")
	end

	return true
end
spawnTreasureChest:register()
