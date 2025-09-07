global function ServerChatCommand_Balance_Init

global function SSOM_Balance

void function ServerChatCommand_Balance_Init()
{
    if(IsLobby() || IsMenuLevel())
        return
    AddServerChatCommandCallback("/balance", ServerChatCommand_Balance)
}

void function ServerChatCommand_Balance(entity player, array<string> args)
{
    if( !SSOM_IsPlayerAdmin( player ) )
    {
        SSOM_ChatServerPrivateMessage(player, "你没有管理员权限！！！")
        return
    }

    if(args.len() != 0)
        return
    
    SSOM_Balance()
    SendAnnouncementMessageToAllAlivePlayers( "平衡", "", <85,85,85> , 1, ANNOUNCEMENT_STYLE_RESULTS )
}

/*
void function SSOM_Balance()
{
    foreach( int i, player in GetPlayerArray() )
    {
        if(!IsEven(i))
        {
            SetTeam(player, TEAM_IMC)
        }
        else
        {
            SetTeam(player, TEAM_MILITIA)
        }
    }
}
*/

void function SSOM_Balance()
{
    foreach( int i, player in GetPlayerArray() )
    {
        SetTeam( player, i % 2 ? TEAM_MILITIA : TEAM_IMC )
    }
}