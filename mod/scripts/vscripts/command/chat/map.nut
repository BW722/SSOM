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
    
    string args0 = args[0]
    if( !GetPrivateMatchMaps().contains(args0) )
    {
        SSOM_ChatServerPrivateMessage(player, "地图不存在！！！")
        return
    }
    
    GameRules_ChangeMap( args0, GameRules_GetGameMode() ) 
}