local ChatMutePlayers = {}
local MetaPlayer = FindMetaTable("Player")

--- Determines whether a player should be muted.
-- @param ply Player in question.
-- @param txt Not used.
-- @param tChat Not used.
-- @param pIsDead Not used.
-- @return true if the player is muted and false otherwise.
local function ShouldBlockChat(ply, txt, tChat, pIsDead)
  if table.HasValue(ChatMutePlayers, ply) then
    return true
  end
end
hook.Add("OnPlayerChat", "CheckIsChatMuted", ShouldBlockChat)

-- Checks if a player is muted.
-- @return true if the player is muted and false otherwise.
function MetaPlayer:IsChatMuted()
  if table.HasValue(ChatMutePlayers, self) then
    return true
  else
    return false
  end
end

--- Toggles a players mute status. If the player is unmuted, they will be muted.
-- If the player is already muted, they will be unmuted.
function MetaPlayer:SetChatMuted()
  local target = self
  if not target then
    return
  end

  if target:IsPlayer() and not table.HasValue(ChatMutePlayers, target) then
    table.insert(ChatMutePlayers, target)
  elseif target:IsPlayer() and table.HasValue(ChatMutePlayers, target) then
    for _, ply in pairs(ChatMutePlayers) do
      if ply == target then
	table.remove(ChatMutePlayers, _)
      end
    end
  end
end
