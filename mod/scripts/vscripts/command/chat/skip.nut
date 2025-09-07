global function ServerChatCommand_Skip_Init

void function ServerChatCommand_Skip_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
    AddServerChatCommandCallback("/skip", ServerChatCommand_Skip)
}

void function ServerChatCommand_Skip(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }
    SetGameState(eGameState.Postmatch)
    SSOM_ChatServerBroadcast("已跳过当前游戏")
}