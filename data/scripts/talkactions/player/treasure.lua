local treasure = TalkAction("!treasure")

function treasure.onSay(player, words, param)
    local hasAccess = player:getGroup():getAccess()
    local players = Game.getPlayers()
		player:sendTextMessage(MESSAGE_ATTENTION, "test")
    return false
end

treasure:register()
