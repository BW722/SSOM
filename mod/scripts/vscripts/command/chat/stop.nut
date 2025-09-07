global function ServerChatCommand_Stop_Init


void function ServerChatCommand_Stop_Init()
{
    AddServerChatCommandCallback( "/stop",  ServerChatCommand_Stop )
}

void function ServerChatCommand_Stop(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    foreach(player in GetPlayerArray())
    {
        NSDisconnectPlayer( player, "stop" )
    }

    ServerCommand("quit")
}