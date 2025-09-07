global function SSOM_Connect_Init


void function SSOM_Connect_Init()
{
    if (IsLobby() || IsMenuLevel())
        return
    AddCallback_OnClientConnecting(OnClientConnecting)
    AddCallback_OnClientConnected(OnClientConnected)
    AddCallback_OnClientDisconnected(OnPlayerDisconnected)
}

void function OnClientConnecting(entity player)
{
    array<entity> players = GetPlayerArray()

    if( !(players.len() == GetMaxPlayers()) )
        return
    
    if( SSOM_IsPlayerAdmin(player) )
    {
        entity randomPlayer = players[RandomInt(players.len())]
        SSOM_KickPlayer( randomPlayer, "" )
    }
}

void function OnClientConnected(entity player)
{
    thread ClientConnected(player)
}

void function OnPlayerDisconnected(entity player)
{
    thread PlayerDisconnected(player)
    /*
    if (!SSOM_IsPlayerAdmin(player))
        return
    
    array<entity> onlineAdmins = SSOM_GetAdminArray()
    int index = onlineAdmins.find(player)

    if (index != -1)
    {
        onlineAdmins.remove(index)
    }
    
    if (onlineAdmins.len() == 0)
    {
        SSOM_SetCheatsEnabledd(false)
    }
    */
}

void function ClientConnected(entity player)
{
    string ref = CallingCard_GetRef(PlayerCallingCard_GetActive(player))
    string playerName = player.GetPlayerName()

    if( SSOM_IsPlayerAdmin(player) )
    {
        wait 2.0
        SendLargeMessageToAllAlivePlayers( playerName, "管理員加入游戲", 5, "rui/callsigns/" + ref )
    }
}

void function PlayerDisconnected(entity player)
{
    string ref = CallingCard_GetRef(PlayerCallingCard_GetActive(player))
    string playerName = player.GetPlayerName()

    if( SSOM_IsPlayerAdmin(player) )
    {
        wait 1.0
        SendLargeMessageToAllAlivePlayers( playerName, "管理員退出游戲", 5, "rui/callsigns/" + ref )
    }
}

int function GetMaxPlayers()
{
    return GetCurrentPlaylistVarInt( "max_players", 8 )
}