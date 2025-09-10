global function ServerChatCommand_Tp_Init

void function ServerChatCommand_Tp_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
    
    AddServerChatCommandCallback("/tp", ServerChatCommand_Tp)
}

void function ServerChatCommand_Tp(entity player, array<string> args)
{
    if(!SSOM_IsPlayerAdmin(player)){
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限")
        return
    }

    if(args.len() != 2){
        SSOM_ChatServerPrivateMessage(player, "用法：/tf < playerName/all > < playerName >")
        return
    }

    string command0 = args[0]
    string command1 = args[1]

    array<entity> teleports = []
    switch(command0.tolower()){
        case "all":
            teleports = GetPlayerArray()
            break
        default:
            teleports = GetPlayersByNamePrefix(command0)
            break
    }

    if (teleports.len() == 0 ){
        SSOM_ChatServerPrivateMessage(player, "未找到玩家: " + command0)
        return
    }
       
    entity target = GetPlayerByNamePrefix(command1)
    if( !IsValid(target) || !IsAlive(target) ){
        SSOM_ChatServerPrivateMessage(player, "未找到玩家: " + command0)
        return
    }

    foreach(teleport in teleports){
        if( teleport == player )
            continue
        if( !IsValid(teleport) || !IsAlive(teleport) ){
            SSOM_ChatServerPrivateMessage(player, "玩家 " + teleport.GetPlayerName() + " 跳过传送")
            continue
        }
        thread SSOM_TeleportPlayerToPlayer(teleport, target)
        SSOM_ChatServerPrivateMessage(player, "已传送玩家 " + teleport.GetPlayerName() + " 到 " + target.GetPlayerName())
    }
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