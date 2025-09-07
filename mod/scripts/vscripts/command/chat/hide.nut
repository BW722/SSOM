global function ServerChatCommand_Hide_Init


void function ServerChatCommand_Hide_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
    AddServerChatCommandCallback("/hide", ServerChatCommand_Hide)
}

void function ServerChatCommand_Hide(entity player, array<string> args)
{
    if(!SSOM_IsPlayerAdmin(player))
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }
    
    array<entity> targets = SSOM_GetTargetPlayers(player, args)
    if(targets.len() == 0)
    {
        SSOM_ChatServerPrivateMessage( player, "未找到玩家: " + args[0] )
        return
    }
    
    int successCount = 0
    foreach(target in targets)
    {
        if(IsValid(target) && IsAlive(target))
        {
            target.kv.VisibilityFlags = 0
            successCount++
        }
    }
    
    if(args.len() > 0 && args[0].tolower() == "all")
        SSOM_ChatServerPrivateMessage(player, "已隐藏所有玩家（共" + successCount + "人）")
    else if(args.len() > 0)
        SSOM_ChatServerPrivateMessage(player, "已隐藏玩家: " + targets[0].GetPlayerName())
    else
        SSOM_ChatServerPrivateMessage(player, "已隐藏自己")
}