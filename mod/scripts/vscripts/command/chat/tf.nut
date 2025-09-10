global function ServerChatCommand_Tf_Init
global function SSOM_Titanfall

void function ServerChatCommand_Tf_Init()
{
    if (IsLobby() || IsMenuLevel())
        return
    
    AddServerChatCommandCallback("/tf", ServerChatCommand_Tf)
}

void function ServerChatCommand_Tf(entity player, array<string> args)
{
    if(!SSOM_IsPlayerAdmin(player))
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限")
        return
    }

    if(args.len() != 1){
        SSOM_ChatServerPrivateMessage(player, "用法：/tf < playerName/all >")
        return
    }

    string command0 = args[0].tolower()

    array<entity> targets
    switch(command0){
        case "all":
            targets = GetPlayerArray()
            break
        default:
            targets = GetPlayersByNamePrefix(command0)
            break
    }

    if(targets.len() == 0){
        SSOM_ChatServerPrivateMessage(player, "未找到玩家: " + args[0])
        return
    }

    foreach(target in targets){
        if( !IsValid(target) || !IsAlive(target)){
            SSOM_ChatServerPrivateMessage(player, "玩家 " + target.GetPlayerName() + " 跳过降落泰坦")
            continue
        }
        thread SSOM_Titanfall(target)
        SSOM_ChatServerPrivateMessage(player, "已为玩家 " + target.GetPlayerName() + " 降落泰坦")
    }
}

void function SSOM_Titanfall(entity player)
{
    if(player.IsTitan())
        return
        
    if(SpawnPoints_GetTitan().len() > 0)
    {
        CreateTitanForPlayerAndHotdrop(player, GetTitanReplacementPoint(player, false))
    }
}