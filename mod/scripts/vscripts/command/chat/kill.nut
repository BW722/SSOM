global function ServerChatCommand_Kill_Init

global function KillAllPlayers


void function ServerChatCommand_Kill_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
    AddServerChatCommandCallback("/kill", ServerChatCommand_Kill )
    AddServerChatCommandCallback("/die", ServerChatCommand_Kill )
}

void function ServerChatCommand_Kill(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if( args.len() != 1 )
    {
        player.Die()
        return
    }

    if(args[0] == "all"){
        foreach(player1 in GetPlayerArray()){
            if ( player1 == null || !IsAlive(player1) )
                continue
            player1.Die()
        }
    }else{
        entity player1 = GetPlayerByNamePrefix(args[0])
        if ( player1 == null || !IsAlive(player1) )
            return
        player1.Die()
    }
}

void function KillAllPlayers()
{
    foreach( player in GetPlayerArray() )
    {
        if(!IsAlive(player))
            continue
        player.Die()
    }
}