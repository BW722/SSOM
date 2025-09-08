global function ServerChatCommand_Map_Init

void function ServerChatCommand_Map_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
    
    AddServerChatCommandCallback("/map", ServerChatCommand_Map)
}

void function ServerChatCommand_Map(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if (args.len() != 1)
        return
    
    string arg0 = args[0]
    if( !GetPrivateMatchMaps().contains(arg0) )
    {
        SSOM_ChatServerPrivateMessage(player, "地图不存在！！！")
        return
    }
    SSOM_ChatServerBroadcast("正在切换地图: " + arg0)
    wait 2.0
    GameRules_ChangeMap( arg0, GameRules_GetGameMode() ) 
}