global function ServerChatCommand_Show_Init

void function ServerChatCommand_Show_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
    AddServerChatCommandCallback("/show", ServerChatCommand_Show)
}

void function ServerChatCommand_Show(entity player, array<string> args)
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
        if(target != null && IsAlive(target))
        {
            target.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE
            successCount++
            
            if(target != player)
                SSOM_ChatServerPrivateMessage(target, "你已被管理员显示")
        }
    }
    
    if(args.len() > 0 && args[0].tolower() == "all")
        SSOM_ChatServerPrivateMessage(player, "已显示所有玩家（共" + successCount + "人）")
    else if(args.len() > 0)
        SSOM_ChatServerPrivateMessage(player, "已显示玩家: " + targets[0].GetPlayerName())
    else
        SSOM_ChatServerPrivateMessage(player, "已显示自己")
}