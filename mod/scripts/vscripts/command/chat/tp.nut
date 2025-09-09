global function ServerChatCommand_Tp_Init

void function ServerChatCommand_Tp_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
    
    AddServerChatCommandCallback("/tp", ServerChatCommand_Tp)
}

void function ServerChatCommand_Tp(entity adminPlayer, array<string> args)
{
    if(!SSOM_IsPlayerAdmin(adminPlayer))
    {
        SSOM_ChatServerPrivateMessage(adminPlayer, "你没有管理员权限")
        return
    }

    if(args.len() != 2)
        return

    array<entity> teleportPlayers = []
    string subjectName = args[0]
    string targetName = args[1]

    if(subjectName.tolower() == "all")
    {
        teleportPlayers = GetPlayerArray()
    }
    else
    {
        teleportPlayers = FindPlayersByNamePrefix(subjectName)
        if(teleportPlayers.len() == 0)
        {
            SSOM_ChatServerPrivateMessage(adminPlayer, "未找到玩家 " + subjectName)
            return
        }
    }
       
    entity targetPlayer = FindPlayerByNamePrefix(targetName)
    if(!IsValid(targetPlayer) && !IsAlive(targetPlayer))
    {
        SSOM_ChatServerPrivateMessage(adminPlayer, "未找到玩家 " + targetName)
        return
    }

    int teleportedCount = 0
    foreach(player in teleportPlayers)
    {
        if(IsValid(player) && IsAlive(player))
        {
            thread SSOM_TeleportPlayerToPlayer(player, targetPlayer)
            teleportedCount++
        }
        else
        {
            SSOM_ChatServerPrivateMessage(adminPlayer, "玩家 " + player.GetPlayerName() + " 跳过传送")
        }
    }

    if (subjectName.tolower() == "all")
        SSOM_ChatServerPrivateMessage(adminPlayer, "已传送玩家（共" + teleportedCount + "人）到 " + targetPlayer.GetPlayerName())
    else
        SSOM_ChatServerPrivateMessage(adminPlayer, "已传送玩家 " + teleportPlayers[0].GetPlayerName() + " 到 " + targetPlayer.GetPlayerName())
}

void function SSOM_TeleportPlayerToPlayer(entity playerToTeleport, entity destinationPlayer)
{
    vector destinationOrigin = destinationPlayer.GetOrigin()

    playerToTeleport.SetInvulnerable()
    destinationPlayer.SetInvulnerable()

    WaitEndFrame()
    EmitSoundOnEntity(playerToTeleport, "Timeshift_Scr_DeviceShift2Present")

    wait 0.25
    playerToTeleport.SetOrigin(destinationOrigin)
    playerToTeleport.ClearInvulnerable()
    destinationPlayer.ClearInvulnerable()
}