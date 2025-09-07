global function ServerChatCommand_Tf_Init

global function SSOM_Titanfall

void function ServerChatCommand_Tf_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
    AddServerChatCommandCallback("/tf", ServerChatCommand_Tf)
}

void function ServerChatCommand_Tf(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if( args.len() != 1 )
        return

    array<entity> subjects = []

    if ( args[0].tolower() == "all" )
    {
        subjects = GetPlayerArray()
    } 
    else
    {
        subjects.append( GetPlayerByNamePrefix(args[0]) )
    }
    foreach(subject in subjects)
    {
        if( subject == null || !IsAlive(subject) )
            continue
        thread SSOM_Titanfall(subject)
    }
}

void function SSOM_Titanfall(entity player)
{
    if(player.IsTitan())
        return
    if ( SpawnPoints_GetTitan().len() > 0 )
    {
        thread CreateTitanForPlayerAndHotdrop( player, GetTitanReplacementPoint( player, false ) )
    }
}